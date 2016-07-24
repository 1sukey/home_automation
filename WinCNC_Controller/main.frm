VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Begin VB.Form Main 
   BackColor       =   &H8000000A&
   Caption         =   "WinCNC Controller"
   ClientHeight    =   9735
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   13170
   LinkTopic       =   "Form1"
   ScaleHeight     =   9735
   ScaleWidth      =   13170
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdGrid 
      Caption         =   "Grid"
      Height          =   255
      Left            =   1080
      TabIndex        =   77
      Top             =   1200
      Width           =   735
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   4548
      Index           =   2
      Left            =   5520
      ScaleHeight     =   4545
      ScaleWidth      =   2055
      TabIndex        =   63
      TabStop         =   0   'False
      Top             =   2040
      Width           =   2052
      Begin VB.Frame Frame3 
         Caption         =   "Joystick"
         Height          =   4404
         Index           =   1
         Left            =   0
         TabIndex        =   64
         Top             =   0
         Width           =   1932
         Begin VB.CommandButton cmdJoystick 
            Caption         =   "Disable"
            Height          =   255
            Left            =   360
            TabIndex        =   78
            Top             =   4080
            Width           =   1215
         End
         Begin VB.Label Label20 
            Caption         =   "Thumb Control"
            Height          =   255
            Left            =   120
            TabIndex        =   76
            Top             =   3480
            Width           =   1215
         End
         Begin VB.Label Label19 
            Caption         =   "A Axis:"
            Height          =   255
            Left            =   120
            TabIndex        =   75
            Top             =   2880
            Width           =   975
         End
         Begin VB.Label Label18 
            Caption         =   "Z Axis:"
            Height          =   255
            Left            =   120
            TabIndex        =   74
            Top             =   2280
            Width           =   1335
         End
         Begin VB.Label Label17 
            Caption         =   "Y Axis:"
            Height          =   255
            Left            =   120
            TabIndex        =   73
            Top             =   1680
            Width           =   1455
         End
         Begin VB.Label Label16 
            Caption         =   "X Axis:"
            Height          =   255
            Left            =   120
            TabIndex        =   72
            Top             =   1080
            Width           =   1455
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   0
            Left            =   120
            TabIndex        =   71
            Top             =   720
            Width           =   1005
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   70
            Top             =   1320
            Width           =   1005
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   2
            Left            =   120
            TabIndex        =   69
            Top             =   1920
            Width           =   1005
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   3
            Left            =   120
            TabIndex        =   68
            Top             =   2520
            Width           =   1005
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   4
            Left            =   120
            TabIndex        =   67
            Top             =   3120
            Width           =   1005
         End
         Begin VB.Label Label14 
            BackStyle       =   0  'Transparent
            Caption         =   "X"
            ForeColor       =   &H00800000&
            Height          =   285
            Index           =   5
            Left            =   120
            TabIndex        =   66
            Top             =   3720
            Width           =   1005
         End
         Begin VB.Label Label15 
            Caption         =   "Button:"
            Height          =   255
            Left            =   120
            TabIndex        =   65
            Top             =   480
            Width           =   735
         End
      End
   End
   Begin VB.CommandButton cmdRecompile 
      Caption         =   "Recompile"
      Height          =   495
      Left            =   10560
      TabIndex        =   62
      Top             =   7800
      Width           =   1335
   End
   Begin VB.CommandButton Reset 
      Caption         =   "Reset"
      Height          =   495
      Left            =   480
      TabIndex        =   61
      Top             =   7920
      Width           =   1335
   End
   Begin VB.CommandButton PortMonitor 
      Caption         =   "Port Monitor"
      Height          =   495
      Left            =   480
      TabIndex        =   60
      Top             =   8640
      Width           =   1335
   End
   Begin VB.CommandButton ArrowLT 
      Height          =   495
      Left            =   2880
      Picture         =   "main.frx":0000
      Style           =   1  'Graphical
      TabIndex        =   59
      Top             =   7680
      Width           =   495
   End
   Begin VB.CommandButton ArrowLB 
      Height          =   495
      Left            =   2880
      Picture         =   "main.frx":0442
      Style           =   1  'Graphical
      TabIndex        =   58
      Top             =   8880
      Width           =   495
   End
   Begin VB.CommandButton ArrowRT 
      Height          =   495
      Left            =   4080
      Picture         =   "main.frx":0884
      Style           =   1  'Graphical
      TabIndex        =   57
      Top             =   7680
      Width           =   495
   End
   Begin VB.CommandButton ArrowRight 
      Height          =   495
      Left            =   4080
      Picture         =   "main.frx":0CC6
      Style           =   1  'Graphical
      TabIndex        =   56
      Top             =   8280
      Width           =   495
   End
   Begin VB.CommandButton ArrowRB 
      Height          =   495
      Left            =   4080
      Picture         =   "main.frx":1108
      Style           =   1  'Graphical
      TabIndex        =   55
      Top             =   8880
      Width           =   495
   End
   Begin VB.CommandButton ArrowLeft 
      Height          =   495
      Left            =   2880
      Picture         =   "main.frx":154A
      Style           =   1  'Graphical
      TabIndex        =   54
      Top             =   8280
      Width           =   495
   End
   Begin VB.CommandButton ArrowUp 
      Height          =   495
      Left            =   3480
      Picture         =   "main.frx":198C
      Style           =   1  'Graphical
      TabIndex        =   53
      Top             =   7680
      Width           =   495
   End
   Begin VB.CommandButton ArrowDown 
      Height          =   495
      Left            =   3480
      Picture         =   "main.frx":1DCE
      Style           =   1  'Graphical
      TabIndex        =   52
      Top             =   8880
      Width           =   495
   End
   Begin VB.CommandButton ArrowZUp 
      Height          =   495
      Left            =   5040
      Picture         =   "main.frx":2210
      Style           =   1  'Graphical
      TabIndex        =   51
      Top             =   7920
      Width           =   495
   End
   Begin VB.CommandButton ArrowZDown 
      Height          =   495
      Left            =   5040
      Picture         =   "main.frx":2652
      Style           =   1  'Graphical
      TabIndex        =   50
      Top             =   8640
      Width           =   495
   End
   Begin VB.TextBox ZPos 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   375
      Left            =   6600
      Locked          =   -1  'True
      TabIndex        =   46
      Text            =   "0"
      Top             =   8880
      Width           =   1575
   End
   Begin VB.TextBox YPos 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   375
      Left            =   6600
      Locked          =   -1  'True
      TabIndex        =   45
      Text            =   "0"
      Top             =   8400
      Width           =   1575
   End
   Begin VB.TextBox XPos 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   375
      Left            =   6600
      Locked          =   -1  'True
      TabIndex        =   44
      Text            =   "0"
      Top             =   7920
      Width           =   1575
   End
   Begin VB.CommandButton ZeroX 
      Caption         =   "Zero"
      Height          =   375
      Left            =   8400
      TabIndex        =   43
      Top             =   7920
      Width           =   495
   End
   Begin VB.CommandButton ZeroY 
      Caption         =   "Zero"
      Height          =   375
      Left            =   8400
      TabIndex        =   42
      Top             =   8400
      Width           =   495
   End
   Begin VB.CommandButton ZeroZ 
      Caption         =   "Zero"
      Height          =   375
      Left            =   8400
      TabIndex        =   41
      Top             =   8880
      Width           =   495
   End
   Begin RichTextLib.RichTextBox GCEdit 
      Height          =   6015
      Left            =   9360
      TabIndex        =   40
      Top             =   1560
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   10610
      _Version        =   393217
      BackColor       =   12640511
      Enabled         =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"main.frx":2A94
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   4548
      Index           =   1
      Left            =   3240
      ScaleHeight     =   4545
      ScaleWidth      =   2055
      TabIndex        =   32
      TabStop         =   0   'False
      Top             =   2040
      Width           =   2052
      Begin VB.Frame Frame3 
         Caption         =   "CNC/G-Code"
         Height          =   4404
         Index           =   0
         Left            =   120
         TabIndex        =   33
         Top             =   0
         Width           =   1932
         Begin VB.TextBox TextIsoFormat 
            Height          =   288
            Left            =   120
            TabIndex        =   36
            Text            =   "IsoFormat"
            Top             =   720
            Width           =   1692
         End
         Begin VB.TextBox TextLineNumberFormat 
            Height          =   288
            Left            =   120
            TabIndex        =   35
            Text            =   "LineNumberFormat"
            Top             =   1440
            Width           =   1692
         End
         Begin VB.TextBox TextAdditionalScaling 
            Height          =   288
            Left            =   120
            TabIndex        =   34
            Text            =   "AdditionalScaling"
            Top             =   2160
            Width           =   1692
         End
         Begin VB.Label Label8 
            Caption         =   "IsoFormat"
            Height          =   252
            Left            =   120
            TabIndex        =   39
            Top             =   480
            Width           =   1692
         End
         Begin VB.Label Label9 
            Caption         =   "Line Number Format"
            Height          =   252
            Left            =   120
            TabIndex        =   38
            Top             =   1200
            Width           =   1692
         End
         Begin VB.Label Label10 
            Caption         =   "Additional downscaling"
            Height          =   252
            Left            =   120
            TabIndex        =   37
            Top             =   1920
            Width           =   1692
         End
      End
   End
   Begin VB.CommandButton cmdCollect 
      Caption         =   "Collect"
      Enabled         =   0   'False
      Height          =   252
      Left            =   1680
      TabIndex        =   30
      Top             =   120
      Width           =   1092
   End
   Begin VB.CommandButton cmdGenerate 
      Caption         =   "Generate"
      Enabled         =   0   'False
      Height          =   252
      Left            =   1680
      TabIndex        =   29
      Top             =   480
      Width           =   1092
   End
   Begin VB.CommandButton cmdPath 
      Caption         =   "Path"
      Height          =   252
      Left            =   1800
      TabIndex        =   28
      Top             =   840
      Width           =   492
   End
   Begin VB.TextBox pathnumber 
      Height          =   288
      Left            =   2400
      TabIndex        =   27
      Top             =   840
      Width           =   372
   End
   Begin VB.PictureBox picOptions 
      BorderStyle     =   0  'None
      Height          =   4548
      Index           =   0
      Left            =   120
      ScaleHeight     =   4545
      ScaleWidth      =   2055
      TabIndex        =   24
      TabStop         =   0   'False
      Top             =   1920
      Width           =   2052
      Begin VB.Frame Frame2 
         Caption         =   "Infos"
         Height          =   4425
         Left            =   0
         TabIndex        =   25
         Top             =   120
         Width           =   2052
         Begin VB.TextBox Text1 
            Height          =   4000
            Left            =   120
            MultiLine       =   -1  'True
            ScrollBars      =   2  'Vertical
            TabIndex        =   26
            Text            =   "main.frx":2B16
            Top             =   240
            Width           =   1812
         End
      End
   End
   Begin VB.CommandButton CmdDraw 
      Caption         =   "ReDraw"
      Height          =   252
      Left            =   1080
      TabIndex        =   22
      Top             =   840
      Width           =   732
   End
   Begin VB.CommandButton ComResetScaling 
      Caption         =   "Reset"
      Height          =   252
      Left            =   3600
      TabIndex        =   21
      Top             =   1200
      Width           =   732
   End
   Begin VB.TextBox TextOffY 
      Height          =   288
      Left            =   4920
      TabIndex        =   17
      Text            =   "OffX"
      Top             =   840
      Width           =   852
   End
   Begin VB.TextBox TextOffX 
      Height          =   288
      Left            =   4920
      TabIndex        =   16
      Text            =   "OffY"
      Top             =   1200
      Width           =   852
   End
   Begin VB.TextBox TextMaxY 
      Enabled         =   0   'False
      Height          =   288
      Left            =   7800
      TabIndex        =   10
      Text            =   "MaxY"
      Top             =   1200
      Width           =   852
   End
   Begin VB.TextBox TextMaxX 
      Enabled         =   0   'False
      Height          =   288
      Left            =   7800
      TabIndex        =   9
      Text            =   "MaxX"
      Top             =   840
      Width           =   852
   End
   Begin VB.TextBox TextMinY 
      Enabled         =   0   'False
      Height          =   288
      Left            =   6360
      TabIndex        =   8
      Text            =   "MinY"
      Top             =   1200
      Width           =   852
   End
   Begin VB.TextBox TextMinX 
      Enabled         =   0   'False
      Height          =   288
      Left            =   6360
      TabIndex        =   7
      Text            =   "MinX"
      Top             =   840
      Width           =   852
   End
   Begin VB.TextBox TextScaling 
      Height          =   288
      Left            =   3480
      TabIndex        =   6
      Text            =   "DisplayScale"
      Top             =   840
      Width           =   852
   End
   Begin VB.CommandButton cmdCLR 
      Caption         =   "CLR"
      Height          =   252
      Left            =   480
      TabIndex        =   5
      ToolTipText     =   "Clears the drawing"
      Top             =   840
      Width           =   612
   End
   Begin VB.CommandButton CmdGOutput 
      Caption         =   "Select out CNC file"
      Height          =   252
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   2
      ToolTipText     =   "Choose the output file name that will be generated with Draw"
      Top             =   480
      Width           =   1572
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   688
      _ExtentY        =   688
      _Version        =   393216
   End
   Begin VB.CommandButton cmdOpen 
      Caption         =   "Open"
      Height          =   252
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   120
      Width           =   1572
   End
   Begin MSComctlLib.TabStrip tbsOptions 
      Height          =   6000
      Left            =   0
      TabIndex        =   23
      Top             =   1560
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   10583
      MultiRow        =   -1  'True
      TabMinWidth     =   1005
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   3
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Msg"
            Key             =   "Group1"
            Object.ToolTipText     =   "Shows variuos informations"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "CNC"
            Key             =   "Group4"
            Object.ToolTipText     =   "Various CNC/G-code settings"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Joystick"
            Key             =   "Group3"
            Object.ToolTipText     =   "Joystick postitions"
            ImageVarType    =   2
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComDlg.CommonDialog ColorDialog 
      Left            =   360
      Top             =   0
      _ExtentX        =   688
      _ExtentY        =   688
      _Version        =   393216
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      Height          =   6000
      Left            =   2640
      ScaleHeight     =   5940
      ScaleWidth      =   6705
      TabIndex        =   4
      Top             =   1560
      Width           =   6765
   End
   Begin VB.Label Label13 
      BackColor       =   &H8000000A&
      Caption         =   "Z:"
      Height          =   255
      Left            =   6240
      TabIndex        =   49
      Top             =   9000
      Width           =   255
   End
   Begin VB.Label Label12 
      BackColor       =   &H8000000A&
      Caption         =   "Y:"
      Height          =   255
      Left            =   6240
      TabIndex        =   48
      Top             =   8520
      Width           =   255
   End
   Begin VB.Label Label11 
      BackColor       =   &H8000000A&
      Caption         =   "X:"
      Height          =   255
      Left            =   6240
      TabIndex        =   47
      Top             =   8040
      Width           =   255
   End
   Begin VB.Label LabelGFileTemp 
      Caption         =   "LabelGFileTemp"
      Height          =   255
      Left            =   6480
      TabIndex        =   31
      Top             =   480
      Visible         =   0   'False
      Width           =   2175
   End
   Begin VB.Label Label7 
      BackColor       =   &H8000000A&
      Caption         =   "Scale"
      Height          =   252
      Left            =   2880
      TabIndex        =   20
      Top             =   840
      Width           =   492
   End
   Begin VB.Shape ShapeBusy 
      FillColor       =   &H0000C000&
      FillStyle       =   0  'Solid
      Height          =   252
      Left            =   120
      Shape           =   3  'Circle
      Top             =   840
      Width           =   252
   End
   Begin VB.Label Label6 
      BackColor       =   &H8000000A&
      Caption         =   "OffY"
      Height          =   252
      Left            =   4440
      TabIndex        =   19
      Top             =   1200
      Width           =   372
   End
   Begin VB.Label Label5 
      BackColor       =   &H8000000A&
      Caption         =   "OffX"
      Height          =   252
      Left            =   4440
      TabIndex        =   18
      Top             =   840
      Width           =   372
   End
   Begin VB.Label LabelMessage 
      BackColor       =   &H8000000A&
      Caption         =   "Please choose input DXF-File"
      ForeColor       =   &H000000FF&
      Height          =   615
      Left            =   9480
      TabIndex        =   15
      Top             =   120
      Width           =   3735
   End
   Begin VB.Label Label4 
      BackColor       =   &H8000000A&
      Caption         =   "MinY"
      Height          =   252
      Left            =   5880
      TabIndex        =   14
      Top             =   1200
      Width           =   492
   End
   Begin VB.Label Label3 
      BackColor       =   &H8000000A&
      Caption         =   "MinX"
      Height          =   252
      Left            =   5880
      TabIndex        =   13
      Top             =   840
      Width           =   492
   End
   Begin VB.Label Label2 
      BackColor       =   &H8000000A&
      Caption         =   "MaxY"
      Height          =   252
      Left            =   7320
      TabIndex        =   12
      Top             =   1200
      Width           =   492
   End
   Begin VB.Label Label1 
      BackColor       =   &H8000000A&
      Caption         =   "MaxX"
      Height          =   252
      Left            =   7320
      TabIndex        =   11
      Top             =   840
      Width           =   492
   End
   Begin VB.Label LabelGFile 
      BackColor       =   &H8000000A&
      Caption         =   "OUT.GC"
      Height          =   255
      Left            =   2880
      TabIndex        =   3
      Top             =   480
      Width           =   5775
   End
   Begin VB.Label LabelFileName 
      BackColor       =   &H8000000A&
      Caption         =   "DXF ASCII Input file"
      Height          =   255
      Left            =   2880
      TabIndex        =   1
      Top             =   120
      Width           =   6255
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuOpen 
         Caption         =   "&Open"
      End
      Begin VB.Menu mnuOpenGCode 
         Caption         =   "Open &G-Code"
      End
      Begin VB.Menu mnuSaveDXF 
         Caption         =   "Save as &DXF"
      End
      Begin VB.Menu mnuSetup 
         Caption         =   "&Setup"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu MenuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu MenuEditCopy2Clipboard 
         Caption         =   "Copy picture to clipboard as Bitmap"
      End
   End
   Begin VB.Menu MenuCNC 
      Caption         =   "&CNC"
      Begin VB.Menu MenuCNCGCode 
         Caption         =   "&Generate G-code file"
      End
   End
   Begin VB.Menu MenuDraw 
      Caption         =   "&Draw"
      Begin VB.Menu MenuDrawFromArray 
         Caption         =   "Draw from &array"
      End
      Begin VB.Menu Draw_Line_Path 
         Caption         =   "Draw_&Line_Path"
      End
      Begin VB.Menu MenuDrawExportDXF 
         Caption         =   "E&xport as minimal DXF (only ARC, LINE, POLYLINE, CIRCLE; all positives coordinates)"
      End
   End
   Begin VB.Menu MenuProgress 
      Caption         =   "&Work in progress"
      Begin VB.Menu Collect_Path_Nodes_ 
         Caption         =   "Collect_&Path_Nodes"
      End
      Begin VB.Menu ShowCollectedItems 
         Caption         =   "Show collected &items"
      End
      Begin VB.Menu SuggestLongestPath 
         Caption         =   "Suggest &longest path"
      End
      Begin VB.Menu Dump_OrderedPath_Nodes_ 
         Caption         =   "Generate G Code (&one line)"
      End
   End
   Begin VB.Menu ShowHelp 
      Caption         =   "&Help"
   End
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim spiCount As Integer
Dim length As Double
Dim xlength As Double
Dim ylength As Double
Dim zlength As Double
Dim xtotallength As Double
Dim ytotallength As Double
Dim ztotallength As Double
Dim timervalue As Integer

Dim timervaluejoy As Integer
Dim spi As Integer
Dim XSPI As Integer
Dim YSPI As Integer
Dim ZSPI As Integer
Dim direction As String
Dim state As Integer
Dim inipath As String
Dim mySleeper As CSleeper
Dim timercount As Integer
Dim Scaling As Single
Dim OffsetX As Long, OffsetY As Long
Private WithEvents cJoy As cJoy
Attribute cJoy.VB_VarHelpID = -1
Dim JoyEnable As Integer
Private MyPoints As My_Points

Private Sub cJoy_JoyError(sErrMessage As String)
'
 Debug.Print sErrMessage
End Sub
'-- event raised from cJoy which is called every 25 milliseconds
'-- from timer_module and report all the joystick info we need
Private Sub cJoy_JoyInfo(BtnPressed As Long, leftStickX As Long, _
                         leftStickY As Long, rightStickX As Long, _
                         rightStickY As Long, DpadPos As Long)
'
Dim joyzup As Integer

 Label14(0) = BtnPressed
 Label14(1) = leftStickX
 Label14(2) = leftStickY
 Label14(3) = rightStickX
 Label14(4) = rightStickY
 Label14(5) = DpadPos

 
 If (leftStickX < 10000 And leftStickY < 10000) Or DpadPos = 31500 Then
    direction = "LT"
    Move_Steppers
 End If
 
  If (leftStickX < 10000 And leftStickY > 55000) Or DpadPos = 13500 Then
    direction = "LB"
    Move_Steppers
 End If
 
   If (leftStickX > 55000 And leftStickY < 10000) Or DpadPos = 4500 Then
    direction = "RT"
    Move_Steppers
 End If
 
  If (leftStickX > 55000 And leftStickY > 55000) Or DpadPos = 22500 Then
    direction = "RB"
    Move_Steppers
 End If
 
  If leftStickY < 10000 Or DpadPos = 0 Then
    direction = "Up"
    Move_Steppers
 End If
 
  If leftStickY > 55000 Or DpadPos = 18000 Then
    direction = "Down"
    Move_Steppers
 End If
 
   If leftStickX > 55000 Or DpadPos = 9000 Then
    direction = "Right"
    Move_Steppers
 End If
 
  If leftStickX < 10000 Or DpadPos = 27000 Then
    direction = "Left"
    Move_Steppers
 End If
 
 
  If rightStickX < 10000 Then
    direction = "ZUp"
    Move_Steppers
 End If
 
  If rightStickX > 40000 Then
    direction = "ZDown"
    Move_Steppers
 End If
End Sub
Private Sub GCodeFromArray_All()
Dim TotLineNumber As Long
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "Generating G-code - please wait"
  DoEvents
  TotLineNumber = Generate_GCodeFromArray_All(LabelGFile.Caption)
  LabelMessage.Caption = "G-code generated (" & LineNumber & " program lines )"
  ShapeBusy.FillColor = vbGreen
End Sub
Private Sub GCodeFromArray_Temp()
Dim TotLineNumber As Long
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "Generating G-code - please wait"
  DoEvents
  TotLineNumber = Generate_GCodeFromArray_All(LabelGFileTemp.Caption)
  LabelMessage.Caption = "Working G-code generated (" & LineNumber & " program lines )"
  ShapeBusy.FillColor = vbGreen
End Sub

Private Sub CheckDraw_Click(Index As Integer)
 picOptions(2).Tag = True
End Sub

Private Sub CheckGCode_Click(Index As Integer)
  picOptions(2).Tag = True
End Sub



Private Sub ArrowLT_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "LT"

Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowLT_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
'Timer1.Enabled = False
Out 888, 0
direction = ""
End Sub

Private Sub cmdGrid_Click()
Dim count As Long
  For count = 0 To 21600
    Call DrawLine2D(0, count, 21600, count, vbCyan)
    count = count + 1440
  Next
  For count = 0 To 21600
    Call DrawLine2D(count, 0, count, 21600, vbCyan)
    count = count + 1440
  Next
End Sub

Private Sub cmdJoystick_Click()
If JoyEnable = 0 Then
Set cJoy = New cJoy
cJoy.Start_JoyMonitor JOYSTICKID1
cmdJoystick.Caption = "Disable"
JoyEnable = 1
Else
cJoy.End_JoyMonitor
Set cJoy = Nothing
cmdJoystick.Caption = "Enable"
JoyEnable = 0

End If


End Sub

Private Sub cmdRecompile_Click()
Dim dummyI As Long
GCEdit.SaveFile LabelGFileTemp.Caption, rtfText
Call writedxf(Now, App.Path & "\testing.dxf")
    ArrTot_Arcs = 0
    ArrTot_Circles = 0
    ArrTot_Lines = 0
    ArrTot_Points = 0
    ArrTot_Vertexes = 0
    ArrTot_Polylines = 0
    ArrTot_Texts = 0
    ArrTot_3DFaces = 0
    BlockFound = False
    MinX = 0:   MaxX = 0
    MinY = 0:   MaxY = 0
    FirstCoordinate = True 'to init min/max values with first coordinates found in file
    Scaling = 1
    Picture1.Cls
    Layers = ""
    For dummyI = 0 To UBound(LayerArray)
      LayerArray(dummyI).Name = ""
      LayerArray(dummyI).Enabled = True
      LayerArray(dummyI).Goutput = True
    Next
    ArrTot_Layers = 0
    Text1.Text = "Loading file"
    
    cmdOpen.Enabled = False
    ShapeBusy.FillColor = vbYellow
    LabelMessage.Caption = "Analysing DXF file - please wait"
    DoEvents
    Call PopulateArray(App.Path & "\testing.dxf")
    Call ComputeScalingFactor
    Call PlotFromArray_All
    LabelMessage.Caption = "DXF file analysis done"
    Text1.Text = "file loaded" & vbCrLf & "now please select collect" & vbCrLf & _
                 "You may want to disable some layers before collecting nodes"
'    Text1.Text = "G-code will be generated for following entities" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Polylines: " & ArrTot_Polylines & vbCr & vbLf & _
'                 " Vertexes:  " & ArrTot_Vertexes & vbCr & vbLf & _
'                 "Lines:     " & ArrTot_Lines & vbCr & vbLf & _
'                 "Arcs:      " & ArrTot_Arcs & vbCr & vbLf & _
'                 "Circles:   " & ArrTot_Circles & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Layers:    " & ArrTot_Layers & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "No G-code will be generated for following data:" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Texts:     " & ArrTot_Texts & vbCr & vbLf & _
'                 "Points:    " & ArrTot_Points & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf
    If BlockFound = True Then
      Text1.Text = Text1.Text & _
                   "BLOCK's FOUND!" & vbCr & vbLf & _
                   "The result may not be accurate since block's are not supported yet!" & vbCr & vbLf
    End If
    cmdOpen.Enabled = True
    cmdCollect.Enabled = True
    ShapeBusy.FillColor = vbGreen
    Call GCodeFromArray_Temp

    GCEdit.LoadFile LabelGFileTemp.Caption
End Sub

Private Sub Command1_Click()

End Sub

Private Sub Form_Unload(Cancel As Integer)
Dim saved As Integer
saved = mfncWriteIni("SaveValues", "XPOS", XPos.Text, inipath)
saved = mfncWriteIni("SaveValues", "YPOS", YPos.Text, inipath)
saved = mfncWriteIni("SaveValues", "ZPOS", ZPos.Text, inipath)
Set mySleeper = Nothing
On Error Resume Next
cJoy.End_JoyMonitor
Set cJoy = Nothing

End Sub



Private Sub mnuExit_Click()
Dim frm As Form

For Each frm In Forms
  If Not (frm.Name = Me.Name) Then
    Unload frm
  End If
Next frm
Unload Me
End Sub

Private Sub mnuOpenGCode_Click()
On Error GoTo ErrHandler
  Dim gcfile As String
  CommonDialog1.CancelError = True
  'On Error GoTo ErrHandler
  CommonDialog1.Filter = "G-Code Files(*.gc)|*.gc|" & _
  "TXT Files (*.txt)|*.txt|All Files (*.*)|*.*"
  ' Specify default filter
  CommonDialog1.ShowOpen
  GCEdit.LoadFile CommonDialog1.FileName
  
  Exit Sub
ErrHandler:
  'ChooseFile = False
  Exit Sub


End Sub



Private Sub mnuSaveDXF_Click()
'On Error GoTo ErrHandler

'Dim linedata As String
'    Dim A As Variant
'    Dim I As Integer
'Dim X1 As Single
'Dim Y1 As Single

    'Open "temp.dxf" For Output As #1
'    Open App.Path & "\temp.gc" For Input As #2
 '       Do While Not EOF(2)   ' Loop until end of file.
             
Call writedxf(Now, App.Path & "\testing.dxf")
  '  Line Input #2, linedata
'    I = 1
'    X1 = 0 'temp
'    Y1 = 0 'temp
'    A = Empty
'    A = Parse(linedata, " ")
'If A(2) = "G01" Then
'If X1 = 0 Then
'X1 = CSng(Right(A(3), Len(A(3)) - 1))
'If Right(A(4), 1) = ";" Then
'Y1 = CSng(Left(Right(A(4), Len(A(4)) - 1), Len(A(4)) - 2))
'Else
'Y1 = CSng(Right(A(4), Len(A(4)) - 1))
'End If
'End If
'End If

             
       ' Loop
        'Close #2
    'Close #1
      Exit Sub
ErrHandler:
  Exit Sub
End Sub

Private Sub PortMonitor_Click()

Shell App.Path & "\parmon.exe", vbNormalFocus
Main.Show
End Sub

Private Sub Reset_Click()
Out 888, 0
direction = ""
End Sub

Private Sub ArrowLB_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "LB"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowLB_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowRT_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "RT"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowRT_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowRight_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "Right"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowRight_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowRB_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "RB"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowRB_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowLeft_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "Left"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowLeft_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowUp_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "Up"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowUp_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub ArrowDown_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "Down"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowDown_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub


Function Move_Steppers()
Dim countit As Integer
'countit = 24
'Do While countit > 0
       
    Select Case direction

    Case "ZUp":
        'ztotallength = CDbl(ZPos.Text)
        'length = 1 / spi
        If state = 1 Then
            Out 888, 16
            state = 0
         '   Label4.Caption = CStr(Inp(888))
        Else
            Out 888, 48
            state = 1
          '  Label4.Caption = CStr(Inp(888))
        End If
        If timercount <= 10 Then
            mySleeper.SleepTime
        End If
        
        ztotallength = ztotallength + zlength
        ZPos.Text = CStr(Round(ztotallength, 4))
        ZPos.Refresh
        
        'Main.Refresh

    Case "ZDown":
        'ztotallength = CDbl(ZPos.Text)
         'length = 1 / spi
        If state = 1 Then
            Out 888, 32
            state = 0
        Else
            Out 888, 0
            state = 1
        End If
        'mySleeper.SleepTime
        ztotallength = ztotallength - zlength
        ZPos.Text = CStr(Round(ztotallength, 4))
        ZPos.Refresh
        
        'Main.Refresh

    Case "Up":
        'ytotallength = CDbl(YPos.Text)
         'length = 1 / spi
        If state = 1 Then
            Out 888, 8
            state = 0
        Else
            Out 888, 0
            state = 1
        End If
       ' mySleeper.SleepTime
        ytotallength = ytotallength + ylength
        YPos.Text = CStr(Round(ytotallength, 4))
        YPos.Refresh
        
        'Main.Refresh

    Case "Down":
       ' ytotallength = CDbl(YPos.Text)
        ' length = 1 / spi
        If state = 1 Then
            Out 888, 12
            state = 0
        Else
            Out 888, 4
            state = 1
        End If
        mySleeper.SleepTime
        ytotallength = ytotallength - ylength
        YPos.Text = CStr(Round(ytotallength, 4))
        YPos.Refresh
        
        'Main.Refresh
        
    Case "Left":
        'xtotallength = CDbl(XPos.Text)
        'length = 1 / spi
        If state = 1 Then
            Out 888, 3
            state = 0
        Else
            Out 888, 1
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength - xlength
        XPos.Text = CStr(Round(xtotallength, 4))
        XPos.Refresh
        
        'Main.Refresh
        
    Case "Right":
        'xtotallength = CDbl(XPos.Text)
        'length = 1 / spi
        If state = 1 Then
            Out 888, 2
            state = 0
        Else
            Out 888, 0
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength + xlength
        
        XPos.Text = CStr(Round(xtotallength, 4))
        XPos.Refresh
        
        'Main.Refresh
        
    Case "LT":
        'xtotallength = CDbl(XPos.Text)
        'ytotallength = CDbl(YPos.Text)
        
        'length = 1 / spi
        If state = 1 Then
            Out 888, 11
            state = 0
        Else
            Out 888, 1
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength - xlength
        ytotallength = ytotallength + ylength
        XPos.Text = CStr(Round(xtotallength, 4))
        YPos.Text = CStr(Round(ytotallength, 4))
        XPos.Refresh
        YPos.Refresh
        
        'Main.Refresh

    Case "LB":
        'xtotallength = CDbl(XPos.Text)
        'ytotallength = CDbl(YPos.Text)
        
        'length = 1 / spi
        If state = 1 Then
            Out 888, 15
            state = 0
        Else
            Out 888, 5
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength - xlength
        ytotallength = ytotallength - ylength
        XPos.Text = CStr(Round(xtotallength, 4))
        YPos.Text = CStr(Round(ytotallength, 4))
        YPos.Refresh
        XPos.Refresh
        'Main.Refresh

    Case "RT":
        'xtotallength = CDbl(XPos.Text)
        'ytotallength = CDbl(YPos.Text)
        
        'length = 1 / spi
        If state = 1 Then
            Out 888, 10
            state = 0
        Else
            Out 888, 0
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength + xlength
        ytotallength = ytotallength + ylength
        XPos.Text = CStr(Round(xtotallength, 4))
        YPos.Text = CStr(Round(ytotallength, 4))
        XPos.Refresh
        YPos.Refresh
        
       'Main.Refresh
    Case "RB":
        'xtotallength = CDbl(XPos.Text)
        'ytotallength = CDbl(YPos.Text)
        
        'length = 1 / spi
        If state = 1 Then
            Out 888, 14
            state = 0
        Else
            Out 888, 4
            state = 1
        End If
            mySleeper.SleepTime
        xtotallength = xtotallength + xlength
        ytotallength = ytotallength - ylength
        XPos.Text = CStr(Round(xtotallength, 4))
        YPos.Text = CStr(Round(ytotallength, 4))
        XPos.Refresh
        YPos.Refresh
        
       'Main.Refresh
        
        
    Case Else
        Out 888, 0

    End Select
    
'End With
    
'countit = countit - 1
'Loop
Out 888, 0


End Function

Private Sub mnuSetup_Click()
frmSetup.Show
End Sub

Private Sub ZeroX_Click()
XPos.Text = "0"
xtotallength = 0
End Sub

Private Sub ZeroY_Click()
YPos.Text = "0"
ytotallength = 0
End Sub

Private Sub ZeroZ_Click()
ZPos.Text = "0"
ztotallength = 0
End Sub

Private Sub ArrowZUp_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
timercount = 0
repeat:
'Main.Refresh
direction = "ZUp"
Move_Steppers
If GetInputState() = 0 Then
    If timercount <= 10 Then
        timercount = timercount + 1
    End If
    GoTo repeat
End If
End Sub

Private Sub ArrowZUp_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
timercount = 0
End Sub

Private Sub ArrowZDown_MouseDown(button As Integer, Shift As Integer, x As Single, y As Single)
repeat:
direction = "ZDown"
Move_Steppers
If GetInputState() = 0 Then
    GoTo repeat
End If
End Sub

Private Sub ArrowZDown_MouseUp(button As Integer, Shift As Integer, x As Single, y As Single)
Out 888, 0
direction = ""
End Sub

Private Sub cmdCLR_Click()
  Picture1.Cls
End Sub


Private Sub cmdCollect_Click()
  Dim TotN As Long
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "collecting nodes - please wait"
  DoEvents
  Call Collect_Path_Nodes
  LabelMessage.Caption = "searching for paths"
  TotN = Order_Path_Nodes
  LabelMessage.Caption = TotN & " Paths"
  ShapeBusy.FillColor = vbGreen
  cmdGenerate.Enabled = True
  Text1.Text = "nodes have been collected and matched to form connected paths where possible." & vbCrLf & "now please select <<work in progress>> and then <<suggest longest path>>, then push the path button" & vbCrLf
End Sub

Private Sub cmdColor_Click(Index As Integer)
  ColorDialog.Color = cmdColor(Index).BackColor
  ColorDialog.ShowColor
  If Err = cdlCancel Then Exit Sub
  cmdColor(Index).BackColor = ColorDialog.Color
End Sub

Private Sub CmdDraw_Click()
  Picture1.Cls
  Call PlotFromArray_All
End Sub


Private Sub cmdGenerate_Click()
Dim LineNumber As Long
Dim N As Long
  N = Val(pathnumber.Text)
  If N > ArrTot_PathLines Then N = ArrTot_PathLines
  pathnumber.Text = N
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "Generating G-code - please wait"
  DoEvents
  LineNumber = Dump_OrderedPath_Nodes(LabelGFile.Caption, N)
  LabelMessage.Caption = "G-code generated (" & LineNumber & " program lines )"
  ShapeBusy.FillColor = vbGreen
End Sub

Private Sub CmdGOutput_Click()
  CommonDialog1.CancelError = True
  On Error GoTo ErrHandler
  CommonDialog1.Filter = "ISO Files(*.ISO)|*.iso|" & _
  "CNC Files(*.CNC)|*.cnc|GNC Files(*.GC)|*.gnc|TXT Files (*.txt)|*.txt|All Files (*.*)|*.*"
  ' Specify default filter
  CommonDialog1.FileName = LabelGFile.Caption
  CommonDialog1.ShowSave
  LabelGFile.Caption = CommonDialog1.FileName
  Exit Sub
ErrHandler:
  Exit Sub
End Sub

Private Sub cmdPath_Click()
Dim N As Long
  N = Val(pathnumber.Text)
  If ArrTot_PathLines > 0 Then
    If N > ArrTot_PathLines - 1 Then N = ArrTot_PathLines - 1
    pathnumber.Text = N
    Call Draw_Line_Path_Array(N, vbRed)
    Text1.Text = "If the bold path is the one you are interested in, select the generate button to create the cnc-file. " & vbCrLf & _
                 "Elsewhere you can change the active path by hand in the textbox beneatch the <<path>>-button"
  Else
    pathnumber.Text = ""
  End If
End Sub


Private Sub Collect_Path_Nodes__Click()
  Dim TotN As Long
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "collecting nodes - please wait"
  DoEvents
  Call Collect_Path_Nodes
  LabelMessage.Caption = "searching for paths"
  TotN = Order_Path_Nodes
  LabelMessage.Caption = TotN & " Paths"
  ShapeBusy.FillColor = vbGreen
End Sub


Private Sub ComResetScaling_Click()
  Call ComputeScalingFactor
End Sub

Private Sub Draw_Line_Path_Click()
Dim N As Long
  N = Val(pathnumber.Text)
  If N > ArrTot_PathNodes Then N = ArrTot_PathNodes
  pathnumber.Text = N
  Call Draw_Line_Path_Array(N, vbRed)
End Sub

Private Sub Dump_OrderedPath_Nodes__Click()
Dim LineNumber As Long
  ShapeBusy.FillColor = vbYellow
  LabelMessage.Caption = "Generating G-code - please wait"
  DoEvents
  LineNumber = Dump_OrderedPath_Nodes(LabelGFile.Caption, 0)
  LabelMessage.Caption = "G-code generated (" & LineNumber & " program lines )"
  ShapeBusy.FillColor = vbGreen
End Sub

Private Sub MenuCNCGCode_Click()
  Call GCodeFromArray_All
End Sub


Private Sub MenuDrawExportDXF_Click()

' MenuDrawExportDXF creates a minimal DXF file that only contains
' the ENTITIES section.
  Dim count As Long, Vertex As Long, Handle As Long, Scaling As Single

  Handle = 0: Scaling = 1
  Open "minmal_dxf_file.dxf" For Output As #1
    Print #1, 0
    Print #1, "SECTION"
    Print #1, 2
    Print #1, "ENTITIES"
    
   ' For count = 0 To ArrTot_Points - 1
   '   Print #1, 0           'entitie
   '   Print #1, "POINT"
   '   Print #1, 5           'Handle
   '   Print #1, handle
   '   Print #1, 8           'layer
   '   Print #1, PointArray(count).Layer
   '   Print #1, 10          'X
   '   Print #1, PointArray(count).X
   '   Print #1, 20          'Y
   '   Print #1, PointArray(count).Y
   '   handle = handle + 1
   ' Next
    For count = 0 To ArrTot_Lines - 1
      Print #1, 0           'entitie
      Print #1, "LINE"
      Print #1, 5           'Handle
      Print #1, Handle
      Print #1, 8           'layer
      Print #1, LineArray(count).Layer
      Print #1, 10          'X
      Print #1, CStr_((LineArray(count).X0 - MinX) * Scaling)
      Print #1, 20          'Y
      Print #1, CStr_((LineArray(count).Y0 - MinY) * Scaling)
      Print #1, 11          'X
      Print #1, CStr_((LineArray(count).x1 - MinX) * Scaling)
      Print #1, 21          'Y
      Print #1, CStr_((LineArray(count).y1 - MinY) * Scaling)
      Handle = Handle + 1
    Next
    For count = 0 To ArrTot_Arcs - 1
      Print #1, 0           'entitie
      Print #1, "ARC"
      Print #1, 5           'Handle
      Print #1, Handle
      Print #1, 8           'layer
      Print #1, ArcArray(count).Layer
      Print #1, 10          'X
      Print #1, CStr_((ArcArray(count).x - MinX) * Scaling)
      Print #1, 20          'Y
      Print #1, CStr_((ArcArray(count).y - MinY) * Scaling)
      Print #1, 40          'Radius
      Print #1, CStr_((ArcArray(count).R) * Scaling)
      Print #1, 50          'Start angle
      Print #1, CStr_(ArcArray(count).A1 / pi * 180)
      Print #1, 51          'End angle
      Print #1, CStr_(ArcArray(count).A2 / pi * 180)
      Handle = Handle + 1
    Next
    For count = 0 To ArrTot_Circles - 1
      Print #1, 0           'entitie
      Print #1, "CIRCLE"
      Print #1, 5           'Handle
      Print #1, Handle
      Print #1, 8           'layer
      Print #1, CircleArray(count).Layer
      Print #1, 10          'X
      Print #1, CStr_((CircleArray(count).x - MinX) * Scaling)
      Print #1, 20          'Y
      Print #1, CStr_((CircleArray(count).y - MinY) * Scaling)
      Print #1, 40          'Radius
      Print #1, CStr_((CircleArray(count).R) * Scaling)
      Handle = Handle + 1
    Next
    'For count = 0 To ArrTot_Texts - 1
    '  Call DrawPoint2D(TextArray(count).X, TextArray(count).Y, colors(TextArray(count).Layer))
    '  Picture1.Print TextArray(count).T
    'Next
    For count = 0 To ArrTot_Polylines - 1
      Print #1, 0           'entitie
      Print #1, "POLYLINE"
      Print #1, 5           'Handle
      Print #1, Handle
      Print #1, 8           'layer
      Print #1, PolylineArray(count).Layer
      Print #1, 10          'X dummy point
      Print #1, 0
      Print #1, 20          'Y dummy point
      Print #1, 0
      If PolylineArray(count).closed Then
        Print #1, 70         'Flags
        Print #1, 1
      End If
      Handle = Handle + 1
      For Vertex = PolylineArray(count).Vertex1 To PolylineArray(count).Vertex2
        Print #1, 0           'entitie
        Print #1, "VERTEX"
        Print #1, 5           'Handle
        Print #1, Handle
        Print #1, 8           'layer
        Print #1, VertexArray(count).Layer
        Print #1, 10          'X
        Print #1, CStr_((VertexArray(Vertex).x - MinX) * Scaling)
        Print #1, 20          'Y
        Print #1, CStr_((VertexArray(Vertex).y - MinY) * Scaling)
        Print #1, 42          'Bulge
        Print #1, CStr_(VertexArray(Vertex).B)
        Handle = Handle + 1
      Next
      Print #1, 0           'entitie
      Print #1, "SEQEND"
    Next
    Print #1, 0
    Print #1, "ENDSEC"
    Print #1, 0
    Print #1, "EOF"
  Close #1
End Sub

Private Sub MenuDrawFromArray_Click()
  Picture1.Cls
  Call PlotFromArray_All
End Sub

Private Sub PlotFromArray_All()
Dim count As Long, Vertex As Long
Dim i As Long, J As Long, R As Long, A1 As Single, A2 As Single

  For count = 0 To ArrTot_Points - 1
    If LayerArray(PointArray(count).Layer).Enabled Then
      Call DrawPoint2D(PointArray(count).x, PointArray(count).y, _
                       LayerArray(PointArray(count).Layer).Color)
    End If
  Next
  For count = 0 To ArrTot_Lines - 1
    If LayerArray(LineArray(count).Layer).Enabled Then
      Call DrawLine2D(LineArray(count).X0, LineArray(count).Y0, _
                      LineArray(count).x1, LineArray(count).y1, _
                      LayerArray(LineArray(count).Layer).Color)
    End If
  Next
  For count = 0 To ArrTot_Arcs - 1
    If LayerArray(ArcArray(count).Layer).Enabled Then
      Call DrawArc2D(ArcArray(count).x, ArcArray(count).y, _
                     ArcArray(count).R, ArcArray(count).A1, ArcArray(count).A2, _
                     LayerArray(ArcArray(count).Layer).Color)
    End If
  Next
  For count = 0 To ArrTot_Circles - 1
    If LayerArray(CircleArray(count).Layer).Enabled Then
      Call DrawCircle2D(CircleArray(count).x, CircleArray(count).y, _
                        CircleArray(count).R, _
                        LayerArray(CircleArray(count).Layer).Color)
    End If
  Next
  For count = 0 To ArrTot_Texts - 1
    If LayerArray(TextArray(count).Layer).Enabled Then
      Call DrawPoint2D(TextArray(count).x, TextArray(count).y, _
                       LayerArray(TextArray(count).Layer).Color)
      Picture1.Print TextArray(count).t
    End If
  Next
  For count = 0 To ArrTot_Polylines - 1
    If LayerArray(PolylineArray(count).Layer).Enabled Then
      Call DrawPolyLine2D(PolylineArray(count).Vertex1, PolylineArray(count).Vertex2, count)
    End If
  Next
  For count = 0 To ArrTot_3DFaces - 1
    If LayerArray(Face3DArray(count).Layer).Enabled Then
      'We have to draw the face!
      Call DrawLine2D(Face3DArray(count).x(0), Face3DArray(count).y(0), _
                      Face3DArray(count).x(1), Face3DArray(count).y(1), _
                      LayerArray(Face3DArray(count).Layer).Color)
      Call DrawLine2D(Face3DArray(count).x(1), Face3DArray(count).y(1), _
                      Face3DArray(count).x(2), Face3DArray(count).y(2), _
                      LayerArray(Face3DArray(count).Layer).Color)
      If Face3DArray(count).Vertexes = 3 Then
        Call DrawLine2D(Face3DArray(count).x(2), Face3DArray(count).y(2), _
                        Face3DArray(count).x(3), Face3DArray(count).y(3), _
                        LayerArray(Face3DArray(count).Layer).Color)
        Call DrawLine2D(Face3DArray(count).x(3), Face3DArray(count).y(3), _
                        Face3DArray(count).x(0), Face3DArray(count).y(0), _
                        LayerArray(Face3DArray(count).Layer).Color)
      Else
        Call DrawLine2D(Face3DArray(count).x(2), Face3DArray(count).y(2), _
                        Face3DArray(count).x(0), Face3DArray(count).y(0), _
                        LayerArray(Face3DArray(count).Layer).Color)
      End If
    End If
  Next
End Sub
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim i As Integer
    'handle ctrl+tab to move to the next tab
    If Shift = vbCtrlMask And KeyCode = vbKeyTab Then
        i = tbsOptions.SelectedItem.Index
        If i = tbsOptions.Tabs.count Then
            'last tab so we need to wrap to tab 1
            Set tbsOptions.SelectedItem = tbsOptions.Tabs(1)
        Else
            'increment the tab
            Set tbsOptions.SelectedItem = tbsOptions.Tabs(i + 1)
        End If
    End If
End Sub

Private Sub Form_Load()
Dim i As Long
inipath = App.Path + "\WinCNC.ini"
spi = 16000
XSPI = CInt(mfncGetFromIni("Setup", "XSPI", inipath))
YSPI = CInt(mfncGetFromIni("Setup", "YSPI", inipath))
ZSPI = CInt(mfncGetFromIni("Setup", "ZSPI", inipath))
timervalue = CInt(mfncGetFromIni("Setup", "Timer", inipath))
timervaluejoy = 25
xtotallength = CDbl(Round(mfncGetFromIni("SaveValues", "XPOS", inipath), 4))
ytotallength = CDbl(Round(mfncGetFromIni("SaveValues", "YPOS", inipath), 4))
ztotallength = CDbl(Round(mfncGetFromIni("SaveValues", "ZPOS", inipath), 4))
XPos.Text = CStr(xtotallength)
YPos.Text = CStr(ytotallength)
ZPos.Text = CStr(ztotallength)
length = 0
xlength = 1 / XSPI
ylength = 1 / YSPI
zlength = 1 / ZSPI
state = 1

Set mySleeper = New CSleeper

    
    With mySleeper
    .DelayNanoSeconds = timervalue
    .Init
    End With

  ReDim LineArray(0 To 10)
  ReDim ArcArray(0 To 10)
  ReDim CircleArray(0 To 10)
  ReDim PointArray(0 To 10)
  ReDim PolylineArray(0 To 10)
  ReDim VertexArray(0 To 10)
  ReDim TextArray(0 To 10)
  ReDim Face3DArray(0 To 10)
  ReDim PathNodeArray(0 To 10)
  ReDim PathLineArray(0 To 10)
  
  'MenuDraw.Enabled = False
  MinX = 0
  MaxX = 0
  MinY = 0
  MaxY = 0
  Scaling = 1
  
  ReDim LayerArray(0 To 15)  'support 16 layers
  LayerArray(0).Color = vbBlack
  LayerArray(1).Color = vbRed
  LayerArray(2).Color = vbBlue
  LayerArray(3).Color = vbGreen
  LayerArray(4).Color = vbYellow
  LayerArray(5).Color = vbMagenta
  LayerArray(6).Color = vbCyan
  LayerArray(7).Color = vbWhite
  LayerArray(8).Color = vbGreen
  LayerArray(9).Color = vbYellow
  LayerArray(10).Color = vbBlack
  LayerArray(11).Color = vbRed
  LayerArray(12).Color = vbBlue
  LayerArray(13).Color = vbGreen
  LayerArray(14).Color = vbYellow
  LayerArray(15).Color = vbBlack
  
  Text1.Text = "no file selected" & vbCrLf & "please select open"
  
  picOptions(0).Tag = False 'used as changed flag
  picOptions(0).Left = 120
  picOptions(0).Enabled = True

  picOptions(1).Tag = False 'used as changed flag
  picOptions(1).Left = -20000
  picOptions(1).Enabled = False
  
  picOptions(2).Tag = False 'used as changed flag
  picOptions(2).Left = -20000
  picOptions(2).Enabled = False
  
  GCEdit.Text = ""

  
  IsoFormat = "0000.0000"
  LineNumberFormat = "0000"
  AdditionalScaling = 1

LabelGFileTemp.Caption = App.Path + "\temp.gc"
Me.Move (Screen.Width - Me.Width) / 2, (Screen.Height - Me.Height) / 2
JoyEnable = 1
  Set cJoy = New cJoy
 
     '-- on MY computer joystick #2 is the valid 1
     '-- on your system it might be different so make
     '-- sure you enter the right number
     cJoy.Start_JoyMonitor JOYSTICKID1
'Stores the center points of the screen to memory
    MyPoints.x = Me.ScaleWidth * 0.5
    MyPoints.y = Me.ScaleHeight * 0.5
End Sub
Private Sub cmdOPen_Click()
Dim dummyI As Long

  If ChooseFile Then
    ArrTot_Arcs = 0
    ArrTot_Circles = 0
    ArrTot_Lines = 0
    ArrTot_Points = 0
    ArrTot_Vertexes = 0
    ArrTot_Polylines = 0
    ArrTot_Texts = 0
    ArrTot_3DFaces = 0
    BlockFound = False
    MinX = 0:   MaxX = 0
    MinY = 0:   MaxY = 0
    FirstCoordinate = True 'to init min/max values with first coordinates found in file
    Scaling = 1
    Picture1.Cls
    Layers = ""
    For dummyI = 0 To UBound(LayerArray)
      LayerArray(dummyI).Name = ""
      LayerArray(dummyI).Enabled = True
      LayerArray(dummyI).Goutput = True
    Next
    ArrTot_Layers = 0
    Text1.Text = "Loading file"
    
    cmdOpen.Enabled = False
    ShapeBusy.FillColor = vbYellow
    LabelMessage.Caption = "Analysing DXF file - please wait"
    DoEvents
    Call PopulateArray(LabelFileName.Caption)
    Call ComputeScalingFactor
    Call PlotFromArray_All
    LabelMessage.Caption = "DXF file analysis done"
    Text1.Text = "file loaded" & vbCrLf & "now please select collect" & vbCrLf & _
                 "You may want to disable some layers before collecting nodes"
'    Text1.Text = "G-code will be generated for following entities" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Polylines: " & ArrTot_Polylines & vbCr & vbLf & _
'                 " Vertexes:  " & ArrTot_Vertexes & vbCr & vbLf & _
'                 "Lines:     " & ArrTot_Lines & vbCr & vbLf & _
'                 "Arcs:      " & ArrTot_Arcs & vbCr & vbLf & _
'                 "Circles:   " & ArrTot_Circles & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Layers:    " & ArrTot_Layers & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "No G-code will be generated for following data:" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Texts:     " & ArrTot_Texts & vbCr & vbLf & _
'                 "Points:    " & ArrTot_Points & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf
    If BlockFound = True Then
      Text1.Text = Text1.Text & _
                   "BLOCK's FOUND!" & vbCr & vbLf & _
                   "The result may not be accurate since block's are not supported yet!" & vbCr & vbLf
    End If
    cmdOpen.Enabled = True
    cmdCollect.Enabled = True
    ShapeBusy.FillColor = vbGreen
    Call GCodeFromArray_Temp

    GCEdit.LoadFile LabelGFileTemp.Caption
    'Main.Refresh
    
  Else
    cmdOpen.Enabled = True
    ShapeBusy.FillColor = vbRed
    LabelMessage.Caption = "file error"
  End If
End Sub

Private Function ChooseFile() As Boolean
  CommonDialog1.CancelError = True
  On Error GoTo ErrHandler
  CommonDialog1.Filter = "DXF Files(*.dxf)|*.dxf|" & _
  "TXT Files (*.txt)|*.txt|All Files (*.*)|*.*"
  ' Specify default filter
  CommonDialog1.ShowOpen
  LabelFileName.Caption = CommonDialog1.FileName
  ChooseFile = True
  Exit Function
ErrHandler:
  ChooseFile = False
  Exit Function
End Function

Public Sub DrawLine2D(ByVal X0 As Long, ByVal Y0 As Long, _
                       ByVal x1 As Long, ByVal y1 As Long, _
                       ByVal Color As Long)
                       Dim A1 As Long
                       Dim A2 As Long
                       Dim b1 As Long
                       Dim b2 As Long
                       A1 = (X0 - MinX) * Scaling + OffsetX
                       A2 = Picture1.ScaleHeight - (Y0 - MinY) * Scaling - OffsetY
                     b1 = (x1 - MinX) * Scaling + OffsetX
                       b2 = Picture1.ScaleHeight - (y1 - MinY) * Scaling - OffsetY
                       Picture1.Line (A1, A2)-(b1, b2), Color
'  Picture1.Line ((X0 - MinX) * Scaling + OffsetX, Picture1.ScaleHeight - (Y0 - MinY) * Scaling - OffsetY) _
               -((X1 - MinX) * Scaling + OffsetX, Picture1.ScaleHeight - (Y1 - MinY) * Scaling - OffsetY), Color
End Sub

Private Sub DrawPoint2D(ByVal x As Long, ByVal y As Long, ByVal Color As Long)
  Picture1.PSet ((x - MinX) * Scaling + OffsetX, Picture1.ScaleHeight - (y - MinY) * Scaling - OffsetY), Color
End Sub

Public Sub DrawPolyLine2D(FromVertex As Long, ToVertex As Long, PolyLine As Long)
  Dim Vertex As Long
  Dim i As Long, J As Long, R As Long, A1 As Single, A2 As Single

    For Vertex = FromVertex To ToVertex - 1
      If VertexArray(Vertex).B = 0 Then
        Call DrawLine2D(VertexArray(Vertex).x, VertexArray(Vertex).y, _
                        VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, _
                        LayerArray(VertexArray(Vertex).Layer).Color)
      Else
        Call Bulge2IJ(VertexArray(Vertex).x, VertexArray(Vertex).y, _
                      VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, _
                      VertexArray(Vertex).B, i, J, R, A1, A2)
        Call DrawArc2D(VertexArray(Vertex).x + i, VertexArray(Vertex).y + J, _
                       R, A1, A2, _
                       LayerArray(VertexArray(Vertex).Layer).Color)
      End If
    Next
    If PolylineArray(PolyLine).closed Then
      If VertexArray(PolylineArray(PolyLine).Vertex2).B = 0 Then
        Call DrawLine2D(VertexArray(PolylineArray(PolyLine).Vertex1).x, VertexArray(PolylineArray(PolyLine).Vertex1).y, _
                        VertexArray(PolylineArray(PolyLine).Vertex2).x, VertexArray(PolylineArray(PolyLine).Vertex2).y, _
                        LayerArray(VertexArray(PolylineArray(PolyLine).Vertex2 - 1).Layer).Color)
      Else
        Call Bulge2IJ(VertexArray(PolylineArray(PolyLine).Vertex2).x, VertexArray(PolylineArray(PolyLine).Vertex2).y, _
                      VertexArray(PolylineArray(PolyLine).Vertex1).x, VertexArray(PolylineArray(PolyLine).Vertex1).y, _
                      VertexArray(PolylineArray(PolyLine).Vertex2).B, i, J, R, A1, A2)
        Call DrawArc2D(VertexArray(PolylineArray(PolyLine).Vertex2).x + i, VertexArray(PolylineArray(PolyLine).Vertex2).y + J, _
                       R, A1, A2, _
                       LayerArray(VertexArray(PolylineArray(PolyLine).Vertex2 - 1).Layer).Color)
      End If
    End If

End Sub

Public Sub DrawArc2D(ByVal x As Long, ByVal y As Long, _
                      ByVal R As Long, _
                      ByVal A1 As Single, ByVal A2 As Single, _
                      ByVal Color As Long)
  Picture1.Circle (((x - MinX) * Scaling + OffsetX), _
                   ((Picture1.ScaleHeight - (y - MinY) * Scaling) - OffsetY)), _
                   (R * Scaling), Color, A1, A2
End Sub

Public Sub DrawCircle2D(ByVal x As Long, ByVal y As Long, _
                         ByVal R As Long, ByVal Color As Long)
  Picture1.Circle ((x - MinX) * Scaling + OffsetX, _
                   (Picture1.ScaleHeight - (y - MinY) * Scaling) - OffsetY), _
                   R * Scaling, Color
End Sub



Private Sub ComputeScalingFactor()
Dim ScalingX As Single, ScalingY As Single
Dim PictureMin  As Long
   If Picture1.ScaleWidth > Picture1.ScaleHeight Then PictureMin = Picture1.ScaleHeight Else PictureMin = Picture1.ScaleWidth
   If MaxX <> MinX Then ScalingX = (Picture1.ScaleWidth - 4) / (MaxX - MinX) Else ScalingX = 0
   If MaxY <> MinY Then ScalingY = (Picture1.ScaleHeight - 4) / (MaxY - MinY) Else ScalingY = 0
   If ScalingX > ScalingY Then Scaling = ScalingY Else Scaling = ScalingX
   If Scaling > 10 Then Scaling = CInt(Scaling)
   OffsetX = ((Picture1.ScaleWidth - 2) - (MaxX - MinX) * Scaling) / 2
   OffsetY = ((Picture1.ScaleHeight - 2) - (MaxY - MinY) * Scaling) / 2
   TextScaling.Text = Scaling
   TextMinX.Text = MinX
   TextMinY.Text = MinY
   TextMaxX.Text = MaxX
   TextMaxY.Text = MaxY
   TextOffX.Text = OffsetX
   TextOffY.Text = OffsetY
End Sub

Private Sub Form_Resize()
'  If Main.ScaleWidth > Picture1.Left Then Picture1.Width = Main.ScaleWidth - Picture1.Left
 ' If Main.ScaleHeight > Picture1.Top Then Picture1.Height = Main.ScaleHeight - (Picture1.Top + 3000)
 ' If Main.ScaleHeight > Text1.Top Then Text1.Height = Main.ScaleHeight - Text1.Top
 
  Call ComputeScalingFactor
  TextScaling.Text = Scaling
  
  
End Sub


Private Sub MenuEditCopy2Clipboard_Click()
  Clipboard.Clear
  Clipboard.SetData Picture1.Image
End Sub




Private Sub mnuOpen_Click()
Dim dummyI As Long

  If ChooseFile Then
    ArrTot_Arcs = 0
    ArrTot_Circles = 0
    ArrTot_Lines = 0
    ArrTot_Points = 0
    ArrTot_Vertexes = 0
    ArrTot_Polylines = 0
    ArrTot_Texts = 0
    ArrTot_3DFaces = 0
    BlockFound = False
    MinX = 0:   MaxX = 0
    MinY = 0:   MaxY = 0
    FirstCoordinate = True 'to init min/max values with first coordinates found in file
    Scaling = 1
    Picture1.Cls
    Layers = ""
    For dummyI = 0 To UBound(LayerArray)
      LayerArray(dummyI).Name = ""
      LayerArray(dummyI).Enabled = True
      LayerArray(dummyI).Goutput = True
    Next
    ArrTot_Layers = 0
    Text1.Text = "Loading file"
    
    cmdOpen.Enabled = False
    ShapeBusy.FillColor = vbYellow
    LabelMessage.Caption = "Analysing DXF file - please wait"
    DoEvents
    Call PopulateArray(LabelFileName.Caption)
    Call ComputeScalingFactor
    Call PlotFromArray_All
    LabelMessage.Caption = "DXF file analysis done"
    Text1.Text = "file loaded" & vbCrLf & "now please select collect" & vbCrLf & _
                 "You may want to disable some layers before collecting nodes"
'    Text1.Text = "G-code will be generated for following entities" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Polylines: " & ArrTot_Polylines & vbCr & vbLf & _
'                 " Vertexes:  " & ArrTot_Vertexes & vbCr & vbLf & _
'                 "Lines:     " & ArrTot_Lines & vbCr & vbLf & _
'                 "Arcs:      " & ArrTot_Arcs & vbCr & vbLf & _
'                 "Circles:   " & ArrTot_Circles & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Layers:    " & ArrTot_Layers & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "No G-code will be generated for following data:" & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf & _
'                 "Texts:     " & ArrTot_Texts & vbCr & vbLf & _
'                 "Points:    " & ArrTot_Points & vbCr & vbLf & _
'                 "-----------------------------" & vbCr & vbLf
    If BlockFound = True Then
      Text1.Text = Text1.Text & _
                   "BLOCK's FOUND!" & vbCr & vbLf & _
                   "The result may not be accurate since block's are not supported yet!" & vbCr & vbLf
    End If
    cmdOpen.Enabled = True
    cmdCollect.Enabled = True
    ShapeBusy.FillColor = vbGreen
    Call GCodeFromArray_Temp
    GCEdit.LoadFile LabelGFileTemp.Caption
    'Main.Refresh
  Else
    cmdOpen.Enabled = True
    ShapeBusy.FillColor = vbRed
    LabelMessage.Caption = "file error"
  End If
  
End Sub

Private Sub ShowCollectedItems_Click()
  Call DrawPathNodes
End Sub

Private Sub ShowHelp_Click()
  MsgBox "This DXF-parser is a program written in my spare-time, don't expect too much" & vbCrLf & _
         "You can use it if you want but at your own risk" & vbCrLf & _
         "It is still a mess and instable, but sometimes the results are usable" & vbCrLf & _
         "Avoid big files - it is written in visual basic and is not really performant"
End Sub

Private Sub SuggestLongestPath_Click()
  Dim N As Long, M As Long, i As Long, D As Long
  Dim NA() As Long
  N = 0: M = 0
    
  ReDim NA(0 To ArrTot_PathLines)

   For i = 0 To ArrTot_PathLines - 1
     If PathNodeArray(PathLineArray(i).FirstN).t = TPOLYLINE Then
       D = PathNodeArray(PathLineArray(i).FirstN).N
       D = PolylineArray(D).Vertex2 - PolylineArray(D).Vertex1
       NA(i) = D
       If D > N Then
         N = D
         M = i
       End If
     ElseIf PathLineArray(i).TotN > N Then
       N = PathLineArray(i).TotN
       M = i
       NA(i) = N
     Else
       NA(i) = PathLineArray(i).TotN
     End If
   Next
  pathnumber.Text = M
  If ArrTot_PathLines > 0 Then
    Text1.Text = "PathLine:" & vbTab & "Length:" & vbCrLf
    For i = 0 To ArrTot_PathLines - 1
      Text1.Text = Text1.Text & i & vbTab & NA(i) & vbCrLf
    Next
  End If
End Sub

Private Sub tbsOptions_Click()
Dim i As Integer, J As Integer
    'changed something?
    
    


    TextIsoFormat = IsoFormat
    TextLineNumberFormat = LineNumberFormat
    TextAdditionalScaling = AdditionalScaling
    
    'show and enable the selected tab's controls
    'and hide and disable all others
    For i = 0 To tbsOptions.Tabs.count - 1
        If i = tbsOptions.SelectedItem.Index - 1 Then
            picOptions(i).Left = 120
            picOptions(i).Enabled = True
        Else
            picOptions(i).Left = -20000
            picOptions(i).Enabled = False
        End If
    Next
End Sub

Private Sub TextAdditionalScaling_Change()
  AdditionalScaling = Val(TextAdditionalScaling)
  If AdditionalScaling < 0.001 Then AdditionalScaling = 1
  If AdditionalScaling > 1000 Then AdditionalScaling = 1
  TextAdditionalScaling = AdditionalScaling
End Sub

Private Sub TextIsoFormat_Change()
  IsoFormat = TextIsoFormat
End Sub

Private Sub TextLineNumberFormat_Change()
  LineNumberFormat = TextLineNumberFormat
End Sub

Private Sub TextOffX_Change()
  OffsetX = Val(TextOffX.Text)
  TextOffX.Text = OffsetX
End Sub

Private Sub TextOffY_Change()
  OffsetY = Val(TextOffY.Text)
  TextOffY.Text = OffsetY
End Sub

Private Sub TextScaling_Change()
   Scaling = Val(Replace(TextScaling.Text, ",", "."))
   TextScaling.Text = Scaling
End Sub

