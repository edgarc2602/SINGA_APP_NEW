Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_pro_recepcione
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function orden(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_orden, id_requisicion, a.id_proveedor, b.nombre proveedor, c.nombre empresa, e.nombre as cliente," & vbCrLf)
        sqlbr.Append("subtotal, iva, total, a.id_cliente, a.id_status, d.dias" & vbCrLf)
        sqlbr.Append("from tb_ordencompra a inner join tb_proveedor b on a.id_proveedor = b.id_proveedor" & vbCrLf)
        sqlbr.Append("inner join tb_empresa c on a.id_empresa = c.id_empresa" & vbCrLf)
        sqlbr.Append("inner join tb_credito d on b.credito = d.id_credito" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente e on a.id_cliente = e.id_cliente" & vbCrLf)
        sqlbr.Append("where id_orden = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_orden") & "', req:'" & dt.Rows(0)("id_requisicion") & "', proveedor:'" & dt.Rows(0)("proveedor") & "', empresa:'" & dt.Rows(0)("empresa") & "', cliente:'" & dt.Rows(0)("cliente") & "',"
            sql += " subtotal:'" & Format(dt.Rows(0)("subtotal"), "#0.00") & "', iva:'" & Format(dt.Rows(0)("iva"), "#0.00") & "', total:'" & Format(dt.Rows(0)("total"), "#0.00") & "',"
            sql += " idcte:'" & dt.Rows(0)("id_cliente") & "', estatus:'" & dt.Rows(0)("id_status") & "', idpro:'" & dt.Rows(0)("id_proveedor") & "', credito:'" & dt.Rows(0)("dias") & "'}"
        End If
        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_recepcione", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            Dim prmR As New SqlParameter("@IdMov", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            folio = 0
        End Try
        myConnection.Close()
        Return folio

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        'Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idorden.Value = Request("folio")
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
