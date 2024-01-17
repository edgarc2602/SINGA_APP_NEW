Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Mantenimiento_Man_Cat_FormatosPreventivo
    Inherits System.Web.UI.Page


    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function guarda(cliente As Integer) As String

        Dim sql = "insert into tb_formatoslistatrabajos_preventivo (id_cliente, id_status) values(" & cliente & ", 1)"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardapr(idformato As Integer, idtrabajo As Integer, idpunto As Integer) As String

        Dim sql = "insert into tb_trabajospunto_preventivo (id_formatolistatrabajo_preventivo, id_trabajo_preventivo, id_punto, id_status) values(" & idformato.ToString() & "," & idtrabajo.ToString() & "," & idpunto.ToString() & ", 1)"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function formatospreventivo(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_formatolistatrabajo_preventivo as 'td','', cliente as 'td','', " & vbCrLf)
        sqlbr.Append("(select id_formatolistatrabajo_preventivo as '@idformato', 'btn btn-primary btver' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by c.nombre) As RowNum, id_formatolistatrabajo_preventivo, c.nombre as cliente" & vbCrLf)
        sqlbr.Append("from tb_formatoslistatrabajos_preventivo f join tb_cliente c on f.id_cliente = c.id_cliente where f.id_status = 1 and c.id_status = 1" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by cliente for xml path('tr'), root('tbody')")

        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function formato(idformato As Integer, pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select nombrepunto as 'td','', descripciontrabajo as 'td','', nombrearea as 'td','', " & vbCrLf)
        sqlbr.Append("(select id_trabajopunto_preventivo as '@idtrabajopunto', 'btn btn-danger btborra' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by p.id_arearevision_preventivo) As RowNum, id_trabajopunto_preventivo, t.descripcion as descripciontrabajo, p.nombre as nombrepunto, p.id_arearevision_preventivo as area, a.nombre as nombrearea " & vbCrLf)
        sqlbr.Append("from tb_trabajospunto_preventivo tp join tb_trabajos_preventivo t on t.id_trabajo_preventivo = tp.id_trabajo_preventivo join tb_puntosrevision_preventivo p on p.id_puntorevision_preventivo = tp.id_punto join tb_areasrevision_preventivo a on a.id_arearevision_preventivo = p.id_arearevision_preventivo where tp.id_status = 1 and tp.id_formatolistatrabajo_preventivo = " + idformato.ToString() & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 10 And " & pagina & " * 10 order by area for xml path('tr'), root('tbody')")

        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contartrabajos(idformato As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/10 + 1 as Filas, COUNT(*) % 10 as Residuos FROM tb_trabajospunto_preventivo" & vbCrLf)

        Dim ds As New DataTable
        Dim myconnection As String = (New Conexion).StrConexion
        Dim comm As New SqlDataAdapter(sqlbr.ToString(), myconnection)
        comm.Fill(ds)
        sql = "["
        If ds.Rows.Count > 0 Then
            For x As Integer = 0 To ds.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{pag:" & ds.Rows(x)("Filas") & "}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function area() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_arearevision_preventivo, nombre from tb_areasrevision_preventivo where id_status = 1 order by nombre" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_arearevision_preventivo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.id_cliente, a.nombre  from tb_cliente a inner join tb_cliente_lineanegocio b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("left join tb_formatoslistatrabajos_preventivo f on f.id_cliente <> a.id_cliente where a.id_status =1 and b.id_lineanegocio= 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_cliente") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function puntos() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select p.id_puntorevision_preventivo, p.nombre as punto, a.nombre as area from tb_puntosrevision_preventivo p join tb_areasrevision_preventivo a on a.id_arearevision_preventivo = p.id_arearevision_preventivo " & vbCrLf)
        sqlbr.Append("where a.id_status = 1 and p.id_status = 1  order by area, punto")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_puntorevision_preventivo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("area") & " - " & dt.Rows(x)("punto") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function trabajos() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_trabajo_preventivo, descripcion from tb_trabajos_preventivo " & vbCrLf)
        sqlbr.Append("where id_status = 1  order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_trabajo_preventivo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function borrartrabajopunto(idtrabajopunto As Integer) As String

        Dim sql = "delete from tb_trabajospunto_preventivo where id_trabajopunto_preventivo = @idtrabajopunto"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        mycommand.Parameters.AddWithValue("@idtrabajopunto", idtrabajopunto)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub


End Class
