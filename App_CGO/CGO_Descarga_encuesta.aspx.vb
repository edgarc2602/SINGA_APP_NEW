Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_CGO_CGO_Descarga_encuesta
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

    Protected Sub rptencuesta(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal inmueble As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        Dim vfecini As Date, vfecfin As Date
        If fini <> "" Then vfecini = fini
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_campania, cliente, inmueble, encuesta, fecha, encuestado, " & vbCrLf)
        sqlbr.Append("personal, operaciones, cgo, material, Miscelaneos from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER() over (order by cliente, inmueble, fecha) as rownum, j.id_campania,j.cliente,j.inmueble, j.encuesta,j.fecha, " & vbCrLf)
        sqlbr.Append("j.encuestado, cast(i.[1] as numeric(12,0)) as personal, cast(i.[2] as numeric(12,0)) as operaciones, cast(i.[3] as numeric(12,0)) as cgo, " & vbCrLf)
        sqlbr.Append("cast(i.[4] as numeric(12,0)) as material, cast(i.[5] as numeric(12,0)) as Miscelaneos  from (" & vbCrLf)
        sqlbr.Append("Select id_campania, b.nombre as cliente, c.nombre as inmueble, d.descripcion as encuesta," & vbCrLf)
        sqlbr.Append("convert(varchar(12),fecha,103) as fecha, encuestado" & vbCrLf)
        sqlbr.Append("from tb_encuesta_registro a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_encuesta_nombre d on a.id_encuesta = d.id_encuesta" & vbCrLf)
        sqlbr.Append("where a.id_status = 1" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and a.fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente =" & cliente & "")
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble =" & inmueble & "")
        sqlbr.Append(") as j inner join (" & vbCrLf)
        sqlbr.Append("select id_campania, [1],[2],[3],[4],[5] from (" & vbCrLf)
        sqlbr.Append("	SELECT id_campania, id_grupo, cast(avg((valor / 5.0) * 100) as numeric(12,0)) promedio " & vbCrLf)
        sqlbr.Append("	FROM tb_encuesta_registrod where valor != 0 group by id_grupo, id_campania) as tabla" & vbCrLf)
        sqlbr.Append("PIVOT" & vbCrLf)
        sqlbr.Append("(" & vbCrLf)
        sqlbr.Append("AVG(promedio) for id_grupo in([1],[2],[3],[4],[5])" & vbCrLf)
        sqlbr.Append(") as result) i on j.id_campania = i.id_campania) tabla order by cliente, inmueble, fecha " & vbCrLf)
        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "encuesta")
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)

        Dim fecini As String = Trim(Request("fecini"))
        Dim fecfin As String = Trim(Request("fecfin"))
        Dim cliente As Integer = Request("cliente")
        Dim inmueble As Integer = Request("inmueble")

        rptencuesta(fecini, fecfin, cliente, inmueble)

        'Select Case prm.tname
        ' Case "kardex"
        ' End Select
    End Sub
End Class
