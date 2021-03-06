unit View.ToastAlert;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Buttons,
  Helper.GlobalFunctions;

type
  TViewToastAlert = class(TForm)
    pnl_body: TPanel;
    pnl_image: TPanel;
    img_icone: TImage;
    lbl_titulo: TLabel;
    lbl_mensagem: TLabel;
    img_fechar: TImage;
    pnl_bar: TPanel;
    pnl_progress: TPanel;
    timer_show: TTimer;
    timer_close: TTimer;
    procedure img_fecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timer_showTimer(Sender: TObject);
    procedure timer_closeTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }


    var
      FTypeAlert : TTypeAlert;
      FTop,
      FLeft      : Integer;

  end;

var
  ViewToastAlert: TViewToastAlert;

implementation

{$R *.dfm}

procedure TViewToastAlert.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action          :=  caFree;
  ViewToastAlert  :=  nil;

end;

procedure TViewToastAlert.FormCreate(Sender: TObject);
begin

  FTop      :=  60;
  FLeft     :=  Screen.PrimaryMonitor.Width - Width - 20;
  Self.Top  :=  FTop;
  Self.Left :=  FLeft;

end;

procedure TViewToastAlert.FormShow(Sender: TObject);
begin

  case FTypeAlert of
    taSuccess: begin
                 pnl_body.Color   :=  $008CBC00;
                 pnl_image.Color  :=  $008CBC00;
                 img_icone.Picture.LoadFromFile('C:\Project\PedidoVenda\Images\Icones\success.png');
               end;
    taError:   begin
                 pnl_body.Color   :=  $003D4CE8;
                 pnl_image.Color  :=  $003D4CE8;
                 img_icone.Picture.LoadFromFile('C:\Project\PedidoVenda\Images\Icones\error.png');
               end;
    taInfo:    begin
                 pnl_body.Color   :=  $00DB9835;
                 pnl_image.Color  :=  $00DB9835;
                 img_icone.Picture.LoadFromFile('C:\Project\PedidoVenda\Images\Icones\info.png');
               end;
    taWarning: begin
                 pnl_body.Color   :=  $00119CF3;
                 pnl_image.Color  :=  $00119CF3;
                 img_icone.Picture.LoadFromFile('C:\Project\PedidoVenda\Images\Icones\warning.png');
               end;
  end;


end;

procedure TViewToastAlert.img_fecharClick(Sender: TObject);
begin

  Close;

end;

procedure TViewToastAlert.timer_closeTimer(Sender: TObject);
begin

  if (Self.AlphaBlendValue>0) then begin

    pnl_progress.Width    :=  pnl_progress.Width - 2;
    Self.AlphaBlendValue  :=  Self.AlphaBlendValue - 1;
    Application.ProcessMessages;

  end
  else
  begin
    timer_close.Enabled := False;
    Close;
  end;

end;

procedure TViewToastAlert.timer_showTimer(Sender: TObject);
begin

  if Self.AlphaBlendValue < 255 then
    Self.AlphaBlendValue := Self.AlphaBlendValue + 15
  else begin
    timer_show.Enabled  := False;
    timer_close.Enabled :=  True;
  end;

end;

end.
