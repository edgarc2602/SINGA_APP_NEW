
Imports System

Partial Class CerrarSesion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Session.Clear() ' Limpia todos los datos de la sesión
        Response.Redirect("Login.aspx")
    End Sub
End Class
