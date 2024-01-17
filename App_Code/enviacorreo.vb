Imports MailKit.Net.Smtp
Imports MailKit.Security
Imports MimeKit

Public Class enviacorreo
    'Public Function envia(ByVal cuerpo As String, ByVal destino As String, ByVal folio As Integer) As String
    Public Function envia(ByVal cuerpo As String, ByVal destino As String, ByVal folio As String) As String

        Dim email = New MimeMessage()
        email.From.Add(MailboxAddress.Parse("adminsinga@grupobatia.com.mx"))
        'email.To.Add(MailboxAddress.Parse("ricardob@grupobatia.com.mx"))
        'email.Subject = "NOFITIFICACION DE SINGA, Solicitud de recursos No: " + folio.ToString
        email.Subject = folio
        email.Body = New TextPart("Html") With {.Text = cuerpo}

        Dim v_par As Array
        v_par = (destino).Split(";")
        For i As Integer = 0 To v_par.Length - 1
            If v_par(i) <> "" Then email.To.Add(MailboxAddress.Parse("" & v_par(i) & ""))
        Next

        Dim smtp = New SmtpClient()
        smtp.Connect("smtp.office365.com", 587, SecureSocketOptions.StartTls)
        smtp.Authenticate("adminsinga@grupobatia.com.mx", "Ad*Gb1001")
        smtp.Send(email)
        smtp.Disconnect(True)

        Return ""

    End Function
End Class
