Attribute VB_Name = "DXF_Save"
'================================================================
'Save countless hours of CAD design time by automating the design
'process.  Output DXF files on the fly by using this source code.
'Create a simple GUI to gather data to generate the geometry,
'then export it instantly to a ".dxf" file which is a format
'supported by most CAD software and even some design software.

'This DXF generating source code was created by David S. Tufts,
'you can contact me at kdtufts@juno.com.  The variables set
'up in the DXF header are my personal preferences. The
'variables can be changed by observing the settings of any
'DXF file which was saved with your desired preferences.  Also,
'any additional geometry can be added to this code in the form of
'a function by observing the DXF output of any CAD software that
'supports DXF files.  Good luck and have fun...
'================================================================

Option Explicit
Public Type My_Points
    x As Single
    y As Single
End Type
Private MyPoints As My_Points
Dim DXF_BodyText As String, DXF_BlockBody As String, BlockIndex As Integer
Dim iLayer As String
Public Function Radians(ByVal Degree As Single) As Single
'Converts degrees to radians
    Radians = Degree * 0.0174532925
End Function
Public Sub writedxf(ByVal StartTime As Variant, ByVal SavePath As String)

    Dim linedata As String
    Dim A As Variant
    Dim i As Integer
    Dim x1 As Single
    Dim y1 As Single
    Dim x2 As Single
    Dim y2 As Single
    Dim z1 As Single
    Dim z2 As Single
    
    Dim firstline As Integer
    Dim layername As String
        
    Dim iDate As String, iHr As Integer, iMin As Integer, iSec As Integer
    MyPoints.x = 50: MyPoints.y = 50
    BlockIndex = 0
    DXF_BodyText = ""
    DXF_BlockBody = ""
    iLayer = "First_Layer"
    
    firstline = 1
    x1 = Empty 'temp
    y1 = 0 'temp
    x2 = 0 'temp
    y2 = 0 'temp
    z1 = 0
    z2 = 0
    'Open "temp.dxf" For Output As #1
    Open App.Path & "\temp.gc" For Input As #2
    Do While Not EOF(2)   ' Loop until end of file.
             

    Line Input #2, linedata
    i = 1

    A = Empty
    A = Parse(linedata, " ")
    
    If A(2) = "G00" And Left(A(3), 1) = "Z" Then
            If Right(A(3), 1) = ";" Then
                z1 = CSng(Left(Right(A(3), Len(A(3)) - 1), Len(A(3)) - 2))
                z2 = CSng(Left(Right(A(3), Len(A(3)) - 1), Len(A(3)) - 2))
            Else
                z1 = CSng(Right(A(3), Len(A(3)) - 1))
                z2 = CSng(Right(A(3), Len(A(3)) - 1))
            End If
    End If

    If A(2) = "G00" And Left(A(3), 1) = "X" Then
            x2 = CSng(Right(A(3), Len(A(3)) - 1))
            If Right(A(4), 1) = ";" Then
                y2 = CSng(Left(Right(A(4), Len(A(4)) - 1), Len(A(4)) - 2))
            Else
                y2 = CSng(Right(A(4), Len(A(4)) - 1))
            End If
            
           ' If Right(A(5), 1) = ";" Then
           '     z2 = CSng(Left(Right(A(5), Len(A(5)) - 1), Len(A(5)) - 2))
           ' Else
           '     z2 = CSng(Right(A(5), Len(A(5)) - 1))
           ' End If
    
            If firstline = 1 Then
                firstline = 0
                x1 = x2
                y1 = y2
                z1 = z2
        
            Else
               ' Call DXF_Line(iLayer, x1, y1, z1, x2, y2, z2)
                x1 = x2
                y1 = y2
                z1 = z2
            End If
    End If
    
    If A(2) = "G01" Then
 
            x2 = CSng(Right(A(3), Len(A(3)) - 1))
            If Right(A(4), 1) = ";" Then
                y2 = CSng(Left(Right(A(4), Len(A(4)) - 1), Len(A(4)) - 2))
            Else
                y2 = CSng(Right(A(4), Len(A(4)) - 1))
            End If
            
           ' If Right(A(5), 1) = ";" Then
           '     z2 = CSng(Left(Right(A(5), Len(A(5)) - 1), Len(A(5)) - 2))
           ' Else
           '     z2 = CSng(Right(A(5), Len(A(5)) - 1))
           ' End If
    
            If firstline = 1 Then
                firstline = 0
                x1 = x2
                y1 = y2
                z1 = z2
        
            Else
                Call DXF_Line(iLayer, x1, y1, z1, x2, y2, z2)
                x1 = x2
                y1 = y2
                z1 = z2
            End If
        End If
    Loop
    Close #2
    'Close #1
    'Save the DXF file
    DXF_save_to_file SavePath
End Sub
Public Sub MainOutput(ByVal StartTime As Variant, ByVal SavePath As String)
Dim iDate As String, iHr As Integer, iMin As Integer, iSec As Integer
MyPoints.x = 50: MyPoints.y = 50
BlockIndex = 0
DXF_BodyText = ""
DXF_BlockBody = ""
iLayer = "CLOCK_FACE"
'Draw a border
    DXF_Border iLayer, 1, 1, 0, 99, 99, 0
'Draw a circle
    DXF_Circle iLayer, MyPoints.x, MyPoints.y, 0, 48
'Draw four arcs on clock face
    DXF_Arc iLayer, MyPoints.x, MyPoints.y, 0, 46, 2, 88
    DXF_Arc iLayer, MyPoints.x, MyPoints.y, 0, 46, 92, 178
    DXF_Arc iLayer, MyPoints.x, MyPoints.y, 0, 46, 182, 268
    DXF_Arc iLayer, MyPoints.x, MyPoints.y, 0, 46, 272, 358
'Draw a rectangle on the clock face
    DXF_Rectangle iLayer, 50, 70, 0, 55, 80, 0
'Dimension the rectangle
    'I know for sure that this works in AutoCAD,
    'but I don't know about other CAD software
    DXF_Dimension iLayer, 55, 70, 55, 80, 60, 80, 60, 75, 90
    DXF_Dimension iLayer, 50, 70, 55, 70, 55, 65, 52.5, 65
    DXF_Dimension iLayer, 50, 70, 50, 80, 45, 80, 45, 75, 90, "Height"
    DXF_Dimension iLayer, 50, 80, 55, 80, 55, 85, 52.5, 85, , "Width"
'Show text
    DXF_ShowText 50.5, 80, 315, 12, "This is a rectangle."
'Print the date
    iDate = Format(StartTime, "dddd, mmmm d yyyy")
    DXF_Text iLayer, MyPoints.x - Len(iDate), MyPoints.y - 20, 0, 2, iDate
'Get the hours, minutes, seconds
    iHr = IIf(Hour(StartTime) < 12, Hour(StartTime) - 12, Hour(StartTime))
    iMin = Minute(StartTime)
    iSec = Second(StartTime)
'Draw the hour hand
    DXF_DrawHand (Radians(30 * iHr)) + ((Radians(6 * iMin)) / 12), 20
'Draw the minute hand
    DXF_DrawHand (Radians(6 * iMin)) + ((Radians(6 * iSec)) / 60), 30
'Draw the seconds hand
    DXF_DrawHand Radians(6 * iSec), 45
'Save the DXF file
    DXF_save_to_file SavePath
End Sub
Private Sub DXF_DrawHand(ByVal iRadians As Single, ByVal i As Integer)
Dim x(1) As Single, y(1) As Single
'Finds the outer x & y locations of the clock hands
    x(0) = MyPoints.x + (i * (sIn(iRadians)))
    y(0) = MyPoints.y + (i * (Cos(iRadians)))
'Finds the inner x & y locations of the clock hands
    x(1) = MyPoints.x - ((i * 0.25) * (sIn(iRadians)))
    y(1) = MyPoints.y - ((i * 0.25) * (Cos(iRadians)))
'Draw the line with an arrow head
    DXF_Line iLayer, x(0), y(0), 0, x(1), y(1), 0
    DXF_ArrowHead iRadians, x(0), y(0)
End Sub
'Build the header, this header is set with my personal preferences
Private Function DXF_Header() As String
Dim HS(19) As String
    HS(0) = "  0|SECTION|  2|HEADER|  9"
        HS(1) = "$ACADVER|  1|AC1009|  9"
        HS(2) = "$INSBASE| 10|0.0| 20|0.0| 30|0.0|  9"
        HS(3) = "$EXTMIN| 10|  0| 20|  0| 30|  0|  9"
        HS(4) = "$EXTMAX| 10|368| 20|326| 30|0.0|  9"
        HS(5) = "$LIMMIN| 10|0.0| 20|0.0|  9"
        HS(6) = "$LIMMAX| 10|100.0| 20|100.0|  9"
        HS(7) = "$ORTHOMODE| 70|     1|  9"
        HS(8) = "$DIMSCALE| 40|8.0|  9"
        HS(9) = "$DIMSTYLE|  2|STANDARD|  9"
        HS(10) = "$FILLETRAD| 40|0.0|  9"
        HS(11) = "$PSLTSCALE| 70|     1|  0"
    HS(12) = "ENDSEC|  0"
    HS(13) = "SECTION|  2|TABLES|  0"
        HS(14) = "TABLE|  2|VPORT| 70|     2|  0|VPORT|  2|*ACTIVE| 70|     0| 10|0.0| 20|0.0| 11|1.0| 21|1.0| 12|50.0| 22|50.0| 13|0.0| 23|0.0| 14|1.0| 24|1.0| 15|0.0| 25|0.0| 16|0.0| 26|0.0| 36|1.0| 17|0.0| 27|0.0| 37|0.0| 40|100.0| 41|1.55| 42|50.0| 43|0.0| 44|0.0| 50|0.0| 51|0.0| 71|     0| 72|   100| 73|     1| 74|     1| 75|     0| 76|     0| 77|     0| 78|     0|  0|ENDTAB|  0"
        HS(15) = "TABLE|  2|LTYPE| 70|     1|  0|LTYPE|  2|CONTINUOUS|  70|     0|  3|Solid Line| 72|    65| 73|     0| 40|0.0|  0|ENDTAB|  0"
        HS(16) = "TABLE|  2|LAYER| 70|     3|  0|LAYER|  2|0| 70|     0| 62|     7|  6|CONTINUOUS|  0|LAYER|  2|CLOCK_FACE| 70|     0| 62|     7|  6|CONTINUOUS|  0|LAYER|  2|DEFPOINTS| 70|     0| 62|     7| 6|CONTINUOUS|  0|ENDTAB|  0"
        HS(17) = "TABLE|  2|VIEW| 70|     0|  0|ENDTAB|  0"
        HS(18) = "TABLE|  2|DIMSTYLE| 70|     1|  0|DIMSTYLE|  2|STANDARD| 70|     0|  3||  4||  5||  6||  7|| 40|1.0| 41|0.18| 42|0.0625| 43|0.38| 44|0.18| 45|0.0| 46|0.0| 47|0.0| 48|0.0|140|0.18|141|0.09|142|0.0|143|25.4|144|1.0|145|0.0|146|1.0|147|0.09| 71|     0| 72|     0| 73|     1| 74|     1| 75|     0| 76|     0| 77|     0| 78|     0|170|     0|171|     2|172|     0|173|     0|174|     0|175|     0|176|     0|177|     0|178|     0|  0|ENDTAB|  0"
    HS(19) = "ENDSEC|  0|"
    DXF_Header = Join$(HS(), "|")
End Function
'The block header, body, and footer are used to append the
'header with any dimensional information added in the body.
Private Function DXF_BlockHeader() As String
DXF_BlockHeader = "SECTION|  2|BLOCKS|  0|"
End Function
Private Sub DXF_BuildBlockBody()
DXF_BlockBody = DXF_BlockBody & "BLOCK|  8|0|  2|*D" & BlockIndex & "|70|     1| 10|0.0| 20|0.0| 30|0.0|  3|*D" & BlockIndex & "|  1||0|ENDBLK|  8|0|0|"
BlockIndex = BlockIndex + 1
End Sub
Private Function DXF_BlockFooter() As String
DXF_BlockFooter = "ENDSEC|  0|"
End Function
'The body header, and footer will always remain the same
Private Function DXF_BodyHeader() As String
    DXF_BodyHeader = "SECTION|  2|ENTITIES|  0|"
End Function
Private Function DXF_BodyFooter() As String
    DXF_BodyFooter = "ENDSEC|  0|"
End Function
Private Function DXF_Footer() As String
DXF_Footer = "EOF"
End Function
Private Sub DXF_save_to_file(ByVal SavePath As String)
Dim varDXF, intDXF As Long, strDXF_Output As String
'Build a full text string
    strDXF_Output = DXF_Header & DXF_BlockHeader & DXF_BlockBody & DXF_BlockFooter & DXF_BodyHeader & DXF_BodyText & DXF_BodyFooter & DXF_Footer
'split the text string at "|" and output to specified file
    varDXF = Split(strDXF_Output, "|")
    Open SavePath For Output As #1
        For intDXF = 0 To UBound(varDXF)
            Print #1, varDXF(intDXF)
        Next
    Close #1
'Reminder of where the file was saved to
    'MsgBox "DXF file was saved to:" & vbCrLf & SavePath
End Sub

'====================================================
'All geometry is appended to the text: "DXF_BodyText"
'====================================================

Private Sub DXF_Line(ByVal iLayer As String, ByVal x1 As Single, ByVal y1 As Single, ByVal z1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal z2 As Single)
    DXF_BodyText = DXF_BodyText & "LINE|8|" & iLayer & _
        "| 10|" & x1 & "| 20|" & y1 & "| 30|" & z1 & _
        "| 11|" & x2 & "| 21|" & y2 & "| 31|" & z2 & "|0|"
End Sub
Private Sub DXF_Circle(ByVal iLayer As String, ByVal x As Single, ByVal y As Single, ByVal Z As Single, ByVal Radius As Single)
    DXF_BodyText = DXF_BodyText & "CIRCLE|8|" & iLayer & _
        "| 10|" & x & "| 20|" & y & "| 30|" & Z & _
        "| 40|" & Radius & "| 39|  0|0|"
End Sub
Private Sub DXF_Arc(ByVal iLayer As String, ByVal x As Single, ByVal y As Single, ByVal Z As Single, ByVal Radius As Single, ByVal StartAngle As Single, ByVal EndAngle As Single)
'"|62|1|" after iLayer sets the to color (Red)
    DXF_BodyText = DXF_BodyText & "ARC|8|" & iLayer & _
        "| 10|" & x & "| 20|" & y & "| 30|" & Z & _
        "| 40|" & Radius & "| 50|" & StartAngle & "| 51|" & EndAngle & "|0|"
End Sub
Private Sub DXF_Text(ByVal iLayer As String, ByVal x As Single, ByVal y As Single, ByVal Z As Single, ByVal Height As Single, ByVal iText As String)
    DXF_BodyText = DXF_BodyText & "TEXT|8|" & iLayer & _
              "| 10|" & x & "| 20|" & y & "| 30|" & Z & _
              "| 40|" & Height & "|1|" & iText & "| 50|  0|0|"
End Sub
Private Sub DXF_Dimension(ByVal iLayer As String, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal PX1 As Single, ByVal PY1 As Single, ByVal PX2 As Single, ByVal PY2 As Single, Optional ByVal iAng As Single = 0, Optional ByVal iText As String = "None")
'I know for sure that this works in AutoCAD.
Dim strDim(6) As String
    strDim(0) = "DIMENSION|  8|" & iLayer & "|  6|CONTINUOUS|  2|*D" & BlockIndex
    strDim(1) = " 10|" & PX1 & "| 20|" & PY1 & "| 30|0.0"
    strDim(2) = " 11|" & PX2 & "| 21|" & PY2 & "| 31|0.0"
    strDim(3) = IIf(iText = "None", " 70|     0", " 70|     0|  1|" & iText)
    strDim(4) = " 13|" & x1 & "| 23|" & y1 & "| 33|0.0"
    strDim(5) = " 14|" & x2 & "| 24|" & y2 & "| 34|0.0" & IIf(iAng = 0, "", "| 50|" & iAng)
    strDim(6) = "1001|ACAD|1000|DSTYLE|1002|{|1070|   287|1070|     3|1070|    40|1040|8.0|1070|   271|1070|     3|1070|   272|1070|     3|1070|   279|1070|     0|1002|}|  0|"
DXF_BodyText = DXF_BodyText & Join$(strDim(), "|")
'All dimensions need to be referenced in the header information
    DXF_BuildBlockBody
End Sub
Private Sub DXF_Rectangle(ByVal iLayer As String, ByVal x1 As Single, ByVal y1 As Single, ByVal z1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal z2 As Single)
Dim strRectangle(5) As String
    strRectangle(0) = "POLYLINE|  5|48|  8|" & iLayer & "|66|1| 10|0| 20|0| 30|0| 70|1|0"
    strRectangle(1) = "VERTEX|5|50|8|0| 10|" & x1 & "| 20|" & y1 & "| 30|" & z1 & "|  0"
    strRectangle(2) = "VERTEX|5|51|8|0| 10|" & x2 & "| 20|" & y1 & "| 30|" & z2 & "|  0"
    strRectangle(3) = "VERTEX|5|52|8|0| 10|" & x2 & "| 20|" & y2 & "| 30|" & z2 & "|  0"
    strRectangle(4) = "VERTEX|5|53|8|0| 10|" & x1 & "| 20|" & y2 & "| 30|" & z1 & "|  0"
    strRectangle(5) = "SEQEND|0|"
    DXF_BodyText = DXF_BodyText & Join$(strRectangle(), "|")
End Sub
Private Sub DXF_Border(ByVal iLayer As String, ByVal x1 As Single, ByVal y1 As Single, ByVal z1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal z2 As Single)
Dim strBorder(5) As String
    strBorder(0) = "POLYLINE|  8|" & iLayer & "| 40|1| 41|1| 66|1| 70|1|0"
    strBorder(1) = "VERTEX|  8|" & iLayer & "| 10|" & x1 & "| 20|" & y1 & "| 30|" & z1 & "|  0"
    strBorder(2) = "VERTEX|  8|" & iLayer & "| 10|" & x2 & "| 20|" & y1 & "| 30|" & z2 & "|  0"
    strBorder(3) = "VERTEX|  8|" & iLayer & "| 10|" & x2 & "| 20|" & y2 & "| 30|" & z2 & "|  0"
    strBorder(4) = "VERTEX|  8|" & iLayer & "| 10|" & x1 & "| 20|" & y2 & "| 30|" & z1 & "|  0"
    strBorder(5) = "SEQEND|  0|"
    DXF_BodyText = DXF_BodyText & Join$(strBorder(), "|")
End Sub
Private Sub DXF_ShowText(ByVal x As Single, ByVal y As Single, ByVal eAng As Single, ByVal eRad As Single, ByVal eText As Variant)
Dim eX As Single, eY As Single, iRadians As Single
iRadians = Radians(eAng)
'Find the angle at which to draw the arrow head and leader
    eX = x - (eRad * (Cos(iRadians)))
    eY = y - (eRad * (sIn(iRadians)))
    'Draw an arrow head
        DXF_ArrowHead iRadians + Radians(180), x, y
    'Draw the leader lines
        DXF_Line iLayer, x, y, 0, eX, eY, 0
        DXF_Line iLayer, eX, eY, 0, eX + 2, eY, 0
    'Place the text
        DXF_Text iLayer, eX + 2.5, eY - 0.75, 0, 1.5, eText
End Sub
Private Sub DXF_ArrowHead(iRadians As Single, sngX As Single, sngY As Single)
Dim x(1) As Single, y(1) As Single
'The number "3" is the length of the arrow head.
'Adding or subtracting 170 degrees from the angle
'gives us a 10 degree angle on the arrow head.
    'Finds the first side of the arrow head
        x(0) = sngX + (3 * (sIn(iRadians + Radians(170))))
        y(0) = sngY + (3 * (Cos(iRadians + Radians(170))))
    'Finds the second side of the arrow head
        x(1) = sngX + (3 * (sIn(iRadians - Radians(170))))
        y(1) = sngY + (3 * (Cos(iRadians - Radians(170))))
    'Draw the first side of the arrow head
        DXF_Line iLayer, sngX, sngY, 0, x(0), y(0), 0 '/
    'Draw the second side of the arrow head
        DXF_Line iLayer, sngX, sngY, 0, x(1), y(1), 0 '\
    'Draw the bottom side of the arrow head
        DXF_Line iLayer, x(0), y(0), 0, x(1), y(1), 0 '_
End Sub



