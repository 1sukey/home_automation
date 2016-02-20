VERSION 5.00
Begin VB.Form frmTools 
   Caption         =   "Tools"
   ClientHeight    =   3015
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4050
   LinkTopic       =   "Form2"
   ScaleHeight     =   3015
   ScaleWidth      =   4050
   StartUpPosition =   2  'CenterScreen
   Begin VB.OptionButton optHole 
      Caption         =   "Inside"
      Height          =   330
      Index           =   0
      Left            =   225
      TabIndex        =   13
      Top             =   2925
      Value           =   -1  'True
      Visible         =   0   'False
      Width           =   960
   End
   Begin VB.OptionButton optHole 
      Caption         =   "Outside"
      Height          =   330
      Index           =   1
      Left            =   1125
      TabIndex        =   12
      Top             =   2925
      Visible         =   0   'False
      Width           =   960
   End
   Begin VB.TextBox txtProbeDia 
      Height          =   330
      Left            =   2925
      TabIndex        =   11
      Text            =   "0"
      Top             =   2925
      Visible         =   0   'False
      Width           =   690
   End
   Begin VB.Frame Frame1 
      Caption         =   "Find Hole Center"
      Height          =   2625
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   3750
      Begin VB.CommandButton cmdMachGoto 
         Caption         =   "Mach Goto "
         Height          =   330
         Left            =   2565
         TabIndex        =   10
         Top             =   2160
         Width           =   1005
      End
      Begin VB.TextBox txtDesc 
         Height          =   330
         Left            =   810
         TabIndex        =   8
         Top             =   1665
         Width           =   1410
      End
      Begin VB.CommandButton cmdSavePoint 
         Caption         =   "Save Point"
         Height          =   375
         Left            =   2565
         TabIndex        =   7
         Top             =   1665
         Width           =   1005
      End
      Begin VB.ComboBox cboTest 
         Height          =   315
         Left            =   45
         TabIndex        =   6
         Text            =   "Combo1"
         Top             =   2160
         Width           =   1230
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Test data"
         Height          =   285
         Left            =   1350
         TabIndex        =   5
         Top             =   2160
         Width           =   825
      End
      Begin VB.TextBox txtCenter 
         Height          =   330
         Left            =   810
         TabIndex        =   4
         Top             =   1170
         Width           =   1410
      End
      Begin VB.CommandButton cmdRecord 
         Caption         =   "Record"
         Height          =   375
         Left            =   2565
         TabIndex        =   2
         Top             =   1125
         Width           =   1005
      End
      Begin VB.Label Label5 
         Caption         =   "Todo: account for current position...."
         Height          =   285
         Left            =   495
         TabIndex        =   15
         Top             =   720
         Width           =   3165
      End
      Begin VB.Label Label4 
         Caption         =   "Name"
         Height          =   285
         Left            =   90
         TabIndex        =   9
         Top             =   1710
         Width           =   690
      End
      Begin VB.Label Label2 
         Caption         =   "Center"
         Height          =   285
         Left            =   180
         TabIndex        =   3
         Top             =   1215
         Width           =   600
      End
      Begin VB.Label Label1 
         Caption         =   "hit record and then trace circle"
         Height          =   285
         Left            =   225
         TabIndex        =   1
         Top             =   360
         Width           =   3435
      End
   End
   Begin VB.Label Label3 
      Caption         =   "Probe Dia"
      Height          =   330
      Left            =   2115
      TabIndex        =   14
      Top             =   2970
      Visible         =   0   'False
      Width           =   780
   End
End
Attribute VB_Name = "frmTools"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim WithEvents serial As clsSerial
Attribute serial.VB_VarHelpID = -1

Dim xx() As Double
Dim yy() As Double
Dim recording As Boolean

Private Sub cmdMachGoto_Click()
    
    On Error GoTo hell
    Dim ret As String
    
    If Len(txtCenter) = 0 Then Exit Sub
    If InStr(txtCenter, ",") < 1 Then Exit Sub
    
    tmp = Split(txtCenter, ",")
    ret = "G0 X" & tmp(0) & " Y" & tmp(1)
    
    Form1.mach.RunGCode ret
        
    Exit Sub
hell:
    MsgBox Err.Description
    
End Sub

Private Sub cmdRecord_Click()
    On Error Resume Next
    
    If cmdRecord.Caption = "Record" Then
         cmdRecord.Caption = "Done"
         Erase xx
         Erase yy
         recording = True
         txtCenter = Empty
    Else
        txtCenter = calcCircleCenter()
        recording = False
        cmdRecord.Caption = "Record"
    End If
    
End Sub

Private Sub cmdSavePoint_Click()
    
    If Len(txtCenter) = 0 Then Exit Sub
    
    On Error GoTo hell
    If InStr(txtCenter, ",") < 1 Then Exit Sub
    
    tmp = Split(txtCenter, ",")
    
    ret = "X" & tmp(0) & " Y" & tmp(1)
    If Len(txtDesc) > 0 Then
        ret = ret & " ;  " & txtDesc
    End If
    
    Form1.List1.AddItem ret
    
hell:

End Sub

Private Sub Command1_Click()
    Dim i As Integer
    
    i = cboTest.ListIndex
    
    If Not recording Then cmdRecord_Click
    
    If i = 0 Then
        push xx, -2
        push xx, -1
        push yy, 1
        push yy, -1
    ElseIf i = 1 Then
        push xx, 2
        push xx, 1
        push yy, 1
        push yy, 2
    Else
        MsgBox "? bad index?"
    End If
    
    cmdRecord_Click
    
End Sub

Private Sub Form_Load()
    
    'hook into existing com ports serial data events..
    Set serial = Form1.serial
    
    If Not Form1.mach.isMachInit Then cmdMachGoto.Enabled = False
    
    Command1.Visible = IsIde()
    cboTest.Visible = IsIde()
    cboTest.AddItem "- circle"
    cboTest.AddItem "+ circle"
    cboTest.ListIndex = 0
End Sub


Private Sub serial_MessageReceived(msg As String)
    
    On Error Resume Next
    
    Dim recordIt As Boolean
    Dim x As Double
    Dim y As Double
    Dim tmp
    
    If Not recording Then Exit Sub
    If Left(msg, 1) = "#" Then Exit Sub
    
    tmp = Split(msg, ",")
    
    x = CDbl(tmp(0)) * modMain.x_calibration '0.00066 'now we are in inches for each axis (calibration)
    y = CDbl(tmp(1)) * modMain.y_calibration '0.00052
    
    x = Round(x, 3)
    y = Round(y, 3)
    
    push xx, x
    push yy, y
    
    
End Sub

Function calcCircleCenter() As String
    
    On Error GoTo hell
    
    Dim max_x As Double
    Dim min_x As Double
    
    Dim max_y As Double
    Dim min_y As Double
    
    Dim i As Long
    
    max_x = -9999
    min_x = 9999
    max_y = -9999
    min_y = 9999
    
    For i = 0 To UBound(xx)
        If xx(i) > max_x Then max_x = xx(i)
        If xx(i) < min_x Then min_x = xx(i)
    Next
    
    For i = 0 To UBound(yy)
        If yy(i) > max_y Then max_y = yy(i)
        If yy(i) < min_y Then min_y = yy(i)
    Next
       
    Dim center_x As Double
    Dim center_y As Double
    
    center_x = (max_x + min_x) / 2
    center_y = (max_y + min_y) / 2
    
    center_x = Round(center_x, 3)
    center_y = Round(center_y, 3)
    
    calcCircleCenter = center_x & "," & center_y
    
    Exit Function
hell:
    Me.Caption = Err.Description
End Function

'Sub swap(ByRef maxVal As Double, ByRef minVal As Double)
'    Dim tmp As Double
'    tmp = minVal
'    minVal = maxVal
'    maxVal = tmp
'End Sub
'
'    Dim x_both_neg As Boolean
'    Dim y_both_neg As Boolean
'
'    x_both_neg = max_x < 0 And min_x < 0
'    y_both_neg = max_y < 0 And min_y < 0
'
'    If x_both_neg Then swap max_x, min_x
'    If y_both_neg Then swap max_y, min_y
