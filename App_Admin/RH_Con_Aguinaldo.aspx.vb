Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Admin_RH_Con_Aguinaldo
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""


    <Web.Services.WebMethod()>
    Public Shared Function procesado(ByVal anio As Integer, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select isnull(id_status,0) estatus, importe, case when id_status = 1 then 'Abierto' when id_status = 2 then 'Cerrado' when id_status = 3 then 'Liberado' when id_status = 4 then 'Pagado'  end as estado from tb_calculoaguinaldog where anio = " & anio & " and id_area = " & tipo & " and id_status in(2,3,4)")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estatus: '" & dt.Rows(0)("estatus") & "', importe:'" & Format(dt.Rows(0)("importe"), "$0,0.00") & "', estado: '" & dt.Rows(0)("estado") & "'}"
        Else
            sql += "{estatus:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contaraguinaldo(ByVal anio As Integer, ByVal tipo As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select COUNT(*)/100 + 1 As Filas, COUNT(*) % 100 As Residuos from tb_calculoaguinaldo where anio =" & anio & " and id_area =" & tipo & "" & vbCrLf)

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
    Public Shared Function aguinaldo(ByVal anio As Integer, ByVal tipo As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select cliente as 'td','', inmueble as 'td','', id_empleado as 'td','', empleado as 'td','', isnull(fingreso,'') as 'td','', " & vbCrLf)
        sqlbr.Append("isnull(antiguedad,0) as 'td','', cast(sueldo as numeric(12,2)) as 'td','', cast(aguinaldo as numeric(12,2)) as 'td' from( " & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, c.nombre as Cliente, d.nombre as inmueble, " & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno+ ' ' + rtrim(b.materno) + ' ' + b.nombre empleado, convert( varchar(12),b.fingreso,103) fingreso, antiguedad, a.sueldo, aguinaldo " & vbCrLf)
        sqlbr.Append("from tb_calculoaguinaldo a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble where a.anio=" & anio & " and a.id_area =" & tipo & ") as tabla " & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 100 + 1 And " & pagina & " * 100 order by  cliente, inmueble, empleado for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function cerrar(ByVal anio As Integer, ByVal tipo As Integer, ByVal desctipo As String) As String

        Dim sql As String = ""
        sql = "Update tb_calculoaguinaldog set id_status = 3 where anio = " & anio & " and id_area ='" & tipo & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Dim generacorreo As New correodir()
        generacorreo.liberaaguinaldo(anio, desctipo)
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function pagar(ByVal anio As Integer, ByVal tipo As Integer) As String

        Dim sql As String = ""
        sql = "Update tb_calculoaguinaldog set id_status = 4 where anio = " & anio & " and id_area ='" & tipo & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        'Dim generacorreo As New correocgo()
        'generacorreo.cierrenomina(periodo, per, anio, tipoctext)
        Return ""

    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
