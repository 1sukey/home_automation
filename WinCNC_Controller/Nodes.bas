Attribute VB_Name = "Nodes"
Option Explicit

Public PathNodeArray() As PathNodeDef
Public ArrTot_PathNodes As Long

Public Const TLINE = 0
Public Const TARC = 1
Public Const TCIRCLE = 2
Public Const TPOLYLINE = 3
Public Const T3DFACE = 4

Const Tnotmatched = -1
Const Tnotclosed = -2

Type PathNodeDef
  x As Long  'start or end point - in micrometers (if metric)
  y As Long
  T As Byte     'Type: Polyline Line Arc Circles
  I As Long
  J As Long
  N As Long
  Match As Long
  Tag As Long 'used to signal a re-enetring special path
End Type

Public PathLineArray() As PathLineDef
Public ArrTot_PathLines As Long

Type PathLineDef
  FirstN As Long  'beginiing node
  LastN As Long   'ending node
  TotN As Long    'total nodes in path
  closed As Boolean 'true if closed
End Type

Private Sub AddNode(x As Long, y As Long, T As Long, I As Long, J As Long, N As Long, Tag As Long)
  'Check if there is space in the array
  If ArrTot_PathNodes >= UBound(PathNodeArray) Then
    ReDim Preserve PathNodeArray(0 To UBound(PathNodeArray) + 2) 'provvisorio/facilita debugging
    'Allocation is done in "big" steps to gain speed! ArrayAllocationSize
  End If
  PathNodeArray(ArrTot_PathNodes).x = x
  PathNodeArray(ArrTot_PathNodes).y = y
  PathNodeArray(ArrTot_PathNodes).T = T
  PathNodeArray(ArrTot_PathNodes).I = I
  PathNodeArray(ArrTot_PathNodes).J = J
  PathNodeArray(ArrTot_PathNodes).N = N
  PathNodeArray(ArrTot_PathNodes).Tag = Tag
  PathNodeArray(ArrTot_PathNodes).Match = Tnotmatched
  ArrTot_PathNodes = ArrTot_PathNodes + 1
End Sub

Function Match_XY(X0 As Long, Y0 As Long, X1 As Long, Y1 As Long) As Boolean
'matching coordinates with some error allowed
  If (Abs(X0 - X1) < 2) And (Abs(Y0 - Y1) < 2) Then Match_XY = True Else Match_XY = False
End Function

Public Sub Collect_Path_Nodes()
Dim count As Long, Vertex As Long
'In this procedure I collect all the start and end points of the
'lines, arcs, circles, polylines
'This will be used to try to generate a single line

Dim I As Long, J As Long, R As Long, A1 As Single, A2 As Single
Dim X1 As Long, Y1 As Long, X2 As Long, Y2 As Long
Dim H As Long

ArrTot_PathNodes = 0

   'LINES:
    For count = 0 To ArrTot_Lines - 1
      If LayerArray(LineArray(count).Layer).Goutput Then
        'skip 0-length lines
        If (LineArray(count).X0 = LineArray(count).X1) And (LineArray(count).Y0 = LineArray(count).Y1) Then
        Else
          Call AddNode(LineArray(count).X0, LineArray(count).Y0, TLINE, 0, 0, count, Tnotmatched)
          Call AddNode(LineArray(count).X1, LineArray(count).Y1, TLINE, 0, 0, count, Tnotmatched)
        End If
      End If
    Next
    'ARCS:
    For count = 0 To ArrTot_Arcs - 1
      If LayerArray(ArcArray(count).Layer).Goutput Then
        X1 = ArcArray(count).x + ArcArray(count).R * Cos(ArcArray(count).A1)
        Y1 = ArcArray(count).y + ArcArray(count).R * Sin(ArcArray(count).A1)
        X2 = ArcArray(count).x + ArcArray(count).R * Cos(ArcArray(count).A2)
        Y2 = ArcArray(count).y + ArcArray(count).R * Sin(ArcArray(count).A2)
        I = ArcArray(count).x - X2
        J = ArcArray(count).y - Y2
        Call AddNode(X1, Y1, TARC, I, J, count, Tnotmatched)
        I = ArcArray(count).x - X1
        J = ArcArray(count).y - Y1
        Call AddNode(X2, Y2, TARC, I, J, count, Tnotmatched)
      End If
    Next
    'CIRCLES:
    'For count = 0 To ArrTot_Circles - 1
    '  If LayerArray(CircleArray(count).Layer).Goutput Then
    '    R = CircleArray(count).R
    '    X1 = CircleArray(count).X + R
    '    Y1 = CircleArray(count).Y
    '    X2 = CircleArray(count).X - R
    '    Y2 = CircleArray(count).Y
    '    Call AddNode(X1, Y1, X2, Y2, TCIRCLE, count) 'circle is treated as 2 arcs
    '   Call AddNode(X2, Y2, X1, Y1, TCIRCLE, count)
    ' End If
    'Next
    'POLYLINES:
    For count = 0 To ArrTot_Polylines - 1
      If LayerArray(PolylineArray(count).Layer).Goutput Then
        If (Not PolylineArray(count).closed) Then
          Call AddNode(VertexArray(PolylineArray(count).Vertex1).x, _
                       VertexArray(PolylineArray(count).Vertex1).y, _
                       TPOLYLINE, 0, 0, count, Tnotmatched)
          Call AddNode(VertexArray(PolylineArray(count).Vertex2).x, _
                       VertexArray(PolylineArray(count).Vertex2).y, _
                       TPOLYLINE, 0, 0, count, Tnotmatched)
        Else
          Call AddNode(VertexArray(PolylineArray(count).Vertex1).x, _
                       VertexArray(PolylineArray(count).Vertex1).y, _
                       TPOLYLINE, 0, 0, count, Tnotmatched)
         Call AddNode(VertexArray(PolylineArray(count).Vertex1).x, _
                       VertexArray(PolylineArray(count).Vertex1).y, _
                       TPOLYLINE, 0, 0, count, Tnotmatched)
        End If
      End If
    Next
    'Face3D or SOLID:
    For count = 0 To ArrTot_3DFaces - 1
      If LayerArray(Face3DArray(count).Layer).Goutput Then
        For I = 0 To Face3DArray(count).Vertexes
          'Avoid and eliminate double lines!
          H = I + 1: If H > Face3DArray(count).Vertexes Then H = 0
          If Not SearchFace3D(count, Face3DArray(count).x(I), Face3DArray(count).y(I), Face3DArray(count).x(H), Face3DArray(count).y(H)) Then
            Call AddNode(Face3DArray(count).x(I), Face3DArray(count).y(I), T3DFACE, 0, 0, count, Tnotmatched)
            Call AddNode(Face3DArray(count).x(H), Face3DArray(count).y(H), T3DFACE, 0, 0, count, Tnotmatched)
          End If
        Next
      End If
    Next

End Sub

Function SearchFace3D(N As Long, X0 As Long, Y0 As Long, X1 As Long, Y1 As Long) As Boolean
  Dim I As Long, J As Long, H As Long
  
  For J = 0 To ArrTot_3DFaces - 1
    If N <> J Then
      For I = 0 To Face3DArray(J).Vertexes
        H = I + 1: If H > Face3DArray(J).Vertexes Then H = 0
        If (((Face3DArray(J).x(I) = X0) And (Face3DArray(J).y(I) = Y0) And _
             (Face3DArray(J).x(H) = X1) And (Face3DArray(J).y(H) = Y1)) Or _
             ((Face3DArray(J).x(I) = X1) And (Face3DArray(J).y(I) = Y1) And _
             (Face3DArray(J).x(H) = X0) And (Face3DArray(J).y(H)))) Then
          SearchFace3D = True
          Exit Function
        End If
      Next
    End If
  Next
  SearchFace3D = False
End Function

Public Function Order_Path_Nodes() As Long
  Dim I As Long, AllMatched As Boolean
  Dim TotN As Long, LeftN As Long
  
  ArrTot_PathLines = 0
  LeftN = ArrTot_PathNodes / 2 - 1 'all entities (1 entite has 2 nodes)
  Do
    AllMatched = True
    For I = 0 To ArrTot_PathNodes - 1
      If PathNodeArray(I).Match = Tnotmatched Then
        AllMatched = False
        TotN = Search_Line_Path_Nodes(I, ArrTot_PathLines)
        LeftN = LeftN - TotN
        ArrTot_PathLines = ArrTot_PathLines + 1
        If ArrTot_PathLines >= UBound(PathLineArray) Then
          ReDim Preserve PathLineArray(0 To UBound(PathLineArray) + 1)
        End If
        Exit For
      End If
    Next
  Loop Until AllMatched
  
  'If ArrTot_PathLines > 1 Then
  '  MsgBox "All " & ArrTot_PathNodes / 2 & " entities matched in " & ArrTot_PathLines & " lines"
  '  'check for possibilities of merging path lines
  '  MsgBox Try_merging_Line_Paths & " merged together"
  'Else
  '   MsgBox "All " & ArrTot_PathNodes / 2 & " entities matched in one single line"
  'End If
  Order_Path_Nodes = TotN

 End Function
 
Public Function Try_merging_Line_Paths() As Long
  Dim C As Long
  Dim I As Long, J As Long, K As Long
  Dim X1 As Long, Y1 As Long, X2 As Long, Y2 As Long
  Dim MergedPaths As Long
     
     MergedPaths = 0
     For J = 0 To ArrTot_PathLines - 1
       If (Not PathLineArray(J).closed) And (PathLineArray(J).TotN > 0) Then
         ' - if line is not closed, search if the end points
         '   are on an other pat
         ' - if line is closed simpli skip...
         X1 = PathNodeArray(PathLineArray(J).FirstN).x
         Y1 = PathNodeArray(PathLineArray(J).FirstN).y
         X2 = PathNodeArray(PathLineArray(J).LastN).x
         Y2 = PathNodeArray(PathLineArray(J).LastN).y
         For I = 0 To ArrTot_PathLines - 1
           If (I <> J) And (PathLineArray(I).TotN > 0) Then
           'skip self and empty paths
             K = PathLineArray(I).FirstN
             Do
               If Match_XY(X1, Y1, PathNodeArray(K).x, PathNodeArray(K).y) Then      'Matched FirstN
                 'found a matching node!
                 If PathLineArray(I).closed Then
                   'cut the closed line at the matching point
                   'and insert this line
                   PathLineArray(I).TotN = PathLineArray(I).TotN + PathLineArray(J).TotN
                   PathLineArray(I).LastN = PathNodeArray(K).Match
                   PathNodeArray(PathLineArray(I).LastN).Match = Tnotclosed
                   PathLineArray(I).closed = False  'The final line will be open!
                   PathNodeArray(PathLineArray(J).FirstN).Match = K
                   PathNodeArray(K).Match = PathLineArray(J).FirstN
                   PathLineArray(I).FirstN = PathLineArray(J).LastN
                   'empty obsolete line path
                   PathLineArray(J).FirstN = 0
                   PathLineArray(J).LastN = 0
                   PathLineArray(J).TotN = 0
                   PathLineArray(J).closed = False
                   '
                   MergedPaths = MergedPaths + 1
     Call Dump_Nodes("Try_merging_Line_Paths" & C & ".txt", C)
                   
                 Else
                   'if the matched point behaves to an already open lines
                   'it will be complicated:
                   'We have to cut and insert the path backwards and forwars..
                   '* to be efficient, search for the shorter path
                   '* The end node points to itself, so the path is recursed backwards
                   '* insert this path at the matching site
                   'cut the closed line at the matching point
                   '---changed trategy: the special path is signaled trough the tag
                   'and insert this line
                   PathLineArray(I).TotN = PathLineArray(I).TotN + PathLineArray(J).TotN
                   'close other line end to self to recurse back
                   PathNodeArray(PathLineArray(J).LastN).Match = PathLineArray(J).LastN
                   'point to matching node
                   PathNodeArray(PathLineArray(J).FirstN).Match = K
                   'signal extra line
                   PathNodeArray(K).Tag = PathLineArray(J).FirstN
                   PathNodeArray(PathNodeArray(K).Match).Tag = PathLineArray(J).FirstN
                   'empty obsolete line path
                   PathLineArray(J).FirstN = 0
                   PathLineArray(J).LastN = 0
                   PathLineArray(J).TotN = 0
                   PathLineArray(J).closed = False
                   '
                   MergedPaths = MergedPaths + 1
     Call Dump_Nodes("Try_merging_Line_Paths" & C & ".txt", C)
                   
                 End If
               ElseIf Match_XY(X2, Y2, PathNodeArray(K).x, PathNodeArray(K).y) Then
                 'found a matching node!
                 If PathLineArray(I).closed Then
                   'cut the closed line at the matching point
                   'and insert this line
                   PathLineArray(I).TotN = PathLineArray(I).TotN + PathLineArray(J).TotN
                   PathLineArray(I).LastN = PathNodeArray(K).Match
                   PathNodeArray(PathLineArray(I).LastN).Match = Tnotclosed
                   PathLineArray(I).closed = False  'The final line will be open!
                   PathNodeArray(PathLineArray(J).LastN).Match = K
                   PathNodeArray(K).Match = PathLineArray(J).LastN
                   PathLineArray(I).FirstN = PathLineArray(J).FirstN
                   'empty obsolete line path
                   PathLineArray(J).FirstN = 0
                   PathLineArray(J).LastN = 0
                   PathLineArray(J).TotN = 0
                   PathLineArray(J).closed = False
                   '
                   MergedPaths = MergedPaths + 1
     Call Dump_Nodes("Try_merging_Line_Paths" & C & ".txt", C)
                   
                 Else
                   'if the matched point behaves to an already open lines
                   'it will be complicated:
                   'We have to cut and insert the path backwards and forwars..
                   '* to be efficient, search for the shorter path
                   '* The end node points to itself, so the path is recursed backwards
                   '* insert this path at the matching site
                   'cut the closed line at the matching point
                   'and insert this line
                   PathLineArray(I).TotN = PathLineArray(I).TotN + PathLineArray(J).TotN
                   PathNodeArray(PathLineArray(J).FirstN).Match = PathLineArray(J).FirstN
                   PathNodeArray(PathLineArray(J).LastN).Match = K
                   PathNodeArray(K).Tag = PathLineArray(J).LastN
                   PathNodeArray(PathNodeArray(K).Match).Tag = PathLineArray(J).FirstN
                   'empty obsolete line path
                   PathLineArray(J).FirstN = 0
                   PathLineArray(J).LastN = 0
                   PathLineArray(J).TotN = 0
                   PathLineArray(J).closed = False
                   '
                   MergedPaths = MergedPaths + 1
     Call Dump_Nodes("Try_merging_Line_Paths" & C & ".txt", C)
                   
                 End If
               End If
               K = K Xor 1 'other end of segment
               If (K = PathLineArray(I).LastN) And (Not PathLineArray(I).closed) Then Exit Do
               K = PathNodeArray(K).Match 'matching segment
             Loop Until (K = PathLineArray(I).FirstN) Or (K < 0)
           End If
         Next I
       End If
     Next J

     Try_merging_Line_Paths = MergedPaths
End Function

Public Function Search_Line_Path_Nodes(StartN As Long, PathLine As Long) As Long
  Dim N As Long, x As Long, y As Long, I As Long

  'Begin with a casual node and search matching points in one
  'direction
  PathLineArray(PathLine).FirstN = StartN
  PathLineArray(PathLine).LastN = StartN Xor 1
  PathLineArray(PathLine).TotN = 0
  PathLineArray(PathLine).closed = False
  
  N = PathLineArray(PathLine).FirstN
  N = N Xor 1 'get other end of line
  Do
    N = N Xor 1 'get other end of line
    If PathNodeArray(N).Match = Tnotmatched Then
      x = PathNodeArray(N).x
      y = PathNodeArray(N).y
      PathLineArray(PathLine).FirstN = N
      N = Match_Path_Nodes_XY(x, y, N) '
      PathLineArray(PathLine).TotN = PathLineArray(PathLine).TotN + 1
    Else
      Exit Do
    End If
  Loop While N >= 0
  'LastN has no matching node -- could be beginning/end of line
  'this is a end of the line, try the other side to see if
  'entieties are left
  N = PathLineArray(PathLine).LastN
  If PathNodeArray(N).Match = Tnotmatched Then
    N = N Xor 1 'get other end of line
    Do
      N = N Xor 1 'get other end of line
      If PathNodeArray(N).Match = Tnotmatched Then
        x = PathNodeArray(N).x
        y = PathNodeArray(N).y
        PathLineArray(PathLine).LastN = N
        N = Match_Path_Nodes_XY(x, y, N) '
        PathLineArray(PathLine).TotN = PathLineArray(PathLine).TotN + 1
      Else
        Exit Do
      End If
    Loop While N >= 0
  End If
  If (PathNodeArray(PathLineArray(PathLine).LastN).Match = Tnotmatched) Then
    'open line or 1 segment
    'mark beginning and end point!
    PathNodeArray(PathLineArray(PathLine).LastN).Match = Tnotclosed
    PathNodeArray(PathLineArray(PathLine).FirstN).Match = Tnotclosed
  Else
    'this is a closed line
    PathLineArray(PathLine).closed = True
    PathLineArray(PathLine).TotN = PathLineArray(PathLine).TotN - 1
  End If
  Search_Line_Path_Nodes = PathLineArray(PathLine).TotN - 1
  Call Dump_Nodes("Search_Line_Path_Nodes.txt", StartN)
End Function

Public Function Match_Path_Nodes_XY(x As Long, y As Long, N As Long) As Long
  Dim I As Long

  For I = 0 To ArrTot_PathNodes - 1
    If (PathNodeArray(I).Match = Tnotmatched) And ((N Or 1) <> (I Or 1)) Then
      If Match_XY(PathNodeArray(I).x, PathNodeArray(I).y, x, y) Then
        PathNodeArray(I).Match = N
        PathNodeArray(N).Match = I
        Match_Path_Nodes_XY = I
        Exit Function
      End If
    End If
  Next I
  'No matching node found!
  Match_Path_Nodes_XY = -1
End Function

Public Sub Dump_Nodes(FileName As String, ByRef C As Long)
  Dim I As Long
  Open FileName For Output As #2
    Print #2, "I" & vbTab & "X" & vbTab & "Y" & vbTab & "T" & vbTab & "I" & vbTab & "J" & vbTab & "N" & vbTab & "Tag" & vbTab & "Match" & vbTab
    For I = 0 To ArrTot_PathNodes
      Print #2, I & vbTab & PathNodeArray(I).x & vbTab & _
                            PathNodeArray(I).y & vbTab & _
                            PathNodeArray(I).T & vbTab & _
                            PathNodeArray(I).I & vbTab & _
                            PathNodeArray(I).J & vbTab & _
                            PathNodeArray(I).N & vbTab & _
                            PathNodeArray(I).Tag & vbTab & _
                            PathNodeArray(I).Match
    Next
    Print #2, "I" & vbTab & "FirstN" & vbTab & "LastN" & vbTab & "TotN" & vbTab & "Closed"
    For I = 0 To ArrTot_PathLines
      Print #2, I & vbTab & PathLineArray(I).FirstN & vbTab & _
                            PathLineArray(I).LastN & vbTab & _
                            PathLineArray(I).TotN & vbTab & _
                            PathLineArray(I).closed
    Next
  Close #2
  C = C + 1
End Sub

Public Function Dump_OrderedPath_Nodes(ByVal FileName As String, PathLine As Long) As Long
  Dim I As Long, J As Long, LastI As Long
  Dim X1 As Long, Y1 As Long, X2 As Long, Y2 As Long
  Dim Ip As Long, Jp As Long, R As Long, A1 As Single, A2 As Single
  Dim Vertex As Long
  
  LineNumber = 0
  I = PathLineArray(PathLine).FirstN
  LastI = I
  Open FileName For Output As #2
    Print #2, LineNumberStr(LineNumber) & " G90; # absolute coordinates "
    Print #2, LineNumberStr(LineNumber) & " G71; # metric programming unit "
    'Set Start point!
    Call GCode_G00(PathNodeArray(I).x, _
                   PathNodeArray(I).y)
    'recurse path
    Do
      I = I Xor 1 'get other end of line/arc/...
      If (I >= 0) And (I <> PathLineArray(PathLine).FirstN) Then
        Select Case PathNodeArray(I).T
          Case TLINE, T3DFACE
            Call GCode_G01(PathNodeArray(I).x, _
                           PathNodeArray(I).y)
          Case TARC
            If (I And 1) = 0 Then
              Call GCode_G02(PathNodeArray(I).x, _
                             PathNodeArray(I).y, _
                             PathNodeArray(I).I, _
                             PathNodeArray(I).J)
            Else
              Call GCode_G03(PathNodeArray(I).x, _
                             PathNodeArray(I).y, _
                             PathNodeArray(I).I, _
                             PathNodeArray(I).J)
            End If
          Case TPOLYLINE
            If (I And 1) = 1 Then 'End
              For Vertex = PolylineArray(PathNodeArray(I).N).Vertex1 To PolylineArray(PathNodeArray(I).N).Vertex2 - 1
                If VertexArray(Vertex).B = 0 Then
                  Call GCode_G01(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y)
                Else
                  Call Bulge2IJ(VertexArray(Vertex).x, VertexArray(Vertex).y, _
                                VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, _
                                VertexArray(Vertex).B, Ip, Jp, R, A1, A2)
                  If VertexArray(Vertex).B > 0 Then
                    Call GCode_G03(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, Ip, Jp)
                  Else
                    Call GCode_G02(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, Ip, Jp)
                  End If
                End If
              Next
              If PolylineArray(PathNodeArray(I).N).closed Then
                If VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).B = 0 Then
                  Call GCode_G01(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y)
                Else
                  Call Bulge2IJ(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).y, _
                                VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, _
                                VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).B, Ip, Jp, R, A1, A2)
                  If VertexArray(Vertex).B > 0 Then
                    Call GCode_G03(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, Ip, Jp)
                  Else
                    Call GCode_G02(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, Ip, Jp)
                  End If
                End If
              End If
            Else
              For Vertex = PolylineArray(PathNodeArray(I).N).Vertex2 - 1 To PolylineArray(PathNodeArray(I).N).Vertex1 Step -1
                If VertexArray(Vertex).B = 0 Then
                  Call GCode_G01(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y)
                Else
                  Call Bulge2IJ(VertexArray(Vertex).x, VertexArray(Vertex).y, _
                                VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, _
                                VertexArray(Vertex).B, Ip, Jp, R, A1, A2)
                  If VertexArray(Vertex).B > 0 Then
                    Call GCode_G03(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, Ip, Jp)
                  Else
                    Call GCode_G02(VertexArray(Vertex + 1).x, VertexArray(Vertex + 1).y, Ip, Jp)
                  End If
                End If
              Next
              If PolylineArray(PathNodeArray(I).N).closed Then
                If VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).B = 0 Then
                  Call GCode_G01(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y)
                Else
                  Call Bulge2IJ(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).y, _
                                VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, _
                                VertexArray(PolylineArray(PathNodeArray(I).N).Vertex2).B, Ip, Jp, R, A1, A2)
                  If VertexArray(Vertex).B > 0 Then
                    Call GCode_G03(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, Ip, Jp)
                  Else
                    Call GCode_G02(VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).x, VertexArray(PolylineArray(PathNodeArray(I).N).Vertex1).y, Ip, Jp)
                  End If
                End If
              End If
            End If
        End Select
      End If
      If PathNodeArray(I).Tag = Tnotmatched Then
        LastI = I
        I = PathNodeArray(I).Match 'this line/arc/... is complete
                                   'get next matching element
      Else
        If (LastI Or 1) = (PathNodeArray(I).Tag Or 1) Then
          MsgBox "che cu"
          LastI = I
          I = PathNodeArray(I).Match 'this line/arc/... is complete
                                     'get next matching element
        Else
          I = PathNodeArray(I).Tag   'go to the re-entering special path!
        End If
      End If
    Loop Until (I < 0) Or (I = PathLineArray(PathLine).FirstN) Or (I = PathLineArray(PathLine).LastN)
    Print #2, LineNumberStr(LineNumber) & " M02; # program end "
  Close #2
  Dump_OrderedPath_Nodes = LineNumber
End Function

Public Sub Draw_Line_Path_Array(PathLine As Long, Color As Long)
  Dim I As Long, LastI As Long, J As Long
  Dim Vertex As Long
  
  If (PathLineArray(PathLine).FirstN = 0) And _
     (PathLineArray(PathLine).LastN = 0) And _
     (PathLineArray(PathLine).TotN = 0) Then Exit Sub 'void or merged polyline
  I = PathLineArray(PathLine).FirstN
  Main.Picture1.DrawWidth = 3
  LastI = I
    'recurse path
    Do
      I = I Xor 1 'get other end of line/arc/...
      If (I >= 0) And (I <> PathLineArray(PathLine).FirstN) Then
        Select Case PathNodeArray(I).T
          Case TLINE, T3DFACE
            Call Main.DrawLine2D(PathNodeArray(I).x, _
                                 PathNodeArray(I).y, _
                                 PathNodeArray(I Xor 1).x, _
                                 PathNodeArray(I Xor 1).y, _
                                 Color)

          Case TARC
            Call Main.DrawArc2D(ArcArray(PathNodeArray(I).N).x, _
                           ArcArray(PathNodeArray(I).N).y, _
                           ArcArray(PathNodeArray(I).N).R, _
                           ArcArray(PathNodeArray(I).N).A1, _
                           ArcArray(PathNodeArray(I).N).A2, _
                           Color)
          Case TPOLYLINE
            Call Main.DrawPolyLine2D(PolylineArray(PathNodeArray(I).N).Vertex1, PolylineArray(PathNodeArray(I).N).Vertex2, PathNodeArray(I).N)
         ' Case T3DFACE
         '   Call Main.DrawLine2D(Face3DArray(PathNodeArray(I).N).X(0), _
         '                   Face3DArray(PathNodeArray(I).N).Y(0), _
         '                   Face3DArray(PathNodeArray(I).N).X(1), _
         '                   Face3DArray(PathNodeArray(I).N).Y(1), _
         '                   Color)
         '   Call Main.DrawLine2D(Face3DArray(PathNodeArray(I).N).X(1), _
         '                   Face3DArray(PathNodeArray(I).N).Y(1), _
         '                   Face3DArray(PathNodeArray(I).N).X(2), _
         '                   Face3DArray(PathNodeArray(I).N).Y(2), _
         '                   Color)
         '   Call Main.DrawLine2D(Face3DArray(PathNodeArray(I).N).X(2), _
         '                   Face3DArray(PathNodeArray(I).N).Y(2), _
         '                   Face3DArray(PathNodeArray(I).N).X(3), _
         '                   Face3DArray(PathNodeArray(I).N).Y(3), _
         '                   Color)
         '   Call Main.DrawLine2D(Face3DArray(PathNodeArray(I).N).X(3), _
         '                   Face3DArray(PathNodeArray(I).N).Y(3), _
         '                   Face3DArray(PathNodeArray(I).N).X(0), _
         '                   Face3DArray(PathNodeArray(I).N).Y(0), _
         '                   Color)
        End Select
      End If
      If PathNodeArray(I).Tag = Tnotmatched Then
        LastI = I
        I = PathNodeArray(I).Match 'this line/arc/... is complete
                                   'get next matching element
      Else
        If (LastI Or 1) = (PathNodeArray(I).Tag Or 1) Then
          MsgBox "che cu"
          LastI = I
          I = PathNodeArray(I).Match 'this line/arc/... is complete
                                     'get next matching element
        Else
          I = PathNodeArray(I).Tag   'go to the re-entering special path!
        End If
      End If
    Loop Until (I < 0) Or (I = PathLineArray(PathLine).FirstN) Or (I = PathLineArray(PathLine).LastN)
    Main.Picture1.DrawWidth = 1
End Sub

Sub DrawPathNodes()
  
  Dim I As Long, LastI As Long, J As Long
  Dim Vertex As Long, Color As Long
  
  Color = vbRed
  
  Main.Picture1.DrawWidth = 3
  For I = 0 To ArrTot_PathNodes - 1
        Select Case PathNodeArray(I).T
          Case TLINE, T3DFACE
            Call Main.DrawLine2D(PathNodeArray(I).x, _
                                 PathNodeArray(I).y, _
                                 PathNodeArray(I Xor 1).x, _
                                 PathNodeArray(I Xor 1).y, _
                                 Color)

          Case TARC
            Call Main.DrawArc2D(ArcArray(PathNodeArray(I).N).x, _
                           ArcArray(PathNodeArray(I).N).y, _
                           ArcArray(PathNodeArray(I).N).R, _
                           ArcArray(PathNodeArray(I).N).A1, _
                           ArcArray(PathNodeArray(I).N).A2, _
                           Color)
          Case TPOLYLINE
            Call Main.DrawPolyLine2D(PolylineArray(PathNodeArray(I).N).Vertex1, PolylineArray(PathNodeArray(I).N).Vertex2, PathNodeArray(I).N)
        End Select
    Next
    Main.Picture1.DrawWidth = 1
    

End Sub


