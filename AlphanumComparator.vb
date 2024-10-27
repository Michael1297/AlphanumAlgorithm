'Setup (form)
Public Class Form1

    Private Sub Form1_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        Dim arr As ArrayList = New ArrayList
        arr.Add("111")
        arr.Add("90")
        arr.Add("A55")
        arr.Add("X")
        arr.Add("Z")
        arr.Add("20C")
        arr.Add("5")

        arr.Sort(New AlphanumComparator)

        For Each s As String In arr
            Console.WriteLine(s)
        Next
    End Sub
End Class
'Class
Public Class AlphanumComparator
    Implements IComparer

    Public Function Compare(x As Object, y As Object) As Integer Implements System.Collections.IComparer.Compare

        'Validate inputs - Initialize variables
        Dim comparison1 As String = x
        If comparison1 = Nothing Then Return 0
        Dim comparison2 As String = y
        If comparison2 = Nothing Then Return 0
        Dim len1 As Integer = comparison1.Length
        Dim len2 As Integer = comparison2.Length
        Dim marker1 As Integer = 0
        Dim marker2 As Integer = 0

        'loop and compare strings
        While marker1 < len1 AndAlso marker2 < len2
            Dim char1 As Char = comparison1(marker1)
            Dim char2 As Char = comparison2(marker2)

            Dim space1(len1) As Char
            Dim loc1 As Integer = 0
            Dim space2(len2) As Char
            Dim loc2 As Integer = 0

            'Get digits from string1 for comparison
            Do
                space1(loc1) = char1
                loc1 += 1
                marker1 += 1

                If marker1 < len1 Then char1 = comparison1(marker1) Else Exit Do
            Loop While Char.IsDigit(char1) = Char.IsDigit(space1(0))

            'Get digits from string2 for comparison
            Do
                space2(loc2) = char2
                loc2 += 1
                marker2 += 1

                If marker2 < len2 Then char2 = comparison2(marker2) Else Exit Do
            Loop While Char.IsDigit(char2) = Char.IsDigit(space2(0))

            'convert to spaces strings
            Dim str1 = New String(space1)
            Dim str2 = New String(space2)

            'Parse strings to ints
            Dim result As Integer
            If Char.IsDigit(space1(0)) And Char.IsDigit(space2(0)) Then
                Dim num1 = Integer.Parse(str1)
                Dim num2 = Integer.Parse(str2)
                result = num1.CompareTo(num2)
            Else
                result = str1.CompareTo(str2)
            End If
            'Return result if not equal
            If Not result = 0 Then Return result
        End While
        'Compare lengths
        Return len1 - len2
    End Function
End Class
