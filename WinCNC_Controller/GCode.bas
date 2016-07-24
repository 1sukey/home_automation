Attribute VB_Name = "GCode"
Option Explicit

Public IsoFormat As String
Public LineNumberFormat As String
Public AdditionalScaling As Single
Public xOld As Long
Public yOld As Long

Public LineNumber As Long

Const SCALEFACTOR = 10000

Public Function Value(InVal) As Long
  Value = CLng(Val(InVal) * SCALEFACTOR + 0.5)
End Function


Public Function Generate_GCodeFromArray_All(ByVal FileName As String) As Long
Dim count As Long, Vertex As Long
Dim i As Long, J As Long, R As Long, A1 As Single, A2 As Single
Dim x1 As Long, y1 As Long, x2 As Long, y2 As Long, z1 As Long, z2 As Long
yOld = 0
xOld = 0
  'points and text will be ignored!
  LineNumber = 0
  Open FileName For Output As #2
    Print #2, LineNumberStr(LineNumber) & " G90; # absolute coordinates "
    Print #2, LineNumberStr(LineNumber) & " G71; # metric programming unit "
   'LINES: 'working
    For count = 0 To ArrTot_Lines - 1
      If LayerArray(LineArray(count).Layer).Goutput Then
        'Call GCode_G00(LineArray(count).X0, LineArray(count).Y0)
        'Call GCode_G01(LineArray(count).X1, LineArray(count).Y1)
        Call GCodeLine_G0X(LineArray(count).X0, LineArray(count).Y0, LineArray(count).x1, LineArray(count).y1)
      End If
    Next
    'ARCS:'working
    For count = 0 To ArrTot_Arcs - 1
      If LayerArray(ArcArray(count).Layer).Goutput Then
        x1 = ArcArray(count).x + ArcArray(count).R * Cos(ArcArray(count).A1)
        y1 = ArcArray(count).y + ArcArray(count).R * sIn(ArcArray(count).A1)
        x2 = ArcArray(count).x + ArcArray(count).R * Cos(ArcArray(count).A2)
        y2 = ArcArray(count).y + ArcArray(count).R * sIn(ArcArray(count).A2)
        i = ArcArray(count).x - x1
        J = ArcArray(count).y - y1
        Call GCode_G00(x1, y1)
        Call GCode_G03(x2, y2, i, J)
      End If
    Next
    'CIRCLES 'should be working
    For count = 0 To ArrTot_Circles - 1
      If LayerArray(CircleArray(count).Layer).Goutput Then
        R = CircleArray(count).R
        x1 = CircleArray(count).x + R
        y1 = CircleArray(count).y
        x2 = CircleArray(count).x - R
        y2 = CircleArray(count).y
        Call GCode_G00(x1, y1)
        Call GCode_G03(x2, y2, -R, 0)
        Call GCode_G03(x1, y1, R, 0)
      End If
    Next
    'POLYLINES
    For count = 0 To ArrTot_Polylines - 1
      If LayerArray(PolylineArray(count).Layer).Goutput Then
        Call GCode_G00(VertexArray(PolylineArray(count).Vertex1).x, _
                       VertexArray(PolylineArray(count).Vertex1).y)
        For Vertex = PolylineArray(count).Vertex1 To PolylineArray(count).Vertex2 - 1
          If VertexArray(Vertex).B = 0 Then
            Call GCode_G01(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y)
          Else
            Call Bulge2IJ(VertexArray(Vertex).x, VertexArray(Vertex).y, _
                          VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, _
                          VertexArray(Vertex).B, i, J, R, A1, A2)
            If VertexArray(Vertex).B > 0 Then
              Call GCode_G03(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, i, J)
            Else
              Call GCode_G02(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, i, J)
            End If
          End If
        Next
        If PolylineArray(count).closed Then
          If VertexArray(PolylineArray(count).Vertex2).B = 0 Then
            Call GCode_G01(VertexArray(PolylineArray(count).Vertex1).x, VertexArray(PolylineArray(count).Vertex1).y)
          Else
            Call Bulge2IJ(VertexArray(PolylineArray(count).Vertex2).x, VertexArray(PolylineArray(count).Vertex2).y, _
                          VertexArray(PolylineArray(count).Vertex1).x, VertexArray(PolylineArray(count).Vertex1).y, _
                          VertexArray(PolylineArray(count).Vertex2).B, i, J, R, A1, A2)
            If VertexArray(Vertex).B > 0 Then
              Call GCode_G03(VertexArray(PolylineArray(count).Vertex1).x, VertexArray(PolylineArray(count).Vertex1).y, i, J)
            Else
              Call GCode_G02(VertexArray(PolylineArray(count).Vertex1).x, VertexArray(PolylineArray(count).Vertex1).y, i, J)
            End If
          End If
        End If
      End If
    Next
    Print #2, LineNumberStr(LineNumber) & " M02; # program end "
  Close #2
  Generate_GCodeFromArray_All = LineNumber
End Function



Public Function LineNumberStr(ByRef LineNumber As Long) As String
  LineNumberStr = "N" & Format(LineNumber, LineNumberFormat)
  LineNumber = LineNumber + 1
End Function

Public Sub GCode_G00(ByVal x As Long, ByVal y As Long)
Dim Linestr As String
  'Ho notato dei problemi di notazione scientifica e con la virgola
  'quindi devo usare format.
  'I have seen problems with the scientific notation, we have to use format!
  Linestr = "X" & Format(x / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y / SCALEFACTOR / AdditionalScaling, IsoFormat)
  'Però format è bastardo: invece di mettere il punto mi mette . o , a dipendenza del paese
  'Quindi devo rimpiazzare a mano la , con . per sicurezza!
  'Caveat: format uses the decimal placeholder of the country - coul be . or ,
  'But ISO-code needs always . --> let's replace , by . to avoid problems!
  Linestr = Replace(Linestr, ",", ".")
  'Print #2, LineNumberStr(LineNumber) & " G00 " & Linestr & ";"
  Print #2, LineNumberStr(LineNumber) & " M05 ;"
  Print #2, LineNumberStr(LineNumber) & " G00 Z" & Format(10000 / SCALEFACTOR / AdditionalScaling, IsoFormat) & ";"
  Print #2, LineNumberStr(LineNumber) & " G00 " & Linestr & ";"
  Print #2, LineNumberStr(LineNumber) & " M03 ;"
  Print #2, LineNumberStr(LineNumber) & " G00 Z" & Format(5000 / SCALEFACTOR / AdditionalScaling, IsoFormat) & ";"
End Sub
Public Sub GCodeLine_G0X(ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long)

Dim Linestr1 As String
Dim Linestr2 As String


  Linestr1 = "X" & Format(x1 / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y1 / SCALEFACTOR / AdditionalScaling, IsoFormat)
  Linestr1 = Replace(Linestr1, ",", ".")
  
  Linestr2 = "X" & Format(x2 / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y2 / SCALEFACTOR / AdditionalScaling, IsoFormat)
  Linestr2 = Replace(Linestr2, ",", ".")
  If xOld = x1 And yOld = y1 Then
  ' skip line, same as last position of previous line
  Else
  Print #2, LineNumberStr(LineNumber) & " M05 ;"
  Print #2, LineNumberStr(LineNumber) & " G00 Z" & Format(10000 / SCALEFACTOR / AdditionalScaling, IsoFormat) & ";"
  Print #2, LineNumberStr(LineNumber) & " G00 " & Linestr1 & ";"
  Print #2, LineNumberStr(LineNumber) & " M03 ;"
  Print #2, LineNumberStr(LineNumber) & " G00 Z" & Format(5000 / SCALEFACTOR / AdditionalScaling, IsoFormat) & ";"
  End If
    
  Print #2, LineNumberStr(LineNumber) & " G01 " & Linestr2 & ";"
  xOld = x2
  yOld = y2
End Sub

Public Sub GCode_G01(ByVal x As Long, ByVal y As Long)
Dim Linestr As String
  Linestr = "X" & Format(x / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y / SCALEFACTOR / AdditionalScaling, IsoFormat)
  Linestr = Replace(Linestr, ",", ".")
  Print #2, LineNumberStr(LineNumber) & " G01 " & Linestr & ";"
End Sub

Public Sub GCode_G02(ByVal x As Long, ByVal y As Long, _
                      ByVal i As Long, ByVal J As Long)
Dim Linestr As String
  Linestr = "X" & Format(x / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " I" & Format(i / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " J" & Format(J / SCALEFACTOR / AdditionalScaling, IsoFormat)
  Linestr = Replace(Linestr, ",", ".")
  Print #2, LineNumberStr(LineNumber) & " G02 " & Linestr & "; "
End Sub

Public Sub GCode_G03(ByVal x As Long, ByVal y As Long, _
                      ByVal i As Long, ByVal J As Long)
Dim Linestr As String
  Linestr = "X" & Format(x / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " Y" & Format(y / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " I" & Format(i / SCALEFACTOR / AdditionalScaling, IsoFormat) & _
           " J" & Format(J / SCALEFACTOR / AdditionalScaling, IsoFormat)
  Linestr = Replace(Linestr, ",", ".")
  Print #2, LineNumberStr(LineNumber) & " G03 " & Linestr & "; "
End Sub


