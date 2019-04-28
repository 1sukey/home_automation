VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSleeper"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Function CreateWaitableTimer Lib "kernel32" Alias "CreateWaitableTimerA" (ByVal lpSemaphoreAttributes As Long, ByVal bManualReset As Long, ByVal lpName As String) As Long
Private Declare Function OpenWaitableTimer Lib "kernel32" Alias "OpenWaitableTimerA" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal lpName As String) As Long
Private Declare Function SetWaitableTimer Lib "kernel32" (ByVal hTimer As Long, lpDueTime As FILETIME, ByVal lPeriod As Long, ByVal pfnCompletionRoutine As Long, ByVal lpArgToCompletionRoutine As Long, ByVal fResume As Long) As Long
Private Declare Function CancelWaitableTimer Lib "kernel32" (ByVal hTimer As Long)
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long

Private Const ERROR_ALREADY_EXISTS = 183&
Private Const WAIT_OBJECT_0 = 0
Private Const WAIT_TIMEOUT = &H102&

Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type

Private m_TimerObjectHandle As Long
Private m_dDelay As Double
Private m_tSleeperName As String

Public Event WakeUp()

Public Enum EnumSleeperErrors
    sleaperNoDelayError = vbObjectError + 512 + 2
    sleeperAlreadyInitError = vbObjectError + 512 + 3
    sleeperNotInitError = vbObjectError + 512 + 4
End Enum

'Private Sub cmdSleep_Click()
'   GoToSleep False
'End Sub

' Function to go to sleep.
' Slightly different behavior if called during form load
Public Property Get Delay() As Double 'In seconds
    Delay = m_dDelay
End Property

Public Property Get DelayNanoSeconds() As Double
    DelayNanoSeconds = m_dDelay / 100000000
End Property
Public Property Let DelayNanoSeconds(dDelay As Double)
    m_dDelay = dDelay / 100000000
End Property
Public Property Get DelayMilliSeconds() As Double
    DelayMilliSeconds = m_dDelay / 1000
End Property
Public Property Let DelayMilliSeconds(dDelay As Double)
    m_dDelay = dDelay / 1000
End Property
Public Property Get DelaySeconds() As Double
    DelaySeconds = m_dDelay
End Property
Public Property Let DelaySeconds(dDelay As Double)
    m_dDelay = dDelay
End Property
Public Property Get DelayMinutes() As Double
    DelayMinutes = m_dDelay / 60
End Property
Public Property Let DelayMinutes(dDelay As Double)
    m_dDelay = dDelay * 60
End Property
Public Property Get DelayHours() As Double
    DelayHours = (m_dDelay / 60) / 60
End Property
Public Property Let DelayHours(dDelay As Double)
    m_dDelay = (dDelay * 60) * 60
End Property

Public Property Get SleeperName() As String
    SleeperName = m_tSleeperName
End Property
Public Property Let SleeperName(tName As String)
    m_tSleeperName = tName
End Property

Private Sub GoToSleep(ByVal IsLoading As Boolean, Optional ByVal dDelay As Double = 0)
Dim ft As FILETIME
Dim IsBusy As Long
Dim dDelaylow As Double
Dim dUnit32 As Double
   
    On Error GoTo Handle_Error
    If m_TimerObjectHandle = 0 Then
        Err.Raise sleeperNotInitError, "fSleeper", "Sleeper hasn't been initialized"
        Exit Sub
    End If
    
    If dDelay = 0 Then
        If m_dDelay = 0 Then
            Err.Raise sleaperNoDelayError, "fSleeper", "No Delay was set"
            Exit Sub
        Else
            dDelay = m_dDelay
        End If
    End If
    
   ' Is object signaled now?
   IsBusy = WaitForSingleObject(m_TimerObjectHandle, 0)
      
   ' We know WAIT_OBJECT_0 is 0, so False indicates signaled
   If IsLoading Then
      If IsBusy Then
         'MsgBox "Hey! Everyone else is asleep already! I'm going to join them!", vbOKOnly, "I'm Tired"
      Else
         ' It's not active
         Exit Sub
      End If
   End If
   ' Update in case state changed during message box
   IsBusy = WaitForSingleObject(m_TimerObjectHandle, 0)
   If Not IsBusy Then
      ' Set the timer
      dUnit32 = CDbl(&H10000) * CDbl(&H10000)
      'dDelay = CDbl(txtSeconds.Text)
      dDelay = dDelay * 1000 * 10000
      ' dDelay is now 100ns
         
      ft.dwHighDateTime = -CLng(dDelay / dUnit32) - 1
      
      dDelaylow = -dUnit32 * (dDelay / dUnit32 - Fix(dDelay / dUnit32))
      If dDelaylow < CDbl(&H80000000) Then
         dDelaylow = dUnit32 + dDelaylow
      End If
      ft.dwLowDateTime = CLng(dDelaylow)
      
      SetWaitableTimer m_TimerObjectHandle, ft, 0, 0, 0, 0
   End If
   'App.TaskVisible = False
   IsBusy = WaitForSingleObject(m_TimerObjectHandle, -1)
   RaiseEvent WakeUp
   'frmMorning.Move Me.Left, Me.Top
   'frmMorning.Show vbModal
   'Me.Show
   'App.TaskVisible = True
    Exit Sub
Handle_Error:
    Err.Raise Err.Number, Err.Source, Err.Description
End Sub

Public Sub Init()
Dim ft As FILETIME
    On Error GoTo Handle_Error
    If m_TimerObjectHandle = 0 Then
        m_TimerObjectHandle = CreateWaitableTimer(0, True, m_tSleeperName)
        If Err.LastDllError = ERROR_ALREADY_EXISTS Then
           ' Another app already created the timer,
           ' we may need to go to sleep now
           GoToSleep True
        Else
           ft.dwLowDateTime = -1
           ft.dwHighDateTime = -1
           SetWaitableTimer m_TimerObjectHandle, ft, 0, 0, 0, 0
        End If
    Else
        Err.Raise sleeperAlreadyInitError, "fSleeper", "Sleeper has already been Initialized"
    End If
    Exit Sub
Handle_Error:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub

Public Sub SleepTime(Optional dDelay As Double = 0)
    GoToSleep False, dDelay
End Sub
Private Sub Class_Initialize()
    m_TimerObjectHandle = 0
    m_tSleeperName = "MySleeperName"
End Sub

Private Sub Class_Terminate()
    CloseHandle m_TimerObjectHandle
End Sub
