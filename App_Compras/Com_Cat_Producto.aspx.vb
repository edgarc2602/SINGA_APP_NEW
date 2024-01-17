Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Cat_Producto
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function unidad() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_unidad, descripcion from tb_unidadmedida order by id_unidad")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_unidad") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function familia(ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_familia, descripcion from tb_familia where id_status =1 and tipo= " & tipo & " order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_familia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function contarproducto(ByVal campo As String, ByVal valor As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_producto a inner join tb_familia b on a.id_familia = b.id_familia where a.id_status = 1 " & vbCrLf)
        If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
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
    Public Shared Function producto(ByVal pagina As Integer, ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select clave as 'td','', tipo as 'td','', familia as 'td','', servicio as 'td','', producto as 'td','', unidad as 'td','', stockminimo as 'td','', stockmaximo as 'td','',preciobase as 'td',''," & vbCrLf)
        sqlbr.Append("idtipo as 'td','', id_familia as 'td','', id_unidad as 'td','', id_cliente as 'td','', id_servicio as 'td'" & vbCrLf)
        sqlbr.Append("from(" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by a.descripcion) As RowNum, clave, case when a.tipo = 1 then 'Materiales' else 'Servicios' end tipo, " & vbCrLf)
        sqlbr.Append("b.descripcion as familia, a.descripcion as producto, c.descripcion as unidad, cast(stockminimo as numeric(12,2)) stockminimo, cast(stockmaximo as numeric(12,2)) stockmaximo," & vbCrLf)
        sqlbr.Append("a.tipo as idtipo, a.id_familia, a.id_unidad, cast(a.preciobase as numeric(12,2)) as preciobase, id_cliente, " & vbCrLf)
        sqlbr.Append("case when a.id_servicio = 1 then 'Mantenimiento' else 'Limpieza' end as servicio, id_servicio" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_familia b on a.id_familia = b.id_familia " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on a.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("WHERE a.id_status =1 " & vbCrLf)
        If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append(") result where RowNum BETWEEN (" & pagina & " - 1) * 50 + 1 And " & pagina & " * 50 order by producto For xml path('tr'), root('tbody') " & vbCrLf)


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
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_cliente") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_producto", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal producto As String) As String

        Dim sql As String = "Update tb_producto set id_status = 2 where clave ='" & producto & "';"
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
