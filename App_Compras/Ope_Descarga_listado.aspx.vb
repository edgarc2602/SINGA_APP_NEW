﻿Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_Operaciones_Ope_Descarga_listado
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

    Protected Sub rptlistado(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer)
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()


        sqlbr.Append("select  ROW_NUMBER()Over(Order by a.nombre) As RowNum, a.id_inmueble, a.nombre, isnull(b.id_listado,0) as id_listado, isnull(d.descripcion,'') as tipo, case when b.id_status = 1 then 'Alta' when b.id_status = 2 then  " & vbCrLf)
        sqlbr.Append("'Aprobado' when b.id_status = 3 then 'Despachado' when b.id_status = 4 then 'Entregado' when b.id_status = 5 then 'Cancelado' else 'No existe' end as estatus," & vbCrLf)
        sqlbr.Append("convert(varchar(12), falta, 103) as falta," & vbCrLf)
        sqlbr.Append("cast(isnull(SUM(c.cantidad * c.precio),0) as numeric(12,2)) as total" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_listadomaterial b on a.id_inmueble = b.id_inmueble and mes = " & mes & " and anio = " & anio & "" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald c on b.id_listado = c.id_listado left outer join tb_tipolistado d on b.tipo = d.id_tipo" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & " and a.id_status = 1 group by a.id_inmueble, a.nombre, b.falta, b.id_listado, b.id_status,d.descripcion")

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "listados")
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load



        Dim cliente As Integer = Request("cliente")
        Dim mes As Integer = Request("mes")
        Dim anio As Integer = Request("anio")


        rptlistado(cliente, mes, anio)
    End Sub
End Class