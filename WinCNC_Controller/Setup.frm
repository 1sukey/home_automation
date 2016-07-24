VERSION 5.00
Begin VB.Form frmSetup 
   Caption         =   "Setup"
   ClientHeight    =   3285
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5205
   LinkTopic       =   "Setup"
   ScaleHeight     =   3285
   ScaleWidth      =   5205
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnSave 
      Caption         =   "&Save"
      Height          =   615
      Left            =   1080
      TabIndex        =   10
      Top             =   2280
      Width           =   1215
   End
   Begin VB.CommandButton btnCancel 
      Caption         =   "&Cancel"
      Height          =   615
      Left            =   2880
      TabIndex        =   9
      Top             =   2280
      Width           =   1215
   End
   Begin VB.TextBox Timer 
      Height          =   375
      Left            =   3240
      TabIndex        =   7
      Top             =   360
      Width           =   1215
   End
   Begin VB.TextBox ZSPI 
      Height          =   375
      Left            =   960
      TabIndex        =   2
      Top             =   1320
      Width           =   1215
   End
   Begin VB.TextBox YSPI 
      Height          =   375
      Left            =   960
      TabIndex        =   1
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox XSPI 
      Height          =   375
      Left            =   960
      TabIndex        =   0
      Top             =   360
      Width           =   1215
   End
   Begin VB.Label Label5 
      Caption         =   "Clock Speed:"
      Height          =   375
      Left            =   2640
      TabIndex        =   8
      Top             =   0
      Width           =   1215
   End
   Begin VB.Label Label4 
      Caption         =   "Steps Per Inch (SPI)"
      Height          =   375
      Left            =   360
      TabIndex        =   6
      Top             =   0
      Width           =   1815
   End
   Begin VB.Label Label3 
      Caption         =   "Z:"
      Height          =   255
      Left            =   600
      TabIndex        =   5
      Top             =   1440
      Width           =   255
   End
   Begin VB.Label Label2 
      Caption         =   "Y:"
      Height          =   255
      Left            =   600
      TabIndex        =   4
      Top             =   960
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "X:"
      Height          =   255
      Left            =   600
      TabIndex        =   3
      Top             =   480
      Width           =   255
   End
End
Attribute VB_Name = "frmSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim inipath As String

Private Sub btnCancel_Click()
Unload Me
End Sub

Private Sub Form_Load()
inipath = App.Path + "\WinCNC.ini"
XSPI.Text = mfncGetFromIni("Setup", "XSPI", inipath)
YSPI.Text = mfncGetFromIni("Setup", "YSPI", inipath)
ZSPI.Text = mfncGetFromIni("Setup", "ZSPI", inipath)
Timer.Text = mfncGetFromIni("Setup", "Timer", inipath)

End Sub

Private Sub btnSave_Click()
Dim save As Integer
save = mfncWriteIni("Setup", "XSPI", XSPI.Text, inipath)
save = mfncWriteIni("Setup", "YSPI", YSPI.Text, inipath)
save = mfncWriteIni("Setup", "ZSPI", ZSPI.Text, inipath)
save = mfncWriteIni("Setup", "Timer", Timer.Text, inipath)
Unload Me
End Sub
