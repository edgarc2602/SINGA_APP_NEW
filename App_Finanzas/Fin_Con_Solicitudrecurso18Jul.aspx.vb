Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Con_Solicitudrecurso
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
    Public Shared Function estatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_status, descripcion from tb_statussr order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_status") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarsolicitud(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal empleado As Integer, ByVal estatus As Integer, ByVal proveedor As Integer, ByVal beneficia As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_solicitudrecurso where id_cliente != 0" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and id_status = " & estatus & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and falta between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If beneficia = 1 Then
            If empleado <> 0 Then sqlbr.Append("and id_empleado =" & empleado & "" & vbCrLf)
        Else
            If proveedor <> 0 Then sqlbr.Append("and id_proveedor =" & proveedor & "" & vbCrLf)
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
    Public Shared Function solicitudes(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal pagina As Integer, ByVal empleado As Integer, ByVal estatus As Integer, ByVal proveedor As Integer, ByVal beneficia As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_solicitud as 'td','', tipo as 'td','', isnull(empleado,'') as 'td','', empresa as 'td','', gasto as 'td','', " & vbCrLf)
        sqlbr.Append("fecha as 'td','', estatus as 'td','', total as 'td','',isnull(banco,'') as 'td','', isnull(clabe,'') as 'td','', isnull(cuenta,'') as 'td',''," & vbCrLf)
        sqlbr.Append("area as 'td','', concepto as 'td','',")
        sqlbr.Append("(select 'btn btn-primary btdetalle' as '@class', 'Detalles' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when estatus ='alta' then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btvalida' as '@class', 'Validar/Rechazar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Validado' then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btlibera' as '@class', 'Liberar/Rechazar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Liberado' then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btautoriza' as '@class', 'Autorizar/Rechazar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Autorizado' then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btpagado' as '@class', 'Pagado' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("end" & vbCrLf)
        sqlbr.Append("")
        sqlbr.Append("from ( select ROW_NUMBER() over (order by a.id_solicitud) as rownum , id_solicitud, case when a.id_tipo = 5 then d.razonsocial when a.id_tipo = 3 then  k.nombre + ' ' + k.paterno + ' ' + k.materno else b.nombre + ' ' + b.paterno + ' ' + trim(b.materno) end as empleado, c.nombre as empresa," & vbCrLf)
        sqlbr.Append("convert(varchar(12),a.falta,103) as fecha, cast(a.total as numeric(12,2)) as total, f.descripcion as estatus," & vbCrLf)
        sqlbr.Append("g.descripcion as tipo, case when a.tipopago = 1 then 'Por comprobar' when a.tipopago = 0 then 'Por comprobar' else 'Facturas pendientes' end as gasto," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then h.descripcion when a.id_jornalero != 0 then l.descripcion else i.descripcion end as banco," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then b.clabe when a.id_jornalero != 0 then k.cuenta else d.clabe end as clabe," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then b.cuenta when a.id_jornalero != 0 then '' else d.cuenta end as cuenta," & vbCrLf)
        sqlbr.Append("a.concepto, j.Ar_Descripcion as area" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecurso a left outer join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_empresa c on a.id_empresa = c.id_empresa" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedor d on a.id_proveedor = d. id_proveedor" & vbCrLf)
        sqlbr.Append("inner join tb_statussr f on a.id_status = f.id_status " & vbCrLf)
        sqlbr.Append("inner join tb_solicitudrecurso_tipo g on a.id_tipo = g.id_tipo " & vbCrLf)
        sqlbr.Append("left outer join tb_banco h on b.id_banco = h.id_banco" & vbCrLf)
        sqlbr.Append("left outer join tb_banco i on d.id_banco = i.id_banco" & vbCrLf)
        sqlbr.Append("left outer join tb_jornalero k on a.id_jornalero = k.id_jornalero" & vbCrLf)
        sqlbr.Append("Left outer join tb_banco l on k.id_banco = l.id_banco" & vbCrLf)
        sqlbr.Append("inner join Tbl_Area_Empresa j on a.areaautoriza = j.IdArea" & vbCrLf)
        sqlbr.Append("where id_solicitud != 0" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and a.id_solicitud =" & folio & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.falta as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and a.id_status =" & estatus & "" & vbCrLf)
        If beneficia = 1 Then
            If empleado <> 0 Then sqlbr.Append("and a.id_empleado =" & empleado & "" & vbCrLf)
        Else
            If proveedor <> 0 Then sqlbr.Append("and a.id_proveedor =" & proveedor & "" & vbCrLf)
        End If
        sqlbr.Append(") as tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 for xml path('tr'), root('tbody')")
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
    Public Shared Function solicituddet(ByVal folio As Integer, ByVal gasto As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        If gasto = "Facturas pendientes" Then
            sqlbr.Append("select 'Factura-'+factura as 'td','', cast(monto as numeric(12,2)) as 'td' from tb_solicitudrecursof " & vbCrLf)
            sqlbr.Append("where id_solicitud = " & folio & " for xml path('tr'), root('tbody')")
        Else
            sqlbr.Append("select b.descripcion as 'td','', cast(a.monto as numeric(12,2)) as 'td' from tb_solicitudrecursoc a inner join tb_conceptosolicitud b on a.id_concepto = b.id_concepto" & vbCrLf)
            sqlbr.Append("where id_solicitud = " & folio & " for xml path('tr'), root('tbody')")
        End If
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
    Public Shared Function cambiaestatus(ByVal req As Integer, ByVal status As Integer, ByVal usuario As Integer, ByVal motivo As String) As String

        Dim sql As String = "Update tb_solicitudrecurso set id_status = " & status & " "
        Select Case status
            Case 2
                sql += ", usuariovalida = " & usuario & ", fvalida = getdate()"
            Case 3
                sql += ", usuariolibera = " & usuario & ", flibera = getdate()"
            Case 4
                sql += ", usuarioautoriza = " & usuario & ", fautoriza = getdate()"
            Case 5
                sql += ", usuariopaga = " & usuario & ", fpaga = getdate()"
            Case 6
                sql += ", usuariorechaza = " & usuario & ", frechaza = getdate(), motivo ='" & motivo & "'"
        End Select

        sql += " where id_solicitud =" & req & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        Dim generacorreo As New correofinanzas()
        Select Case status
            Case 2
                generacorreo.validasolicitud(req, status)
            Case 3
                generacorreo.liberasolicitud(req, status)
            Case 4
                generacorreo.autorizasolicitud(req, status)
            Case 5
                generacorreo.pagasolicitud(req, status)
            Case 6
                generacorreo.rechazasolicitud(req, status)
        End Select

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function validausuario(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select per_valida from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{valida: '" & dt.Rows(0)("valida") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal id As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, a.nombre + ' ' + paterno + ' ' + materno as nombre, b.nombre as empresa, a.id_empresa as idemp from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa ")
        sqlbr.Append("where id_status =2 and id_empleado = " & id & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "', nombre: '" & dt.Rows(0)("nombre") & "'}" ', empresa: '" & dt.Rows(0)("empresa") & "', idemp: '" & dt.Rows(0)("idemp") & "'}"
        Else
            sql += "{id:''}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleadolista(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.nombre as 'td','', a.id_empresa as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa where id_status = 2" & vbCrLf)
        sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append("order by paterno, materno, a.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function proveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, nombre from tb_proveedor where id_status = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_proveedor") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        'idcliente1.Value = Request.Cookies("Cliente").Value

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
