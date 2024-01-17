Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Data.OleDb

Partial Class Inventarios_App_Inv_Cat_Precios
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
        If Request.Params("__EVENTTARGET") = "opcion" Then
            Select Case Request.Params("__eventargument")
                Case 1
                    llenagrid()
                Case 2
                    Dim Sql As String = "EXEC spConPzaPrecio '" & ddlfam.SelectedValue & "'"
                    Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                    Dim dsd As New DataSet
                    myCommand.Fill(dsd)
                    Dim grid As New GridView
                    grid.Caption = ddlfam.SelectedItem.Text
                    grid.AutoGenerateColumns = True
                    grid.DataSource = dsd
                    grid.DataBind()
                    ExportToExcel("" & ddlfam.SelectedValue & ".xls", grid)
                Case 4
                    importa()
            End Select
        End If

        If Not IsPostBack Then
            Dim sql As String = "SELECT IdFamilia, Convert(nvarchar(4),IdFamilia) +' - '+ PzaF_DescFamilia as PzaF_DescFamilia FROM Tbl_Pza_Familia"
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
        End If
    End Sub
    Protected Sub llenagrid()
        Dim Sql As String = "EXEC spConPzaPrecio '" & ddlfam.SelectedValue & "'"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dsd As New DataSet
        myCommand.Fill(dsd)
        GridView1.DataSource = dsd
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
    Private Sub ExportToExcel(ByVal nameReport As String, ByVal wControl As GridView)
        Dim responsePage As HttpResponse = Response
        'StringBuilder(sb = New StringBuilder())
        Dim sb As New StringBuilder()

        Dim sw As New StringWriter(sb)
        Dim htw As New HtmlTextWriter(sw)
        Dim pageToRender As New Page()
        Dim form As New HtmlForm()
        wControl.EnableViewState = False

        pageToRender.EnableEventValidation = False
        pageToRender.DesignerInitialize()

        form.Controls.Add(wControl)
        pageToRender.Controls.Add(form)
        pageToRender.RenderControl(htw)

        responsePage.Clear()
        responsePage.Buffer = True
        responsePage.ContentType = "application/vnd.ms-excel"
        responsePage.AddHeader("Content-Disposition", "attachment;filename=" & nameReport)
        responsePage.Charset = "UTF-8"
        responsePage.ContentEncoding = Encoding.Default
        responsePage.Write(sw.ToString())
        responsePage.End()
    End Sub
    Protected Sub importa()
        Dim ext As Array = Server.MapPath(cargaarch.FileName.ToString()).Split(".")
        Dim A_Nombre As String = "cargaprecio."
        A_Nombre += ext(ext.Length - 1)
        If cargaarch.HasFile Then
            cargaarch.SaveAs("f:\Inventario\" + A_Nombre)
        End If
        'CargaArchivo(A_Nombre)
        Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & _
      "data source=" & "f:\Inventario\" + A_Nombre & ";Extended Properties=Excel 12.0;")

        cnn.Open()
        Dim sqlExcel As String = "Select * From [" & ddlfam.SelectedValue & "$] WHERE id IS NOT NULL"
        Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
        Dim da As New OleDbDataAdapter(myCommand1)
        Dim dt As New DataTable
        da.Fill(dt)
        dt.TableName = "p"
        Dim dsr As New DataSet
        dsr.Tables.Add(dt)
        cnn.Close()

        Dim strxmlinv As String = dsr.GetXml()
        Dim Sql As String = "EXEC [spinsertPzaPrecio] '" & strxmlinv & "'"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dsd As New DataSet
        myCommand.Fill(dsd)
        llenagrid()
    End Sub
End Class
