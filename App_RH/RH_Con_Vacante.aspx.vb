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
    Public Shared Function vacantes(ByVal cliente As Integer, ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal revisa As Integer, ByVal puesto As Integer, ByVal pagina As Integer, ByVal inmueble As Integer, ByVal gerente As Integer, ByVal usuario As Integer, ByVal folio As Integer, ByVal estado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select " & vbCrLf)
        If usuario <> 1 Then
            If revisa = 0 Then 'ESTA VALIDACION ES PARA COLOCAR LOS CONTROLES DE EDICION DE RECURSOS HUMANOS
                sqlbr.Append("'' as 'td','', '' as 'td','',")
                sqlbr.Append("(select 'symbol1 icono1 tbliberar' as '@class', 'Registrar Candidato' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                sqlbr.Append("(select 'symbol1 icono1 tbreingresa' as '@class', 'Reingreso de personal' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            Else
                If puesto = 11 Then ' ESTA VALIDACION ES PARA COLOCAR EL CONTROL DE EDICION DEL GERENTE
                    sqlbr.Append("(select 'symbol1 icono1 tbeditar' as '@class', 'Cancelar vacante' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                    sqlbr.Append("'' as 'td','', '' as 'td','', '' as 'td','',")
                Else
                    If puesto = 40 Then ' ESTO ES PARA CONSULTA GENERAL Y SOLO PODER ASIGNAR RECLUTADOR
                        sqlbr.Append("'' as 'td','',")
                        sqlbr.Append("(select 'symbol1 icono1 tbaprobar' as '@class', 'Asignar Reclutador' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                        sqlbr.Append("'' as 'td','', '' as 'td','',")
                    Else
                        If puesto = 108 Then ' ESTO ES PARA LOS GENERALISTAS DE RH
                            sqlbr.Append("'' as 'td','',")
                            sqlbr.Append("(select 'symbol1 icono1 tbaprobar' as '@class', 'Asignar Reclutador' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                            sqlbr.Append("(select 'symbol1 icono1 tbliberar' as '@class', 'Registrar Candidato' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                            sqlbr.Append("(select 'symbol1 icono1 tbreingresa' as '@class', 'Reingreso de personal' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
                        Else
                            sqlbr.Append("'' as 'td','', '' as 'td','','' as 'td','', '' as 'td','',") ' ESTO ES PARA CONSULTA GENERAL SIN PODER EDITAR
                        End If
                    End If
                End If
            End If
        Else
            sqlbr.Append("(select 'symbol1 icono1 tbeditar' as '@class', 'Cancelar vacante' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            sqlbr.Append("(select 'symbol1 icono1 tbaprobar' as '@class', 'Asignar Reclutador' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            sqlbr.Append("(select 'symbol1 icono1 tbliberar' as '@class', 'Registrar Candidato' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
            sqlbr.Append("(select 'symbol1 icono1 tbreingresa' as '@class', 'Reingreso de personal' as '@title' for xml path('span'),root('td'),type),''," & vbCrLf)
        End If
        sqlbr.Append("id_vacante as 'td','', cliente as 'td','', isnull(estado,'') as 'td','', sucursal as 'td','', isnull(gerente,'') as 'td','', fechaalta as 'td','',tipo as 'td','', " & vbCrLf)
        sqlbr.Append("coordinador as 'td','', fechaobj as 'td','',bandera as 'td','', estatus as 'td','', reclutador as 'td','', isnull(direccion,'') as 'td','', " & vbCrLf)
        sqlbr.Append("puesto as 'td','', sueldo as 'td','', sexo as 'td','', turno as 'td','', horario as 'td','', observacion as 'td','', id_plantilla as 'td' from(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by a.id_vacante) As RowNum, a.id_vacante, b.nombre as cliente, j.nombre as sucursal, d.nombre + ' '+ rtrim(d.paterno) + ' ' + rtrim(d.materno) as gerente," & vbCrLf)
        sqlbr.Append("convert(varchar(10), fechaalta, 103) As fechaalta, " & vbCrLf)
        sqlbr.Append("CASE WHEN id_tipo = 1 then 'Urgente' else 'Programada' end tipo," & vbCrLf)
        sqlbr.Append("isnull(e.nombre + ' '+ rtrim(e.paterno) + ' ' + rtrim(e.materno),'') as coordinador,  isnull(convert(varchar(10),fechaobj,103),'') as fechaobj," & vbCrLf)
        sqlbr.Append("case when DATEDIFF(day, getdate() , fechaobj) >= 3 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 1 and 2 and id_tipo = 1 and a.id_status = 1 then (select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 1 and a.id_status = 1 Then (Select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        'sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 8 and 10 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        'sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) between 1 and 5 and id_tipo = 2 and a.id_status = 1 Then (Select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        'sqlbr.Append("	when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 2 and a.id_status = 1 then (select 'tbborrar colorrojo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("    when a.id_status != 1 then (select 'tbborrar colorgris' as '@class' for xml path('span'), type)end as bandera, " & vbCrLf)
        sqlbr.Append("case when a.id_status =1 then 'Sin cubrir' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 2 then 'Cubierta por confirmar' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 3 then 'Confirmado-Activo' " & vbCrLf)
        sqlbr.Append("	 when a.id_status = 4 then 'Cancelada' end as estatus, " & vbCrLf)
        sqlbr.Append("isnull(g.nombre + ' ' + rtrim(g.paterno), ' ') as reclutador, j.direccion + ' ' + j.colonia + ' ' + j.delegacionmunicipio + ' ' + j.cp + ' ' + c.descripcion as direccion," & vbCrLf)
        sqlbr.Append("isnull(k.descripcion,'') as puesto, cast(isnull(i.smntope,0) as numeric(12,2)) As sueldo, " & vbCrLf)
        sqlbr.Append("case when i.sexo = 1 then 'Masculino' " & vbCrLf)
        sqlbr.Append("	when i.sexo = 2 then 'Femenino' else 'Indistinto' end as sexo," & vbCrLf)
        sqlbr.Append("isnull(f.descripcion,'') as turno, isnull('Horario: ' + horariode + ' a ' + horarioa + ' Dias laborables: ' + i.diade + ' a ' + i.diaa + ' Descanso: ' + i.diadescanso,'') as horario, a.observacion, a.id_plantilla," & vbCrLf)
        sqlbr.Append("c.descripcion as estado" & vbCrLf)
        sqlbr.Append("From tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble j on a.id_inmueble = j.id_inmueble " & vbCrLf)
        sqlbr.Append("left outer join tb_estado c on j.id_estado = c.id_estado " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado d on b.id_operativo = d.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_gerente_coordinador h on b.id_operativo = h.id_gerente " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado e on h.id_coordinador = e.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado g on a.id_reclutador = g.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_plantilla i on a.id_plantilla = i.id_plantilla" & vbCrLf)
        sqlbr.Append("left outer join tb_turno f on i.id_turno = f.id_turno left outer join tb_puesto k on i.id_puesto = k.id_puesto " & vbCrLf)

        sqlbr.Append("where a.id_status =  " & estatus & "  " & vbCrLf)
        'If revisa <> 0 Then
        'If puesto = 11 Then
        ' sqlbr.Append("and a.usuarioalta  = " & usuario & "" & vbCrLf)
        'End If
        'End If
        If folio <> 0 Then sqlbr.Append("and a.id_vacante = " & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble = " & inmueble & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and b.id_operativo  = " & gerente & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and j.id_estado  = " & estado & "" & vbCrLf)
        If vfecini <> Nothing Then sqlbr.Append("And CAST(a.fechaalta As Date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by fechaalta, id_vacante for xml path('tr'), root('tbody')")

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
    Public Shared Function contarvacante(ByVal cliente As Integer, ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal inmueble As Integer, ByVal gerente As Integer, ByVal folio As Integer, ByVal estado As Integer) As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble where a.id_status = " & estatus & "")
        If folio <> 0 Then sqlbr.Append("and a.id_vacante = " & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "")
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble  = " & inmueble & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and b.id_operativo  = " & gerente & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and c.id_estado  = " & estado & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(fechaalta as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'")
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
    Public Shared Function contartotal(ByVal cliente As Integer, ByVal fini As String, ByVal ffin As String, ByVal estatus As Integer, ByVal inmueble As Integer, ByVal gerente As Integer, ByVal folio As Integer, ByVal estado As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT count(id_vacante) as total FROM tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble where a.id_status = " & estatus & "")
        If folio <> 0 Then sqlbr.Append("and a.id_vacante = " & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente = " & cliente & "")
        If inmueble <> 0 Then sqlbr.Append("and a.id_inmueble  = " & inmueble & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and b.id_operativo  = " & gerente & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and c.id_estado  = " & estado & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(fechaalta as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'")
        Dim ds As New DataTable
        Dim myconnection As String = (New Conexion).StrConexion
        Dim comm As New SqlDataAdapter(sqlbr.ToString(), myconnection)
        comm.Fill(ds)
        If ds.Rows.Count > 0 Then
            sql += "{total:" & ds.Rows(0)("total") & "}" & vbCrLf
        End If

        Return sql
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

        sqlbr.Append("select * from (" & vbCrLf)
        sqlbr.Append("select id_reclutador, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as nombre " & vbCrLf)
        sqlbr.Append("from tb_coordina_recluta a inner join tb_empleado b on a.id_reclutador = b.id_empleado  " & vbCrLf)
        sqlbr.Append("where id_coordinador = " & empleado & "" & vbCrLf)
        sqlbr.Append("union all" & vbCrLf)
        sqlbr.Append("select id_empleado, paterno + ' ' + rtrim(materno) + ' ' + nombre as nombre " & vbCrLf)
        sqlbr.Append("from tb_empleado where id_empleado = " & empleado & ") As tabla order by nombre")
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
    Public Shared Function cancelavacante(ByVal vacante As Integer) As String

        Dim sql As String = "Update tb_vacante set id_status = 4 where id_vacante =" & vacante & ";"
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

    <Web.Services.WebMethod()>
    Public Shared Function inmueble(ByVal cliente As Integer, ByVal estado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente & "" & vbCrLf)
        If estado <> 0 Then sqlbr.Append("and id_estado = " & estado & "")
        sqlbr.Append("order by nombre")
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
    Public Shared Function estados(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct(a.id_estado), b.descripcion from tb_cliente_inmueble a inner join tb_estado b on a.id_estado = b.id_estado" & vbCrLf)
        sqlbr.Append("where id_cliente = " & cliente & " order by id_estado")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id: '" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reingresoempleado(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + nombre as 'td','', rfc as 'td','', curp as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado where id_status = 3 " & vbCrLf)
        sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append("order by paterno, materno, nombre for xml path('tr'), root('tbody')")
        'sqlbr.Append(") as result" & vbCrLf)
        'sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 30 + 1 And " & pagina & " * 30 order by RowNum For xml path('tr'), root('tbody') " & vbCrLf)
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
    Public Shared Function empleado(ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado,nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 and " & tipo & "   = 1 order by empleado")
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
