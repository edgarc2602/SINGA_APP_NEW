Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class Ventas_App_Ven_Cat_Cliente_encargado
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal puesto As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' ' + paterno + ' ' +  rtrim(materno) as empleado from tb_empleado" & vbCrLf)
        If puesto = 39 Then
            sqlbr.Append("where id_puesto in(39,40)" & vbCrLf)
        Else
            sqlbr.Append("where id_puesto = " & puesto & "" & vbCrLf)
        End If
        sqlbr.Append(" and id_status = 2 order by empleado ")
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
    Public Shared Function cliente(ByVal encargado As Integer, ByVal area As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_cliente as 'td','', nombre as 'td'" & vbCrLf) ','',
        'sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append("from tb_cliente where id_status = 1")
        Select Case area
            Case 53
                sqlbr.Append("and id_comprador =" & encargado & "")
            Case 30
                sqlbr.Append("and id_operativo =" & encargado & "")
            Case 107
                sqlbr.Append("and id_mantenimiento =" & encargado & "")
            Case 39
                sqlbr.Append("and id_coordinadorrh =" & encargado & "")
            Case 40
                sqlbr.Append("and id_coordinadorrh =" & encargado & "")
        End Select

        sqlbr.Append("order by nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function clientes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 ")
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
    Public Shared Function actualiza(ByVal tipo As String, ByVal empleado As Integer, ByVal cliente As Integer) As String

        Dim sql As String = ""
        Select Case tipo
            Case 53
                sql = "Update tb_cliente set id_comprador = " & empleado & " where id_cliente =" & cliente & ";"
            Case 30
                sql = "Update tb_cliente set id_operativo = " & empleado & " where id_cliente =" & cliente & ";"
            Case 107
                sql = "Update tb_cliente set id_mantenimiento = " & empleado & " where id_cliente =" & cliente & ";"
            Case 39
                sql = "Update tb_cliente set id_coordinadorrh = " & empleado & " where id_cliente =" & cliente & ";"
            Case 40
                sql = "Update tb_cliente set id_coordinadorrh = " & empleado & " where id_cliente =" & cliente & ";"
            Case 66
                sql = "Update tb_cliente set id_factura = " & empleado & " where id_cliente =" & cliente & ";"
        End Select
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ejecuta(ByVal tipo As String, ByVal empleado As Integer, ByVal anterior As Integer) As String

        Dim sql As String = ""
        Select Case tipo
            Case 53
                sql = "Update tb_cliente set id_comprador = " & empleado & " where id_comprador =" & anterior & ";"
            Case 30
                sql = "Update tb_cliente set id_operativo = " & empleado & " where id_operativo =" & anterior & ";"
            Case 107
                sql = "Update tb_cliente set id_mantenimiento = " & empleado & " where id_mantenimiento =" & anterior & ";"
            Case 39
                sql = "Update tb_cliente set id_coordinadorrh = " & empleado & " where id_coordinadorrh =" & anterior & ";"
            Case 40
                sql = "Update tb_cliente set id_coordinadorrh = " & empleado & " where id_coordinadorrh =" & anterior & ";"
                'Case 66
                '    sql = "Update tb_cliente set id_factura = " & empleado & " where id_factura =" & anterior & ";"
        End Select
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
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
