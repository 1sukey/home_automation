VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   2010
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7755
   LinkTopic       =   "Form1"
   ScaleHeight     =   2010
   ScaleWidth      =   7755
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOEM 
      Caption         =   "SendOEMCode"
      Height          =   420
      Left            =   1035
      TabIndex        =   1
      Top             =   180
      Width           =   1725
   End
   Begin VB.TextBox txtOEM 
      Height          =   375
      Left            =   225
      TabIndex        =   0
      Text            =   "16"
      Top             =   180
      Width           =   645
   End
   Begin VB.Label Label1 
      Caption         =   "No UI, start it, then pause and play with the class in the immediate window.."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2490
      Left            =   90
      TabIndex        =   2
      Top             =   900
      Width           =   7170
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim mach As New CMach

Private Sub cmdOEM_Click()
    mach.SendOEMCode CInt(txtOEM)
End Sub

Private Sub Form_Load()
    
    If Not mach.InitMach() Then
        MsgBox "FAILED to initilize connection to mach is it running?, what version? use Mach3Version3.042.020.exe from the ftp server. New versions dont properly register the COM objects in the registry."
    Else
        Me.Caption = "Initilization Complete"
    End If
    
End Sub


