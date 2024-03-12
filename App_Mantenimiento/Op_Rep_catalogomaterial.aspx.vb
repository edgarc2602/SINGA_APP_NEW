Imports System.Data
Imports System.Data.SqlClient
Partial Class App_Mantenimiento_Op_Rep_catalogomaterial
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function familia() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct a.id_familia, b.descripcion  " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_familia b on a.id_familia = b.id_familia" & vbCrLf)
        sqlbr.Append("where a.id_status = 1 and id_servicio = 1 order by b.descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_familia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

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
