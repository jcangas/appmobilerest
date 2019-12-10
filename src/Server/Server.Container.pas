unit Server.Container;

interface

uses
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker,
  Datasnap.DSServer,
  Web.WebFileDispatcher,
  Web.HTTPProd,
  Datasnap.DSAuth,
  Datasnap.DSProxyJavaScript,
  IPPeerServer,
  Datasnap.DSMetadata,
  Datasnap.DSServerMetadata,
  Datasnap.DSClientMetadata,
  Datasnap.DSCommonServer,
  Datasnap.DSHTTP,
  Server.OrderItemsService;

type
  TWebModule1 = class(TWebModule)
    DSRESTWebDispatcher1: TDSRESTWebDispatcher;
    DSServer: TDSServer;
    OrdersServiceFactory: TDSServerClass;
    ServerFunctionInvoker: TPageProducer;
    ReverseString: TPageProducer;
    WebFileDispatcher1: TWebFileDispatcher;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    OrderItemsServiceFactory: TDSServerClass;
    procedure OrdersServiceFactoryGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcher1BeforeDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure OrderItemsServiceFactoryGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSRESTWebDispatcher1ParsingRequest(Sender: TObject;
      const ARequest: string; const ASegments: TStrings;
      var ADSMethodName: string; const AParamValues: TStrings;
      var AHandled: Boolean);
    procedure DSRESTWebDispatcher1ParseRequest(Sender: TObject;
      const ARequest: string; const ASegments: TStrings;
      var ADSMethodName: string; const AParamValues: TStrings);
  private
    { Private declarations }
    FServerFunctionInvokerAction: TWebActionItem;
    function AllowServerFunctionInvoker: Boolean;
    function MapRoute(const ARequest: string; const ASegments: TStrings;
      var ADSMethodName: string; const AParamValues: TStrings): Boolean;
    function Singularize(const Name: string): string;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}

uses
  Server.OrdersService,
  FMX.Types,
  Web.WebReq;

function TWebModule1.Singularize(const Name: string): string;
begin
  if Name.EndsWith('s') then
    Result := Copy(Name, 1, Length(Name) - 1)
  else
    Result := Name;
end;

function TWebModule1.MapRoute(const ARequest: string; const ASegments: TStrings;
  var ADSMethodName: string; const AParamValues: TStrings): Boolean;
var
  Segment: string;
  AClassName: string;
  AMethodName: string;
  idx: Integer;
begin
  AMethodName := '';
  for idx := 0 to ASegments.Count - 1 do
  begin
    if (idx mod 2) = 0 then
    begin
      Segment := ASegments[idx];
      // nos quedamos el ultimo resource mencionado
      AClassName := 'T' + Segment + 'Service';
      if idx > 1 then // concatenamos los anteriores como nombre de metodo
        AMethodName := AMethodName + Singularize(ASegments[idx - 2]);
    end
    else
      AParamValues.Add(ASegments[idx])
  end;
  if ASegments.Count > 2 then
    AMethodName := 'By' + AMethodName;

  if SameText(ARequest, 'GET') then
  begin
    if (ASegments.Count mod 2) = 1 then
      AMethodName := 'GetAll' + AMethodName
    else
      AMethodName := 'Get' + AMethodName;
  end
  else if SameText(ARequest, 'PUT') then
    AMethodName := 'Update' + AMethodName
  else if SameText(ARequest, 'POST') then
    AMethodName := 'Insert' + AMethodName
  else if SameText(ARequest, 'DELETE') then
    AMethodName := 'Delete' + AMethodName;

  Result := not AMethodName.IsEmpty;

  if Result then
    ADSMethodName := Format('%s.%s', [AClassName, AMethodName]);
end;

procedure TWebModule1.DSRESTWebDispatcher1ParseRequest(Sender: TObject;
  const ARequest: string; const ASegments: TStrings; var ADSMethodName: string;
  const AParamValues: TStrings);
begin
  //
  ASegments.Delimiter := '/';
  Log.d('[%s] %s', [ARequest, ASegments.DelimitedText]);
end;

procedure TWebModule1.DSRESTWebDispatcher1ParsingRequest(Sender: TObject;
  const ARequest: string; const ASegments: TStrings; var ADSMethodName: string;
  const AParamValues: TStrings; var AHandled: Boolean);
begin
  AHandled := MapRoute(ARequest, ASegments, ADSMethodName, AParamValues);
end;

procedure TWebModule1.OrderItemsServiceFactoryGetClass(DSServerClass
  : TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TOrderItemsService;
end;

procedure TWebModule1.OrdersServiceFactoryGetClass(DSServerClass
  : TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := TOrdersService;
end;

procedure TWebModule1.ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'urlpath') then
    ReplaceText := string(Request.InternalScriptName)
  else if SameText(TagString, 'port') then
    ReplaceText := IntToStr(Request.ServerPort)
  else if SameText(TagString, 'host') then
    ReplaceText := string(Request.Host)
  else if SameText(TagString, 'classname') then
    ReplaceText := TOrdersService.ClassName
  else if SameText(TagString, 'loginrequired') then
    if DSRESTWebDispatcher1.AuthenticationManager <> nil then
      ReplaceText := 'true'
    else
      ReplaceText := 'false'
  else if SameText(TagString, 'serverfunctionsjs') then
    ReplaceText := string(Request.InternalScriptName) + '/js/serverfunctions.js'
  else if SameText(TagString, 'servertime') then
    ReplaceText := DateTimeToStr(Now)
  else if SameText(TagString, 'serverfunctioninvoker') then
    if AllowServerFunctionInvoker then
      ReplaceText := '<div><a href="' + string(Request.InternalScriptName) +
        '/ServerFunctionInvoker" target="_blank">Server Functions</a></div>'
    else
      ReplaceText := '';
end;

procedure TWebModule1.WebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if (Request.InternalPathInfo = '') or (Request.InternalPathInfo = '/') then
    Response.Content := ReverseString.Content
  else
    Response.SendRedirect(Request.InternalScriptName + '/');
end;

procedure TWebModule1.WebModuleBeforeDispatch(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if FServerFunctionInvokerAction <> nil then
    FServerFunctionInvokerAction.Enabled := AllowServerFunctionInvoker;
end;

function TWebModule1.AllowServerFunctionInvoker: Boolean;
begin
  Result := (Request.RemoteAddr = '127.0.0.1') or
    (Request.RemoteAddr = '0:0:0:0:0:0:0:1') or (Request.RemoteAddr = '::1');
end;

procedure TWebModule1.WebFileDispatcher1BeforeDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
  Handled := False;
  if SameFileName(ExtractFileName(AFileName), 'serverfunctions.js') then
    if not FileExists(AFileName) or
      (FileAge(AFileName, D1) and FileAge(WebApplicationFileName, D2) and
      (D1 < D2)) then
    begin
      DSProxyGenerator1.TargetDirectory := ExtractFilePath(AFileName);
      DSProxyGenerator1.TargetUnitName := ExtractFileName(AFileName);
      DSProxyGenerator1.Write;
    end;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  FServerFunctionInvokerAction := ActionByName('ServerFunctionInvokerAction');
end;

initialization

finalization

Web.WebReq.FreeWebModules;

end.
