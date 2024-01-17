Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Almacen_Alm_Pro_kardex
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function almacen() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, rtrim(nombre) as nombre from tb_almacen where id_status = 1 order by nombre ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_almacen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal desc As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', cast(a.costopromedio as numeric(12,2))  as 'td',''," & vbCrLf)
        sqlbr.Append("cast(a.existencia as numeric(12,2)) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_inventario a inner join tb_producto b on a.clave = b.clave" & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("where b.descripcion like '%" & desc & "%' and a.id_almacen =" & almacen & " for xml path('tr'), root('tbody')")
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
    Public Shared Function contarkd(ByVal fini As String, ByVal ffin As String, ByVal clave As String, ByVal almacen As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_kardex" & vbCrLf)
        sqlbr.Append("where clave='" & clave & "' and id_almacen =" & almacen & " and cast(fecha as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
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
    Public Shared Function kardex(ByVal fini As String, ByVal ffin As String, ByVal clave As String, ByVal almacen As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_kardex as 'td','', documento as 'td','', isnull(registro,'') as 'td','',fecha as 'td','', hora as 'td','', cast(cantidad as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(costoprom as numeric(12,2)) as 'td','', cast(existact as numeric(12,2)) as 'td','', cliente as 'td' from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by a.fecha) as rownum, id_kardex, b.descripcion as documento, " & vbCrLf)
        sqlbr.Append("case when a.id_documento = 3 then 'OC-' + cast(a.id_orden as varchar) " & vbCrLf)
        sqlbr.Append("when a.id_documento = 8 then 'LISTADO-' + cast(a.id_orden as varchar) when a.id_documento = 2 then 'SOL-' + cast(a.id_orden as varchar) end as registro, " & vbCrLf)
        sqlbr.Append("convert(varchar(12), fecha, 103) as fecha, convert(varchar(5), fecha, 114) as hora," & vbCrLf)
        sqlbr.Append("case when b.Tipo ='S' then cantidad * -1 else cantidad end as cantidad, costoprom, existact, isnull(c.nombre,'') as cliente    " & vbCrLf)
        sqlbr.Append("from tb_kardex a inner join tb_documentokdx b on a.id_documento = b.id_documento" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on a.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where clave='" & clave & "' and id_almacen =" & almacen & " and cast(fecha as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by fecha for xml path('tr'), root('tbody')")
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
