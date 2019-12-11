object OrdersProxy: TOrdersProxy
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 261
  Width = 212
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    Params = <>
    HandleRedirects = True
    Left = 40
    Top = 24
  end
  object OrdersService: TRESTRequest
    Client = RESTClient
    Params = <>
    Resource = 'Orders'
    SynchronizedEvents = False
    Left = 120
    Top = 32
  end
  object OrdersResponse: TRESTResponse
    Left = 112
    Top = 184
  end
end
