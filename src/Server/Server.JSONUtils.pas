unit Server.JSONUtils;

interface

uses
  System.JSON,
  Data.DB;

type
  TJSON = class
  private
  public
    class function ReadRow(const ADataset: TDataset): TJSONObject; static;
    class function ReadAllRows(const ADataset: TDataset): TJSONArray;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{ TJSON }

class function TJSON.ReadRow(const ADataset: TDataset): TJSONObject;
var
  Col: Integer;
  Data: TJSONValue;
  Field: TField;
begin
  Result := TJSONObject.Create;
  for Col := 0 to ADataset.FieldCount - 1 do
  begin
    Field := ADataset.Fields[Col];
    if Field.IsNull then
      Data := TJSONNull.Create
    else
      case Field.DataType of
        ftSmallint, ftInteger, ftWord, ftLargeint, ftLongWord, ftShortint,
          ftByte, ftAutoInc:
          Data := TJSONNumber.Create(Field.AsLargeInt);

        ftBCD, ftCurrency, ftFMTBcd, ftExtended, ftSingle:
          Data := TJSONNumber.Create(Field.AsFloat);

        ftDateTime, ftTimeStamp:
          Data := TJSONString.Create(DateToISO8601(Field.AsDateTime));
        ftTime:
          Data := TJSONString.Create(FormatDateTime('hh:nn:ss.zzz',
            Field.AsDateTime));
        ftDate:
          Data := TJSONString.Create(FormatDateTime('yyyy-mm-dd',
            Field.AsDateTime));

        ftBoolean:
          if Field.AsBoolean then
            Data := TJSONTrue.Create
          else
            Data := TJSONFalse.Create;
      else
        Data := TJSONString.Create(Field.AsString);
      end;

    Result.AddPair(Field.FieldName, Data);
  end;

end;

class function TJSON.ReadAllRows(const ADataset: TDataset): TJSONArray;
begin
  Result := TJSONArray.Create;
  ADataset.First;
  while not ADataset.Eof do
  begin
    Result.Add(ReadRow(ADataset));
    ADataset.Next;
  end;
end;

end.
