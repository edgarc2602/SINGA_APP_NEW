Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_AsignaCoordina
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function gerente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado, nombre + ' ' + rtrim(paterno) + ' ' + rtrim(materno) as nombre from tb_empleado where id_puesto in(30,31) and esencargado = 1 and id_status = 2 order by nombre, paterno")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function coordinador() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado, nombre + ' ' + rtrim(paterno) + ' ' + rtrim(materno) as nombre from tb_empleado where escoordinador = 1 and id_puesto in (39,40,108,83,26,116) and id_status = 2 order by nombre, paterno, materno")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function cgo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado, nombre + ' ' + rtrim(paterno) + ' ' + rtrim(materno) as nombre from tb_empleado where id_puesto = 5 and escoordinador = 1 and id_status = 2 order by nombre, paterno")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asignados(ByVal gerente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_coordinador, id_cgo from tb_gerente_coordinador where id_gerente = " & gerente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{coordrg:'" & dt.Rows(0)("id_coordinador") & "'," & vbCrLf
            sql += "coordcgo:'" & dt.Rows(0)("id_cgo") & "'}" & vbCrLf
        Else
            sql += "{coordrg:'" & 0 & "'," & vbCrLf
            sql += "coordcgo:'" & 0 & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda1(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_coordinarecluta", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function recluta(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', nombre as 'td','', (select 'symbol1 icono1 tbeditar' as '@class', 'checkbox' as '@type',"&vbCrLf)
        sqlbr.Append("case when id_coordina = " & empleado & " then 'checked' end as '@checked' for xml path('input'), root('td'),type) from (" & vbCrLf)
        sqlbr.Append("select id_empleado, paterno + ' ' + rtrim(materno) + ' ' + nombre as nombre, isnull(b.id_coordinador,0) as id_coordina"&vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_coordina_recluta b on a.id_empleado = b.id_reclutador and b.id_coordinador = " & empleado & "" & vbCrLf)
        sqlbr.Append("where id_puesto in(26,39,1140,1141,1142) and a.id_status = 2) as tabla order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function guarda(ByVal gerente As Integer, ByVal coordrh As Integer, ByVal coordcgo As Integer) As String

        Dim sql As String = "delete from tb_gerente_coordinador where id_gerente =" & gerente & ";"
        sql += "insert into tb_gerente_coordinador values(" & gerente & "," & coordrh & ", " & coordcgo & ");"
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
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
