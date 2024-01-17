Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Banfuturo_Ban_Con_SolicitudD
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        hdfolio.Value = Request("folio")

    End Sub

    <Web.Services.WebMethod()>
    Public Shared Function nombre(ByVal fol As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select paterno + ' ' + rtrim(materno) + ' ' + nombre as empleado from tb_solicitudprestamo a "&vbCrLf)
        sqlbr.Append("inner join tb_empleado b on a.id_empleado=b.id_empleado" & vbCrLf)
        sqlbr.Append("where id_solicitud=" & fol & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        'sql = "["
        If dt.Rows.Count > 0 Then
            sql += "{empleado:'" & dt.Rows(0)("empleado") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function documentos(ByVal emp As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_solicitud as 'td','', archivo as 'td','', documento as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-success tbeditar' as '@class', 'Descarga' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''" & vbCrLf)
        sqlbr.Append("from tb_solicitudprestamod  where id_solicitud = " & emp & " and status=1 for xml path('tr'), root ('tbody')")
        'select id_solicitud, archivo, documento from tb_solicitudprestamod where id_solicitud=2168 and status=1 order by fecha, archivo asc

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

End Class
