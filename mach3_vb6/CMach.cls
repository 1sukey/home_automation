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
Public mach As Mach4.CMach4Doc
Public oScript As Object

Public Enum dros
    dro_x = 0
    dro_y = 1
    dro_z = 2
End Enum

Public Enum uis
    ui_Program_Run = 1
    ui_MDI = 2
    ui_Toolpath = 3
    ui_Positioning = 4
    ui_Diagnostics = 5
    ui_Corrections = 6
End Enum

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal pDest As Long, ByRef pSrc As Long, ByVal ByteLen As Long)

'see rtf for all the methods and prototypes that oScript object supports.
'todo:
'    Sub DoButton (ByVal Function  As Integer )
'    Function GetScale(ByVal Axis As Integer) As Double
'    Sub SetScale (  ByVal Axis  As Integer , ByVal Scale  As Double )
'    Function CommandedFeed() As Double


'some OEM codes of possible interest.. (from OEMCOdes.csv on ftp)
'4   Load G-code 32  1   216
'6   Feed per Min    56  1   39
'6   Feed per Rev    56  1   40
'4   Jog mode Continuous 32  1   204
'4   Jog mode Incremental    32  1   205
'4   Joystick On 32  1   206
'4   Joystick Off    32  1   207
'4   Close File  32  1   169
'4   ReLoad  32  1   170
'4   Zero X-Y    32  1   161
'4   Coordinate mode 32  1   162
'4   Raise spindle speed 32  1   163
'4   Lower spindle speed 32  1   164
'4   Set next line   32  1   156
'4   Go Home 32  1   138
'4   Slow Jog Up 32  1   111
'4   Slow Jog Dn 32  1   112
'4   Flood   32  1   113
'4   Mist    32  1   114
'4   Goto Safe Z 32  1   104
'4   Jog mode toggle 32  1   103

'1   X Machine Coord DRO 12  1   83
'1   Y Machine Coord DRO 12  1   84
'1   Z Machine Coord DRO 12  1   85
'

Public Enum OEMCodes
    oem_FeedPerMin = 39
    oem_FeedPerRev = 40
    oem_JogCont = 204
    oem_JogInc = 205
    oem_JogModeToggle = 103
    oem_JoyStickOn = 206
    oem_JoyStickOff = 207
    oem_CloseFile = 169
    oem_Reload = 170
    oem_GoHome = 138
    oem_Flood = 113
End Enum

 
 
Property Get isMachInit()
    isMachInit = Not mach Is Nothing
End Property

Property Get IsEstop()
    On Error Resume Next
    IsEstop = oScript.IsEstop
End Property
 
Property Get IsStopped()
    On Error Resume Next
    IsStopped = oScript.IsStopped
End Property

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

Function ReadDRO(x As dros) As String
    On Error Resume Next
    ReadDRO = oScript.GetDROString(x)
End Function

Sub SetDRO(x As dros, val As Double)
    On Error Resume Next
    oScript.SetDRO x, val
End Sub

Sub UserMsg(msg As String)
    On Error Resume Next
    oScript.Message msg
End Sub

Sub RunGCode(singleLine As String)
    On Error Resume Next
    oScript.code singleLine
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

Function FileName() As String
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




Property Get RPM() As Double
    On Error Resume Next
    RPM = oScript.GetRPM()
End Property

Property Let RPM(x As Double)
    On Error Resume Next
    oScript.SetSpinSpeed x
End Property

Property Get FeedRate() As Double
    On Error Resume Next
    FeedRate = oScript.FeedRate()
End Property

Property Let FeedRate(x As Double)
    On Error Resume Next
    oScript.SetFeedRate x  'this is screwy right now 12.123 -> 720 ??
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

Sub DoSpinCW()
    On Error Resume Next
    oScript.DoSpinCW
End Sub

Sub DoSpinCCW()
    On Error Resume Next
    oScript.DoSpinCCW 'this always seems to do CW ?
End Sub

Sub DoSpinStop()
    On Error Resume Next
    oScript.DoSpinStop
End Sub

Sub RunProgram(program As String)
    On Error Resume Next
    oScript.RunProgram program 'does not seem to work like this test: mach.RunProgram("g0 x1 y1" & vbcrlf & "y2")
End Sub

