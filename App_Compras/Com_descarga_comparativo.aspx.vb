Imports System.Data
Imports System.Data.SqlClient
Partial Class App_Compras_Com_descarga_comparativo
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

    Protected Sub rptlistado(ByVal comprador As Integer, ByVal gerente As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal tipo As String)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select cliente, cast(isnull(ptto,0) as numeric(12,2)) as ptto, cast(isnull(utilizado,0) as numeric(12,2)) as utilizado, "& vbCrLf)
        sqlbr.Append("cast(isnull(ptto,0) - isnull(utilizado,0) as numeric(12,2)) as variacion, gerente, comprador from (" & vbCrLf)
        sqlbr.Append("select c.nombre as cliente,  sum((cantidad * precio)) as utilizado,"& vbCrLf)
        sqlbr.Append("(select sum(importe) from tb_cliente_material d where id_cliente = c.id_cliente and id_status =1" & vbCrLf)
        sqlbr.Append("and id_concepto in(1,2)) ptto, d.nombre + ' ' + d.paterno + ' ' + rtrim(d.materno) as gerente, e.nombre + ' ' + e.paterno + ' ' + rtrim(e.materno) as comprador" & vbCrLf)
        sqlbr.Append("from tb_listadomaterial a inner join tb_listadomateriald b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on a.id_cliente = c.id_cliente inner join tb_empleado d on c.id_operativo = d.id_empleado"& vbCrLf)
        sqlbr.Append("inner join tb_empleado e on c.id_comprador = e.id_empleado " & vbCrLf)
        sqlbr.Append("where mes = " & mes & " and anio = " & anio & " and a.id_status != 5 " & vbCrLf)
        sqlbr.Append("and a.tipo in(" & tipo & ")" & vbCrLf)
        If comprador <> 0 Then sqlbr.Append("and c.id_comprador = " & comprador & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "" & vbCrLf)
        sqlbr.Append("group by c.nombre, c.id_cliente, d.nombre, d.paterno, d.materno, e.nombre, e.paterno, e.materno) tabla order by cliente ")

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "listados")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim comprador As Integer = Request("comprador")
        Dim gerente As Integer = Request("gerente")
        Dim mes As Integer = Request("mes")
        Dim anio As Integer = Request("anio")
        Dim tipo As String = Request("tipo")


        rptlistado(comprador, gerente, mes, anio, tipo)
    End Sub
End Class
