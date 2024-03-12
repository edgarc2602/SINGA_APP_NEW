Imports MimeKit
Imports MailKit.Net.Smtp
Imports MailKit.Security

Public Class enviacorreo
    Public Function envia(ByVal cuerpo As String, ByVal destino As String, ByVal notificacion As String) As String


        Dim email = New MimeMessage()
        'email.From.Add(MailboxAddress.Parse("adminsinga@grupobatia.com.mx"))
        email.To.Add(MailboxAddress.Parse("fidelm@grupobatia.com.mx"))
        email.Subject = notificacion
        email.Body = New TextPart("Html") With {.Text = cuerpo}

        Dim v_par As Array
        v_par = (destino).Split(";")
        For i As Integer = 0 To v_par.Length - 1
            If v_par(i) <> "" Then email.To.Add(MailboxAddress.Parse("" & v_par(i) & ""))
        Next

        'Dim smtp = New SmtpClient()
        'smtp.Connect("smtp.office365.com", 587, SecureSocketOptions.StartTls)
        'smtp.Authenticate("adminsinga@grupobatia.com.mx", "Ad*Gb6584")
        'smtp.Send(email)
        'smtp.Disconnect(True)

        Return ""

    End Function
End Class
