Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class Ventas_App_Ven_Cat_Prospecto_N
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function contarprospecto(ByVal campo As String, ByVal dato As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/20 + 1 as Filas, COUNT(*) % 20 as Residuos FROM tb_catprospecto a " & vbCrLf)
        If campo <> "0" Then
            'sqlbr.Append("and " & campo & " like '%" & dato & "%'" & vbCrLf)
            sqlbr.Append(" WHERE " & campo & " like '%" & dato & "%'" & vbCrLf)
        End If
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
    Public Shared Function cliente(ByVal pagina As Integer, ByVal campo As String, ByVal dato As String, ByVal idpersonal As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        '
        sqlbr.Append("SELECT id_catprospecto as 'td','', nombre as 'td','',  credito as 'td','', fechaini as 'td','', vigencia as 'td' from" & vbCrLf)
        'sqlbr.Append("contacto as 'td','', puesto as 'td','', telefono as 'td','',estatus as 'td' from" & vbCrLf)
        sqlbr.Append("(SELECT ROW_NUMBER()Over(Order by nombre) As RowNum, id_catprospecto, nombre, credito, isnull(convert(varchar(12), fechaini ,103),'') as fechaini, vigencia " & vbCrLf)
        'sqlbr.Append("isnull(a.contacto,'') as contacto, isnull(a.puesto,'') as puesto, isnull(telefono1,'') as telefono, case when c.id_cliente is null then 'Activo' else 'Programado para baja' end as estatus " & vbCrLf)
        sqlbr.Append("From tb_catprospecto) ")
        sqlbr.Append(" as result" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 20 + 1 And " & pagina & " * 20 order by nombre for xml path('tr'), root('tbody') ")


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
    Public Shared Function detalle(ByVal prospecto As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select nombre, credito, fechaini, vigencia " & vbCrLf)
        sqlbr.Append("From tb_catprospecto where id_catprospecto = " & prospecto & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        da.Fill(ds)
        Dim x As Integer = 0
        sql = "{"
        If ds.Tables(0).Rows().Count > 0 Then
            sql += "nombre:'" & ds.Tables(0).Rows(0).Item("nombre") & "', credito:'" & ds.Tables(0).Rows(0).Item("credito") & "', fechaini:'" & ds.Tables(0).Rows(0).Item("fechaini") & "', vigencia:'" & ds.Tables(0).Rows(0).Item("vigencia") & "'"
        End If
        sql += "}"
        Return sql

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal area As Integer, ByVal tipo As String, ByVal idpersonal As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select e.id_empleado,nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado e" & vbCrLf)
        'If Not idpersonal = 42 And tipo = "esejecutivo" Then
        'sqlbr.Append("join personal p on p.id_empleado = e.id_empleado and IdPersonal = " & idpersonal & vbCrLf)
        'End If
        sqlbr.Append("where e.id_status = 2 and " & tipo & " = 1  order by empleado")
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
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 and tipo = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empresa") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        'Dim mycommand As New SqlCommand("sp_cliente", myConnection)
        Dim mycommand As New SqlCommand("sp_catprospecto", myConnection)
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
    Public Shared Function elimina(ByVal idcatprospectoeliminado As Integer, ByVal fecha As String, ByVal comentario As String) As String
        'Public Shared Function elimina(ByVal cliente As Integer, ByVal clienten As String, ByVal fecha As String, ByVal motivo As String, ByVal ejecutivo As Integer, ByVal gerente As Integer) As String

        Dim vfec1 As Date = fecha

        Dim vfecr As Date = Date.Today()

        Dim sql As String = "insert into tb_catprospecto_eliminado (select max(isnull(id_catprospectoeliminado,0) + 1) , '" & vfecr & "', '" & comentario & "',1 from tb_catprospecto_eliminado  );"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        'Dim generacorreo As New correoventas()
        'generacorreo.bajacliente(vfecr, "Programación de baja de cliente", clienten, vfec1, motivo, ejecutivo, gerente)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function galleta(ByVal prospecto As String) As String


        Dim Cookieidcliente As HttpCookie = New HttpCookie("prospecto")
        Cookieidcliente.Value = prospecto
        'Cookieidcliente.Expires = Now.AddDays(1)
        HttpContext.Current.Response.Cookies.Add(Cookieidcliente)
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
