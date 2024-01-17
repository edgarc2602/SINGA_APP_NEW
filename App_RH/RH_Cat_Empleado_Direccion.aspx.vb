Imports System.Data
Imports System.Data.SqlClient
Partial Class App_RH_RH_Cat_Empleado_Direccion
    Inherits System.Web.UI.Page

    <Web.Services.WebMethod()>
    Public Shared Function estado() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_estado, descripcion from tb_estado order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empleadodir", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalle(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select calle, noext, noint, colonia, cp, municipio, id_estado, tel1, tel2, contacto from tb_empleado where id_empleado = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{calle: '" & dt.Rows(0)("calle") & "',noext:'" & dt.Rows(0)("noext") & "',noint:'" & dt.Rows(0)("noint") & "'," & vbCrLf
            sql += "colonia:'" & dt.Rows(0)("colonia") & "', cp:'" & dt.Rows(0)("cp") & "', municipio:'" & dt.Rows(0)("municipio") & "'," & vbCrLf
            sql += "estado:'" & dt.Rows(0)("id_estado") & "', tel1:'" & dt.Rows(0)("tel1") & "', tel2:'" & dt.Rows(0)("tel2") & "'," & vbCrLf
            sql += "contacto:'" & dt.Rows(0)("contacto") & "'}"
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        idemp.Value = Request("id")
        nombre.Value = Request("nombre")
    End Sub

End Class
