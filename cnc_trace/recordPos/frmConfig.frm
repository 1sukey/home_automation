VERSION 5.00
Begin VB.Form frmConfig 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Config"
   ClientHeight    =   2160
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4710
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2160
   ScaleWidth      =   4710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame2 
      Caption         =   "Encoder inches / tick"
      Height          =   1815
      Left            =   2025
      TabIndex        =   6
      Top             =   135
      Width           =   2580
      Begin VB.CommandButton cmdCancel 
         Caption         =   "Cancel"
         Height          =   375
         Left            =   180
         TabIndex        =   10
         Top             =   1305
         Width           =   1005
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "Save"
         Height          =   375
         Left            =   1350
         TabIndex        =   9
         Top             =   1305
         Width           =   1095
      End
      Begin VB.TextBox txtY 
         Height          =   330
         Left            =   90
         TabIndex        =   8
         Top             =   900
         Width           =   1095
      End
      Begin VB.TextBox txtX 
         Height          =   330
         Left            =   90
         TabIndex        =   7
         Top             =   450
         Width           =   1095
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Encoder ticks / inch"
      Height          =   1770
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   1770
      Begin VB.CommandButton cmdCalculate 
         Caption         =   "Calculate"
         Height          =   375
         Left            =   405
         TabIndex        =   5
         Top             =   1260
         Width           =   1140
      End
      Begin VB.TextBox txtYY 
         Height          =   330
         Left            =   450
         TabIndex        =   4
         Top             =   810
         Width           =   1095
      End
      Begin VB.TextBox txtXX 
         Height          =   330
         Left            =   450
         TabIndex        =   2
         Top             =   405
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "Y"
         Height          =   285
         Index           =   1
         Left            =   180
         TabIndex        =   3
         Top             =   900
         Width           =   240
      End
      Begin VB.Label Label1 
         Caption         =   "X"
         Height          =   285
         Index           =   0
         Left            =   180
         TabIndex        =   1
         Top             =   450
         Width           =   240
      End
   End
End
Attribute VB_Name = "frmConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCalculate_Click()
    Dim x As Double
    Dim y As Double
    
    On Error Resume Next
    
    x = 1 / CLng(txtXX)
    y = 1 / CLng(txtYY)
    
    txtX = Round(x, 5)
    txtY = Round(y, 5)
    
    If Err.Number <> 0 Then MsgBox Err.Description
    
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdSave_Click()
    Dim x As Double
    Dim y As Double
    On Error Resume Next
     
    x = CDbl(txtX)
    y = CDbl(txtY)
    
    SaveCalibration x, y
    
    If Err.Number = 0 Then
        Unload Me
    Else
        MsgBox Err.Description
    End If
    
End Sub

Private Sub Form_Load()
    
    txtX = Round(modMain.x_calibration, 5)
    txtY = Round(modMain.y_calibration, 5)
    
End Sub
