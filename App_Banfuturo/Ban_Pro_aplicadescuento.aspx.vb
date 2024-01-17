Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Banfuturo_Ban_Pro_aplicadescuento
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function periodo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + descripcion as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonomina where activo = 1")
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
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "' and anio = " & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function prestamos(ByVal fini As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini

        sqlbr.Append("select id_empleado as 'td','', empleado as 'td','', cast(pagototal as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("fpago as 'td','', pago as 'td','', anio as 'td','', tipo as 'td','', id_solicitud as 'td' from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over( order by c.paterno, c.materno, c.nombre) as rownum, b.id_empleado, c.paterno + ' ' + rtrim(c.materno) + ' ' + c.nombre as empleado, pagototal, convert(varchar(12), fpago , 103) fpago, pago, " & vbCrLf)
        sqlbr.Append("year(fpago) as anio, case when b.planpago = 1 Then 'Quincenal' else 'Semanal' end as tipo, a.id_solicitud" & vbCrLf)
        sqlbr.Append("from tb_solicitudprestamoa a inner join tb_solicitudprestamo b on a.id_solicitud = b.id_solicitud" & vbCrLf)
        sqlbr.Append("inner join tb_empleado c on b.id_empleado = c.id_empleado" & vbCrLf)
        sqlbr.Append("where cast(fpago as date) = '" & Format(vfecini, "yyyyMMdd") & "' and aplicado = 0) tabla order by empleado for xml path('tr'), root('tbody')")
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
        Dim mycommand As New SqlCommand("sp_incidenciaprestamo", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

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
