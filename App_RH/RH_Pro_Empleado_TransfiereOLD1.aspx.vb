Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Empleado_Transfiere
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function empleados(ByVal inmueble As String, ByVal nombre As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.id_empleado as 'td','', a.paterno + ' ' + rtrim(a.materno) + ' '+ a.nombre as 'td','', b.descripcion as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("a.jornal as 'td','', case when a.formapago =1 then 'Quincenal' else 'Semanal' end as 'td','', cast(a.sueldo as numeric(12,2)) as 'td','', 'Activo' as 'td','', " & vbCrLf)
        sqlbr.Append("a.id_plantilla as 'td'")
        sqlbr.Append("From tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno c on a.id_turno = c.id_turno inner join tb_cliente_inmueble d on a.id_inmueble = d.id_inmueble " & vbCrLf)
        'sqlbr.Append("Left outer join tb_empleado_transfiere e on a.id_empleado = e.id_empleado" & vbCrLf)
        sqlbr.Append("where  a.id_status = 2 and a.id_inmueble = " & inmueble & " " & vbCrLf)
        If nombre <> "" Then
            sqlbr.Append("and a.paterno + rtrim(a.materno) + a.nombre like '%" & Replace(nombre, " ", "%") & "%'" & vbCrLf)
        End If
        sqlbr.Append("order by a.paterno, a.materno, a.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function datosextra(ByVal sucursal As Integer, ByVal puesto As Integer, ByVal turno As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select direccion + ' '+ colonia + ' ' + delegacionmunicipio + ' ' + cp + ' '+ b.descripcion as ubicacion" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a inner join tb_estado b on a.id_estado = b.id_estado  where id_inmueble = " & sucursal & ";" & vbCrLf)
        sqlbr.Append("Select 'Turno: ' + b.descripcion + ' Entrada: ' + horariode + ' Salida: '+ horarioa + ' Jornal: ' + cast(jornal as varchar) + ' De: ' + diade + ' A: ' + diaa as horario " & vbCrLf)
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_turno b on a.id_turno = b.id_turno where a.id_status = 1 and id_inmueble = " & sucursal & " and a.id_puesto = " & puesto & "  and a.id_turno = " & turno & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{ubicacion: '" & dt.Tables(0).Rows(0)("ubicacion") & "', horario: '" & dt.Tables(1).Rows(0)("horario") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select b.nombre + ' ' + rtrim(b.paterno) + ' ' + rtrim(b.materno)  as empleado, a.id_operativo," & vbCrLf)
        sqlbr.Append(" d.nombre + ' ' + rtrim(d.paterno) + ' ' + rtrim(d.materno)  as coordina, c.id_coordinador" & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_empleado b on a.id_operativo = b.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_gerente_coordinador c on b.id_empleado = c.id_gerente" & vbCrLf)
        sqlbr.Append("inner join tb_empleado d on c.id_coordinador = d.id_empleado " & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{idgerente: '" & dt.Rows(0)("id_operativo") & "', idcoordina: '" & dt.Rows(0)("id_coordinador") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal fecha As String, ByVal empleado As String, ByVal salida As String, ByVal llegada As String, ByVal usuario As Integer, ByVal gerente As Integer) As String '  ByVal puesto As String, , ByVal usuario As Integer

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_transfiere", myConnection)
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
        'If pvac = 1 Then
        ' generacorreo.correovacante(fecha, "Registro de Vacante", cliente, puesto, sucursal, ubicacion, horario, usuario)
        ' End If

        generacorreo.correotransfiere(fecha, "Transferencia de empleado", empleado, salida, llegada, usuario, gerente)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estructura(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_plantilla as 'td','', puesto as 'td','', turno as 'td','', cast(jornal as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("formapago as 'td','', sexo as 'td','', cast(smntope as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cantidad as 'td','', activos as 'td','', cantidad - activos as 'td','', id_puesto as 'td','', id_turno as 'td','', forma as 'td' from (" & vbCrLf)
        sqlbr.Append("select id_plantilla, b.descripcion as puesto, c.descripcion as turno, jornal, case when formapago = 1 then 'Quincenal' else 'Semanal' end formapago, " & vbCrLf)
        sqlbr.Append("case when sexo =1 then 'Masculino' when sexo = 2 then 'Femenino' when sexo = 3 then 'Indistinto' end sexo, smntope, cantidad," & vbCrLf)
        sqlbr.Append("(select COUNT (id_empleado) from tb_empleado where id_plantilla = a.id_plantilla and id_status = 2) As activos, a.formapago as forma," & vbCrLf)
        sqlbr.Append("a.id_puesto, a.id_turno" & vbCrLf)
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

    <Web.Services.WebMethod()>
    Public Shared Function validacliente(ByVal cliente1 As Integer, ByVal cliente2 As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empresa from tb_cliente where id_cliente = " & cliente1 & ";")
        sqlbr.Append("select id_empresa from tb_cliente where id_cliente = " & cliente2 & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            If dt.Tables(0).Rows(0)("id_empresa") <> dt.Tables(1).Rows(0)("id_empresa") Then
                sql += "{paso: 1}"
            Else
                sql += "{paso: 0}"
            End If
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
