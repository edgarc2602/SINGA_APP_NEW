Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Almacen_Alm_Pro_Conversion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function almacen() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, nombre from tb_almacen where id_status =1 and tipo =1 order by id_almacen ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_almacen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal desc As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("Select a.clave As 'td','', a.descripcion as 'td','', b.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("cast(case when c.costopromedio is null then a.preciobase when c.costopromedio = 0 then  a.preciobase else c.costopromedio end as numeric(12,2))  as 'td',''," & vbCrLf)
        sqlbr.Append("cast(isnull(c.existencia,0) as numeric(12,2)) as 'td'")
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_inventario c on a.clave = c.clave and id_almacen = " & almacen & "" & vbCrLf)
        sqlbr.Append("where tipo = 1 and a.id_status = 1 and a.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
    Public Shared Function guarda(ByVal registro As String, ByVal registro1 As String) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 17)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro1)
            mycommand.Parameters.AddWithValue("@docto", 18)
            Dim prmR1 As New SqlParameter("@Id", "0")
            prmR1.Size = 10
            prmR1.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR1)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

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
