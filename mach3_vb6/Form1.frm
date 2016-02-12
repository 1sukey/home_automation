VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Mach3 External Automation Sample"
   ClientHeight    =   4425
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7755
   LinkTopic       =   "Form1"
   ScaleHeight     =   4425
   ScaleWidth      =   7755
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkAndWait 
      Caption         =   "andWait"
      Height          =   240
      Left            =   4005
      TabIndex        =   16
      Top             =   2610
      Width           =   1005
   End
   Begin VB.CommandButton cmdZeroAxis 
      Caption         =   "Zero Axis"
      Height          =   375
      Left            =   5850
      TabIndex        =   15
      Top             =   2475
      Width           =   1725
   End
   Begin VB.CommandButton cmdToggleJogMode 
      Caption         =   "Toggle Jog Mode"
      Height          =   420
      Left            =   5895
      TabIndex        =   14
      Top             =   1890
      Width           =   1635
   End
   Begin VB.CommandButton cmdJog 
      Caption         =   "Start Jogging"
      Height          =   375
      Left            =   5895
      TabIndex        =   13
      Top             =   1350
      Width           =   1635
   End
   Begin VB.CommandButton cmdReadDro 
      Caption         =   "Read DRO"
      Height          =   330
      Left            =   5895
      TabIndex        =   12
      Top             =   765
      Width           =   1635
   End
   Begin VB.CommandButton cmdGCode 
      Caption         =   "Run GCode"
      Height          =   375
      Left            =   2700
      TabIndex        =   11
      Top             =   2520
      Width           =   1185
   End
   Begin VB.TextBox txtGCode 
      Height          =   330
      Left            =   1125
      TabIndex        =   10
      Text            =   "g0 x5 y5"
      Top             =   2520
      Width           =   1410
   End
   Begin VB.TextBox txtRPM 
      Height          =   330
      Left            =   720
      TabIndex        =   8
      Text            =   "1200"
      Top             =   1845
      Width           =   1230
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Goto Page"
      Height          =   330
      Left            =   2025
      TabIndex        =   6
      Top             =   945
      Width           =   1005
   End
   Begin VB.ComboBox cboPage 
      Height          =   315
      Left            =   225
      TabIndex        =   5
      Top             =   945
      Width           =   1590
   End
   Begin VB.CommandButton cmdCreateMachObj 
      Caption         =   "Create Mach Object"
      Height          =   420
      Left            =   5895
      TabIndex        =   4
      Top             =   180
      Width           =   1635
   End
   Begin VB.CommandButton cmdSpindle 
      Caption         =   "Spindle On"
      Height          =   420
      Left            =   2070
      TabIndex        =   3
      Top             =   1800
      Width           =   1275
   End
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
   Begin VB.Label Label3 
      Caption         =   "GCODE"
      Height          =   285
      Left            =   135
      TabIndex        =   9
      Top             =   2565
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "RPM"
      Height          =   240
      Left            =   135
      TabIndex        =   7
      Top             =   1935
      Width           =   465
   End
   Begin VB.Label Label1 
      Caption         =   "To experiment with more of the methods, start it, then pause and play with the class in the VB6 immediate window.."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2580
      Left            =   225
      TabIndex        =   2
      Top             =   3105
      Width           =   7170
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim mach As New CMach

Private Sub cmdCreateMachObj_Click()
    Form_Load
End Sub

Private Sub cmdGCode_Click()
    mach.RunGCode txtGCode, (chkAndWait.value = 1)
    If chkAndWait.value Then MsgBox "Just arrived at location now"
End Sub

Private Sub cmdJog_Click()

    Dim i As Long

    If cmdJog.Caption = "Start Jogging" Then
        For i = 0 To 2
            mach.JogOn i, True
        Next
        cmdJog.Caption = "Jog Off"
    Else
        For i = 0 To 2
            mach.JogOff i
        Next
        cmdJog.Caption = "Start Jogging"
    End If
     
End Sub

Private Sub cmdOEM_Click()
    mach.SendOEMCode CInt(txtOEM)
End Sub

Private Sub cmdReadDro_Click()
    
    Dim tmp
    
    tmp = "X: " & mach.ReadDRO(axis_x) & vbCrLf
    tmp = tmp & "Y: " & mach.ReadDRO(axis_y) & vbCrLf
    tmp = tmp & "Z: " & mach.ReadDRO(axis_z) & vbCrLf
    
    MsgBox tmp
    
End Sub

Private Sub cmdSpindle_Click()
    On Error Resume Next
    
    mach.SpindleRPM = CDbl(txtRPM)
    
    If Err.Number <> 0 Then
        MsgBox "Invalid spindle rpm"
        Exit Sub
    End If
    
    If cmdSpindle.Caption = "Spindle On" Then
        mach.StopSpindle
        cmdSpindle.Caption = "Spindle Off"
    Else
        cmdSpindle.Caption = "Spindle On"
        mach.StartSpindle
    End If
    
End Sub

Private Sub cmdToggleJogMode_Click()
    mach.SendOEMCode oem_JogModeToggle
End Sub

Private Sub cmdZeroAxis_Click()
    mach.SetDRO axis_x, 0
    mach.SetDRO axis_y, 0
    mach.SetDRO axis_z, 0
End Sub

Private Sub Command1_Click()
    mach.GotoUIPage cboPage.ListIndex + 1
End Sub

Private Sub Form_Load()
    
    If Not mach.InitMach() Then
        MsgBox mach.InitErrorMsg
    Else
        Me.Caption = "Initilization Complete"
    End If
    
    cboPage.Clear
    cboPage.AddItem "Run"
    cboPage.AddItem "MDI"
    cboPage.AddItem "Toolpath"
    cboPage.AddItem "Positioning"
    cboPage.AddItem "Diagonistics"
    cboPage.AddItem "Corrections"
    cboPage.ListIndex = 0
    
    
End Sub


