Imports System.Data
Imports System.Data.SqlClient

Partial Class Ventas_App1_Ven_Directorio
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labelmenu As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        If Request.Params("__EVENTTARGET") = "limpia" Then
            txtid.Text = "0"
            txtnsuc.Text = ""
            txtsuc.Text = ""
            txtcvei.Text = ""
            txtcalle.Text = ""
            txtcol.Text = ""
            txtcp.Text = ""
            txtdel.Text = ""
            txtcd.Text = ""
            ddlestado.SelectedValue = 0
            ddlstatus.SelectedValue = 0
            txtcon.Text = ""
            txtmail.Text = ""
            txttel.Text = ""
            BindGridData()
        End If

        If Not IsPostBack Then
            If Request("idc") <> Nothing Then
                Dim sql As String = "select a.ID_Cliente,Cte_Fis_Clave_Cliente,Cte_Fis_Nombre_Comercial,Cte_Ser_Tipos_Servicios "
                sql += " from Tbl_Cliente a inner join Tbl_Cliente_Ser b on b.ID_Cliente =a.ID_Cliente where a.ID_Cliente=" & Request("idc") & ""
                Dim ds As New SqlDataAdapter(sql, myConnection)
                Dim dt As New DataTable()
                ds.Fill(dt)
                If dt.Rows.Count > 0 Then
                    txtidc.Text = dt.Rows(0).Item("ID_Cliente")
                    txtclave.Text = dt.Rows(0).Item("Cte_Fis_Clave_Cliente")
                    txtncomercial.Text = dt.Rows(0).Item("Cte_Fis_Nombre_Comercial")
                    Select Case dt.Rows(0).Item("Cte_Ser_Tipos_Servicios")
                        Case 0
                            chkmto.Checked = False
                            chklim.Checked = False
                            chkfum.Checked = False
                            chkjar.Checked = False
                        Case 1
                            chkmto.Checked = True
                            chklim.Checked = False
                            chkfum.Checked = False
                            chkjar.Checked = False
                        Case 2
                            chkmto.Checked = False
                            chklim.Checked = True
                            chkfum.Checked = False
                            chkjar.Checked = False
                        Case 3
                            chkmto.Checked = False
                            chklim.Checked = False
                            chkfum.Checked = True
                            chkjar.Checked = False
                        Case 4
                            chkmto.Checked = False
                            chklim.Checked = False
                            chkfum.Checked = False
                            chkjar.Checked = True
                    End Select
                    chkmto.Enabled = False
                    chklim.Enabled = False
                    chkfum.Enabled = False
                    chkjar.Enabled = False

                    txtidc.Enabled = False
                    txtclave.Enabled = False
                    txtncomercial.Enabled = False
                End If
            End If
            BindGridData()
        End If
    End Sub
    Protected Sub BindGridData()
        Dim sql As String = "select ID_Sucursal,Cte_Dir_No_Surusal, Cte_Dir_Sucursal, Cte_Dir_Cve_Interna, Cte_Dir_Contacto, Cte_Dir_Mail, Cte_Dir_Telefono, "
        sql += " Cte_Dir_Calle+' Col.'+Cte_Dir_Colonia+' CP'+Cte_Dir_CP+' Del.'+ Cte_Dir_Delegacion+' Cd.'+Cte_Dir_Ciudad+' Edo.'+b.estado as Dir,"
        sql += " Cte_Dir_Calle,Cte_Dir_Colonia,Cte_Dir_CP,Cte_Dir_Delegacion,Cte_Dir_Ciudad,cte_dir_Estado,Cte_Dir_Estatus"
        sql += " from Tbl_Cliente_dir a left outer join estados b on "
        sql += " b.id_Estado = a.cte_dir_Estado"
        If IsNumeric(txtidc.Text) Then If txtidc.Text <> 0 Then sql += " where(ID_Cliente = " & txtidc.Text & ")"
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable()
        ds.Fill(dt)
        ViewState("dtsucursal") = dt

        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub
    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Dim dt As DataTable = DirectCast(ViewState("dtsucursal"), DataTable)
        Dim vst As New DataView(dt)
        vst.RowFilter = "ID_Sucursal=" & GridView1.SelectedDataKey("ID_Sucursal") & " "
        txtid.Text = GridView1.SelectedDataKey("ID_Sucursal")
        ddlstatus.SelectedValue = vst.Item(0).Item("Cte_Dir_Estatus")
        txtnsuc.Text = vst.Item(0).Item("Cte_Dir_No_Surusal")
        txtsuc.Text = vst.Item(0).Item("Cte_Dir_Sucursal")
        txtcvei.Text = vst.Item(0).Item("Cte_Dir_Cve_Interna")
        txtcalle.Text = vst.Item(0).Item("Cte_Dir_Calle")
        txtcol.Text = vst.Item(0).Item("Cte_Dir_Colonia")
        txtcp.Text = vst.Item(0).Item("Cte_Dir_CP")
        txtdel.Text = vst.Item(0).Item("Cte_Dir_Delegacion")
        txtcd.Text = vst.Item(0).Item("Cte_Dir_Ciudad")
        ddlestado.SelectedValue = vst.Item(0).Item("cte_dir_Estado")

        txtcon.Text = vst.Item(0).Item("Cte_Dir_Contacto")
        txtmail.Text = vst.Item(0).Item("Cte_Dir_Mail")
        txttel.Text = vst.Item(0).Item("Cte_Dir_Telefono")
        BindGridData()
        'Dim script As String
        'script = "muestra();"
        'ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("OnClick", "oculta('" & GridView1.DataKeys(e.Row.DataItemIndex)("RFC") & "');")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(GridView1, "Select$" & e.Row.RowIndex.ToString())
        End Select
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim Sql As String = ""
        Dim id As Integer = 0
        Dim fecha As Date
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet

        If IsNumeric(txtid.Text) Then
            id = txtid.Text
            Sql = "delete from Tbl_Cliente_Dir_TS where ID_Sucursal=" & txtid.Text & ""
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)

        End If
        If id = 0 Then
            Sql = "Insert into Tbl_Cliente_Dir (ID_Cliente,Cte_Dir_No_Surusal,Cte_Dir_Sucursal,Cte_Dir_Cve_Interna,Cte_Dir_Calle,Cte_Dir_Colonia,Cte_Dir_CP,Cte_Dir_Delegacion,"
            Sql += "Cte_Dir_Ciudad,Cte_Dir_Estado,Cte_Dir_Contacto,Cte_Dir_Mail,Cte_Dir_Telefono,Cte_Dir_Estatus)"
            Sql += " values (" & txtidc.Text & ",'" & txtnsuc.Text & "','" & txtsuc.Text & "','" & txtclave.Text & "','" & txtcalle.Text & "','" & txtcol.Text & "','" & txtcp.Text & "','" & txtdel.Text & "',"
            Sql += "'" & txtcd.Text & "'," & ddlestado.SelectedValue & ",'" & txtcon.Text & "','" & txtmail.Text & "','" & txttel.Text & "',1)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            Sql = "Select max(ID_Sucursal) as idsuc from Tbl_Cliente_Dir "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            txtid.Text = ds.Tables(0).Rows(0).Item("Idsuc")
        Else
            Sql = " update Tbl_Cliente_Dir set ID_Cliente=" & txtidc.Text & ",Cte_Dir_No_Surusal='" & txtnsuc.Text & "',Cte_Dir_Sucursal='" & txtsuc.Text & "',Cte_Dir_Cve_Interna='" & txtclave.Text & "',"
            Sql += " Cte_Dir_Calle='" & txtcalle.Text & "', Cte_Dir_Colonia='" & txtcol.Text & "', Cte_Dir_CP='" & txtcp.Text & "', Cte_Dir_Delegacion='" & txtdel.Text & "',"
            Sql += "Cte_Dir_Ciudad='" & txtcd.Text & "',Cte_Dir_Estado=" & ddlestado.SelectedValue & ",Cte_Dir_Contacto='" & txtcon.Text & "',Cte_Dir_Mail='" & txtmail.Text & "',Cte_Dir_Telefono='" & txttel.Text & "',"
            Sql += " Cte_Dir_Estatus=" & ddlstatus.SelectedValue & ""

            Sql += " where Id_Sucursal  =" & id & ""
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)

        End If
        If chkmto.Checked = True Then
            Sql = "Insert into Tbl_Cliente_Dir_TS (ID_Sucursal, Id_TipoServicio)"
            Sql += " values (" & txtid.Text & ",1)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If
        If chklim.Checked = True Then
            Sql = "Insert into Tbl_Cliente_Dir_TS (ID_Sucursal, Id_TipoServicio)"
            Sql += " values (" & txtid.Text & ",2)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If
        If chkjar.Checked = True Then
            Sql = "Insert into Tbl_Cliente_Dir_TS (ID_Sucursal, Id_TipoServicio)"
            Sql += " values (" & txtid.Text & ",3)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If
        If chkfum.Checked = True Then
            Sql = "Insert into Tbl_Cliente_Dir_TS (ID_Sucursal, Id_TipoServicio)"
            Sql += " values (" & txtid.Text & ",4)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If
        BindGridData()

    End Sub
End Class
