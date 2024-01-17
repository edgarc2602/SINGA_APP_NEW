Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_dashboard_Dash_Nominas
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function periodo(ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + descripcion as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonomina where anio =" & anio & "")
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
    Public Shared Function resumen(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT cast(SUM(neto) as numeric(12,2)) as percepciones, cast(SUM(deduccion) as numeric (12,2)) as deducciones, " & vbCrLf)
        sqlbr.Append("cast(SUM(case when neto > 0 then neto else 0 end) as numeric(12,2)) as total " & vbCrLf)
        sqlbr.Append("from tb_nominacalculadar1 a inner join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente  " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("where id_periodo = " & periodo & " and a.tipo ='" & tipo & "' and anio = " & anio & " and b.id_area= " & tipoc & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{perc:'" & dt.Rows(0)("percepciones") & "', dedc:'" & dt.Rows(0)("deducciones") & "', total:'" & dt.Rows(0)("total") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalle(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal tipoc As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        If tipoc = 6 Then
            sqlbr.Append("SELECT rtrim(d.nombre) as 'td','', COUNT(a.id_empleado) as 'td','', SUM(f + fj) as 'td','', SUM(d) as 'td','', " & vbCrLf)
            sqlbr.Append("cast(SUM(neto) as numeric(12,2)) as 'td','', cast(SUM(deduccion) as numeric (12,2)) as 'td','', cast(SUM(case when neto > 0 then neto else 0 end) as numeric(12,2)) as 'td' " & vbCrLf)
            sqlbr.Append("from tb_nominacalculadar1 a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
            sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente  " & vbCrLf)
            sqlbr.Append("inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
            sqlbr.Append("where id_periodo = " & periodo & " and a.tipo ='" & tipo & "' and anio = " & anio & " and b.id_area = " & tipoc & "" & vbCrLf)
            sqlbr.Append("group by d.nombre order by d.nombre for xml path('tr'), root('tbody')")

        Else
            sqlbr.Append("SELECT rtrim(c.nombre) as 'td','', COUNT(a.id_empleado) as 'td','', SUM(f + fj) as 'td','', SUM(d) as 'td','', " & vbCrLf)
            sqlbr.Append("cast(SUM(neto) as numeric(12,2)) as 'td','', cast(SUM(deduccion) as numeric (12,2)) as 'td','', cast(SUM(case when neto > 0 then neto else 0 end) as numeric(12,2)) as 'td' " & vbCrLf)
            sqlbr.Append("from tb_nominacalculadar1 a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
            sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente  " & vbCrLf)
            sqlbr.Append("inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
            sqlbr.Append("where id_periodo = " & periodo & " and a.tipo ='" & tipo & "' and anio = " & anio & " and b.id_area= " & tipoc & "" & vbCrLf)
            sqlbr.Append("group by c.nombre order by c.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function detallea(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal tipoc As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        If tipoc = 6 Then
            sqlbr.Append("SELECT rtrim(d.nombre) as 'td','', COUNT(a.id_empleado) as 'td','', SUM(f + fj) as 'td','', SUM(d) as 'td','', " & vbCrLf)
            sqlbr.Append("cast(SUM(neto) as numeric(12,2)) as 'td','', cast(SUM(deduccion) as numeric (12,2)) as 'td','', cast(SUM(case when neto > 0 then neto else 0 end) as numeric(12,2)) as 'td' " & vbCrLf)
            sqlbr.Append("from tb_nominacalculadar1 a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
            sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente  " & vbCrLf)
            sqlbr.Append("inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
            sqlbr.Append("where id_periodo = " & periodo & " and a.tipo ='" & tipo & "' and anio = " & anio & " and b.id_area= " & tipoc & "" & vbCrLf)
            sqlbr.Append("group by d.nombre order by d.nombre for xml path('tr'), root('tbody')")

        Else
            sqlbr.Append("SELECT rtrim(c.nombre) as 'td','', COUNT(a.id_empleado) as 'td','', SUM(f + fj) as 'td','', SUM(d) as 'td','', " & vbCrLf)
            sqlbr.Append("cast(SUM(neto) as numeric(12,2)) as 'td','', cast(SUM(deduccion) as numeric (12,2)) as 'td','', cast(SUM(case when neto > 0 then neto else 0 end) as numeric(12,2)) as 'td' " & vbCrLf)
            sqlbr.Append("from tb_nominacalculadar1 a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
            sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente  " & vbCrLf)
            sqlbr.Append("inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
            sqlbr.Append("where id_periodo = " & periodo & " and a.tipo ='" & tipo & "' and anio = " & anio & " and b.id_area= " & tipoc & "" & vbCrLf)
            sqlbr.Append("group by c.nombre order by c.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String, ByVal anio As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin" & vbCrLf)
        sqlbr.Append(" from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "' and anio =" & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estatus(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select case when b.id_status = 1 then 'Período cerrado, no liberado' when b.id_status = 2 then 'Período liberado, no pagado'" & vbCrLf)
        sqlbr.Append("when b.id_status = 3 then 'Período liberado y pagado' else 'Período en proceso' end as estatus" & vbCrLf)
        sqlbr.Append("from tb_periodonomina a left outer join tb_periodonominac b on a.id_periodo = b.id_periodo and a.descripcion = b.tipo " & vbCrLf)
        sqlbr.Append("and a.anio = b.anio and b.tipoc = " & tipoc & " " & vbCrLf)
        sqlbr.Append("where a.id_periodo = " & periodo & " and descripcion ='" & per & "' and a.anio = " & anio & " ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estatus: '" & dt.Rows(0)("estatus") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function libera(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As Integer) As String

        Dim sql As String = "Update tb_periodonominac set id_status = 2 where id_periodo = " & periodo & " and tipo ='" & per & "' and anio = " & anio & " and tipoc = " & tipoc & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Dim generacorreo As New correodir()
        generacorreo.liberanomina(periodo, per, anio)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function rechaza(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As Integer) As String

        Dim sql As String = "Update tb_periodonomina set activo = 1 where id_periodo = " & periodo & " and descripcion ='" & per & "' and anio = " & anio & ";"
        sql += " delete from tb_periodonominac where id_periodo = " & periodo & " and tipo ='" & per & "' and anio = " & anio & " and tipoc = " & tipoc & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Dim generacorreo As New correodir()
        generacorreo.rechazanomina(periodo, per, anio)

        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
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
