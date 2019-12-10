unit Server.OrderItemsService;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.FMXUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  System.JSON, FireDAC.Comp.UI;

type
{$METHODINFO ON}
  TOrderItemsService = class(TDataModule)
    Query: TFDQuery;
    DBConnection: TFDConnection;

    FDGUIxWaitCursor1: TFDGUIxWaitCursor;  private
  public
    function GetAllByOrder(const OrderID: Int64): TJSONValue;
    function GetByOrder(const OrderID, OrderItemID: Int64): TJSONValue;
  end;
{$METHODINFO OFF}

implementation

uses
  Server.JSONUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TOrderItemsService }

function TOrderItemsService.GetAllByOrder(const OrderID: Int64): TJSONValue;
const
  SQL = 'select * from "order_items" where "order_id" = :ID';
begin
  Query.Close;
  Query.Open(SQL, [OrderID]);
  Result := TJSON.ReadAllRows(Query);
end;

function TOrderItemsService.GetByOrder(const OrderID: Int64;
  const OrderItemID: Int64): TJSONValue;
const
  SQL = 'select * from "order_items" where "order_id" = :OrderID and  "id" = :OrdeOrderItemIDrID';
begin
  Query.Close;
  Query.Open(SQL, [OrderID, OrderItemID]);
  Result := TJSON.ReadRow(Query);
end;

end.
