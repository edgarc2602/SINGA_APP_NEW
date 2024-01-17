Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Solicitudrecurso
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre + '  ' + case when clase = 1 then '(NOMINAS)' ELSE '(PROVEEDORES)' End as nombre from tb_empresa where id_estatus = 1 and clase in(1,2) order by nombre")
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
    Public Shared Function proveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, nombre from tb_proveedor where id_status = 1 order by nombre")
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
    Public Shared Function area(ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select idarea, ar_nombre from Tbl_Area_Empresa where ar_estatus = 0" & vbCrLf)
        If tipo = 1 Then
            sqlbr.Append(" and autoriza = " & tipo & "" & vbCrLf)
        End If
        sqlbr.Append("order by ar_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idarea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("ar_nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tipo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_tipo, descripcion from tb_solicitudrecurso_tipo where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_tipo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function concepto() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_concepto, descripcion from tb_conceptosolicitud where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_concepto") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal id As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, a.nombre + ' ' + paterno + ' ' + materno as nombre, b.nombre as empresa, a.id_empresa as idemp from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa ")
        sqlbr.Append("where id_status =2 and id_empleado = " & id & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "', nombre: '" & dt.Rows(0)("nombre") & "'}" ', empresa: '" & dt.Rows(0)("empresa") & "', idemp: '" & dt.Rows(0)("idemp") & "'}"
        Else
            sql += "{id:''}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleadolista(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.nombre as 'td','', a.id_empresa as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa where id_status = 2" & vbCrLf)
        sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append("order by paterno, materno, a.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function jornallista(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_jornalero as 'td','', paterno + ' ' + materno + ' ' + nombre as 'td','', 'PRODUCTOS DE LIMPIEZA GIANHAU' as 'td','', 12 as 'td'" & vbCrLf)
        sqlbr.Append("from tb_jornalero  where id_status = 1" & vbCrLf)
        sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append("order by paterno, materno, nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function facturas(ByVal proveedor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_provision as 'td','', factura as 'td','', convert(varchar(19), ffactura, 103) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(total - Pago as numeric(12,2)) As 'td','', " & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(total - Pago as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbaplica' as '@class', 'checkbox' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_provision where id_proveedor = " & proveedor & " and total - Pago != 0 order by ffactura for xml path('tr'), root('tbody')")
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
    Public Shared Function detfacturas(ByVal sol As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_provision as 'td','', a.factura as 'td','', convert(char(11), b.ffactura,103) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(b.total - b.Pago as numeric(12,2)) As 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(monto as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbaplica' as '@class', 'checkbox' as '@type', 'checked' as '@checked' for xml path('input'),root('td'),type)" & vbCrLf)
        'sqlbr.Append("cast(monto as numeric(12,2)) as 'td','','' as 'td'" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecursof a inner join tb_provision b on a.id_provision = b.id_provision where id_solicitud = " & sol & "" & vbCrLf)
        sqlbr.Append("for xml path('tr'), root('tbody')")
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
    Public Shared Function detconcepto(ByVal sol As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("SELECT a.id_concepto as 'td','', b.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(monto as numeric(12,2)) as '@value' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecursoc a inner join tb_conceptosolicitud  b on a.id_concepto = b.id_concepto" & vbCrLf)
        sqlbr.Append("where a.id_solicitud = " & sol & " for xml path('tr'), root('tbody')")
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
    Public Shared Function guarda(ByVal registro As String, ByVal tipo As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim aa As String = "", folio As Integer = 0

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_solicitudrecurso", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@tipo", tipo)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value
            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        'If folio = 0 Then
        Dim generacorreo As New correofinanzas()
        generacorreo.solicitudrecurso(folio)
        'End If

        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargasol(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_solicitud, a.id_empresa, solicita, id_tipo, areaautoriza, a.formapago, a.id_empleado, id_proveedor, convert(varchar(12), falta, 103) as falta, " & vbCrLf)
        sqlbr.Append("subtotal, iva, total, concepto, piva, tipopago, b.nombre + ' ' + b.paterno + ' ' + rtrim(b.materno) as empleado, a.id_cliente, " & vbCrLf)
        sqlbr.Append("c.nombre + ' ' + c.paterno + ' ' + c.materno as jornalero, a.id_jornalero" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecurso a left outer join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_jornalero c on a.id_jornalero = c.id_jornalero" & vbCrLf)
        sqlbr.Append("where id_solicitud= " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_solicitud") & "', idempresa: '" & dt.Rows(0)("id_empresa") & "',  areas:'" & dt.Rows(0)("solicita") & "', tipo:'" & dt.Rows(0)("id_tipo") & "', areaa:'" & dt.Rows(0)("areaautoriza") & "',"
            sql += " formapago: '" & dt.Rows(0)("formapago") & "',"
            sql += " idempleado: '" & dt.Rows(0)("id_empleado") & "', idproveedor: '" & dt.Rows(0)("id_proveedor") & "', falta:'" & dt.Rows(0)("falta") & "',  subtotal:'" & Format(dt.Rows(0)("subtotal"), "#0.00") & "', iva:'" & Format(dt.Rows(0)("iva"), "#0.00") & "',"
            sql += " total:'" & Format(dt.Rows(0)("total"), "#0.00") & "',concepto:'" & dt.Rows(0)("concepto") & "',"
            sql += " piva:'" & dt.Rows(0)("piva") & "', tipopago:'" & dt.Rows(0)("tipopago") & "', empleado:'" & dt.Rows(0)("empleado") & "', cliente:'" & dt.Rows(0)("id_cliente") & "', "
            sql += " idjornalero: '" & dt.Rows(0)("id_jornalero") & "', jornalero:'" & dt.Rows(0)("jornalero") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 ")
        sqlbr.Append("order by nombre")
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


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        'Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idsol.Value = Request("folio")
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
