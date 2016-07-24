Attribute VB_Name = "DXF_library"
Option Explicit


'********************************************************************
' Routine di esempio prese dalla documentazione DXF di AutoCad
'********************************************************************
' ReadDXF extracts specified code/value pairs from a DXF file.
' This function requires four string parameters, a valid DXF
' file name, a DXF section name, the name of an object in that
' section, and a comma delimited list of codes.
'
Function ReadDXF( _
  ByVal dxfFile As String, ByVal strSection As String, _
  ByVal strObject As String, ByVal strCodeList As String)

  Dim tmpCode, lastObj As String
  Dim Codes 'RK, non era definito, da controllare!!
  
  Open dxfFile For Input As #1
    ' Get the first code/value pair
    Codes = ReadCodes
    ' Loop through the whole file until the "EOF" line
    While Codes(1) <> "EOF"
      ' If the group code is '0' and the value is 'SECTION' ..
      If Codes(0) = "0" And Codes(1) = "SECTION" Then
        ' This must be a new section, so get the next
        ' code/value pair.
        Codes = ReadCodes()
        ' If this section is the right one ..
        If Codes(1) = strSection Then
          ' Get the next code/value pair and ..
          Codes = ReadCodes
          ' Loop through this section until the 'ENDSEC'
          While Codes(1) <> "ENDSEC"
            ' While in a section, all '0' codes indicate
            ' an object. If you find a '0' store the
            ' object name for future use.
            If Codes(0) = "0" Then lastObj = Codes(1)
            ' If this object is one you're interested in
            If lastObj = strObject Then
              ' Surround the code with commas
              tmpCode = "," & Codes(0) & ","
             ' If this code is in the list of codes ..
              If InStr(strCodeList, tmpCode) Then
                ' Append the return value.
                ReadDXF = ReadDXF & _
                 Codes(0) & "=" & Codes(1) & vbCrLf
              End If
            End If
            ' Read another code/value pair
            Codes = ReadCodes
          Wend
        End If
      Else
        Codes = ReadCodes
      End If
    Wend
  Close #1
End Function
' ReadCodes reads two lines from an open file and returns a two item
' array, a group code and its value. As long as a DXF file is read
' two lines at a time, all should be fine. However, to make your
' code more reliable, you should add some additional error and
' other checking.
'
Function ReadCodes() As Variant

  Dim codeStr, valStr As String
  Line Input #1, codeStr
  If EOF(1) Then
    MsgBox "File Error: " & vbCr & vbLf & _
           " The file has to be in ASCII-format and the CR/LF" & vbCr & vbLf & _
           " must be used (windows, not unix text file)" & vbCr & vbLf & _
           " Check also for extra lines (maybe empty and at the end of the file)" & vbCr & vbLf & _
           " Sorry!"
  Else
    Line Input #1, valStr
  End If
  ' Trim the leading and trailing space from the code
  codeStr = Replace(codeStr, Chr(9), " ")
  valStr = Replace(valStr, Chr(9), " ")
  ReadCodes = Array(Trim(codeStr), Trim(valStr))
End Function


' WriteDXFPolygon creates a minimal DXF file that only contains
' the ENTITIES section. This subroutine requires five parameters,
' the DXF file name, the number of sides for the polygon, the X
' and Y coordinates for the bottom end of the right-most side
' (it starts in a vertical direction), and the length for each
' side. Note that because this only requests 2D points, it does
' not include the Z coordinates (codes 30 and 31). The lines are
' placed on the layer "Polygon."
'
Sub WriteDXFPolygon( _
    dxfFile As String, iSides As Integer, _
    dblX As Double, dblY As Double, dblLen As Double)
  
  Dim I As Integer
  Dim dblA1, dblA, dblPI, dblNX, dblNY As Double
  Open dxfFile For Output As #1
    Print #1, 0
    Print #1, "SECTION"
    Print #1, 2
    Print #1, "ENTITIES"
    dblPI = Atn(1) * 4
    dblA1 = (2 * dblPI) / iSides
    dblA = dblPI / 2
    For I = 1 To iSides
      Print #1, 0
      Print #1, "LINE"
      Print #1, 8
      Print #1, "Polygon"
      Print #1, 10
      Print #1, dblX
      Print #1, 20
      Print #1, dblY
      dblNX = dblLen * Cos(dblA) + dblX
      dblNY = dblLen * Sin(dblA) + dblY
      Print #1, 11
      Print #1, dblNX
      Print #1, 21
      Print #1, dblNY
      dblX = dblNX
      dblY = dblNY
      dblA = dblA + dblA1
    Next I
    Print #1, 0
    Print #1, "ENDSEC"
    Print #1, 0
    Print #1, "EOF"
  Close #1
End Sub


