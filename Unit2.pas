unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, abfControls, ImgList, StrUtils,
  Menus, Buttons, ToolWin, ComCtrls;

  const
  UM_HIDECARET = WM_USER + 101;
  type
  TUMHideCaret = packed record
    msg: Cardinal;
    control: TWinControl;
  end;

  type
  TStringArray = Array of String;

type
  TForm2 = class(TForm)
    texto_botao_07: TLabel;
    texto_botao_08: TLabel;
    START: TabfEdit;
    SELECT: TabfEdit;
    combobox_player: TabfComboBox;
    Panel_Controle_Tipo: TPanel;
    controle_tipo: TRadioGroup;
    Panel_Controles: TPanel;
    joy_segacd: TImage;
    joy_mega: TImage;
    joy_master: TImage;
    joy_ps1: TImage;
    joy_snes: TImage;
    Panel_Direcionais: TPanel;
    DOWN_IMG: TImage;
    UP_IMG: TImage;
    LEFT_IMG: TImage;
    RIGHT_IMG: TImage;
    UP: TabfEdit;
    DOWN: TabfEdit;
    RIGHT: TabfEdit;
    LEFT: TabfEdit;
    Panel_Botoes_Padrao: TPanel;
    texto_botao_03: TLabel;
    texto_botao_05: TLabel;
    texto_botao_04: TLabel;
    texto_botao_06: TLabel;
    texto_botao_01: TLabel;
    texto_botao_02: TLabel;
    botao_03: TabfEdit;
    botao_05: TabfEdit;
    botao_04: TabfEdit;
    botao_06: TabfEdit;
    botao_01: TabfEdit;
    botao_02: TabfEdit;
    ps1_triangulo: TImage;
    ps1_quadrado: TImage;
    ps1_bola: TImage;
    ps1_x: TImage;
    botao_09: TabfEdit;
    botao_10: TabfEdit;
    texto_botao_10: TLabel;
    texto_botao_09: TLabel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    joy_nes: TImage;
    StatusBar1: TStatusBar;
    joy_n64: TImage;
    Panel_C_Botoes: TPanel;
    C_DOWN_IMG: TImage;
    C_DOWN: TabfEdit;
    C_LEFT: TabfEdit;
    C_LEFT_IMG: TImage;
    C_UP: TabfEdit;
    C_UP_IMG: TImage;
    C_RIGHT: TabfEdit;
    C_RIGHT_IMG: TImage;
    MainMenu1: TMainMenu;
    Controles1: TMenuItem;
    btn_editar: TMenuItem;
    btn_gravar: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure controle_tipoClick(Sender: TObject);
    procedure combobox_playerChange(Sender: TObject);
    procedure btn_editarClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  procedure UMHideCaret(var msg: TUMHideCaret); message UM_HIDECARET;
  public
    { Public declarations }
  //-------------------------------------------------------------
  procedure Entra_Campo(Sender: TObject);
  procedure Solta_Tecla(Sender: TObject; var Key: Word;Shift: TShiftState);
  //-------------------------------------------------------------
  function Listar_Controles(player:Integer):Boolean;
  function Editar_Controles(player:Integer):Boolean;
  function converter_entradas(modelo_teclas:Integer;comando:String):String;
  function converter_saidas  (modelo_teclas:Integer;comando:String):String;
  //-------------------------------------------------------------
  function Padrao_Controle_Genesis(JoystickType:Integer):Boolean;
  function Padrao_Controle_Geral  (JoyPad      :Integer):Boolean;
  //-------------------------------------------------------------
  function Limpar_Campos(limpar,colorir:Boolean):Boolean;
  //-------------------------------------------------------------
  function start_select(botoes:Boolean):Boolean;
  function Lista_Botoes_Controle(linha,player:String;tipo_controle:Integer):Boolean;
  end;

var
  Form2: TForm2;
  Editar_Flag: Boolean;
  controle_genesis_2: Integer;

const
  erro_tecla = 'ERRO';
  erro_cor   = 'FF0012';

  aviso_campos     = 'Preencha todos os campos corretamente com teclas válidas e tente novamente!'+#13#13+
                     'CODE: JOY01';
                     //É verificado em todos os campos se está algum em BRANCO ou com a mensagem de ERRO.

  comandos_teclado : array[0..77] of String =
{4 }  ('CIMA','BAIXO','ESQUERDA','DIREITA',
{5 }   'ENTER','SHIFT','CTRL','ALT','ESPAÇO',
{6 }   'PAGE UP','PAGE DOWN','END','HOME','INSERT','DELETE',
{15}   'NUM0','NUM1','NUM2','NUM3','NUM4','NUM5','NUM6','NUM7','NUM8','NUM9','DEL','+','-','*','/',
{12}// 'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12',
       'ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO','ERRO',
{10}   '1','2','3','4','5','6','7','8','9','0',
{26}   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
      );
  comandos_fusion : array[0..77] of String =
{4 }  ('200','208','203','205',
{5 }   '28','42','29','56','57',
{6 }   '201','209','207','199','210','211',
{15}   '82','79','80','81','75','76','77','71','72','73','83','78','74','55','181',
{12}// '59','60','61','62','63','64','65','66','67','68','87','88',
       '','','','','','','','','','','','',
{10}   '2','3','4','5','6','7','8','9','10','11',
{26}   '30','48','46','32','18','33','34','35','23','36','37','38','50','49','24','25','16','19','31','20','22','47','17','45','21','44'
      );
  comandos_snes : array[0..87] of String =
{4 }  ('Up','Down','Left','Right',
{5 }   'Enter','Shift','Control','Alt','Space',
{6 }   'PgUp','PgDn','End','Home','Insert','Delete',
{15}   'Numpad-0','Numpad-1','Numpad-2','Numpad-3','Numpad-4','Numpad-5','Numpad-6','Numpad-7','Numpad-8','Numpad-9','Numpad .','Numpad +','Numpad -','Numpad *','Numpad /',
{12}// 'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12',
       '','','','','','','','','','','','',
{10}   '1','2','3','4','5','6','7','8','9','0',
{26}   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
{10}   'Pad0','Pad1','Pad2','Pad3','Pad4','Pad5','Pad6','Pad7','Pad8','Pad9'
      );
  comandos_nes : array[0..77] of String =
{4 }  ('Up','Down','Left','Right',
{5 }   'Enter','Shift','Ctrl','Alt','Space',
{6 }   'Page up','Page down','End','Home','Insert','Delete',
{15}   'Num 0','Num 1','Num 2','Num 3','Num 4','Num 5','Num 6','Num 7','Num 8','Num 9','Num del','+','-','*','Num /',
{12}// 'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12',
       '','','','','','','','','','','','',
{10}   '1','2','3','4','5','6','7','8','9','0',
{26}   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
      );
  comandos_n64 : array[0..77] of String =
{4 }  ('C8','D0','CB','CD',
{5 }   '1C','2A','1D','38','39',
{6 }   'C9','D1','CF','C7','D2','D3',
{15}   '52','4F','50','51','4B','4C','4D','47','48','49','53','4E','4A','37','35',
{12}   '00','00','00','00','00','00','00','00','00','00','00','00',
{10}   '2','3','4','5','6','7','8','9','10','11',
{26}   '1E','30','2E','20','12','21','22','23','17','24','25','26','32','31','18','19','10','13','1F','14','16','2F','11','2D','15','2C'
      );

implementation

uses Genericas, Unit1, Mensagens;

//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Lista_Botoes_Controle(linha,player:String;tipo_controle:Integer):Boolean;
var
joy_emulador_fusion:TStringList;
begin
Result:=True;

joy_emulador_fusion:=TStringList.Create;
ExtractStrings([',',','],[' '],pchar(Copy(linha,Length(player)+1,Length(linha))),joy_emulador_fusion);

  if tipo_controle = 1 then
  begin
  //----------------------------------------------------------------
  UP.Text      :=converter_saidas(1,joy_emulador_fusion.Strings[0]);
  DOWN.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[1]);
  LEFT.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[2]);
  RIGHT.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[3]);
  botao_01.Text:=converter_saidas(1,joy_emulador_fusion.Strings[4]);
  botao_02.Text:=converter_saidas(1,joy_emulador_fusion.Strings[5]);
  botao_03.Text:=converter_saidas(1,joy_emulador_fusion.Strings[6]);
  START.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[7]);
  //----------------------------------------------------------------
  end;

  if tipo_controle = 2 then
  begin
  //----------------------------------------------------------------
  UP.Text      :=converter_saidas(1,joy_emulador_fusion.Strings[0]);
  DOWN.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[1]);
  LEFT.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[2]);
  RIGHT.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[3]);
  botao_09.Text:=converter_saidas(1,joy_emulador_fusion.Strings[4]);
  botao_01.Text:=converter_saidas(1,joy_emulador_fusion.Strings[5]);
  botao_03.Text:=converter_saidas(1,joy_emulador_fusion.Strings[6]);
  START.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[7]);
  botao_10.Text:=converter_saidas(1,joy_emulador_fusion.Strings[8]);
  botao_02.Text:=converter_saidas(1,joy_emulador_fusion.Strings[9]);
  botao_04.Text:=converter_saidas(1,joy_emulador_fusion.Strings[10]);
  SELECT.Text  :=converter_saidas(1,joy_emulador_fusion.Strings[11]);
  //----------------------------------------------------------------
  end;

  if tipo_controle = 3 then
  begin
  //----------------------------------------------------------------
  UP.Text      :=converter_saidas(1,joy_emulador_fusion.Strings[0]);
  DOWN.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[1]);
  LEFT.Text    :=converter_saidas(1,joy_emulador_fusion.Strings[2]);
  RIGHT.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[3]);
  botao_01.Text:=converter_saidas(1,joy_emulador_fusion.Strings[4]);
  botao_02.Text:=converter_saidas(1,joy_emulador_fusion.Strings[5]);
  START.Text   :=converter_saidas(1,joy_emulador_fusion.Strings[6]);
  //----------------------------------------------------------------
  end;
            
joy_emulador_fusion.Free;
end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function Verifica_Teclas_Validas(nome_form: TForm): Boolean;
var
i:Integer;
Componente:TabfEdit;
begin
Result:=True;

 for i := 0 to nome_form.ComponentCount -1 do
 begin
   if nome_form.Components[i] is TabfEdit then
   begin
   Componente:=nome_form.Components[i] as TabfEdit;
   Componente.Color:=clWhite;
      //-------------------------------------------
      if (Length(Componente.Text) = 0) then
      Componente.Text:=erro_tecla;
      //-------------------------------------------
      if ((Componente.Text = erro_tecla) and (Componente.Visible = True)) then
      begin
      Componente.Color:=HexToColor(erro_cor);
      Result:=False;
      end;
      //-------------------------------------------
   end;
 end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
procedure TForm2.Entra_Campo(Sender: TObject);
var
i: Integer;
cor_entrar,cor_sair,cor_erro: TColor;
begin
PostMessage(Handle, UM_HIDECARET, wparam(Sender), 0);

if Editar_Flag = True then
begin
 //---------------------------------------------------
 cor_entrar:=HexToColor(Copy(Array_Consoles[id_console_joy][7],0,6));
 cor_sair  :=HexToColor(Copy(Array_Consoles[id_console_joy][7],7,6));
 cor_erro  :=HexToColor(erro_cor);
 //---------------------------------------------------

    for i := 0 to ComponentCount-1 do
    begin
      if (Components[i] is TabfEdit) then
      begin
      //----------------------------------------------------
        if (TabfEdit(Components[i]).Color = cor_entrar) then
        TabfEdit(Components[i]).Color := clwhite;

        if (TabfEdit(Components[i]).Focused) and
           (TabfEdit(Components[i]).Color <> cor_erro) and
           (TabfEdit(Components[i]).Color <> cor_sair) then
        TabfEdit(Components[i]).Color := cor_entrar;
      //----------------------------------------------------
      end;
    end;
end
else
combobox_player.SetFocus;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
procedure TForm2.Solta_Tecla(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
//-------------------------------------------------------------
if (Key = VK_TAB) and (Length( TabfEdit(Sender).Text) >= 0) then
Exit;
//-------------------------------------------------------------

TabfEdit(Sender).Color:=HexToColor(Copy(Array_Consoles[id_console_joy][7],7,6));
Perform(WM_NEXTDLGCTL,0,0);
 
case Key of
 //--------------------------------------------------------------------------------------------------
  38: TabfEdit(Sender).Text:=comandos_teclado[0];    40: TabfEdit(Sender).Text:=comandos_teclado[1];
  37: TabfEdit(Sender).Text:=comandos_teclado[2];    39: TabfEdit(Sender).Text:=comandos_teclado[3];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
  13: TabfEdit(Sender).Text:=comandos_teclado[4];    16: TabfEdit(Sender).Text:=comandos_teclado[5];
  17: TabfEdit(Sender).Text:=comandos_teclado[6];    18: TabfEdit(Sender).Text:=comandos_teclado[7];
  32: TabfEdit(Sender).Text:=comandos_teclado[8];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
  33: TabfEdit(Sender).Text:=comandos_teclado[9];    34: TabfEdit(Sender).Text:=comandos_teclado[10];
  35: TabfEdit(Sender).Text:=comandos_teclado[11];   36: TabfEdit(Sender).Text:=comandos_teclado[12];
  45: TabfEdit(Sender).Text:=comandos_teclado[13];   46: TabfEdit(Sender).Text:=comandos_teclado[14];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
  96: TabfEdit(Sender).Text:=comandos_teclado[15];   97: TabfEdit(Sender).Text:=comandos_teclado[16];
  98: TabfEdit(Sender).Text:=comandos_teclado[17];   99: TabfEdit(Sender).Text:=comandos_teclado[18];
 100: TabfEdit(Sender).Text:=comandos_teclado[19];  101: TabfEdit(Sender).Text:=comandos_teclado[20];
 102: TabfEdit(Sender).Text:=comandos_teclado[21];  103: TabfEdit(Sender).Text:=comandos_teclado[22];
 104: TabfEdit(Sender).Text:=comandos_teclado[23];  105: TabfEdit(Sender).Text:=comandos_teclado[24];
 110: TabfEdit(Sender).Text:=comandos_teclado[25];  107: TabfEdit(Sender).Text:=comandos_teclado[26];
 109: TabfEdit(Sender).Text:=comandos_teclado[27];  106: TabfEdit(Sender).Text:=comandos_teclado[28];
 111: TabfEdit(Sender).Text:=comandos_teclado[29];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
 112: TabfEdit(Sender).Text:=comandos_teclado[30];  113: TabfEdit(Sender).Text:=comandos_teclado[31];
 114: TabfEdit(Sender).Text:=comandos_teclado[32];  115: TabfEdit(Sender).Text:=comandos_teclado[33];
 116: TabfEdit(Sender).Text:=comandos_teclado[34];  117: TabfEdit(Sender).Text:=comandos_teclado[35];
 118: TabfEdit(Sender).Text:=comandos_teclado[36];  119: TabfEdit(Sender).Text:=comandos_teclado[37];
 120: TabfEdit(Sender).Text:=comandos_teclado[38];  121: TabfEdit(Sender).Text:=comandos_teclado[39];
 122: TabfEdit(Sender).Text:=comandos_teclado[40];  123: TabfEdit(Sender).Text:=comandos_teclado[41];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
  49: TabfEdit(Sender).Text:=comandos_teclado[42];   50: TabfEdit(Sender).Text:=comandos_teclado[43];
  51: TabfEdit(Sender).Text:=comandos_teclado[44];   52: TabfEdit(Sender).Text:=comandos_teclado[45];
  53: TabfEdit(Sender).Text:=comandos_teclado[46];   54: TabfEdit(Sender).Text:=comandos_teclado[47];
  55: TabfEdit(Sender).Text:=comandos_teclado[48];   56: TabfEdit(Sender).Text:=comandos_teclado[49];
  57: TabfEdit(Sender).Text:=comandos_teclado[50];   48: TabfEdit(Sender).Text:=comandos_teclado[51];
 //--------------------------------------------------------------------------------------------------

 //--------------------------------------------------------------------------------------------------
 65..90: TabfEdit(Sender).Text:=comandos_teclado[(Key-13)];
 //--------------------------------------------------------------------------------------------------
 else
 TabfEdit(Sender).Text:=erro_tecla;
end;

if TabfEdit(Sender).Text = erro_tecla then
begin
TabfEdit(Sender).Color:=HexToColor(erro_cor);
TabfEdit(Sender).SetFocus;
TabfEdit(Sender).SelStart:=0;
end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
procedure TForm2.UMHideCaret(var msg: TUMHideCaret);
begin
HideCaret(msg.control.Handle);
end;

 function GetCharFromVirtualKey(Key: Word): string;
 var
    keyboardState: TKeyboardState;
    asciiResult: Integer;
 begin
    GetKeyboardState(keyboardState) ;
 
    SetLength(Result, 2) ;
    asciiResult := ToAscii(key, MapVirtualKey(key, 0), keyboardState, @Result[1], 0) ;
    case asciiResult of
      0: Result := '';
      1: SetLength(Result, 1) ;
      2:;
      else
        Result := '';
    end;
 end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function Captura_Valor_Tecla(console:Integer;linha_arquivo,botao:String):String;
begin
{SUPER NINTENDO - PLAYSTATION}
if console = 2 then
Result:=Copy(linha_arquivo,Pos('=',linha_arquivo)+1,Length(linha_arquivo)+Pos(':'+botao,linha_arquivo)+1);

{NINTENDO}
if console = 3 then
Result:=Copy(linha_arquivo,Pos('>',linha_arquivo)+1,Length(Trim(linha_arquivo))-(Length('<'+botao+'>')*2)-1);

{NINTENDO 64}
if console = 7 then
//Result:=Copy(linha_arquivo,Pos('=',linha_arquivo)+1,Length(linha_arquivo)-Pos('=',linha_arquivo));
Result:=Copy(linha_arquivo,Pos('} ',linha_arquivo)+1,Length(linha_arquivo)-Pos('} ',linha_arquivo));
end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.converter_saidas(modelo_teclas:Integer;comando:String):String;
begin
//---------------------
//1 - LISTAR CONTROLES
//---------------------

{MEGA DRIVE - PLAYSTATION - NINTENDO64}
if (modelo_teclas = 1) then
begin
   case AnsiIndexStr(Trim(comando),comandos_fusion) of
   0..77: Result:=comandos_teclado[AnsiIndexStr(Trim(comando),comandos_fusion)];
   else
   Result:=erro_tecla;
   end;
end;

{SUPER NINTENDO}
if (modelo_teclas = 2) then
begin
   case AnsiIndexStr(Trim(comando),comandos_snes) of
    0..77: Result:=comandos_teclado[AnsiIndexStr(Trim(comando),comandos_snes)];
   78..87: Result:=comandos_teclado[AnsiIndexStr(Trim(comando),comandos_snes)-63]; //OLHAR AQUI
   else
   Result:=erro_tecla;
   end;
end;

{NINTENDO}
if (modelo_teclas = 3) then
begin
   case AnsiIndexStr(Trim(comando),comandos_nes) of
   0..77: Result:=comandos_teclado[AnsiIndexStr(Trim(comando),comandos_nes)];
   else
   Result:=erro_tecla;
   end;
end;

{NINTENDO64}
if (modelo_teclas = 4) then
begin
   case AnsiIndexStr(Trim(comando),comandos_n64) of
   0..77: Result:=comandos_teclado[AnsiIndexStr(Trim(comando),comandos_n64)];
   else
   Result:=erro_tecla;
   end;
end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.converter_entradas(modelo_teclas:Integer;comando:String):String;
begin
//---------------------
//2 - GRAVAR CONTROLES
//---------------------

{MEGA DRIVE - PLAYSTATION}
if (modelo_teclas = 1) then
begin
   case AnsiIndexStr(Trim(comando),comandos_teclado) of
   0..77: Result:=comandos_fusion[AnsiIndexStr(Trim(comando),comandos_teclado)];
   end;
end;

{SUPER NINTENDO}
if (modelo_teclas = 2) then
begin
   case AnsiIndexStr(Trim(comando),comandos_teclado) of
   0..77: Result:=comandos_snes[AnsiIndexStr(Trim(comando),comandos_teclado)];
   end;
end;

{NINTENDO}
if (modelo_teclas = 3) then
begin
   case AnsiIndexStr(Trim(comando),comandos_teclado) of
   0..77: Result:=comandos_nes[AnsiIndexStr(Trim(comando),comandos_teclado)];
   end;
end;

{NINTENDO64}
if (modelo_teclas = 4) then
begin
   case AnsiIndexStr(Trim(comando),comandos_teclado) of
   0..77: Result:=comandos_n64[AnsiIndexStr(Trim(comando),comandos_teclado)];
   end;
end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Padrao_Controle_Genesis(JoystickType:Integer):Boolean;
begin
Result:=True;

case JoystickType of
1: begin
   {CASO ESTEJA EDITANDO}
   //------------------------------------------
   if (Panel_Controle_Tipo.Visible = True) then
   begin
     //----------------------------------------------
     //AO GRAVAR, VERIFICA EM QUAL LAYOUT DE CONTROLE
     //----------------------------------------------
     controle_genesis_2:=JoystickType;
     //----------------------------------------------
   controle_tipo.ItemIndex:=0;
   botao_02.Text:=botao_01.Text;
   botao_01.Text:=botao_09.Text;
   end;
   //------------------------------------------

   {APAGA OS BOTÕES ADICIONAIS}
   //----------------------------
   joy_segacd.Visible:=False;
   texto_botao_09.Visible:=False;
   texto_botao_10.Visible:=False;
   texto_botao_04.Visible:=False;
   texto_botao_08.Visible:=False;
   botao_09.Visible:=False;
   botao_10.Visible:=False;
   botao_04.Visible:=False;
   SELECT.Visible:=False;
   //----------------------------

   {CONFIGURA A APARÊNCIA DO CONTROLE - 3 BOTÕES}
   //---------------------------
   joy_mega.Visible:=True;
   //---------------------------
   texto_botao_01.Caption:='A:';
   texto_botao_02.Caption:='B:';
   texto_botao_03.Caption:='C:';
   //---------------------------
   botao_01.Top:=34;
   botao_02.Top:=botao_01.Top;
   botao_03.Top:=58;
   texto_botao_01.Top:=botao_01.Top+4;
   texto_botao_02.Top:=botao_02.Top+4;
   texto_botao_03.Top:=botao_03.Top+4;
   //---------------------------
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   botao_03.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   texto_botao_03.Visible:=True;
   //---------------------------
   start_select(True);
   //---------------------------
   botao_01.TabOrder:=0;
   botao_02.TabOrder:=1;
   botao_03.TabOrder:=2;
   START.TabOrder:=3;
   //---------------------------
   end;
2: begin
   {CASO ESTEJA EDITANDO}
   //------------------------------------------
   if (Panel_Controle_Tipo.Visible = True) then
   begin
     //----------------------------------------------
     //AO GRAVAR, VERIFICA EM QUAL LAYOUT DE CONTROLE
     //----------------------------------------------
     controle_genesis_2:=JoystickType;
     //----------------------------------------------
   controle_tipo.ItemIndex:=1;
   botao_09.Text:=botao_01.Text;
   botao_01.Text:=botao_02.Text;
   botao_02.Clear; 
   end;
   //------------------------------------------

   {APAGA OS BOTÕES ADICIONAIS}
   //----------------------------
   joy_mega.Visible:=False;
   //----------------------------

   {CONFIGURA A APARÊNCIA DO CONTROLE - 6 BOTÕES}
   //---------------------------
   joy_segacd.Visible:=True;
   //---------------------------
   texto_botao_09.Caption:='A:';
   texto_botao_10.Caption:='X:';
   texto_botao_01.Caption:='B:';
   texto_botao_02.Caption:='Y:';
   texto_botao_03.Caption:='C:';
   texto_botao_04.Caption:='Z:';
   texto_botao_08.Caption:='MODE';
   //---------------------------
   botao_09.Top:=10;
   botao_10.Top:=botao_09.Top;
   botao_01.Top:=34;
   botao_02.Top:=botao_01.Top;
   botao_03.Top:=58;
   botao_04.Top:=botao_03.Top;
   texto_botao_09.Top:=botao_09.Top+4;
   texto_botao_10.Top:=botao_10.Top+4;
   texto_botao_01.Top:=botao_01.Top+4;
   texto_botao_02.Top:=botao_02.Top+4;
   texto_botao_03.Top:=botao_03.Top+4;
   texto_botao_04.Top:=botao_04.Top+4;
   //---------------------------
   botao_09.Visible:=True;
   botao_10.Visible:=True;
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   botao_03.Visible:=True;
   botao_04.Visible:=True;
   texto_botao_09.Visible:=True;
   texto_botao_10.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   texto_botao_03.Visible:=True;
   texto_botao_04.Visible:=True;
   //---------------------------
   start_select(False);
   //---------------------------
   botao_09.TabOrder:=0;
   botao_10.TabOrder:=3;
   botao_01.TabOrder:=1;
   botao_02.TabOrder:=4;
   botao_03.TabOrder:=2;
   botao_04.TabOrder:=5;
   //---------------------------
   START.TabOrder:=6;
   SELECT.TabOrder:=7;
   //---------------------------
   end;
end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Padrao_Controle_Geral(JoyPad:Integer):Boolean;
begin

case JoyPad of
2: begin
   joy_snes.Visible:=True;
   //---------------------------
   texto_botao_09.Caption:='L:';
   texto_botao_10.Caption:='R:';
   texto_botao_01.Caption:='Y:';
   texto_botao_02.Caption:='X:';
   texto_botao_03.Caption:='B:';
   texto_botao_04.Caption:='A:';
   texto_botao_08.Caption:='SELECT';
   //---------------------------
   botao_09.Top:=botao_09.Top+8;
   botao_10.Top:=botao_10.Top+8;
   botao_01.Top:=botao_01.Top+8;
   botao_02.Top:=botao_02.Top+8;
   botao_03.Top:=botao_03.Top+8;
   botao_04.Top:=botao_04.Top+8;
   texto_botao_09.Top:=botao_09.Top+4;
   texto_botao_10.Top:=botao_10.Top+4;
   texto_botao_01.Top:=botao_01.Top+4;
   texto_botao_02.Top:=botao_02.Top+4;
   texto_botao_03.Top:=botao_03.Top+4;
   texto_botao_04.Top:=botao_04.Top+4;
   //--------------------------
   botao_09.Visible:=True;
   botao_10.Visible:=True;
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   botao_03.Visible:=True;
   botao_04.Visible:=True;
   texto_botao_09.Visible:=True;
   texto_botao_10.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   texto_botao_03.Visible:=True;
   texto_botao_04.Visible:=True;
   //---------------------------
   start_select(False);
   //---------------------------
   botao_01.TabOrder:=0;
   botao_02.TabOrder:=1;
   botao_03.TabOrder:=2;
   botao_04.TabOrder:=3;
   botao_09.TabOrder:=4;
   botao_10.TabOrder:=5;
   //---------------------------
   START.TabOrder:=6;
   SELECT.TabOrder:=7;
   //---------------------------
   Result:=True;
   end;
3: begin
   joy_nes.Visible:=True;
   //---------------------------
   texto_botao_01.Caption:='B:';
   texto_botao_02.Caption:='A:';
   //---------------------------
   botao_01.Top:=botao_01.Top+8;
   botao_02.Top:=botao_02.Top+8;
   texto_botao_01.Top:=botao_01.Top+4;
   texto_botao_02.Top:=botao_02.Top+4;
   //---------------------------
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   //---------------------------
   start_select(False);
   //---------------------------
   botao_01.TabOrder:=0;
   botao_02.TabOrder:=1;
   //---------------------------
   START.TabOrder:=2;
   SELECT.TabOrder:=3;
   //---------------------------
   Result:=True;
   end;
4: begin
   joy_master.Visible:=True;
   //---------------------------
   texto_botao_01.Caption:='1:';
   texto_botao_02.Caption:='2:';
   //---------------------------
   botao_01.Top:=botao_01.Top+8;
   botao_02.Top:=botao_02.Top+8;
   texto_botao_01.Top:=botao_01.Top+4;
   texto_botao_02.Top:=botao_02.Top+4;
   //---------------------------
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   //---------------------------
   start_select(True);
   //---------------------------
   botao_01.TabOrder:=0;
   botao_02.TabOrder:=1;
   START.TabOrder:=2;
   //---------------------------
   Result:=True;
   end;
6: begin
   joy_ps1.Visible:=True;
   //-----------------------------------------
   texto_botao_01.Caption:='L1:';
   texto_botao_02.Caption:='R1:';
   texto_botao_03.Caption:=':';
   texto_botao_04.Caption:=':';
   texto_botao_05.Caption:=':';
   texto_botao_06.Caption:=':';
   texto_botao_08.Caption:='SELECT';
   texto_botao_09.Caption:='L2:';
   texto_botao_10.Caption:='R2:';
   texto_botao_01.Left:=texto_botao_01.Left-3;
   texto_botao_02.Left:=texto_botao_02.Left-3;
   texto_botao_03.Left:=texto_botao_03.Left+9;
   texto_botao_04.Left:=texto_botao_04.Left+9;
   texto_botao_05.Left:=texto_botao_05.Left+9;
   texto_botao_06.Left:=texto_botao_06.Left+9;
   texto_botao_09.Left:=texto_botao_01.Left;
   texto_botao_10.Left:=texto_botao_02.Left;
   //-----------------------------------------
   ps1_quadrado.Left :=texto_botao_03.Left-21;
   ps1_quadrado.Top  :=texto_botao_03.Top-2;
   ps1_triangulo.Left:=texto_botao_04.Left-21;
   ps1_triangulo.Top :=texto_botao_04.Top-2;
   ps1_x.Left        :=texto_botao_05.Left-21;
   ps1_x.Top         :=texto_botao_05.Top-2;
   ps1_bola.Left     :=texto_botao_06.Left-21;
   ps1_bola.Top      :=texto_botao_06.Top-2;
   //-----------------------------------------
   START.Top:=START.Top+8;
   SELECT.Top:=SELECT.Top+8;
   //-----------------------------------------
   texto_botao_07.Top:=texto_botao_07.Top+8;
   texto_botao_08.Top:=texto_botao_08.Top+8;
   //-----------------------------------------
   ps1_quadrado.Visible:=True;
   ps1_triangulo.Visible:=True;
   ps1_x.Visible:=True;
   ps1_bola.Visible:=True;
   //-----------------------------------------
   botao_01.Visible:=True;
   botao_02.Visible:=True;
   botao_03.Visible:=True;
   botao_04.Visible:=True;
   botao_05.Visible:=True;
   botao_06.Visible:=True;
   botao_09.Visible:=True;
   botao_10.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_02.Visible:=True;
   texto_botao_03.Visible:=True;
   texto_botao_04.Visible:=True;
   texto_botao_05.Visible:=True;
   texto_botao_06.Visible:=True;
   texto_botao_09.Visible:=True;
   texto_botao_10.Visible:=True;
   //-----------------------------------------
   start_select(False);
   //-----------------------------------------
   botao_03.TabOrder:=0;
   botao_04.TabOrder:=1;
   botao_05.TabOrder:=2;
   botao_06.TabOrder:=3;
   botao_01.TabOrder:=4;
   botao_09.TabOrder:=5;
   botao_02.TabOrder:=6;
   botao_10.TabOrder:=7;
   //-----------------------------------------
   START.TabOrder:=8;
   SELECT.TabOrder:=9;
   //-----------------------------------------
   Result:=True;
   end;
7: begin
   joy_n64.Visible:=True;
   //---------------------------
   texto_botao_09.Caption:='L:';
   texto_botao_10.Caption:='R:';
   texto_botao_01.Caption:='B:';
   texto_botao_03.Caption:='A:';
   texto_botao_08.Caption:='Z';
   //---------------------------
   texto_botao_01.Top:=texto_botao_01.Top+16;
   texto_botao_03.Top:=texto_botao_03.Top+16;
   botao_01.Top:=botao_01.Top+16;
   botao_03.Top:=botao_03.Top+16;
   Panel_C_Botoes.Top:=275;
   //---------------------------
   texto_botao_09.Visible:=True;
   texto_botao_10.Visible:=True;
   texto_botao_01.Visible:=True;
   texto_botao_03.Visible:=True;
   Panel_C_Botoes.Visible:=True;
   Form2.Width:=550;
   Form2.Height:=479;
   //---------------------------
   botao_09.Visible:=True;
   botao_10.Visible:=True;
   botao_01.Visible:=True;
   botao_03.Visible:=True;
   //---------------------------
   start_select(False);
   //---------------------------
   botao_01.TabOrder:=0;
   botao_03.TabOrder:=1;
   botao_09.TabOrder:=2;
   botao_10.TabOrder:=3;
   //---------------------------
   START.TabOrder:=4;
   SELECT.TabOrder:=5;
   START.Top:=375;
   SELECT.Top:=375;
   texto_botao_07.Top:=361;
   texto_botao_08.Top:=361;
   //---------------------------
   combobox_player.Items.Add('PLAYER 3');
   combobox_player.Items.Add('PLAYER 4');
   //---------------------------
   Result:=True;
   end;
 else
 Result:=False;
end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Listar_Controles(player:Integer):Boolean;
var
i,posicao_controle: Integer;
player_select,nome_emulador:String;
begin
Inc(player);
posicao_controle:=0;
nome_emulador:=LowerCase(ChangeFileExt(ExtractFileName(Array_Consoles[id_console_joy][6]),''));

  //------------------------------
  //-- INICIO - FOR ARQUIVO INI --
  //------------------------------
  for i:= 0 to arquivo_ini_fisico.Count -1 do
  begin
    {EMULADOR FUSION - INICIO}
    //----------------------------------------------------------------------------------------------------------------------
    if (nome_emulador = 'fusion') then
    begin
     {CASE - INICIO}
     case id_console_joy of
        {MEGA DRIVE - INICIO}
        //--------------------------------------------------------------------
        1: begin
           player_select:='Player'+IntToStr(player)+'Keys=';
             if (Pos(player_select,arquivo_ini_fisico[i]) = 1) then
             posicao_controle:=i;
              //-----------------------------------------------------------------------------
              //CONTROLE 3 BOTÕES
              //-----------------------------------------------------------------------------
              if Pos('Joystick'+IntToStr(player)+'Type=1',arquivo_ini_fisico[i]) = 1 then
              begin
              Padrao_Controle_Genesis(1);
              Lista_Botoes_Controle(arquivo_ini_fisico[posicao_controle],player_select,1);
              end;
              //-----------------------------------------------------------------------------
              //CONTROLE 6 BOTÕES
              //-----------------------------------------------------------------------------
              if Pos('Joystick'+IntToStr(player)+'Type=2',arquivo_ini_fisico[i]) = 1 then
              begin
              Padrao_Controle_Genesis(2);
              Lista_Botoes_Controle(arquivo_ini_fisico[posicao_controle],player_select,2);
              end;
              //-----------------------------------------------------------------------------
           end;
        //--------------------------------------------------------------------
        {MEGA DRIVE - FIM}

        {MASTER SYSTEM - INICIO}
        //--------------------------------------------------------------------
        4: begin
           player_select:='Player'+IntToStr(player)+'MSKeys=';
              if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
              Lista_Botoes_Controle(arquivo_ini_fisico[i],player_select,3);
           end;
        //--------------------------------------------------------------------
        {MASTER SYSTEM - FIM}

        {SEGA CD - INICIO}
        //--------------------------------------------------------------------
        5: begin
           player_select:='Player'+IntToStr(player)+'Keys=';
              if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
              begin
              Padrao_Controle_Genesis(2);
              Lista_Botoes_Controle(arquivo_ini_fisico[i],player_select,2);
              end;
           end;
        //--------------------------------------------------------------------
        {SEGA CD - FIM}

     end;
     {CASE - FIM}
    end;
    //----------------------------------------------------------------------------------------------------------------------
    {EMULADOR FUSION - FIM}

    {EMULADOR SNES9X - INICIO}
    //----------------------------------------------------------------------------------------------------------------------
    if (id_console_joy = 2) then
    begin
    player_select:='     Joypad'+IntToStr(player);

     //----------------------------------------------------------------------------------
     if Pos(player_select+':Up                   = ',arquivo_ini_fisico[i]) = 1 then
     UP.Text:=   converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Up'));
     if Pos(player_select+':Down                 = ',arquivo_ini_fisico[i]) = 1 then
     DOWN.Text:= converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Down'));
     if Pos(player_select+':Left                 = ',arquivo_ini_fisico[i]) = 1 then
     LEFT.Text:= converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Left'));
     if Pos(player_select+':Right                = ',arquivo_ini_fisico[i]) = 1 then
     RIGHT.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Right'));
     //----------------------------------------------------------------------------------
     if Pos(player_select+':A                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_04.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'A'));
     if Pos(player_select+':B                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_03.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'B'));
     if Pos(player_select+':Y                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_01.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Y'));
     if Pos(player_select+':X                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_02.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'X'));
     if Pos(player_select+':L                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_09.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'L'));
     if Pos(player_select+':R                    = ',arquivo_ini_fisico[i]) = 1 then
     botao_10.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'R'));
     //----------------------------------------------------------------------------------
     if Pos(player_select+':Start                = ',arquivo_ini_fisico[i]) = 1 then
     START.Text :=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Start'));
     if Pos(player_select+':Select               = ',arquivo_ini_fisico[i]) = 1 then
     SELECT.Text:=converter_saidas(2,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Select'));
     //----------------------------------------------------------------------------------
    end;
    //----------------------------------------------------------------------------------------------------------------------
    {EMULADOR SNES9X - FIM}

    {EMULADOR NESTOPIA - INICIO}
    //----------------------------------------------------------------------------------------------------------------------
    if (id_console_joy = 3) then
    begin
    player_select:='<pad-'+IntToStr(player)+'>';

     if Pos(player_select,Trim(arquivo_ini_fisico[i])) = 1 then
     begin
     //------------------------------------------------------------------------------------------
     botao_02.Text:=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 1],'a'     ));
     botao_01.Text:=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 4],'b'     ));
     DOWN.Text    :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 5],'down'  ));
     LEFT.Text    :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 6],'left'  ));
     RIGHT.Text   :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 8],'right' ));
     SELECT.Text  :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+ 9],'select'));
     START.Text   :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+10],'start' ));
     UP.Text      :=converter_saidas(3,Captura_Valor_Tecla(3,arquivo_ini_fisico[i+11],'up'    ));
     //------------------------------------------------------------------------------------------
     end;

    end;
    //----------------------------------------------------------------------------------------------------------------------
    {EMULADOR NESTOPIA - FIM}

    {EMULADOR PSXFIN - INICIO}
    //----------------------------------------------------------------------------------------------------------------------
    if (id_console_joy = 6) then
    begin
    player_select:='Key'+IntToStr(player);

     //------------------------------------------------------------------------------------
     if Pos(player_select+'Select=',arquivo_ini_fisico[i]) = 1 then
     SELECT.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Select'));
     if Pos(player_select+'Start=' ,arquivo_ini_fisico[i]) = 1 then
     START.Text :=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Start'));
     //------------------------------------------------------------------------------------
     if Pos(player_select+'Up='   ,arquivo_ini_fisico[i]) = 1 then
     UP.Text   :=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Up'));
     if Pos(player_select+'Right=',arquivo_ini_fisico[i]) = 1 then
     RIGHT.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Right'));
     if Pos(player_select+'Down=' ,arquivo_ini_fisico[i]) = 1 then
     DOWN.Text :=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Down'));
     if Pos(player_select+'Left=' ,arquivo_ini_fisico[i]) = 1 then
     LEFT.Text :=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Left'));
     //------------------------------------------------------------------------------------
     if Pos(player_select+'L2=',arquivo_ini_fisico[i]) = 1 then
     botao_09.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'L2'));
     if Pos(player_select+'R2=',arquivo_ini_fisico[i]) = 1 then
     botao_10.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'R2'));
     if Pos(player_select+'L1=',arquivo_ini_fisico[i]) = 1 then
     botao_01.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'L1'));
     if Pos(player_select+'R1=',arquivo_ini_fisico[i]) = 1 then
     botao_02.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'R1'));
     //------------------------------------------------------------------------------------
     if Pos(player_select+'Triangle=',arquivo_ini_fisico[i]) = 1 then
     botao_04.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Triangle'));
     if Pos(player_select+'Circle='  ,arquivo_ini_fisico[i]) = 1 then
     botao_06.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Circle'));
     if Pos(player_select+'Cross='   ,arquivo_ini_fisico[i]) = 1 then
     botao_05.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Cross'));
     if Pos(player_select+'Square='  ,arquivo_ini_fisico[i]) = 1 then
     botao_03.Text:=converter_saidas(1,Captura_Valor_Tecla(2,arquivo_ini_fisico[i],'Square'));
     //------------------------------------------------------------------------------------
    end;
    //----------------------------------------------------------------------------------------------------------------------
    {EMULADOR PSXFIN - FIM}

    {EMULADOR PROJECT64 - INICIO}
    //----------------------------------------------------------------------------------------------------------------------
    if (id_console_joy = 7) then
    begin
    //player_select:='[DirectInput-Controller '+IntToStr(player-1)+']';
    player_select:='[Input-Controller '+IntToStr(player-1)+']';

     if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
     begin
     //------------------------------------------------------------------------------------
     DOWN.Text    :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 1],''));
     LEFT.Text    :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 2],''));
     RIGHT.Text   :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 3],''));
     UP.Text      :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 4],''));
     //------------------------------------------------------------------------------------
{A}  botao_01.Text:=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 5],''));
{B}  botao_03.Text:=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 6],''));
{L}  botao_09.Text:=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 7],''));
{R}  botao_10.Text:=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 8],''));
     START.Text   :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+ 9],''));
{Z}  SELECT.Text  :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+10],''));
     //------------------------------------------------------------------------------------
     C_DOWN.Text  :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+11],''));
     C_LEFT.Text  :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+12],''));
     C_RIGHT.Text :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+13],''));
     C_UP.Text    :=converter_saidas(4,Captura_Valor_Tecla(7,arquivo_ini_fisico[i+14],''));
     //------------------------------------------------------------------------------------
     end;

    end;
    //----------------------------------------------------------------------------------------------------------------------
    {EMULADOR PROJECT64 - FIM}
  end;
  //---------------------------
  //-- FIM - FOR ARQUIVO INI --
  //---------------------------

Result:=Verifica_Teclas_Validas(Form2);
end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Editar_Controles(player:Integer):Boolean;
var
i: Integer;
player_select,nome_emulador:String;
begin
Inc(player);
nome_emulador:=LowerCase(ChangeFileExt(ExtractFileName(Array_Consoles[id_console_joy][6]),''));

  //------------------------------
  //-- INICIO - FOR ARQUIVO INI --
  //------------------------------
  for i:= 0 to arquivo_ini_fisico.Count -1 do
  begin
     {EMULADOR FUSION - INICIO}    
     //----------------------------------------------------------------------------------------------------------------------
     if (nome_emulador = 'fusion') then
     begin
        {CASE - INICIO}
        case id_console_joy of
        //-----------------------------------------------------------------------------------------------------
        {MEGA DRIVE - INICIO}
        1: begin
           player_select:='Player'+IntToStr(player)+'Keys=';
            if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
            begin
             //---------------------------------------------------------------------------------------------
             //GRAVA CONTROLE 3 BOTÕES
             //---------------------------------------------------------------------------------------------
             if controle_tipo.ItemIndex = 0 then
             arquivo_ini_fisico[i]:=player_select+converter_entradas(1,UP.Text)      +','+
                                                  converter_entradas(1,DOWN.Text)    +','+
                                                  converter_entradas(1,LEFT.Text)    +','+
                                                  converter_entradas(1,RIGHT.Text)   +','+
                                                  converter_entradas(1,botao_01.Text)+','+
                                                  converter_entradas(1,botao_02.Text)+','+
                                                  converter_entradas(1,botao_03.Text)+','+
                                                  converter_entradas(1,START.Text)   +',0,0,0,0,0,0,0,0';
             //---------------------------------------------------------------------------------------------
             //GRAVA CONTROLE 6 BOTÕES
             //---------------------------------------------------------------------------------------------
             if controle_tipo.ItemIndex = 1 then
             arquivo_ini_fisico[i]:=player_select+converter_entradas(1,UP.Text)      +','+
                                                  converter_entradas(1,DOWN.Text)    +','+
                                                  converter_entradas(1,LEFT.Text)    +','+
                                                  converter_entradas(1,RIGHT.Text)   +','+
                                                  converter_entradas(1,botao_09.Text)+','+
                                                  converter_entradas(1,botao_01.Text)+','+
                                                  converter_entradas(1,botao_03.Text)+','+
                                                  converter_entradas(1,START.Text)   +','+
                                                  converter_entradas(1,botao_10.Text)+','+
                                                  converter_entradas(1,botao_02.Text)+','+
                                                  converter_entradas(1,botao_04.Text)+','+
                                                  converter_entradas(1,SELECT.Text)  +',0,0,0,0';
             //---------------------------------------------------------------------------------------------
            end;
            //------------------------------------------------------------------------------------------------
            //GRAVA TIPO DE CONTROLE
            //------------------------------------------------------------------------------------------------
            if Pos('Joystick'+IntToStr(player)+'Type=',arquivo_ini_fisico[i]) = 1 then
            arquivo_ini_fisico[i]:='Joystick'+IntToStr(player)+'Type='+IntToStr(controle_tipo.ItemIndex+1);
            //------------------------------------------------------------------------------------------------
           end;
        //-----------------------------------------------------------------------------------------------------
        {MEGA DRIVE - FIM}

        {MASTER SYSTEM - INICIO}
        //-----------------------------------------------------------------------------------------------------
        4: begin
           player_select:='Player'+IntToStr(player)+'MSKeys=';
            if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
            arquivo_ini_fisico[i]:=player_select+converter_entradas(1,UP.Text)      +','+
                                                 converter_entradas(1,DOWN.Text)    +','+
                                                 converter_entradas(1,LEFT.Text)    +','+
                                                 converter_entradas(1,RIGHT.Text)   +','+
                                                 converter_entradas(1,botao_01.Text)+','+
                                                 converter_entradas(1,botao_02.Text)+','+
                                                 converter_entradas(1,START.Text)   +',0';
            //------------------------------------------------------------------------------------------------
            //GRAVA TIPO DE CONTROLE
            //------------------------------------------------------------------------------------------------
            if Pos('Joystick'+IntToStr(player)+'MSType=',arquivo_ini_fisico[i]) = 1 then
            arquivo_ini_fisico[i]:='Joystick'+IntToStr(player)+'MSType=1'; //CONTROL PAD
            //------------------------------------------------------------------------------------------------
           end;
        //-----------------------------------------------------------------------------------------------------
        {MASTER SYSTEM - FIM}

        {SEGA CD - INICIO}
        //-----------------------------------------------------------------------------------------------------
        5: begin
           player_select:='Player'+IntToStr(player)+'Keys=';
            if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
            arquivo_ini_fisico[i]:=player_select+converter_entradas(1,UP.Text)      +','+
                                                 converter_entradas(1,DOWN.Text)    +','+
                                                 converter_entradas(1,LEFT.Text)    +','+
                                                 converter_entradas(1,RIGHT.Text)   +','+
                                                 converter_entradas(1,botao_09.Text)+','+
                                                 converter_entradas(1,botao_01.Text)+','+
                                                 converter_entradas(1,botao_03.Text)+','+
                                                 converter_entradas(1,START.Text)   +','+
                                                 converter_entradas(1,botao_10.Text)+','+
                                                 converter_entradas(1,botao_02.Text)+','+
                                                 converter_entradas(1,botao_04.Text)+','+
                                                 converter_entradas(1,SELECT.Text)  +',0,0,0,0';
           end;
        //-----------------------------------------------------------------------------------------------------
        {SEGA CD - FIM}
        end;
        {CASE - FIM}
     end;
     //----------------------------------------------------------------------------------------------------------------------
     {EMULADOR FUSION - FIM}

     {EMULADOR SNES9X - INICIO}
     //----------------------------------------------------------------------------------------------------------------------
     if (id_console_joy = 2) then
     begin
     player_select:='     Joypad'+IntToStr(player);
      //--------------------------------------------------------------------------------------------
                      if Pos(player_select+':Enabled              = FALSE',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Enabled              = TRUE';
      //--------------------------------------------------------------------------------------------
                      if Pos(player_select+':Up                   = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Up                   = '+converter_entradas(2,UP.Text);
                      if Pos(player_select+':Down                 = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Down                 = '+converter_entradas(2,DOWN.Text);
                      if Pos(player_select+':Left                 = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Left                 = '+converter_entradas(2,LEFT.Text);
                      if Pos(player_select+':Right                = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Right                = '+converter_entradas(2,RIGHT.Text);
      //--------------------------------------------------------------------------------------------
                      if Pos(player_select+':A                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':A                    = '+converter_entradas(2,botao_04.Text);
                      if Pos(player_select+':B                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':B                    = '+converter_entradas(2,botao_03.Text);
                      if Pos(player_select+':Y                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Y                    = '+converter_entradas(2,botao_01.Text);
                      if Pos(player_select+':X                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':X                    = '+converter_entradas(2,botao_02.Text);
                      if Pos(player_select+':L                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':L                    = '+converter_entradas(2,botao_09.Text);
                      if Pos(player_select+':R                    = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':R                    = '+converter_entradas(2,botao_10.Text);
      //--------------------------------------------------------------------------------------------
                      if Pos(player_select+':Start                = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Start                = '+converter_entradas(2,START.Text);
                      if Pos(player_select+':Select               = ',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+':Select               = '+converter_entradas(2,SELECT.Text);
      //--------------------------------------------------------------------------------------------
     end;
     //----------------------------------------------------------------------------------------------------------------------
     {EMULADOR SNES9X - FIM}

     {EMULADOR NESTOPIA - INICIO}
     //----------------------------------------------------------------------------------------------------------------------
     if (id_console_joy = 3) then
     begin
     player_select:='<pad-'+IntToStr(player)+'>';

      if Pos(player_select,Trim(arquivo_ini_fisico[i])) = 1 then
      begin
      //---------------------------------------------------------------------------------------------------
      arquivo_ini_fisico[i+ 1]:='                <a>'     +converter_entradas(3,botao_02.Text)+'</a>';
      arquivo_ini_fisico[i+ 4]:='                <b>'     +converter_entradas(3,botao_01.Text)+'</b>';
      arquivo_ini_fisico[i+ 5]:='                <down>'  +converter_entradas(3,DOWN.Text)    +'</down>';
      arquivo_ini_fisico[i+ 6]:='                <left>'  +converter_entradas(3,LEFT.Text)    +'</left>';
      arquivo_ini_fisico[i+ 8]:='                <right>' +converter_entradas(3,RIGHT.Text)   +'</right>';
      arquivo_ini_fisico[i+ 9]:='                <select>'+converter_entradas(3,SELECT.Text)  +'</select>';
      arquivo_ini_fisico[i+10]:='                <start>' +converter_entradas(3,START.Text)   +'</start>';
      arquivo_ini_fisico[i+11]:='                <up>'    +converter_entradas(3,UP.Text)      +'</up>';
      //---------------------------------------------------------------------------------------------------
      end;

     end;
     //----------------------------------------------------------------------------------------------------------------------
     {EMULADOR NESTOPIA - FIM}

     {EMULADOR PSXFIN - INICIO}
     //----------------------------------------------------------------------------------------------------------------------
     if (id_console_joy = 6) then
     begin
     player_select:='Key'+IntToStr(player);
      //------------------------------------------------------------------------------------
                      if Pos(player_select+'Select=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'Select='+converter_entradas(1,SELECT.Text);
                      if Pos(player_select+'Start=' ,arquivo_ini_fisico[i])  = 1 then
      arquivo_ini_fisico[i]:=player_select+'Start=' +converter_entradas(1,START.Text);
      //------------------------------------------------------------------------------------
                      if Pos(player_select+'Up='   ,arquivo_ini_fisico[i])  = 1 then
      arquivo_ini_fisico[i]:=player_select+'Up='   +converter_entradas(1,UP.Text);
                      if Pos(player_select+'Right=',arquivo_ini_fisico[i])  = 1 then
      arquivo_ini_fisico[i]:=player_select+'Right='+converter_entradas(1,RIGHT.Text);
                      if Pos(player_select+'Down=' ,arquivo_ini_fisico[i])  = 1 then
      arquivo_ini_fisico[i]:=player_select+'Down=' +converter_entradas(1,DOWN.Text);
                      if Pos(player_select+'Left=' ,arquivo_ini_fisico[i])  = 1 then
      arquivo_ini_fisico[i]:=player_select+'Left=' +converter_entradas(1,LEFT.Text);
      //------------------------------------------------------------------------------------
                      if Pos(player_select+'L2=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'L2='+converter_entradas(1,botao_09.Text);
                      if Pos(player_select+'R2=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'R2='+converter_entradas(1,botao_10.Text);
                      if Pos(player_select+'L1=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'L1='+converter_entradas(1,botao_01.Text);
                      if Pos(player_select+'R1=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'R1='+converter_entradas(1,botao_02.Text);
      //------------------------------------------------------------------------------------
                      if Pos(player_select+'Triangle=',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'Triangle='+converter_entradas(1,botao_04.Text);
                      if Pos(player_select+'Circle='  ,arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'Circle='  +converter_entradas(1,botao_06.Text);
                      if Pos(player_select+'Cross='   ,arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'Cross='   +converter_entradas(1,botao_05.Text);
                      if Pos(player_select+'Square='  ,arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:=player_select+'Square='  +converter_entradas(1,botao_03.Text);
      //------------------------------------------------------------------------------------
      if Pos('Controller'+IntToStr(player)+'Type=-1',arquivo_ini_fisico[i]) = 1 then
      arquivo_ini_fisico[i]:='Controller'+IntToStr(player)+'Type=0';
      //------------------------------------------------------------------------------------
     end;
     //----------------------------------------------------------------------------------------------------------------------
     {PSXFIN - PLAYSTATION - FIM}

     {EMULADOR PROJECT64 - INICIO}
     //----------------------------------------------------------------------------------------------------------------------
     if (id_console_joy = 7) then
     begin
     player_select:='[DirectInput-Controller '+IntToStr(player-1)+']';

      if Pos(player_select,arquivo_ini_fisico[i]) = 1 then
      begin
      //--------------------------------------------------------------------------
      arquivo_ini_fisico[i+ 1]:='A='+converter_entradas(1,botao_01.Text);
      arquivo_ini_fisico[i+ 2]:='Analog Down=' +converter_entradas(1,DOWN.Text);
      arquivo_ini_fisico[i+ 3]:='Analog Left=' +converter_entradas(1,LEFT.Text);
      arquivo_ini_fisico[i+ 4]:='Analog Right='+converter_entradas(1,RIGHT.Text);
      arquivo_ini_fisico[i+ 5]:='Analog Up='   +converter_entradas(1,UP.Text);
      //--------------------------------------------------------------------------
      arquivo_ini_fisico[i+ 6]:='B='+converter_entradas(1,botao_03.Text);
      //--------------------------------------------------------------------------
      arquivo_ini_fisico[i+ 7]:='C-Down=' +converter_entradas(1,C_DOWN.Text);
      arquivo_ini_fisico[i+ 8]:='C-Left=' +converter_entradas(1,C_LEFT.Text);
      arquivo_ini_fisico[i+ 9]:='C-Right='+converter_entradas(1,C_RIGHT.Text);
      arquivo_ini_fisico[i+10]:='C-Up='   +converter_entradas(1,C_UP.Text);
      //--------------------------------------------------------------------------
      arquivo_ini_fisico[i+17]:='L='    +converter_entradas(1,botao_09.Text);
      if (arquivo_ini_fisico[i+18] = 'Present=0') then
          arquivo_ini_fisico[i+18]:= 'Present=1';
      arquivo_ini_fisico[i+19]:='R='    +converter_entradas(1,botao_10.Text);
      arquivo_ini_fisico[i+21]:='Start='+converter_entradas(1,START.Text);
      arquivo_ini_fisico[i+23]:='Z='    +converter_entradas(1,SELECT.Text);
      //--------------------------------------------------------------------------
      end;

     end;
     //----------------------------------------------------------------------------------------------------------------------
     {EMULADOR PROJECT64 - FIM}
  end;
  //---------------------------
  //-- FIM - FOR ARQUIVO INI --
  //---------------------------

Result:=Verifica_Teclas_Validas(Form2);

//----------------------------------------------------------------------------------------------
if Result = False then
MessageBox(Application.Handle,pchar(aviso_campos),pchar(Application.Title),MB_ICONWARNING+MB_OK)
else
begin
Editar_Flag:=False;
arquivo_ini_fisico.SaveToFile(arquivo_ini_joy);

 //---------------------------------------------------------------------------------------------
 //COPIA PARA O ARQUIVO CONFIG INDIVIDUAL - MEGA DRIVE, MASTER SYSTEM, SEGA CD - EMULADOR FUSION
 //---------------------------------------------------------------------------------------------
 if (LowerCase(ExtractName(Array_Consoles[id_console][6])) = 'fusion') then
 FileCopy(arquivo_ini_joy,Config_Fusion_MultiConsole);
 //---------------------------------------------------------------------------------------------

end;
//----------------------------------------------------------------------------------------------

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.start_select(botoes:Boolean):Boolean;
begin

 if (botoes = True) then
 begin
 //----------------------------------------------------------------
 //START
 //----------------------------------------------------------------
 texto_botao_07.Left:=(Self.Width-texto_botao_07.Width) div 2;
 texto_botao_07.Visible:=True;
 {}
 START.Left:=(Self.Width-START.Width) div 2;
 START.Visible:=True;
 //----------------------------------------------------------------
 end
 else
 begin
 //----------------------------------------------------------------
 //START
 //----------------------------------------------------------------
 texto_botao_07.Left:=((Self.Width-texto_botao_07.Width) div 2)-50;
 texto_botao_07.Visible:=True;
 {}
 START.Left:=((Self.Width-START.Width) div 2)-50;
 START.Visible:=True;
 //----------------------------------------------------------------
 //SELECT
 //----------------------------------------------------------------
 texto_botao_08.Left:=((Self.Width-texto_botao_08.Width) div 2)+50;
 texto_botao_08.Visible:=True;
 {}
 SELECT.Left:=((Self.Width-SELECT.Width) div 2)+50;
 SELECT.Visible:=True;
 //----------------------------------------------------------------
 end;

Result:=botoes;
end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
function TForm2.Limpar_Campos(limpar,colorir:Boolean):Boolean;
var
i: Integer;
begin
Result:=True;

 for i:= 0 to ComponentCount - 1 do
 begin
   if(Components[i] is TabfEdit) then
   begin
     //LIMPAR CONTEÚDO DOS CAMPOS
     if (limpar = True) then
     (Components[i] as TabfEdit).Clear;
     //LIMPAR COR DOS CAMPOS
     if (colorir = True) then
     (Components[i] as TabfEdit).Color:=clWhite;
   end;
 end;

end;
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
var
i:Integer;
begin
Form2.Caption:=Application.Title+' - CONFIGURAR CONTROLES';
//------------------------------------------
Padrao_Controle_Geral(id_console_joy);
Listar_Controles(combobox_player.ItemIndex);
//------------------------------------------

 //---------------------------------------------------
 for i := 0 to ComponentCount-1 do
 begin
   if (Components[i] is TabfEdit) then
   begin
   (Components[i] as TabfEdit).OnEnter := Entra_Campo;
   (Components[i] as TabfEdit).OnKeyUp := Solta_Tecla;
   end;
 end;
 //---------------------------------------------------

end;

procedure TForm2.controle_tipoClick(Sender: TObject);
begin
Limpar_Campos(False,True);

//-------------------------------
//APAGA OS BOTÔES: X, Y, Z e MODE
//-------------------------------
if botao_10.Visible = False then
botao_10.Clear;
//-------------------------------
if botao_04.Visible = False then
botao_04.Clear;
//-------------------------------
if SELECT.Visible   = False then
SELECT.Clear;
//-------------------------------

case controle_tipo.ItemIndex of
0: Padrao_Controle_Genesis(1);
1: Padrao_Controle_Genesis(2);
end;

end;

procedure TForm2.combobox_playerChange(Sender: TObject);
begin
Listar_Controles(combobox_player.ItemIndex);
end;

procedure TForm2.btn_editarClick(Sender: TObject);
begin
//----------------
Editar_Flag:=True;
//----------------

btn_gravar.Enabled:=True;
btn_editar.Enabled:=False;
combobox_player.Enabled:=False;
StatusBar1.Panels[0].Text:='Pressione a tecla desejada...';
UP.SetFocus;

//---------------------------------
{CASO SEJA O MEGA DRIVE - TEM 2 TIPOS DE JOYSTICK}
if id_console_joy = 1 then
begin

  if joy_mega.Visible = True then  //DANDO PAU AQUI PRA DEFINIR, POIS QUANDO MUDA< ELE ACIONA O ONCLICK
  controle_tipo.ItemIndex:=0;

  if joy_segacd.Visible = True then
  controle_tipo.ItemIndex:=1;

Panel_Controle_Tipo.Visible:=True;
end;
//---------------------------------
end;

procedure TForm2.btn_gravarClick(Sender: TObject);
begin

 if Editar_Controles(combobox_player.ItemIndex) = True then
 begin
 btn_gravar.Enabled:=False;
 btn_editar.Enabled:=True;
 Panel_Controle_Tipo.Visible:=False;
 combobox_player.Enabled:=True;
 StatusBar1.Panels[0].Text:='';
 combobox_player.SetFocus;
 end;

end;

procedure TForm2.Sair1Click(Sender: TObject);
begin
Close;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
showmessage(inttostr(botao_01.Top)+inttostr(RIGHT.Top));
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

 if Editar_Flag = False then
 begin
 //------------
 Form2.Release;
 Form2:=Nil;
 //------------
 end
 else
 begin
    //CASE - INICIO
    case MessageBox(Application.Handle,pchar(Mensagens_Publicas(7)),pchar(Application.Title),MB_ICONWARNING+MB_YESNOCANCEL+MB_DEFBUTTON2) of
    idYes:
         begin
          if Editar_Controles(combobox_player.ItemIndex) = True then
          begin
          arquivo_ini_fisico.Free;
          //------------
          Form2.Release;
          Form2:=Nil;
          //------------
          end
          else
          CanClose:=False;
         end;
    idNo :
         begin
         Editar_Flag:=False;
         arquivo_ini_fisico.Free;
         //------------
         Form2.Release;
         Form2:=Nil;
         //------------
         end;
idCancel :
         CanClose:=False;
    end;
    //CASE - FIM
 end;

end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

end.
