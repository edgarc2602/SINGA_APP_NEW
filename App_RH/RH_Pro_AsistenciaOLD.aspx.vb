Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Asistencia
    Inherits System.Web.UI.Page

    Public listamenu As String = ""

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
    Public Shared Function estados(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct a.id_estado, b.descripcion from tb_cliente_inmueble a inner join tb_estado b on a.id_estado = b.id_estado where a.id_cliente = " & cliente & " order by id_estado")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
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
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "'")
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
    Public Shared Function contarempleado(ByVal forma As String, ByVal cliente As String, ByVal inmueble As String, ByVal turno As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/80 + 1 as Filas, COUNT(*) % 80 as Residuos" & vbCrLf)
        sqlbr.Append("FROM  tb_empleado a  where a.tipo = 2 and a.id_status = 2 and a.formapago = " & forma & " and a.id_cliente = " & cliente & "" & vbCrLf)
        sqlbr.Append("And a.id_inmueble = " & inmueble & "" & vbCrLf)
        If turno <> 0 Then
            sqlbr.Append("and a.id_turno = " & turno & "" & vbCrLf)
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
    Public Shared Function empleado(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal fecha As String, ByVal estado As Integer, ByVal forma As Integer, ByVal pagina As Integer, ByVal turno As Integer) As String

        Dim vfecha As Date
        If fecha <> "" Then vfecha = fecha

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select cliente as 'td','', id_inmueble as 'td','', sucursal as 'td','', id_empleado as 'td','',empleado as 'td','', turno as 'td','', fingreso as 'td','',sueldo as 'td',''," & vbCrLf)
        sqlbr.Append("case --when mov ='X' then (select 'S' as '@value', 'tbstatus1 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	when mov ='A' then (select 'S' as '@value', 'tbstatus1 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus1 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='F' then (select 'S' as '@value', 'tbstatus2 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus2 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='FJ' then (select 'S' as '@value', 'tbstatus3 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus3 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='N' then (select 'S' as '@value', 'tbstatus4 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus4 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='V' then (select 'S' as '@value', 'tbstatus5 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus5 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='IEG' then (select 'S' as '@value', 'tbstatus6 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus6 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='IRT' then (select 'S' as '@value', 'tbstatus7 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus7 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end," & vbCrLf)
        sqlbr.Append("case when mov ='D' then (select 'S' as '@value', 'tbstatus8 btn btn-success' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
        sqlbr.Append("	else (select 'N' as '@value', 'tbstatus8 btn btn-secundary' as '@class', 'button' as '@type' for xml path('input'), root('td'),type) end" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by e.nombre, a.paterno, a.materno, a.nombre) As RowNum, b.nombre as cliente, e.id_inmueble, e.nombre as sucursal, a.id_empleado, paterno + ' ' + rtrim(materno) + ' ' + a.nombre as empleado," & vbCrLf)
        sqlbr.Append("convert(varchar(10),fingreso, 103) fingreso, cast(sueldo/30 as numeric(12,2)) sueldo, isnull(d.movimiento, 'X') mov, f.descripcion as turno" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_cliente b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_empleado_inmueble c on a.id_empleado = c.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble e on c.id_inmueble = e.id_inmueble " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado_asistencia d on a.id_empleado = d.id_empleado and d.fecha = '" & Format(vfecha, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append("inner join tb_turno f on a.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("where a.tipo = 2 and a.id_status = 2 and cast(fingreso as date) <= '" & Format(vfecha, "yyyyMMdd") & "'  and a.formapago = " & forma & " and a.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and e.id_estado = " & estado & "" & vbCrLf)
        If turno <> 0 Then sqlbr.Append("and a.id_turno = " & turno & "" & vbCrLf)
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
        Dim mycommand As New SqlCommand("sp_asistencia", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reporte(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_rep_aistencia", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function


    <Web.Services.WebMethod()>
    Public Shared Function quitafalta(ByVal empleado As String, ByVal per As Integer, ByVal anio As Integer, ByVal tipo As String) As String

        Dim sql As String = "delete from tb_empleadoincidencia where id_empleado =" & empleado & " and id_periodo =" & per & " and anio =" & anio & " and tipo ='" & tipo & "' and id_incidencia =1;"
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
    End Sub
End Class
