unit AppMobileREST.OrdersProxy;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Json,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Client,
  AppMobileREST.Models,
  AppMobileREST.JSONUtiils,
  IPPeerClient, REST.Types;

type
  TOrdersProxy = class(TDataModule)
    RESTClient: TRESTClient;
    OrdersService: TRESTRequest;
    OrdersResponse: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
    procedure SetupDataConnection;
  private
    function GetResponseResult(const Request: TRestRequest): TJSONArray;
  public
    function GetAll: TObjectList<TOrder>;
    function GetOrderItems(const Order: TOrder): TObjectList<TOrderItem>;
  end;

var
  OrdersProxy: TOrdersProxy;

implementation
uses System.IOUtils, AppMobileREST.Tools;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TOrdersProxy.DataModuleCreate(Sender: TObject);
begin
  SetupDataConnection;
end;

procedure TOrdersProxy.SetupDataConnection;
begin
  RESTClient.BaseURL := 'http://localhost:8080/api';
end;

function TOrdersProxy.GetResponseResult(const Request: TRestRequest) : TJSONArray;
var
  JsonResponse: TJSONObject;
begin
  if not Request.Response.JSONValue.TryGetValue(JsonResponse) then
    raise Exception.Create('Error Message');
  JsonResponse.Values['result'].TryGetValue(Result);
end;

function TOrdersProxy.GetOrderItems(const Order: TOrder): TObjectList<TOrderItem>;
const
  HttpVerb = rmGET;
  MethodUrl = '%d/OrderItems';
var
  jsonList: TJSONArray;
begin
  if Order = nil then begin
    Result := TObjectList<TOrderItem>.Create;
    Exit;
  end;
  OrdersService.Method := HttpVerb;
  OrdersService.ResourceSuffix := Format(MethodUrl, [Order.ID]);
  OrdersService.Execute;
  GetResponseResult(OrdersService).Items[0].TryGetValue(jsonList);
  Result := TJSON.ToObjectList<TOrderItem>(jsonList);
end;

function TOrdersProxy.GetAll: TObjectList<TOrder>;
const
  HttpVerb = rmGET;
  MethodUrl = '/';
var
  jsonList: TJSONArray;
begin
  OrdersService.Method := HttpVerb;
  OrdersService.ResourceSuffix := MethodUrl;
  OrdersService.Execute;
  GetResponseResult(OrdersService).Items[0].TryGetValue(jsonList);
  Result := TJSON.ToList<TOrder>(jsonList);
end;

end.
