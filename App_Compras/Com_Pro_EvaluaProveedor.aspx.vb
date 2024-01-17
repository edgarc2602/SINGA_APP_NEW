Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Xml
Partial Class App_Compras_Com_Pro_EvaluaProveedor
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
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
    Public Shared Function proveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, nombre from tb_proveedor where id_status = 1 ")
        sqlbr.Append("order by nombre")
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
    Public Shared Function cargastatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_status, descripcion from tb_statusep ")
        sqlbr.Append("order by id_status")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_status") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function inmueble(ByVal proveedor As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_proveedor_inmueble where id_status = 1 and id_proveedor =" & proveedor & " order by nombre")
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
    Private Shared Function ExisteEvaluacion(idEvaluacionProv As Integer) As Boolean
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim Existe As Boolean = False

        sqlbr.Append("select select EP.id_evaluacionproveedor, E.id_caracteristica " & vbCrLf)
        sqlbr.Append("From tb_evaluacionproveedor EP INNER Join tb_evaluacion E ON EP.id_proveedor = E.id_proveedor " & vbCrLf)
        sqlbr.Append("Where E.id_evaluacionproveedor = " & idEvaluacionProv & "")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            Existe = True
        End If
        Return Existe
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function preguntas(ByVal idEvaluacionProv As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sqlbrval As New StringBuilder
        Dim ExisteValua As Boolean = False

        sqlbrval.Append("select EP.id_proveedor, E.id_caracteristica " & vbCrLf)
        sqlbrval.Append("From tb_evaluacionproveedor EP INNER Join tb_evaluacion E ON EP.id_proveedor = E.id_proveedor " & vbCrLf)
        sqlbrval.Append("Where EP.id_evaluacionproveedor = " & idEvaluacionProv & "")
        Dim da As New SqlDataAdapter(sqlbrval.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            ExisteValua = True
        End If
        If ExisteValua Then '                                                                              input  class="form-control" type="text" id="txnumcontrato
            sqlbr.Append("select EP.id_proveedor as 'td','', C.id_caracteristica as 'td','', E.clavecalificacion as 'td','', C.descripcion as 'td','', " & vbCrLf)
            'sqlbr.Append(", E.clavecalificacion as 'td',''" & vbCrLf)
            'sqlbr.Append("(select case when C.id_caracteristica = 1 then " & Caract1 & " when C.id_caracteristica = 2 then " & Caract2 & " else '' end as criterios )  as 'td',''," & vbCrLf)
            sqlbr.Append("(criterios )  as 'td',''," & vbCrLf)
            sqlbr.Append("(select case when E.calificacion = 0 then '0' else E.calificacion end as '@value', case when E.calificacion = 0 then 'txcalificacion input' else 'txcalificacion input' end as '@class', 'input' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
            sqlbr.Append("from tb_evaluacionproveedor EP INNER JOIN tb_evaluacion E ON EP.id_proveedor = E.id_proveedor " & vbCrLf)
            sqlbr.Append("INNER JOIN tb_caracteristica C ON C.id_caracteristica = E.id_caracteristica" & vbCrLf)
        Else
            sqlbr.Append("select '0' as 'td','', C.id_caracteristica as 'td','','0' as 'td','', C.descripcion as 'td','', C.criterios as 'td', ''," & vbCrLf)
            'sqlbr.Append("'0' as 'td',''," & vbCrLf)
            sqlbr.Append("(select case when c.id_caracteristica = 0 then '0' else '0' end as '@value', case when c.id_caracteristica = 0 then 'txcalificacion input' else 'txcalificacion input' end as '@class', 'input' as '@type' for xml path('input'), root('td'),type) " & vbCrLf)
            '(select case when c.id_caracteristica = 0 then '0' else '0' end as '@value', case when c.id_caracteristica = 0 then 'txcalificacion input' else 'txcalificacion input' end as '@class', 'input' as '@type' for xml path('input'), root('td'),type) 
            sqlbr.Append("from  tb_caracteristica C " & vbCrLf)
        End If
        'VER TABLAS:  tb_evaluacionproveedor   tb_evaluacion
        If ExisteValua Then
            sqlbr.Append("where EP.id_evaluacionproveedor = " & idEvaluacionProv & " order by EP.id_proveedor, C.id_caracteristica for xml path('tr'), root ('tbody')")
        Else
            sqlbr.Append(" order by C.id_caracteristica for xml path('tr'), root ('tbody')")
        End If

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
        Dim mycommand As New SqlCommand("sp_evaluacionproveedor", myConnection)
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
    Public Shared Function autoriza(ByVal Folio As Integer) As String

        Dim generacorreo As New correocompras()
        generacorreo.evaluacionproveedor(Folio)
        Return "ok"

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function campania(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_proveedor, id_inmueble, id_gerente, id_supervisor, id_comprador, id_cgo, fecha, encuestado, id_encuesta, observacion," & vbCrLf)
        sqlbr.Append("edad, sexo, fingreso, correoenc, telenc" & vbCrLf)
        sqlbr.Append("from tb_encuesta_registro WHERE id_campania =" & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{proveedor:'" & dt.Rows(0)("id_proveedor") & "', inmueble:'" & dt.Rows(0)("id_inmueble") & "', gerente:'" & dt.Rows(0)("id_gerente") & "'," & vbCrLf
            sql += "supervisor:'" & dt.Rows(0)("id_supervisor") & "', comprador:'" & dt.Rows(0)("id_comprador") & "', cgo:'" & dt.Rows(0)("id_cgo") & "'," & vbCrLf
            sql += "fecha:'" & dt.Rows(0)("fecha") & "', encuestado:'" & dt.Rows(0)("encuestado") & "', encuesta:'" & dt.Rows(0)("id_encuesta") & "'," & vbCrLf
            sql += "edad:'" & dt.Rows(0)("edad") & "', sexo:'" & dt.Rows(0)("sexo") & "', fing:'" & dt.Rows(0)("fingreso") & "',"
            sql += "correoenc:'" & dt.Rows(0)("correoenc") & "', telenc:'" & dt.Rows(0)("telenc") & "',"
            sql += "observacion:'" & dt.Rows(0)("observacion") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cabecera(ByVal idevalprov As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_evaluacionproveedor, id_proveedor, id_status, fecha_evaluacion, numero_contrato, promedio, texto_promedio " & vbCrLf)
        sqlbr.Append("from tb_evaluacionproveedor WHERE id_evaluacionproveedor =" & idevalprov & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id_evaluacionproveedor:" & dt.Rows(0)("id_evaluacionproveedor") & ", id_proveedor:" & dt.Rows(0)("id_proveedor") & ", id_status:'" & dt.Rows(0)("id_status") & "'," & vbCrLf
            sql += "fecha_evaluacion:'" & dt.Rows(0)("fecha_evaluacion") & "', numero_contrato:'" & dt.Rows(0)("numero_contrato") & "',promedio:'" & dt.Rows(0)("promedio") & "', texto_promedio:'" & dt.Rows(0)("texto_promedio") & "'}" & vbCrLf
        End If
        Return sql
    End Function

End Class
