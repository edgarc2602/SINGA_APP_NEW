Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Empleado_Permuta
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function listaempleado(ByVal busca As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.descripcion as 'td','', c.nombre as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_puesto b on a.id_puesto = b.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on a.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where a.id_status = 2 and CAST(id_empleado AS char)+paterno+materno+A.nombre like '%" & busca & "%'" & vbCrLf)
        sqlbr.Append("order by paterno, materno, a.nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function empleado(ByVal usuario As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_empleado, a.paterno + ' ' + rtrim(a.materno) + ' ' + a.nombre as empleado, b.nombre as cliente, c.nombre as inmueble," & vbCrLf)
        sqlbr.Append("d.descripcion as puesto, e.descripcion as turno, jornal, sueldo, a.id_plantilla, f.posicion " & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_cliente b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_puesto d on a.Id_Puesto = d.id_puesto inner join tb_turno e on a.id_turno = e.id_turno" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_plantillap f on a.id_empleado = f.id_empleado" & vbCrLf)
        sqlbr.Append("where a.id_empleado = " & usuario & " and a.id_status = 2")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{emp: '" & dt.Rows(0)("id_empleado") & "', cliente:'" & dt.Rows(0)("cliente") & "', inmueble:'" & dt.Rows(0)("inmueble") & "',"
            sql += " sueldo:'" & dt.Rows(0)("sueldo") & "', empleado:'" & dt.Rows(0)("empleado") & "',"
            sql += " puesto:'" & dt.Rows(0)("puesto") & "', turno:'" & dt.Rows(0)("turno") & "', jornal:'" & dt.Rows(0)("jornal") & "',"
            sql += " plantilla:'" & dt.Rows(0)("id_plantilla") & "', posicion:'" & dt.Rows(0)("posicion") & "'}"
        Else
            sql += "{emp:'0'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function valempleado(ByVal usuario As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_status from tb_empleado" & vbCrLf)
        sqlbr.Append("where id_empleado = " & usuario & "")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estatus: '" & dt.Rows(0)("id_status") & "'}"
        Else
            sql += "{estatus:'0'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal emp1 As Integer, ByVal emp2 As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_permuta", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@emp1", emp1)
        mycommand.Parameters.AddWithValue("@emp2", emp2)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()


        'Dim generacorreo As New enviocorreo()
        'generacorreo.correocandidato(fecha, "Registro de Candidato", cliente, puesto, sucursal, persona, vacante, idvacante, usuario)

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
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
