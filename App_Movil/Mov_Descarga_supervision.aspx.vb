Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_Movil_Mov_Descarga_supervision
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

    Protected Sub rptencuesta(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal supervisor As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        Dim vfecini As Date, vfecfin As Date
        If fini <> "" Then vfecini = fini
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_supervision, fecha, id_cliente, cliente, id_inmueble, inmueble, usuario," & vbCrLf)
        sqlbr.Append("entrevista, clientenombre, califsrv from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by a.id_supervision) as rownum, id_supervision, isnull(convert(varchar(12),a.fechaini,103),'') as fecha, " & vbCrLf)
        sqlbr.Append("a.id_cliente, b.nombre as cliente, a.id_inmueble, c.nombre as inmueble, d.per_nombre + ' ' + Per_Paterno as usuario, " & vbCrLf)
        sqlbr.Append("case when clienteentrevista = 1 then 'Si' else 'No'end as entrevista, clientenombre, " & vbCrLf)
        sqlbr.Append("case when evalua = 3 then 'Bueno' when evalua= 2 then 'Regular' when evalua = 1 then 'Malo' else 'No califica' end as califsrv" & vbCrLf)
        sqlbr.Append("from tb_supervision a inner join tb_cliente b ON a.id_cliente=b.id_cliente " & vbCrLf)
        sqlbr.Append("LEFT OUTER JOIN tb_cliente_inmueble c ON a.id_inmueble=c.id_inmueble " & vbCrLf)
        sqlbr.Append("LEFT OUTER JOIN Personal d ON a.usuario=d.IdPersonal where a.id_cliente != 0" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.fechaini as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        If supervisor <> 0 Then sqlbr.Append("and a.usuario = " & supervisor & "" & vbCrLf)
        sqlbr.Append(")as tabla order by fecha, cliente, inmueble ")
        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "supervision")
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)

        Dim fecini As String = Trim(Request("fecini"))
        Dim fecfin As String = Trim(Request("fecfin"))
        Dim cliente As Integer = Request("cliente")
        Dim supervisor As Integer = Request("supervisor")

        rptencuesta(fecini, fecfin, cliente, supervisor)

        'Select Case prm.tname
        ' Case "kardex"
        ' End Select
    End Sub
End Class
