Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_empleadoexpediente
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 order by nombre")
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
    Public Shared Function inmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente & " order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_inmueble") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarempleado(ByVal cliente As String, ByVal inmueble As String, ByVal noemp As String, ByVal nombre As String, ByVal tipo As Integer, ByVal forma As Integer, ByVal estatus As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/80 + 1 as Filas, COUNT(*) % 80 as Residuos FROM tb_empleado a where id_status <> 0" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & " " & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & " " & vbCrLf)
        If noemp <> "" Then sqlbr.Append("and a.id_empleado = " & noemp & " " & vbCrLf)
        If nombre <> "" Then sqlbr.Append("and a.paterno+a.materno+a.nombre like '%" & nombre & "%' " & vbCrLf)
        If tipo <> 0 Then sqlbr.Append("and a.id_area = " & tipo & " " & vbCrLf)
        If forma <> 0 Then sqlbr.Append("and a.formapago = " & forma & " " & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and a.id_status = " & estatus & " " & vbCrLf)
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
    Public Shared Function empleado(ByVal pagina As Integer, ByVal cliente As String, ByVal inmueble As String, ByVal noemp As String, ByVal nombre As String, ByVal tipo As Integer, ByVal forma As Integer, ByVal estatus As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select (select 'btn btn-success tbeditar' as '@class', 'Doctos' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'','',id_empleado as 'td','', empleado as 'td','', tipo as 'td',''," & vbCrLf)
        sqlbr.Append("estatus as 'td','', cliente as 'td','', inmueble as 'td','', id_documento as 'td','', archivo as 'td' from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER() Over(Order by a.paterno, a.materno, a.nombre) As RowNum, " & vbCrLf)
        sqlbr.Append("a.id_empleado, a.paterno + ' ' + rtrim(a.materno) + ' ' + a.nombre as empleado, " & vbCrLf)
        sqlbr.Append("case when a.tipo =1 then 'Administrativo' when a.tipo =2 then 'Operarivo' when a.tipo = 3 then 'Jornalero' end as tipo," & vbCrLf)
        sqlbr.Append("case when a.id_status = 1 then 'Candidato' when a.id_status =2 then 'Activo' when a.id_status = 3 then 'Baja' when a.id_status = 4 then 'No se presento' end as estatus," & vbCrLf)
        sqlbr.Append("isnull(rtrim(b.nombre),'') as cliente, isnull(rtrim(e.nombre),'') as inmueble, " & vbCrLf)
        sqlbr.Append("case when i.id_documento = 2 then 'Si' else 'No' end as id_documento, i.descripcion as archivo" & vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_empresa c on a.id_empresa = c.id_empresa" & vbCrLf)
        sqlbr.Append("left outer join tb_puesto d on a.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado_documento i on a.id_empleado = i.id_empleado and id_documento = 2 where a.id_status <> 0" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & " " & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & " " & vbCrLf)
        If noemp <> "" Then sqlbr.Append("and a.id_empleado = " & noemp & " " & vbCrLf)
        If nombre <> "" Then sqlbr.Append("and a.paterno+a.materno+a.nombre like '%" & nombre & "%'  " & vbCrLf)
        If tipo <> 0 Then sqlbr.Append("and a.id_area = " & tipo & " " & vbCrLf)
        If forma <> 0 Then sqlbr.Append("and a.formapago = " & forma & " " & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and a.id_status = " & estatus & " " & vbCrLf)
        sqlbr.Append(") result where RowNum BETWEEN (" & pagina & " - 1) * 80 + 1 And " & pagina & " * 80  " & vbCrLf)
        sqlbr.Append("order by empleado for xml path('tr'), root('tbody')" & vbCrLf)

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
    Public Shared Function actualiza(ByVal empleado As String, ByVal archivo As String) As String

        Dim sql As String = "insert into tb_empleado_documento (id_empleado, id_documento, descripcion) values (" & empleado & ", 2, '" & archivo & "');"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = usuario.Value
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
