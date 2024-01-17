Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_Requisicion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function familia() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_familia, descripcion from tb_familia where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_familia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
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

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 order by nombre")
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
    Public Shared Function comprador() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select idpersonal, Per_Nombre + ' ' + Per_Paterno  + ' ' + Per_Materno as nombre from personal where per_status = 0 and idarea = 8 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function catproveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, rtrim(nombre) as nombre  from tb_proveedor where id_status = 1 order by nombre ")
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

        sqlbr.Append("select id_status, descripcion from tb_statusc  order by descripcion")
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
    Public Shared Function requisiciones(ByVal fini As String, ByVal ffin As String, ByVal emp As Integer, ByVal pro As Integer, ByVal cli As Integer, ByVal est As Integer, ByVal pagina As Integer, ByVal folio As Integer, ByVal tipo As Integer, ByVal comprador As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_requisicion as 'td','', falta as 'td','', empresa as 'td','', proveedor as 'td','', tipo as 'td','', isnull(comprador,'') as 'td','', cliente as 'td','', estatus as 'td',''," & vbCrLf)
        sqlbr.Append("elabora as 'td','', cast(total as numeric(12,2)) as 'td','', observacion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btimprime' as '@class', 'Imprimir' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btimprime1' as '@class', 'Integración' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btauto' as '@class', 'Autoriza/Rechaza' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btn-sm btoc' as '@class', 'Genera OC' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from ( Select  ROW_NUMBER() over (order by a.falta, b.nombre, c.nombre ) as rownum, id_requisicion,  b.nombre as empresa, isnull(c.nombre,'') as proveedor, isnull(d.nombre,'') as cliente, " & vbCrLf)
        sqlbr.Append("e.descripcion as estatus, convert(varchar(12), falta,103) as falta , f.Per_Nombre + ' ' + f.Per_Paterno as elabora, a.total, a.observacion," & vbCrLf)
        sqlbr.Append("case when a.tipo =1 then 'Entrega mensual' else 'Solicitado por el cliente' end as tipo, g.nombre + ' ' + g.paterno  + ' ' + rtrim(g.materno) as comprador" & vbCrLf)
        sqlbr.Append("from tb_requisicion a inner join tb_empresa b on a.id_empresa = b.id_empresa" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedor c on a.id_proveedor = c.id_proveedor" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente d on a.id_cliente = d.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_statusc e on a.id_status = e.id_status inner join personal f on a.ualta = f.IdPersonal" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado g on a.id_comprador = g.id_empleado" & vbCrLf)
        sqlbr.Append("where a.id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.falta as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If emp <> 0 Then sqlbr.Append("and a.id_empresa = " & emp & "")
        If pro <> 0 Then sqlbr.Append("and a.id_proveedor =" & pro & "")
        If cli <> 0 Then sqlbr.Append("and a.id_cliente =" & cli & "")
        If tipo <> 0 Then sqlbr.Append("and a.tipo =" & tipo & "")
        If comprador <> 0 Then sqlbr.Append("and a.id_comprador =" & comprador & "")
        If folio <> 0 Then sqlbr.Append("and id_requisicion =" & folio & "")
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by falta, empresa, proveedor for xml path('tr'), root('tbody')")
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
    Public Shared Function contarreq(ByVal fini As String, ByVal ffin As String, ByVal emp As Integer, ByVal pro As Integer, ByVal cli As Integer, ByVal est As Integer, ByVal folio As Integer, ByVal tipo As Integer, ByVal comprador As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_requisicion" & vbCrLf)
        sqlbr.Append("where id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and falta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If emp <> 0 Then sqlbr.Append("and id_empresa = " & emp & "")
        If pro <> 0 Then sqlbr.Append("and id_proveedor =" & pro & "")
        If cli <> 0 Then sqlbr.Append("and id_cliente =" & cli & "")
        If tipo <> 0 Then sqlbr.Append("and tipo =" & tipo & "")
        If comprador <> 0 Then sqlbr.Append("and id_comprador =" & comprador & "")
        If folio <> 0 Then sqlbr.Append("and id_requisicion =" & folio & "")
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

        Dim sql As String = "Update tb_requisicion set id_status = " & status & " where id_requisicion =" & req & ";"
        If status = 3 Then
            sql += "update tb_listadomaterial set id_requisicion = 0 where id_requisicion = " & req & ";"
        End If
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        Dim generacorreo As New correocompras()
        'If status = 2 Then
        'generacorreo.requisicionauto(req)
        'End If

        Return ""

    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        'Dim userid As Integer

        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            'userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
