Imports System.Data
Imports System.Data.SqlClient
Partial Class App_RH_RH_Cat_Empleado_Sueldo
    Inherits System.Web.UI.Page

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
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empleadosueldo", myConnection)
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

        sqlbr.Append("select sueldo, sueldoimss, sdi, convert(varchar(10),fingreso,103) as fingreso, formapago, id_banco, clabe, cuenta, tarjeta, tienecredito, isnull(convert(varchar(10),fcredito,103),'') as fcredito, tipocredito, montocredito from tb_empleado where id_empleado = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{sueldo: '" & dt.Rows(0)("sueldo") & "',sueldoimss:'" & dt.Rows(0)("sueldoimss") & "',sdi:'" & dt.Rows(0)("sdi") & "'," & vbCrLf
            sql += "fingreso:'" & dt.Rows(0)("fingreso") & "', formapago:'" & dt.Rows(0)("formapago") & "', banco:'" & dt.Rows(0)("id_banco") & "'," & vbCrLf
            sql += "clabe:'" & dt.Rows(0)("clabe") & "', cuenta:'" & dt.Rows(0)("cuenta") & "', tarjeta:'" & dt.Rows(0)("tarjeta") & "', tienecredito:'" & dt.Rows(0)("tienecredito") & "'," & vbCrLf
            sql += "fcredito:'" & dt.Rows(0)("fcredito") & "', tipocredito:'" & dt.Rows(0)("tipocredito") & "', montocredito:'" & dt.Rows(0)("montocredito") & "'}"
        End If
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        idemp.Value = Request("id")
        nombre.Value = Request("nombre")
    End Sub


End Class
