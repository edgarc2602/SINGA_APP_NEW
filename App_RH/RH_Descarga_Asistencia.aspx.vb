Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_RH_RH_Descarga_Asistencia
    Inherits System.Web.UI.Page

    Class parametro
        Public tname As String
        Public tipo As Int16
        Public alm As Int32
        Public emp As Int16
        Public pza As String
        Public fini As String
        Public ffin As String
    End Class

    Private Sub extoex(ByVal data As DataTable, ByVal nombre As String)
        Dim context As HttpContext = HttpContext.Current()
        context.Response.Clear()
        context.Response.Write("<html><body>")
        context.Response.Write("<table>")
        context.Response.Write("<tr>")
        For Each column As DataColumn In data.Columns
            context.Response.Write("<td>" & column.ColumnName & "</td>")
        Next
        context.Response.Write("</tr>")
        context.Response.Write(Environment.NewLine)

        For Each ren As DataRow In data.Rows
            context.Response.Write("<tr>")
            For i As Integer = 0 To data.Columns.Count - 1
                context.Response.Write("<td>" & ren(i).ToString().Replace(";", String.Empty) & "</td>")
            Next
            context.Response.Write("</tr>")
            context.Response.Write(Environment.NewLine)
        Next

        context.Response.ContentType = "application/vnd.ms-excel"
        context.Response.AppendHeader("Content-Disposition", "attachment; filename=" & nombre & ".xls")
        context.Response.Charset = "UTF-8"
        context.Response.ContentEncoding = Encoding.Default
        context.Response.Write("</table>")
        context.Response.Write("</body></html>")
        context.Response.End()
    End Sub

    Protected Sub rptKardex(ByVal fecini As String, fecfin As String, ByVal cliente As Integer, ByVal gerente As Integer, ByVal ejecutivo As Integer, ByVal tipo As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        Dim vfecini As Date, vfecfin As Date
        If fecini <> "" Then vfecini = fecini
        If fecfin <> "" Then vfecfin = fecfin

        sqlbr.Append("DECLARE @cols NVARCHAR (MAX),  @query NVARCHAR(MAX);" & vbCrLf)
        sqlbr.Append("SELECT @cols = COALESCE (@cols + ',[' + CONVERT(NVARCHAR, fecha, 103) + ']', " & vbCrLf)
        sqlbr.Append("'[' + CONVERT(NVARCHAR, fecha, 103) + ']')" & vbCrLf)
        sqlbr.Append("FROM (SELECT DISTINCT fecha FROM tb_empleado_asistencia) PV  " & vbCrLf)
        sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append("ORDER BY fecha" & vbCrLf)
        sqlbr.Append("" & vbCrLf)
        sqlbr.Append("SET @query = '           " & vbCrLf)
        sqlbr.Append("              SELECT * FROM " & vbCrLf)
        sqlbr.Append("             (" & vbCrLf)
        sqlbr.Append("                 SELECT c.nombre as Cliente, d.nombre as Inmueble, a.id_empleado, movimiento, CONVERT(NVARCHAR, fecha, 103) as fecha, b.paterno, rtrim(b.materno) materno ,  b.nombre, " & vbCrLf)
        sqlbr.Append("				 e.descripcion as Puesto, f.descripcion as Turno, convert(varchar(10),b.fingreso,103) as fingreso, case when b.formapago= 1 then ''Quincenal'' else ''Semanal'' end as Formapago" & vbCrLf)
        sqlbr.Append("				 FROM tb_empleado_asistencia a inner join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("				 inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble" & vbCrLf)
        sqlbr.Append("				 inner join tb_puesto e on b.id_puesto = e.id_puesto inner join tb_turno f on b.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("				 inner join tb_cliente_ejecutivocgo g on b.id_cliente = g.id_cliente" & vbCrLf)
        sqlbr.Append("				 where  convert(varchar(8), fecha,112) between ' + '" & Format(vfecini, "yyyyMMdd") & "' +' and ' + '" & Format(vfecfin, "yyyyMMdd") & "' + ' and b.id_area = '+ '" & tipo & "'+'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente='+ '" & cliente & "'+'" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo='+ '" & gerente & "'+'" & vbCrLf)
        If ejecutivo <> 0 Then sqlbr.Append("and g.id_ejecutivo='+ '" & ejecutivo & "'+'" & vbCrLf)
        sqlbr.Append("             ) x" & vbCrLf)
        sqlbr.Append("             PIVOT " & vbCrLf)
        sqlbr.Append("             (" & vbCrLf)
        sqlbr.Append("                 max(movimiento)" & vbCrLf)
        sqlbr.Append("                 FOR fecha IN (' + @cols + ')" & vbCrLf)
        sqlbr.Append("            ) p'" & vbCrLf)
        sqlbr.Append("EXEC SP_EXECUTESQL @query ")

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "Asistencia")
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)
        Dim tipo As Integer = Request("tipo")
        Dim cliente As Integer = Request("cliente")
        Dim fecini As String = Request("fecini")
        Dim fecfin As String = Request("fecfin")
        Dim gerente As Integer = Request("gerente")
        Dim ejecutivo As Integer = Request("ejecutivo")
        rptKardex(fecini, fecfin, cliente, gerente, ejecutivo, tipo)

        'Select Case prm.tname
        ' Case "kardex"
        ' End Select
    End Sub
End Class
