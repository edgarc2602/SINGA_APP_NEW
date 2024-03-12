Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class Ventas_App_Ven_Cat_Cliente_inmueble
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function contarinmueble(ByVal cliente As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_cliente_inmueble where id_status = 1 and id_cliente=" & cliente & "" & vbCrLf)

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
    Public Shared Function cargainmueble(ByVal cliente As Integer, ByVal pagina As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_inmueble as 'td','', nombre as 'td','', ceco as 'td','', descripcion as 'td','', oficina as 'td',''," & vbCrLf)
        sqlbr.Append("nombrecontacto as 'td','', isnull(tel1,'') as 'td' from" & vbCrLf)
        sqlbr.Append("(select ROW_NUMBER()Over(Order by a.nombre) As RowNum, id_inmueble, a.nombre, isnull(ceco,0) as ceco, b.descripcion, isnull(c.nombre,'') as oficina, nombrecontacto, tel1" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a inner join tb_tipoinmueble b on a.id_tipoinmueble = b.id_tipoinmueble" & vbCrLf)
        sqlbr.Append("Left outer join tb_oficina c on a.id_oficina = c.id_oficina where a.id_status = 1 and id_cliente = " & cliente & ") as resu" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 50 + 1 And " & pagina & " * 50 order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function tipo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_tipoinmueble, descripcion from tb_tipoinmueble where id_status = 1 order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_tipoinmueble") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estado() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_estado, descripcion from tb_estado order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function oficina(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_oficina, b.nombre from tb_cliente_oficina a inner join tb_oficina b on a.id_oficina = b.id_oficina where a.id_cliente =" & cliente & " order by b.nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_oficina") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_puntoatencion", myConnection)
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
    Public Shared Function datosinmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select direccion, entrecalles, cp, colonia, delegacionmunicipio, ciudad, id_estado,tel2, emailcontacto, " & vbCrLf)
        sqlbr.Append("cargocontacto, id_tipoinmueble, id_oficina, presupuestol, presupuestoh, presupuestom,centrocosto, prefijo, " & vbCrLf)
        sqlbr.Append("latitud, longitud, materiales, banio" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble where id_inmueble = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{calle:'" & dt.Rows(0)("direccion") & "'," & vbCrLf
            sql += "entrecalle:'" & dt.Rows(0)("entrecalles") & "'," & vbCrLf
            sql += "cp:'" & dt.Rows(0)("cp") & "'," & vbCrLf
            sql += "colonia:'" & dt.Rows(0)("colonia") & "'," & vbCrLf
            sql += "del:'" & dt.Rows(0)("delegacionmunicipio") & "'," & vbCrLf
            sql += "ciudad:'" & dt.Rows(0)("ciudad") & "'," & vbCrLf
            sql += "estado:'" & dt.Rows(0)("id_estado") & "'," & vbCrLf
            sql += "tel2:'" & dt.Rows(0)("tel2") & "'," & vbCrLf
            sql += "correo:'" & dt.Rows(0)("emailcontacto") & "'," & vbCrLf
            sql += "cargo:'" & dt.Rows(0)("cargocontacto") & "'," & vbCrLf
            sql += "tipo:'" & dt.Rows(0)("id_tipoinmueble") & "'," & vbCrLf
            sql += "oficina:'" & dt.Rows(0)("id_oficina") & "'," & vbCrLf
            sql += "ptto1:'" & dt.Rows(0)("presupuestol") & "'," & vbCrLf
            sql += "ptto2:'" & dt.Rows(0)("presupuestoh") & "'," & vbCrLf
            sql += "ptto3:'" & dt.Rows(0)("presupuestom") & "'," & vbCrLf
            sql += "cc:'" & dt.Rows(0)("centrocosto") & "'," & vbCrLf
            sql += "prefijo:'" & dt.Rows(0)("prefijo") & "'," & vbCrLf
            sql += "latitud:'" & dt.Rows(0)("latitud") & "'," & vbCrLf
            sql += "longitud:'" & dt.Rows(0)("longitud") & "'," & vbCrLf
            sql += "materiales:'" & dt.Rows(0)("materiales") & "'," & vbCrLf
            sql += "banio:'" & dt.Rows(0)("banio") & "'," & vbCrLf
            sql += "}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal inmueble As String) As String

        Dim sql As String = "Update tb_cliente_inmueble set id_status = 2 where id_inmueble =" & inmueble & ";"
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
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
