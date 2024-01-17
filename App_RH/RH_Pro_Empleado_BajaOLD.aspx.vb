Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Empleado_Baja
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
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
    Public Shared Function empleadoop(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_empleado from personal where idpersonal = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = "{id:'" & dt.Rows(0)("id_empleado") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function baja(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select fprogramada, a.id_vacante, b.id_tipo, ubicacion, experiencia, observacion from tb_empleado_baja a inner join tb_vacante b on a.id_vacante = b.id_vacante" & vbCrLf)
        sqlbr.Append("where id_empleado = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = "{fprogramada:'" & dt.Rows(0)("fprogramada") & "', vacante:'" & dt.Rows(0)("id_vacante") & "'," & vbCrLf
            sql += "tipo:'" & dt.Rows(0)("id_tipo") & "', ubicacion:'" & dt.Rows(0)("ubicacion") & "'," & vbCrLf
            sql += "experiencia:'" & dt.Rows(0)("experiencia") & "', observacion:'" & dt.Rows(0)("observacion") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarempleado(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal noemp As Integer, ByVal nombre As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/100 + 1 as Filas, COUNT(*) % 100 as Residuos FROM tb_empleado a where a.id_status = 2" & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append("and a.id_cliente = " & cliente & "")
        End If
        If inmueble <> 0 Then
            sqlbr.Append("and a.id_inmueble = " & inmueble & "")
        End If
        If noemp <> 0 Then
            sqlbr.Append("and a.id_empleado = " & noemp & "")
        End If
        If nombre <> "" Then
            sqlbr.Append("and paterno + materno + nombre like '%" & Replace(nombre, " ", "%") & "%'" & vbCrLf)
        End If
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
    Public Shared Function empleados(ByVal pagina As Integer, ByVal cliente As Integer, ByVal inmueble As Integer, ByVal noemp As Integer, ByVal nombre As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_empleado as 'td','', empleado as 'td','', rfc as 'td','', curp as 'td','', ss as 'td','', " & vbCrLf)
        sqlbr.Append("puesto as 'td','', turno as 'td','',id_puesto as 'td','', id_turno as 'td','', estatus as 'td','', id_plantilla as 'td'  from (" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by paterno, materno, nombre) As RowNum, a.id_empleado, paterno + ' ' + rtrim(materno) + ' '+ nombre as empleado, rfc, curp, ss," & vbCrLf)
        sqlbr.Append("b.descripcion as puesto, c.descripcion as turno, a.id_puesto, a.id_turno, 'Activo' as estatus," & vbCrLf)
        sqlbr.Append("a.id_plantilla" & vbCrLf)
        sqlbr.Append("From tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto inner join tb_turno c on a.id_turno = c.id_turno" & vbCrLf)
        ' sqlbr.Append("inner join tb_cliente e on a.id_cliente = e.id_cliente")
        sqlbr.Append("left outer join tb_empleado_baja d on a.id_empleado = d.id_empleado" & vbCrLf)
        sqlbr.Append("where a.id_status = 2" & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append("and a.id_cliente = " & cliente & "")
        End If
        If inmueble <> 0 Then
            sqlbr.Append("and a.id_inmueble = " & inmueble & "")
        End If
        If noemp <> 0 Then
            sqlbr.Append("and a.id_empleado = " & noemp & "")
        End If
        If nombre <> "" Then
            sqlbr.Append("and paterno + materno + nombre like '%" & Replace(nombre, " ", "%") & "%'" & vbCrLf)
        End If
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 100 + 1 And " & pagina & " * 100 order by empleado for xml path('tr'), root('tbody')")
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
    Public Shared Function totalempleados(ByVal cliente As Integer, ByVal inmueble As Integer, ByVal noemp As Integer, ByVal nombre As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select count(id_empleado) as total from tb_empleado a" & vbCrLf)
        sqlbr.Append("where a.id_status = 2" & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append("and a.id_cliente = " & cliente & "")
        End If
        If inmueble <> 0 Then
            sqlbr.Append("and a.id_inmueble = " & inmueble & "")
        End If
        If noemp <> 0 Then
            sqlbr.Append("and a.id_empleado = " & noemp & "")
        End If
        If nombre <> "" Then
            sqlbr.Append("and paterno + materno + nombre like '%" & Replace(nombre, " ", "%") & "%'" & vbCrLf)
        End If
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{total: '" & dt.Tables(0).Rows(0)("total") & "'}" & vbCrLf
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
            sql += "{activos:0, espacios:1}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function datosextra(ByVal plantilla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("Select 'Turno: ' + isnull(b.descripcion,'') + ' Entrada: ' + horariode + ' Salida: '+ horarioa + ' Jornal: ' + cast(jornal as varchar) + ' De: ' + diade + ' A: ' + diaa as horario " & vbCrLf)
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_turno b on a.id_turno = b.id_turno where a.id_plantilla = " & plantilla & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{horario: '" & dt.Tables(0).Rows(0)("horario") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ubicacion(ByVal sucursal As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select direccion + ' '+ colonia + ' ' + delegacionmunicipio + ' ' + cp + ' '+ b.descripcion as ubicacion" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_estado b on a.id_estado = b.id_estado  where id_inmueble = " & sucursal & ";" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{ubicacion: '" & dt.Tables(0).Rows(0)("ubicacion") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal ubicacion As String, ByVal horario As String, ByVal fbaja As String, ByVal empleado As String, ByVal idcli As Integer, ByVal vacante As Integer, ByVal motivo As String) As String

        Dim rfc As String = ""
        Dim curp As String = ""
        Dim ss As String = ""
        Dim nombre As String = ""

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

        If vacante = 1 Then
            generacorreo.correovacante(fecha, "Registro de Vacante", cliente, puesto, sucursal, ubicacion, horario, idcli, prmR.Value)
        End If

        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select rfc, curp, ss, paterno + ' ' + rtrim(materno) + ' ' + nombre as empleado from tb_empleado where id_empleado = " & empleado & "" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            rfc = dt.Rows(0)("rfc")
            curp = dt.Rows(0)("curp")
            ss = dt.Rows(0)("ss")
            nombre = dt.Rows(0)("empleado")
        End If

        generacorreo.correobaja(fecha, "Baja programada de Empleado", cliente, puesto, sucursal, fbaja, nombre, rfc, curp, ss, idcli, motivo)

        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function bajaimss(ByVal empleado As String) As String

        Dim sql As String = "Update tb_empleado set id_status = 3 where id_empleado =" & empleado & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function bajadef(ByVal empleado As String) As String

        Dim sql As String = "Update tb_empleado set id_status = 3 where id_empleado =" & empleado & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function coordina(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_operativo, id_coordinador, c.nombre  + ' ' +  c.paterno+ ' ' + rtrim(c.materno) as nombre " & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_gerente_coordinador b on a.id_operativo = b.id_gerente " & vbCrLf)
        sqlbr.Append("inner join tb_empleado c on b.id_coordinador = c.id_empleado " & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = "{id: '" & dt.Rows(0)("id_operativo") & "', nombre:'" & dt.Rows(0)("nombre") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function motivos() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_motivo, descripcion from tb_motivobaja where id_status = 1  order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_motivo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
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
