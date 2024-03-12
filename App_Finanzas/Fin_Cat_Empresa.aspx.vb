Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Cat_Empresa
    Inherits System.Web.UI.Page
    Public listamenu As String = ""

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
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empresa as 'td','', nombre as 'td','', case when tipo = 1 then 'Manejo de Personal' else 'Operativa' end as 'td','', razonsocial as 'td','', rfc as 'td' from tb_empresa " & vbCrLf)
        sqlbr.Append("where id_estatus = 1 order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function detalle(ByVal empresa As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select tipo, registro, callenum, colonia, cp, municipio,id_estado" & vbCrLf)
        sqlbr.Append("From tb_empresa where id_empresa = " & empresa & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        da.Fill(ds)
        Dim x As Integer = 0
        sql = "{"
        If ds.Tables(0).Rows().Count > 0 Then
            sql += "tipo:'" & ds.Tables(0).Rows(0).Item("tipo") & "', registro:'" & ds.Tables(0).Rows(0).Item("registro") & "', callenum:'" & ds.Tables(0).Rows(0).Item("callenum") & "' , colonia: '" & ds.Tables(0).Rows(0).Item("colonia") & "',"
            sql += "cp:'" & ds.Tables(0).Rows(0).Item("cp") & "' , municipio:'" & ds.Tables(0).Rows(0).Item("municipio") & "',estado:'" & ds.Tables(0).Rows(0).Item("id_estado") & "'"
        End If
        sql += "}"
        Return sql

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empresa", myConnection)
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
    Public Shared Function guardadocto(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empresadocumento", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaregistro(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empresaregistro", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal empresa As String) As String

        Dim sql As String = "Update tb_empresa set id_estatus = 2 where id_empresa =" & empresa & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function documento() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_documentoempresa, nombre from tb_documentoempresa where id_status = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_documentoempresa") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadocto(ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_documento as 'td','', convert(varchar(12), a.fecha, 103) as 'td','', b.nombre as 'td','', Archivo as 'td','', convert(varchar(10), a.fecha, 112) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btquita' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From tb_empresadocumento a inner join tb_documentoempresa b on a.id_documentoempresa = b.id_documentoempresa " & vbCrLf)
        sqlbr.Append("where id_empresa = " & emp & "  for xml path('tr'), root('tbody')")
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
    Public Shared Function listaregistro(ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.registro as 'td','', b.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btquitareg' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From tb_empresaregistro	a inner join tb_estado b on a.id_estado= b.id_estado " & vbCrLf)
        sqlbr.Append("where id_empresa = " & emp & "  for xml path('tr'), root('tbody')")
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
    Public Shared Function eliminaa(ByVal folio As Integer) As String

        Dim sql As String = "delete from tb_empresadocumento where id_documento =" & folio & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminareg(ByVal folio As String) As String

        Dim sql As String = "delete from tb_empresaregistro where registro ='" & folio & "';"
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
        Dim cliente As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        cliente = Request.Cookies("cliente")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
    End Sub
End Class
