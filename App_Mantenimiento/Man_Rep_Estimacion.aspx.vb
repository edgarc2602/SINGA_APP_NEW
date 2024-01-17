Imports System.Data
Imports System.Data.SqlClient
Partial Class App_Mantenimiento_Man_Rep_Estimacion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.id_cliente, a.nombre  from tb_cliente a inner join tb_cliente_lineanegocio b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("where a.id_status =1 and b.id_lineanegocio= 1 order by nombre")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_cliente") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function regiones(ByVal idcliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select distinct r.id_region, r.descripcion from tb_cliente_inmueble cli " & vbCrLf)
        sqlbr.Append("join tb_cliente_inmueble_region clir on clir.id_inmueble = cli.id_inmueble " & vbCrLf)
        sqlbr.Append("join tb_regionentrega r on r.id_region = clir.id_region " & vbCrLf)
        sqlbr.Append("where cli.id_cliente = " + idcliente.ToString())
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_region") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

End Class
