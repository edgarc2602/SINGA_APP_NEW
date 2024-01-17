Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class Ventas_App_Ven_Cat_Cliente_Plantilla
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function plantillas(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_plantilla as 'td','', b.descripcion as 'td','', cantidad as 'td','', c.descripcion as 'td','', cast(jornal as numeric(12,2)) as 'td','', cast(smntope as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(cargasocial as numeric(12,2)) As 'td','', cast(uniforme as numeric(12,2)) as 'td','', case when formapago = 1 then 'Quincenal' when formapago = 2 then 'Semanal' else '0' end  as 'td','', " & vbCrLf)
        sqlbr.Append("case when sexo = 1 then 'Masculino' when sexo = 2 then 'Femenino' when sexo = 3 then 'Indistinto' end as 'td','', (select '@id' = 'bthorario', '@class' = 'btn btn-warning bthorario', '@type' ='button','@value' = 'Horarios' for xml path( 'input'), type) as 'td',''," & vbCrLf)
        sqlbr.Append("(select '@id' = 'btmodifica', '@class' = 'btn btn-success btmodifica', '@type' ='button','@value' = 'Modificar' for xml path( 'input'), type) as 'td','',")
        sqlbr.Append("(select '@id' = 'btborrar', '@class' = 'btn btn-danger btborra', '@type' ='button','@value' = 'Eliminar' for xml path( 'input'), type) as 'td'")
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno c on a.id_turno = c.id_turno where a.id_status =1 and id_inmueble = " & inmueble & "" & vbCrLf)
        sqlbr.Append(" order by b.descripcion, c.descripcion for xml path('tr'), root('tbody')")

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
    Public Shared Function inmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente = " & cliente & " order by nombre ")
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
    Public Shared Function puesto() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_puesto, descripcion from tb_puesto where id_status = 1 order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_puesto") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function turno() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_turno, descripcion from tb_turno where id_status = 1 order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_turno") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalleplantilla(ByVal plantilla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_puesto, id_turno, formapago, sexo  from tb_cliente_plantilla where id_plantilla = " & plantilla & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id_puesto:'" & dt.Rows(0)("id_puesto") & "', id_turno:'" & dt.Rows(0)("id_turno") & "', formapago:'" & dt.Rows(0)("formapago") & "',"
            sql += "sexo:'" & dt.Rows(0)("sexo") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function horarios(ByVal plantilla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select edadde, edada, horariode, horarioa, diade, diaa, horariofs, diadescanso from tb_cliente_plantilla where id_plantilla = " & plantilla & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{edadde:'" & dt.Rows(0)("edadde") & "', edada:'" & dt.Rows(0)("edada") & "', horariode:'" & dt.Rows(0)("horariode") & "'," & vbCrLf
            sql += "horarioa:'" & dt.Rows(0)("horarioa") & "', diade:'" & dt.Rows(0)("diade") & "', diaa:'" & dt.Rows(0)("diaa") & "'," & vbCrLf
            sql += "horariofs:'" & dt.Rows(0)("horariofs") & "', diadescanso:'" & dt.Rows(0)("diadescanso") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal plantilla As String) As String

        Dim sql As String = "Update tb_cliente_plantilla set id_status = 2 where id_plantilla =" & plantilla & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_plantilla", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardahorario(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_plantillahorario", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        idcte.Value = Request("id")
        nombre.Value = Request("nombre")

        Dim usuario As HttpCookie
        Dim userid As Integer
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
