Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class App_Finanzas_Fin_Pro_Provisionfactura
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function facturas() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.id_recepcion as 'td','', a.id_orden as 'td','', c.nombre as 'td','', cast(a.importe as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(a.iva as numeric(12,2)) as 'td','', cast(a.total as numeric(12,2)) as 'td','', a.factura as 'td','', " & vbCrLf)
        sqlbr.Append("convert(varchar(12),a.ffactura, 103) as 'td','', isnull(d.dias,0) as 'td',''," & vbCrLf)
        sqlbr.Append("convert(varchar(12),DATEADD(DAY, isnull(d.dias,0), a.ffactura),103)as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'tbstatus' as '@class', 'checkbox' as '@type' for xml path('input'), root('td'),type),''," & vbCrLf)
        sqlbr.Append("b.id_proveedor as 'td'")
        sqlbr.Append("from tb_recepcion a inner join tb_ordencompra b on a.id_orden = b.id_orden " & vbCrLf)
        sqlbr.Append("inner join tb_proveedor c on b.id_proveedor = c.id_proveedor" & vbCrLf)
        sqlbr.Append("left outer join tb_credito d on c.credito = d.id_credito" & vbCrLf)
        sqlbr.Append("where interface = 0 order by a.ffactura desc for xml path('tr'), root('tbody')")
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
        Dim aa As String = ""

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_provision", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.ExecuteNonQuery()

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return ""

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
