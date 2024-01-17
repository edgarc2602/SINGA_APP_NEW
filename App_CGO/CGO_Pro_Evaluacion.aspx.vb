Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class App_CGO_CGO_Pro_Evaluacion
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function encuesta() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_encuesta, descripcion from tb_encuesta_nombre where id_status = 1 order by descripcion")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_encuesta") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 ")
        sqlbr.Append("order by nombre")
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
    Public Shared Function gerente(ByVal puesto As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 ")
        If puesto = "1000" Then
            sqlbr.Append("And id_puesto in(20,30,5,118) " & vbCrLf)
        Else
            sqlbr.Append("And id_puesto in(" & puesto & ")")
        End If
        sqlbr.Append("order by empleado")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("empleado") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function atiende(ByVal area As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT idpersonal, Per_Nombre+' '+Per_Paterno+' '+Per_Materno as nombre FROM personal" & vbCrLf)
        sqlbr.Append(" where per_status= 0 and idarea = " & area & "" & vbCrLf)
        sqlbr.Append("order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function preguntas(ByVal encuesta As Integer, ByVal campania As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.id_grupo as 'td','', a.consecutivo as 'td','', b.descripcion as 'td','', c.pregunta as 'td','', " & vbCrLf)
        sqlbr.Append("(select case when d.valor = 1 then '1' else '0' end as '@value', case when d.valor = 1 then 'tbstatus1 btn btn-success' else 'tbstatus1 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("(select case when d.valor = 2 then '2' else '0' end as '@value', case when d.valor = 2 then 'tbstatus2 btn btn-success' else 'tbstatus2 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("(select case when d.valor = 3 then '3' else '0' end as '@value', case when d.valor = 3 then 'tbstatus3 btn btn-success' else 'tbstatus3 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("(select case when d.valor = 4 then '4' else '0' end as '@value', case when d.valor = 4 then 'tbstatus4 btn btn-success' else 'tbstatus4 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("(select case when d.valor = 5 then '5' else '0' end as '@value', case when d.valor = 5 then 'tbstatus5 btn btn-success' else 'tbstatus5 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)," & vbCrLf)
        sqlbr.Append("(select case when d.valor = 0 then '0' else '0' end as '@value', case when d.valor = 0 then 'tbstatus6 btn btn-success' else 'tbstatus6 btn btn-secundary' end as '@class', 'button' as '@type' for xml path('input'), root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_encuesta_campania a inner join tb_encuesta_grupo b on a.id_grupo = b.id_grupo " & vbCrLf)
        sqlbr.Append("inner join tb_encuesta_pregunta c on a.consecutivo = c.consecutivo and a.id_grupo = c.id_grupo " & vbCrLf)
        sqlbr.Append("left outer join tb_encuesta_registrod d on d.id_campania = " & campania & " and c.id_grupo = d.id_grupo and c.consecutivo = d.consecutivo" & vbCrLf)
        sqlbr.Append("where id_encuesta = " & encuesta & " order by a.id_grupo,a.consecutivo for xml path('tr'), root ('tbody')")
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
        Dim mycommand As New SqlCommand("sp_encuesta", myConnection)
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
    Public Shared Function campania(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, id_inmueble, id_gerente, id_supervisor, id_comprador, id_cgo, fecha, encuestado, id_encuesta, observacion," & vbCrLf)
        sqlbr.Append("edad, sexo, fingreso, correoenc, telenc" & vbCrLf)
        sqlbr.Append("from tb_encuesta_registro WHERE id_campania =" & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{cliente:'" & dt.Rows(0)("id_cliente") & "', inmueble:'" & dt.Rows(0)("id_inmueble") & "', gerente:'" & dt.Rows(0)("id_gerente") & "'," & vbCrLf
            sql += "supervisor:'" & dt.Rows(0)("id_supervisor") & "', comprador:'" & dt.Rows(0)("id_comprador") & "', cgo:'" & dt.Rows(0)("id_cgo") & "'," & vbCrLf
            sql += "fecha:'" & dt.Rows(0)("fecha") & "', encuestado:'" & dt.Rows(0)("encuestado") & "', encuesta:'" & dt.Rows(0)("id_encuesta") & "'," & vbCrLf
            sql += "edad:'" & dt.Rows(0)("edad") & "', sexo:'" & dt.Rows(0)("sexo") & "', fing:'" & dt.Rows(0)("fingreso") & "',"
            sql += "correoenc:'" & dt.Rows(0)("correoenc") & "', telenc:'" & dt.Rows(0)("telenc") & "',"
            sql += "observacion:'" & dt.Rows(0)("observacion") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim usuario As HttpCookie
        Dim userid As Integer

        idfolio.Value = Request("folio")
        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = usuario.Value
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
