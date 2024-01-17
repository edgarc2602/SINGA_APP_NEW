Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Con_compptto
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function comprador() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select IdPersonal, Per_Nombre + ' ' + per_paterno + ' ' + Per_Materno  as comprador from personal where IdArea = 8 and per_status = 0 order by comprador")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdPersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("comprador") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function gerente(ByVal puesto As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 ")
        If puesto = 1000 Then
            sqlbr.Append("And id_puesto in(20,30,5) " & vbCrLf)
        Else
            sqlbr.Append("And id_puesto = " & puesto & "")
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
    Public Shared Function comparativo(ByVal comprador As Integer, ByVal gerente As Integer, ByVal anio As Integer, ByVal mes As Integer, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select cliente as 'td','', ptto as 'td','', utilizado as 'td','', variacion as 'td',''," & vbCrLf)
        sqlbr.Append("case when variacion < 0 then (select 'hola' as '@value', 'tbborrar colorrojo' as '@class' for xml path('span'), type) else (select 'tbborrar colorverde' as '@class' for xml path('span'), type)  end as 'td',''," & vbCrLf)
        sqlbr.Append("gerente as 'td','', comprador as 'td'")
        sqlbr.Append("from (select cliente, cast(isnull(ptto,0) as numeric(12,2)) as ptto, cast(isnull(utilizado,0) as numeric(12,2)) as utilizado, " & vbCrLf)
        sqlbr.Append("cast(isnull(ptto,0) - isnull(utilizado,0) as numeric(12,2)) as variacion, gerente, comprador from (" & vbCrLf)
        sqlbr.Append("select c.nombre as cliente,  sum((cantidad * precio)) as utilizado," & vbCrLf)
        sqlbr.Append("(select sum(importe) from tb_cliente_material d where id_cliente = c.id_cliente and id_status =1" & vbCrLf)
        Select Case tipo
            Case 1, 3
                sqlbr.Append("and id_concepto in(1,2)")
            Case 4
                sqlbr.Append("and id_concepto in(3)")
            Case Else
                sqlbr.Append("and id_concepto in(0)")
        End Select

        sqlbr.Append(") ptto, d.nombre + ' ' + d.paterno + ' ' + rtrim(d.materno) as gerente, e.nombre + ' ' + e.paterno + ' ' + rtrim(e.materno) as comprador" & vbCrLf)
        sqlbr.Append("from tb_listadomaterial a inner join tb_listadomateriald b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on a.id_cliente = c.id_cliente inner join tb_empleado d on c.id_operativo = d.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_empleado e on c.id_comprador = e.id_empleado " & vbCrLf)
        sqlbr.Append("where mes = " & mes & " and anio = " & anio & " and a.id_status != 5 " & vbCrLf)
        If comprador <> 0 Then sqlbr.Append("and c.id_comprador = " & comprador & "" & vbCrLf)
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "" & vbCrLf)
        Select Case tipo
            Case 1
                sqlbr.Append("and a.tipo in(1,3)" & vbCrLf)
            Case Else
                sqlbr.Append("and a.tipo = " & tipo & "" & vbCrLf)
        End Select
        'If tipo <> 0 Then sqlbr.Append("and a.tipo = " & tipo & "" & vbCrLf)
        sqlbr.Append("group by c.nombre, c.id_cliente, d.nombre, d.paterno, d.materno, e.nombre, e.paterno, e.materno) tabla) result  order by cliente" & vbCrLf)
        sqlbr.Append("for xml path('tr'), root('tbody')")

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
