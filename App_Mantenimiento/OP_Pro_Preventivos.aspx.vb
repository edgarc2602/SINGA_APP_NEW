
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Newtonsoft.Json

Partial Class App_Mantenimiento_OP_Pro_Preventivos
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim usuario As HttpCookie
        Dim userid As Integer

        'idfolio.Value = Request("folio")
        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = usuario.Value
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)

        hdfec.Value = Format(Today.Date(), "yyyyMMdd")
        fecha.Value = Format(Today.Date(), "MMMM yyyy").ToUpper()

    End Sub

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.id_cliente, a.nombre  from tb_cliente a inner join tb_cliente_lineanegocio b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("where a.id_status =1 and b.id_lineanegocio= 1 order by nombre")
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
    Public Shared Function region(ByVal cte As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_region, descripcion from tb_regionentrega" & vbCrLf)
        'sqlbr.Append("where id_cliente =" & cte & " order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_region") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tipos() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select id_servicio, descripcion From tb_tipomantenimiento where id_status = 1 and clase=0" & vbCrLf)
        sqlbr.Append("order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_servicio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tecnico() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' ' + paterno + ' ' + rtrim(materno) as empleado  from tb_empleado " & vbCrLf)
        sqlbr.Append("where id_status = 2 and id_area = 11 and id_puesto in (5,107) ")
        sqlbr.Append("order by empleado")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("empleado") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gtTipo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = "Select id_servicio, descripcion From tb_tipomantenimiento where id_status = 1 and clase=0"
        sql += "order by descripcion"

        Dim dt As New DataTable()

        Dim da As New SqlDataAdapter(sql, myConnection)
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = JsonConvert.SerializeObject(dt)
        Else
            sql = "[]"
        End If
        Return sql

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gtPeriodo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sql As String = "select Id_Periodo as id, rtrim(descripcion) as nm from tb_periodo "
        sql += "order by id;" & vbCrLf

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sql, myConnection)
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = JsonConvert.SerializeObject(dt)
        Else
            sql = "[]"
        End If
        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function gtProyecto2(ByVal id As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        'Dim dto() As String = bsq.Split("|")
        Dim sql As String = "select id_inmueble, nombre from tb_cliente_inmueble where id_status=1" & vbCrLf
        sql += "where id_cliente =" + id

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sql, myConnection)
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = JsonConvert.SerializeObject(dt)
        Else
            sql = "[]"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gtProyecto(ByVal id As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status=1" & vbCrLf)
        sqlbr.Append("and id_cliente =" & id)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id: '" & dt.Rows(x)("id_inmueble") & "'," & vbCrLf
                sql += "nm:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function svPrograma(ByVal prm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim cmd As New SqlCommand("sp_preventivo", myConnection)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.AddWithValue("@dta", prm)
        Dim prmR As SqlParameter
        prmR = New SqlParameter("@prg", 0)
        prmR.Direction = ParameterDirection.Output
        cmd.Parameters.Add(prmR)
        myConnection.Open()
        cmd.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscaprograma(ByVal cliente As String, ByVal tipo As Integer, ByVal coordina As Integer, ByVal region As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_programa from tb_programaestructura where id_cliente =" & cliente & " and id_servicio = " & tipo & "")
        sqlbr.Append(" and id_coordinador = " & coordina & " and id_region = " & region & " and id_status =1")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_programa") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gtEstructura(ByVal prm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim xdoc As New XmlDocument()
        xdoc.LoadXml(prm)

        Dim dt As DataTable
        Dim da As SqlDataAdapter
        Dim sql As String = ""

        If xdoc.DocumentElement().Attributes("prg").Value <> 0 Then
            sql = "declare @dta xml;" & vbCrLf
            sql += "Set @dta = '" & prm & "';" & vbCrLf & vbCrLf
            sql += "select a.id_programa, a.id_cliente, a.id_servicio, a.id_servicio, a.id_coordinador, b.descripcion" & vbCrLf
            sql += "from tb_ProgramaEstructura a" & vbCrLf
            sql += "inner join tb_tipomantenimiento b on a.id_servicio=b.id_servicio" & vbCrLf
            sql += "where a.id_programa = " & xdoc.DocumentElement().Attributes("prg").Value & " and a.id_status = 1;"

            dt = New DataTable()
            da = New SqlDataAdapter(sql, myConnection)
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{cmd: true, pro: " & dt.Rows(0)("id_cliente") & ", ser: " & dt.Rows(0)("id_servicio")
                sql += ", per: " & dt.Rows(0)("id_programa") & ", sup: " & dt.Rows(0)("id_coordinador") & ", tipo: '" & dt.Rows(0)("descripcion") & "'}"
            Else
                sql = "{cmd: false }"
            End If
        Else
            sql = "declare @dta xml;" & vbCrLf
            sql += "Set @dta = '" & prm & "';" & vbCrLf & vbCrLf
            sql += "select a.IdPrograma" & vbCrLf
            sql += "from tb_ProgramaEstructura a" & vbCrLf
            sql += "inner join @dta.nodes('Param') t(c) on a.IdPlaza = c.value('@pla', 'smallint') and a.IdSupervisor = c.value('@sup', 'int')" & vbCrLf
            sql += "and a.idCliente = c.value('@pro', 'int') and a.idServicio = c.value('@ser', 'smallint')" & vbCrLf
            sql += "and a.IdPeriodo = c.value('@per', 'smallint') and a.Id_Empresa = c.value('@emp', 'smallint')" & vbCrLf
            sql += "and a.Status = 0;"

            dt = New DataTable()
            da = New SqlDataAdapter(sql, myConnection)
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{cmd: true, prg: " & dt.Rows(0)("id_programa") & "}"
            Else
                sql = "{cmd: false}"
            End If
        End If
        Return sql
    End Function
    'aqui se obtienen los detalles de un programa
    <Web.Services.WebMethod()>
    Public Shared Function gtPreventivo(ByVal prm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim xdoc As New XmlDocument()
        xdoc.LoadXml(prm)

        Dim ds As DataSet
        Dim da As SqlDataAdapter
        Dim sql As String = ""

        sql = "Set language 'Spanish';" & vbCrLf
        sql += "declare @dta xml;" & vbCrLf
        sql += "declare @fec date, @pgn int, @pla int, @ser int, @sup int, @pro int;" & vbCrLf
        sql += "set @dta = '" & prm & "';" & vbCrLf & vbCrLf
        sql += "select @fec = convert(date, c.value('@fec', 'char(10)'), 103), @pgn = c.value('@pgn', 'int') "
        sql += ", @pro = c.value('@pro', 'int'), @ser = c.value('@ser', 'int') from @dta.nodes('Param') t(c);" & vbCrLf
        sql += "select @ser = a.id_Servicio, @sup = a.id_coordinador, @pro = a.id_Cliente " & vbCrLf
        sql += "From tb_programaestructura a " & vbCrLf
        sql += "inner join @dta.nodes('Param') t(c) on  a.id_programa = c.value('@prg', 'int');" & vbCrLf
        sql += "select dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec) As fec, datepart(dd, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) As dia" & vbCrLf
        sql += ", left(DATENAME(w, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)), 2) as nmdia" & vbCrLf
        sql += ", DATEDIFF(WEEK, DATEADD(MONTH, DATEDIFF(MONTH, 0, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)), 0), dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) + 1 AS NumSem" & vbCrLf
        sql += ", row_number() over(order by b.mul, a.id_mes) As ordo" & vbCrLf
        sql += "from tb_Mes a" & vbCrLf
        sql += "cross join (" & vbCrLf
        sql += "	select 0 as mul union all select 1 union all select 2" & vbCrLf
        sql += ") b" & vbCrLf
        sql += "cross join (" & vbCrLf
        sql += "	Select dateadd(dd, datepart(dd, @fec) * -1, @fec) As fec" & vbCrLf
        sql += ") c" & vbCrLf
        sql += "where month(dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) = month(@fec)" & vbCrLf
        sql += "and datename(dw, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) != 'Domingo'" & vbCrLf
        sql += "order by b.mul, a.Id_Mes;" & vbCrLf & vbCrLf
        sql += "select *, row_number() over(order by c.inm) as ordo" & vbCrLf
        sql += "from (" & vbCrLf
        sql += "	select a.Id_Inmueble as id, rtrim(b.nombre) as pro, rtrim(a.Nombre) as inm" & vbCrLf
        sql += "	, (row_number() over(order by a.nombre) - 1) / 100 As pgn" & vbCrLf
        sql += "	from tb_cliente_inmueble a" & vbCrLf
        sql += "	inner join tb_cliente b On a.id_cliente = b.id_cliente" & vbCrLf
        sql += "	where a.Id_Status = 1 and b.Id_Status = 1" & vbCrLf
        sql += "	and a.id_cliente = @pro" & vbCrLf
        sql += ") c" & vbCrLf
        sql += "where pgn = @pgn;" & vbCrLf & vbCrLf
        sql += "select b.id, b.inm, b.ordo as ren, c.ordo as col, count(a.Id_Orden) as num, max(a.Id_Orden) as numot" & vbCrLf
        sql += "from tb_OrdenTrabajo a" & vbCrLf
        sql += "inner join (" & vbCrLf
        sql += "	Select c.id, c.pro, c.inm, c.pgn, row_number() over(order by c.inm) As ordo" & vbCrLf
        sql += "	from (" & vbCrLf
        sql += "		Select a.Id_Inmueble As id, rtrim(b.nombre) As pro, rtrim(a.Nombre) As inm" & vbCrLf
        sql += "		, (row_number() over(order by a.nombre) - 1) / 100 as pgn" & vbCrLf
        sql += "		from tb_cliente_inmueble a" & vbCrLf
        sql += "		inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf
        sql += "		where a.Id_Status = 1 And b.Id_Status = 1" & vbCrLf
        sql += "	    and a.id_cliente = @pro" & vbCrLf
        sql += "	) c" & vbCrLf
        sql += "	where pgn = @pgn" & vbCrLf
        sql += ") b On a.Id_Inmueble = b.id" & vbCrLf
        sql += "inner join (" & vbCrLf
        sql += "	select dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec) As fec, datepart(dd, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) As dia" & vbCrLf
        sql += "	, DATENAME(dw, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) as nmdia" & vbCrLf
        sql += "	, row_number() over(order by b.mul, a.id_mes) As ordo" & vbCrLf
        sql += "	from tb_mes a" & vbCrLf
        sql += "	cross join (" & vbCrLf
        sql += "		select 0 as mul union all select 1 union all select 2" & vbCrLf
        sql += "	) b" & vbCrLf
        sql += "	cross join (" & vbCrLf
        sql += "		Select dateadd(dd, datepart(dd, @fec) * -1, @fec) As fec" & vbCrLf
        sql += "	) c" & vbCrLf
        sql += "	where month(dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) = month(@fec)" & vbCrLf
        sql += "	and datename(dw, dateadd(dd, (a.id_mes + (b.mul * 12)), c.fec)) != 'Domingo'" & vbCrLf
        sql += ") c On a.fregistro = c.fec" & vbCrLf
        sql += "where 1 = 1" & vbCrLf
        sql += "and a.Id_Servicio = @ser" & vbCrLf
        sql += "and a.id_coordinador = @sup" & vbCrLf
        sql += "and a.id_status in (1,2,3)" & vbCrLf
        sql += "group by b.id, b.inm, b.ordo, c.ordo;" & vbCrLf & vbCrLf

        sql += "select pgn, count(id) as cnt" & vbCrLf
        sql += "from (" & vbCrLf
        sql += "	select a.Id_Inmueble as id, rtrim(b.nombre) as pro, rtrim(a.Nombre) as inm" & vbCrLf
        sql += "	, (row_number() over(order by a.nombre) - 1) / 100 As pgn" & vbCrLf
        sql += "	from tb_cliente_inmueble a" & vbCrLf
        sql += "	inner join tb_cliente b On a.id_cliente = b.id_cliente" & vbCrLf
        sql += "	where a.Id_Status = 1 and b.Id_Status = 1" & vbCrLf
        sql += "	and a.id_cliente = @pro" & vbCrLf
        sql += ") b" & vbCrLf
        sql += "group by pgn" & vbCrLf
        sql += "order by pgn;"
        sql += "SELECT a.estructura FROM tb_programaestructura a WHERE a.id_programa IN"
        sql += "( SELECT c.value('@prg', 'int') AS id_programa FROM @dta.nodes('Param') t(c));"

        ds = New DataSet()
        da = New SqlDataAdapter(sql, myConnection)
        da.Fill(ds)
        sql = "{ cmd: true, "
        If ds.Tables.Count > 0 Then
            sql += "dias:"
            If ds.Tables(0).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(0))
            Else
                sql += "[]"
            End If
            sql += ", sucs:"
            If ds.Tables(1).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(1))
            Else
                sql += "[]"
            End If
            sql += ", ots:"
            If ds.Tables(2).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(2))
            Else
                sql += "[]"
            End If
            sql += ", pgn:"
            If ds.Tables(3).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(3))
            Else
                sql += "[]"
            End If
            sql += ", estr:"
            If ds.Tables(4).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(4).Rows(0)(0))
            Else
                sql += "[]"
            End If
        End If
        sql += "}"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gnFecha(ByVal prm As String, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sql As String = "select dateadd(m, " & mes & ", '" & prm & "') as fecha, CONVERT(VARCHAR(25),DATEADD(dd,-(DAY( '" & prm & "' )-1), '" & prm & "' ),23) as ini, " & vbCrLf
        sql += " Convert(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,'" & prm & "'))),DATEADD(mm,1,'" & prm & "')),23) as fin" & vbCrLf
        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sql, myConnection)
        da.Fill(dt)
        sql = Format(dt.Rows(0)("fecha"), "yyyyMMdd") & "|" & Format(dt.Rows(0)("fecha"), "MMMM yyyy").ToUpper() & "|" & Format(dt.Rows(0).ItemArray(1)) & "|" & Format(dt.Rows(0).ItemArray(2))
        'sql += "{ini: " & ds.Tables(1).Rows(0)("ini") & ", fin: " & ds.Tables(2).Rows(0)("ultimo") & "}"
        Return sql
    End Function
    'este metodo genera las ordenes'
    <Web.Services.WebMethod()>
    Public Shared Function svOrdenes(ByVal prm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim cmd As New SqlCommand("[sp_generaot]", myConnection)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.AddWithValue("@dta", prm)
        myConnection.Open()
        cmd.ExecuteNonQuery()
        myConnection.Close()
        Return "{ cmd: true }"
    End Function
    'este metodo carga los programas
    <Web.Services.WebMethod()>
    Public Shared Function muestrapreventivos(ByVal pagina As Integer, ByVal campo As String, ByVal dato As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_programa as 'td','', nombre as 'td','', descripcion as 'td','', coordinador as 'td','' ")
        sqlbr.Append("from (  ")
        sqlbr.Append("select ROW_NUMBER() over (order by id_programa) as rownum,  id_programa, b.nombre, c.descripcion, d.nombre + ' ' + d.paterno + ' ' + rtrim(d.materno) as coordinador ")
        sqlbr.Append("  from tb_programaestructura a  inner join tb_cliente b on a.id_cliente=b.id_cliente ")
        sqlbr.Append("inner join tb_tipomantenimiento c on a.id_servicio=c.id_servicio inner join tb_empleado d on a.id_coordinador= d.id_empleado  ")
        If campo <> "0" Then
            sqlbr.Append("where " & campo & " like '%" & dato & "%'" & vbCrLf)
        End If
        sqlbr.Append(") as result" & vbCrLf)
        sqlbr.Append(" where RowNum BETWEEN (" & pagina & "  - 1) * 20 And " & pagina & " * 20 order by id_programa for xml path('tr'), root('tbody')")
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
    Public Shared Function contarpreventivos(ByVal campo As String, ByVal dato As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select COUNT(*)/20 + 1 as Filas, COUNT(*) % 20 as Residuos from tb_programaestructura a inner join tb_cliente b on a.id_cliente=b.id_cliente " & vbCrLf)
        sqlbr.Append(" inner join tb_tipomantenimiento c on a.id_servicio=c.id_servicio" & vbCrLf)
        If campo <> "0" Then
            sqlbr.Append("where " & campo & " like '%" & dato & "%'" & vbCrLf)
        End If
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
    Public Shared Function consultapreventivo(ByVal prm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        'Dim xdoc As New XmlDocument()
        'xdoc.LoadXml(prm)

        Dim dt As DataTable
        Dim da As SqlDataAdapter
        Dim sql As String = ""

        If prm <> 0 Then
            sql = "declare @dta xml;" & vbCrLf
            sql += "Set @dta = '" & prm & "';" & vbCrLf & vbCrLf
            sql += "select a.id_programa, a.id_cliente, a.id_servicio, a.id_servicio, a.id_coordinador, b.descripcion,CASE  WHEN a.estructura = 0 THEN 0 WHEN a.estructura = 1 THEN 1 END AS estructura" & vbCrLf
            sql += "from tb_ProgramaEstructura a" & vbCrLf
            sql += "inner join tb_tipomantenimiento b on a.id_servicio=b.id_servicio" & vbCrLf
            sql += "where a.id_programa = " & prm & " and a.id_status = 1;"

            dt = New DataTable()
            da = New SqlDataAdapter(sql, myConnection)
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{cmd: true, pro: " & dt.Rows(0)("id_cliente") & ", ser: " & dt.Rows(0)("id_servicio")
                sql += ", per: " & dt.Rows(0)("id_programa") & ", sup: " & dt.Rows(0)("id_coordinador") & ", tipo: '" & dt.Rows(0)("descripcion") & "', estr: '" & dt.Rows(0)("estructura") & "'}"
            Else
                sql = "{cmd: false }"
            End If
        Else
            sql = "declare @dta xml;" & vbCrLf
            sql += "Set @dta = '" & prm & "';" & vbCrLf & vbCrLf
            sql += "select a.IdPrograma" & vbCrLf
            sql += "from ProgramaEstructura a" & vbCrLf
            sql += "inner join @dta.nodes('Param') t(c) on a.IdPlaza = c.value('@pla', 'smallint') and a.IdSupervisor = c.value('@sup', 'int')" & vbCrLf
            sql += "and a.idCliente = c.value('@pro', 'int') and a.idServicio = c.value('@ser', 'smallint')" & vbCrLf
            sql += "and a.IdPeriodo = c.value('@per', 'smallint') and a.Id_Empresa = c.value('@emp', 'smallint')" & vbCrLf
            sql += "and a.Status = 0;"

            dt = New DataTable()
            da = New SqlDataAdapter(sql, myConnection)
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{cmd: true, prg: " & dt.Rows(0)("id_programa") & "}"
            Else
                sql = "{cmd: false}"
            End If
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gtPrograma(ByVal prm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim xdoc As New XmlDocument()
        xdoc.LoadXml(prm)

        Dim sql As String = " Set language 'Spanish';" & vbCrLf & "declare @dta xml, @pgn smallint;" & vbCrLf
        sql += "Set @dta = '" & prm & "';" & vbCrLf & vbCrLf

        sql += "select @pgn = c.value('@pgn', 'smallint') from @dta.nodes('Param') t(c);" & vbCrLf
        sql += "Select distinct pgn" & vbCrLf
        sql += "from (" & vbCrLf
        sql += "	Select (row_number() over(order by b.nombre, d.descripcion) - 1) / 200 As pgn" & vbCrLf
        sql += "	from tb_programaestructura a" & vbCrLf
        sql += "	inner join tb_cliente b On a.id_cliente = b.id_cliente" & vbCrLf
        sql += "	inner join tb_tipomantenimiento d on a.id_servicio = d.id_servicio" & vbCrLf
        'sql += "	left outer join Empleado e On a.IdSupervisor = e.IdEmpleado" & vbCrLf
        'sql += "    where a.Id_Empresa = " & xdoc.DocumentElement.Attributes("emp").Value & " And a.IdPlaza = " & xdoc.DocumentElement.Attributes("pla").Value & vbCrLf
        If xdoc.DocumentElement.Attributes("pro").Value <> 0 Then
            sql += "And a.id_cliente = " & xdoc.DocumentElement.Attributes("pro").Value & vbCrLf
        End If
        If xdoc.DocumentElement.Attributes("sup").Value <> 0 Then
            sql += "And a.id_coordinador = " & xdoc.DocumentElement.Attributes("sup").Value & vbCrLf
        End If
        sql += "    and a.id_status = 0" & vbCrLf
        sql += ") b order by pgn;" & vbCrLf & vbCrLf

        sql += "Select *" & vbCrLf
        sql += "from (" & vbCrLf
        sql += "	Select a.id_programa As prg, rtrim(b.Nombre) As pro, rtrim(d.Descripcion) As ser" & vbCrLf
        sql += "	, isnull(DATENAME(M, max(e.fregistro)) + ' ' + datename(yy, max(e.fregistro)), '') As sup" & vbCrLf
        sql += "	, Case a.id_status When 0 Then 'Activo' else 'Cancelado' end as stt" & vbCrLf
        sql += "	, (row_number() over(order by b.nombre, d.descripcion) - 1) / 200 as pgn" & vbCrLf
        sql += "	from tb_programaestructura a" & vbCrLf
        sql += "	inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf
        sql += "	inner join tb_tipomantenimiento d On a.id_servicio = d.id_servicio" & vbCrLf
        sql += "	left outer join tb_ordentrabajo e On a.id_programa = e.id_programa " & vbCrLf
        'sql += "    where a.Id_Empresa = " & xdoc.DocumentElement.Attributes("emp").Value & " And a.IdPlaza = " & xdoc.DocumentElement.Attributes("pla").Value & vbCrLf
        If xdoc.DocumentElement.Attributes("pro").Value <> 0 Then
            sql += "And a.id_cliente = " & xdoc.DocumentElement.Attributes("pro").Value & vbCrLf
        End If
        If xdoc.DocumentElement.Attributes("sup").Value <> 0 Then
            sql += "And a.id_coordinador = " & xdoc.DocumentElement.Attributes("sup").Value & vbCrLf
        End If
        sql += "	and a.id_status = 0" & vbCrLf
        sql += "	group by a.id_programa, b.Nombre, d.Descripcion, Case a.id_status When 0 Then 'Activo' else 'Cancelado' end" & vbCrLf
        sql += ") a" & vbCrLf
        sql += "where pgn = @pgn" & vbCrLf
        sql += "order by pro;"

        Dim ds As New DataSet()
        Dim da As New SqlDataAdapter(sql, myConnection)
        da.Fill(ds)
        sql = "{"
        If ds.Tables().Count > 1 Then
            sql += "pgn:"
            If ds.Tables(0).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(0))
            Else
                sql += "[]"
            End If
            sql += ", pro:"
            If ds.Tables(1).Rows.Count > 0 Then
                sql += JsonConvert.SerializeObject(ds.Tables(1))
            Else
                sql += "[]"
            End If
        End If
        sql += "}"
        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function cancelaot(ByVal id As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        Dim sql As String = "update tb_ordentrabajo set id_status=4 where id_orden=" & id

        Dim da As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable()
        da.Fill(dt)
        sql = JsonConvert.SerializeObject(dt)

        Return sql
    End Function

End Class

