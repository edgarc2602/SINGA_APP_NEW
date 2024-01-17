Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Mantenimiento_Com_Pro_Requisicion

    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function catproveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, rtrim(nombre) as nombre  from tb_proveedor where id_status = 1 order by nombre ")
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
    Public Shared Function almacen() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, nombre as nombre from tb_almacen where id_status = 1 order by nombre ")
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
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 order by nombre")
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

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente & " order by nombre")
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
    Public Shared Function comprador(ByVal cliente As Integer, ByVal idc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select b.id_empleado, b.Nombre + ' ' + b.paterno  + ' ' + rtrim(b.materno) as nombre " & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_empleado b on a.id_comprador = b.id_empleado " & vbCrLf)

        If cliente <> 0 Then sqlbr.Append("where a.id_cliente = " & cliente & "")
        If idc <> 0 Then sqlbr.Append("where b.id_empleado = " & idc & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "', nombre:'" & dt.Rows(0)("nombre") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function area(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select idarea from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("idarea") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("Select a.clave As 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(a.preciobase as numeric(12,2))  as 'td' " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        'sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where id_status = 1 and a.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
    Public Shared Function productoind(ByVal clave As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, a.descripcion, b.descripcion as unidad, a.preciobase from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad ")
        sqlbr.Append("where id_status = 1 and a.clave = '" & clave & "'")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{clave: '" & dt.Rows(0)("clave") & "', descripcion: '" & dt.Rows(0)("descripcion") & "',"
            sql += " unidad: '" & dt.Rows(0)("unidad") & "', precio: '" & dt.Rows(0)("preciobase") & "'}"
        Else
            sql += "{clave:''}"
        End If
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
    Public Shared Function contarconcentrado(ByVal proveedor As Integer, ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos from(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by b.clave) as rownum, b.clave, c.descripcion as producto, d.descripcion as unidad, sum(cantidad) as cantidad, " & vbCrLf)
        sqlbr.Append("case when f.precio  is null  then c.preciobase else f.precio end as precio" & vbCrLf)
        sqlbr.Append("from tb_listadomaterial a inner join tb_listadomateriald b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("inner join tb_producto c on b.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio f on b.clave = f.clave and f.id_proveedor = e.id_proveedor" & vbCrLf)
        sqlbr.Append("where a.mes = " & mes & " and a.anio = " & anio & " and a.id_status !=5  and e.id_proveedor = " & proveedor & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        sqlbr.Append("group by b.clave,c.descripcion,d.descripcion, f.precio, c.preciobase) tabla ")
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
    Public Shared Function concentrado(ByVal proveedor As Integer, ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by b.clave) as rownum, b.clave, c.descripcion as producto, d.descripcion as unidad, sum(cantidad) as cantidad, " & vbCrLf)
        sqlbr.Append("case when f.precio  is null  then c.preciobase else f.precio end as precio" & vbCrLf)
        sqlbr.Append("from tb_listadomaterial a inner join tb_listadomateriald b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("inner join tb_producto c on b.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio f on b.clave = f.clave and f.id_proveedor = e.id_proveedor" & vbCrLf)
        sqlbr.Append("where a.mes = " & mes & " and a.anio = " & anio & " and a.id_status !=5  and e.id_proveedor = " & proveedor & " and a.id_requisicion = 0" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        sqlbr.Append("group by b.clave,c.descripcion,d.descripcion, f.precio, c.preciobase) as tabla  order by clave for xml path('tr'), root('tbody') " & vbCrLf)
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
    <Web.Services.WebMethod()>
    Public Shared Function correctivo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_clavecm, id_clavecm from tb_correctivo_mayor where id_status = 4")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_clavecm") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("id_clavecm") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function solicitudm(ByVal correctivo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_solicitud,id_solicitud from  tb_solicitudmaterialmantto where id_status = 1 and id_clave_cm =" & correctivo & " ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id: '" & dt.Rows(x)("id_solicitud") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("id_solicitud") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function estado(ByVal sucursal As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select isnull(b.descripcion,'') as estado from tb_cliente_inmueble a left outer join tb_estado b on a.id_estado = b.id_estado  where a.id_inmueble = " & sucursal & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estado: '" & dt.Rows(0)("estado") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function subtotal(ByVal idreq As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select sum(cantidad * precio) as subtotal from tb_requisiciond  where id_requisicion = " & idreq & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{subtotal: '" & dt.Rows(0)("subtotal") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualizalinea(ByVal cantidad As Decimal, ByVal precio As Decimal, ByVal clave As String, ByVal idreq As Integer) As String

        Dim sql As String = "Update tb_requisiciond set cantidad =" & cantidad & ", precio =" & precio & " where id_requisicion =" & idreq & " and clave ='" & clave & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal folio As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal pro As Integer, ByVal cli As Integer, ByVal conc As Integer, ByVal folion As Integer) As String

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

            If conc = 1 Then
                mycommand = New SqlCommand("sp_requisicionlistado", myConnection, trans)
                mycommand.CommandType = CommandType.StoredProcedure
                mycommand.Parameters.AddWithValue("@mes", mes)
                mycommand.Parameters.AddWithValue("@anio", anio)
                mycommand.Parameters.AddWithValue("@proveedor", pro)
                mycommand.Parameters.AddWithValue("@cliente", cli)
                mycommand.Parameters.AddWithValue("@req", prmR.Value)
                mycommand.ExecuteNonQuery()
            End If
            folio = prmR.Value

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        If folion = 0 Then
            Dim generacorreo As New correocompras()
            generacorreo.requisicion(folio)
        End If

        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaconcentrado(ByVal registro As String, ByVal folio As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_requisicionconcentrado", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        If folio = 0 Then
            'Dim generacorreo As New correocompras()
            'generacorreo.requisicion(prmR.Value)
        End If

        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargareq(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_requisicion, id_empresa, id_proveedor, id_cliente, id_almacen, formapago, convert(varchar(12), falta, 103) as falta, " & vbCrLf)
        sqlbr.Append("subtotal, iva, total, observacion, b.descripcion as estatus, tipo, id_comprador, id_inmueble, piva, mes, anio from tb_requisicion a inner join tb_statusc b on a.id_status = b.id_status where id_requisicion= " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_requisicion") & "', id_empresa: '" & dt.Rows(0)("id_empresa") & "',  id_proveedor:'" & dt.Rows(0)("id_proveedor") & "', id_almacen:'" & dt.Rows(0)("id_almacen") & "', formapago:'" & dt.Rows(0)("formapago") & "',"
            sql += " id_cliente: '" & dt.Rows(0)("id_cliente") & "', falta:'" & dt.Rows(0)("falta") & "',  subtotal:'" & Format(dt.Rows(0)("subtotal"), "#0.00") & "', iva:'" & Format(dt.Rows(0)("iva"), "#0.00") & "',"
            sql += " total:'" & Format(dt.Rows(0)("total"), "#0.00") & "',observacion:'" & dt.Rows(0)("observacion") & "', estatus:'" & dt.Rows(0)("estatus") & "', tipo:'" & dt.Rows(0)("tipo") & "', idcomprador:'" & dt.Rows(0)("id_comprador") & "',"
            sql += " idinmueble:'" & dt.Rows(0)("id_inmueble") & "', piva:'" & dt.Rows(0)("piva") & "' , mes:'" & dt.Rows(0)("mes") & "' , anio:'" & dt.Rows(0)("anio") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contardetalle(ByVal idreq As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos from tb_requisiciond where id_requisicion = " & idreq & "")
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
    Public Shared Function solicitudcm(ByVal cm As String, ByVal sol As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by b.clave) as rownum, b.clave, c.descripcion as producto, d.descripcion as unidad, b.cantidad as cantidad, c.preciobase as precio" & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterialmantto a inner join tb_solicitudmaterialdmantto  b on b.id_solicitud = a.id_solicitud" & vbCrLf)
        sqlbr.Append("inner join tb_producto c on c.clave = b.clave" & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida d on d.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("where a.id_clave_cm = '" & cm & "' and a.id_solicitud = '" & sol & "'" & vbCrLf)
        sqlbr.Append("group by b.clave,c.descripcion,d.descripcion, b.cantidad, c.preciobase) as tabla  order by clave for xml path('tr'), root('tbody') " & vbCrLf)
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
    Public Shared Function cargadetalle(ByVal idreq As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Qsuitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from( select ROW_NUMBER() over (order by c.descripcion) as rownum, a.clave, c.descripcion as producto, d.descripcion as unidad,  cantidad, precio, e.tipo" & vbCrLf)
        sqlbr.Append("From tb_requisiciond a inner join tb_producto c on a.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_requisicion e on a.id_requisicion = e.id_requisicion" & vbCrLf)
        sqlbr.Append("where a.id_requisicion = " & idreq & ") as tabla  order by producto for xml path('tr'), root('tbody') " & vbCrLf)

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
        'Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idreq.Value = Request("folio")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            'userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
