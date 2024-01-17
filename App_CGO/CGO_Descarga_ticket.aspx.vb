Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_RH_CGO_Descarga_ticket
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

    Protected Sub rptticket(ByVal fini As String, ByVal ffin As String, ByVal mes As Integer, ByVal folio As Integer, ByVal cliente As Integer, ByVal area As Integer, ByVal estatus As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        Dim vfecini As Date, vfecfin As Date
        If fini <> "" Then vfecini = fini
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select ROW_NUMBER() over (order by id_ticket) as rownum, a.no_ticket, tk_folio, " & vbCrLf)
        sqlbr.Append("case when Tk_Estatus =0 then 'Alta' when tk_estatus = 1 then 'Atendido' when tk_estatus = 2 then 'Cerrado' when tk_estatus = 3 then 'Cancelado' when tk_estatus = 4 then 'Cerrado sin cubrir' end estatus," & vbCrLf)
        sqlbr.Append("convert(varchar(10),Tk_FechaAlta, 103) falta, convert(varchar(5),Tk_HoraAlta,108) halta, " & vbCrLf)
        sqlbr.Append("convert(varchar(17),fnotifica, 113) fnotifica, convert(varchar(17),fescala, 113) fescala, " & vbCrLf)
        sqlbr.Append("isnull(convert(varchar(10),Tk_FechaTermino,103),'') ffin, isnull(convert(varchar(5), Tk_HoraTermino,108) ,'') hter, case when Tk_FechaTermino is null  then '' else DATEDIFF(day,Tk_FechaAlta ,Tk_FechaTermino) end atn," & vbCrLf)
        sqlbr.Append("case when Tk_Estatus = 0 then DATEDIFF(day, Tk_FechaAlta , getdate()) else ''end pend, g.descripcion, case when ID_Ambito = 1 then 'Local' else 'Foraneo' end ambito," & vbCrLf)
        sqlbr.Append("b.nombre cliente, h.nombre inmueble, ubicacion, f.Tk_Inc_Descripcion, i.Tk_CuaOri_Descripcion, d.Ar_Descripcion, Tk_Descripcion, isnull(Tk_Accion_Correctiva,'') accc, isnull(Tk_Accion_Preventiva,'') accp, " & vbCrLf)
        sqlbr.Append("Tk_Reporta, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre ejecutivo, e.paterno + ' ' + e.materno + ' ' + e.nombre as gerente" & vbCrLf)
        sqlbr.Append("from Tbl_Ticket a left outer join tb_cliente b on a.ID_Cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("inner join Personal c on a.Tk_ID_Ejecutivo = c.IdPersonal left outer join Tbl_Area_Empresa d on a.id_area = d.IdArea" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado e on b.id_operativo = e.id_empleado inner join Tbl_tk_Incidencia f on a.ID_Incidencia = f.ID_Incidencia  " & vbCrLf)
        sqlbr.Append("inner join tb_mes g on a.Tk_MesServicio = g.id_mes left outer join tb_cliente_inmueble h on a.ID_Sucursal = h.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join Tbl_tk_CausaOrigen i on a.ID_CausaOrigen = i.ID_CausaOrigen" & vbCrLf)
        sqlbr.Append("left outer join tbl_ticket_escala j on a.no_ticket = j.no_ticket" & vbCrLf)
        'sqlbr.Append("where Tk_FechaAlta between '20200701' And '20200708' and tk_estatus = 0")
        sqlbr.Append("where Tk_FechaAlta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If estatus <> 99 Then sqlbr.Append("and tk_estatus = " & estatus & "")
        If mes <> 0 Then sqlbr.Append("and tk_messervicio =" & mes & "")
        If folio <> 0 Then sqlbr.Append("and a.no_ticket =" & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente =" & cliente & "")
        If area <> 0 Then sqlbr.Append("and a.id_area =" & area & "")

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "tickets")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)

        Dim fecini As String = Request("fecini")
        Dim fecfin As String = Request("fecfin")
        Dim mes As String = Request("mes")
        Dim folio As String = Request("folio")
        Dim cliente As Integer = Request("cliente")
        Dim area As Integer = Request("area")
        Dim estatus As Integer = Request("estatus")


        rptticket(fecini, fecfin, mes, folio, cliente, area, estatus)

        'Select Case prm.tname
        ' Case "kardex"
        ' End Select
    End Sub
End Class
