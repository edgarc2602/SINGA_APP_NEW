Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_IncidenciaM
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function periodo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + descripcion as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonomina where activo = 1")
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
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "' and anio =" & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function turno() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_turno, descripcion from tb_turno where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_turno") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function incidencia() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_incidencia, descripcion from tb_incidencia where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_incidencia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detincidencia(ByVal incidencia As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select case when tipomov = 1 then 'Deducción' else 'Percepción' end as tipo, case when tipo =1 then formula else 'Monto' end as formula from tb_incidencia where id_incidencia = " & incidencia & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{tipo:'" & dt.Rows(0)("tipo") & "', formula:'" & dt.Rows(0)("formula") & "'}"

        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarempleado(ByVal forma As String, ByVal cliente As String, ByVal inmueble As String, ByVal turno As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/80 + 1 as Filas, COUNT(*) % 80 as Residuos" & vbCrLf)
        sqlbr.Append("FROM  tb_empleado a  where a.tipo = 2 and a.id_status = 2 and a.formapago = " & forma & " and a.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("And a.id_inmueble = " & inmueble & "" & vbCrLf)
        If turno <> 0 Then sqlbr.Append("and a.id_turno = " & turno & "" & vbCrLf)
        'If nombre <> "" Then sqlbr.Append("and a.paterno+rtrim(a.materno)+a.nombre like '%" & nombre & "%'" & vbCrLf)
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
    Public Shared Function empleado(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal fecha As String, ByVal forma As Integer, ByVal pagina As Integer, ByVal turno As Integer) As String

        Dim vfecha As Date
        If fecha <> "" Then vfecha = fecha

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_inmueble as 'td','', sucursal as 'td','', id_empleado as 'td','',empleado as 'td','', turno as 'td','', fingreso as 'td','', cast(sueldo/30.4167 as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control input-sm' as '@class', 'text' as '@type' for xml path('input'), root('td'),type) from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by e.nombre, a.paterno, a.materno, a.nombre) As RowNum, e.id_inmueble, e.nombre as sucursal, a.id_empleado, paterno + ' ' + rtrim(materno) + ' ' + a.nombre as empleado," & vbCrLf)
        sqlbr.Append("convert(varchar(10),fingreso, 103) fingreso, f.descripcion as turno, sueldo" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_cliente b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_empleado_inmueble c on a.id_empleado = c.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble e on c.id_inmueble = e.id_inmueble " & vbCrLf)
        'sqlbr.Append("Left outer join tb_empleado_asistencia d on a.id_empleado = d.id_empleado and d.fecha = '20200526'" & vbCrLf)
        sqlbr.Append("inner join tb_turno f on a.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("where a.id_status = 2 and cast(fingreso as date) <= '" & Format(vfecha, "yyyyMMdd") & "'  and a.formapago = " & forma & " and a.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & "" & vbCrLf)
        'If estado <> 0 Then sqlbr.Append("and e.id_estado = " & estado & "" & vbCrLf)
        If turno <> 0 Then sqlbr.Append("and a.id_turno = " & turno & "" & vbCrLf)
        'If nombre <> "" Then sqlbr.Append("and a.paterno+rtrim(a.materno)+a.nombre like '%" & nombre & "%'" & vbCrLf)
        sqlbr.Append(") as tabla where RowNum BETWEEN (" & pagina & " - 1) * 80 + 1 And " & pagina & " * 80 order by sucursal, empleado for xml path('tr'), root('tbody')")
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
        Dim mycommand As New SqlCommand("sp_incidenciafalta", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim cliente As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        cliente = Request.Cookies("cliente")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
