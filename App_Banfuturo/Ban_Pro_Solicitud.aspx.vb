Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_Banfuturo_Ban_Pro_Solicitud
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal usuario As String, ByVal origen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select b.id_empleado, convert(varchar(10), fingreso, 103) fingreso, DATEDIFF(month, fingreso, GETDATE()) antiguedad, sueldo, " & vbCrLf)
        sqlbr.Append("b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, b.rfc, curp, fnacimiento, genero, civil," & vbCrLf)
        sqlbr.Append(" calle + ' ' + noext + ' ' + noint + ' ' + b.colonia + ' ' + b.cp + ' ' + b.municipio + ' ' + c.descripcion  as domicilio," & vbCrLf)
        sqlbr.Append(" b.tel1, b.tel2, d.descripcion as puesto, e.nombre as empresa, f.direccion + ' ' + f.colonia + ' ' + f.cp + ' ' + f.delegacionmunicipio + ' ' +  g.descripcion  as ubicacion " & vbCrLf)
        sqlbr.Append("from tb_empleado b " & vbCrLf)
        sqlbr.Append("left outer join tb_estado c on b.id_estado = c.id_estado inner join tb_puesto d on b.Id_Puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_empresa e on b.id_empresa = e.id_empresa inner join tb_cliente_inmueble f on b.id_inmueble = f.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_estado g on f.id_estado = g.id_estado " & vbCrLf)
        If origen = 1 Then
            sqlbr.Append("where a.idpersonal = " & usuario & "")
        Else
            sqlbr.Append("where b.id_empleado = " & usuario & "")
        End If

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{emp: '" & dt.Rows(0)("id_empleado") & "', fingreso:'" & dt.Rows(0)("fingreso") & "', antiguedad:'" & dt.Rows(0)("antiguedad") & "',"
            sql += " sueldo:'" & dt.Rows(0)("sueldo") & "', empleado:'" & dt.Rows(0)("empleado") & "',"
            sql += " rfc:'" & dt.Rows(0)("rfc") & "', curp:'" & dt.Rows(0)("curp") & "', fnac:'" & dt.Rows(0)("fnacimiento") & "',"
            sql += " genero:'" & dt.Rows(0)("genero") & "', civil:'" & dt.Rows(0)("civil") & "', domicilio:'" & dt.Rows(0)("domicilio") & "',"
            sql += " tel1:'" & dt.Rows(0)("tel1") & "', tel2:'" & dt.Rows(0)("tel2") & "', puesto:'" & dt.Rows(0)("puesto") & "',"
            sql += " empresa:'" & dt.Rows(0)("empresa") & "', ubicacion:'" & dt.Rows(0)("ubicacion") & "'}"
        Else
            sql += "{emp:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal usuario As Integer, ByVal autoriza As Integer, ByVal folio As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudprestamo", myConnection)
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
            Dim correodir As New correodir()
            correodir.solicitudprestamo(prmR.Value, usuario, autoriza)
        End If
        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function enviacodigo(ByVal req As Integer, xmlgraba As String) As String

        documentos(xmlgraba)

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_codigovalidacion", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@req", req)
        mycommand.Parameters.AddWithValue("@estatus", 2)
        Dim prm1 As New SqlParameter("@cv", "")
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Dim correocodigovalidacion As New correocodigovalidacion()
        correocodigovalidacion.codigoval(prm1.Value.ToString())


        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function validaliberar(ByVal req As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("select id_status from tb_solicitudprestamo where id_solicitud = @req", myConnection)
        mycommand.Parameters.AddWithValue("@req", req)
        myConnection.Open()
        Dim res As Integer = mycommand.ExecuteScalar()
        myConnection.Close()

        Return res.ToString()

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardac(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudprestamoc", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        'If idvacante <> 0 Then
        'Dim correodir As New correodir()
        'correodir.solicitudprestamo(prmR.Value, usuario, autoriza)
        'End If
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardac1(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudprestamoc1", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        'If idvacante <> 0 Then
        'Dim correodir As New correodir()
        'correodir.solicitudprestamo(prmR.Value, usuario, autoriza)
        'End If
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function solicitud(ByVal folio As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT id_empleado, convert(varchar(12), fecha, 103) as fecha, tel, cel, correo, jefe, monto, plazo, planpago, ref1nombre, ref1parentezco, ref1telcasa, ref1telcel," & vbCrLf)
        sqlbr.Append("ref2nombre, ref2parentezco, ref2telcasa, ref2telcel, ref3nombre, ref3parentezco , ref3telcasa, ref3telcel, " & vbCrLf)
        sqlbr.Append("tieneparentezco, espolitico, doctodom, doctoing, doctoide," & vbCrLf)
        sqlbr.Append("case when id_status =1 then 'Alta' when id_status =2 then 'Autorizado' when id_status =3 then 'Liberado' when id_status =4 then 'Rechazado' when id_status =5 then 'Pagado' end as estatus ")
        sqlbr.Append("from tb_solicitudprestamo where id_solicitud = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{emp: '" & dt.Rows(0)("id_empleado") & "', fecha:'" & dt.Rows(0)("fecha") & "', tel:'" & dt.Rows(0)("tel") & "',"
            sql += " cel:'" & dt.Rows(0)("cel") & "', jefe:'" & dt.Rows(0)("jefe") & "', correo:'" & dt.Rows(0)("correo") & "', "
            sql += " monto:'" & dt.Rows(0)("monto") & "', plazo:'" & dt.Rows(0)("plazo") & "', planpago:'" & dt.Rows(0)("planpago") & "',"
            sql += " ref1nombre:'" & dt.Rows(0)("ref1nombre") & "', ref1parentezco:'" & dt.Rows(0)("ref1parentezco") & "', ref1telcasa:'" & dt.Rows(0)("ref1telcasa") & "',"
            sql += " ref1telcel:'" & dt.Rows(0)("ref1telcel") & "', ref2nombre:'" & dt.Rows(0)("ref2nombre") & "', ref2parentezco:'" & dt.Rows(0)("ref2parentezco") & "',"
            sql += " ref2telcasa:'" & dt.Rows(0)("ref2telcasa") & "', ref2telcel:'" & dt.Rows(0)("ref2telcel") & "',"
            sql += " ref3nombre:'" & dt.Rows(0)("ref3nombre") & "', ref3parentezco:'" & dt.Rows(0)("ref3parentezco") & "',"
            sql += " ref3telcasa:'" & dt.Rows(0)("ref3telcasa") & "', ref3telcel:'" & dt.Rows(0)("ref3telcel") & "',"
            sql += " tieneparentezco:'" & dt.Rows(0)("tieneparentezco") & "', espolitico:'" & dt.Rows(0)("espolitico") & "',"
            sql += " doctodom:'" & dt.Rows(0)("doctodom") & "', doctoing:'" & dt.Rows(0)("doctoing") & "', doctoide:'" & dt.Rows(0)("doctoide") & "', estatus:'" & dt.Rows(0)("estatus") & "' }"
        Else
            sql += "{emp:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function periodo(ByVal tipo As Integer, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + descripcion as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonomina where anio = " & anio & "" & vbCrLf)
        If tipo = 2 Then
            sqlbr.Append(" and descripcion = 'Semanal'" & vbCrLf)
        Else
            sqlbr.Append(" and descripcion = 'Quincenal'" & vbCrLf)
        End If
        sqlbr.Append("order by id_periodo" & vbCrLf)

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_periodo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("periodo") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function autoriza() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select idpersonal, per_nombre+ ' ' + Per_Paterno + ' ' + Per_Materno as autoriza from personal where per_autoriza = 1 and per_status =0 and IdArea in(1,4) order by per_nombre, per_paterno, per_materno" & vbCrLf)

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("autoriza") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "' and anio = " & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ultimafecha(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal pagos As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim per As Integer = (periodo + pagos) - 1
        If per > 24 Then
            per = 24
        End If

        sqlbr.Append("select convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & per & " and descripcion = '" & tipo & "' and anio = " & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function amortizacion(ByVal per As Integer, ByVal anio As Integer, ByVal tipo As String, ByVal sol As Integer, ByVal plazo As Integer, ByVal plan As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim perf = 0
        Select Case plan
            Case 1
                perf = per + (plazo * 4) - 1
            Case 2
                perf = per + (plazo * 2) - 1
        End Select


        sqlbr.Append("select ROW_NUMBER() over (order by id_periodo) as 'td','', id_periodo as 'td','', convert(varchar(12),ffin,103) as 'td','', " & vbCrLf)
        sqlbr.Append("cast((monto) / (cast (plazo as float) * case when planpago = 1 then  4 when planpago = 2 then  2 end) as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast((monto) / (cast (plazo as float) * case when planpago = 1 then  4 when planpago = 2 then  2 end) * 0.3 as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast((monto) / (cast (plazo as float) * case when planpago = 1 then  4 when planpago = 2 then  2 end) * 1.3 as numeric(12,2)) as 'td'")
        sqlbr.Append("from tb_periodonomina a cross join tb_solicitudprestamo b " & vbCrLf)
        sqlbr.Append("where a.anio = " & anio & " and a.descripcion = '" & tipo & "' and a.id_periodo between " & per & " and " & perf & "  and b.id_solicitud = " & sol & "" & vbCrLf)
        sqlbr.Append("order by id_periodo for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function cargaamort(ByVal solicitud As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select nopago as 'td','', pago as 'td','', convert(varchar(12),fpago,103) as 'td','', cast(pagocapital as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(pagointeres as numeric(12,2)) As 'td','', cast(pagototal as numeric(12,2)) as 'td' " & vbCrLf)
        sqlbr.Append("from tb_solicitudprestamoa where id_solicitud = " & solicitud & " order by nopago for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function listaempleado(ByVal busca As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.descripcion as 'td','', c.nombre as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on a.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where a.id_status = 2 and CAST(id_empleado AS char)+paterno+materno+A.nombre like '%" & busca & "%'" & vbCrLf)
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
    Public Shared Function libera(ByVal solicitud As String) As String

        Dim sql As String = "Update tb_solicitudprestamo set id_status = 3 where id_solicitud =" & solicitud & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Dim correodir As New correodir()
        correodir.solicitudlibera(solicitud)

        Return ""

    End Function

    Public Shared Function documentos(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudprestamod", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        'If idvacante <> 0 Then
        'Dim correodir As New correodir()
        'correodir.solicitudprestamo(prmR.Value, usuario, autoriza)
        'End If
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

        idfolio.Value = Request("folio")
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
