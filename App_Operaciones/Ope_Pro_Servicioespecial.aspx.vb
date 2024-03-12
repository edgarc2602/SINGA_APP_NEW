Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Pro_Servicioespecial
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
    Public Shared Function trabajo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_trabajo, descripcion from tb_trabajoespecial order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_trabajo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal orden As String, ByVal folio As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_servicioespecial", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecera", orden)
        Dim prm1 As New SqlParameter("@id", 0)
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        If folio = 0 Then
            Dim generacorreo As New correooper()
            generacorreo.servicioespecial(prm1.Value)
        End If

        Return prm1.Value

    End Function


    <Web.Services.WebMethod()>
    Public Shared Function servicio(ByVal idsolm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_servicio, fregistro, concepto, costodirecto, indirectop, indirectom, utilidadp, utilidadm, presupuesto," & vbCrLf)
        sqlbr.Append("id_cliente, id_inmueble, id_trabajo, b.descripcion as estatus" & vbCrLf)
        sqlbr.Append("from tb_servicioespecial a inner join tb_statuscm b on a.id_status = b.id_status where id_servicio = " & idsolm & ";")
        sqlbr.Append("select isnull(sum(subtotal),0) as solicitado from tb_solicitudrecurso where id_servicioespecial =" & idsolm & " and id_status != 6")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{fregistro:'" & dt.Tables(0).Rows(0)("fregistro") & "',concepto:'" & dt.Tables(0).Rows(0)("concepto") & "',"
            sql += "costodirecto:'" & dt.Tables(0).Rows(0)("costodirecto") & "', indirectop:'" & dt.Tables(0).Rows(0)("indirectop") & "',"
            sql += "indirectom:'" & dt.Tables(0).Rows(0)("indirectom") & "', utilidadp:'" & dt.Tables(0).Rows(0)("utilidadp") & "',"
            sql += "utilidadm:'" & dt.Tables(0).Rows(0)("utilidadm") & "', presupuesto:'" & dt.Tables(0).Rows(0)("presupuesto") & "',"
            sql += "id_cliente:'" & dt.Tables(0).Rows(0)("id_cliente") & "', id_inmueble:'" & dt.Tables(0).Rows(0)("id_inmueble") & "',"
            sql += "id_trabajo:'" & dt.Tables(0).Rows(0)("id_trabajo") & "', estatus:'" & dt.Tables(0).Rows(0)("estatus") & "',"
            sql += "solicitado:'" & dt.Tables(1).Rows(0)("solicitado") & "'}"
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")
        idservicio.Value = Request("folio")

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
