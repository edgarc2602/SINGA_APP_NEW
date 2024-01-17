Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_Admin_Adm_Usuario_N
    Inherits System.Web.UI.Page

    Public listamenu As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cargausuario() As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select idpersonal as 'td','', (Per_Paterno + ' ' + per_materno + ' ' + Per_Nombre) as 'td','', isnull(d.descripcion,'')  as 'td','', per_usuario as 'td',''," & vbCrLf)
        sqlbr.Append("convert(varchar(10),Fecha_Alta ,103) As 'td','', case when per_status = 0 then 'Activo' else 'Inactivo' end as 'td'" & vbCrLf)
        sqlbr.Append("from personal a left outer join tb_empleado c on a.id_empleado = c.id_empleado left outer join tb_puesto d on c.id_puesto = d.id_puesto where per_status in(0,1) order by Per_Paterno, Per_Materno" & vbCrLf)
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
    Public Shared Function area() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT IdArea, Ar_Nombre FROM tbl_area_Empresa WHERE ar_Estatus=0 order by ar_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdArea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("Ar_Nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function puesto() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_puesto, descripcion from tb_puesto where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_puesto") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function grupo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select IdGrupos,Gr_Nombre from Tbl_Per_Grupos where gr_status=0 order by gr_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdGrupos") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("Gr_Nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function datosusuario(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select per_status, Per_Paterno, Per_Materno, Per_Nombre, Per_Email, Per_Interno, per_password, " & vbCrLf)
        sqlbr.Append("paterno + ' ' + rtrim(materno) + ' '+ nombre as empleado, " & vbCrLf)
        sqlbr.Append("d.Ar_Descripcion as area, e.descripcion as puesto, isnull(IdGrupos,0) as idgrupo, per_elabora, per_revisa, per_autoriza" & vbCrLf)
        sqlbr.Append("from Personal a left outer join tbl_UsuarioGrupos b on a.IdPersonal = b.IdPersonal" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado c on a.id_empleado = c.id_empleado  " & vbCrLf)
        sqlbr.Append("left outer join Tbl_Area_Empresa d on c.id_area = d.idarea " & vbCrLf)
        sqlbr.Append("left outer join tb_puesto e on c.id_puesto = e.id_puesto where a.idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{status:'" & dt.Rows(0)("per_status") & "'," & vbCrLf
            sql += "paterno:'" & dt.Rows(0)("per_paterno") & "'," & vbCrLf
            sql += "materno:'" & dt.Rows(0)("per_materno") & "'," & vbCrLf
            sql += "nombre:'" & dt.Rows(0)("per_nombre") & "'," & vbCrLf
            sql += "mail:'" & dt.Rows(0)("per_email") & "'," & vbCrLf
            sql += "interno:'" & dt.Rows(0)("per_interno") & "'," & vbCrLf
            sql += "pass:'" & dt.Rows(0)("per_password") & "'," & vbCrLf
            sql += "empleado:'" & dt.Rows(0)("empleado") & "'," & vbCrLf
            sql += "area:'" & dt.Rows(0)("area") & "'," & vbCrLf
            sql += "puesto:'" & dt.Rows(0)("puesto") & "'," & vbCrLf
            sql += "grupo:'" & dt.Rows(0)("idgrupo") & "'," & vbCrLf
            sql += "elabora:'" & dt.Rows(0)("per_elabora") & "'," & vbCrLf
            sql += "revisa:'" & dt.Rows(0)("per_revisa") & "'," & vbCrLf
            sql += "autoriza:'" & dt.Rows(0)("per_autoriza") & "'," & vbCrLf
            sql += "}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_Usuario", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal usuario As String) As String

        Dim rw As Integer = 0

        Dim sql As String = "Update Personal set per_status = 2 where IdPersonal =" & usuario & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        rw = mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal nombre As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + nombre as 'td','',b.ar_descripcion as 'td','', c.descripcion as 'td' " & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join Tbl_Area_Empresa b on a.id_area = b.idarea inner join tb_puesto c on a.id_puesto = c.id_puesto" & vbCrLf)
        sqlbr.Append("where a.id_status = 2 and nombre + paterno + materno  like '%" & nombre & "%' ")
        sqlbr.Append("order by paterno, materno, nombre for xml path('tr'), root('tbody')")
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

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim usuario As HttpCookie
        'Dim cliente As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        'cliente = Request.Cookies("cliente")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value

        End If
        'If cliente IsNot Nothing Then
        'idcliente1.Value = Request.Cookies("cliente").Value
        'Response.Cookies("cliente").Expires = DateTime.Now
        'End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)

    End Sub
End Class
