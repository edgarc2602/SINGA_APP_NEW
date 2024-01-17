Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Empleado_act
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function contarempleado() As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_empleado where id_status = 2 and confirmaimss = 0" & vbCrLf)
        'If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
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
    Public Shared Function empleados(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select cliente as 'td','', sucursal as 'td','', tipo as 'td','',id_empleado as 'td','', empleado as 'td',''," & vbCrLf)
        sqlbr.Append("rfc as 'td','',  curp as 'td','', ss as 'td','', banco as 'td','', cuenta as 'td','', tarjeta as 'td','', fingreso as 'td' from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by paterno, materno, a.nombre) As RowNum, isnull(b.nombre,'') as cliente, isnull(c.nombre,'') as sucursal, case when tipo = 1 then 'Administrativo' else 'Operativo' end tipo," & vbCrLf)
        sqlbr.Append("id_empleado, rtrim(paterno) + ' ' + rtrim(materno) + ' ' + a.nombre empleado, " & vbCrLf)
        sqlbr.Append("rfc, curp, ss, isnull(d.descripcion,'') as banco, isnull(a.cuenta,'') as cuenta, isnull(a.tarjeta,'') as tarjeta, isnull(convert(varchar(10),fingreso,103),'') fingreso" & vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("Left outer join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_banco d on a.id_banco = d.id_banco ")
        sqlbr.Append("where a.id_status = 2 and confirmaimss = 0 and pensionado=0) tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 + 1 And " & pagina & " * 50 order by empleado  for xml path('tr'), root('tbody')")

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
    Public Shared Function banco() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_banco, descripcion from tb_banco order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_banco") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualiza(ByVal empleado As String, ByVal cuenta As String, ByVal archivo As String) As String

        Dim sql As String = "Update tb_empleado set confirmaimss = 1, cuenta =" & cuenta & "  where id_empleado =" & empleado & ";"
        sql += "insert into tb_empleado_documento (id_empleado, id_documento, descripcion) values (" & empleado & ",1,'" & archivo & "');"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value

            tipomov.Value = Request("tipo")
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
