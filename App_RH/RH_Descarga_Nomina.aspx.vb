Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_RH_RH_Descarga_Nomina
    Inherits System.Web.UI.Page

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

    Protected Sub rptnomina(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, rtrim(c.nombre) as cliente, d.nombre as sucursal," & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, a.percepciones, a.deducciones, a.total from(" & vbCrLf)
        sqlbr.Append("select id_empleado, sum(percepcion) as percepciones, sum(deduccion) as deducciones, sum(percepcion) - sum(deduccion) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada where id_periodo =" & periodo & " and tipo = '" & tipo & "' and anio = " & anio & "" & vbCrLf)
        sqlbr.Append("group by id_empleado) as a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble")

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "Nomina")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)

        Dim periodo As Integer = Request("periodo")
        Dim tipo As String = Request("tipo")
        Dim anio As Integer = Request("anio")

        rptnomina(periodo, tipo, anio)

    End Sub
End Class
