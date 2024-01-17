
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_RH_RH_Cat_Incidencia
    Inherits System.Web.UI.Page

    Public listamenu As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function incidencia() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("SELECT id_incidencia as 'td','', descripcion as 'td','', case when tipomov = 1 then 'Deducción' else 'Percepción' end as 'td','', case when tipo = 1 then 'Formula' else 'Monto'end as 'td',''," & vbCrLf)
        sqlbr.Append("case when tipo = 1 then rtrim(formula) Else cast(monto As varchar) End As 'td','', tipo as 'td','', tipomov as 'td'" & vbCrLf)
        sqlbr.Append("from tb_incidencia where id_status =1 order by descripcion for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_incidencia", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal incidencia As String) As String

        Dim sql As String = "Update tb_incidencia set id_status = 2 where id_incidencia =" & incidencia & ";"
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

        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
    End Sub
End Class
