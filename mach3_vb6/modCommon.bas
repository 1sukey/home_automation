Attribute VB_Name = "modCommon"
Option Explicit


'if mach 3 is installed on the system this registry key will tell us where:
'[HKEY_CLASSES_ROOT\CLSID\{2DD5D509-E89E-4825-87D3-A939E689BD25}\InprocServer32]
'@="C:\\Mach3\\NTgraph.ocx"

'if mach3 is installed, _and running_ , but we can not get a reference to it,
'it must be a newer version with the missing regkeys.

'I extracted a handfull of regkeys, but apparently the only
'one that is required on XP/2k is the following:

'[HKEY_CLASSES_ROOT\Mach4.Document\CLSID]
'@="{CA7992B2-2653-4342-8061-D7D385C07809}"

'this may be a shortcut the complete set of extracted keys can be found in the mach_regKeys sub folder..
'if you installed to a non-default path (c:\mach3) you have to edit these files..
'for vista+ machines, adding this registry key may require "run as administrator" rights.


Private Declare Function ProcessFirst Lib "Kernel32" Alias "Process32First" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function ProcessNext Lib "Kernel32" Alias "Process32Next" (ByVal hSnapshot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function CreateToolhelpSnapshot Lib "Kernel32" Alias "CreateToolhelp32Snapshot" (ByVal lFlags As Long, lProcessID As Long) As Long

Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Private Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, lpSecurityAttributes As SECURITY_ATTRIBUTES, phkResult As Long, lpdwDisposition As Long) As Long
Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long

Private Const TH32CS_SNAPPROCESS = 2

Private Const REG_OPTION_BACKUP_RESTORE = 4     ' open for backup or restore
Private Const REG_OPTION_VOLATILE = 1           ' Key is not preserved when system is rebooted
Private Const REG_OPTION_NON_VOLATILE = 0       ' Key is preserved when system is rebooted


Private Const STANDARD_RIGHTS_ALL = &H1F0000
Private Const SYNCHRONIZE = &H100000
Private Const READ_CONTROL = &H20000
Private Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Private Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)
Private Const KEY_CREATE_LINK = &H20
Private Const KEY_CREATE_SUB_KEY = &H4
Private Const KEY_ENUMERATE_SUB_KEYS = &H8
Private Const KEY_NOTIFY = &H10
Private Const KEY_QUERY_VALUE = &H1
Private Const KEY_SET_VALUE = &H2
Private Const KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
Private Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
Private Const KEY_EXECUTE = (KEY_READ)
Private Const KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))

Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Boolean
End Type

Private Enum hKey
    HKEY_CLASSES_ROOT = &H80000000
    HKEY_CURRENT_USER = &H80000001
    HKEY_LOCAL_MACHINE = &H80000002
    HKEY_USERS = &H80000003
    HKEY_PERFORMANCE_DATA = &H80000004
    HKEY_CURRENT_CONFIG = &H80000005
    HKEY_DYN_DATA = &H80000006
End Enum

Private Enum dataType
    REG_BINARY = 3                     ' Free form binary
    REG_DWORD = 4                      ' 32-bit number
    'REG_DWORD_BIG_ENDIAN = 5           ' 32-bit number
    'REG_DWORD_LITTLE_ENDIAN = 4        ' 32-bit number (same as REG_DWORD)
    'REG_EXPAND_SZ = 2                  ' Unicode nul terminated string
    'REG_MULTI_SZ = 7                   ' Multiple Unicode strings
    REG_SZ = 1                         ' Unicode nul terminated string
End Enum

Private Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szexeFile As String * 260
End Type

Function isMachInstalled() As Boolean
    
    If RegKeyExists(HKEY_CLASSES_ROOT, "\CLSID\{2DD5D509-E89E-4825-87D3-A939E689BD25}\InprocServer32") Then
        isMachInstalled = True
        Exit Function
    End If
    
End Function

Function isMachCOMObjRegistered() As Boolean
    
    If RegKeyExists(HKEY_CLASSES_ROOT, "\Mach4.Document\CLSID") Then
        isMachCOMObjRegistered = True
        Exit Function
    End If
    
End Function

Function RegisterMachCOMType() As Boolean

    If Not RegCreateKey(HKEY_CLASSES_ROOT, "\Mach4.Document\") Then Exit Function
    If Not RegCreateKey(HKEY_CLASSES_ROOT, "\Mach4.Document\CLSID") Then Exit Function
    If Not RegSetVal(HKEY_CLASSES_ROOT, "\Mach4.Document\CLSID", "", "{CA7992B2-2653-4342-8061-D7D385C07809}") Then Exit Function
    
    RegisterMachCOMType = True
    
End Function

Private Function RegCreateKey(hive As hKey, path) As Boolean
    Dim sec As SECURITY_ATTRIBUTES, result As Long, ret As Long
    Dim p As String
  
    p = stdPath(path)
    RegCreateKeyEx hive, p, 0, "REG_DWORD", REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, sec, result, ret
    RegCreateKey = IIf(result = 0, False, True)
End Function

Private Function RegSetVal(hive As hKey, path, KeyName, data, Optional dType As dataType = REG_SZ) As Boolean
    Dim p As String, ret As Long, handle As Long
  
    p = stdPath(path)
    RegOpenKeyEx hive, p, 0, KEY_ALL_ACCESS, handle
    Select Case dType
        Case REG_SZ
            ret = RegSetValueEx(handle, CStr(KeyName), 0, dType, ByVal CStr(data), Len(data))
        Case REG_BINARY
            ret = RegSetValueEx(handle, CStr(KeyName), 0, dType, ByVal CStr(data), Len(data))
        Case REG_DWORD
            ret = RegSetValueEx(handle, CStr(KeyName), 0, dType, CLng(data), 4)
    End Select
    RegCloseKey handle
    RegSetVal = IIf(ret = 0, True, False)
End Function

Private Function RegKeyExists(hive As hKey, path) As Boolean
  Dim x As Long
  Dim p As String, handle As Long
  
  p = stdPath(path)
  x = RegOpenKeyEx(hive, p, 0, KEY_QUERY_VALUE, handle)
  RegKeyExists = IIf(x = 0, True, False)
  RegCloseKey handle
  
End Function


Function isMachRunning() As Boolean
    
    Dim c As Collection
    Dim path
    
    Set c = GetRunningProcesses()
    
    For Each path In c
        If InStr(1, path, "mach3.exe", vbTextCompare) > 0 Then
            isMachRunning = True
            Exit Function
        End If
    Next
    
End Function

Private Function GetRunningProcesses() As Collection

    Dim m_col As New Collection
    Dim myProcess As PROCESSENTRY32
    Dim mySnapshot As Long
    Dim n As Long
    Dim path As String
    
    myProcess.dwSize = Len(myProcess)
    mySnapshot = CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0&)

    ProcessFirst mySnapshot, myProcess

    If myProcess.th32ProcessID <> 0 Then
        path = myProcess.szexeFile
        If InStr(path, Chr(0)) > 0 Then
           path = Mid(path, 1, InStr(path, Chr(0)) - 1)
        End If
        m_col.Add path
    End If

    While ProcessNext(mySnapshot, myProcess)

        If myProcess.th32ProcessID <> 4 Then
            path = myProcess.szexeFile
            If InStr(path, Chr(0)) > 0 Then
               path = Mid(path, 1, InStr(path, Chr(0)) - 1)
            End If

            path = Replace(path, "\??\", Empty)
            path = Replace(path, "\SystemRoot", Environ("Windir"))

            m_col.Add path
        End If

    Wend

    Set GetRunningProcesses = m_col

End Function



'Sub push(ary, value) 'this modifies parent ary object
'    Dim x As Long
'    On Error GoTo init
'    x = UBound(ary) '<-throws Error If Not initalized
'    ReDim Preserve ary(UBound(ary) + 1)
'    ary(UBound(ary)) = value
'    Exit Sub
'init:     ReDim ary(0): ary(0) = value
'End Sub

Private Function stdPath(sIn) As String
    stdPath = Replace(sIn, "/", "\")
    If Left(stdPath, 1) = "\" Then stdPath = Mid(stdPath, 2, Len(stdPath))
    If Right(stdPath, 1) <> "\" Then stdPath = stdPath & "\"
End Function
