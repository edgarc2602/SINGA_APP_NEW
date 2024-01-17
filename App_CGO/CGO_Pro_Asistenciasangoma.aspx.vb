Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_CGO_CGO_Pro_Asistenciasangoma
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
    Public Shared Function periodo(ByVal fecha As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fecha <> "" Then vfecini = fecha

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente() & " order by nombre")
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
    Public Shared Function asistencias(ByVal fini As String, ByVal cliente As Integer, ByVal inmueble As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini

        sqlbr.Append("select isnull(cliente,'') as 'td','', isnull(inmueble,'') as 'td','', empleado as 'td','', isnull(nombre,'EMPLEADO INCORRECTO') as 'td','', fecha as 'td','', " & vbCrLf)
        sqlbr.Append("hora as 'td','', telefono as 'td','', isnull(llamada, 'NO SE LOCALIZA REGISTRO') as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'checked' as '@checked', 'tbstatus1' as '@class', 'checkbox' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("f.id_periodo as 'td','', formapago as 'td','',  f.anio as 'td','', id_inmueble as 'td'" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("Select c.nombre cliente, d.nombre inmueble, a.empleado, b.paterno + + ' ' + rtrim(b.materno) +' '  + b.nombre as nombre, " & vbCrLf)
        sqlbr.Append("convert(varchar(12), fecha, 103) as fecha, convert(varchar(8), hora) as hora, telefono, e.nombre as llamada, " & vbCrLf)
        sqlbr.Append("case when b.formapago = 1 then 'Quincenal' else 'Semanal' end as formapago, b.id_inmueble" & vbCrLf)
        sqlbr.Append("from tb_asistenciasangoma a left outer join tb_empleado b on a.empleado = b.id_empleado  " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble e on a.telefono = e.tel1 " & vbCrLf)
        sqlbr.Append("where fecha = '" & Format(vfecini, "yyyyMMdd") & "' and aplicado = 0" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and b.id_inmueble = " & inmueble & "" & vbCrLf)
        sqlbr.Append(") as result left outer join tb_periodonomina f on result.formapago = f.descripcion  and finicio <= '" & Format(vfecini, "yyyyMMdd") & "' and ffin >= '" & Format(vfecini, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append("order by  cliente, inmueble, result.nombre  for xml path('tr'), root('tbody')")
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
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_asistencia", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_asistenciasangoma", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.ExecuteNonQuery()

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            Dim aa = ex.Message.ToString().Replace("'", "")
        End Try

        myConnection.Close()
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
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub


End Class
