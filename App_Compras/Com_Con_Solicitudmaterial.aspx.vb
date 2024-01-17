Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_Solicitudmaterial
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select c.id_cliente, c.nombre from tb_cliente c" & vbCrLf)
        sqlbr.Append("join tb_cliente_lineanegocio cl on cl.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where cl.id_lineanegocio = 1 and c.id_status = 1" & vbCrLf)
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
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empresa") & "'," & vbCrLf
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
    Public Shared Function contarsolicitud(ByVal fini As String, ByVal ffin As String, ByVal cli As Integer, ByVal est As Integer, ByVal folio As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_solicitudmaterial" & vbCrLf)
        sqlbr.Append("where id_servicio = 1 and id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and falta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If cli <> 0 Then sqlbr.Append("and id_cliente =" & cli & "")
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "")
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
    Public Shared Function solicitudes(ByVal fini As String, ByVal ffin As String, ByVal cli As Integer, ByVal est As Integer, ByVal pagina As Integer, ByVal folio As Integer, usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_solicitud as 'td','', falta as 'td','', cliente as 'td','', " & vbCrLf)
        'sqlbr.Append("select id_solicitud as 'td','', falta as 'td','', almacen as 'td','', cliente as 'td','', " & vbCrLf)
        sqlbr.Append("case when statussol = 1 then 'Alta' when statussol = 6 and statusreq = 1 then 'En requisición' when statussol = 6 and statusreq = 2 then 'Requisición autorizada' when statussol = 6 and statusreq = 3 then 'Requisición rechazada' when statussol = 6 and statusreq = 4 then 'Requisición completa' when statussol = 6 and statusreq = 5 then 'Requisición despachada' end as 'td', ''," & vbCrLf)
        sqlbr.Append("case when requisicion <> 0 then convert(varchar(5), requisicion) when requisicion = 0 then '---' end as 'td', ''," & vbCrLf)

        sqlbr.Append("solicita as 'td','', cast(total as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btimprime' as '@class', 'Imprimir' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when statussol = 1 then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),type) end as 'td', ''" & vbCrLf)


        If usuario = 131 Or usuario = 1 Or usuario = 20445 Then
            sqlbr.Append(", case when statussol =1 then " & vbCrLf)
            sqlbr.Append("(select id_solicitud as '@id_sol', 'checkbox' as '@type' for xml path('input'),type)" & vbCrLf)
            sqlbr.Append("end as 'td'" & vbCrLf)
        End If

        sqlbr.Append("from ( Select  ROW_NUMBER() over (order by a.id_solicitud desc) as rownum, id_solicitud, d.nombre as cliente, b.nombre as almacen, a.id_requisicion as requisicion," & vbCrLf)
        sqlbr.Append(" convert(varchar(12), a.falta,103) as falta , a.solicita, a.id_status statussol, e.id_status statusreq, a.id_almacen, a.id_cliente, " & vbCrLf)
        sqlbr.Append("(select sum(cantidad * precio) from tb_solicitudmateriald where id_solicitud = a.id_solicitud) as total" & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterial a inner join tb_almacen b on a.id_almacen = b.id_almacen" & vbCrLf)
        sqlbr.Append("inner join tb_cliente d on a.id_cliente = d.id_cliente left join tb_requisicion e on a.id_requisicion = e.id_requisicion" & vbCrLf)
        sqlbr.Append("where a.id_servicio = 1 and a.id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and a.falta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If cli <> 0 Then sqlbr.Append("and a.id_cliente =" & cli & "")
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "")
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by id_solicitud desc for xml path('tr'), root('tbody')")
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
    Public Shared Function detalles(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder


        sqlbr.Append("select a.clave as 'td','', d.descripcion as 'td','', e.descripcion as 'td','', cast(a.cantidad as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(c.costopromedio as numeric(12,2)) as 'td','', cast(c.existencia as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right txcant' as '@class', cast(a.cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_solicitudmateriald a inner join tb_solicitudmaterial b on a.id_solicitud = b.id_solicitud" & vbCrLf)
        sqlbr.Append("inner join tb_inventario c on a.clave = c.clave and b.id_almacen = c.id_almacen" & vbCrLf)
        sqlbr.Append("inner join tb_producto d on a.clave = d.clave inner join tb_unidadmedida e on d.id_unidad = e.id_unidad " & vbCrLf)
        sqlbr.Append("where a.id_solicitud = " & folio & " for xml path('tr'), root('tbody')")
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
    Public Shared Function autoriza(ByVal sol As Integer, ByVal status As Integer) As String

        Dim sql As String = "Update tb_solicitudmaterial set id_status = " & status & " where id_solicitud =" & sol & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function crearequisicion(strsolicitudes As String, empresa As Integer, tipo As Integer, proveedor As Integer, año As String, mes As String, cliente As Integer,
                                           pago As Integer, iva As Decimal, usuario As Integer, from As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String
        sqlbr.Append("select * from (	" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by b.clave) as rownum, b.clave, c.descripcion as producto, d.descripcion as unidad, sum(cantidad) as cantidad, " & vbCrLf)
        sqlbr.Append("case when f.precio  is null  then c.preciobase else f.precio end as precio," & vbCrLf)
        sqlbr.Append("case when f.precio  is null  then c.preciobase * sum(cantidad) else f.precio * sum(cantidad) end as costo" & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterial a inner join tb_solicitudmateriald b on a.id_solicitud = b.id_solicitud " & vbCrLf)
        sqlbr.Append("inner join tb_producto c on b.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio f on b.clave = f.clave and f.id_proveedor = e.id_proveedor" & vbCrLf)
        sqlbr.Append("where a.id_solicitud in(" & strsolicitudes & ")" & vbCrLf)
        sqlbr.Append("group by b.clave,c.descripcion,d.descripcion, f.precio, c.preciobase) as tabla" & vbCrLf)

        Dim ds As New DataTable
        Dim comm As New SqlDataAdapter(sqlbr.ToString(), myConnection)
        comm.Fill(ds)

        Dim subtot As Double = 0

        sql = "<movimiento>"

        If ds.Rows.Count > 0 Then
            For x As Integer = 0 To ds.Rows.Count - 1
                sql += "<partida clave=""" & ds.Rows(x)("clave") & """ cantidad=""" & ds.Rows(x)("cantidad") & """ precio=""" & ds.Rows(x)("precio") & """ total=""" & ds.Rows(x)("costo") & """ />" & vbCrLf
                subtot += ds.Rows(x)("costo")
            Next
        End If

        Dim ivat As Double = subtot * iva

        Dim total As Double = subtot + ivat

        'Dim comprador As Integer = 0

        'If from = 2 Then
        '    cliente = 0
        'End If
        'If Not cliente = 0 Then
        '    'comprador = obtienecompradorporcliente(cliente)
        'End If

        sql += "<requisicion id=""0"" empresa=""" & empresa & """ proveedor=""" & proveedor & """ cliente=""" & cliente & """ almacen=""14"" forma=""" & pago & """ usuario=""" & usuario & """ observacion="""" "
        sql += "subtot=""" & subtot & """ iva=""" & ivat & """ total=""" & total & """ comprador=""" & 7223 & """ tipo=""" & tipo & """ inmueble=""0"" piva=""" & iva & """ mes=""" & mes & """ anio=""" & año & """ />"
        sql += "</movimiento>"

        Return guardareq(sql, 0, strsolicitudes, proveedor, cliente)


    End Function
    Public Shared Function obtienecompradorporcliente(cliente As Integer) As Integer
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select b.id_empleado, b.Nombre + ' ' + b.paterno  + ' ' + rtrim(b.materno) as nombre " & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_empleado b on a.id_comprador = b.id_empleado " & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & "")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = Convert.ToInt32(dt.Rows(0)("id_empleado"))
        End If
        Return sql
    End Function

    Public Shared Function guardareq(ByVal registro As String, ByVal folio As Integer, ByVal lista As String, ByVal pro As Integer, ByVal cli As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim aa As String = ""

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_requisicion", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            Dim com As String = "update tb_solicitudmaterial set id_requisicion = " + prmR.Value + ", id_status = 6 from tb_solicitudmaterial a inner join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble where a.id_solicitud in (" + lista + ")"
            mycommand = New SqlCommand(com, myConnection, trans)
            mycommand.CommandType = CommandType.Text
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_requisicionsolicitud", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@lista", lista)
            mycommand.Parameters.AddWithValue("@proveedor", pro)
            mycommand.Parameters.AddWithValue("@cliente", cli)
            mycommand.Parameters.AddWithValue("@req", prmR.Value)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        'Dim generacorreo As New correocompras()
        'generacorreo.requisicion(folio)

        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function catproveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, rtrim(nombre) as nombre  from tb_proveedor where id_status = 1 and id_lineanegocio = 1 order by nombre ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_proveedor") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
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
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            'myConnection.Open()
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

    <Web.Services.WebMethod()>
    Public Shared Function concentrado(ByVal proveedor As Integer, ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_solicitud as 'td','', solicita as 'td', '', '$ ' + convert(varchar(10),total) as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'checked' as '@checked', 'tbeditar' as '@class', id_solicitud as '@id_sol', 'checkbox' as '@type' for xml path('input'),type) as 'td',''" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("	select ROW_NUMBER() over (order by id_solicitud) as rownum, sum(costo) as total, id_solicitud, solicita from(" & vbCrLf)
        sqlbr.Append("		select sum(cantidad) * precio as costo, id_solicitud, solicita from (" & vbCrLf)
        sqlbr.Append("			select b.clave, c.descripcion as producto, d.descripcion as unidad, sum(cantidad) as cantidad, a.id_solicitud, a.solicita," & vbCrLf)
        sqlbr.Append("			case when f.precio  is null  then c.preciobase else f.precio end as precio" & vbCrLf)
        sqlbr.Append("			from tb_solicitudmaterial a inner join tb_solicitudmateriald b on a.id_solicitud = b.id_solicitud " & vbCrLf)
        sqlbr.Append("			inner join tb_producto c on b.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("			left outer join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("			left outer join tb_productoprecio f on b.clave = f.clave and f.id_proveedor = e.id_proveedor" & vbCrLf)
        sqlbr.Append("			where month(a.falta) = " & mes & " and year(a.falta) = " & anio & " and a.id_status = 1 and a.id_servicio = 1 and e.id_proveedor = " & proveedor & " and a.id_requisicion = 0" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        sqlbr.Append("			group by b.clave,c.descripcion,d.descripcion, f.precio, c.preciobase, a.solicita, a.id_solicitud" & vbCrLf)
        sqlbr.Append("		) as tabla group by id_solicitud, precio, solicita" & vbCrLf)
        sqlbr.Append("	) as tabla2 group by id_solicitud, solicita" & vbCrLf)
        sqlbr.Append(") as tabla3  order by id_solicitud for xml path('tr'), root('tbody') " & vbCrLf)


        ' where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50
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
