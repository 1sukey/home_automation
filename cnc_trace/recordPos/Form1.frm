VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "CNC_Trace      http://sandsprite.com"
   ClientHeight    =   5025
   ClientLeft      =   60
   ClientTop       =   630
   ClientWidth     =   7260
   LinkTopic       =   "Form1"
   ScaleHeight     =   5025
   ScaleWidth      =   7260
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdMachZero 
      Caption         =   "Mach Zero"
      Height          =   375
      Left            =   90
      TabIndex        =   25
      Top             =   4635
      Width           =   1050
   End
   Begin VB.CommandButton cmdMachGoto 
      Caption         =   "Mach Goto"
      Height          =   375
      Left            =   1170
      TabIndex        =   23
      Top             =   4635
      Width           =   1050
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "..."
      Height          =   330
      Left            =   6750
      TabIndex        =   20
      Top             =   1260
      Width           =   420
   End
   Begin VB.TextBox txtSmooth 
      Height          =   330
      Left            =   5265
      TabIndex        =   18
      Text            =   ".010"
      Top             =   1665
      Width           =   1410
   End
   Begin VB.TextBox txtPath 
      Height          =   330
      Left            =   5265
      TabIndex        =   16
      Text            =   "c:\path.txt"
      Top             =   1260
      Width           =   1410
   End
   Begin VB.CommandButton cmdRecordPath 
      Caption         =   "Record Path"
      Height          =   375
      Left            =   5265
      TabIndex        =   14
      Top             =   2115
      Width           =   1440
   End
   Begin VB.CommandButton cmdZero 
      Caption         =   "Zero Enc"
      Height          =   330
      Left            =   2925
      TabIndex        =   13
      Top             =   1170
      Width           =   960
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   375
      Left            =   2925
      TabIndex        =   12
      Top             =   2565
      Width           =   1095
   End
   Begin VB.CommandButton cmdCopy 
      Caption         =   "Save Output"
      Height          =   375
      Left            =   2925
      TabIndex        =   11
      Top             =   3285
      Width           =   1095
   End
   Begin VB.TextBox txtDesc 
      Height          =   330
      Left            =   810
      TabIndex        =   10
      Top             =   2070
      Width           =   1995
   End
   Begin VB.ListBox List1 
      Height          =   2010
      Left            =   135
      TabIndex        =   8
      Top             =   2520
      Width           =   2670
   End
   Begin VB.CommandButton cmdSavePoint 
      Caption         =   "Save Point"
      Height          =   375
      Left            =   2925
      TabIndex        =   7
      Top             =   1620
      Width           =   960
   End
   Begin VB.TextBox txtPos 
      Height          =   330
      Left            =   810
      TabIndex        =   6
      Top             =   1620
      Width           =   1995
   End
   Begin VB.TextBox txtEncoder 
      Height          =   285
      Left            =   810
      TabIndex        =   5
      Top             =   1215
      Width           =   1995
   End
   Begin VB.ComboBox CboPort 
      Height          =   315
      Left            =   1350
      TabIndex        =   1
      Top             =   135
      Width           =   1950
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   4950
      Top             =   45
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Label lblMach 
      Height          =   330
      Left            =   2295
      TabIndex        =   24
      Top             =   4680
      Width           =   4830
   End
   Begin VB.Label Label7 
      Caption         =   "Record Points"
      Height          =   240
      Index           =   1
      Left            =   45
      TabIndex        =   22
      Top             =   855
      Width           =   2445
   End
   Begin VB.Line Line2 
      X1              =   90
      X2              =   7290
      Y1              =   1125
      Y2              =   1125
   End
   Begin VB.Label Label7 
      Caption         =   "Record Path"
      Height          =   285
      Index           =   0
      Left            =   4185
      TabIndex        =   21
      Top             =   810
      Width           =   2445
   End
   Begin VB.Line Line1 
      X1              =   4140
      X2              =   4140
      Y1              =   1125
      Y2              =   4590
   End
   Begin VB.Label lblRecorded 
      Height          =   420
      Left            =   4725
      TabIndex        =   19
      Top             =   2700
      Width           =   2535
   End
   Begin VB.Label Label6 
      Caption         =   "smoothing"
      Height          =   285
      Left            =   4455
      TabIndex        =   17
      Top             =   1710
      Width           =   825
   End
   Begin VB.Label Label5 
      Caption         =   "Save To"
      Height          =   240
      Left            =   4500
      TabIndex        =   15
      Top             =   1305
      Width           =   735
   End
   Begin VB.Label Label4 
      Caption         =   "Name"
      Height          =   285
      Left            =   90
      TabIndex        =   9
      Top             =   2115
      Width           =   690
   End
   Begin VB.Label Label3 
      Caption         =   "Encoder"
      Height          =   285
      Left            =   90
      TabIndex        =   4
      Top             =   1260
      Width           =   645
   End
   Begin VB.Label Label1 
      Caption         =   "CurPos"
      Height          =   285
      Left            =   90
      TabIndex        =   3
      Top             =   1665
      Width           =   690
   End
   Begin VB.Label lblRefresh 
      Caption         =   "Refresh"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   195
      Left            =   3510
      TabIndex        =   2
      Top             =   180
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "Active Serial Port"
      Height          =   285
      Left            =   45
      TabIndex        =   0
      Top             =   180
      Width           =   1590
   End
   Begin VB.Menu mnuCalculator 
      Caption         =   "Tools"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'author: David Zimmer <dzzie@yahoo.com>

Public WithEvents serial As clsSerial
Attribute serial.VB_VarHelpID = -1

'will not throw an error if mach is not installed (all late bound),
'just wont enable mach related buttons..
Public mach As New CMach

Dim hRec As Long
Dim hits As Long
Dim smoothing As Double
Dim lastX As Double
Dim lastY As Double
Dim dlg As New clsCmnDlg2

Private Sub CboPort_Click()
    Dim port As Long
    Dim sport As String
    
    On Error Resume Next
    
    sport = CboPort.Text
    a = InStr(sport, " ")
    If a > 0 Then
        sport = Mid(sport, 4, a - 4)
        port = CLng(sport)
    End If
    
    With MSComm1
        If .PortOpen Then .PortOpen = False
        .CommPort = port
        .PortOpen = True
    End With
    
    If Err.Number <> 0 Then
        MsgBox "can not set commport to " & port
    End If
    
End Sub

Private Sub cmdBrowse_Click()
    Dim p As String
    p = dlg.SaveDialog(AllFiles, , "Save path as", , Me.hWnd, "path.txt")
    txtPath = p
End Sub

Private Sub cmdClear_Click()
    List1.Clear
End Sub
 

Private Sub cmdCopy_Click()

    Dim t() As String
    Dim pth As String
    
    On Error Resume Next
    
    pth = dlg.SaveDialog(AllFiles, , "Save points file", , Me.hWnd, "points.txt")
    If Len(pth) = 0 Then Exit Sub
    
    push t, "; Point file recorded by cnc_trace - sandsprite.com, " & Now & vbCrLf
    push t, "G0"
    
    For i = 0 To List1.ListCount - 1
        push t, List1.List(i)
        push t, "G04 P1"
    Next
    
    WriteFile pth, Join(t, vbCrLf)
    
    If Err.Number <> 0 Then
        MsgBox Err.Description, vbInformation
    End If
    
End Sub

Private Sub cmdMachGoto_Click()
    
    If List1.ListCount < 1 Then
        MsgBox "No points in list yet"
        Exit Sub
    End If
    
    If List1.ListIndex = -1 Then List1.ListIndex = 0
    
    mach.GotoSafeZ
    mach.RunGCode "G0 " & List1.List(List1.ListIndex)
    
    If List1.ListIndex + 1 = List1.ListCount Then
        List1.ListIndex = -1
    Else
        List1.ListIndex = List1.ListIndex + 1
    End If
    
End Sub



Private Sub cmdMachZero_Click()
    mach.SetDRO axis_x, 0
    mach.SetDRO axis_y, 0
    mach.SetDRO axis_z, 0
End Sub

Private Sub cmdRecordPath_Click()
    On Error Resume Next
    
    If cmdRecordPath.Caption = "Record Path" Then
        lblRecorded = Empty
        smoothing = CDbl(txtSmooth)
        
        If Err.Number <> 0 Then
            MsgBox "Invalid smoothing value enter decimal change to ignore."
            Exit Sub
        End If
        
        If Len(txtPath) = 0 Then
            MsgBox "Select a output file path"
            Exit Sub
        End If
        
        cmdRecordPath.Caption = "Stop"
        hits = 0
        
        If FileExists(txtPath) Then Kill txtPath
        
        hRec = FreeFile
        Open txtPath For Output As hRec
        Print #hRec, "; Path recorded by cnc_trace sandsprite.com " & Now & vbCrLf
        Print #hRec, "G0"
        
        If Err.Number <> 0 Then
            MsgBox "Error opening file: " & Err.Description
            Close hRec
            cmdRecordPath.Caption = "Record Path"
        End If
        
    Else
        lblRecorded = hits & " points recorded."
        Close hRec
        hRec = 0
        cmdRecordPath.Caption = "Record Path"
    End If
        
End Sub

Private Sub cmdSavePoint_Click()
    
    If Len(txtPos) = 0 Then Exit Sub
    
    On Error GoTo hell
    If InStr(txtPos, ",") < 1 Then Exit Sub
    
    tmp = Split(txtPos, ",")
    
    ret = "X" & tmp(0) & " Y" & tmp(1)
    If Len(txtDesc) > 0 Then
        ret = ret & " ;  " & txtDesc
    End If
    
    List1.AddItem ret
    
hell:
End Sub

Private Sub cmdZero_Click()
    On Error Resume Next
    MSComm1.Output = "zero" & vbLf
End Sub

Private Sub Form_Load()

    mnuCalculator.Enabled = IsIde()
    
    Set serial = New clsSerial
    serial.Configure MSComm1
    LoadPorts

    Dim machEnabled As Boolean
    
    If Not isMachInstalled() Then
        lblMach = "Mach3 not installed Automation Disabled."
    Else
        If Not mach.InitMach() Then
            lblMach = mach.InitErrorMsg
        Else
            lblMach = "Connected to Mach3 Automation Interface"
            machEnabled = True
        End If
    End If
    
    cmdMachGoto.Enabled = machEnabled
    cmdMachZero.Enabled = machEnabled
    
End Sub



Private Sub LoadPorts()
    Dim strComputer As String
    Dim objWMIService As Object
    Dim colItems As Object
    Dim objItem As Object
    
    On Error Resume Next
    
    strComputer = "."
    Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
    Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_SerialPort", , 48)
    
    For Each objItem In colItems
        CboPort.AddItem objItem.DeviceID & " " & objItem.Description
    Next
       
    Set objItem = Nothing
    Set colItems = Nothing
    Set objWMIService = Nothing
    
    CboPort.ListIndex = 0
    
End Sub



Private Sub lblRefresh_Click()
    Screen.MousePointer = vbHourglass
    CboPort.Clear
    'LoadPorts
    Form_Load
    Screen.MousePointer = vbDefault
End Sub

Private Sub mnuCalculator_Click()
    frmTools.Visible = True
End Sub

Private Sub serial_MessageReceived(msg As String)

    On Error Resume Next
    
    Dim recordIt As Boolean
    Dim x As Double
    Dim Y As Double
    Dim tmp
    
    If Left(msg, 1) = "#" Then Exit Sub
    
    txtEncoder = Replace(msg, vbCr, Empty)
    
    tmp = Split(msg, ",")
    
    x = CDbl(tmp(0)) * 0.00066 'now we are in inches for each axis (calibration)
    Y = CDbl(tmp(1)) * 0.00052
    
    x = Round(x, 3)
    Y = Round(Y, 3)
    
    txtPos = x & "," & Y
    
    If hRec <> 0 Then
        
        If Abs(lastX - x) >= smoothing Then recordIt = True
        If Abs(lastY - Y) >= smoothing Then recordIt = True
        
        If (recordIt) Then
            lastX = x
            lastY = Y
            hits = hits + 1
            Print #hRec, "X" & x & " Y" & Y
        End If
        
        
    End If
    
    
    
End Sub
