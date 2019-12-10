object OrderItemsService: TOrderItemsService
  OldCreateOrder = False
  Height = 150
  Width = 252
  object Query: TFDQuery
    Connection = DBConnection
    SQL.Strings = (
      '')
    Left = 168
    Top = 32
  end
  object DBConnection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Public\Documents\DataBases\APPMOBILEREST.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=fB')
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 56
    Top = 80
  end
end
