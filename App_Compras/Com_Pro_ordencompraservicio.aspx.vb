Imports System.Data
Imports System.Data.SqlClient
Partial Class App_Compras_Com_Pro_ordencompraservicio
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function comprador(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 order by nombre")
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

    <Web.Services.WebMethod()>
    Public Shared Function catproveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, rtrim(nombre) as nombre  from tb_proveedor where id_status = 1 order by nombre ")
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
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_mes, descripcion from tb_mes order by id_mes")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_mes") & "'," & vbCrLf
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
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ordencompraservicio", myConnection)
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
    Public Shared Function orden(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_orden, convert(varchar(12), a.falta, 103) as falta, a.id_empresa, a.id_proveedor, a.formapago, a.id_almacen, a.id_cliente, a.subtotal, a.iva, a.total, a.id_requisicion, inventario, a.observacion, b.descripcion as estatus, comprador, " & vbCrLf)
        sqlbr.Append("nombre + ' ' + paterno + ' ' + rtrim(materno) as nombrec, case when d.tipo is null then 0 else d.tipo end as tipo, a.piva," & vbCrLf)
        sqlbr.Append("subtotalp, retencion, descuento, a.mes, a.anio, a.concepto" & vbCrLf)
        sqlbr.Append("from tb_ordencompra a inner join tb_statusc b on a.id_status = b.id_status" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado c on a.comprador = c.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_requisicion d on a.id_requisicion = d.id_requisicion" & vbCrLf)
        sqlbr.Append("where id_orden = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_orden") & "', id_empresa: '" & dt.Rows(0)("id_empresa") & "',  id_proveedor:'" & dt.Rows(0)("id_proveedor") & "', id_almacen:'" & dt.Rows(0)("id_almacen") & "', formapago:'" & dt.Rows(0)("formapago") & "',"
            sql += " id_cliente: '" & dt.Rows(0)("id_cliente") & "', falta:'" & dt.Rows(0)("falta") & "',  subtotal:'" & dt.Rows(0)("subtotal") & "', iva:'" & dt.Rows(0)("iva") & "', inventario:'" & dt.Rows(0)("inventario") & "',"
            sql += " total:'" & dt.Rows(0)("total") & "',observacion:'" & dt.Rows(0)("observacion") & "', estatus:'" & dt.Rows(0)("estatus") & "', idcomprador:'" & dt.Rows(0)("comprador") & "',"
            sql += " req:'" & dt.Rows(0)("id_requisicion") & "', comprador:'" & dt.Rows(0)("nombrec") & "', tipo:'" & dt.Rows(0)("tipo") & "', piva:'" & dt.Rows(0)("piva") & "',"
            sql += " subtotalp:'" & dt.Rows(0)("subtotalp") & "', retencion:'" & dt.Rows(0)("retencion") & "', descuento:'" & dt.Rows(0)("descuento") & "',"
            sql += " mes:'" & dt.Rows(0)("mes") & "', anio:'" & dt.Rows(0)("anio") & "', concepto:'" & dt.Rows(0)("concepto") & "'}"
        End If
        Return sql
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie

        usuario = Request.Cookies("Usuario")
        idrequisicion.Value = Request("idreq")
        idorden.Value = Request("folio")
        If Request("familia") <> "" Then
            idfamilia.Value = Request("familia")
        Else
            idfamilia.Value = 0
        End If

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
