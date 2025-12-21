unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, registry, DateUtils;

type
  TForm5 = class(TForm)
    Panel_Lateral: TPanel;
    IMG_LOGO: TImage;
    BTN_OK: TButton;
    IMG_TOPO: TImage;
    Label_Descricao: TLabel;
    Label_VersaoWindows: TLabel;
    Linha: TBevel;
    procedure BTN_OKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Mensagens,Unit1;

//----------------------------------------------------------

{PEGAR A VERSÃO DO WINDOWS}
function GetWindowsVersion: string;
var 
VerInfo: TOsversionInfo; 
PlatformId, VersionNumber: string; 
Reg: TRegistry;
begin 
VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo); 
GetVersionEx(VerInfo); 
// Detect platform 
Reg := TRegistry.Create; 
Reg.RootKey := HKEY_LOCAL_MACHINE; 
case VerInfo.dwPlatformId of 
VER_PLATFORM_WIN32s: 
begin 
// Registry (Huh? What registry?) 
PlatformId := 'Windows 3.1';
end;
VER_PLATFORM_WIN32_WINDOWS: 
begin 
// Registry 
Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
PlatformId := Reg.ReadString('ProductName');
VersionNumber := Reg.ReadString('VersionNumber');
end; 
VER_PLATFORM_WIN32_NT: 
begin 
// Registry 
Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False);
PlatformId := Reg.ReadString('ProductName');
VersionNumber := Reg.ReadString('CurrentVersion');
end; 
end; 
Reg.Free; 
Result := PlatformId + ' (version ' + VersionNumber + ')';
end;
//----------------------------------------------------------

{$R *.dfm}

procedure TForm5.BTN_OKClick(Sender: TObject);
begin
Close;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form5.Release;
Form5:=Nil;
//Action := caFree;

end;

procedure TForm5.FormActivate(Sender: TObject);
begin
Form5.Caption:=UpperCase(Mensagens_Pequenas(9)+' '+Application.Title+'...');
Label_Descricao.Caption:=Mensagens_Pequenas(11)+' '+VersaoApp_Global
                         +#13+
                         'JMBA Softwares, 2014-'+IntToStr(YearOf(Date));
Label_VersaoWindows.Caption:=Copy(GetWindowsVersion,0,Pos('(',GetWindowsVersion)-1);
end;

end.
