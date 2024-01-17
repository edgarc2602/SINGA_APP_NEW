Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_listadogeneral
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
    Public Shared Function operador() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select idpersonal, per_nombre + ' ' + per_paterno + ' ' + per_materno as nombre from personal where idarea =14 and per_status =0 order by nombre ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
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
    Public Shared Function ptto(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select cast(isnull(sum(importe),0) as numeric(12,2)) as ptto from tb_cliente_material where id_status = 1 and id_cliente = " & cliente & " ")
        Select Case tipo
            Case 1, 3
                sqlbr.Append("and id_concepto in(1,2);")
            Case 4
                sqlbr.Append("and id_concepto=3;")
            Case 2
                sqlbr.Append("and id_concepto=0;")
        End Select
        sqlbr.Append("select cast(isnull(SUM(cantidad * precio),0) as numeric(12,2)) as usado from tb_listadomateriald a inner join tb_listadomaterial b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("where b.id_cliente = " & cliente & " and mes =" & mes & "  and anio =" & anio & " AND B.id_status != 5")
        Select Case tipo
            Case 0
                sqlbr.Append("and tipo !=2;")
            Case Else
                sqlbr.Append("and tipo =" & tipo & ";")
        End Select
        sqlbr.Append("select COUNT(id_inmueble) as totinm from tb_cliente_inmueble where id_cliente = " & cliente & " and id_status = 1;" & vbCrLf)
        sqlbr.Append("select ISNULL(COUNT(id_listado),0) as totlis from tb_listadomaterial where id_cliente = " & cliente & " and mes = " & mes & " and anio =" & anio & ";" & vbCrLf)

        'sqlbr.Append("select SUM(presupuestol) as totptto, COUNT(id_inmueble) as totinm from tb_cliente_inmueble where id_cliente = " & cliente & " and id_status = 1;" & vbCrLf)

        'sqlbr.Append("select ISNULL(SUM(cantidad * precio),0) as totuti from tb_listadomaterial a left outer join tb_listadomateriald b on a.id_listado = b.id_listado " & vbCrLf)
        'sqlbr.Append("where id_cliente = " & cliente & " and mes = " & mes & " and anio =" & anio & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        da.Fill(ds)
        'sql = "["
        If ds.Tables(0).Rows.Count > 0 Then
            'For x As Integer = 0 To dt.Rows.Count - 1
            'If x > 0 Then sql += ","
            sql = "{totptto: '" & ds.Tables(0).Rows(0)("ptto") & "',totinm: '" & ds.Tables(2).Rows(0)("totinm") & "',"
            sql += "totlis:'" & ds.Tables(3).Rows(0)("totlis") & "', totuti:'" & ds.Tables(1).Rows(0)("usado") & "'}"
            'Next
        End If
        'sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarlistados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal estado As Integer, ByVal busca As String, ByVal tipo As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_listadomaterial a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where a.id_cliente = " & cliente & " and mes = " & mes & " and anio = " & anio & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append(" and b.id_estado = " & estado & "" & vbCrLf)
        If busca <> "" Then sqlbr.Append(" and cast(a.id_listado as varchar)+b.nombre like '%" & busca & "%'" & vbCrLf)
        If tipo <> 0 Then sqlbr.Append(" and a.tipo = " & tipo & "")
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
    Public Shared Function listados(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal pagina As Integer, ByVal estado As Integer, ByVal busca As String, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_inmueble as'td','', nombre as'td','', id_listado as'td','', tipo as 'td','', estatus as'td','', falta as'td','', total as'td',''," & vbCrLf)
        sqlbr.Append("isnull(fentrega,'') as 'td','',")
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btacuse' as '@class', 'Acuse' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'', prefijo as 'td'" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select  ROW_NUMBER()Over(Order by a.nombre) As RowNum, a.id_inmueble, a.nombre, isnull(b.id_listado,0) as id_listado, isnull(d.descripcion,'') as tipo, case when b.id_status = 1 Then 'Alta' when b.id_status = 2 then  " & vbCrLf)
        sqlbr.Append("'Aprobado' when b.id_status = 3 then 'Despachado' when b.id_status = 4 then 'Entregado' when b.id_status = 5 then 'Cancelado' else 'No existe' end as estatus," & vbCrLf)
        sqlbr.Append("convert(varchar(12), falta, 103) as falta," & vbCrLf)
        sqlbr.Append("cast(isnull(SUM(c.cantidad * c.precio),0) as numeric(12,2)) as total, convert(varchar(12), fentrega, 103) as fentrega, a.prefijo" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_listadomaterial b on a.id_inmueble = b.id_inmueble and mes = " & mes & " and anio = " & anio & "" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald c on b.id_listado = c.id_listado left outer join tb_tipolistado d on b.tipo = d.id_tipo" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & " and a.id_status = 1 and a.materiales = 0" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and a.id_estado =" & estado & "" & vbCrLf)
        If busca <> "" Then sqlbr.Append(" and cast(b.id_listado as varchar)+nombre like '%" & busca & "%'" & vbCrLf)
        If tipo <> 0 Then sqlbr.Append(" and b.tipo = " & tipo & "" & vbCrLf)
        sqlbr.Append("group by a.id_inmueble, a.nombre, b.falta, b.id_listado, b.id_status, d.descripcion, fentrega, prefijo" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN ((" & pagina & " - 1) * 50) + (" & pagina & " - 1) And " & pagina & " * 50 order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function listadod(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', b.descripcion as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("cast(a.cantidad as numeric(12,2)) as 'td' ,''," & vbCrLf)
        sqlbr.Append("cast(a.precio as numeric(12,2)) as 'td','', cast(a.cantidad * a.precio as numeric(12,2)) as 'td'")
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
    Public Shared Function listadoa(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_listado as 'td','', carpeta as 'td','', archivo as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btquita' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From tb_listadomateriala where id_listado = " & folio & " for xml path('tr'), root('tbody')")

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
    Public Shared Function autoriza(ByVal cliente As String, ByVal mes As Integer, ByVal anio As Integer, ByVal estatus As Integer) As String

        Dim sql As String = "Update tb_listadomaterial set id_status = " & estatus & " where id_cliente =" & cliente & " and mes =" & mes & " and anio =" & anio & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualiza(ByVal folio As String, ByVal archivo As String) As String

        Dim fechaa As Date = Date.Now()

        Dim vmes As String = fechaa.Month.ToString
        If Len(vmes) = 1 Then
            vmes = "0" + vmes
        End If
        Dim vanio As String = fechaa.Year.ToString

        Dim vfolder = "F" + vanio + "_" + vmes

        'Dim vcarpeta As String = "c:\Doctos\entrega\"

        Dim sql As String = "insert into tb_listadomateriala (id_listado, carpeta, archivo) values (" & folio & ", '" & vfolder & "', '" & archivo & "');"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminaa(ByVal folio As Integer) As String

        'Dim fechaa As Date = Date.Now()

        'Dim vmes As String = fechaa.Month.ToString
        'If Len(vmes) = 1 Then
        ' vmes = "0" + vmes
        ' End If
        ' Dim vanio As String = fechaa.Year.ToString

        ' Dim vfolder = "F" + vanio + "_" + vmes

        'Dim vcarpeta As String = "c:\Doctos\entrega\"

        Dim sql As String = "delete from tb_listadomateriala where id_listado=" & folio & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cierra(ByVal operador As Integer, ByVal fecha As String, ByVal folio As String) As String

        Dim vfecini As Date
        If fecha <> "" Then vfecini = fecha

        Dim sql As String = "Update tb_listadomaterial set id_status = 4, usuarioentrega = " & operador & ", fentrega = '" & Format(vfecini, "yyyyMMdd") & "' where id_listado =" & folio & ";"

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
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
