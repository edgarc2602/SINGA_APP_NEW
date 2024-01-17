Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net
Imports System.Net.Mail

Partial Class Ventas_App_Ven_Con_Cotizacion
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public lblcteinfo As String = ""
    Public labelmenu As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "continua"
                Dim sql As String = "select ID_Cotizacion,case when cot_tipo=1 then 'Cliente' else 'Prospecto' end Tipo"
                sql += ",case when cot_tipo=1 then (select Cte_Fis_Nombre_Comercial from Tbl_Cliente where ID_Cliente=cot_id)"
                sql += "else (select Pros_Razon_Social from Tbl_Prospecto where ID_Prospecto=a.cot_id) end razonsocial"
                sql += ",'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as folio "
                sql += ",b.TS_Descripcion,Cot_Subtotal,Cot_Subtotal*(1+(Cot_Por_Indirecto/100)) as [C/Indirecto]"
                sql += ",(Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100))as [C/Utilidad]"
                sql += ",((Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100)))*(1+(Cot_Por_Comercializacion/100))as [C/Comer],Cot_Estatus "
                sql += ", case when Cot_Estatus=0 then 'Alta' when Cot_Estatus=1 then 'Autorizada' when Cot_Estatus=2 then 'Cancelada' end estatus,Cot_Documento "

                sql += "from tbl_Cotizacion a inner join Tbl_TipoServicio b on b.IdTpoServicio=a.Cot_Id_TipoServicio"
                sql += "  where(cot_estatus >= 0) and ID_Cotizacion=" & lblid.Text & ""
                Dim ds As New SqlDataAdapter(sql, myConnection)
                Dim dtu As New DataTable
                ds.Fill(dtu)
                If dtu.Rows.Count > 0 Then
                    Select Case dtu.Rows(0).Item("Cot_Estatus")
                        Case 0
                            chkalta.Checked = True
                            chkautoriza.Checked = False
                            chkcancela.Checked = False
                        Case 1
                            chkalta.Checked = False
                            chkautoriza.Checked = True
                            chkcancela.Checked = False
                        Case 2
                            chkalta.Checked = False
                            chkautoriza.Checked = False
                            chkcancela.Checked = True
                    End Select
                    ViewState("dt") = dtu
                    BindGridData()
                Else
                    gvData.DataSource = Nothing
                    gvData.DataBind()
                End If
                Dim Script As String = "muestra(9);"
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
            Case "exporta"
                Dim sql As String = "select cot_version from tbl_Cotizacion where id_cotizacion=" & lblid.Text & ""
                Dim ds As New SqlDataAdapter(sql, myConnection)
                Dim dtu As New DataTable
                ds.Fill(dtu)
                Dim version As String = dtu.Rows(0).Item("cot_version")
                sql = "select 'Estados: ' +c.Estado as DESCRIPCION,"
                sql += " d.Pue_Puesto as PUESTO,Cot_Per_cantidad as CANTIDAD,Cot_Per_costo as [PRECIO U.],Cot_Per_costo * Cot_Per_cantidad as TOTAL "
                sql += " from Tbl_Cot_Personal a inner join turno b on a.Cot_Per_Idturno=b.Id_Turno "
                sql += " inner join Estados c on c.Id_Estado= a.cot_per_id_edo inner join Tbl_Puesto d on d.ID_Puesto=a.Cot_Per_Idpuesto"
                sql += " where(ID_Cotizacion = " & lblid.Text & " And Cot_Version = " & version & ")"
                ds = New SqlDataAdapter(sql, myConnection)
                dtu = New DataTable
                ds.Fill(dtu)
                Dim gv As New GridView
                gv.Caption = "Puestos"
                gv.AutoGenerateColumns = True
                gv.DataSource = dtu
                gv.DataBind()

                sql = "select d.Pue_Puesto as PUESTO,Sum(Cot_Per_cantidad)as CANTIDAD,b.Descripcion,b.Horario"
                sql += " from Tbl_Cot_Personal a inner join turno b on a.Cot_Per_Idturno=b.Id_Turno "
                sql += " inner join Estados c on c.Id_Estado= a.cot_per_id_edo inner join Tbl_Puesto d on d.ID_Puesto=a.Cot_Per_Idpuesto"
                sql += " where(ID_Cotizacion = " & lblid.Text & " And Cot_Version = " & version & ")"
                sql += " group by d.Pue_Puesto,b.Descripcion,b.Horario"

                ds = New SqlDataAdapter(sql, myConnection)
                dtu = New DataTable
                ds.Fill(dtu)
                Dim gv1 As New GridView
                gv1.Caption = "Plantilla"
                gv1.AutoGenerateColumns = True
                gv1.DataSource = dtu
                gv1.DataBind()


                sql = "select c.PzaF_DescFamilia Famila,ROW_NUMBER() OVER (partition by pzaf_descfamilia ORDER BY pzaf_descfamilia) AS fila,b.Pza_Clave as Clave,b.Pza_DescPieza as Descripcion,Cot_MHES_cantidad as cantidad,b.Pza_IdUnidad,"
                sql += " case when Cot_MHES_tipo in(1,2) then case when Cot_MHES_idfrecuencia=1 then 'Mensual' when Cot_MHES_idfrecuencia=3 then 'Trimestral' when Cot_MHES_idfrecuencia=6 then 'Semestral'"
                sql += " when Cot_MHES_idfrecuencia=12 then 'Anual'  end else convert(nvarchar(10), Cot_MHES_idfrecuencia) end as frecuencia"
                sql += " FROM         Tbl_Cot_MatHerEqpSE a inner join Tbl_Pieza b on a.Cot_MHES_Id_Pieza =b.IdPieza"
                sql += " inner join Tbl_Pza_Familia c on c.IdFamilia=b.Pza_IdFamilia"
                sql += " where(ID_Cotizacion = " & lblid.Text & " And Cot_Version = " & version & ") and Cot_MHES_tipo in (1,2)"
                ds = New SqlDataAdapter(sql, myConnection)
                dtu = New DataTable
                ds.Fill(dtu)
                Dim gv2 As New GridView
                gv2.Caption = "Materiales y Uniformes"
                gv2.AutoGenerateColumns = True
                gv2.DataSource = dtu
                gv2.DataBind()


                sql = " select c.PzaF_DescFamilia Famila,ROW_NUMBER() OVER (partition by pzaf_descfamilia ORDER BY pzaf_descfamilia) AS fila,"
                sql += " b.Pza_Clave as Clave,b.Pza_DescPieza as Descripcion,Cot_MHES_cantidad as cantidad,b.Pza_IdUnidad"
                sql += " FROM         Tbl_Cot_MatHerEqpSE a inner join Tbl_Pieza b on a.Cot_MHES_Id_Pieza =b.IdPieza"
                sql += " inner join Tbl_Pza_Familia c on c.IdFamilia=b.Pza_IdFamilia"
                sql += " where(ID_Cotizacion = " & lblid.Text & " And Cot_Version = " & version & ") and Cot_MHES_tipo in (3,4)"

                ds = New SqlDataAdapter(sql, myConnection)
                dtu = New DataTable
                ds.Fill(dtu)
                Dim gv3 As New GridView
                gv3.Caption = "Equipo y Herramienta"
                gv3.AutoGenerateColumns = True
                gv3.DataSource = dtu
                gv3.DataBind()


                sql = "select 'SERV. ADICIONALES' Famila,ROW_NUMBER() OVER (ORDER BY a.id_fila) AS fila,"
                sql += " b.SAdi_Clave as Clave,b.SAdi_DescPieza as Descripcion,Cot_MHES_cantidad as cantidad"
                sql += " FROM         Tbl_Cot_MatHerEqpSE a inner join Tbl_ServiciosAdicionales b on a.Cot_MHES_Id_Pieza =b.IdPieza"
                sql += " where(ID_Cotizacion = " & lblid.Text & " And Cot_Version = " & version & ") and Cot_MHES_tipo in (5)"
                ds = New SqlDataAdapter(sql, myConnection)
                dtu = New DataTable
                ds.Fill(dtu)
                Dim gv4 As New GridView
                gv4.Caption = "Ser. Adicional"
                gv4.AutoGenerateColumns = True
                gv4.DataSource = dtu
                gv4.DataBind()

                Response.Clear()
                Response.Buffer = True
                Response.AddHeader("content-disposition", _
                       "attachment;filename=GridViewExport.xls")
                Response.Charset = ""
                Response.ContentType = "application/vnd.ms-excel"
                Dim sw As New StringWriter()
                Dim hw As New HtmlTextWriter(sw)

                Dim tb As New Table()
                Dim tr1 As New TableRow()
                Dim cell1 As New TableCell()
                cell1.Controls.Add(gv)
                tr1.Cells.Add(cell1)

                Dim cell3 As New TableCell()
                cell3.Controls.Add(gv1)
                Dim cell2 As New TableCell()
                cell2.Text = "&nbsp;"
                ''If rbPreference.SelectedValue = "2" Then
                'tr1.Cells.Add(cell2)
                'tr1.Cells.Add(cell3)
                'tb.Rows.Add(tr1)
                ''Else
                Dim tr2 As New TableRow()
                tr2.Cells.Add(cell2)
                Dim tr3 As New TableRow()
                tr3.Cells.Add(cell3)
                'End If


                Dim cell5 As New TableCell()
                cell5.Controls.Add(gv2)
                Dim cell4 As New TableCell()
                cell4.Text = "&nbsp;"
                Dim tr4 As New TableRow()
                tr4.Cells.Add(cell4)
                Dim tr5 As New TableRow()
                tr5.Cells.Add(cell5)

                Dim cell7 As New TableCell()
                cell7.Controls.Add(gv3)
                Dim cell6 As New TableCell()
                cell6.Text = "&nbsp;"
                Dim tr6 As New TableRow()
                tr6.Cells.Add(cell6)
                Dim tr7 As New TableRow()
                tr7.Cells.Add(cell7)


                Dim cell9 As New TableCell()
                cell9.Controls.Add(gv4)
                Dim cell8 As New TableCell()
                cell8.Text = "&nbsp;"
                Dim tr8 As New TableRow()
                tr8.Cells.Add(cell8)
                Dim tr9 As New TableRow()
                tr9.Cells.Add(cell9)


                tb.Rows.Add(tr1)
                tb.Rows.Add(tr2)
                tb.Rows.Add(tr3)
                tb.Rows.Add(tr4)
                tb.Rows.Add(tr5)
                tb.Rows.Add(tr6)
                tb.Rows.Add(tr7)
                tb.Rows.Add(tr8)
                tb.Rows.Add(tr9)




                tb.RenderControl(hw)
                'style to format numbers to string 
                Dim style As String = "<style> .textmode { mso-number-format:\@; } </style>"
                Response.Write(style)
                Response.Output.Write(sw.ToString())
                Response.Flush()
                Response.End()

                'ExportToExcel("Informe.xls", gv)

        End Select

        If Not IsPostBack Then
            chkcliente.Checked = True
        End If
    End Sub


    Protected Sub PrepareForExport(ByVal Gridview As GridView)

        ''Change the Header Row back to white color 
        'Gridview.HeaderRow.Style.Add("background-color", "#FFFFFF")
        ''Apply style to Individual Cells 
        'For k As Integer = 0 To Gridview.HeaderRow.Cells.Count - 1
        ' Gridview.HeaderRow.Cells(k).Style.Add("background-color", "green")
        ' Next
        For i As Integer = 0 To Gridview.Rows.Count - 1
            Dim row As GridViewRow = Gridview.Rows(i)
            'Change Color back to white 
            ' row.BackColor = System.Drawing.Color.White
            ' 'Apply text style to each Row 
            ' row.Attributes.Add("class", "textmode")
            'Apply style to Individual Cells of Alternating Row 
            'If i Mod 2 <> 0 Then
            ' For j As Integer = 0 To Gridview.Rows(i).Cells.Count - 1
            ' row.Cells(j).Style.Add("background-color", "#C2D69B")
            'Next
            ' End If
        Next
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
    Protected Sub Button3_Click(sender As Object, e As System.EventArgs) Handles Button3.Click
        Dim sql As String = "select ID_Cotizacion,case when cot_tipo=1 then 'Cliente' else 'Prospecto' end Tipo"
        Sql += ",case when cot_tipo=1 then (select Cte_Fis_Nombre_Comercial from Tbl_Cliente where ID_Cliente=cot_id)"
        Sql += "else (select Pros_Razon_Social from Tbl_Prospecto where ID_Prospecto=a.cot_id) end razonsocial"
        sql += ",'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as folio ,"
        sql += " case when Cot_Estatus=0 then 'Alta' when Cot_Estatus=1 then 'Autorizada' when Cot_Estatus=2 then 'Cancelada' end estatus"
        Sql += ",b.TS_Descripcion,Cot_Subtotal,Cot_Subtotal*(1+(Cot_Por_Indirecto/100)) as [C/Indirecto]"
        Sql += ",(Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100))as [C/Utilidad]"
        sql += ",((Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100)))*(1+(Cot_Por_Comercializacion/100))as [C/Comer],Cot_Estatus,Cot_Documento "
        Sql += "from tbl_Cotizacion a inner join Tbl_TipoServicio b on b.IdTpoServicio=a.Cot_Id_TipoServicio"
        sql += "  where(cot_estatus >= 0)"
        If chkcliente.Checked = True And txtrsc.Text <> "" Then
            sql += " and cot_id in (select ID_Cliente from Tbl_Cliente where Cte_Fis_Razon_Social LIKE '%" & txtrsc.Text & "%')"
        End If
        If chkprospecto.Checked = True And txtrsp.Text <> "" Then
            sql += " and cot_id in(select ID_Prospecto from Tbl_Prospecto where Pros_Razon_Social LIKE '%" & txtrsp.Text & "%')"
        End If
        If chkts.Checked = True And ddltservicio.Text <> "" Then
            sql += " and cot_Id_TipoServicio=" & ddltservicio.SelectedValue & ""
        End If
        If chkfecha.Checked = True And IsDate(txtfi.Text) And IsDate(txtff.Text) Then
            sql += " and convert(date, cot_Fecha) between '" & txtfi.Text & "' and '" & txtff.Text & "'"
        End If
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dtu As New DataTable
        ds.Fill(dtu)
        If dtu.Rows.Count > 0 Then
            ViewState("dt") = dtu
            BindGridData()
        Else
            gvData.DataSource = Nothing
            gvData.DataBind()

        End If
        Dim Script As String = "muestra(0);"
        If chkcliente.Checked = True Then
            Script = "muestra(0);"
        End If
        If chkprospecto.Checked = True Then
            Script = "muestra(1);"
        End If
        If chkts.Checked = True Then
            Script = "muestra(2);"
        End If
        If chkfecha.Checked = True Then
            Script = "muestra(3);"
        End If

        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
        lblid.Text = "0"
    End Sub
    Protected Sub BindGridData()
        gvData.DataSource = TryCast(ViewState("dt"), DataTable)
        gvData.DataBind()
    End Sub

    Protected Sub OnDataBound(ByVal sender As Object, ByVal e As EventArgs)

        Dim row As New GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal)
        For i As Integer = 0 To gvData.Columns.Count - 1
            Dim cell As New TableHeaderCell()
            Dim txtboxSearch As New TextBox()
            txtboxSearch.Attributes("placeholder") = gvData.Columns(i).HeaderText
            txtboxSearch.Font.Name = "Tahoma"
            txtboxSearch.Font.Size = 8
            txtboxSearch.CssClass = "search_textbox"

            'cell.Controls.Add(txtboxSearch)
            'row.Controls.Add(cell)
        Next
        gvData.HeaderRow.Parent.Controls.AddAt(1, row)

    End Sub

    Protected Sub gvData_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvData.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("OnClick", "oculta('" & GridView1.DataKeys(e.Row.DataItemIndex)("RFC") & "');")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(gvData, "Select$" & e.Row.RowIndex.ToString())
        End Select

    End Sub

    Protected Sub gvData_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles gvData.SelectedIndexChanged
        lblid.Text = gvData.SelectedDataKey("ID_Cotizacion")
        lblestatus.Text = gvData.SelectedDataKey("Cot_Estatus")
        If IsDBNull(gvData.SelectedDataKey("Cot_Documento")) Then LinkButton1.Text = "" Else LinkButton1.Text = gvData.SelectedDataKey("Cot_Documento")
        If IsDBNull(gvData.SelectedDataKey("Cot_Documento")) Then LinkButton2.Text = "" Else LinkButton2.Text = gvData.SelectedDataKey("Cot_Documento")
        Dim Script As String = "muestra(0);"
        If chkcliente.Checked = True Then
            Script = "muestra(0);"
        End If
        If chkprospecto.Checked = True Then
            Script = "muestra(1);"
        End If
        If chkts.Checked = True Then
            Script = "muestra(2);"
        End If
        If chkfecha.Checked = True Then
            Script = "muestra(3);"
        End If
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)

    End Sub

    Protected Sub btnEstatus_Click(sender As Object, e As System.EventArgs) Handles btnEstatus.Click
        Dim estatus As Integer = 0
        If chkalta.Checked = True Then estatus = 0
        If chkautoriza.Checked = True Then estatus = 1
        If chkcancela.Checked = True Then estatus = 2

        Dim sql As String = "Update tbl_Cotizacion set cot_estatus=" & estatus & ""
        sql += "  where ID_Cotizacion=" & lblid.Text & ""
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dtu As New DataTable
        ds.Fill(dtu)

        sql = "select ID_Cotizacion,case when cot_tipo=1 then 'Cliente' else 'Prospecto' end Tipo"
        sql += ",case when cot_tipo=1 then (select Cte_Fis_Nombre_Comercial from Tbl_Cliente where ID_Cliente=cot_id)"
        sql += "else (select Pros_Razon_Social from Tbl_Prospecto where ID_Prospecto=a.cot_id) end razonsocial"
        sql += ",'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as folio "
        sql += ",b.TS_Descripcion,Cot_Subtotal,Cot_Subtotal*(1+(Cot_Por_Indirecto/100)) as [C/Indirecto]"
        sql += ",(Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100))as [C/Utilidad]"
        sql += ",((Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100)))*(1+(Cot_Por_Comercializacion/100))as [C/Comer],Cot_Estatus "
        sql += ", case when Cot_Estatus=0 then 'Alta' when Cot_Estatus=1 then 'Autorizada' when Cot_Estatus=2 then 'Cancelada' end estatus,Cot_Version,Cot_Documento "

        sql += "from tbl_Cotizacion a inner join Tbl_TipoServicio b on b.IdTpoServicio=a.Cot_Id_TipoServicio"
        sql += "  where  ID_Cotizacion=" & lblid.Text & ""
        ds = New SqlDataAdapter(sql, myConnection)
        dtu = New DataTable
        ds.Fill(dtu)
        ViewState("dt") = dtu
        BindGridData()
        lblid.Text = "0"
        Dim hora As String = Date.Now.ToString("HH:mm:ss")
        Dim fecha As String = Date.Today

        sql = "  insert into Tbl_Cot_Ctrl_Cambios"
        sql += " select " & lblid.Text & " ," & dtu.Rows(0).Item("Cot_Version") & ",'" & fecha & " " & hora & "' ," & Session("v_usuario") & "," & dtu.Rows(0).Item("Cot_estatus") & ",'Cambio de estatus'"


    End Sub

    Protected Sub ctnadjunta_Click(sender As Object, e As System.EventArgs) Handles ctnadjunta.Click
        Dim ruta As String = Server.MapPath("")
        If cargaarch.HasFile Then
            cargaarch.SaveAs("" & ruta & "/DocCot/" + cargaarch.FileName.ToString())
        End If

        Dim sql As String = "Update tbl_Cotizacion set cot_documento='" & cargaarch.FileName.ToString() & "'"
        sql += "  where ID_Cotizacion=" & lblid.Text & ""
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dtu As New DataTable
        ds.Fill(dtu)

    End Sub

    Protected Sub LinkButton1_Click(sender As Object, e As System.EventArgs) Handles LinkButton1.Click
        Dim filename As String = Server.MapPath("")
        filename += "/DocCot/" + LinkButton1.Text
        If (Not String.IsNullOrEmpty(filename)) Then
            Dim toDownload = New System.IO.FileInfo(filename)
            Response.Clear()
            Response.AddHeader("Content-Disposition", "attachment; filename=" + toDownload.Name)
            Response.AddHeader("Content-Length", toDownload.Length.ToString())
            Response.ContentType = "application/octet-stream"
            Response.WriteFile(filename)
            Response.End()
        End If
    End Sub

    Protected Sub ImageButton2_Click(sender As Object, e As System.Web.UI.ImageClickEventArgs) Handles ImageButton2.Click
        correo1()
    End Sub
    Protected Sub correo1()
        'Dim cc As String = TextBox7.Text & ";" & textbox3.Text
        Dim cc As String = txtpara.Text & ""
        Dim mail As New MailMessage
        mail.From = New MailAddress("lhernandez@interlabel.com.mx")
        'mail.Bcc.Add(TextBox3.Text)
        Dim v_par As Array
        v_par = (cc).Split(";")
        Dim i As Integer = 0
        For i = 0 To v_par.Length - 1
            mail.To.Add("" & v_par(i) & "")
        Next
        mail.Subject = "" & txtmensaje.Text & ""


        Dim FilePath As String = ""
        Dim filename As String = Server.MapPath("")
        filename += "/DocCot/" + LinkButton2.Text

        FilePath = filename
        mail.Attachments.Add(New Attachment(FilePath))

        Dim sb As New StringBuilder()
        sb.Append("<html>")

        sb.Append("<table width=""835"" height=""79"" >")
        sb.Append("<tr>")
        sb.Append("<td width=""835""><form id=""form1"" name=""form1"" method=""post"" action="""">")
        sb.Append("<label>")
        sb.Append("<input type=""image"" name=""logo"" id=""logo"" src=""cid:imagen001"" />")
        sb.Append("</label>")
        sb.Append("</form></td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td width=""830"" >")
        sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
        sb.Append("<tr><td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 10pt; color: #FFFFFF"">Datos Generales:</td> </tr>")
        sb.Append("</table>")

        sb.Append("<table width=""830"" cellpadding=""1"" cellspacing=""1"" >")
        sb.Append("<tr>")
        sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">Fecha Envio:</td>")
        sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & Format(Date.Today, "dd/MM/yyyy") & "</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">Cliente:</td>")
        sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & gvData.SelectedRow.Cells(1).Text & "</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">No. Cotizacion:</td>")
        sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & gvData.SelectedRow.Cells(2).Text & "</td>")
        sb.Append("</tr>")
        sb.Append("</table>")

        sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
        sb.Append("<tr><td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 10pt; color: #FFFFFF"">Mensaje:</td> </tr>")


        sb.Append("<td height=""8"">")

        Dim mensaje As String = ""
        mensaje = Replace(txtmensaje.Text, Chr(13), "<br />")
        sb.Append("<p><br />" & mensaje & "</p>")
        sb.Append("</table>")
        sb.Append("</table>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<input type=""image"" name=""logo1"" id=""logo2"" src=""cid:imagen002"" height=""56"" width=""836"" />")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")

        sb.Append("</html>")

        mail.Body = sb.ToString()

        Dim HTMLConImagenes As AlternateView
        HTMLConImagenes = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen As LinkedResource
        imagen = New LinkedResource((Server.MapPath("..\Content\img\Correo\headerbk.png")))
        imagen.ContentId = "imagen001"
        HTMLConImagenes.LinkedResources.Add(imagen)
        mail.AlternateViews.Add(HTMLConImagenes)

        Dim HTMLConImagenes1 As AlternateView
        HTMLConImagenes1 = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen1 As LinkedResource
        imagen1 = New LinkedResource((Server.MapPath("..\Content\img\Correo\footerbk.png")))
        imagen1.ContentId = "imagen002"
        HTMLConImagenes1.LinkedResources.Add(imagen1)
        mail.AlternateViews.Add(HTMLConImagenes1)
        Dim pass As String = "Barbosa1"
        Dim mailClient As New SmtpClient()
        Dim basicAuthenticationInfo As New NetworkCredential("lhernandez@interlabel.com.mx", "" & pass & "")
        mailClient.Host = "smtp.alestraune.net.mx"
        mailClient.UseDefaultCredentials = True
        mailClient.Credentials = basicAuthenticationInfo
        mailClient.Port = 587
        Try
            mailClient.Send(mail)
            Response.Write("<script>alert('Mensaje enviado satisfactoriamente');</script>")
            'Response.Write("<script>javascript:self.close()</script>")
        Catch ex As Exception
            Response.Write("<script>alert('ERROR: " & ex.Message & "');</script>")
        End Try
    End Sub
End Class
