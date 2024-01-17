Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Mantenimiento_Man_Pro_CargaOTInditex
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub

End Class
