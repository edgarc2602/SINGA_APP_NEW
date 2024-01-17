Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class App_Operaciones_Ope_tk_Consulta
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public labelmenu As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("v_usuario") = Nothing Then
            Response.Redirect("../login.aspx")
        End If
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "opcion"
                Select Case Request.Params("__eventargument")
                    Case 0
                        consultaticket()
                    Case 1
                        exporta()                        
                    Case 2
                        Session("v_consulta") = txtfecini.Text & "|" & txtfecfin.Text & "|" & ddlmes.SelectedValue & "|" & txtnumtk.Text & "|" & txtfolio.Text & "|"
                        If txtrs.Text <> "" Then
                            Dim sql1 As String = "select ID_Cliente from tbl_cliente where Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
                            Dim myCommand1 As New SqlDataAdapter(sql1, myConnection)
                            Dim dt1 As New DataTable
                            myCommand1.Fill(dt1)
                            If dt1.Rows.Count > 0 Then
                                Session("v_consulta") += dt1.Rows(0).Item("ID_Cliente").ToString
                            End If
                        End If
                        Session("v_consulta") += "|" & ddlarearesp.SelectedValue.ToString & "|" & ddlstatus.SelectedValue.ToString
                        Dim Script As String = "muestra(3);"
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "muestra", Script, True)
                End Select
        End Select
        If Not IsPostBack Then
            Dim sql As String = "SELECT IdArea, Ar_Nombre FROM Tbl_Area_Empresa where isnull(ar_estatus,0) =0"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            ddlarearesp.DataSource = dt
            ddlarearesp.DataTextField = "Ar_Nombre"
            ddlarearesp.DataValueField = "IdArea"
            ddlarearesp.DataBind()
            ddlarearesp.Items.Add(New ListItem("Sel. el area...", 0, True))
            ddlarearesp.SelectedValue = 0
            ddlstatus.SelectedValue = -1
            ddlmes.SelectedValue = 0
            Dim fecfin As Date = DateTime.Now.ToString("dd/MM/yyyy")
            Dim fecini As Date = "01/" & fecfin.Month & "/" & fecfin.Year
            txtfecfin.Text = fecfin
            txtfecini.Text = fecini
            consultaticket()
        End If
    End Sub
    Protected Sub exporta()
        consultaticket()
        'Dim sql As String = "select (SELECT STUFF((SELECT '/' + Tbl_Area_Empresa.Ar_Nombre FROM Tbl_Area_Empresa WHERE convert(nvarchar(100),Tbl_Area_Empresa.IdArea) in(select substring from funcionSplit(a.IdArea,',',1000) )"
        'sql += " FOR XML PATH (''), TYPE).value('.[1]', 'nvarchar(4000)'), 1, 1, '')) AS Ar_Nombre,"

        'sql += "ID_Ticket as ID,No_Ticket as Ticket,Tk_Folio as Folio,"
        'sql += " case when Tk_Estatus=0 then 'Alta' when Tk_Estatus=1 then 'Atendido'"
        'sql += " when Tk_Estatus=2 then 'Cerrado' when Tk_Estatus=4 then 'Cancelado'  end Estatus"
        'sql += " ,Tk_FechaAlta as FechaAlta,Tk_HoraAlta as HoraAlta,Tk_FechaTermino as FechaTermino,Tk_HoraTermino as HoraTermino"
        'sql += " ,DATENAME(MM,convert(date,'01/'+ convert(nvarchar(2),Tk_MesServicio) +'/2019')) as MesServicio,Tk_MesServicio as Valor,case when ID_Ambito=1 then 'Local' else 'Foraneo' end Ambito"
        'sql += " ,b.Cte_Fis_Nombre_Comercial as Cliente,d.Estado,a.Sucursal,e.Tk_Inc_Descripcion as Incidencia,"
        'sql += " f.Tk_CuaOri_Descripcion as CausaOrigen,a.Tk_Descripcion as Descripcion,a.Tk_Accion_Correctiva as AccionCorrectiva,"
        'sql += " a.Tk_Accion_Preventiva as AccionPreventiva," 'h.Per_Nombre +' '+h.Per_Paterno as PersonalRespuesta,"
        'sql += " a.Tk_Reporta,i.Per_Nombre +' '+i.Per_Paterno as Ejecutivo"
        'sql += "  from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        'sql += "  left outer join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
        'sql += "  left outer join Estados d on d.Id_Estado=a.ID_Estado"
        'sql += " inner join Tbl_tk_Incidencia e on e.ID_Incidencia=a.ID_Incidencia"
        'sql += " inner join Tbl_tk_CausaOrigen f on f.ID_CausaOrigen=a.ID_CausaOrigen"
        '' sql += " inner join Tbl_Area_Empresa g on g.IdArea=a.IdArea"
        '' sql += " inner join Personal h on h.IdPersonal=a.Tk_ID_Responsable"
        'sql += " inner join Personal i on i.IdPersonal=a.Tk_ID_Ejecutivo"
        'sql += " where tk_Estatus<> 10 "
        'If IsDate(txtfecini.Text) And IsDate(txtfecfin.Text) Then
        '    Dim fecini, fecfin As Date
        '    fecini = txtfecini.Text : fecfin = txtfecfin.Text
        '    'sql += " and  Tk_Fechasistema between '" & fecini & "' and '" & fecfin & "'"
        '    sql += " and  convert(date, tk_fechaalta) between '" & fecini & "' and '" & fecfin & "'"

        'End If
        'If ddlmes.SelectedValue <> 0 Then sql += " and Tk_MesServicio=" & ddlmes.SelectedValue & " "
        'If IsNumeric(txtnumtk.Text) Then sql += " and No_Ticket=" & txtnumtk.Text & " "
        'If txtfolio.Text <> "" Then sql += " and Tk_Folio='" & txtfolio.Text & "'"
        'If txtrs.Text <> "" Then
        '    Dim datos As Array = txtrs.Text.Split("|")
        '    If datos.Length > 1 Then
        '        sql += " and  a.ID_Cliente=" & datos(0) & ""
        '    End If
        'End If
        'If ddlarearesp.SelectedValue <> 0 Then sql += " and a.IdArea=" & ddlarearesp.SelectedValue & " "
        'If ddlstatus.SelectedValue <> -1 Then sql += " and a.Tk_Estatus=" & ddlstatus.SelectedValue & " "
        'sql += " order by id_ticket"
        'Dim myCommand As New SqlDataAdapter(sql, myConnection)
        'Dim dt As New DataTable
        'myCommand.Fill(dt)
        'gwm.DataSource = dt
        'gwm.DataBind()

        ExportToExcel("tickets.xls", gwm)
    End Sub
    Protected Sub consultaticket()
        Dim sql As String = "select (SELECT STUFF((SELECT '/' + Tbl_Area_Empresa.Ar_Nombre FROM Tbl_Area_Empresa WHERE convert(nvarchar(100),Tbl_Area_Empresa.IdArea) in(select substring from funcionSplit(a.IdArea,',',1000) )"
        sql += " FOR XML PATH (''), TYPE).value('.[1]', 'nvarchar(4000)'), 1, 1, '')) AS Ar_Nombre,"
        sql += " ID_Ticket as ID,No_Ticket as Ticket,Tk_Folio as Folio,"
        sql += " case when Tk_Estatus=0 then 'Alta' when Tk_Estatus=1 then 'Atendido'"
        sql += " when Tk_Estatus=2 then 'Cerrado' when Tk_Estatus=4 then 'Cancelado'  end Estatus"
        sql += " ,Tk_FechaAlta as FechaAlta,Tk_HoraAlta as HoraAlta,Tk_FechaTermino as FechaTermino,Tk_HoraTermino as HoraTermino"
        sql += " ,DATENAME(MM,convert(date,'01/'+ convert(nvarchar(2),Tk_MesServicio) +'/1900')) as MesServicio,Tk_MesServicio as Valor,case when ID_Ambito=1 then 'Local' else 'Foraneo' end Ambito"
        sql += " ,b.Cte_Fis_Nombre_Comercial as Cliente,d.Estado,a.Sucursal,e.Tk_Inc_Descripcion as Incidencia,"
        sql += " f.Tk_CuaOri_Descripcion as CausaOrigen,a.Tk_Descripcion as Descripcion,a.Tk_Accion_Correctiva as AccionCorrectiva,"
        sql += " a.Tk_Accion_Preventiva as AccionPreventiva," 'h.Per_Nombre +' '+h.Per_Paterno as PersonalRespuesta,"
        sql += " a.Tk_Reporta,i.Per_Nombre +' '+i.Per_Paterno as Ejecutivo"
        sql += "  from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        sql += " left outer join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
        sql += " left outer join Estados d on d.Id_Estado=a.ID_Estado"
        sql += " inner join Tbl_tk_Incidencia e on e.ID_Incidencia=a.ID_Incidencia"
        sql += " inner join Tbl_tk_CausaOrigen f on f.ID_CausaOrigen=a.ID_CausaOrigen"
        'sql += " inner join Tbl_Area_Empresa g on g.IdArea=a.IdArea"
        'sql += " inner join Personal h on h.IdPersonal=a.Tk_ID_Responsable"
        sql += " inner join Personal i on i.IdPersonal=a.Tk_ID_Ejecutivo"
        sql += " where tk_Estatus<> 10 "
        If IsDate(txtfecini.Text) And IsDate(txtfecfin.Text) Then
            Dim fecini, fecfin As Date
            fecini = txtfecini.Text : fecfin = txtfecfin.Text
            'sql += " and  Tk_Fechasistema between '" & fecini & "' and '" & fecfin & "'"
            sql += " and  convert(date, tk_fechaalta) between '" & fecini & "' and '" & fecfin & "'"
        End If
        If ddlmes.SelectedValue <> 0 Then sql += " and Tk_MesServicio=" & ddlmes.SelectedValue & " "
        If IsNumeric(txtnumtk.Text) Then sql += " and No_Ticket=" & txtnumtk.Text & " "
        If txtfolio.Text <> "" Then sql += " and Tk_Folio='" & txtfolio.Text & "'"
        If txtrs.Text <> "" Then

            Dim sql1 As String = "select ID_Cliente from tbl_cliente where Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
            Dim myCommand1 As New SqlDataAdapter(sql1, myConnection)
            Dim dt1 As New DataTable
            myCommand1.Fill(dt1)
            If dt1.Rows.Count > 0 Then
                sql += " and a.ID_Cliente=" & dt1.Rows(0).Item("ID_Cliente") & ""
            End If
        End If
        If ddlarearesp.SelectedValue <> 0 Then sql += " and a.IdArea=" & ddlarearesp.SelectedValue & " "
        If ddlstatus.SelectedValue <> -1 Then sql += " and a.Tk_Estatus=" & ddlstatus.SelectedValue & " "
        sql += " order by id_ticket"
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        gwm.DataSource = dt
        gwm.DataBind()

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
    Protected Sub gwm_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gwm.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("OnClick", "ticket('" & gwm.DataKeys(e.Row.DataItemIndex)("ID") & "');")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(gwm, "Select$" & e.Row.RowIndex.ToString())
        End Select
    End Sub
    Protected Sub OnDataBounda(ByVal sender As Object, ByVal e As EventArgs)
        Dim row As New GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal)
        For i As Integer = 0 To gwm.Columns.Count - 1
            Dim cell As New TableHeaderCell()
            Dim txtboxSearch As New TextBox()
            txtboxSearch.Attributes("placeholder") = gwm.Columns(i).HeaderText
            txtboxSearch.Font.Name = "Tahoma"
            txtboxSearch.Font.Size = 8
            txtboxSearch.Width = 50%
            txtboxSearch.CssClass = "search_textbox1"
            If gwm.Columns(i).HeaderText <> "Sel" Then
                cell.Controls.Add(txtboxSearch)
            End If
            row.Controls.Add(cell)
        Next
        If gwm.Rows.Count > 0 Then gwm.HeaderRow.Parent.Controls.AddAt(1, row)
    End Sub

    'Protected Sub gwm_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwm.SelectedIndexChanged

    '    vst.RowFilter = "Id=" & gwm.SelectedDataKey("ID") & " "

    'End Sub
    Protected Sub gwm_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles gwm.SelectedIndexChanged
        Response.Write("<script>window.open('Ope_Ticket.aspx?Id=" & gwm.SelectedDataKey("ID") & "','dialogHeight:320px; dialogWidth:100px')</script>")
    End Sub
End Class
