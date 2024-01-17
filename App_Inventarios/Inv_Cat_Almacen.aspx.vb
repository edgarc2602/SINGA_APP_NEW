Imports System.Data
Imports System.Data.SqlClient

Partial Class Inventarios_App_Inv_Cat_Almacen
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public labelmenu As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        If Request.Params("__EVENTTARGET") = "limpia" Then
            lblid.Text = "0"
            consulta()
        End If
        If Not IsPostBack Then
            Dim sql As String = "select * from estados"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlestado.DataSource = dt
                ddlestado.DataTextField = "Estado"
                ddlestado.DataValueField = "Id_Estado"
                ddlestado.DataBind()
                ddlestado.SelectedValue = 9
            End If
            consulta()

        End If

    End Sub
    Protected Sub consulta()
        Dim Sql As String = "SELECT     IdAlmacen, IdEstado, Alm_Clave, Alm_Nombre,b.Estado ,Alm_status, Alm_direccion, Alm_inventario,"
        Sql += " case when Alm_status=0 then 'Activo' else 'Baja' end Estatus,case when Alm_inventario=0 then 'Libre' else 'En Inventario' end Estatu"
        Sql += " FROM         Tbl_Almacen a inner join Estados b on b.Id_Estado=a.idestado"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        GridView1.DataSource = dt
        GridView1.DataBind()

    End Sub
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(GridView1, "Select$" & e.Row.RowIndex.ToString())
        End Select
    End Sub
    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
'=" & GridView1.SelectedDataKey("Id_Prospecto") & " "

        lblid.Text = GridView1.SelectedDataKey("IdAlmacen")
        txtcve.Text = GridView1.SelectedRow.Cells(1).Text
        txtalmacen.Text = GridView1.SelectedRow.Cells(2).Text
        txtdireccion.Text = GridView1.SelectedRow.Cells(3).Text
        ddlestado.SelectedValue = GridView1.SelectedDataKey("IdEstado")
        ddlinv.SelectedValue = GridView1.SelectedDataKey("Alm_Inventario")
        ddlstatus.SelectedValue = GridView1.SelectedDataKey("Alm_status")

    End Sub

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        Dim datos As String
        datos = lblid.Text & "#" & txtcve.Text & "#" & txtalmacen.Text & "#" & txtdireccion.Text & "#" & ddlestado.SelectedValue & "#" & ddlinv.SelectedValue & "#" & ddlstatus.SelectedValue
        graba(datos)
    End Sub
    Protected Sub graba(ByVal datosg As String)
        Dim datos As Array = datosg.Split("#")
        Dim Sql As String = ""
        If datos(0) = "0" Then
            Sql = "Insert into Tbl_Almacen values (" & datos(4) & ",'" & datos(1) & "','" & datos(2) & "'," & datos(6) & "," & datos(3) & "," & datos(5) & ")"
        Else
            Sql = " update Tbl_Almacen set idestado=" & datos(4) & ",Alm_Clave='" & datos(1) & "',Alm_Nombre='" & datos(2) & "',"
            Sql += " Alm_Status=" & datos(6) & ",Alm_Direccion='" & datos(3) & "',Alm_Inventario=" & datos(5) & ""
            Sql += " where IdAlmacen=" & datos(0) & ""
        End If
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)
        consulta()
    End Sub
End Class
