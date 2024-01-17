Imports System.Data
Imports System.Data.SqlClient

Partial Class Login
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim selecciona As String = "SELECT per_usuario, per_password, idpersonal, per_interno, isnull(id_puesto,0) as id_puesto FROM personal where per_usuario = '" & txuser.Text & "' and per_password = '" & txpwd.Text & "' and per_status=0"
        Dim myCommand As New SqlDataAdapter(selecciona, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)

        'ASI TAMBIEN CORRIGUE EL SQL INJECTION IsDBNull
        If ds.Tables(0).Rows.Count = 0 Then
            Response.Write("<script>alert('El usuario o contraseña son incorrectos. Verifique!!');</script>")
        Else
            If ds.Tables(0).Rows.Count = 1 And ds.Tables(0).Rows(0)("per_usuario") = Trim(txuser.Text) And ds.Tables(0).Rows(0)("per_password") = Trim(txpwd.Text) Then
                'Session("v_usuario") = ds.Tables(0).Rows(0).Item("Idpersonal")
                FormsAuthentication.RedirectFromLoginPage(txpwd.Text, False)
                Dim CookieidUsuario As HttpCookie = New HttpCookie("Usuario")
                CookieidUsuario.Value = ds.Tables(0).Rows(0).Item("Idpersonal")
                CookieidUsuario.Expires = Now.AddDays(30)
                Response.Cookies.Add(CookieidUsuario)
                Dim Cookiecliente As HttpCookie = New HttpCookie("Cliente")
                Cookiecliente.Value = ds.Tables(0).Rows(0).Item("per_interno")
                Cookiecliente.Expires = Now.AddDays(30)
                Response.Cookies.Add(Cookiecliente)
                Dim Cookierecluta As HttpCookie = New HttpCookie("reclutador")
                Cookierecluta.Value = ds.Tables(0).Rows(0).Item("id_puesto")
                Cookierecluta.Expires = Now.AddDays(30)
                Response.Cookies.Add(Cookierecluta)
            Else
                'FormsAuthentication.RedirectFromLoginPage(TextBox2.Text, False)
                Response.Write("<script>alert('El Usuario o la Contraseña son incorrectos Verifique');</script>")
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txuser.Focus()
    End Sub
End Class
