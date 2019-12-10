program AppMobileRESTApi;

uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Server.MainForm in '..\Server\Server.MainForm.pas' {Form1},
  Server.Container in '..\Server\Server.Container.pas' {WebModule1: TWebModule},
  Server.OrdersService in '..\Server\Server.OrdersService.pas' {OrdersService: TDataModule},
  Server.JSONUtils in '..\Server\Server.JSONUtils.pas',
  Server.OrderItemsService in '..\Server\Server.OrderItemsService.pas' {OrderItemsService: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
