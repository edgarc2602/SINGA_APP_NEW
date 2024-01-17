Imports System.Data
Imports System.Data.SqlClient

Partial Class Home
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public labeludesc As String = ""
    Public labeluant As String = ""
    Public labelmenu As String = ""

    Public nnot As String = 1
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sql As String = "SELECT Per_Nombre,Fecha_Alta,b.ar_descripcion from Personal a inner join area b on b.idarea=a.IdArea where IdPersonal=" & Session("v_usuario") & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            labeluser = dt.Rows(0).Item("per_nombre")
            labeludesc = dt.Rows(0).Item("per_nombre") & "-" & dt.Rows(0).Item("ar_descripcion")
            labeluant = dt.Rows(0).Item("fecha_alta")
        End If
        sql = "select * from func_Menu(" & Session("v_usuario") & ")											"

        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
	

        labelmenu = dt.Rows(0).Item("menu1")
    
    End Sub
End Class
