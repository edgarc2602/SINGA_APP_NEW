Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Mantenimiento_OP_CON_OrdenTrabajo
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idcliente1.Value = Request.Cookies("Cliente").Value

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

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.id_cliente, a.nombre  from tb_cliente a inner join tb_cliente_lineanegocio b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("where a.id_status =1 and b.id_lineanegocio= 1 order by nombre")
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
    Public Shared Function estatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_status, descripcion from tb_statusot" & vbCrLf)
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
    Public Shared Function ordenes(ByVal folio As Integer, ByVal fini As String, ByVal ffin As String, ByVal cliente As Integer, ByVal sucursal As Integer, ByVal estatus As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_orden as 'td', '', tipomant as 'td', '', estatus as 'td', '', falta as 'td', '',  " & vbCrLf)
        sqlbr.Append(" cliente as 'td', '', sucursal as 'td', '', isnull(desctrabajos,'') as 'td', '',isnull(tecnico,'') as 'td', '', " & vbCrLf)
        sqlbr.Append(" (select 'Asignar técnico' as '@title', 'font-size:36px; color:#3c8dbc;' as '@style', 'fa fa-user btasigna' as '@class' for xml path('icon'),root('td'),type),'', " & vbCrLf)
        sqlbr.Append(" (select 'btn btn-primary btn-sm btedita' as '@class', 'Ver Detalle' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'', " & vbCrLf)
        sqlbr.Append(" (select tipoorden as '@tipo', 'btn btn-primary btn-sm btimprime' as '@class', 'Reporte Mto' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'', " & vbCrLf)
        sqlbr.Append(" case tipoorden when 2 then (select tipoorden as '@tipo', 'btn btn-primary btn-sm btcheck' as '@class', 'CheckList' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) when 1 then '' end as chk,'', " & vbCrLf)

        sqlbr.Append(" case a.id_status when 1 then  " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btcancela' as '@class', 'Cancelar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append(" else " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm deshabilita' as '@class', 'Cancelar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append(" end ,'' " & vbCrLf)

        'sqlbr.Append("(select 'btn btn-primary btn-sm btcancela' as '@class', 'Cancelar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),'' " & vbCrLf)
        sqlbr.Append(" from  ( ")
        sqlbr.Append(" Select ROW_NUMBER() over (order by a.id_orden) as rownum, a.id_orden, c.descripcion as tipomant, b.descripcion as estatus, ")
        sqlbr.Append(" Convert(varchar(10), a.fregistro, 103) falta , a.fbaja, d.nombre as cliente, e.nombre as sucursal, a.tipo as tipoorden,")

        sqlbr.Append(" case when isnull(z.id_proveedor,0) =0 then f.nombre + ' ' + f.paterno + ' ' + rtrim(f.materno) else isnull(z.nombre,'') end as tecnico,")

        sqlbr.Append(" a.desctrabajos, a.id_status ")
        sqlbr.Append(" From tb_ordentrabajo a ")
        sqlbr.Append(" inner join tb_statusot b on a.id_status=b.id_status ")
        sqlbr.Append(" inner join tb_tipomantenimiento c on a.id_servicio=c.id_servicio ")
        sqlbr.Append(" inner join tb_cliente d on a.id_cliente=d.id_cliente ")
        sqlbr.Append(" inner join tb_cliente_inmueble e on a.id_inmueble=e.id_inmueble ")
        sqlbr.Append(" left join tb_empleado f on a.id_tecnico=f.id_empleado ")
        sqlbr.Append(" left join tb_proveedor z on a.id_Proveedor = z.id_proveedor ")
        sqlbr.Append(" where 1=1 ")
        If estatus <> 0 Then sqlbr.Append("and a.id_status = " & estatus & " ")
        If folio <> 0 Then sqlbr.Append("and a.id_orden =" & folio & " ")
        If cliente <> 0 Then sqlbr.Append("and d.id_cliente =" & cliente & " ")
        If sucursal <> 0 Then sqlbr.Append("and e.id_inmueble =" & sucursal & " ")
        If vfecini <> Nothing Then sqlbr.Append("And CAST(a.fregistro As Date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        sqlbr.Append(" ) as a where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by id_orden for xml path('tr'), root('tbody') ")
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
    Public Shared Function contartickets(ByVal folio As Integer, ByVal cliente As Integer, ByVal sucursal As Integer, ByVal estatus As Integer, ByVal fini As String, ByVal ffin As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_ordentrabajo where id_status = " & estatus & " " & vbCrLf)
        sqlbr.Append(" and CAST(fregistro As Date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_orden =" & folio & " ")
        If cliente <> 0 Then sqlbr.Append("and id_cliente =" & cliente & " ")
        If sucursal <> 0 Then sqlbr.Append("and id_inmueble =" & sucursal & " ")
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
    Public Shared Function cerrarorden(folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = "update tb_ordentrabajo set id_status=4 , fbaja = getdate() where id_orden=" & folio
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tecnico(ByVal nombre As String, ByVal tipoTecnico As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim Aux_where As String = ""

        sqlbr.Append("SELECT " & vbCrLf)

        If nombre = "" Then
            sqlbr.Append("TOP 50 " & vbCrLf)
        Else
            If (tipoTecnico = "I") Then
                Aux_where = "And nombre + paterno + materno  Like '%" & nombre & "%' " & vbCrLf
            Else Aux_where = "And nombre Like '%" & nombre & "%' " & vbCrLf
            End If
        End If

        If tipoTecnico = "I" Then
            sqlbr.Append("id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + nombre as 'td','', c.descripcion as 'td' " & vbCrLf)
            sqlbr.Append("from tb_empleado a inner join tb_puesto c on a.id_puesto = c.id_puesto " & vbCrLf)
            sqlbr.Append("where a.id_puesto in(1,16,21,22,23,24,25,92) and a.id_status = 2 " & vbCrLf)
            sqlbr.Append(Aux_where)
            sqlbr.Append("order by paterno, materno, nombre for xml path('tr'), root('tbody')")
        Else
            sqlbr.Append("id_proveedor as 'td','', nombre as 'td','', '' as 'td' " & vbCrLf)
            sqlbr.Append("from tb_proveedor " & vbCrLf)
            sqlbr.Append("where id_status=1 and id_lineanegocio=1 and idarea=11 " & vbCrLf)
            sqlbr.Append(Aux_where)
            sqlbr.Append("order by nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function asignatecnico(ByVal idtecnico As Integer, ByVal idorden As Integer, ByVal tipoTecnico As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        Dim sql As String = "update tb_ordentrabajo set id_tecnico = " + idtecnico.ToString() + " where id_orden = " + idorden.ToString()

        If tipoTecnico = "P" Then sql = "update tb_ordentrabajo set id_Proveedor = " + idtecnico.ToString() + " where id_orden = " + idorden.ToString()



        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()

        myConnection.Close()
        Return "Ok"
    End Function


End Class
