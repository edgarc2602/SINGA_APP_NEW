Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Aplicapago
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function facturas(ByVal proveedor As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_provision as 'td','', factura as 'td','', cast(total as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast(pago as numeric(12,2)) as 'td','', cast(total - pago as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select id_provision, factura, total, " & vbCrLf)
        sqlbr.Append("(select isnull(sum(pago),0) from tb_provisionpago where id_provision = a.id_provision) pago" & vbCrLf)
        sqlbr.Append("from tb_provision a where id_proveedor = " & proveedor & ") As tabla For xml path('tr'), root('tbody')")
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

            Dim mycommand As New SqlCommand("sp_provisionpago", myConnection, trans)
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
