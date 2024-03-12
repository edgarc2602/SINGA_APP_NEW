Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_Operaciones_Ope_DescargalistadoG
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

                'If data.Columns.Item(i).ColumnName = "clabe" Then
                ' context.Response.Write("<td>" & Format(ren(i).ToString(), "0") & "</td>")
                ' End If
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

    Protected Sub rptListado(ByVal mes As Integer, ByVal anio As Integer, ByVal gerente As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select f.nombre + ' ' + f.paterno + ' ' + rtrim(f.materno) as gerente, c.nombre as Cliente, a.id_inmueble, a.nombre as Sucursal, isnull(b.id_listado,0) Listado, case when b.id_status = 1 then 'Alta' when b.id_status = 2 then 'Autorizado' when b.id_status = 4 then 'Entregado' end as Estatus," & vbCrLf)
        sqlbr.Append("case when b.tipo = 1 then 'Iguala' when b.tipo = 2 then 'Adicionales' when b.tipo = 3 then 'Complemento'" & vbCrLf)
        sqlbr.Append("when b.tipo = 4 then 'Pulido' end as Tipo, convert(varchar(12),b.falta, 103) as 'F Alta', isnull(sum(cantidad * precio),0) as Costo, e.descripcion as Estado" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a " & vbCrLf)
        sqlbr.Append("left outer join tb_listadomaterial b on a.id_inmueble = b.id_inmueble and mes = " & mes & " and anio =" & anio & " and b.id_status != 5 " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on a.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald d on b.id_listado = d.id_listado" & vbCrLf)
        sqlbr.Append("INNER join tb_estado e on a.id_estado = e.id_estado" & vbCrLf)
        sqlbr.Append("inner join tb_empleado f on c.id_operativo = f.id_empleado" & vbCrLf)
        sqlbr.Append("where a.id_status = 1 and materiales = 0" & vbCrLf)
        If gerente <> 0 Then
            sqlbr.Append("and c.id_operativo = " & gerente & "" & vbCrLf)
        End If
        sqlbr.Append("group by f.nombre, f.paterno, f.materno, c.nombre, a.id_inmueble, a.nombre, b.id_listado, b.id_status, b.tipo, falta, e.descripcion " & vbCrLf)
        sqlbr.Append("order by gerente, c.nombre, a.nombre" & vbCrLf)

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "listados")
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()

        Dim mes As Integer = Request("mes")
        Dim anio As Integer = Request("anio")
        Dim gerente As Integer = Request("gerente")
        rptListado(mes, anio, gerente)
    End Sub

End Class
