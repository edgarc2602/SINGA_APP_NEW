Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class Home1
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function general(ByVal anio As Integer, mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select left(convert(varchar,cast(count(id_cliente) as money),1), len(convert(varchar,cast(count(id_cliente) as money),1))-3)  as clientes from tb_cliente where id_status = 1;" & vbCrLf)
        sqlbr.Append("select left(convert(varchar,cast(sum(importe) as money),1), len(convert(varchar,cast(sum(importe) as money),1))-3) as iguala from tb_cliente_inmueble_ig;" & vbCrLf)
        sqlbr.Append("select left(convert(varchar,cast(sum(cantidad) as money),1), len(convert(varchar,cast(sum(cantidad) as money),1))-3)  as empleados from tb_cliente_plantilla where id_status = 1;" & vbCrLf)
        sqlbr.Append("select COUNT(id_vacante) as totalv from tb_vacante where id_status = 1;")
        sqlbr.Append("select COUNT(id_supervision) as totals from tb_supervision where year(fechaini) = " & anio & " and  month(fechaini) = " & mes & ";")
        sqlbr.Append("select count(id_listado) as totall from tb_listadomaterial where mes = " & mes & " and anio = " & anio & "  and id_status = 4;")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{clientes: '" & dt.Tables(0).Rows(0)("clientes") & "', igualas:'" & dt.Tables(1).Rows(0)("iguala") & "',empleados:'" & dt.Tables(2).Rows(0)("empleados") & "', vacantes:'" & dt.Tables(3).Rows(0)("totalv") & "',"
            sql += " supervision:'" & dt.Tables(4).Rows(0)("totals") & "', entregas:'" & dt.Tables(5).Rows(0)("totall") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tickets(ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select estatus as 'td','', COUNT(tk_estatus) as 'td','', max(Tk_Estatus) as 'td' from (" & vbCrLf)
        sqlbr.Append("select ID_Ticket, Tk_Estatus, " & vbCrLf)
        sqlbr.Append("case when Tk_Estatus = 0 then 'Alta' when Tk_Estatus = 1 then 'Atendido' when Tk_Estatus = 2 then 'Cerrado'   "& vbCrLf)
        sqlbr.Append("	when Tk_Estatus = 3 then 'Cancelado' when Tk_Estatus = 4 then 'Cerrado sin cubrir'   end estatus " & vbCrLf)
        sqlbr.Append("from Tbl_Ticket where YEAR(Tk_FechaAlta ) = " & anio & " and MONTH(Tk_FechaAlta ) = " & mes & ") result group by estatus for xml path('tr'), root('tbody')")

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
    Public Shared Function ticketschr(ByVal anio As Integer, ByVal mes As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder, chpre As String

        sqlbr.Append("select estatus, COUNT(tk_estatus) as total from (" & vbCrLf)
        sqlbr.Append("select ID_Ticket, Tk_Estatus, " & vbCrLf)
        sqlbr.Append("case when Tk_Estatus = 0 then 'Alta' when Tk_Estatus = 1 then 'Atendido' when Tk_Estatus = 2 then 'Cerrado'" & vbCrLf)
        sqlbr.Append("when Tk_Estatus = 3 then 'Cancelado' when Tk_Estatus = 4 then 'Cerrado sin cubrir'   end estatus " & vbCrLf)
        sqlbr.Append("from Tbl_Ticket where YEAR(Tk_FechaAlta ) = " & anio & " and MONTH(Tk_FechaAlta ) = " & mes & ") result group by estatus")

        Dim mycommand As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: {"
        chpre += "plotBackgroundColor: null, plotBorderWidth: null, plotShadow: false, type: 'pie' },"
        chpre += "    title: { text: 'Tickets por estatus' },"
        chpre += "    tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}</b>' },"
        chpre += "    accessibility: { point: { valueSuffix: ''}},"
        chpre += "    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', dataLabels: {enabled: true, format: '<b>{point.name}</b>: {point.percentage:.1f}%'}}},"
        chpre += "    series: [{"
        chpre += "        name: 'Incidencia',"
        chpre += "        colorByPoint: true,"
        chpre += "    data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ", "
            chpre += "{ name: '" & ds.Tables(0).Rows(x)("estatus") & "' , y: " & ds.Tables(0).Rows(x)("total") & "} "
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false }}"
        Return chpre
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ticketarea(ByVal anio As Integer, ByVal mes As Integer, ByVal estatus As Integer, ByVal descest As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sql As String, chpre As String

        sql = "select count(ID_Ticket) as total,  isnull(b.Ar_Descripcion, 'No registrada') as area"
        sql += " from Tbl_Ticket a left outer join Tbl_Area_Empresa b on a.id_area = b.IdArea "
        sql += " where YEAR(Tk_FechaAlta ) = " & anio & " and MONTH(Tk_FechaAlta ) = " & mes & " and Tk_Estatus = " & estatus & "  group by id_area, b.Ar_Descripcion "

        Dim mycommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)

        chpre = "{ chart: { type: 'column' }, title: { text: 'Tickets " + descest + " por Area'}"
        chpre += ", xAxis: { type: 'category', labels: { rotation: 90, align: 'left' }, categories: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "'" & ds.Tables(0).Rows(x)("area") & "'"
        Next
        chpre += "]}"
        chpre += ", legend: { enabled: false }"
        chpre += ", plotOptions: { column: { pointPadding: 0.2, borderWidth: 0 } }"
        chpre += ", tooltip: { pointFormat: '<span style=""color:{series.color}"">{series.name}</span>: <b>{point.y}</b> ', shared: true }"
        chpre += ", yAxis: { min: 0, title: { text: 'Cantidad' } }, series: ["
        chpre += "{ name: 'Tickets', data: ["
        For x = 0 To ds.Tables(0).Rows.Count - 1
            If x > 0 Then chpre += ","
            chpre += "" & ds.Tables(0).Rows(x)("total")
        Next
        chpre += "]}]"
        chpre += ", credits: { enabled: false } }"
        Return chpre
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function supervisiones(ByVal anio As Integer, ByVal mes As Integer, ByVal opc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Select Case opc
            Case 1
                sqlbr.Append("select supervisor as 'td','', total as 'td' from (" & vbCrLf)
                sqlbr.Append("select	b.Per_Nombre +' ' + b.Per_Paterno+ ' '+ b.Per_Materno as supervisor, count(id_supervision) as total " & vbCrLf)
                sqlbr.Append("from tb_supervision a inner join Personal b on a.usuario = b.IdPersonal where month(fechaini) = " & mes & " and year(Fechaini) =" & anio & "" & vbCrLf)
                sqlbr.Append("group by usuario, Per_Nombre, Per_Paterno, Per_Materno) as tabla order by supervisor for xml path('tr'), root('tbody')")
            Case 2
                sqlbr.Append("select nombre as 'td','', total as 'td' from (" & vbCrLf)
                sqlbr.Append("select	b.nombre, count(id_supervision) as total " & vbCrLf)
                sqlbr.Append("from tb_supervision a inner join tb_cliente b on a.id_cliente = b.id_cliente where month(fechaini) = " & mes & " and year(Fechaini) =" & anio & "" & vbCrLf)
                sqlbr.Append("group by b.nombre) as tabla order by nombre for xml path('tr'), root('tbody')")

        End Select

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
    Public Shared Function vacantes(ByVal reclutador As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_vacante as 'td','', d.nombre + ', ' + c.nombre  + ' ' + e.descripcion + ' ' + f.descripcion + ' ' +cast(b.jornal as varchar) + 'hrs, sueldo:' + cast(b.smntope as varchar) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_vacante a inner join tb_cliente_plantilla b on a.id_plantilla = b.id_plantilla" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on b.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_cliente d on c.id_cliente = d.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_puesto e on b.id_puesto = e.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno f on b.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("where id_reclutador = " & reclutador & " And a.id_status = 1 for xml path('tr'), root('tbody')")

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
    Public Shared Function empleado(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{empleado: '" & dt.Tables(0).Rows(0)("id_empleado") & "'}"
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idcliente1.Value = Request.Cookies("Cliente").Value
        reclutador.Value = Request.Cookies("reclutador").Value

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
