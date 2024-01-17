Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_EvaluaProveedor
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function proveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, nombre from tb_proveedor where id_status = 1 ")
        sqlbr.Append("order by nombre")
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
    Public Shared Function cambiaestatus(ByVal Folio As Integer, ByVal status As Integer, ByVal usuario As Integer) As String

        Dim sql As String = "Update tb_evaluacionproveedor set id_status = " & status & " "
        sql += " where id_evaluacionproveedor =" & Folio & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function encuestas(ByVal fini As String, ByVal ffin As String, ByVal proveedor As Integer, folio As String, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin
        If folio.Trim = "" Then folio = "0"
        sqlbr.Append("select id_evaluacionproveedor as 'td','', id_proveedor as 'td','', proveedor as 'td','', id_status as 'td','',status as 'td','', numero_contrato as 'td'," & vbCrLf)
        sqlbr.Append("'', Format(fecha_evaluacion, 'dd/MM/yyyy') as 'td' ,'', promedio as 'td','', texto_promedio as 'td', '',  " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btcerrado' as '@class', 'Cerrar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary bteditar' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btimprimir' as '@class', 'Imprimir' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''" & vbCrLf)
        sqlbr.Append("from (Select ROW_NUMBER() over (order by P.nombre, Format(fecha_evaluacion, 'dd/MM/yyyy')) as rownum, EP.id_evaluacionproveedor, EP.id_proveedor, P.nombre as proveedor, EP.id_status as id_status, S.descripcion as status, EP.numero_contrato, fecha_evaluacion, promedio,texto_promedio  " & vbCrLf)
        sqlbr.Append("from tb_evaluacionproveedor EP inner join tb_proveedor P on EP.id_proveedor = P.id_proveedor" & vbCrLf)
        'sqlbr.Append("inner join tb_caracteristica C on c.id_caracteristica = c.id_caracteristica " & vbCrLf)
        sqlbr.Append("inner join tb_statusep S on EP.id_status = S.id_status " & vbCrLf)
        sqlbr.Append("where EP.id_status in (1,2) " & vbCrLf)
        If fini <> "" Then sqlbr.Append("and EP.fecha_evaluacion between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If proveedor <> 0 Then sqlbr.Append("and EP.id_proveedor =" & proveedor & " " & vbCrLf)
        If folio <> "0" Then sqlbr.Append("And EP.id_evaluacionproveedor =" & folio & "" & vbCrLf)
        sqlbr.Append(") tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by id_evaluacionproveedor,id_proveedor, numero_contrato " & vbCrLf)
        sqlbr.Append("For xml path('tr'), root('tbody')")

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
    Public Shared Function contarencuesta(ByVal fini As String, ByVal ffin As String, ByVal proveedor As Integer, folio As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_evaluacionproveedor" & vbCrLf)
        sqlbr.Append("where id_status in (1,2) " & vbCrLf)
        If fini <> "" Then sqlbr.Append("and fecha_evaluacion between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If proveedor <> 0 Then sqlbr.Append("and id_proveedor =" & proveedor & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_evaluacionproveedor =" & folio & "" & vbCrLf)
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
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        'idproveedor1.Value = Request.Cookies("proveedor").Value

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
