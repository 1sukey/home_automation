VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMach"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal pDest As Long, ByRef pSrc As Long, ByVal ByteLen As Long)

Public mach As Mach4.CMach4Doc
Public oScript As Object

Public Enum axs
    axis_x = 0
    axis_y = 1
    axis_z = 2
End Enum

Public Enum uis
    ui_Program_Run = 1
    ui_MDI = 2
    ui_Toolpath = 3
    ui_Positioning = 4
    ui_Diagnostics = 5
    ui_Corrections = 6
End Enum


'OEM codes and descriptions for the oScript interface can be found in Mach3_V3.x_Macro_Prog_Ref.pdf
'see rtf for a dump of all the methods and prototypes that oScript object supports.
'todo:
'    Function GetScale(ByVal Axis As Integer) As Double
'    Sub SetScale (  ByVal Axis  As Integer , ByVal Scale  As Double )
'    SetParam/GetParam gives you allot of control over config.. <--

'this is just some interesting OEM codes..there are many..these ones arent repeat of other funcs below..
Public Enum OEMCodes
    oem_FeedPerMin = 39
    oem_FeedPerRev = 40
    oem_JogCont = 204
    oem_JogInc = 205
    oem_JogModeToggle = 103
    oem_JoyStickOn = 206  '158?
    oem_JoyStickOff = 207 '159?
    oem_CloseFile = 169
    oem_Reload = 170
    oem_GoHome = 138
    oem_Flood = 113
    oem_Start = 1000
    oem_RewindGCode = 1002
    oem_PauseFeedHold = 1001
    oem_Stop = 1003
    oem_Resume = 1005
    oem_Reset = 1021
    oem_SoftlimitsToggle = 1029
End Enum


'start an axis jogging in a specified direction at the current default jog speed.
Sub JogOn(axis As axs, Optional posDirection As Boolean)
    On Error Resume Next
    oScript.JogOn axis, IIf(posDirection, 0, 1)
End Sub

Sub JogOff(axis As axs)
    On Error Resume Next
    oScript.JogOff axis
End Sub
  
Property Get isMachInit()
    isMachInit = Not mach Is Nothing
End Property

Property Get IsEstop()
    On Error Resume Next
    IsEstop = oScript.IsEstop
End Property
 
'This function returns 1 if all axes are currently stopped.
Property Get IsStopped()
    On Error Resume Next
    IsStopped = oScript.IsStopped
End Property

'This function returns 1 if Safe_Z isenabled in Config->Safe_Z Setup.
Property Get IsSafeZ()
    On Error Resume Next
    IsSafeZ = oScript.IsSafeZ
End Property

Property Get IsMoving()
    On Error Resume Next
    IsMoving = oScript.IsMoving
End Property

Property Get IsFirst()
    On Error Resume Next
    IsFirst = oScript.IsFirst
End Property

Property Get IsLoading()
    On Error Resume Next
    IsLoading = oScript.IsLoading
End Property

Function ReadDRO(x As axs) As String
    On Error Resume Next
    ReadDRO = oScript.GetDROString(x)
End Function

Sub SetDRO(x As axs, val As Double)
    On Error Resume Next
    oScript.SetDRO x, val
End Sub

Sub UserMsg(msg As String)
    On Error Resume Next
    oScript.Message msg
End Sub

Sub RunGCode(singleLine As String, Optional andBlock As Boolean = True)
    On Error Resume Next
    oScript.code singleLine
    If andBlock Then
        While Me.IsMoving
            DoEvents
        Wend
    End If
End Sub

Sub LoadFile(path As String, Optional andRun As Boolean)
    On Error Resume Next
    oScript.LoadFile path
    If andRun Then RunLoadedFile
End Sub

Sub RunLoadedFile()
    On Error Resume Next
    oScript.RunFile
End Sub

Function FileName() As String ' returns No File Loaded. if none loaded..
    On Error Resume Next
    FileName = oScript.FileName()
End Function

Sub GotoUIPage(ui As uis)
    On Error Resume Next
    Me.SendOEMCode ui
End Sub

Sub SendOEMCode(code As OEMCodes)
    On Error Resume Next
    oScript.DoOEMButton code
End Sub


Public Function InitMach() As Boolean
    On Error Resume Next
    Set mach = GetObject(, "Mach4.Document")
    If mach Is Nothing Then Exit Function
    IncrementRefCount mach
    Set oScript = mach.GetScriptDispatch()
    If Err.Number = 0 Then InitMach = True
End Function

'mach does not properly increment its ref count when using GetObject()
'on a running instance, so we need to artifically do it for it..
'otherwise when our vb app shuts down, the interface will be removed from memory.
'an wont be available until mach is restarted..
Private Sub IncrementRefCount(target As Object)

    Dim tempObj As Object
    Set tempObj = target 'VB6 calls AddRef for you here
    
    'MsgBox "Obj=" & Hex(VarPtr(tempObj))
    
    'we set our variable to 0 (nothing) outside of vb's knowledge,
    'so when it checks as variable goes out of scope, it thinks
    'there is nothing to do and does not call release
    Call CopyMemory(ByVal VarPtr(tempObj), 0, 4)
    

End Sub




Property Get SpindleRPM() As Double
    On Error Resume Next
    SpindleRPM = oScript.GetRPM()
End Property

Property Let SpindleRPM(x As Double)
    On Error Resume Next
    oScript.SetSpinSpeed x
End Property

Property Get FeedRate() As Double
    On Error Resume Next
    FeedRate = oScript.FeedRate()
End Property

Property Let FeedRate(unitsPerSecond As Double)
    On Error Resume Next
    oScript.SetFeedRate unitsPerSecond  'note: FeedRate = 12 -> 720  which is 12 * 60..divide by 60 to make more intutive?
End Property

Property Get SafeZ() As Double
    On Error Resume Next
    SafeZ = oScript.GetSafeZ()
End Property

Property Let SafeZ(x As Double)
    On Error Resume Next
    oScript.SetSafeZ x
End Property

Sub GotoSafeZ()
    On Error Resume Next
    oScript.GotoSafeZ 'safe z has to be enabled in config / safe z setup
End Sub

Sub StartSpindle(Optional clockWise As Boolean = True, Optional setRPM As Double = -1)
    On Error Resume Next
    If setRPM > 0 Then Me.SpindleRPM = setRPM
    If clockWise Then
        oScript.DoSpinCW
    Else
        oScript.DoSpinCCW 'this always show CW ? m4 gives same output..
    End If
End Sub

Sub StopSpindle()
    On Error Resume Next
    oScript.DoSpinStop
End Sub

Sub RunProgram(program As String)
    On Error Resume Next
    oScript.RunProgram program 'does not seem to work like this test: mach.RunProgram("g0 x1 y1" & vbcrlf & "y2")
End Sub

