Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Almacen_Alm_Pro_Despacholistado
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_mes, descripcion from tb_mes order by id_mes")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_mes") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function almacen() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, rtrim(nombre) as nombre  from tb_almacen where id_status =1 and tipo = 1 and inventario = 0 order by id_almacen ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_almacen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarlistados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal tipo As Integer, ByVal folio As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_listadomaterial" & vbCrLf)
        sqlbr.Append("a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_proveedorinmueble c on b.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("where a.id_status in(2,4) and c.id_proveedor = 35 and mes = " & mes & " and anio = " & anio & "")
        If folio <> 0 Then sqlbr.Append(" and id_listado = " & folio & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append(" and a.id_cliente = " & cliente & "" & vbCrLf)
        If tipo <> 0 Then sqlbr.Append(" and a.tipo = " & tipo & "" & vbCrLf)
        Dim ds As New DataTable
        Dim myconnection As String = (New Conexion).StrConexion
        Dim comm As New SqlDataAdapter(sqlbr.ToString(), myconnection)
        comm.Fill(ds)
        sql = "["
        If ds.Rows.Count > 0 Then
            For x As Integer = 0 To ds.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{pag:" & ds.Rows(x)("Filas") & "}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal pagina As Integer, ByVal tipo As Integer, ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_cliente as 'td','', cliente as 'td','', id_inmueble as 'td','', sucursal as 'td','', id_listado as 'td','', tipo as 'td','', estatus as 'td','', falta as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Despachar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from ( select ROW_NUMBER()Over(Order by f.nombre, b.nombre) As RowNum, a.id_cliente, f.nombre as cliente, a.id_inmueble, b.nombre as sucursal, a.id_listado, d.descripcion as tipo, " & vbCrLf)
        sqlbr.Append("e.descripcion as estatus , CONVERT(varchar(12), a.falta,103) as falta" & vbCrLf)
        sqlbr.Append("from tb_listadomaterial a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_proveedorinmueble c on b.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_tipolistado d on a.tipo = d.id_tipo inner join tb_statusl e on a.id_status = e.id_status" & vbCrLf)
        sqlbr.Append("inner join tb_cliente f on a.id_cliente = f.id_cliente ")
        sqlbr.Append("where a.id_status in(2,4) and c.id_proveedor = 35 and anio = " & anio & " and mes =" & mes & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append(" and a.id_listado = " & folio & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append(" and a.id_cliente = " & cliente & "" & vbCrLf)
        If tipo <> 0 Then sqlbr.Append(" and a.tipo = " & tipo & "" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN ((" & pagina & " - 1) * 50) + (" & pagina & " - 1) And " & pagina & " * 50 order by sucursal for xml path('tr'), root('tbody')")

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
    Public Shared Function listadod(ByVal folio As Integer, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', b.descripcion as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("cast(a.cantidad as numeric(12,2)) as 'td' ,''," & vbCrLf)
        sqlbr.Append("cast(isnull(d.costopromedio,0) as numeric(12,2)) as 'td','', cast(isnull(d.existencia,0) as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast(case when isnull(d.existencia,0) > a.Cantidad then isnull(a.Cantidad,0) else isnull(d.existencia,0) end as numeric(12,2)) as 'td'")
        sqlbr.Append("from tb_listadomateriald a inner join tb_producto b on a.clave = b.clave " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_inventario d on a.clave = d.clave and d.id_almacen = " & almacen & "" & vbCrLf)
        sqlbr.Append("where id_listado = " & folio & " order by b.descripcion for xml path('tr'), root('tbody')")

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
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 8)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

        End Try
        myConnection.Close()

        Return folio

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
