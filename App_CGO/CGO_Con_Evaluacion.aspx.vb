Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_CGO_CGO_Con_Evaluacion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from Tb_Cliente where id_status = 1" & vbCrLf)
        'If idcliente <> 0 Then sqlbr.Append("and id_cliente = " & idcliente & "" & vbCrLf)
        sqlbr.Append("order by nombre")
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
    Public Shared Function elaborado() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct id_usuario, b.Per_Nombre + ' ' + b.Per_Paterno + ' ' + Per_Materno as usuario" & vbCrLf)
        sqlbr.Append("from tb_encuesta_registro a inner join Personal b on a.id_usuario = b.IdPersonal ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_usuario") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("usuario") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function encuestas(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal inmueble As Integer, ByVal pagina As Integer, ByVal gerente As Integer, ByVal cgo As Integer, ByVal comprador As Integer, ByVal supervisor As Integer, ByVal elabora As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_campania as 'td','', cliente as 'td','', inmueble as 'td','', encuesta as 'td','', fecha as 'td','', encuestado as 'td','', " & vbCrLf)
        sqlbr.Append("resul1 as 'td','', resul2 as 'td','', resul3 as 'td','', resul4 as 'td','', resul5 as 'td' from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER() over (order by b.nombre, c.nombre, fecha) as rownum , id_campania, b.nombre as cliente, c.nombre as inmueble, " & vbCrLf)
        sqlbr.Append("d.descripcion as encuesta, convert(varchar(12),fecha,103) as fecha, encuestado, resul1, resul2, resul3, resul4, resul5" & vbCrLf)
        sqlbr.Append("from tb_encuesta_registro a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_encuesta_nombre d on a.id_encuesta = d.id_encuesta" & vbCrLf)
        sqlbr.Append("where a.id_status = 1" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and a.fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente =" & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble =" & inmueble & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and a.id_gerente =" & gerente & "" & vbCrLf)
        If cgo <> 0 Then sqlbr.Append("and a.id_cgo =" & cgo & "" & vbCrLf)
        If comprador <> 0 Then sqlbr.Append("and a.id_comprador =" & comprador & "" & vbCrLf)
        If supervisor <> 0 Then sqlbr.Append("and a.id_supervisor =" & supervisor & "" & vbCrLf)
        If elabora <> 0 Then sqlbr.Append("and a.id_usuario =" & elabora & "" & vbCrLf)
        sqlbr.Append(") tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by cliente, inmueble, fecha " & vbCrLf)
        sqlbr.Append("for xml path('tr'), root('tbody')")
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
    Public Shared Function contarencuesta(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal inmueble As Integer, ByVal gerente As Integer, ByVal cgo As Integer, ByVal comprador As Integer, ByVal supervisor As Integer, ByVal elabora As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_encuesta_registro" & vbCrLf)
        sqlbr.Append("where id_status = 1" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and fecha between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and id_cliente =" & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and id_inmueble =" & inmueble & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and id_gerente =" & gerente & "" & vbCrLf)
        If cgo <> 0 Then sqlbr.Append("and id_cgo =" & cgo & "" & vbCrLf)
        If comprador <> 0 Then sqlbr.Append("and id_comprador =" & comprador & "" & vbCrLf)
        If supervisor <> 0 Then sqlbr.Append("and id_supervisor =" & supervisor & "" & vbCrLf)
        If elabora <> 0 Then sqlbr.Append("and id_usuario =" & elabora & "" & vbCrLf)
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
    Public Shared Function gerente(ByVal puesto As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 ")
        If puesto = 1000 Then
            sqlbr.Append("And id_puesto in(20,30,5) " & vbCrLf)
        Else
            sqlbr.Append("And id_puesto = " & puesto & "")
        End If
        sqlbr.Append("order by empleado")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("empleado") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function atiende(ByVal area As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT idpersonal, Per_Nombre+' '+Per_Paterno+' '+Per_Materno as nombre FROM personal" & vbCrLf)
        sqlbr.Append(" where per_status= 0 and idarea = " & area & "" & vbCrLf)
        sqlbr.Append("order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        'idcliente1.Value = Request.Cookies("Cliente").Value

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
