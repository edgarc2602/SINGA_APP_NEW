Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class Ventas_App_Ven_Descargainmueble
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

    Protected Sub rptinmueble(ByVal cliente As String)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select ROW_NUMBER()Over(Order by a.nombre) As RowNum, id_inmueble, isnull(c.nombre,'') as oficina, a.nombre, a.nosuc, " & vbCrLf)
        sqlbr.Append("(select isnull(SUM(cantidad),0)  from tb_cliente_plantilla where id_status = 1 and id_inmueble = a.id_inmueble) As plantilla," & vbCrLf)
        sqlbr.Append("a.direccion + ' ' + a.colonia + ' ' + a.cp + ' ' + a.delegacionmunicipio + ' ' + a.ciudad + ' ' + d.descripcion as direccion,"& vbCrLf)
        sqlbr.Append("cast(a.presupuestol as numeric (12,2)) as ptto1, cast(a.presupuestom as numeric (12,2)) as ptto2," & vbCrLf)
        sqlbr.Append("cast(a.presupuestoh as numeric (12,2)) As ptto3, cast(a.presupuestob As numeric (12,2)) As ptto4"& vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a" & vbCrLf)
        sqlbr.Append("left outer join tb_oficina c on a.id_oficina = c.id_oficina"& vbCrLf)
        sqlbr.Append("inner join tb_estado d on a.id_estado = d.id_estado " & vbCrLf)
        sqlbr.Append("where a.id_status = 1 and a.id_cliente = " & cliente & " " & vbCrLf)
        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "Inmuebles")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()


        Dim cliente As Integer = Request("cliente")

        rptinmueble(cliente)
    End Sub
End Class
