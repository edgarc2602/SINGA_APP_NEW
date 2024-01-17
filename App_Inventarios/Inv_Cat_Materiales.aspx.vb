Imports System.Data
Imports System.Data.SqlClient

Partial Class Inventarios_App_Inv_Cat_Materiales
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
            txtcve.Enabled = True
            ddlfam.Enabled = True
            txtcve.Text = ""
            txtmat.Text = ""
            ddlfam.SelectedValue = 0
            ddlum.SelectedValue = 0
            consulta()
        End If
        If Not IsPostBack Then
            Dim sql As String = "SELECT IdFamilia, Convert(nvarchar(4),IdFamilia) +' - '+ PzaF_DescFamilia as PzaF_DescFamilia FROM Tbl_Pza_Familia where Pza_Tipo=1"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlfam.DataSource = dt
                ddlfam.DataTextField = "PzaF_DescFamilia"
                ddlfam.DataValueField = "IdFamilia"
                ddlfam.DataBind()
                ddlfam.Items.Add(New ListItem("Sel. la familia...", 0, True))
                ddlfam.SelectedValue = 0
            End If
            sql = "SELECT IdUnidad,IdUnidad+' - '+UM_DescUnidad as UM_DescUnidad FROM Tbl_UnidadMedida"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlum.DataSource = dt
                ddlum.DataTextField = "UM_DescUnidad"
                ddlum.DataValueField = "IdUnidad"
                ddlum.DataBind()
                ddlum.Items.Add(New ListItem("Sel. la Unidad de medida...", 0, True))
                ddlum.SelectedValue = 0
            End If
            consulta()

        End If

    End Sub
    Protected Sub consulta()
        Dim Sql As String = "SELECT     IdPieza, Pza_Clave, Pza_DescPieza, Pza_IdUnidad, Pza_IdFamilia, CASE WHEN Pza_Status = 0 THEN 'Activo' ELSE 'Baja' END AS Estatus,Pza_Status"
        Sql += " FROM Tbl_Pieza where Pza_Tipo=1"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub
    Protected Sub OnDataBounda(ByVal sender As Object, ByVal e As EventArgs)
        Dim row As New GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal)
        For i As Integer = 0 To GridView1.Columns.Count - 1
            Dim cell As New TableHeaderCell()
            Dim txtboxSearch As New TextBox()
            txtboxSearch.Attributes("placeholder") = GridView1.Columns(i).HeaderText
            txtboxSearch.Font.Name = "Tahoma"
            txtboxSearch.Font.Size = 8
            txtboxSearch.Width = 50%
            'txtboxSearch.CssClass = "search_textbox1"
            If GridView1.Columns(i).HeaderText <> "Sel" Then
                cell.Controls.Add(txtboxSearch)
            End If
            row.Controls.Add(cell)
        Next
        'If GridView1.Rows.Count > 0 Then GridView1.HeaderRow.Parent.Controls.AddAt(1, row)
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

        lblid.Text = GridView1.SelectedDataKey("IdPieza")
        ddlstatus.SelectedValue = GridView1.SelectedDataKey("Pza_Status")
        ddlfam.SelectedValue = GridView1.SelectedRow.Cells(0).Text
        ddlfam.Enabled = False
        txtcve.Text = GridView1.SelectedRow.Cells(1).Text
        txtcve.Enabled = False
        txtmat.Text = GridView1.SelectedRow.Cells(2).Text
        ddlum.SelectedValue = GridView1.SelectedRow.Cells(3).Text

    End Sub
    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        Dim datos As String
        '   IdPieza, Pza_Clave,                     Pza_DescPieza,          Pza_IdUnidad,           Pza_IdFamilia,                      Pza_Status, Pza_presentacion, Pza_capacidad, Pza_marca, Pza_reqauto, Pza_idprov, Pza_te_dias, Pza_Clase, Pza_PrecioAutorizado, Pza_Tipo, Pza_Localiza
        datos = lblid.Text & "#" & txtcve.Text & "#" & txtmat.Text & "#" & ddlum.SelectedValue & "#" & ddlfam.SelectedValue & "#" & ddlstatus.SelectedValue & "###0#0#0#0#2#0#1#"
        graba(datos)
    End Sub
    Protected Sub graba(ByVal datosg As String)
        Dim datos As Array = datosg.Split("#")
        Dim Sql As String = ""

        If datos(0) = "0" Then
            Sql = "Select * from tbl_pieza where Pza_Clave='" & datos(1) & "'"
            Dim myCommandi As New SqlDataAdapter(Sql, myConnection)
            Dim dsi As New DataSet
            myCommandi.Fill(dsi)
            If dsi.Tables(0).Rows.Count > 0 Then
                Response.Write("<script>alert('Validacion!. La clave que quiere ingresar ya exite, verifique');</script>")
                Exit Sub
            End If
            Sql = "Insert into Tbl_Pieza values ('" & datos(1) & "','" & datos(2) & "','" & datos(3) & "','" & datos(4) & "','" & datos(5) & "',"
            Sql += "'" & datos(6) & "','" & datos(7) & "','" & datos(8) & "'," & datos(9) & ",'" & datos(10) & "','" & datos(11) & "',"
            Sql += " '" & datos(12) & "'," & datos(13) & "," & datos(14) & ",'" & datos(15) & "')"
        Else
            Sql = " update Tbl_Pieza set  Pza_Clave='" & datos(1) & "', Pza_DescPieza='" & datos(2) & "',Pza_IdUnidad='" & datos(3) & "',"
            Sql += " Pza_IdFamilia='" & datos(4) & "',Pza_Status='" & datos(5) & "',Pza_presentacion='" & datos(6) & "',Pza_capacidad='" & datos(7) & "',"
            Sql += " Pza_marca='" & datos(8) & "',Pza_reqauto = " & datos(9) & ",Pza_idprov='" & datos(10) & "',Pza_te_dias='" & datos(11) & "',"
            Sql += "Pza_Clase='" & datos(12) & "',Pza_PrecioAutorizado = " & datos(13) & ",Pza_Tipo = " & datos(14) & ",Pza_Localiza='" & datos(15) & "'"
            Sql += " where IdPieza=" & datos(0) & ""
        End If
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)
        consulta()
    End Sub

End Class
