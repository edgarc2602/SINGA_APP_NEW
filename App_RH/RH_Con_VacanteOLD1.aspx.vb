Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_RH_RH_Con_Vacante
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
    Public Shared Function vacantes(ByVal cliente As Integer, ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal empleado As Integer, ByVal revisa As Integer, ByVal puesto As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select " & vbCrLf)
        If revisa = 0 Then
            sqlbr.Append("(select 'symbol1 icono1 tbeditar' as '@class', 'Editar' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            sqlbr.Append("(select 'symbol1 icono1 tbaprobar' as '@class', 'Asignar Reclutador' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            sqlbr.Append("(select 'symbol1 icono1 tbliberar' as '@class', 'Registrar Candidato' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
        Else
            sqlbr.Append("'' as 'td','', '' as 'td','','' as 'td','',")
        End If
        sqlbr.Append("a.id_vacante as 'td','', b.nombre as 'td','',  j.nombre as 'td','', d.nombre + ' '+ d.paterno + ' ' + d.materno as 'td',''," & vbCrLf)
        sqlbr.Append("convert(varchar(10), fechaalta, 103) As 'td','', CASE WHEN id_tipo = 1 then 'Urgente' else 'Programada' end as 'td',''," & vbCrLf)
        sqlbr.Append("isnull(e.nombre + ' '+ e.paterno + ' ' + e.materno,'') as 'td','',  isnull(convert(varchar(10),fechaobj,103),'') as 'td',''," & vbCrLf)
        sqlbr.Append("case when DATEDIFF(day, getdate() , fechaobj) between 4 and 5 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	   when DATEDIFF(day, getdate() , fechaobj) between 1 and 3 and id_tipo = 1 and a.id_status = 1 then (select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	   when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	   when DATEDIFF(day, getdate() , fechaobj) between 8 and 10 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	   when DATEDIFF(day, getdate() , fechaobj) between 1 and 5 and id_tipo = 2 and a.id_status = 1 Then (Select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	   when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("     when a.id_status != 1 then (select 'tbborrar colorgris' as '@class' for xml path('span'), type)end as 'td','', case when a.id_status =1 then 'Sin cubrir' when a.id_status = 2 then 'Cubierta por confirmar' when a.id_status = 3 then 'Confirmado-Activo' when a.id_status = 4 then 'Cancelada' end as 'td','', isnull(g.nombre + ' ' + g.paterno, ' ') as 'td',''," & vbCrLf)
        sqlbr.Append("j.direccion + ' ' + j.colonia + ' ' + j.delegacionmunicipio + ' ' + j.cp + ' ' + c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("cast(i.smntope as numeric(12,2)) As 'td','', case when i.sexo = 1 then 'Masculino' when i.sexo = 2 then 'Femenino' else 'Indistinto' end as 'td',''," & vbCrLf)
        sqlbr.Append("f.descripcion as 'td','', 'Horario: ' + horariode + ' a ' + horarioa + ' Dias laborables: ' + i.diade + ' a ' + i.diaa + ' Descanso: ' + i.diadescanso as 'td'" & vbCrLf)
        sqlbr.Append("From tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble j on a.id_inmueble = j.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_estado c on j.id_estado = c.id_estado " & vbCrLf)
        sqlbr.Append("left outer join tb_empleado d on b.id_operativo = d.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_gerente_coordinador h on b.id_operativo = h.id_gerente " & vbCrLf)
        sqlbr.Append("left outer join tb_empleado e on h.id_coordinador = e.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado g on a.id_reclutador = g.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_turno f on a.id_turno = f.id_turno " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_plantilla i on a.id_inmueble = i.id_inmueble and a.id_puesto = i.id_puesto and a.id_turno = i.id_turno and i.id_status = 1" & vbCrLf)
        sqlbr.Append("where a.id_status = " & estatus & " " & vbCrLf)
        If revisa = 0 Then
            Select Case puesto
                Case 26
                    sqlbr.Append("and a.id_reclutador = " & empleado & "" & vbCrLf)
                Case Else
                    sqlbr.Append("and a.id_coordinador = " & empleado & "" & vbCrLf)
            End Select
        End If
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        If vfecini <> Nothing Then sqlbr.Append("And CAST(a.fechaalta As Date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append("order by fechaalta , a.id_vacante for xml path('tr'), root('tbody')")

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
    Public Shared Function menu1(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select * from func_Menu_nav(" & usuario & ")")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)

        If dt.Rows.Count > 0 Then
            sql += "'" & dt.Rows(0)("menu1") & "'" '
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reclutador(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_reclutador , b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as nombre " & vbCrLf)
        sqlbr.Append("from tb_coordina_recluta a inner join tb_empleado b on a.id_reclutador = b.id_empleado  " & vbCrLf)
        sqlbr.Append("where id_coordinador = " & empleado & " order by paterno, materno, nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_reclutador") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function asignarecluta(ByVal vacante As Integer, ByVal reclu As Integer) As String

        Dim sql As String = "Update tb_vacante set id_reclutador = " & reclu & " where id_vacante =" & vacante & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estatus(ByVal idstatus As Integer, ByVal folio As Integer, ByVal emp As String, ByVal med As String, ByVal fecha As String) As String

        Dim vfec As Date

        If fecha <> "" Then vfec = fecha

        Dim sql As String = "Update tb_vacante set id_status = " & idstatus & ""
        If emp <> "" Then sql += ", empleado = '" & emp & "'"
        If med <> "" Then sql += ", medio = '" & med & "'"
        If fecha <> "" Then sql += ", fingreso = '" & Format(vfec, "yyyyMMdd") & "'"
        sql += "where id_vacante =" & folio & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleadoop(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado, isnull(id_puesto,0) as id_puesto from personal where idpersonal = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_empleado") & "', puesto:'" & dt.Rows(0)("id_puesto") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function permiso(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select case when per_revisa = 'true' then 1 else 0 end as revisa from personal where idpersonal = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{permiso:'" & dt.Rows(0)("revisa") & "'}" & vbCrLf
        End If
        Return sql
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
