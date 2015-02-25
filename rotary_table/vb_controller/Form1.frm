VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Rotary Table Indexer - sandsprite.com"
   ClientHeight    =   4020
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4800
   LinkTopic       =   "Form1"
   ScaleHeight     =   4020
   ScaleWidth      =   4800
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtSend 
      Height          =   285
      Left            =   1350
      TabIndex        =   18
      Top             =   3240
      Width           =   3300
   End
   Begin VB.TextBox txtrecv 
      Height          =   285
      Left            =   1350
      TabIndex        =   17
      Top             =   3645
      Width           =   3300
   End
   Begin VB.CommandButton Command1 
      Caption         =   "about"
      Height          =   375
      Left            =   3510
      TabIndex        =   16
      Top             =   2835
      Width           =   1185
   End
   Begin VB.CommandButton cmdGotoIndex 
      Caption         =   "Goto Index"
      Height          =   375
      Left            =   3510
      TabIndex        =   15
      Top             =   2160
      Width           =   1185
   End
   Begin VB.TextBox TxtDelay 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   4140
      TabIndex        =   10
      Text            =   "1"
      Top             =   855
      Width           =   555
   End
   Begin VB.ComboBox CboPort 
      Height          =   315
      Left            =   495
      TabIndex        =   9
      Top             =   135
      Width           =   1950
   End
   Begin VB.TextBox TxtStepsPerRev 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   4140
      TabIndex        =   6
      Text            =   "200"
      Top             =   495
      Width           =   555
   End
   Begin VB.TextBox TxtRatio 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   4140
      TabIndex        =   5
      Text            =   "36"
      Top             =   135
      Width           =   555
   End
   Begin VB.TextBox TxtValue 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   1980
      TabIndex        =   3
      Text            =   "100"
      Top             =   1170
      Width           =   780
   End
   Begin VB.OptionButton optDegrees 
      Caption         =   "Degrees"
      Height          =   420
      Left            =   180
      TabIndex        =   2
      Top             =   1260
      Width           =   1005
   End
   Begin VB.OptionButton optDivisions 
      Caption         =   "Divisions"
      Height          =   420
      Left            =   180
      TabIndex        =   1
      Top             =   945
      Value           =   -1  'True
      Width           =   960
   End
   Begin VB.CommandButton CmdMove 
      Caption         =   "configure"
      Height          =   375
      Left            =   3510
      TabIndex        =   0
      Top             =   1395
      Width           =   1185
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   5310
      Top             =   3195
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Label Label7 
      Caption         =   "Debug Info:"
      Height          =   240
      Left            =   90
      TabIndex        =   21
      Top             =   2880
      Width           =   1230
   End
   Begin VB.Label Label5 
      Caption         =   "sent"
      Height          =   240
      Index           =   0
      Left            =   540
      TabIndex        =   20
      Top             =   3285
      Width           =   420
   End
   Begin VB.Label Label5 
      Caption         =   "received"
      Height          =   240
      Index           =   1
      Left            =   540
      TabIndex        =   19
      Top             =   3690
      Width           =   690
   End
   Begin VB.Line Line3 
      X1              =   45
      X2              =   4770
      Y1              =   1935
      Y2              =   1935
   End
   Begin VB.Line Line2 
      X1              =   45
      X2              =   4770
      Y1              =   2745
      Y2              =   2745
   End
   Begin VB.Label lblPos 
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   330
      Left            =   1260
      TabIndex        =   14
      Top             =   2160
      Width           =   780
   End
   Begin VB.Label Label6 
      Caption         =   "Cur Index:"
      Height          =   240
      Left            =   225
      TabIndex        =   13
      Top             =   2205
      Width           =   915
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
      Left            =   540
      TabIndex        =   12
      Top             =   540
      Width           =   780
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FF0000&
      BorderWidth     =   3
      Index           =   1
      X1              =   1260
      X2              =   1800
      Y1              =   1485
      Y2              =   1305
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FF0000&
      BorderWidth     =   3
      Index           =   0
      X1              =   1260
      X2              =   1800
      Y1              =   1125
      Y2              =   1260
   End
   Begin VB.Label Label4 
      Caption         =   "Delay (ms)"
      Height          =   285
      Left            =   3240
      TabIndex        =   11
      Top             =   900
      Width           =   825
   End
   Begin VB.Label Label2 
      Caption         =   "Port"
      Height          =   285
      Left            =   45
      TabIndex        =   8
      Top             =   180
      Width           =   870
   End
   Begin VB.Label Label3 
      Caption         =   "Stepper Steps Per Rev"
      Height          =   285
      Left            =   2430
      TabIndex        =   7
      Top             =   540
      Width           =   1725
   End
   Begin VB.Label Label1 
      Caption         =   "Rotary Table Ratio 1 : "
      Height          =   285
      Left            =   2565
      TabIndex        =   4
      Top             =   180
      Width           =   1770
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

Sub LoadSettings(Optional saveit As Boolean = False)
    
    Dim tmp
    
    For Each f In Me.Controls
        If TypeName(f) = "TextBox" Then
            If saveit = True Then
                SaveSetting App.EXEName, "settings", f.Name, f.Text
            Else
                tmp = GetSetting(App.EXEName, "settings", f.Name)
                If Len(tmp) > 0 Then f.Text = tmp
            End If
        End If
    Next
  
End Sub

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

Function validate(stepsPerRev, TableRatio, Delay, divisions) As Boolean

    If Not MSComm1.PortOpen Then
        MsgBox "you must first select an open com Port from the list"
        Exit Function
    End If
    
    If Delay <= 0 Then
        MsgBox "Delay must be greater than 0"
        Exit Function
    End If
    
    If stepsPerRev <= 0 Then
        MsgBox "stepsPerRev must be greater than 0"
        Exit Function
    End If
    
    If TableRatio <= 0 Then
        MsgBox "TableRatio must be greater than 0"
        Exit Function
    End If
    
    If divisions <= 0 Then
        MsgBox "divisions must be greater than 0"
        Exit Function
    End If
    
    validate = True

End Function

Private Sub cmdGotoIndex_Click()

    Dim index As Integer, y As String
    
    y = InputBox("Enter index to jump to:", "Goto Index", 0)
    If Len(y) = 0 Then Exit Sub
    
    On Error Resume Next
    index = CInt(y)
    
    If index < 0 Then
        MsgBox "negative indexes are not currently supported", vbInformation
        Exit Sub
    End If
    
    '32666 is an invalid step number, magic value to trigger this feature..
    y = "32666," & index
    txtSend = y
    txtrecv = Empty
    
    MSComm1.Output = y & vbLf
    
End Sub

Private Sub CmdMove_Click()

    Dim divisions As Currency
    Dim steps As Currency
    Dim Cmd As String 'steps, delay, direction
    Dim stepsPerRev As Currency
    Dim TableRatio As Currency
    Dim Delay As Long
    
    On Error Resume Next
    
    stepsPerRev = CCur(TxtStepsPerRev)
    TableRatio = CCur(TxtRatio)
    Delay = CLng(TxtDelay)
    
    If optDegrees.Value Then
        divisions = 360 / CCur(TxtValue)
    Else
        divisions = CCur(TxtValue)
    End If
    
    If Not validate(stepsPerRev, TableRatio, Delay, divisions) Then
        Exit Sub
    End If
    
    steps = stepsPerRev / divisions
    steps = steps * TableRatio
        
    Cmd = CLng(steps) & "," & Delay '& "," & ChkCounterClockwise.Value
    txtSend = Cmd
    txtrecv = Empty
    
    MSComm1.Output = Cmd & vbLf
            
End Sub

Private Sub Command1_Click()

    MsgBox "Copyright David Zimmer <dzzie@yahoo.com>" & vbCrLf & _
            "All Rights Reserved" & vbCrLf & _
            "This software is free for personal use." & vbCrLf & vbCrLf & _
            "If you would like to to use this commercially, please consider a paypal donation" & vbCrLf & _
            "in respect for my time creating it. " & vbCrLf & vbCrLf & _
            "Source:" & vbCrLf & _
            "  https://github.com/dzzie/home_automation/tree/master/rotary_table", vbInformation
            
End Sub

Private Sub Command2_Click()

End Sub

Private Sub Form_Load()

    Set serial = New clsSerial
    serial.Configure MSComm1
    LoadPorts
    LoadSettings
    
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

Private Sub Form_Unload(Cancel As Integer)
    txtSend = Empty
    txtrecv = Empty
    LoadSettings True
End Sub

Private Sub lblRefresh_Click()
    Screen.MousePointer = vbHourglass
    CboPort.Clear
    txtrecv = Empty
    txtSend = Empty
    LoadPorts
    Screen.MousePointer = vbDefault
End Sub

Private Sub serial_MessageReceived(msg As String)

    txtrecv.Text = Format(Now, "hh:nn.ss  -  ") & msg
    
    a = InStr(msg, "[pos:")
    If a > 0 Then
        a = a + Len("[pos:")
        b = InStr(a, msg, "]")
        If b > 0 Then
            lblPos.Caption = Mid(msg, a, b - a)
        End If
    End If
    
End Sub
