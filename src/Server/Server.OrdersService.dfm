object OrdersService: TOrdersService
  OldCreateOrder = False
  Height = 161
  Width = 295
  object DBConnection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Public\Documents\DataBases\APPMOBILEREST.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=fB')
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object Query: TFDQuery
    Connection = DBConnection
    SQL.Strings = (
      'select * from "orders" where "orders"."id" = :id')
    Left = 168
    Top = 32
    ParamData = <
      item
        Name = 'ID'
        DataType = ftWideString
        ParamType = ptInput
        Value = '1'
      end>
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 56
    Top = 80
  end
end
