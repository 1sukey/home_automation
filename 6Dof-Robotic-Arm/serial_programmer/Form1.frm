VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Robotic Arm Serial Record/Replay  http://sandsprite.com"
   ClientHeight    =   5760
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7530
   LinkTopic       =   "Form1"
   ScaleHeight     =   5760
   ScaleWidth      =   7530
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdClearList 
      Caption         =   "Clear List"
      Height          =   330
      Left            =   6390
      TabIndex        =   18
      Top             =   2700
      Width           =   1005
   End
   Begin VB.ListBox List1 
      Height          =   2595
      Left            =   180
      TabIndex        =   17
      Top             =   3060
      Width           =   7215
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   3000
      Left            =   4860
      Top             =   90
   End
   Begin VB.TextBox txtScript 
      Height          =   285
      Left            =   1485
      TabIndex        =   14
      Top             =   2160
      Width           =   3480
   End
   Begin VB.CommandButton cmdBrowse2 
      Caption         =   "..."
      Height          =   330
      Left            =   5040
      TabIndex        =   13
      Top             =   2160
      Width           =   420
   End
   Begin VB.CommandButton cmdStop 
      Caption         =   "Stop"
      Height          =   315
      Left            =   6540
      TabIndex        =   12
      Top             =   1980
      Width           =   855
   End
   Begin VB.CommandButton cmdReplay 
      Caption         =   "Replay"
      Height          =   330
      Left            =   5520
      TabIndex        =   11
      Top             =   2160
      Width           =   915
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "..."
      Height          =   330
      Left            =   5085
      TabIndex        =   10
      Top             =   1755
      Width           =   420
   End
   Begin VB.TextBox txtSaveAs 
      Height          =   285
      Left            =   1530
      TabIndex        =   9
      Top             =   1755
      Width           =   3480
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   "Record"
      Height          =   330
      Left            =   5535
      TabIndex        =   7
      Top             =   1755
      Width           =   915
   End
   Begin VB.TextBox txtData 
      Height          =   330
      Left            =   1530
      TabIndex        =   6
      Top             =   1260
      Width           =   5775
   End
   Begin VB.Frame Frame1 
      Caption         =   "Arduino COM Port Connection"
      Height          =   960
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   7305
      Begin VB.CheckBox chkLogResponse 
         Caption         =   "Log Response"
         Height          =   195
         Left            =   4365
         TabIndex        =   16
         Top             =   450
         Width           =   1500
      End
      Begin VB.CommandButton Command1 
         Caption         =   "about"
         Height          =   375
         Left            =   5850
         TabIndex        =   4
         Top             =   360
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
   Begin VB.Label Label4 
      Caption         =   "Saved Script"
      Height          =   240
      Left            =   360
      TabIndex        =   15
      Top             =   2205
      Width           =   1005
   End
   Begin VB.Label Label3 
      Caption         =   "Save To"
      Height          =   240
      Left            =   765
      TabIndex        =   8
      Top             =   1800
      Width           =   645
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

Enum responses
    r_ok = 1
    r_waiting = 0
    r_error = 2
    r_timeout = 3
    r_complete = 4
    r_userabort = 5
End Enum

Const MAX_LONG As Long = 2147483468

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)


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

Function validate() As Boolean
    
    On Error Resume Next
    Dim uid As Long
    
    If Not MSComm1.PortOpen Then
        MsgBox "you must first select an open com Port from the list"
        Exit Function
    End If
    
     
End Function

Private Sub cmdBrowse2_Click()
    f = dlg.OpenDialog(AllFiles, , , Me.hWnd)
    If Len(f) = 0 Then Exit Sub
    txtScript = f
End Sub

Private Sub cmdRecord_Click()
    
    If Len(txtSaveAs) = 0 Then
        cmdSave_Click
        If Len(txtSaveAs) = 0 Then Exit Sub
    End If
    
    If fstream.FileHandle <> 0 Then fstream.fClose
    
    List1.Clear
    If fso.FileExists(txtSaveAs) Then Kill txtSaveAs
    fstream.fOpen txtSaveAs, otappend
    
    If fstream.FileHandle = 0 Then
        MsgBox "Failed to open file? Error:" & fstream.ErrMsg, vbInformation
    End If
    
End Sub

Private Sub cmdReplay_Click()

    If Len(txtScript) = 0 Then
        cmdBrowse2_Click
        If Len(txtScript) = 0 Then Exit Sub
    End If
    
    Dim i As Long
    List1.Clear
    
    tmp = Split(fso.ReadFile(txtScript), vbCrLf)
    For Each t In tmp
        
        Me.Caption = "Script command: " & i & "/" & UBound(tmp)
        Me.Refresh
                
        recvd = r_waiting
        MSComm1.Output = t & vbLf
        
        Timer1.Enabled = False
        Timer1.Enabled = True

        While recvd = r_waiting
            DoEvents
            Sleep 10
        Wend

        If recvd = r_timeout Then Exit For
        
        i = i + 1
    Next

    Timer1.Enabled = False
    
    If (i = UBound(tmp) + 1) Then recvd = r_complete
     
    Me.Caption = "Script Complete! Status: " & getStatus(recvd) & "  Step: " & i & "/" & UBound(tmp)
    
End Sub

Function getStatus(r As responses)
    If r = r_complete Then getStatus = "complete"
    If r = r_error Then getStatus = "error"
    If r = r_ok Then getStatus = "ok"
    If r = r_timeout Then getStatus = "timeout"
    If r = r_waiting Then getStatus = "waiting"
    If r = r_userabort Then getStatus = "user abort"
End Function

Private Sub cmdSave_Click()
    f = dlg.SaveDialog(AllFiles, , , , Me.hWnd)
    If Len(f) = 0 Then Exit Sub
    txtSaveAs = f
End Sub

Private Sub cmdStop_Click()
    On Error Resume Next
    fstream.fClose
    recvd = r_userabort
End Sub

Private Sub Command1_Click()

    MsgBox "Copyright David Zimmer <dzzie@yahoo.com>" & vbCrLf & _
            "All Rights Reserved" & vbCrLf & _
            "This software is free for personal use." & vbCrLf & vbCrLf, vbInformation
            
End Sub


'Private Sub Command4_Click()
'    On Error Resume Next
'    List1.AddItem "showcfg:"
'    MSComm1.Output = "showcfg:" & vbLf
'End Sub

Private Sub Form_Load()
         
    Set serial = New clsSerial
    serial.Configure MSComm1
    LoadPorts
    
    Const test = "c:\test.txt"
    If fso.FileExists(test) Then txtScript = test

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
    
    If fstream.FileHandle <> 0 Then
        fstream.WriteLine msg
        
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
