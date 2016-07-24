Attribute VB_Name = "DXF_Arrays"
Option Explicit

'Used as a global variable "everywhere"
Public Codes

'Supported entities to be drawn are store in different arrays.
'I first tryied to store them in a tree bur this was too slow:
'populating the tree is slow and also retrivial of information is slow.
Public Const ArrayAllocationSize = 1024

'I expected this is alway defined in VB but had pi >undefined<..
Public Const pi = 3.14159265358979

'Global array: DXF file is parsed and stored in those arrays
Public ArcArray() As ArcNodeDef
Public CircleArray() As CircleNodeDef
Public LineArray() As LineNodeDef
Public PointArray() As PointNodeDef
Public VertexArray() As VertexNodeDef
Public PolylineArray() As PolylineNodeDef
Public TextArray() As TextNodeDef
Public Face3DArray() As D3FaceDef

Public LayerArray() As LayerDef
Public Layers As String
Public ArrTot_Layers As Long

Public ArrTot_Arcs As Long
Public ArrTot_Circles As Long
Public ArrTot_Lines As Long
Public ArrTot_Points As Long
Public ArrTot_Vertexes As Long
Public ArrTot_Polylines As Long
Public ArrTot_Texts As Long
Public ArrTot_3DFaces As Long

Public MinX As Long, MinY As Long
Public MaxX As Long, MaxY As Long
Public FirstCoordinate As Boolean

Public BlockFound As Boolean 'for block warning

Type ArcNodeDef
  Layer As Long
  x As Long 'center
  y As Long
  R As Long   'radius
  A1 As Single  'start angle
  A2 As Single  'end angle
End Type

Type CircleNodeDef
  Layer As Long
  x As Long 'center
  y As Long
  R As Long   'radius
End Type

Type LineNodeDef
  Layer As Long
  X0 As Long  'start point
  Y0 As Long
  X1 As Long  'end point
  Y1 As Long
End Type

Type PointNodeDef
  Layer As Long
  x As Long
  y As Long
End Type

Type VertexNodeDef
  Layer As Long
  x As Long
  y As Long
  B As Single
End Type

Type TextNodeDef
  Layer As Long
  x As Long
  y As Long
  T As String
End Type

Type PolylineNodeDef
  Layer As Long
  closed As Boolean 'closed polyline?
  Vertex1 As Long  'reference to Vertex Array - first vertex
  Vertex2 As Long  'reference to Vertex Array - last vertex
End Type

Type D3FaceDef
  Layer As Long
  Vertexes As Long      '3 or 4
  x(0 To 3) As Long
  y(0 To 3) As Long
End Type

Type LayerDef
  Name As String
  Color As Long
  Enabled As Boolean
  Goutput As Boolean
End Type


Public Function CStr_(ByVal S) As String
'This stupid function is necessary since VB uses national settings for output
'So 4.1 could be written as 4,2. But Val(4,2) is not evalueted to 4.2
'DON'T ASK ME WHY! This is one of the dark sides of microsoft visual basic...
Dim T As String
  T = CStr(S)
  T = Replace(T, ",", ".")
  CStr_ = T
End Function

'Passing variables ByVal and not using "variant" is faster!
'Only output variables will be declared ByRef
Public Sub Bulge2IJ(ByVal X1 As Long, ByVal Y1 As Long, _
                    ByVal X2 As Long, ByVal Y2 As Long, _
                    ByVal Bulge As Single, _
                    ByRef I As Long, ByRef J As Long, _
                    ByRef R As Long, _
                    ByRef AlphaFrom As Single, ByRef AlphaTo As Single)
  Dim C As Single            'lunghezza della corda - length of the cord
  Dim H As Single           'altezza del triangolo - height of the triangle
  Dim alpha2 As Single      'mezzo angolo di arco  - half arc angle
  Dim beta As Single        'angolo della corda rispetto agli assi - orientation of the segment
  Dim dummY As Long
  
  ' The bulge is the tangent of one fourth the
  ' included angle for an arc segment, made negative if the arc goes
  ' clockwise from the start point to the endpoint.
  ' A bulge of 0 indicates a straight segment,
  ' and a bulge of 1 is a semicircle

  'abbiamo la corda e la tangente dell'angolo della corda (0=Nord)
  'We have the cord and the tangent of the arc radius
  ' C=2R sin (Alpha/2)
  If Bulge <> 0 Then
    C = Sqr((X2 - X1) ^ 2 + (Y2 - Y1) ^ 2)
    alpha2 = Atn(Bulge) * 2
    R = Abs(((C / (2 * Sin(alpha2)))))
    H = Sqr(R ^ 2 - (C / 2) ^ 2)
    
    If (Bulge > 1) Or ((Bulge < 0) And (Bulge > -1)) Then alpha2 = alpha2 + pi
    
    If (X1 <> X2) Then
      beta = Atn((Y2 - Y1) / (X2 - X1))
      If X2 < X1 Then beta = beta + pi
    Else
      If Y2 < Y1 Then beta = -pi / 2 Else beta = pi / 2
    End If
    
    If ((Bulge > 1) Or ((Bulge < 0) And (Bulge > -1))) Then
      I = CLng((X2 - X1) / 2 + (Cos(beta - pi / 2) * H))
      J = CLng((Y2 - Y1) / 2 + (Sin(beta - pi / 2) * H))
    Else
      I = CLng((X2 - X1) / 2 - (Cos(beta - pi / 2) * H))
      J = CLng((Y2 - Y1) / 2 - (Sin(beta - pi / 2) * H))
    End If
    
    If I <> 0 Then
      AlphaFrom = Atn(J / I)
      If I > 0 Then AlphaFrom = AlphaFrom + pi
    Else
      If (J > 0) Then AlphaFrom = pi / 2 Else AlphaFrom = -pi / 2
    End If
    AlphaTo = AlphaFrom + alpha2 * 2
    
    While (AlphaTo > 2 * pi)    'clip angles to 0...2pi
      AlphaTo = AlphaTo - 2 * pi
    Wend
    While (AlphaTo < 0)
      AlphaTo = AlphaTo + 2 * pi
    Wend
    While (AlphaFrom > 2 * pi)
      AlphaFrom = AlphaFrom - 2 * pi
    Wend
    While (AlphaFrom < 0)
      AlphaFrom = AlphaFrom + 2 * pi
    Wend
    
    If Bulge < 0 Then 'swap start and end angle
      dummY = AlphaTo: AlphaTo = AlphaFrom: AlphaFrom = dummY
    End If
  End If
End Sub

Public Sub CheckMinMaxXY(ByVal x As Long, ByVal y As Long)
  If x > MaxX Then
    MaxX = x
  ElseIf x < MinX Then
    MinX = x
  End If
  If y > MaxY Then
    MaxY = y
  ElseIf y < MinY Then
    MinY = y
  End If
End Sub

Public Sub CheckArcXY(ByVal x As Long, ByVal y As Long, _
                      ByVal R As Long, _
                      ByVal AlphaFrom As Single, ByVal AlphaTo As Single)
  If AlphaTo < AlphaFrom Then AlphaTo = AlphaTo + 2 * pi
  'Alphafrom is between 0 and 2*pi, alpha to between 0 and 4*pi so I have to check 8 possibilitites!
  If ((1 * pi / 2) > AlphaFrom) And ((1 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x, y + R)
  If ((2 * pi / 2) > AlphaFrom) And ((2 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x - R, y)
  If ((3 * pi / 2) > AlphaFrom) And ((3 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x, y - R)
  If ((4 * pi / 2) > AlphaFrom) And ((4 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x + R, y)
  If ((5 * pi / 2) > AlphaFrom) And ((5 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x, y + R)
  If ((6 * pi / 2) > AlphaFrom) And ((6 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x - R, y)
  If ((7 * pi / 2) > AlphaFrom) And ((7 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x, y - R)
  If ((8 * pi / 2) > AlphaFrom) And ((8 * pi / 2) < AlphaTo) Then Call CheckMinMaxXY(x + R, y)
End Sub

Private Function GetLayer(Name As String) As Long
Dim I As Long
'Public LayerArray() As String
'Public Layers As String
'Public ArrTot_Layers As Long

  If InStr(Layers, Name) Then
    For I = 0 To ArrTot_Layers - 1
      If Name = LayerArray(I).Name Then GetLayer = I
    Next
  Else
    Layers = Layers & vbCr & vbLf & Name
    If ArrTot_Layers >= UBound(LayerArray) Then
      ReDim Preserve LayerArray(0 To UBound(LayerArray) + 10)
    End If
    LayerArray(ArrTot_Layers).Name = Name
    LayerArray(ArrTot_Layers).Enabled = True
    LayerArray(ArrTot_Layers).Goutput = True
    'LayerArray(ArrTot_Layers).Color = vbBlack
    ArrTot_Layers = ArrTot_Layers + 1
    GetLayer = ArrTot_Layers - 1
  End If
End Function


Public Sub PopulateArray(ByVal FileName As String)
'parse DXF file and popuolates the Entities Array
   Open FileName For Input As #1
     Do While Not EOF(1)   ' Loop until end of file.
       Codes = ReadCodes()
       If Codes(0) = 2 Then
         Select Case Codes(1)
           Case "ENTITIES":
             Call RecArrayEntities
           Case "HEADER"
             Call RecArraySkipSection
           Case "CLASSES"
             Call RecArraySkipSection
           Case "BLOCKS"
             Call RecArraySkipSection
           Case "TABLES"
             Call RecArraySkipSection
           Case "OBJECTS"
             Call RecArraySkipSection
           Case Else:
             MsgBox "Unkown section found " & Codes(1)
         End Select
       End If
     Loop
   Close
End Sub

Private Sub RecArraySkipSection()
  Codes = ReadCodes
  While Not EOF(1)  'entitie ends with endsec
    If (Codes(0) = 0) And (Codes(1) = "ENDSEC") Then Exit Sub
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecSkipZeroTerminated()
  Codes = ReadCodes
  While Not EOF(1)  'entitie ends with next entitie declaration
    If Codes(0) = 0 Then Exit Sub
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecArrayEntities()
  Codes = ReadCodes
  While Not EOF(1)  'entitie ends with endsec
    Select Case Codes(0)
      Case 0:
        Select Case Codes(1)
          Case "POLYLINE":
            Call RecArrAdd_Polylines
          Case "ARC":
            Call RecArrAdd_Arc
          Case "LINE":
            Call RecArrAdd_Line
          Case "POINT":
            Call RecArrAdd_Point
          Case "CIRCLE":
            Call RecArrAdd_Circle
          Case "TEXT":
            Call RecArrAdd_Text
          Case "3DFACE":
            Call RecArrAdd_3DFace
          Case "SOLID":
            Call RecArrAdd_3DFace 'RecSolid
          Case "INSERT":  'not supported yet!
            BlockFound = True
            Call RecSkipZeroTerminated
          Case "DIMENSION", "3DSOLID", "ACAD_PROXY_ENTITY", _
               "ATTDEF", "ATTRIB", "BODY", "ELLIPSE", "HATCH", "IMAGE", "INSERT", _
               "LEADER", "LWPOLYLINE", "RAY", "REGION", "SHAPE", "SPLINE", _
               "TOLERANCE", "TRACE", "VIEWPORT", "XLINE":
            Call RecSkipZeroTerminated
          Case "ENDSEC":
            Exit Sub
          Case Else:
            Codes = ReadCodes
        End Select
      Case Else
        Codes = ReadCodes
    End Select
  Wend
End Sub


Private Sub RecArrAdd_Line()
  'Check if there is space in the array
  If ArrTot_Lines >= UBound(LineArray) Then
    ReDim Preserve LineArray(0 To UBound(LineArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  LineArray(ArrTot_Lines).Layer = 0
  LineArray(ArrTot_Lines).X0 = 0
  LineArray(ArrTot_Lines).Y0 = 0
  LineArray(ArrTot_Lines).X1 = 0
  LineArray(ArrTot_Lines).Y1 = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         LineArray(ArrTot_Lines).Layer = GetLayer(CStr_(Codes(1)))
      Case 10 'X coordinate value  point
         LineArray(ArrTot_Lines).X0 = Value(Codes(1))
      Case 20 'Y coordinate value  point
         LineArray(ArrTot_Lines).Y0 = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 11 'X coordinate value  point
         LineArray(ArrTot_Lines).X1 = Value(Codes(1))
      Case 21 'Y coordinate value  point
         LineArray(ArrTot_Lines).Y1 = Value(Codes(1))
      Case 31 'Z coordinate value  point
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = LineArray(ArrTot_Lines).X0: MinX = MaxX
          MaxY = LineArray(ArrTot_Lines).Y0: MinY = MaxY
        End If
        Call CheckMinMaxXY(LineArray(ArrTot_Lines).X0, _
                            LineArray(ArrTot_Lines).Y0)
        Call CheckMinMaxXY(LineArray(ArrTot_Lines).X1, _
                            LineArray(ArrTot_Lines).Y1)
        ArrTot_Lines = ArrTot_Lines + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecSolid()
Dim I As Long
Dim X0 As Long, X1 As Long, X2 As Long, X3 As Long
Dim Y0 As Long, Y1 As Long, Y2 As Long, Y3 As Long
  'The solid entitie is collected as single lines
  'AND: ^trying to eliminate double lines (Elefont:
  ' solid is used with triangles, so chesk last 3 lines)
  
  
  'Check if there is space in the array
  If (ArrTot_Lines + 4) >= UBound(LineArray) Then
    ReDim Preserve LineArray(0 To UBound(LineArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  For I = 0 To 3
    LineArray(ArrTot_Lines + I).Layer = 0
    LineArray(ArrTot_Lines + I).X0 = 0
    LineArray(ArrTot_Lines + I).Y0 = 0
    LineArray(ArrTot_Lines + I).X1 = 0
    LineArray(ArrTot_Lines + I).Y1 = 0
  Next
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         LineArray(ArrTot_Lines).Layer = GetLayer(CStr_(Codes(1)))
      Case 10:          X0 = Value(Codes(1))
      Case 11:          X1 = Value(Codes(1))
      Case 12:          X2 = Value(Codes(1))
      Case 13:          X3 = Value(Codes(1))
      Case 20:          Y0 = Value(Codes(1))
      Case 21:          Y1 = Value(Codes(1))
      Case 22:          Y2 = Value(Codes(1))
      Case 23:          Y3 = Value(Codes(1))
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = X0: MinX = MaxX
          MaxY = Y0: MinY = MaxY
        End If
        Call CheckMinMaxXY(X0, Y0)
        Call CheckMinMaxXY(X1, Y1)
        Call CheckMinMaxXY(X2, Y2)
        Call CheckMinMaxXY(X3, Y3)
        LineArray(ArrTot_Lines + 1).Layer = LineArray(ArrTot_Lines).Layer
        LineArray(ArrTot_Lines + 2).Layer = LineArray(ArrTot_Lines).Layer
        LineArray(ArrTot_Lines + 3).Layer = LineArray(ArrTot_Lines).Layer
        If Not SearchLast3Lines(X0, Y0, X1, Y1) Then
          LineArray(ArrTot_Lines).X0 = X0 ' P0 <--> P1
          LineArray(ArrTot_Lines).Y0 = Y0
          LineArray(ArrTot_Lines).X1 = X1
          LineArray(ArrTot_Lines).Y1 = Y1
          ArrTot_Lines = ArrTot_Lines + 1
        End If
        If Not SearchLast3Lines(X1, Y1, X2, Y2) Then
          LineArray(ArrTot_Lines).X0 = X1 ' P1 <--> P2
          LineArray(ArrTot_Lines).Y0 = Y1
          LineArray(ArrTot_Lines).X1 = X2
          LineArray(ArrTot_Lines).Y1 = Y2
          ArrTot_Lines = ArrTot_Lines + 1
        End If
        'P3 Fourth corner. If only three corners are entered to
        'define the SOLID, then the fourth corner coordinate
        'is the same as the third.
        If ((X3 = X2) And (Y3 = Y2)) Then
          If Not SearchLast3Lines(X2, Y2, X0, Y0) Then
            LineArray(ArrTot_Lines).X0 = X2 'P2 <--> P0
            LineArray(ArrTot_Lines).Y0 = Y2
            LineArray(ArrTot_Lines).X1 = X0
            LineArray(ArrTot_Lines).Y1 = Y0
            ArrTot_Lines = ArrTot_Lines + 1
          End If
        Else
          If Not SearchLast3Lines(X2, Y2, X3, Y3) Then
            LineArray(ArrTot_Lines).X0 = X2 'P2 <--> P3
            LineArray(ArrTot_Lines).Y0 = Y2
            LineArray(ArrTot_Lines).X1 = X3
            LineArray(ArrTot_Lines).Y1 = Y3
            ArrTot_Lines = ArrTot_Lines + 1
          End If
          If Not SearchLast3Lines(X3, Y3, X0, Y0) Then
            LineArray(ArrTot_Lines).X0 = X3 'P3 <--> P0
            LineArray(ArrTot_Lines).Y0 = Y3
            LineArray(ArrTot_Lines).X1 = X0
            LineArray(ArrTot_Lines).Y1 = Y0
            ArrTot_Lines = ArrTot_Lines + 1
          End If
        End If
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Function SearchLast3Lines(X0 As Long, Y0 As Long, X1 As Long, Y1 As Long) As Boolean
  Dim I As Long
  I = ArrTot_Lines - 7: If I < 0 Then I = 0
  For I = I To ArrTot_Lines
    If (((LineArray(I).X0 = X0) And (LineArray(I).Y0 = Y0) And _
         (LineArray(I).X1 = X1) And (LineArray(I).Y1 = Y1)) Or _
         ((LineArray(I).X0 = X1) And (LineArray(I).Y0 = Y1) And _
         (LineArray(I).X1 = X0) And (LineArray(I).Y1 = Y0))) Then
        SearchLast3Lines = False 'true
        Exit Function
    End If
  Next
  SearchLast3Lines = False
End Function

Private Sub RecArrAdd_3DFace()
Dim I As Long
  'Check if there is space in the array
  If ArrTot_3DFaces >= UBound(Face3DArray) Then
    ReDim Preserve Face3DArray(0 To UBound(Face3DArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  Face3DArray(ArrTot_3DFaces).Layer = 0
  Face3DArray(ArrTot_3DFaces).Vertexes = 0
  For I = 0 To 3
    Face3DArray(ArrTot_3DFaces).x(I) = 0
    Face3DArray(ArrTot_3DFaces).y(I) = 0
  Next
  
'This function does not collect data in an array but searches only for min/max coordinates
'Maybe in the future an 3DFaceArray could be...
  Codes = ReadCodes
  While Not EOF(1)  '3DFace ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    I = Val(Codes(0)) Mod 10
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         Face3DArray(ArrTot_3DFaces).Layer = GetLayer(CStr_(Codes(1)))
      Case 10, 11, 12, 13 'X coordinate value  point
        Face3DArray(ArrTot_3DFaces).x(I) = Value(Codes(1))
        If I > Face3DArray(ArrTot_3DFaces).Vertexes Then Face3DArray(ArrTot_3DFaces).Vertexes = I
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = Value(Codes(1)): MinX = MaxX
        End If
        If Value(Codes(1)) > MaxX Then MaxX = Value(Codes(1))
        If Value(Codes(1)) < MinX Then MinX = Value(Codes(1))
      Case 20, 21, 22, 23 'Y coordinate value  point
        Face3DArray(ArrTot_3DFaces).y(I) = Value(Codes(1))
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxY = Value(Codes(1)): MinY = MaxY
        End If
        If Value(Codes(1)) > MaxY Then MaxY = Value(Codes(1))
        If Value(Codes(1)) < MinY Then MinY = Value(Codes(1))
      Case 30, 31, 32, 33 'Z coordinate value  point
      Case 0    'Next Entity type --> this one is complete
        'if SOLID has only 3 borders
        If Face3DArray(ArrTot_3DFaces).Vertexes = 3 Then
          If ((Face3DArray(ArrTot_3DFaces).x(2) = Face3DArray(ArrTot_3DFaces).x(3)) And _
              (Face3DArray(ArrTot_3DFaces).y(2) = Face3DArray(ArrTot_3DFaces).y(3))) Then
              Face3DArray(ArrTot_3DFaces).Vertexes = 2
          End If
        End If
        ArrTot_3DFaces = ArrTot_3DFaces + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecArrAdd_Point()
  'Check if there is space in the array
  If ArrTot_Points >= UBound(PointArray) Then
    ReDim Preserve PointArray(0 To UBound(PointArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  PointArray(ArrTot_Points).Layer = 0
  PointArray(ArrTot_Points).x = 0
  PointArray(ArrTot_Points).y = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         PointArray(ArrTot_Points).Layer = GetLayer(CStr_(Codes(1)))
      Case 10 'X coordinate value  point
         PointArray(ArrTot_Points).x = Value(Codes(1))
      Case 20 'Y coordinate value  point
         PointArray(ArrTot_Points).y = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = PointArray(ArrTot_Points).x: MinX = MaxX
          MaxY = PointArray(ArrTot_Points).y: MinY = MaxY
        End If
        Call CheckMinMaxXY(PointArray(ArrTot_Points).x, _
                            PointArray(ArrTot_Points).y)
        ArrTot_Points = ArrTot_Points + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecArrAdd_Text()
  'Check if there is space in the array
  If ArrTot_Texts >= UBound(TextArray) Then
    ReDim Preserve TextArray(0 To UBound(TextArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  TextArray(ArrTot_Texts).Layer = 0
  TextArray(ArrTot_Texts).x = 0
  TextArray(ArrTot_Texts).y = 0
  TextArray(ArrTot_Texts).T = ""
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         TextArray(ArrTot_Texts).Layer = GetLayer(CStr_(Codes(1)))
      Case 1  'Text caption
         TextArray(ArrTot_Texts).T = Codes(1)
      Case 10 'X coordinate value  point
         TextArray(ArrTot_Texts).x = Value(Codes(1))
      Case 20 'Y coordinate value  point
         TextArray(ArrTot_Texts).y = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = TextArray(ArrTot_Texts).x: MinX = MaxX
          MaxY = TextArray(ArrTot_Texts).y: MinY = MaxY
        Else
          Call CheckMinMaxXY(TextArray(ArrTot_Texts).x, _
                             TextArray(ArrTot_Texts).y)
        End If
        ArrTot_Texts = ArrTot_Texts + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub


Private Sub RecArrAdd_Vertex()
Dim I As Long, J As Long, R As Long, AlphaFrom As Single, AlphaTo As Single
  'Check if there is space in the array
  If ArrTot_Vertexes >= UBound(VertexArray) Then
    ReDim Preserve VertexArray(0 To UBound(VertexArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  VertexArray(ArrTot_Vertexes).Layer = 0
  VertexArray(ArrTot_Vertexes).x = 0
  VertexArray(ArrTot_Vertexes).y = 0
  VertexArray(ArrTot_Vertexes).B = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         VertexArray(ArrTot_Vertexes).Layer = GetLayer(CStr_(Codes(1)))
      Case 10 'X coordinate value  point
         VertexArray(ArrTot_Vertexes).x = Value(Codes(1))
      Case 20 'Y coordinate value  point
         VertexArray(ArrTot_Vertexes).y = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 42 'Bulge
         VertexArray(ArrTot_Vertexes).B = Val(Codes(1))
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = VertexArray(ArrTot_Vertexes).x: MinX = MaxX
          MaxY = VertexArray(ArrTot_Vertexes).y: MinY = MaxY
        Else
          Call CheckMinMaxXY(VertexArray(ArrTot_Vertexes).x, _
                             VertexArray(ArrTot_Vertexes).y)
        End If
        If ArrTot_Vertexes > PolylineArray(ArrTot_Polylines).Vertex1 Then
        'If it is not the first vertex check for Bulge!
        '!If the polyline is closed-line and the last segment is bulge it won't be
        ' considered in min/max searching!
          If VertexArray(ArrTot_Vertexes - 1).B <> 0 Then
            '!! arco, forse le coordinate minime/massime sono altre!
            'approssimiamo pensando non al raggio ma all'altezza della corda come worst case
            Call Bulge2IJ(VertexArray(ArrTot_Vertexes - 1).x, _
                          VertexArray(ArrTot_Vertexes - 1).y, _
                          VertexArray(ArrTot_Vertexes).x, _
                          VertexArray(ArrTot_Vertexes).y, _
                          VertexArray(ArrTot_Vertexes - 1).B, I, J, R, AlphaFrom, AlphaTo)
            Call CheckArcXY(VertexArray(ArrTot_Vertexes - 1).x + I, _
                            VertexArray(ArrTot_Vertexes - 1).y + J, _
                            R, AlphaFrom, AlphaTo)
          End If
        End If
        ArrTot_Vertexes = ArrTot_Vertexes + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecArrAdd_Polylines()
  'Check if there is space in the array
  If ArrTot_Polylines >= UBound(PolylineArray) Then
    ReDim Preserve PolylineArray(0 To UBound(PolylineArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  PolylineArray(ArrTot_Polylines).Layer = 0
  PolylineArray(ArrTot_Polylines).closed = False
  PolylineArray(ArrTot_Polylines).Vertex1 = ArrTot_Vertexes
  PolylineArray(ArrTot_Polylines).Vertex2 = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         PolylineArray(ArrTot_Polylines).Layer = GetLayer(CStr_(Codes(1)))
         Codes = ReadCodes
      Case 70 'Flags
         If (Val(Codes(1)) And 1) = 1 Then
           PolylineArray(ArrTot_Polylines).closed = True
         End If
         Codes = ReadCodes
      Case 0
        Select Case Codes(1)
          Case "VERTEX":
            Call RecArrAdd_Vertex
          Case "SEQEND":
            PolylineArray(ArrTot_Polylines).Vertex2 = ArrTot_Vertexes - 1
            ArrTot_Polylines = ArrTot_Polylines + 1
            Codes = ReadCodes  'skip SEQEND
            Exit Sub
          Case Else: 'unknown
            Codes = ReadCodes
        End Select
      Case Else:
        Codes = ReadCodes
    End Select
  Wend
End Sub


Private Sub RecArrAdd_Arc()
  'Check if there is space in the array
  If ArrTot_Arcs >= UBound(ArcArray) Then
    ReDim Preserve ArcArray(0 To UBound(ArcArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  ArcArray(ArrTot_Arcs).Layer = 0
  ArcArray(ArrTot_Arcs).x = 0
  ArcArray(ArrTot_Arcs).y = 0
  ArcArray(ArrTot_Arcs).R = 0
  ArcArray(ArrTot_Arcs).A1 = 0
  ArcArray(ArrTot_Arcs).A2 = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         ArcArray(ArrTot_Arcs).Layer = GetLayer(CStr_(Codes(1)))
      Case 10 'X coordinate value  point
         ArcArray(ArrTot_Arcs).x = Value(Codes(1))
      Case 20 'Y coordinate value  point
         ArcArray(ArrTot_Arcs).y = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 40 'Radius
         ArcArray(ArrTot_Arcs).R = Value(Codes(1))
      Case 50 'start angle
         ArcArray(ArrTot_Arcs).A1 = Val(Codes(1)) / 180 * pi
      Case 51 'end angle
         ArcArray(ArrTot_Arcs).A2 = Val(Codes(1)) / 180 * pi
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = ArcArray(ArrTot_Arcs).x + ArcArray(ArrTot_Arcs).R * Cos(ArcArray(ArrTot_Arcs).A1): MinX = MaxX
          MaxY = ArcArray(ArrTot_Arcs).y + ArcArray(ArrTot_Arcs).R * Sin(ArcArray(ArrTot_Arcs).A1): MinY = MaxY
        End If
        Call CheckMinMaxXY(ArcArray(ArrTot_Arcs).x + ArcArray(ArrTot_Arcs).R * Cos(ArcArray(ArrTot_Arcs).A1), _
                            ArcArray(ArrTot_Arcs).y + ArcArray(ArrTot_Arcs).R * Sin(ArcArray(ArrTot_Arcs).A1))
        Call CheckMinMaxXY(ArcArray(ArrTot_Arcs).x + ArcArray(ArrTot_Arcs).R * Cos(ArcArray(ArrTot_Arcs).A2), _
                            ArcArray(ArrTot_Arcs).y + ArcArray(ArrTot_Arcs).R * Sin(ArcArray(ArrTot_Arcs).A2))
        Call CheckArcXY(ArcArray(ArrTot_Arcs).x, ArcArray(ArrTot_Arcs).y, _
                        ArcArray(ArrTot_Arcs).R, _
                        ArcArray(ArrTot_Arcs).A1, ArcArray(ArrTot_Arcs).A2)
        ArrTot_Arcs = ArrTot_Arcs + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

Private Sub RecArrAdd_Circle()
  'Check if there is space in the array
  If ArrTot_Circles >= UBound(CircleArray) Then
    ReDim Preserve CircleArray(0 To UBound(CircleArray) + ArrayAllocationSize)
    'Allocation is done in "big" steps to gain speed!
  End If
  CircleArray(ArrTot_Circles).Layer = 0
  CircleArray(ArrTot_Circles).x = 0
  CircleArray(ArrTot_Circles).y = 0
  CircleArray(ArrTot_Circles).R = 0
  
  Codes = ReadCodes
  While Not EOF(1)  'Line ends with next entitie declaration
    'sometimes there are problems with decimal point place holder
    Codes(1) = Replace(Codes(1), ",", ".")
    Select Case Codes(0)
      'Case 5    'handle
      Case 8    'Layer Name
         CircleArray(ArrTot_Circles).Layer = GetLayer(CStr_(Codes(1)))
      Case 10 'X coordinate value  point
         CircleArray(ArrTot_Circles).x = Value(Codes(1))
      Case 20 'Y coordinate value  point
         CircleArray(ArrTot_Circles).y = Value(Codes(1))
      Case 30 'Z coordinate value  point
      Case 11 'X coordinate value  point
         CircleArray(ArrTot_Circles).x = Value(Codes(1))
      Case 21 'Y coordinate value  point
         CircleArray(ArrTot_Circles).y = Value(Codes(1))
      Case 31 'Z coordinate value  point
      Case 40 'Radius
         CircleArray(ArrTot_Circles).R = Value(Codes(1))
      Case 0    'Next Entity type --> this one is complete
        If FirstCoordinate Then
          FirstCoordinate = False
          MaxX = CircleArray(ArrTot_Circles).x: MinX = MaxX
          MaxY = CircleArray(ArrTot_Circles).y: MinY = MaxY
        End If
        If CircleArray(ArrTot_Circles).x + CircleArray(ArrTot_Circles).R > MaxX Then MaxX = CircleArray(ArrTot_Circles).x + CircleArray(ArrTot_Circles).R
        If CircleArray(ArrTot_Circles).x - CircleArray(ArrTot_Circles).R < MinX Then MinX = CircleArray(ArrTot_Circles).x - CircleArray(ArrTot_Circles).R
        If CircleArray(ArrTot_Circles).y + CircleArray(ArrTot_Circles).R > MaxY Then MaxY = CircleArray(ArrTot_Circles).y + CircleArray(ArrTot_Circles).R
        If CircleArray(ArrTot_Circles).y - CircleArray(ArrTot_Circles).R < MinY Then MinY = CircleArray(ArrTot_Circles).y - CircleArray(ArrTot_Circles).R
        ArrTot_Circles = ArrTot_Circles + 1
        Exit Sub
      Case Else:
        'Dont'collect other informations
    End Select
    ' Read another code value pair
    Codes = ReadCodes
  Wend
End Sub

