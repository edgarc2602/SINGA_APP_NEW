Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Vacante
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleadoop(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado from personal where idpersonal = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_empleado") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente(ByVal encargado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1  order by nombre") 'and id_operativo = " & encargado & "
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
    Public Shared Function puesto(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECt distinct a.id_puesto, b.descripcion from tb_cliente_plantilla a inner join tb_puesto b on a.id_puesto = b.id_puesto where id_inmueble = " & inmueble & " and a.id_status = 1 order by descripcion")
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
    Public Shared Function datosinm(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select direccion, colonia, delegacionmunicipio, id_estado,cp from tb_cliente_inmueble where id_inmueble = " & inmueble & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{direccion:'" & dt.Rows(0)("direccion") & "', colonia:'" & dt.Rows(0)("colonia") & "', delegacion:'" & dt.Rows(0)("delegacionmunicipio") & "'," & vbCrLf
            sql += "estado:'" & dt.Rows(0)("id_estado") & "', cp:'" & dt.Rows(0)("cp") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select b.nombre + ' ' + rtrim(b.paterno) + ' ' + rtrim(b.materno)  as empleado," & vbCrLf)
        sqlbr.Append(" d.nombre + ' ' + rtrim(d.paterno) + ' ' + rtrim(d.materno)  as coordina, c.id_coordinador" & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_empleado b on a.id_operativo = b.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_gerente_coordinador c on b.id_empleado = c.id_gerente" & vbCrLf)
        sqlbr.Append("inner join tb_empleado d on c.id_coordinador = d.id_empleado " & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{nombre: '" & dt.Rows(0)("empleado") & "', coordina: '" & dt.Rows(0)("coordina") & "', idcoordina: '" & dt.Rows(0)("id_coordinador") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleadorh(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select d.nombre+ ' ' + d.paterno +' ' + d.materno as nombre" & vbCrLf)
        sqlbr.Append("        From tb_cliente b inner join tb_gerente_coordinador c on b.id_operativo = c.id_gerente" & vbCrLf)
        sqlbr.Append("inner join tb_empleado d on c.id_coordinador = d.id_empleado  where b.id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{nombre:'" & dt.Rows(0)("nombre") & "'}" & vbCrLf
        End If
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
    Public Shared Function turno(ByVal puesto As Integer, ByVal suc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_turno, b.descripcion from tb_cliente_plantilla a inner join tb_turno b on a.id_turno = b.id_turno  where id_inmueble = " & suc & " and id_puesto = " & puesto & " and a.id_status = 1")
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
    Public Shared Function datosplantilla(ByVal plantilla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select smntope, formapago, sexo, edadde, edada, ltrim(horariode) horariode, ltrim(horarioa) horarioa, jornal, diade, diaa, diadescanso, horariofs from tb_cliente_plantilla where id_plantilla = " & plantilla & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{sueldo:'" & dt.Rows(0)("smntope") & "', formap:'" & dt.Rows(0)("formapago") & "', sexo:'" & dt.Rows(0)("sexo") & "'," & vbCrLf
            sql += "edadde:'" & dt.Rows(0)("edadde") & "', edada:'" & dt.Rows(0)("edada") & "', horariode:'" & dt.Rows(0)("horariode") & "'," & vbCrLf
            sql += "horarioa:'" & dt.Rows(0)("horarioa") & "', jornal:'" & dt.Rows(0)("jornal") & "', diade:'" & dt.Rows(0)("diade") & "'," & vbCrLf
            sql += "diaa:'" & dt.Rows(0)("diaa") & "', diadescanso:'" & dt.Rows(0)("diadescanso") & "', horariofs:'" & dt.Rows(0)("horariofs") & "' }"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal ubicacion As String, ByVal horario As String, ByVal idcli As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_vacante", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Dim generacorreo As New enviocorreo()
        generacorreo.correovacante(fecha, "Registro de Vacante", cliente, puesto, sucursal, ubicacion, horario, idcli, prmR.Value)

        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function vacante(ByVal folio As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_tipo, a.id_cliente, a.id_inmueble, a.id_puesto, g.nombre, g.direccion, g.colonia, g.delegacionmunicipio, g.id_estado, g.cp, ubicacion, " & vbCrLf)
        sqlbr.Append("b.nombre + ' '+ b.paterno + ' ' + b.materno as operativo, d.nombre + ' '+ d.paterno + ' ' + d.materno as coordina," & vbCrLf)
        sqlbr.Append("f.smntope, f.formapago, f.sexo, f.edadde, f.edada, f.horariode, f.horarioa, f.jornal,	f.id_turno, f.diade, f.diaa, f.diadescanso, observacion, a.experiencia " & vbCrLf)
        sqlbr.Append("from tb_vacante a inner join tb_cliente c on a.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_empleado b on c.id_operativo = b.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_gerente_coordinador e on c.id_operativo = e.id_gerente " & vbCrLf)
        sqlbr.Append("Left outer join tb_empleado d on e.id_coordinador = d.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble g on a.id_inmueble = g.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_plantilla f on a.id_inmueble = f.id_inmueble and a.id_puesto = f.id_puesto and a.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("where a.id_vacante = '" & folio & "'")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{tipo:'" & dt.Rows(0)("id_tipo") & "', cliente:'" & dt.Rows(0)("id_cliente") & "', puntoatn:'" & dt.Rows(0)("nombre") & "', direccion:'" & dt.Rows(0)("direccion") & "'," & vbCrLf
            sql += "inmueble:'" & dt.Rows(0)("id_inmueble") & "', "
            sql += "colonia:'" & dt.Rows(0)("colonia") & "', delmun:'" & dt.Rows(0)("delegacionmunicipio") & "', estado:'" & dt.Rows(0)("id_estado") & "'," & vbCrLf
            sql += "cp:'" & dt.Rows(0)("cp") & "', ubicacion:'" & dt.Rows(0)("ubicacion") & "', operativo:'" & dt.Rows(0)("operativo") & "'," & vbCrLf
            sql += "coordina:'" & dt.Rows(0)("coordina") & "', sueldo:'" & dt.Rows(0)("smntope") & "', formapago:'" & dt.Rows(0)("formapago") & "'," & vbCrLf
            sql += "sexo:'" & dt.Rows(0)("sexo") & "', edadde:'" & dt.Rows(0)("edadde") & "', edada:'" & dt.Rows(0)("edada") & "'," & vbCrLf
            sql += "horariode:'" & dt.Rows(0)("horariode") & "', horarioa:'" & dt.Rows(0)("horarioa") & "', jornal:'" & dt.Rows(0)("jornal") & "'," & vbCrLf
            sql += "turno:'" & dt.Rows(0)("id_turno") & "', diasde:'" & dt.Rows(0)("diade") & "', diasa:'" & dt.Rows(0)("diaa") & "'," & vbCrLf
            sql += "diasdes:'" & dt.Rows(0)("diadescanso") & "', observacion:'" & dt.Rows(0)("observacion") & "',"
            sql += "puesto:'" & dt.Rows(0)("id_puesto") & "', experiencia:'" & dt.Rows(0)("experiencia") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estructura(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_plantilla as 'td','', puesto as 'td','', turno as 'td','', cast(jornal as numeric(12,2)) as 'td','', "& vbCrLf)
        sqlbr.Append("formapago as 'td','', tiponomina as 'td','', sexo as 'td','', cast(smntope as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cantidad as 'td','', activos as 'td','', vacantes as 'td','', cantidad - activos - vacantes as 'td','', id_puesto as 'td','', id_turno as 'td' from (" & vbCrLf)
        sqlbr.Append("select id_plantilla, b.descripcion as puesto, c.descripcion as turno, jornal, case when formapago = 1 then 'Quincenal' else 'Semanal' end formapago, " & vbCrLf)
        sqlbr.Append("case when sexo =1 then 'Masculino' when sexo = 2 then 'Femenino' when sexo = 3 then 'Indistinto' end sexo, smntope, cantidad," & vbCrLf)
        sqlbr.Append("(select COUNT (id_empleado) from tb_empleado where id_plantilla = a.id_plantilla and id_status = 2) As activos," & vbCrLf)
        sqlbr.Append("(select count(id_vacante) from tb_vacante where id_plantilla = a.id_plantilla and id_status = 1) as vacantes,")
        sqlbr.Append("a.id_puesto, a.id_turno, 1 as tiponomina" & vbCrLf) 'case when tiponomina = 1 then 'Normal' else 'Jornales' end
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno c on a.id_turno = c.id_turno" & vbCrLf)
        sqlbr.Append("where a.id_inmueble = " & inmueble & " and a.id_status = 1) as result for xml path('tr'), root('tbody')")
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
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        idvacante.Value = Request("id")
        'idusuario.Value = 22
        Dim usuario As HttpCookie
        Dim userid As Integer

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
