Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Empleado_Baja
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleados(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select cliente as 'td','', inmueble  as 'td','', id_empleado as 'td','', empleado as 'td',''," & vbCrLf)
        sqlbr.Append("rfc as 'td','',  curp as 'td','', ss as 'td','', convert(varchar(17), fregistro,13) as 'td','', convert(varchar(10),fprogramada,103) as 'td'" & vbCrLf)
        sqlbr.Append("from(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by b.id_empleado) As RowNum, c.nombre as cliente,  d.nombre as inmueble,  b.id_empleado,  b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado," & vbCrLf)
        sqlbr.Append("b.rfc,  b.curp, b.ss, a.fregistro, a.fprogramada" & vbCrLf)
        sqlbr.Append("From tb_empleado_baja a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble" & vbCrLf)
        sqlbr.Append("where finanzas = 0) as tabla " & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 100 + 1 And " & pagina & " * 100 order by empleado " & vbCrLf)
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
    Public Shared Function contarempleado() As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/100 + 1 as Filas, COUNT(*) % 100 as Residuos FROM tb_empleado_baja where finanzas = 0" & vbCrLf)

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
    Public Shared Function baja(ByVal fecha As String, ByVal empleado As String) As String 'ByVal tipo As Integer, 

        Dim vfec As Date = fecha
        Dim sql As String = ""
        sql = "Update tb_empleado_baja set finanzas = 1, fbajafin = '" & Format(vfec, "yyyyMMdd") & "' where id_empleado =" & empleado & ";"
        sql += "Update tb_empleado set  fbaja = '" & Format(vfec, "yyyyMMdd") & "' where id_empleado =" & empleado & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function transfiere(ByVal cliente As Integer, ByVal inmueble As String, ByVal fecha As String, ByVal empleado As Integer) As String

        Dim vfec As Date = fecha
        Dim sql As String = ""
        sql = "Update tb_empleado_baja set transferido = 1, id_cliente = " & cliente & ", id_inmueble = '" & inmueble & "', ftransfiere = '" & Format(vfec, "yyyyMMdd") & "' where id_empleado =" & empleado & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1  order by nombre")
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
