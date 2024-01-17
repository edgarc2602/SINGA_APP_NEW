Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Con_Empleado_Curso
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function contarcandidato(ByVal estatus As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_empleado_capacitacion a where id_status = " & estatus & "" & vbCrLf)
        'If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
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
    Public Shared Function candidato(ByVal pagina As Integer, ByVal estatus As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_candidato as'td','', fregistro as'td','', cliente as'td','', sucursal as'td','', candidato as'td','', rfc as'td',''," & vbCrLf)
        sqlbr.Append("curp as'td','', ss as'td','', puesto as'td','', turno as'td','', reclutador as'td','',fecha as'td','', horario as'td','', estatus as'td' from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by id_candidato) As RowNum, id_candidato, convert(varchar(17), fregistro,13) as fregistro, b.nombre as cliente, " & vbCrLf)
        sqlbr.Append("c.nombre as sucursal, a.paterno +' ' + a.materno + ' ' + a.nombre as candidato, a.rfc, a.curp, a.ss, d.descripcion as puesto," & vbCrLf)
        sqlbr.Append("e.descripcion as turno,  f.paterno +' ' + f.materno + ' ' + f.nombre as reclutador, convert(varchar(12), fecha,103) as fecha, " & vbCrLf)
        sqlbr.Append("case when hora = 1 then '10:00 am' when hora = 2 then '12:00 pm' else '16:00 pm' end as horario," & vbCrLf)
        sqlbr.Append("case when a.id_status = 1 then 'Programado' when a.id_status = 2 then 'Confirmado' when a.id_status = 3 then 'Cancelado' end as estatus" & vbCrLf)
        sqlbr.Append("from tb_empleado_capacitacion a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble inner join tb_puesto d on a.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno e on a.id_turno = e.id_turno INNER JOIN tb_empleado f on a.id_reclutador = f.id_empleado where a.id_status =" & estatus & ") " & vbCrLf)
        sqlbr.Append("as result where RowNum BETWEEN (" & pagina & " - 1) * 30 + 1 And " & pagina & " * 30 order by fregistro For xml path('tr'), root('tbody') " & vbCrLf)


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
    Public Shared Function actualiza(ByVal empleado As String, ByVal estatus As Integer, ByVal coment As String) As String

        Dim sql As String = "Update tb_empleado_capacitacion set id_status = " & estatus & ", observacion = '" & coment & "'  where id_candidato =" & empleado & ";"
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
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
