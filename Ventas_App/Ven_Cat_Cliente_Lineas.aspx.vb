Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class Ventas_App_Ven_Cat_Cliente_Lineas
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    'Agregar Monto
    <Web.Services.WebMethod()>
    Public Shared Function lineas(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_lineanegocio as 'td','', descripcion as 'td','', (select 'symbol1 icono1 tbeditar' as '@class', 'checkbox' as '@type'," & vbCrLf)
        sqlbr.Append("case when id_cliente = " & cliente & " then 'checked' end as '@checked' for xml path('input'), root('td'),type), " & vbCrLf)
        sqlbr.Append("(select case when monto = 0 then '0' else monto end as '@value', case when monto = 0 then 'txmonto input' else 'txmonto input' end as '@class', 'input' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select a.id_lineanegocio, descripcion, isnull(b.id_cliente,0) as id_cliente, b.monto as monto " & vbCrLf)
        sqlbr.Append("from tb_lineanegocio a left outer join tb_cliente_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio and b.id_cliente = " & cliente & ") As tabla order by descripcion " & vbCrLf)
        sqlbr.Append("for xml path('tr'), root('tbody') ")

        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_clientelinea", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        idcte.Value = Request("id")
        nombre.Value = Request("nombre")
        usuario = Request.Cookies("Usuario")


        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
