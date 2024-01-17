Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Partial Class App_RH_RH_Con_EmpleadoD
    Inherits System.Web.UI.Page


    <Web.Services.WebMethod()>
    Public Shared Function nombre(ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select paterno + ' ' + rtrim(materno) + ' ' + nombre as empleado from tb_empleado where id_empleado = " & emp & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        'sql = "["
        If dt.Rows.Count > 0 Then
            '   For x As Integer = 0 To dt.Rows.Count - 1
            '  If x > 0 Then sql += ","
            sql += "{empleado:'" & dt.Rows(0)("empleado") & "'}" & vbCrLf
            '     sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            'Next
        End If
        'sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function documentos(ByVal emp As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.id_documento as 'td','', b.descripcion as 'td','', a.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-success tbeditar' as '@class', 'Descarga' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''" & vbCrLf)
        sqlbr.Append("from tb_empleado_documento a inner join tb_documento b on a.id_documento = b.id_documento where a.id_empleado = " & emp & " for xml path('tr'), root ('tbody')")

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



        idempleado.Value = Request("emp")

    End Sub
End Class
