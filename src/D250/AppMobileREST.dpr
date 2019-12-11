program AppMobileREST;

uses
  System.StartUpCopy,
  FMX.Forms,
  AppMobileREST.MainForm in '..\Client\AppMobileREST.MainForm.pas' {MainForm},
  AppMobileREST.Tools in '..\Client\AppMobileREST.Tools.pas',
  AppMobileREST.OrdersProxy in '..\Client\AppMobileREST.OrdersProxy.pas' {OrdersProxy: TDataModule},
  AppMobileREST.JSONUtiils in '..\Client\AppMobileREST.JSONUtiils.pas',
  AppMobileREST.Models in '..\Client\AppMobileREST.Models.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Debug('Starting AppMobileRest' );
  Application.CreateForm(TOrdersProxy, OrdersProxy);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
