unit AppMobileREST.Models;

interface

type
  TObjIdentity = Int64;
  TUpdLockCtl = Int64;

  TEntity = class
  private
    FLockId: TUpdLockCtl;
    FUpdated_at: TDatetime;
    FCreated_at: TDatetime;
    FID: TObjIdentity;
  public
    property ID: TObjIdentity read FID write FID;
    // campo de control para bloqueo optimista
    property LockId: TUpdLockCtl read FLockId write FLockId;
    property Created_at: TDatetime read FCreated_at write FCreated_at;
    property Updated_at: TDatetime read FUpdated_at write FUpdated_at;
  end;

  TOrder = class(TEntity)
  private
    FTotal: Currency;
    FCompany_id: TObjIdentity;
    FNote: string;
    FStatus: Integer;
    FNumber: string;
    FReference: string;
  public
    property Company_id: TObjIdentity read FCompany_id write FCompany_id;
    property Status: Integer read FStatus write FStatus;
    property Number: string read FNumber write FNumber;
    property Reference: string read FReference write FReference;
    property Total:	Currency read FTotal write FTotal;
    property Note:	string read FNote write FNote;
  end;

  TOrderItem = class(TEntity)
  private
    FProduct_id: TObjIdentity;
    FPrice: Currency;
    FTotal: Currency;
    FOrder_id: TObjIdentity;
    FQuantity: Double;
  public
	  property Order_id: TObjIdentity read FOrder_id write FOrder_id;
	  property Product_id: TObjIdentity read FProduct_id write FProduct_id;
	  property Quantity: Double read FQuantity write FQuantity;
	  property Price: Currency read FPrice write FPrice;
	  property Total: Currency read FTotal write FTotal;
  end;

implementation

end.
