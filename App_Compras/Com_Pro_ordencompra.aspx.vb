Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Pro_ordencompra
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

        sqlbr.Append("select id_almacen, rtrim(nombre) as nombre from tb_almacen where id_status = 1 order by nombre ")
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
    Public Shared Function producto(ByVal clave As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, a.descripcion as producto, b.descripcion as unidad, " & vbCrLf)
        sqlbr.Append("CAST(a.preciobase as numeric(12,2))  as precio" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad " & vbCrLf)
        'sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
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
    Public Shared Function productol(ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(a.preciobase as numeric(12,2))  as 'td' " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        'sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where tipo in(1,2) and id_status = 1 and a.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
        Dim mycommand As New SqlCommand("sp_ordencompra", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function datosproov(ByVal proveedor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select razonsocial, b.descripcion as credito, c.descripcion as banco, a.cuenta " & vbCrLf)
        sqlbr.Append("from tb_proveedor a left outer join tb_credito b on a.credito= b.id_credito " & vbCrLf)
        sqlbr.Append("Left outer join tb_banco c on a.id_banco = c.id_banco where id_proveedor = " & proveedor & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{razon:'" & dt.Rows(0)("razonsocial") & "', credito:'" & dt.Rows(0)("credito") & "', banco:'" & dt.Rows(0)("banco") & "', cuenta:'" & dt.Rows(0)("cuenta") & "'}"
        Else
            sql += "{razon:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function requisicion(ByVal idreq As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_empresa, a.id_proveedor, a.id_cliente, a.id_almacen, a.formapago, subtotal, iva, total, id_comprador," & vbCrLf)
        sqlbr.Append("b.nombre + ' ' + b.paterno + ' ' + rtrim(b.materno) as comprador, piva, mes, anio" & vbCrLf)
        sqlbr.Append("from tb_requisicion a inner join tb_empleado b on a.id_comprador = b.id_empleado where id_requisicion = " & idreq & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{empresa:'" & dt.Rows(0)("id_empresa") & "', proveedor:'" & dt.Rows(0)("id_proveedor") & "', cliente:'" & dt.Rows(0)("id_cliente") & "',"
            sql += " almacen:'" & dt.Rows(0)("id_almacen") & "', formapago:'" & dt.Rows(0)("formapago") & "', subtotal:'" & Format(dt.Rows(0)("subtotal"), "#0.00") & "',"
            sql += " iva:'" & Format(dt.Rows(0)("iva"), "#0.00") & "', total:'" & Format(dt.Rows(0)("total"), "#0.00") & "', idcomprador:'" & dt.Rows(0)("id_comprador") & "',"
            sql += " comprador:'" & dt.Rows(0)("comprador") & "', piva:'" & dt.Rows(0)("piva") & "', mes:'" & dt.Rows(0)("mes") & "', anio:'" & dt.Rows(0)("anio") & "'}"
        Else
            sql += "{empresa:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargadetalle(ByVal idreq As Integer, ByVal familia As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Qsuitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("id_linea as 'td'")
        sqlbr.Append("from(select a.clave, c.descripcion as producto, d.descripcion as unidad,  cantidad - solicitado as cantidad, precio, a.id_linea, e.tipo" & vbCrLf)
        sqlbr.Append("From tb_requisiciond a inner join tb_producto c on a.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_requisicion e on a.id_requisicion = e.id_requisicion" & vbCrLf)
        sqlbr.Append("where a.id_requisicion = " & idreq & " and (cantidad - solicitado) > 0" & vbCrLf)
        If familia <> 0 Then sqlbr.Append("and c.id_familia= " & familia & "" & vbCrLf)
        sqlbr.Append(") as tabla  for xml path('tr'), root('tbody')")
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
    Public Shared Function validareq(ByVal idreq As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        Dim reqcompleta As Integer = 0
        sqlbr.Append("select sum(cantidad -solicitado) as total from tb_requisiciond where id_requisicion = " & idreq & "")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            If dt.Rows(0)("total") = 0 Then
                sql = "Update tb_requisicion set id_status = 4 where id_requisicion =" & idreq & ";"
                'Dim myConnection As New SqlConnection((New Conexion).StrConexion)
                reqcompleta = 1
            Else
                sql = "Update tb_requisicion set id_status = 2 where id_requisicion =" & idreq & ";"
            End If
            Dim mycommand As New SqlCommand(sql, myConnection)
            myConnection.Open()
            mycommand.ExecuteNonQuery()
            myConnection.Close()
        End If

        Return reqcompleta

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function orden(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_orden, convert(varchar(12), a.falta, 103) as falta, a.id_empresa, a.id_proveedor, a.formapago, a.id_almacen, a.id_cliente, a.subtotal, a.iva, a.total, a.id_requisicion, inventario, a.observacion, b.descripcion as estatus, comprador, " & vbCrLf)
        sqlbr.Append("nombre + ' ' + paterno + ' ' + rtrim(materno) as nombrec, case when d.tipo is null then 0 else d.tipo end as tipo, a.piva," & vbCrLf)
        sqlbr.Append("subtotalp, flete, descuento, a.mes, a.anio" & vbCrLf)
        sqlbr.Append("from tb_ordencompra a inner join tb_statusc b on a.id_status = b.id_status" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado c on a.comprador = c.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_requisicion d on a.id_requisicion = d.id_requisicion" & vbCrLf)
        sqlbr.Append("where id_orden = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_orden") & "', id_empresa: '" & dt.Rows(0)("id_empresa") & "',  id_proveedor:'" & dt.Rows(0)("id_proveedor") & "', id_almacen:'" & dt.Rows(0)("id_almacen") & "', formapago:'" & dt.Rows(0)("formapago") & "',"
            sql += " id_cliente: '" & dt.Rows(0)("id_cliente") & "', falta:'" & dt.Rows(0)("falta") & "',  subtotal:'" & dt.Rows(0)("subtotal") & "', iva:'" & dt.Rows(0)("iva") & "', inventario:'" & dt.Rows(0)("inventario") & "',"
            sql += " total:'" & dt.Rows(0)("total") & "',observacion:'" & dt.Rows(0)("observacion") & "', estatus:'" & dt.Rows(0)("estatus") & "', idcomprador:'" & dt.Rows(0)("comprador") & "',"
            sql += " req:'" & dt.Rows(0)("id_requisicion") & "', comprador:'" & dt.Rows(0)("nombrec") & "', tipo:'" & dt.Rows(0)("tipo") & "', piva:'" & dt.Rows(0)("piva") & "',"
            sql += " subtotalp:'" & dt.Rows(0)("subtotalp") & "', flete:'" & dt.Rows(0)("flete") & "', descuento:'" & dt.Rows(0)("descuento") & "',"
            sql += " mes:'" & dt.Rows(0)("mes") & "', anio:'" & dt.Rows(0)("anio") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargadetalleoc(ByVal idorden As Integer) As String ', ByVal tiporeq As Integer
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Qsuitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from( select a.clave, c.descripcion as producto, d.descripcion as unidad,  cantidad, precio" & vbCrLf)
        sqlbr.Append("From tb_ordencomprad a inner join tb_producto c on a.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("where a.id_orden = " & idorden & ") as tabla  for xml path('tr'), root('tbody') " & vbCrLf)

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
    Public Shared Function comprador(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "'}"
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie

        usuario = Request.Cookies("Usuario")
        idrequisicion.Value = Request("idreq")
        idorden.Value = Request("folio")
        If Request("familia") <> "" Then
            idfamilia.Value = Request("familia")
        Else
            idfamilia.Value = 0
        End If

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
