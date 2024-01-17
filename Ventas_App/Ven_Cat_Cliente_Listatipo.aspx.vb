Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class Ventas_App_Ven_Cat_Cliente_Listatipo
    Inherits System.Web.UI.Page

    <Web.Services.WebMethod()>
    Public Shared Function frecuencia() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_frecuencia, descripcion from tb_frecuencia order by id_frecuencia")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_frecuencia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function inmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente & " order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_inmueble") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function materiales(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', '' as 'td','', b.descripcion as 'td','', d.descripcion as 'td','', CAST(Cantidad as numeric(12,2)) as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("cast(f.precio as numeric(12,2)) as 'td','', cast(Cantidad * f.precio as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Qsuitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_cliente_listatipo a inner join tb_producto b on a.clave = b.clave" & vbCrLf)
        sqlbr.Append("inner join tb_frecuencia c on a.id_frecuencia = c.id_frecuencia inner join tb_unidadmedida d on b.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio f on a.clave = f.clave and e.id_proveedor = f.id_proveedor" & vbCrLf)
        sqlbr.Append("where a.id_inmueble = " & inmueble & " order by b.descripcion for xml path('tr'), root('tbody')")

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
    Public Shared Function productol(ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', 10 as 'td' " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad  " & vbCrLf)
        sqlbr.Append("where tipo = 1 and id_status = 1 and a.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
    Public Shared Function guardalinea(ByVal folio As Integer, ByVal clave As String, ByVal frecuencia As Double, ByVal cantidad As Double) As String

        Dim sql As String = "insert into tb_cliente_listatipo (id_inmueble, clave, frecuencia, cantidad) values (" & folio & ",'" & clave & "'," & frecuencia & "," & cantidad & ");"
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

        idcte.Value = Request("id")
        nombre.Value = Request("nombre")
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
    End Sub
End Class
