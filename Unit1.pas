unit Unit1;

interface

uses
  Windows,  Messages, SysUtils, Variants, Classes,     Graphics, Controls, Forms,
  Dialogs,  shellapi, StdCtrls, ComCtrls, FileCtrl,    Buttons,  RXCtrls,
  CheckLst, {TLHelp32,} ExtCtrls, pngimage, abfControls, Menus,    RxGrdCpt, StrUtils,
  AppEvent, Registry, pngextra, ImgList, abfComponents, ExtDlgs, OleCtrls,
  SHDocVw{, MMSystem};

//  procedure Listar_Titulos(id: Integer);

//shellapi - Executar Executáveis no Windows
//TLHelp32 - Encerrar Processo Windows
//StrUtils - Executar o AnsiIndexStr.
//Registry - Criar Variável do Tipo TRegistry.

type
PRecInfo=^TRecInfo;
Trecinfo=record
prev:PRecInfo;
fpathname:string;
srchrec:Tsearchrec;
end;

type
//------------------------------------
Campos = Array[1..14] of String;
//------------------------------------

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    Edit_Pesquisa: TabfEdit;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    PopUp_DiretorioROM: TMenuItem;
    Panel_Status: TPanel;
    PopUp_ExecutarROM: TMenuItem;
    PopUp_BIOS: TMenuItem;
    N1: TMenuItem;
    PopUp_MemoryCard: TMenuItem;
    Image1: TImage;
    PopUp_ConfigurarControles: TMenuItem;
    Panel_Consoles: TPanel;
    IMG_SNES: TImage;
    IMG_NES: TImage;
    IMG_MASTER: TImage;
    IMG_MEGA: TImage;
    IMG_N64: TImage;
    IMG_SEGACD: TImage;
    IMG_PS1: TImage;
    Bevel1: TBevel;
    PopUp_RenomearROM: TMenuItem;
    abfFolderMonitor1: TabfFolderMonitor;
    Menu_Emuladores: TMenuItem;
    Menu_Sobre: TMenuItem;
    Panel2: TPanel;
    img_drive: TabfImage;
    IMG_STATUS: TImage;
    Edit1: TEdit;
    Lista_Imagens: TImageList;
    Menu_Informacoes: TMenuItem;
    SubMenu_PayPal: TMenuItem;
    SubMenu_Facebook: TMenuItem;
    SubMenu_Blog: TMenuItem;
    N2: TMenuItem;
    SubMenu_Sites: TMenuItem;
    coolrom: TMenuItem;
    romhustler: TMenuItem;
    FREEROMScom1: TMenuItem;
    BTN_EXTRAIR: TPNGButton;
    BTN_CONFIG: TPNGButton;
    BTN_TV: TPNGButton;
    BTN_JOYSTICK: TPNGButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    img_logo: TImage;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit_PesquisaChange(Sender: TObject);
    procedure PopUp_DiretorioROMClick(Sender: TObject);
    procedure img_nokClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure PopUp_ExecutarROMClick(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopUp_BIOSClick(Sender: TObject);
    procedure PopUp_MemoryCardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopUp_ConfigurarControlesClick(Sender: TObject);
    procedure Edit_PesquisaExit(Sender: TObject);
    procedure PopUp_RenomearROMClick(Sender: TObject);
    procedure abfFolderMonitor1Change;
    procedure Menu_EmuladoresClick(Sender: TObject);
    procedure Edit_PesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_SobreClick(Sender: TObject);
    procedure img_driveDblClick(Sender: TObject);
    procedure img_driveMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure IMG_STATUSClick(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure SubMenu_FacebookClick(Sender: TObject);
    procedure SubMenu_BlogClick(Sender: TObject);
    procedure SubMenu_PayPalClick(Sender: TObject);
    procedure coolromClick(Sender: TObject);
    procedure romhustlerClick(Sender: TObject);
    procedure FREEROMScom1Click(Sender: TObject);
    procedure BTN_EXTRAIRClick(Sender: TObject);
    procedure BTN_CONFIGClick(Sender: TObject);
    procedure BTN_TVClick(Sender: TObject);
    procedure BTN_JOYSTICKClick(Sender: TObject);


  private
  { Private declarations }
  //--------------------------------------------------------
  // SUBSTITUIR FUNCIONALIDADE DE TECLAS - 01/04
  //--------------------------------------------------------
  procedure WMHotkey(var Msg: TWMHotkey); message WM_HOTKEY;
  //--------------------------------------------------------
  public
  { Public declarations }

  procedure VarGlobais(Nome,Versao,Diretorio_Raiz,Facebook,Blog,PayPal:String);
  //--------------------------------------------------
 // function Listar_Titulos:Boolean;
  function Salvar_Config:Boolean;
  function Carregar_Emulador(rom:String):Boolean;
  //--------------------------------------------------
  function Eventos_Lista(key: Word):Word;
  //--------------------------------------------------
  {USADO EM EVENTOS ONCLICK NA CRIAÇÃO DINÂMICA}
  procedure Executa_Item_Emuladores(Sender: TObject);
  procedure Deleta_Config_Emuladores(Sender: TObject);
  procedure Listagem_Nova(Sender: TObject);
  //--------------------------------------------------
  procedure Menu_Emuladores_Clicar(Sender:TObject);
  end;

var
  Form1: TForm1;
  VarMsgGeral:String;
  PID_Emulador:Cardinal;

  id_console,id_console_joy,config_reg_n64: Integer;
  arquivo_ini_joy:String;
  arquivo_ini_fisico,Vetor_Listagem_Rom:TStringList;

  NomeExe_Global,VersaoApp_Global,Diretorio_Global,URL_Facebook_Global,URL_Blog_Global,URL_PayPal_Global:String;
  Erro_Salvar_Config,TV_On_Off:Boolean;

const

Array_Consoles: Array[1..8] of Campos =                                                                                                                                                                            {Delimitador ';'}
   {1} {2}              {3}                                   {4}     {5}         {6}                                {7}               {8}                                 {9}        {10} {11}                    {12}                         {13}                          {14}
( ('1','Mega Drive'    ,'Consoles\Fusion\Roms\Mega Drive\'   ,'*.smd','116'+'119','Consoles\Fusion\Fusion.exe'      ,'C15151'+'FFA9A9','C15151'+'EFEFEF'+'DE0000'+'000000','Cartucho','16','Fusion.ini'           ,''                          ,'KegaClass'                   ,'Fusion 3.64'          ),
  ('2','Super Nintendo','Consoles\Snes\Roms\'                ,'*.smc','117'+'118','Consoles\Snes\snes9x.exe'        ,'9890D6'+'E4E0FF','9890D6'+'EFEFEF'+'FFFFFF'+'1603A7','Cartucho','16','snes9x.conf'          ,'d3dx9_38.dll;d3dx9_42.dll;','Snes9X: WndClass'            ,'Snes9X 1.60'          ),
  ('3','Nintendo'      ,'Consoles\Nes\Roms\'                 ,'*.nes','117'+'118','Consoles\Nes\nestopia.exe'       ,'A3A2A2'+'DB3131','A3A2A2'+'EFEFEF'+'FFFFFF'+'5F5E5E','Cartucho','8' ,'nestopia.xml'         ,''                          ,'Nestopia'                    ,'Nestopia 1.40'        ),
  ('4','Master System' ,'Consoles\Fusion\Roms\Master System\','*.sms','116'+'119','Consoles\Fusion\Fusion.exe'      ,'6A6A6A'+'D75252','D75252'+'EFEFEF'+'FFFFFF'+'601515','Cartucho','8' ,'Fusion.ini'           ,''                          ,'KegaClass'                   ,'Fusion 3.64'          ),
  ('5','Sega CD'       ,'Consoles\Fusion\Roms\Sega CD\'      ,'*.iso','116'+'119','Consoles\Fusion\Fusion.exe'      ,'5F5E5E'+'BEBDBD','5F5E5E'+'BEBDBD'+'FFFFFF'+'000000','CD'      ,'16','Fusion.ini'           ,''                          ,'KegaClass'                   ,'Fusion 3.64'          ),
  ('6','Playstation'   ,'Consoles\pSX\cdimages\'             ,'*.bin','117'+'112','Consoles\pSX\psxfin.exe'         ,'5F5E5E'+'A3A2A2','9F9D9D'+'EFEFEF'+'838CFC'+'5F5E5E','CD'      ,'32','psx.ini'              ,'d3dx9_26.dll;'             ,'pSX'                         ,'pSX 1.13'             ),
  ('7','Nintendo 64'   ,'Consoles\Project64\Roms\'           ,'*.z64','116'+'118','Consoles\Project64\Project64.exe','E0D923'+'A3A2A2','5F5E5E'+'EFEFEF'+'E0D923'+'000000','Cartucho','64','Config\Project64.cfg' ,''                          ,'Project64 3.0.1.5664-2df3434','Project64 3.0.1.5664' ),
  ('8','ATARI'         ,'Consoles\Stella\Roms\'              ,'*.a26','116'+'118','Consoles\Stella\Stella.exe'      ,'C9AF7C'+'A3A2A2','5F5E5E'+'EFEFEF'+'E0D923'+'000000','Cartucho','8' ,'stella.sqlite3'       ,''                          ,'SDL_app'                     ,'Stella 7.0' )
);

{TECLAS DE SAVESTATE E LOADSTATE}
SaveState_Global = 117; //F6
LoadState_Global = 118; //F7 {NO PS1 SO FUNCIONA O LOADSTATE}
{
SAVE   LOAD
 F6  e  F7  - Super Nintendo
 F6  e  F7  - Nintendo
 F5  e  F8  - Mega Drive, Master System, Sega CD
 F6  e  F1  - Playstation
 F5  e  F7  - Nintendo 64
}

{
 1- NÚMERO
 2- NOME DO CONSOLE
 3- CAMINHO DO ROM
 4- EXTENSAO ROM
 5- SAVESTATE/LOADSTATE
 6- CAMINHO DO EXECUTAVEL DO EMULADOR
 7- COR
 8- COR TABELA LISTAGEM
 9- TIPO DE MIDIA
10- BITS
11- ARQUIVO INI
12- DLL
13- CLASSE DO EMULADOR
14- NOME E VERSÃO DO EMULADOR
}

//------------------------------------------------------------
{NINTENDO 64 - REGISTRO DO WINDOWS}
//------------------------------------------------------------
//driver_video_n64   = 'JaboSoft\Project64 DLL\Direct3D8 1.6.1';

//-----------------------------------
//config_default_n64 = 134217732;
//-----------------------------------
// Use legacy pixel pipeline

//-----------------------------------
//config_alphablending_n64 = 201326596;
//-----------------------------------
// Use legacy pixel pipeline
// Force alpha blending
//-----------------------------------

//------------------------------------------------------------

implementation

uses Mensagens,Genericas,Especificas,Unit2, About;

procedure TForm1.VarGlobais(Nome,Versao,Diretorio_Raiz,Facebook,Blog,PayPal:String);
begin
     NomeExe_Global:=Nome;
   VersaoApp_Global:=Versao;
   Diretorio_Global:=Diretorio_Raiz;
    URL_Blog_Global:=Blog;
URL_Facebook_Global:=Facebook;
  URL_PayPal_Global:=PayPal;
end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure TForm1.Executa_Item_Emuladores(Sender: TObject);
var
VarConfig,VarNomeConsole:String;
begin
VarConfig:=Diretorio_Global+ExtractFilePath(Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][6])
                                           +Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][11];
                  
VarNomeConsole:=Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][2];

{EXECUTA O EMULADOR}
//-------------------------------------------------------------------------------------------
Executar_Esperar(Diretorio_Global+Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][6] ,''
                                 ,Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][12],''
                                 ,Array_Consoles[TMenuItem(Sender).Parent.MenuIndex+1][13]
                                 );
//-------------------------------------------------------------------------------------------

 {SE NÃO ESTIVER COM SEU ARQUIVO .INI, SOLTA MENSAGEM}
 if Menu_Emuladores.Items[TMenuItem(Sender).Parent.MenuIndex].Items[1].Enabled = False then
 begin

   //APÓS FECHAR O EMULADOR, SERÁ VERIFICADO A CRIAÇÃO DO ARQUIVO .INI
   if FileExists(VarConfig) then
   begin
   VarMsgGeral:=Mensagens_Privadas(10,VarNomeConsole,VarConfig,'');
   MessageBox(Application.Handle,pchar(VarMsgGeral)
                                ,pchar(Application.Title),MB_ICONINFORMATION+MB_OK);
   end
   else
   begin
   VarMsgGeral:=Mensagens_Privadas(14,VarNomeConsole,VarConfig,'');
   MessageBox(Application.Handle,pchar(VarMsgGeral)
                                ,pchar(Application.Title),MB_ICONERROR+MB_OK);
   end;
   
 end;
//-----------------------------------------------------------------------------------------

end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure TForm1.Deleta_Config_Emuladores(Sender: TObject);
var
VarConfig,VarNomeConsole,VarConfigOriginal:String;
VarID:Integer;
RegN64:TRegistry;
begin
//------------------------------------------
VarID:=TMenuItem(Sender).Parent.MenuIndex+1;
//------------------------------------------
VarConfig:=Diretorio_Global+ExtractFilePath(Array_Consoles[VarID][6])+Array_Consoles[VarID][11];
VarConfigOriginal:=Diretorio_Global+'Config\'+Array_Consoles[VarID][11];

VarNomeConsole:=Array_Consoles[VarID][2];

 Try
 VarMsgGeral:=Mensagens_Privadas(9,VarNomeConsole,'','');

   if Box_Confirma(Handle,VarMsgGeral) = 6 then
   begin
    {SE FOR NINTENDO 64, DELETAR MAIS ARQUIVOS E CHAVE CRIADA NO REGISTRO}
    if VarID = 7 then
    begin
    //DeleteFile(ChangeFileExt(VarConfig,EmptyStr)+'.cache3');
    //DeleteFile(ChangeFileExt(VarConfig,EmptyStr)+'.sc3');
    //-------------------------------------
    //RegN64:=TRegistry.Create;
    //RegN64.RootKey:=HKEY_CURRENT_USER;
    //RegN64.DeleteKey('\Software\JaboSoft');
    //RegN64.Free;
    //-------------------------------------
    end;
   DeleteFile(VarConfig);
   {COPIA O ARQUIVO DE CONFIG ORIGINAL PARA A PASTA DO EMULADOR}
   FileCopy(VarConfigOriginal,VarConfig);
   end;
   
 Except
 VarMsgGeral:=Mensagens_Privadas(8,VarNomeConsole,VarConfig,'');
 MessageBox(Application.Handle,pchar(VarMsgGeral)
                              ,pchar(Application.Title),MB_ICONERROR+MB_OK);
 end;

end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure TForm1.WMHotkey(var Msg: TWMHotkey);
begin

  case Msg.HotKey of
  {SAVESTATE}
  13: keybd_event(StrToInt(Copy(Array_Consoles[id_console][5],0,3)),0,0,0);
  {LOADSTATE}
  14: keybd_event(StrToInt(Copy(Array_Consoles[id_console][5],4,3)),0,0,0);
  {SIMULA O ALT+F4 - USADO NA TECLA ESC}
  15: TerminateProcess(PID_Emulador,0);
  end;

end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure EnumFolders(Root: String; Folders: TStrings);
procedure Enum(dir: String);
var
SR: TSearchRec;
ret: Integer;
begin
 if dir[length(dir)] <> '\' then
 dir := dir + '\';

 ret := FindFirst(dir + '*.*', faDirectory, SR);
 if ret = 0 then
 Try
   repeat
	 if ((SR.Attr and faDirectory) <> 0) and
		( SR.Name <> '.') and
		( SR.Name <> '..') then
	 begin
	 folders.add( dir+SR.Name );
	 Enum( dir + SR.Name );
	 end;
	 ret := FindNext( SR );
   until ret <> 0;
 Finally
 SysUtils.FindClose(SR)
 end;
   end;
begin
  if root <> EmptyStr then
  Enum(root);
end;

procedure EnumFiles(Pasta, Arquivo: String; Files: TStrings; ListBox1:TListBox);
var
SR:TSearchRec;
SubDirs:TStringList;
ret,X:Integer;
sPasta:String;
begin

 if Pasta[Length(Pasta)] <> '\' then
 Pasta := Pasta + '\';

 SubDirs := TStringList.Create;
 Try
 SubDirs.Add(Pasta);
 EnumFolders(Pasta, SubDirs);

   if SubDirs.Count > 0 then
     for X := 0 to SubDirs.Count -1 do
     begin
     sPasta:= SubDirs[X];

       if sPasta[Length(sPasta)] <> '\' then
       sPasta := sPasta + '\';

     ret := FindFirst(sPasta + Arquivo, faAnyFile, SR);
       if ret = 0 then
       Try
         Repeat
	  if not (SR.Attr and faDirectory > 0) then
          begin
          //--------------------------------------------------------------------
          if Arquivo <> Array_Consoles[id_console][4] then
          Renomear_Extensao(sPasta,Diretorio_Global+Array_Consoles[id_console][3],SR.Name,Array_Consoles[id_console][4])
          else

            //VERIFICA APENAS A PASTA DE ROMS DO PLAYSTATION
            if (sPasta) = (Diretorio_Global+Array_Consoles[6][3]) then
            begin
              //CASO TENHA 2 ARQUIVOS - TRACK1 e TRACK2
              if (Pos('TRACK 1)',UpperCase(SR.Name)) > 0) or (Pos('TRACK 01)',UpperCase(SR.Name)) > 0) then
              Files.Add(sPasta+SR.Name);

              //CASO SEJA CD ÚNICO
              if (Pos('TRACK',UpperCase(SR.Name)) = 0) then
              Files.Add(sPasta+SR.Name);
            end
            else
            Files.Add(sPasta+SR.Name);

          //--------------------------------------------------------------------
          end;
	 ret := FindNext(SR);
	 Until ret <> 0;
       Finally
       SysUtils.FindClose(SR)
       end;
     end;
 Finally
 SubDirs.Free;
 end;

end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
function TForm1.Eventos_Lista(Key: Word):Word;
begin

 if Key = VK_ESCAPE then
 begin
 Edit_Pesquisa.Clear;
 ListBox1.ItemIndex:=Perform(WM_NEXTDLGCTL,0,0);
 Edit_Pesquisa.SetFocus;
 end;

 if Key = VK_F5 then
 begin
  if (ListBox1.Count > 0) then
  Listar_Titulos(id_console);
 end;

Result:=Key;
end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
function TForm1.Carregar_Emulador(rom:String):Boolean;
var
Classe_Emula:PChar;
begin
Classe_Emula:=PChar(Array_Consoles[id_console][13]);

//--------------------------------------------------------
//CASO O EMULADOR ESTEJA TRAVADO NO GERENCIADOR DE TAREFAS
if FindWindow(Classe_Emula,Nil) > 0 then
begin
PostMessage(FindWindow(Classe_Emula,Nil),WM_CLOSE,0,0);
Sleep(1000);
end;
//--------------------------------------------------------

 if FileExists(rom) then
 begin
 Result:=Form1.Salvar_Config;
 //-------------------
 Form1.Enabled:=False;
 Screen.Cursor:=crHourglass;
 //-----------------------------------------------------------
 {O FUSION PRECISA EXECUTAR EM MODO DE COMPATIBILIDADE WINDOWS 7}
 if (LowerCase(ExtractName(Array_Consoles[id_console][6])) = 'fusion') then
 SetRegistryData(HKEY_CURRENT_USER,'\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers',
                 Diretorio_Global+Array_Consoles[id_console][6],rdString,'WIN7RTM');
 //-----------------------------------------------------------
 Executar_Esperar(Diretorio_Global+
                   Array_Consoles[id_console][6 ],' "'+rom+'"'
                  ,Array_Consoles[id_console][12]
                  ,Array_Consoles[id_console][5 ]
                  ,Array_Consoles[id_console][13]
                  );                        
 //-----------------------------------------------------------
 Form1.Enabled:=True;
 Screen.Cursor:=crDefault;
 //-------------------
 end
 else
 begin
 Result:=False;
 //------------------------------------------------------------------------------
 VarMsgGeral:=Mensagens_Privadas(12,Array_Consoles[id_console][2],ChangeFileExt(ExtractFileName(rom),''),'');
 MessageBox(Application.Handle,pchar(VarMsgGeral)
                              ,pchar(Application.Title),MB_ICONERROR+MB_OK);
 //------------------------------------------------------------------------------
 Listar_Titulos(id_console);
 end;

end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
function Editar_Config(arquivo_config:TStringList):Boolean;
var
i,j,k,l_n64,m_n64,NIN_COUNT:Integer;
caminho_emulador,resolucao_n64:String;
registro_n64:TRegistry;
plugin_fusion:Boolean;
arquivo_GLideN64:TStringList;
begin
caminho_emulador:=ExtractFilePath(Diretorio_Global+Array_Consoles[id_console][6]);

//--------------------------------------------------------------------------------------------
// EMULADOR FUSION - RENDER PLUGIN - 2xSaI.rpi
//--------------------------------------------------------------------------------------------
if (LowerCase(ExtractName(Array_Consoles[id_console][6])) = 'fusion') then
Localiza_Move_Plugin(Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6]),'Render Plugin','2xSaI.rpi');

if FileExists(Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6]+'\2xSaI.rpi')) then
plugin_fusion:=True
else
plugin_fusion:=False;
//--------------------------------------------------------------------------------------------

  {RESPEITANDO A ORDEM DOS ARQUIVOS DE CONFIGURAÇÃO DOS EMULADORES}
  j:=0;
  for i:=arquivo_config.Count-1 downto j do
  begin
   {CASO SEJA O EMULADOR FUSION - MASTER SYSTEM - MEGA DRIVE - SEGA CD}
   if (LowerCase(ExtractName(Array_Consoles[id_console][6])) = 'fusion') then
   begin
   if not DirectoryExists(caminho_emulador+'brm') then
   ForceDirectories(caminho_emulador+'brm');

      //-------------------------------------------------------------------------------------------------------
      {MASTER SYSTEM}
      //-------------------------------------------------------------------------------------------------------
      if (id_console = 4) then
      begin
      //------------------------------------------------------------
      // SG1000/SC3000/SMS/GG Specific
      //------------------------------------------------------------
                  if Pos('LastSMSROM=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='LastSMSROM=';
                  if Pos('LastGGROM=' ,arquivo_config[i]) = 1 then
      arquivo_config[i]:='LastGGROM=';
                  if Pos('SxMFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SxMFiles='+caminho_emulador;
      {}
                  if Pos('SMSStateFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SMSStateFiles='+caminho_emulador+'save\';
      {}
                  if Pos('SMSPatchFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SMSPatchFiles='+caminho_emulador;
                  if Pos('GGPatchFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='GGPatchFiles='+caminho_emulador;
      //------------------------------------------------------------
      end;
      //-------------------------------------------------------------------------------------------------------
      {MEGA DRIVE}
      //-------------------------------------------------------------------------------------------------------
      if (id_console = 1) then
      begin
      //------------------------------------------------------------
      // MegaDrive/Genesis Specific
      //------------------------------------------------------------
                  if Pos('LastGenesisROM=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='LastGenesisROM=';
                  if Pos('SRMFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SRMFiles='+caminho_emulador+'brm\';
      {}
                  if Pos('StateFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='StateFiles='+caminho_emulador+'save\';
      {}
                  if Pos('PatchFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='PatchFiles='+caminho_emulador;
      //------------------------------------------------------------
      end;
      //-------------------------------------------------------------------------------------------------------
      {SEGA CD}
      //-------------------------------------------------------------------------------------------------------
      if (id_console = 5) then
      begin
      //------------------------------------------------------------
      // Mega CD/Sega CD Specific
      //------------------------------------------------------------
                  if Pos('LastSegaCDImage=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='LastSegaCDImage=';
      {}
                  if Pos('SCDUSABIOS=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SCDUSABIOS='+caminho_emulador+'bios\us_scd2_9306.bin';
                  if Pos('SCDJAPBIOS=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SCDJAPBIOS='+caminho_emulador+'bios\jp_mcd1_9112.bin';
                  if Pos('SCDEURBIOS=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SCDEURBIOS='+caminho_emulador+'bios\eu_mcd2_9306.bin';
      {}
                  if Pos('SCDStateFiles=',arquivo_config[i]) = 1 then
      arquivo_config[i]:='SCDStateFiles='+caminho_emulador+'save\';
                  if Pos('BRMFiles='     ,arquivo_config[i]) = 1 then
      arquivo_config[i]:='BRMFiles='     +caminho_emulador+'brm\';
                  if Pos('LEDEnabled='   ,arquivo_config[i]) = 1 then
      arquivo_config[i]:='LEDEnabled=0';
      end;
    //------------------------------------------------------------
    // 32X Specific
    //------------------------------------------------------------
                if Pos('Disable32X=0',arquivo_config[i]) = 1 then
    arquivo_config[i]:='Disable32X=1';
    //------------------------------------------------------------
    // File History
    //------------------------------------------------------------
    while Pos('FileHistory',arquivo_config[i]) = 1 do
    arquivo_config.Delete(i);
    //------------------------------------------------------------
    // General Settings
    //------------------------------------------------------------
                if Pos('WAVFilesPath=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='WAVFilesPath='+caminho_emulador+'*.wav';
                if Pos('VGMFilesPath=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='VGMFilesPath='+caminho_emulador+'*.vgm';
                if Pos('AVIFilesPath=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='AVIFilesPath='+caminho_emulador+'*.avi';    
    {}
                if Pos('ScreenshotPath=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='ScreenshotPath='+caminho_emulador+'screenshots\';
    {}
                if Pos('CurrentCountry=',    arquivo_config[i]) = 1 then
    arquivo_config[i]:='CurrentCountry=0';
                if Pos('CountryAutoDetect=0',arquivo_config[i]) = 1 then
    arquivo_config[i]:='CountryAutoDetect=1';
                if Pos('CurrentWaveFormat=1',arquivo_config[i]) = 1 then
    arquivo_config[i]:='CurrentWaveFormat=2';
                if Pos('SoundOverdrive=0'   ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='SoundOverdrive=1';
                if Pos('SoundSuperHQ=0'     ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='SoundSuperHQ=1';
                if Pos('SoundFilter=0'      ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='SoundFilter=1';
    {}
                if Pos('CurrentRenderPlugin=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='CurrentRenderPlugin=1';
                if Pos('FullScreen=0'        ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='FullScreen=1';
    {}
         //       if Pos('DResolution=',arquivo_config[i]) = 1 then
    //arquivo_config[i]:='DResolution='+Resolucao_Tela_Fusion(Screen.Height)+','+Resolucao_Tela_Fusion(Screen.Width);
    {}
                if Pos('DRenderMode=',arquivo_config[i]) = 1 then
    if plugin_fusion = True then
    arquivo_config[i]:='DRenderMode=0'
    else
    arquivo_config[i]:='DRenderMode=3';
    {}
                if Pos('DFixedAspect=1',arquivo_config[i]) = 1 then
    arquivo_config[i]:='DFixedAspect=0';
                if Pos('DFiltered=1'   ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='DFiltered=0';
                if Pos('DNTSCAspect=0' ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='DNTSCAspect=1';
                if Pos('VSyncEnabled=0' ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='VSyncEnabled=1';
    {}
                if Pos('FPSEnabled=1'  ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='FPSEnabled=0';
    //------------------------------------------------------------
   end;
   //-------------------------------------------------------------------------------------------------------
   //SUPER NINTENDO
   //-------------------------------------------------------------------------------------------------------
   if (id_console = 2) then
   begin
   //------------------------------------------------------------
   // [Config]
   //------------------------------------------------------------
               if Pos('Lock          = TRUE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='Lock          = FALSE';
   //------------------------------------------------------------
   // [Sound\Win]
   //------------------------------------------------------------
               if Pos('SoundDriver      = ',  arquivo_config[i]) = 1 then
   arquivo_config[i]:='SoundDriver      = 0';
   //------------------------------------------------------------
   // [Display]
   //------------------------------------------------------------
               if Pos('HiRes             = OFF',arquivo_config[i]) = 1 then
   arquivo_config[i]:='HiRes             = ON';
               if Pos('Transparency      = OFF',arquivo_config[i]) = 1 then
   arquivo_config[i]:='Transparency      = ON';
               if Pos('FrameRate         = ON',arquivo_config[i]) = 1 then
   arquivo_config[i]:='FrameRate         = OFF';
   //------------------------------------------------------------
   // [Display\Win]
   //------------------------------------------------------------
               if Pos('                OutputMethod         = ',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                OutputMethod         = 0'; {0=DirectDraw, 1=Direct3D, 2=OpenGL}
   {}
     //----------------------------------------------------------------------------------------
     if PC_Bom = True then
     begin
                   if Pos('                FilterType           = ',arquivo_config[i]) = 1 then
       arquivo_config[i]:='                FilterType           = 10';
                   if Pos('                FilterHiRes          = ',arquivo_config[i]) = 1 then
       arquivo_config[i]:='                FilterHiRes          = 2';
     end
     else
     begin
                   if Pos('                FilterType           = ',arquivo_config[i]) = 1 then
       arquivo_config[i]:='                FilterType           = 0';
                   if Pos('                FilterHiRes          = ',arquivo_config[i]) = 1 then
       arquivo_config[i]:='                FilterHiRes          = 0';
     end;
     //----------------------------------------------------------------------------------------
   {}
               if Pos('                BlendHiRes           = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                BlendHiRes           = TRUE';
   {}
               if Pos('        Stretch:Enabled              = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='        Stretch:Enabled              = TRUE';
               if Pos('        Stretch:MaintainAspectRatio  = TRUE' ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='        Stretch:MaintainAspectRatio  = FALSE';
               if Pos('        Stretch:BilinearFilter       = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='        Stretch:BilinearFilter       = TRUE';
   {}
               if Pos('     Fullscreen:Enabled              = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='     Fullscreen:Enabled              = TRUE';
               if Pos('     Fullscreen:Width                = '     ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='     Fullscreen:Width                = '+IntToStr(Screen.Width);
               if Pos('     Fullscreen:Height               = '     ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='     Fullscreen:Height               = '+IntToStr(Screen.Height);
               if Pos('     Fullscreen:RefreshRate          = '     ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='     Fullscreen:RefreshRate          = 60';
               if Pos('     Fullscreen:EmulateFullscreen    = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='     Fullscreen:EmulateFullscreen    = TRUE';
               if Pos('                Vsync                = TRUE' ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='                Vsync                = FALSE';
   {}
   //------------------------------------------------------------
   // [Settings\Win]
   //------------------------------------------------------------
               if Pos('PauseWhenInactive          = FALSE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='PauseWhenInactive          = TRUE';
   //------------------------------------------------------------
   // [Settings\Win\Files]
   //------------------------------------------------------------
               if Pos('Dir:Lock         = TRUE',arquivo_config[i]) = 1 then
   arquivo_config[i]:='Dir:Lock         = FALSE';
   {}
   while Pos('Rom:RecentGame',arquivo_config[i]) = 1 do
   arquivo_config.Delete(i);
   //------------------------------------------------------------
   // [Controls\Win\Hotkeys]
   //------------------------------------------------------------
               if Pos('    Key:SaveSlot0         = ',arquivo_config[i]) = 1 then
   arquivo_config[i]:='    Key:SaveSlot0         = F6';
               if Pos('    Key:LoadSlot0         = ',arquivo_config[i]) = 1 then
   arquivo_config[i]:='    Key:LoadSlot0         = F7';
   {}
   if Pos('[Controls\Win\Hotkeys]',arquivo_config[i]) = 1 then
   begin
     for k:=i+3 to arquivo_config.Count-1 do
     begin
       if (Pos('    Key:SaveSlot0',arquivo_config[k]) = 0) and
          (Pos('    Key:LoadSlot0',arquivo_config[k]) = 0) then
       begin
         if (Pos('    Key:',arquivo_config[k]) = 1) then
         arquivo_config[k]:=Copy(arquivo_config[k],0,Pos('=', arquivo_config[k]))+' '+'Unassigned';
         if (Pos('   Mods:',arquivo_config[k]) = 1) then
         arquivo_config[k]:=Copy(arquivo_config[k],0,Pos('=', arquivo_config[k]))+' '+'none';
       end;
     end;
   end;
   //------------------------------------------------------------
   end;
   //-------------------------------------------------------------------------------------------------------
   {NINTENDO}
   //-------------------------------------------------------------------------------------------------------
   if id_console = 3 then
   begin
   //------------------------------------------------------------
   // <input>
   //   <keys>
   //     <file>
   //------------------------------------------------------------
               if Pos('                <exit>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <exit>Esc</exit>';
               if Pos('                <open>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <open>...</open>';
   {}
               if Pos('                <load-state>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <load-state>...</load-state>';
               if Pos('                <quick-load-state-1>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <quick-load-state-1>F7</quick-load-state-1>';
               if Pos('                <quick-load-state-newest>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <quick-load-state-newest>'+'...'+'</quick-load-state-newest>';
   {}
               if Pos('                <save-state>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <save-state>...</save-state>';
               if Pos('                <quick-save-state-1>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <quick-save-state-1>F6</quick-save-state-1>';
               if Pos('                <quick-save-state-oldest>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <quick-save-state-oldest>'+'...'+'</quick-save-state-oldest>';
   {}
   if Pos('            <file>',arquivo_config[i]) = 1 then
   begin
   NIN_COUNT:=2;
     for k:=i+5 to i+23 do
     begin
       if (Pos('                <quick-load-state-1>',arquivo_config[k]) = 0) and
          (Pos('                <quick-save-state-1>',arquivo_config[k]) = 0) then
       begin
                    if (Pos('                <quick-load-state-'+IntToStr(NIN_COUNT)+'>',arquivo_config[k]) = 1) then
         arquivo_config[k]:='                <quick-load-state-'+IntToStr(NIN_COUNT)+'>'+'...'+'</quick-load-state-'+IntToStr(NIN_COUNT)+'>';
                    if (Pos('                <quick-save-state-'+IntToStr(NIN_COUNT-9)+'>',arquivo_config[k]) = 1) then
         arquivo_config[k]:='                <quick-save-state-'+IntToStr(NIN_COUNT-9)+'>'+'...'+'</quick-save-state-'+IntToStr(NIN_COUNT-9)+'>';

       Inc(NIN_COUNT);
       end;
     end;
   end;
   {}
               if Pos('                <readme>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='                <readme>...</readme>';
   //------------------------------------------------------------
   // <input>
   //   <keys>
   //     <view>
   //------------------------------------------------------------
   if Pos('            <view>',arquivo_config[i]) = 1 then
   begin
                  if Pos('                <fullscreen>',arquivo_config[i+1]) = 1 then
    arquivo_config[i+1]:='                <fullscreen>...</fullscreen>';
                  if Pos('                <toggle-menu>',arquivo_config[i+13]) = 1 then
   arquivo_config[i+13]:='                <toggle-menu>...</toggle-menu>';
   end;
   //------------------------------------------------------------
   // <language>
   //------------------------------------------------------------
                 if Pos('    <language>',arquivo_config[i]) = 1 then
   arquivo_config[i+1]:='        <file>'+caminho_emulador+'language\english.nlg</file>';
   //------------------------------------------------------------
   // <machine>
   //------------------------------------------------------------
               if Pos('        <no-sprite-limit>no</no-sprite-limit>',arquivo_config[i]) = 1 then
   arquivo_config[i]:='        <no-sprite-limit>yes</no-sprite-limit>';
   //------------------------------------------------------------
   // <paths>
   //   <cheats>
   //------------------------------------------------------------
   if Pos('        <cheats>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+3]) = 1 then
   arquivo_config[i+3]:='            <directory>'+caminho_emulador+'cheats\</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <images>
   //------------------------------------------------------------
   if Pos('        <images>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <directory>'+caminho_emulador+'</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <patches>
   //------------------------------------------------------------
   if Pos('        <patches>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+3]) = 1 then
   arquivo_config[i+3]:='            <directory>'+caminho_emulador+'patches\</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <recent>
   //------------------------------------------------------------
   if Pos('        <recent>',arquivo_config[i]) = 1 then
   begin
    while Pos('                <directory>',arquivo_config[i+2]) = 1 do
    arquivo_config.Delete(i+2);
    while Pos('                <file>',arquivo_config[i+5]) = 1 do
    arquivo_config.Delete(i+5);
   end;
   //------------------------------------------------------------
   // <paths>
   //   <samples>
   //------------------------------------------------------------
   if Pos('        <samples>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <directory>'+caminho_emulador+'samples\</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <saves>
   //------------------------------------------------------------
   if Pos('        <saves>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <directory>'+caminho_emulador+'save\</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <screenshots>
   //------------------------------------------------------------
   if Pos('        <screenshots>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <directory>'+caminho_emulador+'screenshots\</directory>';
   end;
   //------------------------------------------------------------
   // <paths>
   //   <states>
   //------------------------------------------------------------
   if Pos('        <states>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <directory>',arquivo_config[i+3]) = 1 then
   arquivo_config[i+3]:='            <directory>'+caminho_emulador+'states\</directory>';
   end;
   //------------------------------------------------------------
   // <preferences>
   //   <application>
   //------------------------------------------------------------
   if Pos('        <application>',arquivo_config[i]) = 1 then
   begin
                  if Pos('            <confirm-exit>yes</confirm-exit>',arquivo_config[i+3]) = 1 then
    arquivo_config[i+3]:='            <confirm-exit>no</confirm-exit>';
                  if Pos('            <start-fullscreen>no</start-fullscreen>',arquivo_config[i+10]) = 1 then
   arquivo_config[i+10]:='            <start-fullscreen>yes</start-fullscreen>';
                  if Pos('            <suppress-warnings>no</suppress-warnings>',arquivo_config[i+11]) = 1 then
   arquivo_config[i+11]:='            <suppress-warnings>yes</suppress-warnings>';
   end;
   //------------------------------------------------------------
   // <sound>
   //------------------------------------------------------------
   if Pos('    <sound>',arquivo_config[i]) = 1 then
   begin
                 if Pos('        <memory-pool>hardware</memory-pool>',arquivo_config[i+4]) = 1 then
   arquivo_config[i+4]:='        <memory-pool>system</memory-pool>';
                 if Pos('        <speakers>mono</speakers>',arquivo_config[i+7]) = 1 then
   arquivo_config[i+7]:='        <speakers>stereo</speakers>';
   end;
   //------------------------------------------------------------
   // <video>
   //   <timing>
   //------------------------------------------------------------
   if Pos('    <timing>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <triple-buffering>no</triple-buffering>',arquivo_config[i+7]) = 1 then
   arquivo_config[i+7]:='            <triple-buffering>yes</triple-buffering>';
                 if Pos('            <vsync>no</vsync>',arquivo_config[i+8]) = 1 then
   arquivo_config[i+8]:='            <vsync>yes</vsync>';
   end;
   //------------------------------------------------------------
   // <video>
   //------------------------------------------------------------
   if Pos('    <video>',arquivo_config[i]) = 1 then
   begin
                 if Pos('        <auto-display-frequency>yes</auto-display-frequency>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='        <auto-display-frequency>no</auto-display-frequency>';
   end;
   //------------------------------------------------------------
   // <video>
   //   <filters>
   //------------------------------------------------------------
   if Pos('        <filters>',arquivo_config[i]) = 1 then
   begin
                  if Pos('                <bilinear>no</bilinear>',arquivo_config[i+5]) = 1 then
    arquivo_config[i+5]:='                <bilinear>yes</bilinear>';
                  if Pos('                <tv-aspect>yes</tv-aspect>',arquivo_config[i+18]) = 1 then
   arquivo_config[i+18]:='                <tv-aspect>no</tv-aspect>';
                  if Pos('            <type>',arquivo_config[i+28]) = 1 then
   arquivo_config[i+28]:='            <type>hqx</type>';
   end;
   //------------------------------------------------------------
   // <video>
   //   <fullscreen>
   //------------------------------------------------------------
   if Pos('        <fullscreen>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <bpp>16</bpp>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <bpp>32</bpp>';

                 if Pos('            <height>',arquivo_config[i+2]) = 1 then
   arquivo_config[i+2]:='            <height>'+InTToStr(Screen.Height)+'</height>';
                 if Pos('            <width>' ,arquivo_config[i+3]) = 1 then
   arquivo_config[i+3]:='            <width>' +IntToStr(Screen.Width) +'</width>';
   end;
   //------------------------------------------------------------
   // <view>
   //   <size>
   //------------------------------------------------------------
   if Pos('        <size>',arquivo_config[i]) = 1 then
   begin
                 if Pos('            <fullscreen>',arquivo_config[i+1]) = 1 then
   arquivo_config[i+1]:='            <fullscreen>stretched</fullscreen>';
   end;
   //------------------------------------------------------------
   end;
   //-------------------------------------------------------------------------------------------------------
   {PLAYSTATION}
   //-------------------------------------------------------------------------------------------------------
   if id_console = 6 then
   begin
   //------------------------------------------------------------
   // [Paths]
   //------------------------------------------------------------
               if Pos('SaveStatePath=' ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='SaveStatePath=' +caminho_emulador+'saves\';
               if Pos('MemoryCardPath=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='MemoryCardPath='+caminho_emulador+'cards\';
   {}
               if Pos('CDImagePath='    ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='CDImagePath='    +caminho_emulador+'cdimages\';
               if Pos('ScreenShotsPath=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='ScreenShotsPath='+caminho_emulador+'screenshots\';
   //------------------------------------------------------------
   // [BIOS]
   //------------------------------------------------------------
               if Pos('PS1=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='PS1='+caminho_emulador+'bios\SCPH1001.BIN';
               if Pos('PS2=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='PS2='+caminho_emulador+'bios\scph39001.bin';
   //------------------------------------------------------------
   // [Graphics]
   //------------------------------------------------------------
               if Pos('NTSCWidth=' ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='NTSCWidth='+IntToStr(Screen.Width);
               if Pos('NTSCHeight=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='NTSCHeight='+IntToStr(Screen.Height);
   {}
               if Pos('PALWidth=' ,arquivo_config[i]) = 1 then
   arquivo_config[i]:='PALWidth='+IntToStr(Screen.Width);
               if Pos('PALHeight=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='PALHeight='+IntToStr(Screen.Height);
   {}
               if Pos('FullscreenAspectRatio=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='FullscreenAspectRatio=-1';
   //------------------------------------------------------------
   // [Cards]
   //------------------------------------------------------------
               if Pos('Card1=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='Card1='+caminho_emulador+'cards\MEMORY_CARD_PSX_P1.bin';
               if Pos('Card2=',arquivo_config[i]) = 1 then
   arquivo_config[i]:='Card2='+caminho_emulador+'cards\MEMORY_CARD_PSX_P2.bin';
   //------------------------------------------------------------
   end;
   //-------------------------------------------------------------------------------------------------------
   //NINTENDO 64
   //-------------------------------------------------------------------------------------------------------
   if id_console = 7 then
   begin
   
   //----------------------------------------------------------------
   {REGISTRO DO WINDOWS}
   //----------------------------------------------------------------
   //resolucao_n64:=IntToStr(Screen.Width)+'x'+IntToStr(Screen.Height);
   //----------------------------------------------------------------
   //registro_n64 := TRegistry.Create;
   //registro_n64.RootKey:=HKEY_CURRENT_USER;
                                             gg
       for l_n64:=arquivo_config.Count-1 downto m_n64 do
       begin
          if Pos('textureFilter\txCachePath=',arquivo_config[i]) = 1 then
          arquivo_config[i]:='textureFilter\txCachePath='+caminho_emulador+'Plugin/GFX/GLideN64/cache';
          if Pos('textureFilter\txDumpPath=',arquivo_config[i]) = 1 then
          arquivo_config[i]:='textureFilter\txDumpPath='+caminho_emulador+'Plugin/GFX/GLideN64/texture_dump';
          if Pos('textureFilter\txPath=',arquivo_config[i]) = 1 then
          arquivo_config[i]:='textureFilter\txPath='+caminho_emulador+'Plugin/GFX/GLideN64/hires_texture';

          if Pos('video\fullscreenHeight=',arquivo_config[i]) = 1 then
          arquivo_config[i]:='video\fullscreenHeight='+IntToStr(Screen.Height);
          if Pos('video\fullscreenWidth=',arquivo_config[i]) = 1 then
          arquivo_config[i]:='video\fullscreenWidth='+IntToStr(Screen.Width);
       end;

    {Try
     registro_n64.OpenKey('Software\'+driver_video_n64, True);
    Finally
     registro_n64.WriteInteger('Full Screen Format',22);
     registro_n64.WriteInteger('Direct3D8.InitFlags',14680064);
     registro_n64.WriteInteger('Full Screen Height',StrToInt(Copy(resolucao_n64  ,Pos('x',resolucao_n64)+1,Length(resolucao_n64)-Pos('x',resolucao_n64))));
     registro_n64.WriteInteger('Full Screen Refresh Rate',60);
     registro_n64.WriteInteger('Full Screen Width' ,StrToInt(Copy(resolucao_n64,0,Pos('x',resolucao_n64)-1)));
     registro_n64.WriteInteger('Options',config_reg_n64);
    end;
    registro_n64.CloseKey;
    registro_n64.Free;}
   {}
   //----------------------------------------------------------------
   {ARQUIVO FÍSICO DE CONFIGURAÇÕES}
   //----------------------------------------------------------------
   {}   
   //------------------------------------------------------------
   // [Plugin]
   //------------------------------------------------------------
    if Pos('[Plugin]', arquivo_config[i]) = 1 then
    begin
     {
     arquivo_config[i+1]:='Audio Dll Ver=Jabo''s DirectSound 1.7.0.7';
     arquivo_config[i+2]:='Controller Dll Ver=Jabo''s DirectInput 1.7.0.12';
     arquivo_config[i+3]:='Graphics Dll=1.6 Plugins\Jabo_Direct3D8.dll';
     arquivo_config[i+4]:='Graphics Dll Ver=Jabo''s Direct3D8 1.6.1';
     arquivo_config.Insert(i+5,'RSP Dll Ver=RSP Plugin 1.7.0.9');
     }
     arquivo_config[i+1]:='Audio Dll Ver=Project64 audio plugin: 3.0.1.5664-2df3434';
     arquivo_config[i+2]:='Controller Dll Ver=Project64 input plugin: 3.0.1.5664-2df3434';
     arquivo_config[i+3]:='Graphics Dll Default=GFX\GLideN64\GLideN64.dll';
     arquivo_config[i+4]:='Graphics Dll Ver=GLideN64 rev.c36ffa9';
     arquivo_config[i+5]:='RSP Dll Ver=RSP plugin 3.0.1.5664-2df3434';

    end;
   {}
   //------------------------------------------------------------
   // [default]
   //------------------------------------------------------------
   //if Pos('[default]',arquivo_config[i]) = 1 then
    if Pos('[Settings]',arquivo_config[i]) = 1 then
    begin
                    if Pos('Auto Full Screen=',arquivo_config[i+1]) = 1 then
      arquivo_config[i+1]:='Auto Full Screen=1'
      else
      arquivo_config.Insert(i+1,'Auto Full Screen=1');
    end;
   {}
   //------------------------------------------------------------
   // [Direct3D8]
   //------------------------------------------------------------
   {             if Pos('FullscreenHeight=',arquivo_config[i]) = 1 then
    arquivo_config[i]:='FullscreenHeight='+Copy(resolucao_n64,Pos('x',resolucao_n64)+1,Length(resolucao_n64)-Pos('x',resolucao_n64));
                if Pos('FullscreenWidth=' ,arquivo_config[i]) = 1 then
    arquivo_config[i]:='FullscreenWidth=' +Copy(resolucao_n64,0,Pos('x',resolucao_n64)-1);
   }
   {}
   //------------------------------------------------------------
   // [Recent File]
   //------------------------------------------------------------
    if Pos('Recent Rom ',arquivo_config[i]) = 1 then
    arquivo_config.Delete(i);
   {}
   //------------------------------------------------------------
   end;
  end;

Result:=True;
end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
function TForm1.Salvar_Config:Boolean;
var
arquivo_ini,diretorio_config,arquivo_ini_original,arq_n64:String;
begin
//CAMINHO COMPLETO DO EXECUTÁVEL DO EMULADOR
diretorio_config:=Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6]);

arquivo_ini_fisico:=TStringList.Create;
arquivo_ini:=diretorio_config+Array_Consoles[id_console][11];

  if FileExists(arquivo_ini) then
  begin
  //CARREGA O ARQUIVO .INI
  //-------------------------------------------
  arquivo_ini_fisico.LoadFromFile(arquivo_ini);
  Editar_Config(arquivo_ini_fisico);
  //-------------------------------------------

    //SOBRESCREVE O ARQUIVO .INI ATUAL NA PASTA DO EMULADOR
    Try
    arquivo_ini_fisico.SaveToFile(arquivo_ini);

        {NINTENDO 64 - GRAVAR ARQUIVO DE ATALHO DE TECLAS DO EMULADOR - "PROJECT64.SC3"}
        if id_console = 7 then
        begin
        arq_n64:=ExtractFileName(Array_Consoles[id_console][11]);
        arq_n64:=ExtractFilePath(arquivo_ini)+Copy(arq_n64,0,Length(arq_n64)-4)+'.sc3';
         //-----------------------------
         if not FileExists(arq_n64) then
         Grava_ArquivoN64(arq_n64);
         //-----------------------------
        end;

    Except
    Erro_Salvar_Config:=True;
     {SIM ou NÃO - EXECUTAR NORMALMENTE O EMULADOR}
     if MessageBox(Application.Handle,pchar(Mensagens_Publicas(2)),pchar(Application.Title),MB_ICONWARNING+MB_YESNO) = IDYES then
     begin     
     Result:=False;
     Exit;
     end
    else
    Application.Terminate;
    //Form1.Enabled:=True;
    end;

  Result:=True;
  end
  else
  begin
  arquivo_ini_original:=Diretorio_Global+'Config\'+ExtractFileName(Array_Consoles[id_console][11]);

    //INÍCIO - FileExists
    if FileExists(arquivo_ini_original) then
    begin
     Try
       //--------------------------------------------------------
       //NINTENDO 64
       //--------------------------------------------------------
       if id_console = 7 then
       begin
        if not DirectoryExists(ExtractFilePath(arquivo_ini)) then
        ForceDirectories(ExtractFilePath(arquivo_ini));
       end;
       //--------------------------------------------------------

     //COPIA O .INI DA PASTA "CONFIG" PARA A PASTA DO EMULADOR
     FileCopy(arquivo_ini_original,arquivo_ini);

     Result:=Salvar_Config;
     Except
     Erro_Salvar_Config:=True;
      if MessageBox(Application.Handle, pchar(Mensagens_Publicas(2)), pchar(Application.Title), MB_ICONWARNING+MB_YESNO) = IDYES then
      Result:=True;
    end;
    Exit;
    end
    else
    begin
    //-------------------------------------------------------------------------------
    VarMsgGeral:=Mensagens_Privadas(13,Array_Consoles[id_console][2],arquivo_ini,'');
    MessageBox(Application.Handle,pchar(VarMsgGeral)
                                 ,pchar(Application.Title),MB_ICONERROR+MB_OK);
    //-------------------------------------------------------------------------------
    end;
    //FIM - FileExists

  Result:=False;
  end;

arquivo_ini_fisico.Free;
end;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
{$R *.dfm}

procedure TForm1.Listagem_Nova(Sender: TObject);
var
VarDiretorioRom:String;
begin
id_console:=StrToInt((Sender as TSpeedButton).Name[2]);

VarDiretorioRom:=Diretorio_Global+Array_Consoles[id_console][3];

abfFolderMonitor1.Folder:=VarDiretorioRom;
abfFolderMonitor1.Active:=True;

Listar_Titulos(id_console);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{USADO PARA PEGAR NOVO CÓDIGO E ALTERAR NO BLOG}
//Edit1.Text:=LowerCase(Md5Hash(NomeExe_Global+VersaoApp_Global));
//Edit1.Visible:=True;

 if Verificar_Status(True,IMG_STATUS) < 3 then
 Abertura_Sistema(Menu_Emuladores);

end;

procedure TForm1.Edit_PesquisaChange(Sender: TObject);
var
s:Array[0..255] of Char;
begin

 if Length(Edit_Pesquisa.Text) > 0 then
 begin
 StrPCopy(s,'  '+Edit_Pesquisa.Text);
   with ListBox1 do
   ItemIndex:=Perform(LB_SELECTSTRING,0,LongInt(@s));
 end;

 if Length(Edit_Pesquisa.Text) = 0 then
 ListBox1.ItemIndex:=-1;

end;

procedure TForm1.Edit_PesquisaExit(Sender: TObject);
begin
Edit_Pesquisa.Clear;
end;

procedure TForm1.img_nokClick(Sender: TObject);
begin
MessageBox(Application.Handle,pchar(Mensagens_Publicas(1))
                             ,pchar(Application.Title),MB_ICONWARNING+MB_OK);
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
i:Integer;
p:TPoint;
begin
//-------------------------
id_console_joy:=id_console;
//-------------------------

PopUp_BIOS.Visible:=False;
PopUp_MemoryCard.Visible:=False;

 if (Button = mbRight) then
 begin
 p:=Point(X,Y); //PEGA A POSIÇÃO ATUAL DO CURSOR NO LISTBOX1
 i:=ListBox1.ItemAtPos(p,True); //VERIFICA QUAL ITEM ESTÁ NESTA POSIÇÃO
 //------------------------------------------------
  if i > -1 then //SE EXISTIA ITEM NA POSIÇÃO
  begin
  PopUp_ExecutarROM.Visible:=True;
  PopUp_RenomearROM.Visible:=True;
     case id_console of
     5: PopUp_BIOS.Visible:=True;
     6: begin
        PopUp_BIOS.Visible:=True;
        PopUp_MemoryCard.Visible:=True;
        end;
     end;
  ListBox1.ItemIndex:=i; //SETA O ITEM SELECIONADO
  p:=ListBox1.ClientToScreen(p);
  PopupMenu1.Popup(p.X,p.Y); //MOSTRA O POPUP
  end
  else
  begin
  PopUp_ExecutarROM.Visible:=False;
  PopUp_RenomearROM.Visible:=False;
     case id_console of
     5: PopUp_BIOS.Visible:=True;
     6: begin
        PopUp_BIOS.Visible:=True;
        PopUp_MemoryCard.Visible:=True;
        end;
     end;
  GetCursorPos(p);
  PopupMenu1.Popup(p.X,p.Y); //MOSTRA O POPUP
  end;
 //------------------------------------------------
 end;

end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
PopUp_ExecutarROM.Click;
end;

procedure TForm1.PopUp_ExecutarROMClick(Sender: TObject);
begin
Carregar_Emulador(Vetor_Listagem_Rom[ListBox1.ItemIndex]);
end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 if (ListBox1.ItemIndex >= 0) then
 begin
  {ENTER}
  if Key = 13 then
  PopUp_ExecutarROM.Click;

  {F2}
  if Key = 113 then
  PopUp_RenomearROM.Click;
 end;
 
end;

procedure TForm1.PopUp_DiretorioROMClick(Sender: TObject);
begin
Abrir_Diretorio(Diretorio_Global+Array_Consoles[id_console][3]);
end;

procedure TForm1.PopUp_BIOSClick(Sender: TObject);
begin
Abrir_Diretorio(Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6])+'bios');
end;

procedure TForm1.PopUp_MemoryCardClick(Sender: TObject);
begin
Abrir_Diretorio(Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6])+'cards');
end;

function GetStateK(Key: integer): boolean;
begin
Result:=Odd(GetKeyState(Key));
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Eventos_Lista(Key);
end;

procedure TForm1.PopUp_ConfigurarControlesClick(Sender: TObject);
var
diretorio_config,emulador_exe,arquivo_ini:String;
begin
//NOME DO EXECUTÁVEL DO EMULADOR
emulador_exe:=ExtractFileName(Array_Consoles[id_console_joy][6]);
//CAMINHO COMPLETO DO EXECUTÁVEL DO EMULADOR
diretorio_config:=Diretorio_Global+ExtractFilePath(Array_Consoles[id_console_joy][6]);

arquivo_ini:=diretorio_config+Array_Consoles[id_console_joy][11];

 if FileExists(arquivo_ini) then
 begin
 arquivo_ini_joy:=arquivo_ini; //SALVAR O ARQUIVO .INI NA TELA DO CONTROLE
 //----------------------------------------------
 arquivo_ini_fisico:=TStringList.Create;
 arquivo_ini_fisico.LoadFromFile(arquivo_ini);
 //----------------------------------------------
 Application.CreateForm(TForm2, Form2);
 Form2.ShowModal;
 Form2.Free;
 end
 else
 begin
 //-------------------------------------------------------------------------------
 VarMsgGeral:=Mensagens_Privadas(13,Array_Consoles[id_console_joy][2],arquivo_ini,'');
 MessageBox(Application.Handle,pchar(VarMsgGeral)
                              ,pchar(Application.Title),MB_ICONERROR+MB_OK);
 //-------------------------------------------------------------------------------
 end;
 
end;

procedure TForm1.PopUp_RenomearROMClick(Sender: TObject);
begin
RenomearROM;
end;

procedure TForm1.abfFolderMonitor1Change;
begin
abfFolderMonitor1.Folder:=Diretorio_Global+Array_Consoles[id_console][3];
Listar_Titulos(id_console);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure TForm1.Menu_Emuladores_Clicar(Sender:TObject);
var
Habilitar:Boolean;
begin
id_console_joy:=TMenuItem(Sender).MenuIndex+1;

//VERIFICA SE EXISTE O ARQUIVO DE CONFIGURAÇÃO
Habilitar:=FileExists(Diretorio_Global+
                      ExtractFilePath(Array_Consoles[id_console_joy][6 ])+
                                      Array_Consoles[id_console_joy][11]);

//HABILITA OU DESABILITA O ITEM "Configurar Controles" e "Excluir Configurações"
TMenuItem(Sender).Items[1].Enabled:=Habilitar;
TMenuItem(Sender).Items[3].Enabled:=Habilitar;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure TForm1.Menu_EmuladoresClick(Sender: TObject);
var
i:Integer;
begin

 for i:=1 to Length(Array_Consoles) do
 TMenuItem(Sender).Items[i-1].OnClick:=Menu_Emuladores_Clicar;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure TForm1.Edit_PesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 {CTRL + A}
 if ssCtrl in Shift then
 begin
  if LowerCase(Char(Key)) = 'a' then
  Edit_Pesquisa.SelectAll;
 end;

end;

procedure TForm1.Menu_SobreClick(Sender: TObject);
begin
Application.CreateForm(TForm5, Form5);
Form5.ShowModal;
Form5.Free;
end;

procedure TForm1.img_driveDblClick(Sender: TObject);
var
VarDiretorioROM:String;
begin
 //-------------------------------------------------------------------------
 if (ListBox1.Count = 0) and (ListBox1.Enabled = True) then
 begin
 VarDiretorioROM:=Diretorio_Global+Array_Consoles[id_console][3];

  if DirectoryExists(VarDiretorioROM) then
  Abrir_Diretorio(VarDiretorioROM)
  else
  begin
  VarMsgGeral:=Mensagens_Privadas(11,'',VarDiretorioROM,'');
  MessageBox(Application.Handle,pchar(VarMsgGeral)
                               ,pchar(Application.Title),MB_ICONERROR+MB_OK);
  end;
 end;
 //-------------------------------------------------------------------------
end;

procedure TForm1.img_driveMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (id_console > 0) then
ListBox1MouseDown(Sender,Button,Shift,X,Y);
end;

procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
ColorirLista(Control,Index,Rect,State,Copy(Array_Consoles[id_console][8],0 ,6)
                                     ,Copy(Array_Consoles[id_console][8],7 ,6)
                                     ,Copy(Array_Consoles[id_console][8],13,6)
                                     ,Copy(Array_Consoles[id_console][8],19,6));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//----------------------   
SaveLoadState(False,'');
//----------------------
Vetor_Listagem_Rom.Free;
Vetor_Listagem_Rom:=Nil;
//----------------------
Form1.Release;
Form1:=Nil;
//Action := caFree;
//FreeAndNil(Form1);
//----------------------
end;

procedure TForm1.IMG_STATUSClick(Sender: TObject);
begin
Verificar_Status(False,Nil);
end;

procedure TForm1.StatusBar1Click(Sender: TObject);
begin
Verificar_Status(False,Nil);
end;

procedure TForm1.SubMenu_FacebookClick(Sender: TObject);
begin
ShellExecute(0,Nil,PChar(URL_Facebook_Global),Nil,Nil,0);
end;

procedure TForm1.SubMenu_BlogClick(Sender: TObject);
begin
ShellExecute(0,Nil,PChar(URL_Blog_Global),Nil,Nil,0);
end;

procedure TForm1.SubMenu_PayPalClick(Sender: TObject);
begin
ShellExecute(0,Nil,PChar(URL_PayPal_Global),Nil,Nil,0);
end;

procedure TForm1.coolromClick(Sender: TObject);
begin
ShellExecute(0,Nil,PChar('http://coolrom.com'),Nil,Nil,0);
end;

procedure TForm1.romhustlerClick(Sender: TObject);
begin
ShellExecute(0,Nil,PChar('http://romhustler.net'),Nil,Nil,0);
end;

procedure TForm1.FREEROMScom1Click(Sender: TObject);
begin
ShellExecute(0,Nil,PChar('http://www.freeroms.com'),Nil,Nil,0);
end;

procedure TForm1.BTN_EXTRAIRClick(Sender: TObject);
var
Lista: TStringList;
Nome_Arquivo: String;
i: Integer;
begin
//*********************************
//Usado na função "Listar_Titulos"
//*********************************

Lista:= TStringList.Create;
Nome_Arquivo:=Array_Consoles[id_console][7]+'.txt';

 Try
 Lista.Add(UpperCase(Array_Consoles[id_console][2])+' - '+StatusBar1.Panels[1].Text);
 Lista.Add('');

   For i := 0 to ListBox1.Count-1 do
   Lista.Add(IntToStr(i+1)+'. '+Trim(ListBox1.Items.Strings[i]));

 Lista.SaveToFile(Nome_Arquivo);
 WinExec(PChar('Notepad.exe '+Nome_Arquivo),sw_shownormal);
 DeleteFile(Nome_Arquivo);
 Finally
 Lista.Free;
 end;

end;

procedure TForm1.BTN_CONFIGClick(Sender: TObject);
var
VarConfig: String;
begin
//*********************************
//Usado na função "Listar_Titulos"
//*********************************

VarConfig:=Diretorio_Global+ExtractFilePath(Array_Consoles[id_console][6])
                                           +Array_Consoles[id_console][11];

WinExec(PChar('Notepad.exe '+VarConfig),sw_shownormal);
end;

procedure TForm1.BTN_TVClick(Sender: TObject);
begin
ListBox1.SetFocus;

 {if TV_On_Off = False then
 begin
 TV_On_Off:=True;
 BTN_TV.ImageNormal:=BTN_TV.ImageDown;
 //---------------------------------------
 config_reg_n64:=config_alphablending_n64;
 //---------------------------------------
 VarMsgGeral:=Mensagens_Publicas(6);
 MessageBox(Application.Handle,pchar(VarMsgGeral)
                              ,pchar(Application.Title),MB_ICONWARNING+MB_OK);
 end
 else
 begin
 TV_On_Off:=False;
 BTN_TV.ImageNormal:=BTN_TV.ImageOver;
 //---------------------------------------
 config_reg_n64:=config_default_n64;
 //--------------------------------------- 
 VarMsgGeral:=Mensagens_Publicas(8);
 MessageBox(Application.Handle,pchar(VarMsgGeral)
                              ,pchar(Application.Title),MB_ICONINFORMATION+MB_OK);
 end;
      }
end;

procedure TForm1.BTN_JOYSTICKClick(Sender: TObject);
begin
PopUp_DiretorioROM.Click;
end;

end.


