Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Empleado_Conftrans
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
    Public Shared Function transferencias(ByVal cliente As Integer, ByVal inmueble As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("SELECT (select 'symbol1 icono1 tbeditar' as '@class', 'Confirmar Transferencia' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbrechaza' as '@class', 'Rechazar Transferencia' as '@title' for xml path('span'),root('td'),type),'',")
        sqlbr.Append("a.id_empleado as 'td','', c.nombre as 'td','', f.nombre  as 'td','', " & vbCrLf)
        sqlbr.Append("RTrim(b.paterno) + ' ' + rtrim(b.materno) + ' ' + b.nombre as 'td','', isnull(convert(varchar(10),a.ftransfiere,103),'') as 'td','', " & vbCrLf)
        sqlbr.Append("d.descripcion as 'td','', e.descripcion as 'td','',b.jornal as 'td','',  isnull(convert(varchar(10),b.fingreso,103),'') as 'td',''," & vbCrLf)
        sqlbr.Append("a.id_inmueblede as 'td','', a.id_inmueblea as 'td','', f.id_cliente as 'td'")
        sqlbr.Append("From tb_empleado_transfiere a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueblede = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble f on a.id_inmueblea = f.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_puesto d on b.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno e on b.id_turno = e.id_turno" & vbCrLf)
        sqlbr.Append("where a.aplicado = 0 " & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append("and b.id_cliente = " & cliente & "")
        End If
        If inmueble <> 0 Then
            sqlbr.Append("and a.id_inmueblede = " & inmueble & "")
        End If
        sqlbr.Append("order by c.nombre, b.paterno, b.materno, b.nombre  " & vbCrLf)
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
    Public Shared Function transfiereemp(ByVal empleado As Integer, ByVal inmueblede As Integer, ByVal inmueblea As Integer, ByVal cliente As Integer) As String

        Dim sql As String = "Update tb_empleado set id_inmueble = " & inmueblea & ", id_cliente =" & cliente & " where id_empleado =" & empleado & ";"
        sql += "delete from tb_empleado_inmueble where id_empleado = " & empleado & " and id_inmueble = " & inmueblede & ";"
        sql += "insert into tb_empleado_inmueble (id_empleado, id_inmueble) values (" & empleado & "," & inmueblea & ");"
        sql += " update tb_empleado_transfiere set aplicado = 1, faplicacion = getdate() where id_empleado = " & empleado & ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        'Dim generacorreo As New enviocorreo()
        'generacorreo.correoempleado(fecha, "Activación de Empleado", cliente, puesto, sucursal, persona, vacante, usuario)

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
