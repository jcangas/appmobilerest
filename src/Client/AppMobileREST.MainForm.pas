unit AppMobileREST.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.Components, Data.Bind.DBScope, FMX.ListView, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  FMX.Edit, FMX.Grid.Style, Fmx.Bind.Grid, Data.Bind.Grid, FMX.ScrollBox,
  FMX.Grid, Data.Bind.GenData, Fmx.Bind.GenData, Data.Bind.ObjectScope,
  AppMobileREST.Models;

type
  TMainForm = class(TForm)
    ActionList: TActionList;
    PreviousTabAction1: TPreviousTabAction;
    TitleAction: TControlAction;
    NextTabAction1: TNextTabAction;
    TopToolBar: TToolBar;
    btnBack: TSpeedButton;
    ToolBarLabel: TLabel;
    btnNext: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BottomToolBar: TToolBar;
    BindingsList: TBindingsList;
    NumberCtl: TEdit;
    ReferenceCtl: TEdit;
    TotalCtl: TEdit;
    StringGrid1: TStringGrid;
    ListView1: TListView;
    LinkListControlToField1: TLinkListControlToField;
    OrdersBindSource: TPrototypeBindSource;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    OrderItemsBindSource: TPrototypeBindSource;
    LinkGridToDataSource__OrderItemsBindSource: TLinkGridToDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure FormCreate(Sender: TObject);
    procedure TitleActionUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure OrdersBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure OrderItemsBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
  private
    function GetCurrentOrder: TOrder;
    procedure AfterScrollOrders(ABindSourceAdapter: TBindSourceAdapter);
  public
    property CurrentOrder: TOrder read GetCurrentOrder;
  end;

var
  MainForm: TMainForm;

implementation
uses System.JSON, AppMobileREST.OrdersProxy;

{$R *.fmx}

procedure TMainForm.TitleActionUpdate(Sender: TObject);
begin
  if Sender is TCustomAction then
  begin
    if TabControl1.ActiveTab <> nil then
      TCustomAction(Sender).Text := TabControl1.ActiveTab.Text
    else
      TCustomAction(Sender).Text := '';
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.First(TTabTransition.Slide);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (TabControl1.TabIndex <> 0) then
  begin
    TabControl1.First;
    Key := 0;
  end;
end;

function TMainForm.GetCurrentOrder: TOrder;
begin
  Result := OrdersBindSource.InternalAdapter.Current as TOrder;
end;

procedure TMainForm.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  OrderItemsBindSource.Active := False;
  OrderItemsBindSource.Active := True;
  NextTabAction1.Execute
end;

procedure TMainForm.AfterScrollOrders(ABindSourceAdapter: TBindSourceAdapter);
var
  Adapter: TListBindSourceAdapter<TOrderItem>;
begin
  Adapter := (OrderItemsBindSource.InternalAdapter as TListBindSourceAdapter<TOrderItem>);
  Adapter.SetList(OrdersProxy.GetOrderItems(CurrentOrder));
end;

procedure TMainForm.OrdersBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TListBindSourceAdapter<TOrder>.Create(Self, OrdersProxy.GetAll, True);
  ABindSourceAdapter.AfterScroll := AfterScrollOrders;
end;

procedure TMainForm.OrderItemsBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TListBindSourceAdapter<TOrderItem>.Create(Self, OrdersProxy.GetOrderItems(CurrentOrder), True);
end;

end.
