Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Empleadocuenta
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleados(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select b.nombre as 'td','', c.nombre as 'td','', a.id_empleado as 'td','' , paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td',''," & vbCrLf)
        sqlbr.Append("isnull(d.descripcion,'') as 'td','', isnull(clabe,'') as 'td','', isnull(a.cuenta,'') as 'td','', isnull(e.cuenta,'') as 'td','', a.id_banco as 'td','',")
        sqlbr.Append("numerop as 'td','', nombrep as 'td'")
        sqlbr.Append("from tb_empleado a left outer join tb_cliente b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_banco d on a.id_banco = d.id_banco"& vbCrLf)
        sqlbr.Append("left outer join tb_empleado_azteca e on a.id_empleado = e.id_empleado" & vbCrLf)
        sqlbr.Append("where a.id_status = 2")
        If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append(" order by b.nombre, c.nombre , a.paterno, a.materno, a.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function cambiobanco(ByVal empleado As Integer, ByVal bancoo As String, ByVal bancon As String, ByVal concepto As String, ByVal usuario As Integer) As String

        Dim sql As String = "insert into tb_empleado_cambio (id_empleado, dato1, dato2, operacion, idpersonal, fregistro) values (" & empleado & ", '" & bancoo & "','" & bancon & "','" & concepto & "'," & usuario & ", getdate());"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function banco() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_banco, descripcion from tb_banco order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_banco") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualizabanco(ByVal emp As Integer, ByVal banco As Integer, ByVal clabe As String, ByVal cuenta As String, ByVal clabed As String, ByVal numd As String, ByVal nombred As String) As String

        Dim sql As String = "Update tb_empleado set id_banco = " & banco & ", clabe ='" & clabe & "', cuenta ='" & cuenta & "' where id_empleado =" & emp & ";"
        'sql += "insert into tb_empleado_cambio (id_empleado, dato1, dato2, operacion, idpersonal, fregistro) values (" & emp & ", '" & bancoo & "','" & bancon & "','" & concepto & "'," & usuario & ", getdate());"
        sql += "delete from tb_empleado_azteca where id_empleado =" & emp & ";"
        sql += "insert into tb_empleado_azteca values (" & emp & ", '" & clabed & "','" & numd & "','" & nombred & "');"
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
