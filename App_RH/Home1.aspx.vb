Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class Home1
    Inherits System.Web.UI.Page

    Public listamenu As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function general() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select left(convert(varchar,cast(count(id_cliente) as money),1), len(convert(varchar,cast(count(id_cliente) as money),1))-3)  as clientes from tb_cliente where id_status = 1;" & vbCrLf)
        sqlbr.Append("select left(convert(varchar,cast(sum(importe) as money),1), len(convert(varchar,cast(sum(importe) as money),1))-3) as iguala from tb_cliente_inmueble_ig;" & vbCrLf)
        sqlbr.Append("select left(convert(varchar,cast(sum(cantidad) as money),1), len(convert(varchar,cast(sum(cantidad) as money),1))-3)  as empleados from tb_cliente_plantilla;")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{clientes: '" & dt.Tables(0).Rows(0)("clientes") & "',igualas:'" & dt.Tables(1).Rows(0)("iguala") & "',empleados:'" & dt.Tables(2).Rows(0)("empleados") & "'}" & vbCrLf

        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim cliente As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        cliente = Request.Cookies("cliente")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value

        End If
        If cliente IsNot Nothing Then
            ' idcliente1.Value = Request.Cookies("cliente").Value
            Response.Cookies("cliente").Expires = DateTime.Now
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
    End Sub
End Class
