Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Con_servicioespecial
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function estatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_status, descripcion from tb_statuscm order by descripcion" & vbCrLf)
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
    Public Shared Function contarservicio(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal estatus As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_servicioespecial where id_cliente != 0" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and id_status = " & estatus & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_servicio =" & folio & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and fregistro between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
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
    Public Shared Function servicios(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal pagina As Integer, ByVal estatus As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_servicio as 'td','', cliente as 'td','', inmueble as 'td','', trabajos as 'td','', costodirecto as 'td','', presupuesto as 'td','', estatus as 'td','', " & vbCrLf)
        sqlbr.Append("fregistro as 'td','', concepto as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btsolicitud' as '@class', 'Recursos solicitados' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btrecursos' as '@class', 'Solicitar recurso' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when estatus ='alta' then	" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btautoriza' as '@class', 'Autorizar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	when estatus ='autorizado' then" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btcierra' as '@class', 'Cerrar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	when estatus ='Cerrado' then" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btfactura' as '@class', 'Facturar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	when estatus ='Facturado' then" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btcobra' as '@class', 'Cobrado' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	end," & vbCrLf)
        sqlbr.Append("case when estatus ='Facturado' OR estatus ='Cobrado' then" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btver' as '@class', 'Ver factura' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	end" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER() over (order by id_servicio) as rownum, a.id_servicio, b.nombre as cliente, c.nombre as inmueble, d.descripcion as trabajos, " & vbCrLf)
        sqlbr.Append("cast(a.costodirecto as numeric(12,2)) as costodirecto,")
        sqlbr.Append("cast(a.presupuesto as numeric(12,2)) as presupuesto, e.descripcion as estatus, convert(varchar(12), fregistro, 103) as fregistro, concepto" & vbCrLf)
        sqlbr.Append("FROM tb_servicioespecial a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_trabajoespecial  d on a.id_trabajo = d.id_trabajo " & vbCrLf)
        sqlbr.Append("inner join tb_statuscm e on a.id_status = e.id_status " & vbCrLf)
        sqlbr.Append("where id_servicio != 0" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and a.id_servicio =" & folio & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.fregistro as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and a.id_status =" & estatus & "" & vbCrLf)
        sqlbr.Append(") as tabla  where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 for xml path('tr'), root('tbody')")
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
    Public Shared Function solicitudes(ByVal servicio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_solicitud as 'td','', fecha as 'td','',  estatus as 'td','', isnull(empleado,'') as 'td','', total as 'td','',area as 'td'" & vbCrLf)
        sqlbr.Append("from ( select ROW_NUMBER() over (order by a.id_solicitud) as rownum , id_solicitud, case when a.id_tipo = 5 Then d.razonsocial When a.id_tipo = 3 Then  " & vbCrLf)
        sqlbr.Append("k.nombre + ' ' + k.paterno + ' ' + k.materno else b.nombre + ' ' + b.paterno + ' ' + trim(b.materno) end as empleado, c.nombre as empresa," & vbCrLf)
        sqlbr.Append("convert(varchar(12),a.falta,103) As fecha, cast(a.subtotal As numeric(12,2)) As total, f.descripcion As estatus," & vbCrLf)
        sqlbr.Append("g.descripcion As tipo, Case When a.tipopago = 1 Then 'Por comprobar' when a.tipopago = 0 then 'Por comprobar' else 'Facturas pendientes' end as gasto," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then h.descripcion when a.id_jornalero != 0 then l.descripcion else i.descripcion end as banco," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then b.clabe when a.id_jornalero != 0 then k.cuenta else d.clabe end as clabe," & vbCrLf)
        sqlbr.Append("case when a.id_empleado != 0 then b.cuenta when a.id_jornalero != 0 then '' else d.cuenta end as cuenta," & vbCrLf)
        sqlbr.Append("a.concepto, j.Ar_Descripcion as area, a.id_clavecm, a.id_servicioespecial" & vbCrLf)
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
        sqlbr.Append("where id_servicioespecial = " & servicio & "" & vbCrLf)
        sqlbr.Append(") as tabla order by fecha, id_solicitud for xml path('tr'), root('tbody')")
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

        Dim sql As String = "Update tb_servicioespecial set id_status = " & status & " "
        Select Case status
            Case 2
                sql += ", usuarioautoriza = " & usuario & ", fautoriza = getdate()"
            Case 6
                sql += ", usuariorechaza = " & usuario & ", frechaza = getdate(), motivo ='" & motivo & "'"
        End Select

        sql += " where id_servicio =" & req & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Select Case status
            Case 2
                Dim generacorreo As New correooper()
                generacorreo.servicioespecialauto(req)
            Case 5
                Dim generacorreo As New correooper()
                generacorreo.servicioespecialpago(req)
            Case 6
                'sql += ", usuariorechaza = " & usuario & ", frechaza = getdate(), motivo ='" & motivo & "'"
        End Select

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cierra(ByVal folio As Integer) As String

        Dim aa As String = ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_servicioespecialutilidad", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@id", folio)
            mycommand.ExecuteNonQuery()

            trans.Commit()

            Dim generacorreo As New correooper()
            generacorreo.servicioespecialcierre(folio)

            aa = "esta hecho"

        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return aa

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardafactura(ByVal registro As String, ByVal id_clavecm As Integer) As String
        Dim aa As String = ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_facturase", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@factura", registro)
            mycommand.ExecuteNonQuery()

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()


        Dim generacorreo As New correooper()
        generacorreo.servicioespecialfac(id_clavecm)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadocto(ByVal servicio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select archivo as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btquita' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From tb_servicioespecialfactura " & vbCrLf)
        sqlbr.Append("where id_servicio = " & servicio & "  for xml path('tr'), root('tbody')")
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
