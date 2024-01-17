Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Banfuturo_Ban_Con_Solicitud
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function solicitudes(ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal pagina As Integer, ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_solicitud as 'td','', id_empleado as 'td','', empleado as 'td','',empresa as 'td','', isnull(jefe,'') as 'td','', fecha as 'td','', " & vbCrLf)
        sqlbr.Append("monto as 'td','', plazo as 'td','', planpago as 'td','',  estatus as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btauto' as '@class', 'Autoriza/Rechaza' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when id_status = 3 then (select 'btn btn-primary btpago' as '@class', 'Aplicar pago' as '@value', 'button' as '@type' for xml path('input'), type)  else '' end as 'td', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btdoctos' as '@class', 'Doctos' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'' " & vbCrLf)
        sqlbr.Append("from( Select ROW_NUMBER() over (order by id_solicitud desc) as rownum, id_solicitud, a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, c.nombre as empresa, d.per_nombre+ ' ' + d.Per_Paterno + ' ' + d.Per_Materno as jefe," & vbCrLf)
        sqlbr.Append("convert(varchar(12),a.fecha, 103) as fecha, cast(a.monto as numeric(12,2)) as monto, a.id_status," & vbCrLf)
        sqlbr.Append("cast(a.plazo as varchar) + ' Meses' as plazo, case when a.planpago = 1 then 'Semanal' when a.planpago = 2 then 'Quincenal' when a.planpago = 3 then 'Mensual' end as planpago, " & vbCrLf)
        sqlbr.Append("case when a.id_status = 1 then 'Alta' when a.id_status = 2 then 'Autorizado' when a.id_status = 3 then 'Liberado' when a.id_status = 4 then 'Rechazado' when a.id_status = 5 then 'Pagado' end as estatus " & vbCrLf)
        sqlbr.Append("from tb_solicitudprestamo a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_empresa c on b.id_empresa = c.id_empresa" & vbCrLf)
        sqlbr.Append(" left outer join personal d on a.jefe = d.idpersonal  where a.id_status != 0 ")
        If fini <> "" Then sqlbr.Append(" and cast(a.fecha as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append(" and a.id_status =" & estatus & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "" & vbCrLf)
        sqlbr.Append(") tabla where RowNum BETWEEN (" & pagina & " - 1) * (50) And " & pagina & " * 50 order by id_solicitud desc" & vbCrLf)
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
    Public Shared Function contarsolicitud(ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal folio As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 +1 as Filas, COUNT(*) % 50 as Residuos FROM tb_solicitudprestamo" & vbCrLf)
        sqlbr.Append("where id_status != 0" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(fecha as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and id_status =" & estatus & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "" & vbCrLf)
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
    Public Shared Function autoriza(ByVal req As Integer, ByVal status As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_codigovalidacion", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@req", req)
        mycommand.Parameters.AddWithValue("@estatus", status)
        Dim prm1 As New SqlParameter("@cv", "")
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        'Return 0

        'Dim sql As String = "Update tb_solicitudprestamo set id_status = " & status & " where id_solicitud =" & req & ";"
        'Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        'Dim mycommand As New SqlCommand(Sql, myConnection)
        'myConnection.Open()
        'mycommand.ExecuteNonQuery()
        'myConnection.Close()
        'myConnection = Nothing

        Dim estado As String = ""

        Select Case status
            Case 2
                estado = "Autorizada"
                Dim correocodigovalidacion As New correocodigovalidacion()
                correocodigovalidacion.codigoval(req)
            Case 4
                estado = "Rechazada"
        End Select
        'Dim correodir As New correodir()
        'correodir.solicitudautoriza(req, estado)

        Return prm1.Value
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function paga(ByVal solicitud As String) As String

        Dim sql As String = "Update tb_solicitudprestamo set id_status = 5 where id_solicitud =" & solicitud & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Dim correodir As New correodir()
        correodir.solicitudpago(solicitud)

        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function documentos(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudprestamod", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

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
