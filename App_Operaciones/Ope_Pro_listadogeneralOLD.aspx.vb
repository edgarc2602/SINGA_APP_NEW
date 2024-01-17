Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Pro_listadogeneral
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
    Public Shared Function listados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal tipo As Integer, ByVal pagina As Integer, ByVal estado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        'pagina = 1

        sqlbr.Append("select id_inmueble as'td','', nombre as'td','', id_listado as'td','', tipo as 'td','', estatus as'td','', total as'td','', id_tipo as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select  ROW_NUMBER()Over(Order by a.nombre) As RowNum, a.id_inmueble, a.nombre, isnull(b.id_listado,0) as id_listado, isnull(d.descripcion,'') as tipo, case when b.id_status = 1 Then 'Alta' when b.id_status = 2 then  " & vbCrLf)
        sqlbr.Append("'Aprobado' when b.id_status = 3 then 'Despachado' when b.id_status = 4 then 'Entregado' when b.id_status = 5 then 'Cancelado' else 'No existe' end as estatus," & vbCrLf)
        sqlbr.Append("cast(isnull(SUM(c.cantidad * c.precio),0) as numeric(12,2)) as total, isnull(d.id_tipo,0) id_tipo" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a inner join tb_listadomaterial b on a.id_inmueble = b.id_inmueble and mes = " & mes & " and anio = " & anio & " and b.id_status <> 5" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald c on b.id_listado = c.id_listado left outer join tb_tipolistado d on b.tipo = d.id_tipo" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & " and a.id_status = 1 and materiales = 0" & vbCrLf)
        If tipo <> 0 Then sqlbr.Append("and b.tipo =" & tipo & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and a.id_estado =" & estado & "" & vbCrLf)
        sqlbr.Append("group by a.id_inmueble, a.nombre, a.presupuestol, a.presupuestoh, b.id_listado, b.id_status, d.descripcion, id_tipo")
        sqlbr.Append(") as result where RowNum BETWEEN ((" & pagina & " - 1) * 100 ) + (" & pagina & " - 1) And " & pagina & " * 100 order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function contarlistados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal estado As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT COUNT(*)/100 + 1 as Filas, COUNT(*) % 100 as Residuos FROM tb_listadomaterial a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where a.id_cliente = " & cliente & " and mes = " & mes & " and anio = " & anio & "")
        If estado <> 0 Then sqlbr.Append(" and b.id_estado = " & estado & "")
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
    Public Shared Function listadomes(ByVal inmueble As Integer, ByVal mes As Integer, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select isnull(b.id_listado,0) as id_listado, isnull(a.presupuestol,0) + isnull(a.presupuestoh,0) as presupuestol, isnull(sum(c.cantidad * c.precio),0) as usado, isnull(a.presupuestol - sum(c.cantidad * c.precio),0) as disp" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_listadomaterial b on a.id_inmueble = b.id_inmueble  and b.mes = " & mes & " and b.anio =" & anio & " and b.tipo = 1" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald c on b.id_listado = c.id_listado " & vbCrLf)
        sqlbr.Append("where a.id_inmueble = " & inmueble & " Group by b.id_listado, presupuestol, a.presupuestoh" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_listado") & "', ptto:'" & dt.Rows(0)("presupuestol") & "', usado:'" & dt.Rows(0)("usado") & "', disp:'" & dt.Rows(0)("disp") & "'}"
        Else
            sql += "{id:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadod(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', '' as 'td','', b.descripcion as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(a.cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type) ,''," & vbCrLf)
        sqlbr.Append("cast(a.precio as numeric(12,2)) as 'td','', cast(a.cantidad * a.precio as numeric(12,2)) as 'td','',")
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_listadomateriald a inner join tb_producto b on a.clave = b.clave " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad " & vbCrLf)
        sqlbr.Append("where id_listado = " & folio & " order by b.descripcion  for xml path('tr'), root('tbody')")

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
    Public Shared Function productol(ByVal desc As String, ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(case when d.precio is null then a.preciobase else d.precio end as numeric(12,2))  as 'td' " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where tipo = 1 and id_status = 1 and a.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
    Public Shared Function producto(ByVal clave As String, ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, a.descripcion as producto, b.descripcion as unidad, " & vbCrLf)
        sqlbr.Append("cast(case when d.precio is null then a.preciobase else d.precio end as numeric(12,2)) as precio" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad " & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where a.clave = '" & clave & "' and id_status = 1 and tipo = 1")


        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{clave:'" & dt.Rows(0)("clave") & "', producto:'" & dt.Rows(0)("producto") & "', unidad:'" & dt.Rows(0)("unidad") & "', precio:'" & dt.Rows(0)("precio") & "'}"
        Else
            sql += "{clave:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardalinea(ByVal folio As Integer, ByVal clave As String, ByVal cantidad As Double, ByVal precio As Double) As String

        Dim sql As String = "insert into tb_listadomateriald (id_listado, clave, cantidad, precio) values (" & folio & ",'" & clave & "'," & cantidad & "," & precio & ");"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminalinea(ByVal folio As Integer, ByVal clave As String) As String

        Dim sql As String = "delete from tb_listadomateriald where id_listado = " & folio & " and clave = '" & clave & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardadetalle(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_listadomateriald", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_listadomaterialg", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function enviacorreo(ByVal clienten As String, ByVal cliente As Integer, ByVal mes As String, ByVal usuario As String) As String

        Dim generacorreo As New correooper()
        generacorreo.confirmalistados(clienten, cliente, mes, usuario)

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estado(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct a.id_estado, b.descripcion from tb_cliente_inmueble a inner join tb_estado b on a.id_estado = b.id_estado" & vbCrLf)
        sqlbr.Append("where id_status = 1 and id_cliente = " & cliente & " order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id: '" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function presupuesto(ByVal cliente As String, ByVal tipo As Integer, ByVal mes As Integer, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select isnull(sum(importe),0) as ptto from tb_cliente_material where id_status =1 and id_cliente = " & cliente & " ")
        Select Case tipo
            Case 1, 3
                sqlbr.Append("and id_concepto in(1,2);")
            Case 4
                sqlbr.Append("and id_concepto=3;")
            Case 2
                sqlbr.Append("and id_concepto=0;")
        End Select
        sqlbr.Append("select isnull(SUM(cantidad * precio),0) as usado from tb_listadomateriald a inner join tb_listadomaterial b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("where b.id_cliente = " & cliente & " and mes =" & mes & "  and anio =" & anio & " AND B.id_status != 5")
        Select Case tipo
            Case 1, 3
                sqlbr.Append("and tipo in(1,3)")
            Case Else
                sqlbr.Append("and tipo =" & tipo & "")
        End Select
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{ptto: '" & dt.Tables(0).Rows(0)("ptto") & "', usado:'" & dt.Tables(1).Rows(0)("usado") & "'}"
        Else
            sql += "{ptto:0, usado:0}"
        End If
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
