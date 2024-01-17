Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Pro_recepcion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cargaoc(ByVal orden As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_requisicion, b.nombre proveedor, c.nombre empresa, d.nombre almacen, e.nombre as cliente," & vbCrLf)
        sqlbr.Append("a.id_almacen, a.id_cliente" & vbCrLf)
        sqlbr.Append("from tb_ordencompra a inner join tb_proveedor b on a.id_proveedor = b.id_proveedor" & vbCrLf)
        sqlbr.Append("inner join tb_empresa c on a.id_empresa = c.id_empresa inner join tb_almacen d on a.id_almacen = d.id_almacen" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente e on a.id_cliente = e.id_cliente" & vbCrLf)
        sqlbr.Append("where id_orden = " & orden & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{req:'" & dt.Rows(0)("id_requisicion") & "', proveedor:'" & dt.Rows(0)("proveedor") & "', empresa:'" & dt.Rows(0)("empresa") & "', almacen:'" & dt.Rows(0)("almacen") & "', cliente:'" & dt.Rows(0)("cliente") & "',"
            sql += " idalmacen:'" & dt.Rows(0)("id_almacen") & "', idcliente:'" & dt.Rows(0)("id_cliente") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalleoc(ByVal orden As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', b.descripcion as 'td','',c.descripcion as 'td','', cast(precio as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast(cantidad-recibido as numeric(12,2)) As 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad-recibido as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btcarga' as '@class', 'Carga Datos' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_ordencomprad a inner join tb_producto b on a.clave = b.clave " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("where id_orden = " & orden & " for xml path('tr'), root('tbody')")
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If

        'myConnection.Close().03¿¿
        '    +98kkk  
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 3)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_recepcion", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            Dim prmR1 As New SqlParameter("@IdMov", "0")
            prmR1.Size = 10
            prmR1.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR1)
            mycommand.ExecuteNonQuery()

            folio = prmR1.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

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
