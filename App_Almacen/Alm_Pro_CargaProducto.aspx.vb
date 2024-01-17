

Imports System.Data
    Imports System.Data.SqlClient
    Imports System.Xml
Partial Class App_Almacen_Alm_Pro_CargaProducto
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function almacen(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_orden  as 'td','', id_requisicion as 'td','',estatus as 'td','',total as 'td','', almacen as 'td','', cliente as 'td','' " & vbCrLf)
        sqlbr.Append("from(" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by a.id_orden) As RowNum,a.id_orden, a.id_requisicion,c.descripcion as estatus, cast(a.total as numeric (12,2)) as total, " & vbCrLf)
        sqlbr.Append("d.nombre as cliente, b.nombre as almacen " & vbCrLf)
        sqlbr.Append("from tb_ordencompra as a INNER JOIN tb_almacen as b ON a.id_almacen=b.id_almacen" & vbCrLf)
        sqlbr.Append("inner join tb_cliente d on a.id_cliente = d.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_statusc c on a.id_status = c.id_status WHERE a.id_status =4 " & vbCrLf)
        sqlbr.Append(") result where RowNum BETWEEN (1 - 1) * 50 + 1 And 1 * 50  For xml path('tr'), root('tbody')" & vbCrLf)


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
    Public Shared Function detalleoc(ByVal orden As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select clave as 'td','',producto as 'td','',unidad as 'td','',cantidad as 'td','',total as 'td',''" & vbCrLf)
        sqlbr.Append("from(" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by a.id_orden) As RowNum, a.id_orden, b.clave, d.descripcion as producto ,c.descripcion  as unidad,cast(b.cantidad as numeric (12,0)) as cantidad, cast(b.total as numeric (12,2)) as total" & vbCrLf)
        sqlbr.Append("from tb_ordencompra as a INNER JOIN tb_ordencomprad as b ON a.id_orden =b.id_orden" & vbCrLf)
        sqlbr.Append("inner join tb_producto d on b.clave = d.clave" & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on d.id_unidad  = c.id_unidad where a.id_orden = " & orden & " " & vbCrLf)
        sqlbr.Append(") result where RowNum BETWEEN (1 - 1) * 50 + 1 And 1 * 50  For xml path('tr'), root('tbody')" & vbCrLf)


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
    Public Shared Function productol(ByVal tipo As String, ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(a.preciobase as numeric(12,2)) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on b.id_unidad = a.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_familia c on c.id_familia = a.id_familia" & vbCrLf)
        sqlbr.Append("where c.tipo = '" & tipo & "' and a.descripcion Like '%" & desc & "%' and a.id_servicio = 1 for xml path('tr'), root('tbody')")

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
        Dim mycommand As New SqlCommand("sp_producto", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value

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

