Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_Mantenimiento_Man_Cat_TrabajosPreventivo
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function guarda(desc As String) As String

        Dim sql = "insert into tb_trabajos_preventivo (descripcion, id_status) values('" & desc & "', 1)"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function trabajospreventivo(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_trabajo_preventivo as 'td','', descripcion as 'td','' " & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Sucursales' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by descripcion) As RowNum, id_trabajo_preventivo, descripcion " & vbCrLf)
        sqlbr.Append("from tb_trabajos_preventivo where id_status = 1" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 10 And " & pagina & " * 10 order by descripcion for xml path('tr'), root('tbody')")

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
    Public Shared Function contartrabajos() As String

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/10 + 1 as Filas, COUNT(*) % 10 as Residuos FROM tb_trabajos_preventivo" & vbCrLf)

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
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub


End Class
