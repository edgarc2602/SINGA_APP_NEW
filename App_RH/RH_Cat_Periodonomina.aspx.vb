Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_RH_RH_Cat_Periodonomina
    Inherits System.Web.UI.Page
    Public listamenu As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function existe(ByVal anio As Integer, ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select top 1 isnull(id_periodo,0) as id_periodo from tb_periodonomina where anio =" & anio & " and descripcion ='" & tipo & "' ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_periodo") & "'}"
        Else
            sql += "{id:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function generasemana(ByVal anio As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_pernominasem", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@dato", anio)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function generaquincena(ByVal anio As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_pernominaqin", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@dato", anio)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function periodos(ByVal mes As Integer, ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_periodo as 'td','', anio as 'td','', convert(varchar(10),finicio, 103) as 'td','', convert(varchar(10),ffin, 103) as 'td',''," & vbCrLf)
        sqlbr.Append("(select case when activo=0 then 'Inactivo' else 'Activo' end as '@value', 'tbstatus' as '@class', 'button' as '@type' for xml path('input'), root('td'),type)")
        sqlbr.Append("from tb_periodonomina where anio = " & mes & " and descripcion = '" & tipo & "' for xml path('tr'), root('tbody')")

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
    Public Shared Function activa(ByVal periodo As Integer, ByVal anio As Integer, ByVal tipo As String, ByVal valor As Integer) As String

        Dim sql As String = "Update tb_periodonomina set activo = " & valor & " where id_periodo =" & periodo & " and descripcion = '" & tipo & "' and anio = " & anio & ";"
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
        Dim cliente As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        cliente = Request.Cookies("cliente")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
    End Sub
End Class
