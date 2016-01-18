VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Robotic Arm Serial Record/Replay  http://sandsprite.com"
   ClientHeight    =   5265
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8505
   LinkTopic       =   "Form1"
   ScaleHeight     =   5265
   ScaleWidth      =   8505
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdSave 
      Caption         =   "Open"
      Height          =   270
      Index           =   1
      Left            =   7680
      TabIndex        =   17
      Top             =   1800
      Width           =   720
   End
   Begin VB.CommandButton cmdPause 
      Caption         =   "Pause"
      Height          =   315
      Left            =   6480
      TabIndex        =   16
      Top             =   2160
      Width           =   855
   End
   Begin VB.CommandButton cmdClearList 
      Caption         =   "Clear List"
      Height          =   330
      Left            =   135
      TabIndex        =   15
      Top             =   2160
      Width           =   1005
   End
   Begin VB.ListBox List1 
      Height          =   2595
      Left            =   180
      TabIndex        =   14
      Top             =   2565
      Width           =   8205
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   3000
      Left            =   4860
      Top             =   90
   End
   Begin VB.CommandButton cmdStop 
      Caption         =   "Stop"
      Height          =   315
      Left            =   7515
      TabIndex        =   12
      Top             =   2160
      Width           =   855
   End
   Begin VB.CommandButton cmdReplay 
      Caption         =   "Replay"
      Height          =   330
      Left            =   5355
      TabIndex        =   11
      Top             =   2160
      Width           =   915
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   270
      Index           =   0
      Left            =   6900
      TabIndex        =   10
      Top             =   1800
      Width           =   720
   End
   Begin VB.TextBox txtScript 
      Height          =   285
      Left            =   1530
      OLEDropMode     =   1  'Manual
      TabIndex        =   9
      Text            =   "supports drag and drop"
      Top             =   1755
      Width           =   5340
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   "Record"
      Height          =   330
      Left            =   4140
      TabIndex        =   7
      Top             =   2160
      Width           =   915
   End
   Begin VB.TextBox txtData 
      Height          =   330
      Left            =   1530
      TabIndex        =   6
      Top             =   1260
      Width           =   6855
   End
   Begin VB.Frame Frame1 
      Caption         =   "Arduino COM Port Connection"
      Height          =   960
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   8250
      Begin VB.CheckBox chkLogResponse 
         Caption         =   "Log"
         Height          =   195
         Left            =   5895
         TabIndex        =   13
         Top             =   405
         Width           =   645
      End
      Begin VB.CommandButton Command1 
         Caption         =   "about"
         Height          =   375
         Left            =   6885
         TabIndex        =   4
         Top             =   315
         Width           =   1185
      End
      Begin VB.ComboBox CboPort 
         Height          =   315
         Left            =   945
         TabIndex        =   1
         Top             =   360
         Width           =   2400
      End
      Begin MSCommLib.MSComm MSComm1 
         Left            =   5175
         Top             =   -45
         _ExtentX        =   1005
         _ExtentY        =   1005
         _Version        =   393216
         DTREnable       =   -1  'True
      End
      Begin VB.Label Label2 
         Caption         =   "Port"
         Height          =   285
         Left            =   495
         TabIndex        =   3
         Top             =   405
         Width           =   870
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
         Left            =   3600
         TabIndex        =   2
         Top             =   450
         Width           =   780
      End
   End
   Begin VB.Label Label3 
      Caption         =   "File"
      Height          =   240
      Left            =   1035
      TabIndex        =   8
      Top             =   1800
      Width           =   375
   End
   Begin VB.Label Label1 
      Caption         =   "Data Received:"
      Height          =   240
      Left            =   180
      TabIndex        =   5
      Top             =   1305
      Width           =   1230
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

  
Dim WithEvents serial As clsSerial
Attribute serial.VB_VarHelpID = -1
Dim fso As New CFileSystem2
Dim fstream As New clsFileStream
Dim dlg As New clsCmnDlg2
Dim movements As Long
Dim recvd As responses
Dim lastCmd As Long
Dim paused As Boolean

Enum responses
    r_ok = 1
    r_waiting = 0
    r_error = 2
    r_timeout = 3
    r_complete = 4
    r_userabort = 5
End Enum

Const MAX_LONG As Long = 2147483468
Const MAX_DELAY As Long = 10000 '10sec

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Declare Function GetTickCount Lib "kernel32" () As Long


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

Private Sub cmdClearList_Click()
    List1.Clear
End Sub

'Function validate() As Boolean
'
'    On Error Resume Next
'    Dim uid As Long
'
'    If Not MSComm1.PortOpen Then
'        MsgBox "you must first select an open com Port from the list"
'        Exit Function
'    End If
'
'    If Err.Description <> 0 Then MsgBox Err.Description
'
'End Function

Private Sub cmdSave_Click(Index As Integer)
    If Index = 1 Then
        f = dlg.OpenDialog(AllFiles, , , Me.hWnd)
    Else
        f = dlg.SaveDialog(AllFiles, , , , Me.hWnd)
    End If
    If Len(f) = 0 Then Exit Sub
    txtScript = f
End Sub

Private Sub cmdPause_Click()
    If cmdPause.Caption = "Pause" Then
        paused = True
        cmdPause.Caption = "Resume"
        Me.Caption = "Paused"
    Else
        paused = False
        cmdPause.Caption = "Pause"
        Me.Caption = IIf(fstream.FileHandle <> 0, "Recording", "Running script..")
    End If
End Sub

Private Sub cmdRecord_Click()
            
    'If Not validate Then Exit Sub
    
    If recvd <> r_complete And recvd <> r_userabort Then
        MsgBox "A replay is still active"
        Exit Sub
    End If
    
    If Len(txtScript) = 0 Then
        cmdSave_Click 0
        If Len(txtScript) = 0 Then Exit Sub
    End If
    
    If fstream.FileHandle <> 0 Then fstream.fClose
    
    List1.Clear
    If fso.FileExists(txtScript) Then Kill txtScript
    fstream.fOpen txtScript, otappend
    
    If fstream.FileHandle = 0 Then
        MsgBox "Failed to open file? Error:" & fstream.ErrMsg, vbInformation
    Else
        Me.Caption = "Recording live motion..."
    End If
    
End Sub

Private Sub cmdReplay_Click()
    
    Dim tstamp As Long, stStamp As String, tElapsed As Long
    Dim i As Long, a As Long
    
    recvd = r_complete
    If fstream.FileHandle <> 0 Then
        MsgBox "A recording is still active"
        Exit Sub
    End If
    
    'If Not validate Then Exit Sub
    
    If Len(txtScript) = 0 Then
        cmdSave_Click 1
        If Len(txtScript) = 0 Then Exit Sub
    End If
    
    lastCmd = GetTickCount()
    List1.Clear
    
    tmp = Split(fso.ReadFile(txtScript), vbCrLf)
    For Each t In tmp
    
        recvd = r_waiting
        
        While paused
            DoEvents
            Sleep 10
            If recvd <> r_waiting Then Exit For
        Wend
        
        Me.Caption = "Script command: " & i & "/" & UBound(tmp)
        Me.Refresh
                
        t = Trim(t)
        If Len(t) = 0 Then GoTo nextone
        
        a = InStrRev(t, ",")
        If a < 1 Then GoTo nextone
        
        stStamp = Mid(t, a + 1) 'extract time stamp as string
        t = Mid(t, 1, a - 1)      'remove the timstamp from the corrds
        tstamp = CLng(stStamp)  'this could throw an error if bad data not caught..
        
        MSComm1.Output = t & vbLf
        
        tElapsed = GetTickCount() - lastCmd
        If tElapsed < tstamp Then
            tdelay = tstamp - tElapsed
            If tdelay < MAX_DELAY Then
                Me.Caption = "Sleeping for " & tdelay & "  Step: " & i & "/" & UBound(tmp)
                'List1.AddItem Me.Caption
                Me.Refresh
                While tdelay > 1
                    DoEvents
                    Sleep 1
                    tElapsed = GetTickCount() - lastCmd
                    tdelay = tstamp - tElapsed
                    If recvd = r_userabort Or recvd = r_timeout Then Exit For
                Wend
                lastCmd = GetTickCount()
            End If
        End If
          
        Timer1.Enabled = False
        Timer1.Enabled = True

        While recvd = r_waiting
            DoEvents
            Sleep 10
        Wend

        If recvd = r_timeout Then Exit For
        If recvd = r_userabort Then Exit For
        
nextone:
        i = i + 1
    Next

    Timer1.Enabled = False
    If (i = UBound(tmp) + 1) Then recvd = r_complete
    Me.Caption = "Script Complete! Status: " & getStatus(recvd) & "  Step: " & i & "/" & UBound(tmp)
    recvd = r_complete
    
End Sub

Function getStatus(r As responses)
    If r = r_complete Then getStatus = "complete"
    If r = r_error Then getStatus = "error"
    If r = r_ok Then getStatus = "ok"
    If r = r_timeout Then getStatus = "timeout"
    If r = r_waiting Then getStatus = "waiting"
    If r = r_userabort Then getStatus = "user abort"
End Function

Private Sub cmdStop_Click()
    On Error Resume Next
    fstream.fClose
    recvd = r_userabort
    Me.Caption = "Stopped"
End Sub

Private Sub Command1_Click()

    MsgBox "Copyright David Zimmer <dzzie@yahoo.com>" & vbCrLf & _
            "All Rights Reserved" & vbCrLf & _
            "This software is free for personal use." & vbCrLf & vbCrLf, vbInformation
            
End Sub


Private Sub Form_Load()
         
    Set serial = New clsSerial
    serial.Configure MSComm1
    LoadPorts
    
    recvd = r_complete
    'Const test = "c:\test.txt"
    'If fso.FileExists(test) Then txtScript = test

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

    Dim tstamp As Long
    
    msg = Replace(msg, vbCr, Empty)
    msg = Replace(msg, vbLf, Empty)
    txtData = msg
    
    If chkLogResponse.value = 1 Then
        If List1.ListCount > 1000 Then List1.Clear
        List1.AddItem "Serial Msg: " & msg
    End If

    If msg = "OK" Then
        recvd = r_ok
        Exit Sub
    End If
    
    If InStr(msg, "Invalid") > 0 Then
        recvd = r_error
        Exit Sub
    End If
    
    If paused Then Exit Sub
    
    If fstream.FileHandle <> 0 Then
    
        tstamp = GetTickCount() - lastCmd
        If tstamp < 0 Then tstamp = 0
        lastCmd = GetTickCount()
        
        fstream.WriteLine msg & "," & tstamp
        
        If movements = MAX_LONG Then movements = 0
        movements = movements + 1
        If movements Mod 10 = 0 Then
            Me.Caption = movements & " points recorded"
            Me.Refresh
        End If
        
    End If
    
End Sub



Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub



Function IsIde() As Boolean
    On Error GoTo out
    Debug.Print 1 / 0
out: IsIde = Err
End Function

Private Sub Timer1_Timer()
    recvd = r_timeout
    MsgBox "Script Timeout! No response, are you in serial mode on microcontroller?"
End Sub

Private Sub txtScript_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, Y As Single)
    On Error Resume Next
    txtScript = Data.files(1)
End Sub
