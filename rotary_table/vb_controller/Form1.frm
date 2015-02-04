VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Rotary Table Indexer - sandsprite.com"
   ClientHeight    =   3045
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4635
   LinkTopic       =   "Form1"
   ScaleHeight     =   3045
   ScaleWidth      =   4635
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "about"
      Height          =   375
      Left            =   3465
      TabIndex        =   17
      Top             =   2610
      Width           =   1140
   End
   Begin VB.TextBox txtrecv 
      Height          =   285
      Left            =   900
      TabIndex        =   16
      Top             =   2655
      Width           =   1950
   End
   Begin VB.TextBox txtSend 
      Height          =   285
      Left            =   900
      TabIndex        =   14
      Top             =   2295
      Width           =   1950
   End
   Begin VB.TextBox TxtDelay 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   1215
      TabIndex        =   11
      Text            =   "1"
      Top             =   675
      Width           =   555
   End
   Begin VB.ComboBox CboPort 
      Height          =   315
      Left            =   2610
      TabIndex        =   10
      Top             =   675
      Width           =   1950
   End
   Begin VB.TextBox TxtStepsPerRev 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   3645
      TabIndex        =   7
      Text            =   "200"
      Top             =   135
      Width           =   555
   End
   Begin VB.TextBox TxtRatio 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   1755
      TabIndex        =   6
      Text            =   "36"
      Top             =   135
      Width           =   555
   End
   Begin VB.CheckBox ChkCounterClockwise 
      Caption         =   "Counter ClockWise"
      Height          =   330
      Left            =   2745
      TabIndex        =   4
      Top             =   1170
      Width           =   1770
   End
   Begin VB.TextBox TxtValue 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   1800
      TabIndex        =   3
      Text            =   "100"
      Top             =   1710
      Width           =   780
   End
   Begin VB.OptionButton optDegrees 
      Caption         =   "Degrees"
      Height          =   420
      Left            =   90
      TabIndex        =   2
      Top             =   1800
      Width           =   1005
   End
   Begin VB.OptionButton optDivisions 
      Caption         =   "Divisions"
      Height          =   420
      Left            =   90
      TabIndex        =   1
      Top             =   1485
      Value           =   -1  'True
      Width           =   960
   End
   Begin VB.CommandButton CmdMove 
      Caption         =   "configure"
      Height          =   375
      Left            =   3465
      TabIndex        =   0
      Top             =   2115
      Width           =   1095
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   5310
      Top             =   3195
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Label Label5 
      Caption         =   "received"
      Height          =   240
      Index           =   1
      Left            =   90
      TabIndex        =   15
      Top             =   2700
      Width           =   690
   End
   Begin VB.Label Label5 
      Caption         =   "sent"
      Height          =   240
      Index           =   0
      Left            =   90
      TabIndex        =   13
      Top             =   2340
      Width           =   420
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FF0000&
      BorderWidth     =   3
      Index           =   1
      X1              =   1170
      X2              =   1710
      Y1              =   2025
      Y2              =   1845
   End
   Begin VB.Line Line1 
      BorderColor     =   &H00FF0000&
      BorderWidth     =   3
      Index           =   0
      X1              =   1170
      X2              =   1710
      Y1              =   1665
      Y2              =   1800
   End
   Begin VB.Label Label4 
      Caption         =   "Delay (ms)"
      Height          =   285
      Left            =   180
      TabIndex        =   12
      Top             =   675
      Width           =   1095
   End
   Begin VB.Label Label2 
      Caption         =   "Port"
      Height          =   285
      Left            =   2160
      TabIndex        =   9
      Top             =   720
      Width           =   870
   End
   Begin VB.Label Label3 
      Caption         =   "Steps Per Rev"
      Height          =   285
      Left            =   2520
      TabIndex        =   8
      Top             =   180
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Rotary Table Ratio 1 : "
      Height          =   285
      Left            =   90
      TabIndex        =   5
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
        Logit "can not set commport to " & port
    End If
    
End Sub

Function validate(stepsPerRev, TableRatio, Delay, divisions) As Boolean

    If Not MSComm1.PortOpen Then
        MsgBox "you must first select an open com Port from the list"
        Exit Function
    End If
    
    If Delay = 0 Then
        MsgBox "Delay can not be 0"
        Exit Function
    End If
    
    If stepsPerRev = 0 Then
        MsgBox "stepsPerRev can not be 0"
        Exit Function
    End If
    
    If TableRatio = 0 Then
        MsgBox "TableRatio can not be 0"
        Exit Function
    End If
    
    If divisions = 0 Then
        MsgBox "divisions can not be 0"
        Exit Function
    End If
    
    validate = True

End Function

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
        
    Cmd = CLng(steps) & "," & Delay & "," & ChkCounterClockwise.Value
    txtSend = Cmd
     
    MSComm1.Output = Cmd & vbLf
            
End Sub

Private Sub Command1_Click()

    MsgBox "Copyright David Zimmer <dzzie@yahoo.com>" & vbCrLf & _
            "all rights reserved" & vbCrLf & _
            "this software is free for personal use. " & vbCrLf & _
            "If you would like to to use this commercially, please consider a paypal donation" & vbCrLf & _
            "in respect for my time creating it. "
            
End Sub

Private Sub Form_Load()

    With MSComm1
        If .PortOpen Then .PortOpen = False
        .Settings = "9600,N,8,1"
        .DTREnable = False
        .RTSEnable = False
        .RThreshold = 1
        .SThreshold = 0
        .InBufferSize = 1
    End With
  
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

Sub Logit(x)
    On Error Resume Next
    'List1.AddItem x
    'List1.ListIndex = List1.ListCount - 1
    txtrecv = Format(Now, "h:n.s  -  ") & x
End Sub

Private Sub Form_Unload(Cancel As Integer)
    txtSend = Empty
    txtrecv = Empty
    LoadSettings True
End Sub

Private Sub MSComm1_OnComm()
  Dim strInput As String
  Dim str() As String
  Static strBuffer As String
  Dim boComplete As Boolean
  Dim intPos As Integer
  
  
  
  With MSComm1
    'test for incoming event
    Select Case .CommEvent
        Case comEvReceive
            '
            ' Something to receive
            ' Receive it and add to our static Buffer
            '
            strInput = .Input
            strBuffer = strBuffer & strInput
            Do
                '
                ' Check if there's a complete record in the Buffer
                ' NOTE: This code assumes that the sender terminates
                ' each record with a Carriage Return Line Feed Pair
                ' If this is not the case then change vbCrLf below
                ' to whatever the terminator is
                '
                intPos = InStr(strBuffer, vbLf)
                If intPos <> 0 Then
                    '
                    ' Yes, there is a complete record
                    ' Extract it from the Buffer and process it
                    '
                    strInput = Mid$(strBuffer, 1, intPos - 1)
                    Logit strInput
                    
                    '
                    ' Check if there's anything else in the Buffer
                    '
                    If intPos + 1 < Len(strBuffer) Then
                        '
                        ' Yes, move it to the front of the Buffer
                        ' and go round the loop again
                        '
                        strBuffer = Mid(strBuffer, intPos + 2)
                    Else
                        '
                        ' Nothing left in the Buffer
                        ' Flush it and signal to exit the loop
                        '
                        strBuffer = ""
                        boComplete = True
                    End If
                Else
                    '
                    ' Haven't got a complete record yet
                    ' exit the loop and wait for the next
                    ' comEvReceive event
                    '
                    boComplete = True
                End If
            Loop Until boComplete = True
        End Select
  End With 'MSComm1
End Sub
