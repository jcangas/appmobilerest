unit AppMobileREST.JSONUtiils;

interface
uses System.Json, System.Generics.Collections, REST.JSON;

type
  TJSON = class(REST.Json.TJSON)
  private
    class procedure Fill(const Instance: TObject; const Source: TJSONObject);
  public
    class function ToList<T: class,constructor>(const Values: TJSONArray): TObjectList<T>;
    class function ToObjectList<T: class, constructor>(const Values: TJSONArray): TObjectList<T>;overload;
    class function ToObjectList<T: class, constructor>(const AText: string): TObjectList<T>;overload;
  end;

implementation
uses System.RTTI, System.SysUtils, System.StrUtils, System.DateUtils,
  System.IOUtils,
  AppMobileREST.Tools;

{ TJSON }

class procedure TJSON.Fill(const Instance: TObject; const Source: TJSONObject);
var
  Context: TRttiContext;
  RType: TRttiInstanceType;
  RProp: TRttiProperty;
  JsonValue: TJSONValue;
  PropValue: TValue;
begin
  RType := Context.GetType(Instance.ClassType) as TRttiInstanceType;
  for RProp in RType.GetProperties do
  begin
    JsonValue := Source.Values[RProp.Name.ToLower];
    PropValue := TValue.Empty;
    if JsonValue = nil then Continue;
    if JsonValue is TJSONNumber then begin
      if RProp.PropertyType.IsOrdinal or RProp.PropertyType.InheritsFrom(TRttiInt64Type) then
        PropValue := TJSONNumber(JsonValue).AsInt64
      else
        PropValue := TJSONNumber(JsonValue).AsDouble;
    end
    else if JsonValue is TJSONString then begin
      if RProp.PropertyType.Handle = TypeInfo(TDateTime) then
        PropValue := ISO8601ToDate(TJSONString(JsonValue).Value)
      else if RProp.PropertyType.Handle = TypeInfo(TDate) then
        PropValue := StrToDate(TJSONString(JsonValue).Value)
      else if RProp.PropertyType.Handle = TypeInfo(TTime) then
        PropValue := StrToTime(TJSONString(JsonValue).Value)
      else
        PropValue := TJSONString(JsonValue).Value
    end;

    try
      RProp.SetValue(Instance, PropValue);
    except
      Logger.Debug('fail ' + RProp.Name);
    end;
  end;
end;

class function TJSON.ToList<T>(const Values: TJSONArray): TObjectList<T>;
var
  Value: TJSONValue;
  JsonObj: TJSONObject;
  Obj: T;
begin
  Result := TObjectList<T>.Create(True);
  for Value in Values do
  begin
    if not Value.TryGetValue(JsonObj) then Continue;
    Obj := T.Create;
    Result.Add(Obj);
    Fill(Obj, JsonObj);
  end;
end;

class function TJSON.ToObjectList<T>(const Values: TJSONArray): TObjectList<T>;
var
  AObject: T;
  JsonValue: TJSONValue;
  TempList: TObjectList<T>;
begin
  TempList := TObjectList<T>.Create;
  try
    for JsonValue in Values do begin
      if JsonValue is TJSONObject then
        TempList.Add(JsonToObject<T>(TJSONObject(JsonValue)));
    end;
    Result := TempList;
    TempList := nil;
  finally
    TempList.Free;
  end;
end;

class function TJSON.ToObjectList<T>(const AText: string): TObjectList<T>;
var
  JsonArray: TJSONArray;
begin
  JsonArray := nil;
  try
    JsonArray := TJSONObject.ParseJSONValue(AText) as TJSONArray;
    if JsonArray = nil then
      raise Exception.Create('Invalid JSON List');
    Result := ToObjectList<T>(JsonArray);
  finally
    JsonArray.Free;
  end;
end;

end.
