unit Server.OrdersService;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Json,
  Datasnap.DSServer,
  Datasnap.DSAuth,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI;

type
{$METHODINFO ON}
  TOrdersService = class(TDataModule)
    DBConnection: TFDConnection;
    Query: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DBConnectionBeforeConnect(Sender: TObject);
  private
  public
    function Get(const ID: Integer): TJSONValue;
    function Delete(const ID: Integer): TJSONValue;
    function Update(const Value: TJSONObject): TJSONValue;
    function GetAll: TJSONValue;
    function GetOrderItems(const ID: Integer): TJSONValue;
  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  System.Generics.Collections,
  System.StrUtils,
  Server.JSONUtils,
  REST.Json,
  Server.OrderItemsService;

{%CLASSGROUP 'FMX.Controls.TControl'}

function TOrdersService.GetAll: TJSONValue;
const
  SQL = 'select * from "orders"';
begin
  Query.Close;
  Query.Open(SQL);
  Result := Server.JSONUtils.TJSON.ReadAllRows(Query);
end;

function TOrdersService.Get(const ID: Integer): TJSONValue;
const
  SQL = 'select * from "orders" where "orders"."id" = :id';
begin
  Query.Close;
  Query.Open(SQL, [ID]);
  Result := Server.JSONUtils.TJSON.ReadRow(Query);
end;

procedure TOrdersService.DBConnectionBeforeConnect(Sender: TObject);
begin
 // codigo para configurar la conexion a BD antes de abrir
end;

function TOrdersService.Delete(const ID: Integer): TJSONValue;
begin
  // To Do
  Result := nil;
end;

function TOrdersService.Update(const Value: TJSONObject): TJSONValue;
const
  SQL = 'update "orders" set ';
  SQLWehre = 'where "orders"."id" = :id';
var
  Pair: TJSONPair;
  ColName: string;
begin
  Query.Close;
  Query.SQL.Text := SQL;

  // la idea básaica es recoger los params del Sql update desde el objeto json
  for Pair in Value do
  begin
    ColName := QuotedStr(Pair.JsonString.Value);
    Query.SQL.Add(Format('%s = :%s', [ColName, ColName]));
    // aqui posiblmente deberemos comprobar tipos de columnas
    Query.Params.ParamByName(ColName).AsString := Pair.JsonValue.Value;
  end;
  Result := TJSONBool.Create(Query.ExecSQL(True) = 1);
end;

//ruta segun DS de fabrica /api/TOrdersService/GetOrderItems/2
//ruta REST estandar/api/orders/2/items/
function TOrdersService.GetOrderItems(const ID: Integer): TJSONValue;
var
  ItemsService: TOrderItemsService;
begin
  ItemsService := TOrderItemsService.Create(Self);
  try
    Result := ItemsService.GetAllByOrder(ID);
  finally
    ItemsService.Free;
  end;

end;

end.
