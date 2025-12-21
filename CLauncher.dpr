program CLauncher;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Genericas in 'Genericas.pas',
  Especificas in 'Especificas.pas',
  Mensagens in 'Mensagens.pas',
  About in 'About.pas' {Form5},
  WinINet,
  ShellAPI,
  SysUtils,
  Windows,
  Unit3 in 'Unit3.pas' {splash_screen};

{$R *.res}

var
App_Aberto:HWND;

//-------------------------------------------------------
const
//---------------------
Versao_App = '1.4';
//---------------------

//-------------------------------------------------------
UrlHospedagem = '.blogspot.com.br';
URL_Blog      = 'http://www.im-creator.com/free/phobos/jmba/console';
URL_Facebook  = 'https://www.instagram.com/phobos.arj';
URL_PayPal    = 'https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=KTCCWNMMP7E6W&lc'+
                                                         '=BR&item_name=Console%20Launcher&item_number'+
                                                         '=01&currency_code'+
                                                         '=BRL&bn'+
                                                         '=PP%2dDonationsBF%3apaypal%2dicon%2epng%3aNonHosted';
//-------------------------------------------------------
var
UrlMD5,Diretorio_Raiz,Nome_Executavel:String;
begin
Nome_Executavel:=Copy(ExtractFileName(Application.ExeName),0,Length(ExtractFileName(Application.ExeName))-Length(ExtractFileExt (Application.ExeName)));
Diretorio_Raiz :=Copy(Application.ExeName                 ,0,Length(Application.ExeName)                 -Length(ExtractFileName(Application.ExeName)));
UrlMD5:=LowerCase(Nome_Executavel+Versao_App);

{TRANSFERE AS VARIÁVEIS PARA O FORM1}
//-------------------------------------------------------------------------------------------
Form1.VarGlobais(Nome_Executavel,Versao_App,Diretorio_Raiz,URL_Facebook,URL_Blog,URL_PayPal);
//-------------------------------------------------------------------------------------------

//------------------------------------------------
Application.Initialize;
App_Aberto:=FindWindow(Nil,PChar('CONSOLE LAUNCHER '+Versao_App));

 if App_Aberto = 0 then
 begin
 Application.Title := 'CONSOLE LAUNCHER';
 Splash_Screen:=Tsplash_screen.Create(Application);
 Splash_Screen.Show;
 Splash_Screen.Update;
 Sleep(2000);

   //----------------------------------------------------------------
   {if InternetCheckConnection('http://www.google.com/',  1,  0)  then
   begin
    if NovoUpdate(UrlMD5+UrlHospedagem) = True then
    begin
    ShellExecute(0,Nil,PChar(URL_Blog),Nil,Nil,0);
    Application.Terminate;
    end
    else
    begin
    Application.CreateForm(TForm1, Form1);
    Splash_Screen.Close;
    Application.Run;
    end;
   end
   else
   begin     }
   Application.CreateForm(TForm1, Form1);
   Splash_Screen.Close;
   Application.Run;
  // end;
   //----------------------------------------------------------------

 end
 else
 MessageBox(Application.Handle,pchar('Uma instância do CONSOLE LAUNCHER já está em execução!')
                              ,pchar('CONSOLE LAUNCHER '+Versao_App),MB_ICONINFORMATION+MB_OK);

end.
