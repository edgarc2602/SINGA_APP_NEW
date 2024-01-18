﻿Imports System.Data
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
        sqlbr.Append("a.id_plantilla as 'td','', e.posicion as 'td'" & vbCrLf)
        sqlbr.Append("From tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno c on a.id_turno = c.id_turno inner join tb_cliente_inmueble d on a.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_plantillap e on a.id_empleado = e.id_empleado" & vbCrLf)
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
        sqlbr.Append("select id_operativo, id_coordinadorrh from tb_cliente " & vbCrLf)
        sqlbr.Append("where id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{idgerente: '" & dt.Rows(0)("id_operativo") & "', idcoordina: '" & dt.Rows(0)("id_coordinadorrh") & "'}" & vbCrLf
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

        generacorreo.correotransfiere(fecha, "Transferencia de empleado", empleado, salida, llegada, usuario, gerente)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estructura(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select b.id_plantilla as 'td','', a.posicion as 'td','', c.descripcion as 'td','', d.descripcion as 'td','', cast(b.jornal as numeric(12,2)) as 'td','',"& vbCrLf)
        sqlbr.Append("case when b.formapago = 1 then 'Quincenal' else 'Semanal' end as 'td','', " & vbCrLf)
        sqlbr.Append("case when sexo =1 then 'Masculino' when sexo = 2 then 'Femenino' when sexo = 3 then 'Indistinto' end as 'td','', cast(smntope as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("isnull(e.paterno + ' ' + rtrim(e.materno) + ' ' + e.nombre,'') as 'td','', isnull(f.id_vacante,'') as 'td','', " & vbCrLf)
        sqlbr.Append("b.id_puesto as 'td','', b.id_turno as 'td','', b.formapago as 'td','', a.id_empleado as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_plantillap a inner join tb_cliente_plantilla b on a.id_plantilla = b.id_plantilla" & vbCrLf)
        sqlbr.Append("inner join tb_puesto c on b.id_puesto = c.id_puesto inner join tb_turno d on b.id_turno = d.id_turno" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado e on a.id_empleado = e.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_vacante f on a.id_plantilla = f.id_plantilla and a.posicion = f.posicion and f.id_status = 1" & vbCrLf)
        sqlbr.Append("where b.id_inmueble = " & inmueble & " and b.id_status = 1 ORDER BY b.id_plantilla, a.posicion for xml path('tr'), root('tbody')")

        'sqlbr.Append("select id_plantilla as 'td','', puesto as 'td','', turno as 'td','', cast(jornal as numeric(12,2)) as 'td','', " & vbCrLf)
        'sqlbr.Append("formapago as 'td','', sexo as 'td','', cast(smntope as numeric(12,2)) as 'td',''," & vbCrLf)
        'sqlbr.Append("cantidad as 'td','', activos as 'td','', cantidad - activos as 'td','', id_puesto as 'td','', id_turno as 'td','', forma as 'td','', posicion as 'td' from (" & vbCrLf)
        'sqlbr.Append("select id_plantilla, b.descripcion as puesto, c.descripcion as turno, jornal, case when formapago = 1 then 'Quincenal' else 'Semanal' end formapago, " & vbCrLf)
        'sqlbr.Append("case when sexo =1 then 'Masculino' when sexo = 2 then 'Femenino' when sexo = 3 then 'Indistinto' end sexo, smntope, cantidad," & vbCrLf)
        'sqlbr.Append("(select COUNT (id_empleado) from tb_empleado where id_plantilla = a.id_plantilla and id_status = 2) As activos, a.formapago as forma," & vbCrLf)
        'sqlbr.Append("a.id_puesto, a.id_turno, e.posicion" & vbCrLf)
        'sqlbr.Append("from tb_cliente_plantilla a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        'sqlbr.Append("inner join tb_turno c on a.id_turno = c.id_turno" & vbCrLf)
        'sqlbr.Append("left outer join tb_cliente_plantillap e on a.id_empleado = e.id_empleado" & vbCrLf)
        'sqlbr.Append("where a.id_inmueble = " & inmueble & " and a.id_status = 1) as result for xml path('tr'), root('tbody')")
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

    <Web.Services.WebMethod()>
    Public Shared Function validaposiciones(ByVal plantilla As Integer, ByVal empleado As Integer, ByVal vacante As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        If vacante = 1 Then
            sqlbr.Append("select COUNT (id_empleado) as activos from tb_empleado where id_plantilla = " & plantilla & " and id_empleado !=" & empleado & " and id_status=2;" & vbCrLf)
            sqlbr.Append("select cantidad from tb_cliente_plantilla where id_plantilla = " & plantilla & "")

            Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
            Dim dt As New DataSet
            da.Fill(dt)
            If dt.Tables(0).Rows.Count > 0 Then
                sql += "{activos: '" & dt.Tables(0).Rows(0)("activos") & "', espacios: '" & dt.Tables(1).Rows(0)("cantidad") & "'}" & vbCrLf
            End If
        Else
            sql += "{activos:0, espacios:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function horarios(ByVal plantilla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("Select 'Turno: ' + isnull(b.descripcion,'') + ' Entrada: ' + horariode + ' Salida: '+ horarioa + ' Jornal: ' + cast(jornal as varchar) + ' De: ' + diade + ' A: ' + diaa as horario " & vbCrLf)
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_turno b on a.id_turno = b.id_turno where id_plantilla = " & plantilla & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{horario: '" & dt.Tables(0).Rows(0)("horario") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardavacante(ByVal registro As String, ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal ubicacion As String, ByVal horario As String, ByVal idcli As Integer) As String

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