Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Coberturafalta
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 ")
        If usuario = 97 Then
            sqlbr.Append("and id_cliente = 136")
        Else
            sqlbr.Append("and id_cliente != 136")
        End If
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
    Public Shared Function empleado(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal fecha As String, ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer) As String

        Dim vfecha As Date
        If fecha <> "" Then vfecha = fecha

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.id_inmueble as 'td','', b.nombre as 'td','', a.id_empleado as 'td','', c.paterno + ' ' +  rtrim(c.materno) + ' ' + c.nombre as 'td',''," & vbCrLf)
        sqlbr.Append("convert(varchar(12),a.fecha,103) as 'td','', a.movimiento as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'Buscar' as '@value', 'btbusca btn btn-info' as '@class', 'button' as '@type' for xml path('input'), root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control' as '@class', 'text' as '@type', case when d.cubre is not null then d.cubre end  as '@value' for xml path('input'), root('td'),type),'',"& vbCrLf)
        sqlbr.Append("case when d.cubre is not null and d.tipoemp = 1 then " & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control' as '@class', 'text' as '@type', case when d.cubre is not null then e.paterno + ' ' + rtrim(e.materno) + ' ' + e.nombre  end  as '@value' for xml path('input'), root('td'),type)"&vbcrlf)
        sqlbr.Append("when d.cubre is not null and d.tipoemp = 2 then " & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control' as '@class', 'text' as '@type', case when d.cubre is not null then f.paterno + ' ' + rtrim(f.materno) + ' ' + f.nombre  end  as '@value' for xml path('input'), root('td'),type)" & vbCrLf)
        sqlbr.Append("else '' end ,'',  " & vbCrLf)
        sqlbr.Append("case when d.cubre is not null then"& vbCrLf)
        sqlbr.Append("(select 'Borrar' as '@value', 'btquita btn btn-danger' as '@class', 'button' as '@type' for xml path('input'),type) " & vbCrLf)
        sqlbr.Append("else '' end as 'td',''," & vbCrLf)
        sqlbr.Append("case when d.cubre is not null then '1' else '0' end as 'td','', case when d.cubre is not null then d.tipoemp else '0' end as 'td' " & vbCrLf)
        sqlbr.Append("from tb_empleado_asistencia a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_empleado c on a.id_empleado = c.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado_cubre d on a.id_periodo = d.id_periodo and a.tipo = d.tipo and a.anio = d.anio and a.id_empleado = d.id_empleado and a.id_inmueble = d.id_inmueble and a.fecha = d.fecha" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado e on d.cubre = e.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_jornalero f on d.cubre = f.id_jornalero " & vbCrLf)
        sqlbr.Append("where a.id_periodo = " & periodo & " and a.anio = " & anio & " and a.tipo ='" & tipo & "'" & vbCrLf)
        sqlbr.Append("and movimiento in('F','FJ','V', 'IEG', 'IRT') and b.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & "" & vbCrLf)
        If fecha <> "" Then sqlbr.Append("and a.fecha = '" & Format(vfecha, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append("ORDER BY b.nombre, c.paterno, c.materno, c.nombre, a.fecha for xml path('tr'), root('tbody')" & vbCrLf)

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
    Public Shared Function listaempleado(ByVal tipo As Integer, ByVal busca As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        If tipo = 1 Then
            sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.descripcion as 'td','', c.nombre as 'td'" & vbCrLf)
            sqlbr.Append("from tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
            sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
            sqlbr.Append("where a.id_status = 2 and tipo = 2 and CAST(id_empleado AS char)+paterno+' '+materno+' '+A.nombre like '%" & busca & "%'" & vbCrLf)
            sqlbr.Append("order by paterno, materno, a.nombre for xml path('tr'), root('tbody')")
        Else
            sqlbr.Append("select id_jornalero as 'td','', paterno + ' ' + rtrim(materno) + ' ' + nombre as 'td','', 'Jornalero' as 'td','', '' as 'td'" & vbCrLf)
            sqlbr.Append("from tb_jornalero " & vbCrLf)
            'sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
            sqlbr.Append("where id_status = 1 and CAST(id_jornalero AS char)+paterno+' '+materno+' '+nombre like '%" & busca & "%'" & vbCrLf)
            sqlbr.Append("order by paterno, materno, nombre for xml path('tr'), root('tbody')")
        End If

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
        Dim mycommand As New SqlCommand("sp_cobertura", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal empleado As String, ByVal per As Integer, ByVal anio As Integer, ByVal tipo As String, ByVal inmueble As Integer, ByVal fecha As String) As String

        Dim vfecha As Date
        If fecha <> "" Then vfecha = fecha

        Dim sql As String = "delete from tb_empleado_cubre where id_empleado =" & empleado & " and id_periodo =" & per & " and anio =" & anio & " and tipo ='" & tipo & "' and id_inmueble = " & inmueble & " and fecha = '" & Format(vfecha, "yyyyMMdd") & "';"
        sql += "update tb_empleado_asistencia set cubierto = 0 where id_empleado =" & empleado & " and id_periodo =" & per & " and anio =" & anio & " and tipo ='" & tipo & "' and id_inmueble = " & inmueble & " and fecha = '" & Format(vfecha, "yyyyMMdd") & "';"
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
        'Dim userid As Integer
        usuario = Request.Cookies("Usuario")

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
