Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Con_Asistencia
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function contarasistencia(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal fecini As String, ByVal fecfin As String, ByVal forma As Integer, ByVal turno As Integer) As String

        Dim vfecini As Date, vfecfin As Date
        If fecini <> "" Then vfecini = fecini
        If fecfin <> "" Then vfecfin = fecfin

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select COUNT(*)/80 + 1 as Filas, COUNT(*) % 80 as Residuos from(" & vbCrLf)
        sqlbr.Append("SELECT ROW_NUMBER()Over(Order by cliente, inmueble, empleado) As RowNum, cliente, inmueble, id_empleado, empleado, isnull([1],'') as '1', isnull([2],'') as '2'," & vbCrLf)
        sqlbr.Append("isnull([3],'') as '3',isnull([4],'') as'4',isnull([5],'')as'5',isnull([6],'')as'6',isnull([7],'')as'7'" & vbCrLf)
        sqlbr.Append("FROM  " & vbCrLf)
        sqlbr.Append("(SELECT row_number() over(partition by a.id_empleado order by fecha) As diat, a.id_empleado, movimiento, " & vbCrLf)
        sqlbr.Append("b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, c.nombre as cliente, d.nombre as inmueble  " & vbCrLf)
        sqlbr.Append("FROM tb_empleado_asistencia a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "' and b.formapago = " & forma & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & " ")
        If inmueble <> 0 Then sqlbr.Append("and b.id_inmueble = " & inmueble & " ")
        If turno <> 0 Then sqlbr.Append("and b.id_turno = " & turno & " ")
        sqlbr.Append(") AS SourceTable  " & vbCrLf)
        sqlbr.Append("PIVOT  " & vbCrLf)
        sqlbr.Append("(  " & vbCrLf)
        sqlbr.Append("	max(movimiento)" & vbCrLf)
        sqlbr.Append("	For diat IN ([1],[2],[3],[4],[5],[6],[7])" & vbCrLf)
        sqlbr.Append(") AS PivotTable) result")
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
    Public Shared Function asistencia(ByVal pagina As Integer, ByVal cliente As Integer, ByVal inmueble As Integer, ByVal fecini As String, ByVal fecfin As String, ByVal forma As Integer, ByVal turno As Integer) As String

        Dim vfecini As Date, vfecfin As Date
        If fecini <> "" Then vfecini = fecini
        If fecfin <> "" Then vfecfin = fecfin

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select 'table table-condensed h6' as '@class',(" & vbCrLf)
        sqlbr.Append("select (select 'bg-navy' as '@class', 'Cliente' as 'span' FOR XML path('th'), type), (select 'bg-navy' as '@class', 'Punto de atención' as 'span' FOR XML path('th'), type)," & vbCrLf)
        sqlbr.Append("(select 'bg-navy' as '@class', 'No. Empleado' as 'span' FOR XML path('th'), type), (select 'bg-navy' as '@class', 'Nombre' as 'span' FOR XML path('th'), type)," & vbCrLf)
        sqlbr.Append("(select 'bg-navy' as '@class', d1 as 'span' FOR XML path('th'), type), (select 'bg-navy' as '@class', d2 as 'span' FOR XML path('th'), type)," & vbCrLf)
        sqlbr.Append("(select 'bg-navy' as '@class', d3 as 'span' FOR XML path('th'), type), (select 'bg-navy' as '@class', d4 as 'span' FOR XML path('th'), type)," & vbCrLf)
        sqlbr.Append("(select 'bg-navy' as '@class', d5 as 'span' FOR XML path('th'), type), (select 'bg-navy' as '@class', d6 as 'span' FOR XML path('th'), type)," & vbCrLf)
        sqlbr.Append("(select 'bg-navy' as '@class', d7 as 'span' FOR XML path('th'), type) from tb_periodonomina where finicio = '20200506' and ffin = '20200512' for xml path('tr'), root('thead'),type)," & vbCrLf)
        sqlbr.Append("(select cliente as 'td','', inmueble as 'td','', id_empleado as 'td','', empleado as 'td','', a as 'td','',b as 'td',''," & vbCrLf)
        sqlbr.Append("c as 'td','',d as 'td','',e as 'td','',f as 'td','', g as 'td' " & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("SELECT ROW_NUMBER()Over(Order by cliente, inmueble, empleado) As RowNum, cliente, inmueble, id_empleado, empleado, isnull([1],'') as 'a', " & vbCrLf)
        sqlbr.Append("isnull([2],'') as 'b', isnull([3],'') as 'c',isnull([4],'') as 'd',isnull([5],'')as 'e',isnull([6],'') as'f',isnull([7],'')as'g'" & vbCrLf)
        sqlbr.Append("FROM  " & vbCrLf)
        sqlbr.Append("	(SELECT row_number() over(partition by a.id_empleado order by fecha) As diat, a.id_empleado, movimiento, " & vbCrLf)
        sqlbr.Append("	b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, c.nombre as cliente, d.nombre as inmueble  " & vbCrLf)
        sqlbr.Append("	FROM tb_empleado_asistencia a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("	inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "' and b.formapago = " & forma & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & " ")
        If inmueble <> 0 Then sqlbr.Append("and b.id_inmueble = " & inmueble & " ")
        If turno <> 0 Then sqlbr.Append("and b.id_turno = " & turno & " ")
        sqlbr.Append(") AS SourceTable  " & vbCrLf)
        sqlbr.Append("	PIVOT  " & vbCrLf)
        sqlbr.Append("(  " & vbCrLf)
        sqlbr.Append("		max(movimiento)" & vbCrLf)
        sqlbr.Append("		For diat IN ([1],[2],[3],[4],[5],[6],[7])" & vbCrLf)
        sqlbr.Append(") AS PivotTable) result where RowNum BETWEEN (" & pagina & " - 1) * 80 + 1 And " & pagina & " * 80 order by RowNum for xml path('tr'), root('tbody'),type) for xml path('table')")
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
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
