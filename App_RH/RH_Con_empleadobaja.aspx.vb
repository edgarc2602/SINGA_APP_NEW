Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Con_empleadobaja
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function empleado(ByVal noemp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select paterno+' ' + rtrim(materno)+ ' ' + nombre as empleado, convert(varchar(12),b.fregistro,103) fregistro, " & vbCrLf)
        sqlbr.Append("c.Per_Nombre +' ' + c.Per_Paterno + ' ' + c.Per_Materno as registro," & vbCrLf)
        sqlbr.Append("convert(varchar(12),b.fprogramada, 103) fprogramada, convert(varchar(12),b.fbajafin,103) fconfirmada, d.descripcion, b.observacion " & vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_empleado_baja b on a.id_empleado= b.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join Personal c on b.id_registra = c.IdPersonal " & vbCrLf)
        sqlbr.Append("left outer join tb_motivobaja d on b.id_motivo = d.id_motivo" & vbCrLf)
        sqlbr.Append("where a.id_empleado = " & noemp & " and a.id_status = 3")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{nombre:'" & dt.Rows(0)("empleado") & "', fregistro:'" & dt.Rows(0)("fregistro") & "'," & vbCrLf
            sql += "registro:'" & dt.Rows(0)("registro") & "', fprogramada:'" & dt.Rows(0)("fprogramada") & "'," & vbCrLf
            sql += "fconfirmada:'" & dt.Rows(0)("fconfirmada") & "', motivo:'" & dt.Rows(0)("descripcion") & "', comentbaja:'" & dt.Rows(0)("observacion") & "'}" & vbCrLf
        End If
        Return sql
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
