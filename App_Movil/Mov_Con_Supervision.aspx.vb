Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Movil_Default
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from Tb_Cliente where id_status = 1" & vbCrLf)
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
    Public Shared Function encuestas(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal supervisor As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_supervision as 'td','',fecha as 'td','',cliente as 'td','', inmueble as 'td','',usuario as 'td',''," & vbCrLf)
        sqlbr.Append("entrevista as 'td','', clientenombre as 'td', '', califsrv as 'td' from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by a.id_supervision) as rownum, id_supervision, isnull(convert(varchar(12),a.fechaini,103),'') as fecha, " & vbCrLf)
        sqlbr.Append("b.nombre as cliente, c.nombre as inmueble, d.per_nombre + ' ' + Per_Paterno as usuario, " & vbCrLf)
        sqlbr.Append("case when clienteentrevista = 1 then 'Si' else 'No'end as entrevista, clientenombre, " & vbCrLf)
        sqlbr.Append("case when evalua = 3 then 'Bueno' when evalua= 2 then 'Regular' when evalua = 1 then 'Malo' else 'No califica' end as califsrv" & vbCrLf)
        sqlbr.Append("from tb_supervision a inner join tb_cliente b ON a.id_cliente=b.id_cliente " & vbCrLf)
        sqlbr.Append("LEFT OUTER JOIN tb_cliente_inmueble c ON a.id_inmueble=c.id_inmueble " & vbCrLf)
        sqlbr.Append("LEFT OUTER JOIN Personal d ON a.usuario=d.IdPersonal where a.id_cliente != 0" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.fechaini as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        If supervisor <> 0 Then sqlbr.Append("and a.usuario = " & supervisor & "" & vbCrLf)
        sqlbr.Append(")as tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by fecha, cliente, inmueble for xml path('tr'), root('tbody') ")
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
    Public Shared Function contarencuesta(ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal supervisor As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_supervision where id_cliente != 0" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(fechaini as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and id_cliente =" & cliente & "" & vbCrLf)
        If supervisor <> 0 Then sqlbr.Append("and usuario =" & supervisor & "" & vbCrLf)
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
    Public Shared Function empleado(ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado,nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 and " & tipo & " = 1 order by empleado")
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
    Public Shared Function supervisor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct usuario, b.Per_Nombre + ' ' + b.Per_Paterno + ' ' + b.Per_materno as supervisor" & vbCrLf)
        sqlbr.Append("from tb_supervision a inner join Personal b on a.usuario = b.IdPersonal" & vbCrLf)
        sqlbr.Append("order by supervisor ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("usuario") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("supervisor") & "'}" & vbCrLf
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
