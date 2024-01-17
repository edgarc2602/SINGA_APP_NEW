Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Con_Nomina
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function periodo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + tipo as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonominac where id_status = 2")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_periodo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("periodo") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "'")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

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
    Public Shared Function empleado(ByVal area As Integer, ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado,nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 and " & tipo & " = 1 and id_area= " & area & " order by empleado")
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
    Public Shared Function estatus(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_status from tb_periodonominac where id_periodo = " & periodo & " and tipo = '" & per & "' and anio = " & anio & " and tipoc = " & tipoc & " ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estatus: '" & dt.Rows(0)("id_status") & "'}"
        Else
            sql += "{estatus: '0'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function procesada(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select '$' + convert(varchar(12), convert(money , isnull(sum(percepcion),0)),1) as perc, " & vbCrLf)
        sqlbr.Append("'$' + convert(varchar(12), convert(money , isnull(sum(deduccion),0)),1) as deduc," & vbCrLf)
        sqlbr.Append("'$' + convert(varchar(12), convert(money , isnull(sum(percepcion + deduccion),0)),1) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where id_periodo = " & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and tipoempleado = " & tipoc & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{percepcion: '" & dt.Rows(0)("perc") & "',deduccion:'" & dt.Rows(0)("deduc") & "', total:'" & dt.Rows(0)("total") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarnomina(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoc As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select COUNT(*)/30 + 1 As Filas, COUNT(*) % 30 As Residuos FROM(" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, c.nombre As cliente, d.nombre As sucursal," & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, a.percepciones, a.deducciones, a.total from(" & vbCrLf)
        sqlbr.Append("select a.id_empleado, sum(percepcion) as percepciones, sum(deduccion) as deducciones, sum(percepcion) - sum(deduccion) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("where id_periodo =" & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and tipoempleado = " & tipoc & "" & vbCrLf)
        'If empresa() <> 0 Then sqlbr.Append("and b.id_empresa = " & empresa() & "")
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        sqlbr.Append("group by a.id_empleado) as a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble) as tabla")

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
    Public Shared Function nomina(ByVal pagina As Integer, ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("SELECT cliente as 'td','', sucursal as 'td','', id_empleado as 'td','', empleado as 'td','', cast(percepciones as numeric(18,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(deducciones as numeric(18,2)) As 'td','', cast(total as numeric(18,2)) as 'td' FROM(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, rtrim(c.nombre) as cliente, d.nombre as sucursal," & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, a.percepciones, a.deducciones, a.total from(" & vbCrLf)
        sqlbr.Append("select a.id_empleado, sum(percepcion) as percepciones, sum(deduccion) as deducciones, sum(percepcion) + sum(deduccion) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("where id_periodo =" & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and tipoempleado = " & tipoc & "" & vbCrLf)
        'If empresa() <> 0 Then sqlbr.Append("and b.id_empresa = " & empresa() & "")
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        sqlbr.Append("Group by a.id_empleado) as a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble) as tabla" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 30 + 1 And " & pagina & " * 30 order by  cliente, sucursal,  empleado for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function cerrar(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As String) As String

        Dim sql As String = "Update tb_periodonominac set id_status = 3 where id_periodo = " & periodo & " and tipo ='" & per & "' and anio = " & anio & " and tipoc = " & tipoc & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function banco() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_banco, descripcion from tb_banco order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_banco") & "'," & vbCrLf
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
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empresa") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
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

        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
    End Sub
End Class
