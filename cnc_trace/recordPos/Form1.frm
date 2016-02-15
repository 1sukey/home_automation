VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Trace Path"
   ClientHeight    =   4020
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5760
   LinkTopic       =   "Form1"
   ScaleHeight     =   4020
   ScaleWidth      =   5760
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdRecordPath 
      Caption         =   "Record Path"
      Height          =   375
      Left            =   4020
      TabIndex        =   14
      Top             =   1020
      Width           =   1215
   End
   Begin VB.CommandButton cmdZero 
      Caption         =   "Zero Enc"
      Height          =   330
      Left            =   2880
      TabIndex        =   13
      Top             =   585
      Width           =   960
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   375
      Left            =   2880
      TabIndex        =   12
      Top             =   1980
      Width           =   1050
   End
   Begin VB.CommandButton cmdCopy 
      Caption         =   "Copy Output"
      Height          =   375
      Left            =   2880
      TabIndex        =   11
      Top             =   3510
      Width           =   1095
   End
   Begin VB.TextBox txtDesc 
      Height          =   330
      Left            =   765
      TabIndex        =   10
      Top             =   1485
      Width           =   1995
   End
   Begin VB.ListBox List1 
      Height          =   2010
      Left            =   90
      TabIndex        =   8
      Top             =   1935
      Width           =   2670
   End
   Begin VB.CommandButton cmdSavePoint 
      Caption         =   "Save Point"
      Height          =   375
      Left            =   2880
      TabIndex        =   7
      Top             =   1035
      Width           =   960
   End
   Begin VB.TextBox txtPos 
      Height          =   330
      Left            =   765
      TabIndex        =   6
      Top             =   1035
      Width           =   1995
   End
   Begin VB.TextBox txtEncoder 
      Height          =   285
      Left            =   765
      TabIndex        =   5
      Top             =   630
      Width           =   1995
   End
   Begin VB.ComboBox CboPort 
      Height          =   315
      Left            =   495
      TabIndex        =   1
      Top             =   135
      Width           =   1950
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   5310
      Top             =   3195
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Label Label4 
      Caption         =   "Name"
      Height          =   285
      Left            =   45
      TabIndex        =   9
      Top             =   1530
      Width           =   690
   End
   Begin VB.Label Label3 
      Caption         =   "Encoder"
      Height          =   285
      Left            =   45
      TabIndex        =   4
      Top             =   675
      Width           =   645
   End
   Begin VB.Label Label1 
      Caption         =   "CurPos"
      Height          =   285
      Left            =   45
      TabIndex        =   3
      Top             =   1080
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
      Left            =   2655
      TabIndex        =   2
      Top             =   180
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "Port"
      Height          =   285
      Left            =   45
      TabIndex        =   0
      Top             =   180
      Width           =   870
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Copyright David Zimmer <dzzie@yahoo.com>
'all rights reserved
'this software is free for personal use.
'If you would like to to use this commercially, please consider a paypal donation
'in respect for my time creating it.

Dim WithEvents serial As clsSerial
Attribute serial.VB_VarHelpID = -1

Dim hRec As Long
Dim hits As Long

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

Private Sub cmdClear_Click()
    List1.Clear
End Sub
 

Private Sub cmdCopy_Click()

    Dim t As String
    
    For i = 0 To List1.ListCount
        t = t & List1.List(i) & vbCrLf
        t = t & "G04 P1" & vbCrLf
    Next
    
    Clipboard.Clear
    Clipboard.SetText t
    
End Sub

Private Sub cmdRecordPath_Click()
    On Error Resume Next
    
    If cmdRecordPath.Caption = "Record Path" Then
        cmdRecordPath.Caption = "Stop"
        hits = 0
        hRec = FreeFile
        Kill "C:\path.txt"
        Open "C:\path.txt" For Output As hRec
    Else
        MsgBox hits & " points recorded!", vbInformation
        Close hRec
        hRec = 0
        cmdRecordPath.Caption = "Record Path"
    End If
        
End Sub

Private Sub cmdSavePoint_Click()
    
    If Len(txtPos) = 0 Then Exit Sub
    
    On Error GoTo hell
    
    tmp = Split(txtPos, ",")
    
    ret = "X" & tmp(0) & " Y" & tmp(1)
    If Len(txtDesc) > 0 Then
        ret = ret & " ;" & txtDesc
    End If
    
    List1.AddItem ret
    
hell:
End Sub

Private Sub cmdZero_Click()
    On Error Resume Next
    MSComm1.Output = "zero" & vbLf
End Sub

Private Sub Form_Load()

    Set serial = New clsSerial
    serial.Configure MSComm1
    LoadPorts
    
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
    LoadPorts
    Screen.MousePointer = vbDefault
End Sub

Private Sub serial_MessageReceived(msg As String)

    On Error Resume Next
    
    If Left(msg, 1) = "#" Then Exit Sub
    
    txtEncoder = Replace(msg, vbCr, Empty)
    
    tmp = Split(msg, ",")
    
    Dim x As Double
    Dim y As Double
    
    x = CDbl(tmp(0)) * 0.00066 'now we are in inches for each axis (calibration)
    y = CDbl(tmp(1)) * 0.00052
    
    txtPos = Round(x, 3) & "," & Round(y, 3)
    
    If hRec <> 0 Then
        hits = hits + 1
        Print #hRec, "X" & Round(x, 3) & " Y" & Round(y, 3)
    End If
    
    
    
End Sub
