Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_dashboard_Dash_Cliente
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.Per_Interno, b.nombre from personal a inner join tb_cliente b on a.Per_Interno = b.id_cliente where IdPersonal = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("Per_Interno") & "', nombre: '" & dt.Rows(0)("nombre") & "'}" & vbCrLf
        Else
            sql += "{id:0, nombre:''}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function clientelista() As String
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

        sqlbr.Append("SELECT id as 'td','', nombre as 'td','', cantidad as 'td' from (" & vbCrLf)
        sqlbr.Append("select 0 as id,'TOTAL' as nombre,  isnull(sum(b.cantidad),0) as cantidad" & vbCrLf)
        sqlbr.Append("From tb_cliente_inmueble a left outer join tb_cliente_plantilla b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("where id_cliente = " & cliente & " and a.id_status = 1 and b.id_status = 1 group by a.id_cliente " & vbCrLf)
        sqlbr.Append("union all" & vbCrLf)
        sqlbr.Append("select a.id_inmueble , rtrim(nombre) as nombre, isnull(sum(b.cantidad),0) as cantidad" & vbCrLf)
        sqlbr.Append("From tb_cliente_inmueble a left outer join tb_cliente_plantilla b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("where id_cliente = " & cliente & " and a.id_status = 1 and b.id_status = 1 group by a.id_inmueble , nombre) AS tabla For xml path('tr'), root('tbody')")

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
    Public Shared Function asistenciag(ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select cast(cast(isnull(AVG(calif),0) as numeric(12,2)) as varchar)  + '%'  as promedio  from( " & vbCrLf)
        sqlbr.Append("select cast((cast(count(id_empleado) as float)/" & vbCrLf)
        sqlbr.Append("(Select sum(cantidad) as total from tb_cliente_plantilla a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where b.id_cliente = 101)) *100 as numeric(8,2)) as calif" & vbCrLf)
        sqlbr.Append("from tb_empleado_asistencia a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where b.id_cliente  = 101 AND movimiento = 'A' and month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " Group by fecha) As tabla1")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{prom:'" & dt.Rows(0)("promedio") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function materialg(ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        Dim total As Integer = 0
        Dim entregado As Integer = 0
        Dim porcentaje As Double = 0.0
        sqlbr.Append("SELECT COUNT(id_listado) as total from tb_listadomaterial where id_cliente = " & cliente & " and mes = " & mes & " and anio = " & anio & " and id_status != 5;" & vbCrLf)
        sqlbr.Append("SELECT COUNT(id_listado) as entregado from tb_listadomaterial where id_cliente = " & cliente & " and mes = " & mes & " and anio = " & anio & " and id_status = 4")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            total = dt.Tables(0).Rows(0)("total")
            entregado = dt.Tables(1).Rows(0)("entregado")
            porcentaje = (entregado / total)
            'porcentaje = 
            sql += "{total:'" & Format(porcentaje, "#.00%") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function materialind(ByVal sucursal As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select isnull(count(id),0) as total from tb_entrega_material where id_inmueble = " & sucursal & " and anio = " & anio & " and mes = " & mes & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{total:'" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function supervisiong(ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select count(id_supervision) as total from tb_supervision where id_cliente = " & cliente & " and year(fechaini) = " & anio & " and month(fechaini) = " & mes & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{total:'" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function evaluaciong(ByVal cliente As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select count(id_campania) as total from tb_encuesta_registro where id_cliente = " & cliente & " and year(fecha) = " & anio & " and month(fecha) = " & mes & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{total:'" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function evaluacionind(ByVal sucursal As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select count(id_campania) as total from tb_encuesta_registro where id_inmueble = " & sucursal & " and year(fecha) = " & anio & " and month(fecha) = " & mes & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{total:'" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function supervisioind(ByVal sucursal As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select isnull(count(id_supervision),0) as total from tb_supervision where id_inmueble = " & sucursal & " and year(fechaini) = " & anio & " and month(fechaini) = " & mes & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{total: '" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asistenciaind(ByVal sucursal As Integer, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select cast(cast(isnull(AVG(calif),0) as numeric(12,2)) as varchar)  + '%'  as promedio  from( " & vbCrLf)
        sqlbr.Append("select cast((cast(count(id_empleado) as float)/" & vbCrLf)
        sqlbr.Append("(Select sum(cantidad) as total from tb_cliente_plantilla a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where A.id_inmueble  = " & sucursal & " and a.id_status = 1)) *100 as numeric(8,2)) as calif" & vbCrLf)
        sqlbr.Append("from tb_empleado_asistencia a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where A.id_inmueble  = " & sucursal & " AND movimiento = 'A' and month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " group by fecha) as tabla1")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{prom:'" & dt.Rows(0)("promedio") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asistenciasuc(ByVal sucursal As String, ByVal nombre As String, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sql As String, chpre As String

        sql = "select day(fecha) as fecha, count(movimiento) as asistencia from tb_empleado_asistencia where month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " and id_inmueble = " & sucursal & " AND movimiento = 'A' group by fecha order by fecha"

        Dim mycommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: { type: 'column' }, title: { text: 'Asistencia del mes:" & nombre & "'}"
        chpre += ", xAxis: { type: 'category', labels: { rotation: 90, align: 'left' }, categories: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "'" & ds.Tables(0).Rows(x)("fecha") & "'"
        Next
        chpre += "]}"
        chpre += ", legend: { enabled: false }"
        chpre += ", plotOptions: { column: { pointPadding: 0.2, borderWidth: 0 } }"
        chpre += ", tooltip: { pointFormat: '<span style=""color:{series.color}"">{series.name}</span>: <b>{point.y}</b> ', shared: true }"
        chpre += ", yAxis: { min: 0, title: { text: 'Asistencia' } }, series: ["
        chpre += "{ name: 'Asistencia', data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "" & ds.Tables(0).Rows(x)("asistencia")
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false } }"
        Return chpre
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asistenciacli(ByVal cliente As String, ByVal nombre As String, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim chpre As String
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select day(fecha) as fecha, count(movimiento) as asistencia " & vbCrLf)
        sqlbr.Append("From tb_empleado_asistencia a inner Join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("where month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " and b.id_cliente  = " & cliente & " AND movimiento = 'A' " & vbCrLf)
        sqlbr.Append("Group By fecha Order By fecha")

        Dim mycommand As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: { type: 'column' }, title: { text: 'Asistencia del mes:" & nombre & "'}"
        chpre += ", xAxis: { type: 'category', labels: { rotation: 90, align: 'left' }, categories: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "'" & ds.Tables(0).Rows(x)("fecha") & "'"
        Next
        chpre += "]}"
        chpre += ", legend: { enabled: false }"
        chpre += ", plotOptions: { column: { pointPadding: 0.2, borderWidth: 0 } }"
        chpre += ", tooltip: { pointFormat: '<span style=""color:{series.color}"">{series.name}</span>: <b>{point.y}</b> ', shared: true }"
        chpre += ", yAxis: { min: 0, title: { text: 'Asistencia' } }, series: ["
        chpre += "{ name: 'Asistencia', data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "" & ds.Tables(0).Rows(x)("asistencia")
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false } }"
        Return chpre
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asistenciacli1(ByVal cliente As String, ByVal nombre As String, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder, chpre As String

        sqlbr.Append("select case when movimiento = 'A' then 'Asistencia' when movimiento ='F' then 'falta' else  'Otro' end as mov," & vbCrLf)
        sqlbr.Append("count(movimiento) as total from tb_empleado_asistencia a inner join tb_cliente_inmueble  b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("where b.id_cliente = " & cliente & " and month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " group by movimiento ")

        Dim mycommand As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: {"
        chpre += "plotBackgroundColor: null, plotBorderWidth: null, plotShadow: false, type: 'pie' },"
        chpre += "    title: { text: 'Incidencias," & nombre & "' },"
        chpre += "    tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}</b>' },"
        chpre += "    accessibility: { point: { valueSuffix: ''}},"
        chpre += "    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', dataLabels: {enabled: true, format: '<b>{point.name}</b>: {point.percentage:.1f}%'}}},"
        chpre += "    series: [{"
        chpre += "        name: 'Incidencia',"
        chpre += "        colorByPoint: true,"
        chpre += "    data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ", "
            chpre += "{ name: '" & ds.Tables(0).Rows(x)("mov") & "' , y: " & ds.Tables(0).Rows(x)("total") & "} "
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false }}"
        Return chpre
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asistenciasuc1(ByVal inmueble As String, ByVal nombre As String, ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder, chpre As String

        sqlbr.Append("select case when movimiento = 'A' then 'Asistencia' when movimiento ='F' then 'falta' else  'Otro' end as mov," & vbCrLf)
        sqlbr.Append("count(movimiento) as total from tb_empleado_asistencia a inner join tb_cliente_inmueble  b on a.id_inmueble = b.id_inmueble " & vbCrLf)
        sqlbr.Append("where a.id_inmueble = " & inmueble & " and month(fecha) =" & mes & " and YEAR (fecha) = " & anio & " group by movimiento ")

        Dim mycommand As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: {"
        chpre += "plotBackgroundColor: null, plotBorderWidth: null, plotShadow: false, type: 'pie' },"
        chpre += "    title: { text: 'Incidencias," & nombre & "' },"
        chpre += "    tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}</b>' },"
        chpre += "    accessibility: { point: { valueSuffix: ''}},"
        chpre += "    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', dataLabels: {enabled: true, format: '<b>{point.name}</b>: {point.percentage:.1f}%'}}},"
        chpre += "    series: [{"
        chpre += "        name: 'Incidencia',"
        chpre += "        colorByPoint: true,"
        chpre += "    data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ", "
            chpre += "{ name: '" & ds.Tables(0).Rows(x)("mov") & "' , y: " & ds.Tables(0).Rows(x)("total") & "} "
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false }}"
        Return chpre
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie

        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
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
