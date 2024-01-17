Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_ordencompra
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function contaroc(ByVal fini As String, ByVal ffin As String, ByVal emp As Integer, ByVal pro As Integer, ByVal cli As Integer, ByVal est As Integer, ByVal folio As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_ordencompra" & vbCrLf)
        sqlbr.Append("where id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and falta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If emp <> 0 Then sqlbr.Append("and id_empresa = " & emp & "")
        If pro <> 0 Then sqlbr.Append("and id_proveedor =" & pro & "")
        If cli <> 0 Then sqlbr.Append("and id_cliente =" & cli & "")
        If folio <> 0 Then sqlbr.Append("and id_orden =" & folio & "")
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
    Public Shared Function ordenes(ByVal fini As String, ByVal ffin As String, ByVal emp As Integer, ByVal pro As Integer, ByVal cli As Integer, ByVal est As Integer, ByVal pagina As Integer, ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_orden as 'td','', tipo as 'td','', falta as 'td','', empresa as 'td','', proveedor as 'td','', cliente as 'td','', estatus as 'td',''," & vbCrLf)
        sqlbr.Append("elabora as 'td','', cast(total as numeric(12,2)) as 'td','', observacion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btimprime' as '@class', 'Imprimir' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btauto' as '@class', 'Autoriza/Rechaza' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btrecibe' as '@class', 'Recepción' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("inventario as 'td'" & vbCrLf)
        sqlbr.Append("from ( Select  ROW_NUMBER() over (order by a.falta, b.nombre, c.nombre ) as rownum, id_orden,  b.nombre as empresa, isnull(c.nombre,'') as proveedor, isnull(d.nombre,'') as cliente, " & vbCrLf)
        sqlbr.Append("e.descripcion as estatus, convert(varchar(12), falta,103) as falta , f.Per_Nombre + ' ' + f.Per_Paterno as elabora, a.total, a.observacion, a.inventario," & vbCrLf)
        sqlbr.Append("case when a.tipo = 1 then 'Materiales' else 'Servicios' end as tipo" & vbCrLf)
        sqlbr.Append("from tb_ordencompra a inner join tb_empresa b on a.id_empresa = b.id_empresa" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedor c on a.id_proveedor = c.id_proveedor" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente d on a.id_cliente = d.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_statusc e on a.id_status = e.id_status inner join personal f on a.ualta = f.IdPersonal" & vbCrLf)
        sqlbr.Append("where a.id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.falta as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If emp <> 0 Then sqlbr.Append("and a.id_empresa = " & emp & "")
        If pro <> 0 Then sqlbr.Append("and a.id_proveedor =" & pro & "")
        If cli <> 0 Then sqlbr.Append("and a.id_cliente =" & cli & "")
        If folio <> 0 Then sqlbr.Append("and id_orden =" & folio & "")
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
