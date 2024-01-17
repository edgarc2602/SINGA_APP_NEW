Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Act_Vacante
    Inherits System.Web.UI.Page

    Public listamenu As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from tb_cliente  order by nombre")
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
    Public Shared Function vacantes(ByVal cliente As Integer, ByVal inmueble As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("SELECT (select 'symbol1 icono1 tbeditar' as '@class', 'Confirmar Ingreso' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbrechaza' as '@class', 'No Ingreso' as '@title' for xml path('span'),root('td'),type),'',")
        sqlbr.Append("id_empleado as 'td','', a.id_vacante as 'td','', case a.completar when 1 then 'INCOMPLETO' when 0 then 'COMPLETO' when null then 'COMPLETO' end as 'td', '', b.nombre as 'td','', c.nombre as 'td','', " & vbCrLf)
        sqlbr.Append("RTrim(a.paterno) + ' ' + rtrim(a.materno) + ' ' + a.nombre as 'td','',  rfc as 'td','', curp as 'td','', ss as 'td',''," & vbCrLf)
        sqlbr.Append("isnull(convert(varchar(10),f.fechaalta,103),'') as 'td','', isnull(convert(varchar(10),a.fregistro,103),'') as 'td','',")
        sqlbr.Append("d.descripcion as 'td','', e.descripcion as 'td','',a.jornal as 'td','',  isnull(convert(varchar(10),a.fingreso,103),'') as 'td',''," & vbCrLf)
        sqlbr.Append("isnull(g.descripcion,'')  as 'td','', isnull(a.cuenta,'') as 'td','', isnull(a.tarjeta,'') as 'td','', 'Cubierta por confirmar'as 'td'" & vbCrLf)
        sqlbr.Append("From tb_empleado a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_puesto d on a.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno e on a.id_turno = e.id_turno" & vbCrLf)
        sqlbr.Append("inner join tb_vacante f on a.id_vacante = f.id_vacante" & vbCrLf)
        sqlbr.Append("left outer join tb_banco g on a.id_banco = g.id_banco" & vbCrLf)
        sqlbr.Append("where a.id_status = 1" & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append("and a.id_cliente = " & cliente & "")
        End If
        If inmueble <> 0 Then
            sqlbr.Append("and a.id_inmueble = " & inmueble & "")
        End If
        sqlbr.Append("order by c.nombre, a.paterno, a.materno, a.nombre  for xml path('tr'), root('tbody')" & vbCrLf)

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
    Public Shared Function activaemp(ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal persona As String, ByVal empleado As Integer, ByVal vacante As Integer, ByVal usuario As Integer, ByVal rfc As String, ByVal curp As String, ByVal ss As String) As String

        Dim sql As String = "Update tb_empleado set id_status = 2, usuarioactiva= " & usuario & ", factiva = getdate() where id_empleado =" & empleado & ";"
        sql += "update tb_vacante set id_status = 3 where id_vacante = " & vacante & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        Dim generacorreo As New enviocorreo()
        generacorreo.correoempleado(fecha, "Activación de Empleado", cliente, puesto, sucursal, persona, vacante, usuario, rfc, curp, ss)

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reactivavacante(ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal persona As String, ByVal empleado As Integer, ByVal vacante As Integer, ByVal usuario As Integer) As String

        Dim sql As String = "Update tb_empleado set id_status = 4 where id_empleado =" & empleado & ";"
        sql += "update tb_vacante set id_status = 1 where id_vacante = " & vacante & ";"
        sql += "update tb_cliente_plantillap set id_empleado = 0 where id_empleado = " & empleado & ";"
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

    <Web.Services.WebMethod()>
    Public Shared Function noreactivavacante(ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal persona As String, ByVal empleado As Integer, ByVal vacante As Integer, ByVal usuario As Integer) As String

        Dim sql As String = "Update tb_empleado set id_status = 4 where id_empleado =" & empleado & ";"
        'sql += "update tb_vacante set id_status = 1 where id_vacante = " & vacante & ";"
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

    End Sub
End Class
