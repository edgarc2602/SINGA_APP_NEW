Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_RH_RH_Descarga_vacante
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

    Protected Sub rptvacante(ByVal cliente As String, ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal sucursal As Integer, ByVal gerente As Integer, ByVal folio As Integer, ByVal estado As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        Dim vfecini As Date, vfecfin As Date
        If fini <> "" Then vfecini = fini
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select ROW_NUMBER()Over(Order by a.id_vacante) As RowNum, a.id_vacante, a.id_cliente, b.nombre as cliente, c.descripcion as estado, a.id_inmueble, j.nombre as sucursal, d.nombre + ' '+ rtrim(d.paterno) + ' ' + rtrim(d.materno) as gerente," & vbCrLf)
        sqlbr.Append("convert(varchar(10), fechaalta, 103) As fechaalta, " & vbCrLf)
        sqlbr.Append("CASE WHEN id_tipo = 1 then 'Urgente' else 'Programada' end tipo," & vbCrLf)
        sqlbr.Append("isnull(e.nombre + ' '+ rtrim(e.paterno) + ' ' + rtrim(e.materno),'') as coordinador,  isnull(convert(varchar(10),fechaobj,103),'') as fechaobj," & vbCrLf)
        sqlbr.Append("case when DATEDIFF(day, getdate() , fechaobj) between 4 and 5 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 1 and 3 and id_tipo = 1 and a.id_status = 1 then (select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 8 and 10 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 1 and 5 and id_tipo = 2 and a.id_status = 1 Then (Select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("    when a.id_status != 1 then (select 'tbborrar colorgris' as '@class' for xml path('span'), type)end as bandera, " & vbCrLf)
        sqlbr.Append("case when a.id_status =1 then 'Sin cubrir' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 2 then 'Cubierta por confirmar' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 3 then 'Confirmado-Activo' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 4 then 'Cancelada' end as estatus, " & vbCrLf)
        sqlbr.Append("isnull(g.nombre + ' ' + rtrim(g.paterno), ' ') as reclutador, j.direccion + ' ' + j.colonia + ' ' + j.delegacionmunicipio + ' ' + j.cp + ' ' + c.descripcion as direccion," & vbCrLf)
        sqlbr.Append("k.descripcion as puesto, cast(isnull(i.smntope,0) as numeric(12,2)) As sueldo, " & vbCrLf)
        sqlbr.Append("case when i.sexo = 1 then 'Masculino' " & vbCrLf)
        sqlbr.Append("	when i.sexo = 2 then 'Femenino' else 'Indistinto' end as sexo," & vbCrLf)
        sqlbr.Append("f.descripcion as turno, isnull('Horario: ' + horariode + ' a ' + horarioa + ' Dias laborables: ' + i.diade + ' a ' + i.diaa + ' Descanso: ' + i.diadescanso,'') as horario, a.observacion" & vbCrLf)
        sqlbr.Append("From tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble j on a.id_inmueble = j.id_inmueble " & vbCrLf)
        sqlbr.Append("left outer join tb_estado c on j.id_estado = c.id_estado " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado d on b.id_operativo = d.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_gerente_coordinador h on b.id_operativo = h.id_gerente " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado e on h.id_coordinador = e.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado g on a.id_reclutador = g.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_plantilla i on a.id_plantilla  = i.id_plantilla" & vbCrLf)
        sqlbr.Append("left outer join tb_turno f on i.id_turno = f.id_turno left outer join tb_puesto k on i.id_puesto = k.id_puesto " & vbCrLf)
        sqlbr.Append("where a.id_status =  " & estatus & "  " & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and a.id_vacante = " & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        If sucursal <> 0 Then sqlbr.Append("and a.id_inmueble = " & sucursal & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and b.id_operativo  = " & gerente & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and j.id_estado  = " & estado & "" & vbCrLf)
        If vfecini <> Nothing Then sqlbr.Append("And CAST(a.fechaalta As Date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "' order by fechaalta, id_vacante" & vbCrLf)

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "vacantes")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)

        Dim cliente As Integer = Request("cliente")
        Dim fecini As String = Trim(Request("fecini"))
        Dim fecfin As String = Trim(Request("fecfin"))
        Dim estatus As Integer = Request("estatus")
        Dim sucursal As Integer = Request("sucursal")
        Dim gerente As Integer = Request("gerente")
        Dim estado As Integer = Request("estado")
        Dim folio As Integer = Request("folio")


        rptvacante(cliente, fecini, fecfin, estatus, sucursal, gerente, folio, estado)

    End Sub
End Class
