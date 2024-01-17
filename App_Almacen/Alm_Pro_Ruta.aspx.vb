Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Almacen_Alm_Pro_Ruta
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal ruta As Integer, ByVal desc As String) As String

        Dim sql As String
        If ruta <> 0 Then
            sql = "update tb_ruta set descripcion = '" & desc & "' where id_ruta = " & ruta & ""
        Else
            sql = "insert into tb_ruta (descripcion) values('" & desc & "')"
        End If
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function agrega(ByVal ruta As Integer, ByVal inmueble As Integer) As String

        Dim sql As String
        sql = "insert into tb_ruta_inmueble  (id_ruta, id_inmueble) values(" & ruta & "," & inmueble & ")"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function rutas(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_ruta as 'td','', descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Sucursales' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by descripcion) As RowNum, id_ruta, descripcion " & vbCrLf)
        sqlbr.Append("from tb_ruta where id_status = 1" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by descripcion for xml path('tr'), root('tbody')")

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
    Public Shared Function inmuebles(ByVal ruta As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_inmueble as 'td','', c.nombre as 'td','', b.nombre as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)")
        sqlbr.Append("from tb_ruta_inmueble a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("where a.id_ruta = " & ruta & " order by c.nombre, b.nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct a.id_cliente, nombre from tb_cliente_lineanegocio a inner join tb_cliente b on a.id_cliente = b.id_cliente  where a.id_lineanegocio = 2 and  b.id_status = 1 order by nombre")
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
    Public Shared Function inmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_inmueble, nombre from tb_cliente_inmueble a" & vbCrLf)
        sqlbr.Append("join tb_proveedorinmueble pi on pi.id_inmueble = a.id_inmueble " & vbCrLf)
        sqlbr.Append("where id_status = 1 and materiales = 0 and id_cliente = " & cliente & " and not exists (select id_inmueble  " & vbCrLf)
        sqlbr.Append("from tb_ruta_inmueble b where a.id_inmueble = b.id_inmueble) order by nombre")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_inmueble") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminainmueble(ByVal ruta As Integer, ByVal inmueble As Integer) As String

        Dim sql As String = "delete from tb_ruta_inmueble where id_ruta = " & ruta & " and id_inmueble = '" & inmueble & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""
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
