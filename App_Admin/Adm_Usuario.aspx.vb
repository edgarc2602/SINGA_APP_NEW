Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Admin_Adm_Usuario
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
        Select Case Request.Params("__EVENTTARGET")
            Case "guarda"
                guarda()
            Case "elimina"
                elimina()
        End Select
        If Not Page.IsPostBack Then


            Dim Sql As String = "SELECT IdArea, Ar_Nombre, Ar_Descripcion, Ar_Posicion, ar_Estatus FROM tbl_area_Empresa WHERE ar_Estatus=0"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim ds As New DataTable
            myCommand.Fill(ds)
            ddlarea.DataSource = ds
            ddlarea.DataTextField = "Ar_Nombre"
            ddlarea.DataValueField = "Idarea"
            ddlarea.DataBind()
            ddlarea.Items.Add(New ListItem("Sel.-Area...", 0, True))
            ddlarea.SelectedValue = 0
            Sql = "select id_puesto,Cve_Puesto +' '+Pue_Puesto as puesto from Tbl_Puesto where Pue_Estatus=0"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
            ddlpuesto.DataSource = ds
            ddlpuesto.DataTextField = "puesto"
            ddlpuesto.DataValueField = "id_puesto"
            ddlpuesto.DataBind()
            ddlpuesto.Items.Add(New ListItem("Sel.-puesto...", 0, True))
            ddlpuesto.SelectedValue = 0
            Sql = "Select IdGrupos,Gr_Nombre from Tbl_Per_Grupos where gr_status=0 "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
            ddlgrupo.DataSource = ds
            ddlgrupo.DataTextField = "Gr_Nombre"
            ddlgrupo.DataValueField = "IdGrupos"
            ddlgrupo.DataBind()
            ddlgrupo.Items.Add(New ListItem("Sel.-grupo de privilegios...", 0, True))
            ddlgrupo.SelectedValue = 0
            llenausuarios()
        End If
    End Sub
    Protected Sub guarda()
        Dim sql As String
        If Not IsNumeric(txtid.Text) Then
            sql = "Insert into Personal (per_paterno, per_materno, per_nombre, per_puesto, per_usuario,"
            sql += " per_password, idarea,Per_Email,Fecha_Alta,per_elabora,per_revisa,per_autoriza,per_status,Per_Interno,ID_Puesto) values ("
            sql += " '" & txtap.Text & "','" & txtam.Text & "', '" & txtnom.Text & "', '" & ddlpuesto.SelectedItem.Text & "',"
            sql += " '" & txtusuario.Text & "','" & txtpass.Text & "', " & ddlarea.SelectedValue & ",'" & Trim(txtemail.Text) & "','" & Date.Today & "',"
            If chkelabora.Checked = True Then sql += " 1," Else sql += " 0,"
            If chkrevisa.Checked = True Then sql += " 1," Else sql += " 0,"
            If chkautoriza.Checked = True Then sql += " 1," Else sql += " 0,"
            sql += " " & ddlestatus.SelectedValue & "," & ddltipo.SelectedValue & "," & ddlpuesto.SelectedValue & ")"
        Else
            sql = "update Personal set per_paterno='" & txtap.Text & "', per_materno='" & txtam.Text & "', per_nombre='" & txtnom.Text & "', "
            sql += " per_puesto='" & ddlpuesto.SelectedItem.Text & "', per_usuario='" & txtusuario.Text & "', "
            sql += " per_password='" & txtpass.Text & "', idarea= " & ddlarea.SelectedValue & ",Per_Email='" & Trim(txtemail.Text) & "',"
            sql += " per_status=" & ddlestatus.SelectedValue & ",Per_Interno=" & ddltipo.SelectedValue & ", ID_Puesto=" & ddlpuesto.SelectedValue & ""
            If chkelabora.Checked = True Then sql += ",per_elabora= 1" Else sql += ",per_elabora= 0"
            If chkrevisa.Checked = True Then sql += ",per_revisa= 1" Else sql += ",per_revisa= 0"
            If chkautoriza.Checked = True Then sql += ",per_autoriza= 1" Else sql += ",per_autoriza=0"
            sql += " where IdPersonal=" & txtid.Text & ""
        End If
        Dim Mycommand1 As New SqlCommand(Sql, myConnection)
        myConnection.Open()
        Mycommand1.ExecuteNonQuery()
        myConnection.Close()
        If Not IsNumeric(txtid.Text) Then
            sql = "Select max(IdPersonal) as folio from Personal"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim ds As New DataSet
            myCommand.Fill(ds)
            If ds.Tables(0).Rows.Count > 0 Then
                txtid.Text = ds.Tables(0).Rows(0)("Folio")
            End If

        End If
        If ddlgrupo.SelectedValue <> 0 Then
            sql = "Delete from tbl_UsuarioGrupos where idpersonal=" & txtid.Text & ""
            Dim myCommandg As New SqlDataAdapter(sql, myConnection)
            Dim dsg As New DataTable
            myCommandg.Fill(dsg)
            sql = "Insert into tbl_UsuarioGrupos (idpersonal,idgrupos) values (" & txtid.Text & "," & ddlgrupo.SelectedValue & ") "
            myCommandg = New SqlDataAdapter(sql, myConnection)
            dsg = New DataTable
            myCommandg.Fill(dsg)
        End If

        llenausuarios()
        Response.Write("<script>alert('Registro Almacenado. Este Password es su firma electrònica, la cual es personal, confidencial e intransferible y tiene validez como firma autògrafa. Al dar de alta este password, usted acepta que usara dicha clave bajo su responsabilidad.');</script>")

    End Sub
    Protected Sub elimina()

    End Sub
    Protected Sub llenausuarios()
        Dim sql = " SELECT  idpersonal, Per_Paterno+' '+Per_Materno	+' '+ Per_Nombre as Personal, Per_Puesto,per_usuario,Fecha_Alta"
        sql += " , case when per_status = 0 then 'Activo' when per_status = 1 then 'Suspendido' end estatus fROM Personal where per_status in(0,1)"
        Dim myCommandg As New SqlDataAdapter(sql, myConnection)
        Dim dsg As New DataTable
        myCommandg.Fill(dsg)
        GridView1.DataSource = dsg
        GridView1.DataBind()
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
    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Dim sql As String = "Select isnull(IdGrupos,0) as idgrupo,a.* FROM Personal a left outer join tbl_UsuarioGrupos b on a.IdPersonal=b.IdPersonal"
        sql += " where a.IdPersonal=" & GridView1.SelectedDataKey("IdPersonal") & " "
        Dim myCommandg As New SqlDataAdapter(sql, myConnection)
        Dim dsg As New DataTable
        myCommandg.Fill(dsg)
        If dsg.Rows.Count > 0 Then
            txtid.Text = dsg.Rows(0).Item("IdPersonal")
            ddlestatus.SelectedValue = dsg.Rows(0).Item("per_status")
            txtap.Text = dsg.Rows(0).Item("Per_Paterno")
            txtam.Text = dsg.Rows(0).Item("Per_Materno")
            txtnom.Text = dsg.Rows(0).Item("Per_Nombre")
            txtemail.Text = dsg.Rows(0).Item("Per_Email")
            ddltipo.SelectedValue = dsg.Rows(0).Item("per_Interno")
            txtusuario.Text = dsg.Rows(0).Item("per_usuario")
            txtpass.Text = dsg.Rows(0).Item("per_password")
            txtpass.Attributes.Add("value", dsg.Rows(0).Item("per_password"))
            txtpasscon.Text = dsg.Rows(0).Item("per_password")
            txtpasscon.Attributes.Add("value", dsg.Rows(0).Item("per_password"))
            ddlarea.SelectedValue = dsg.Rows(0).Item("IdArea")
            ddlgrupo.SelectedValue = dsg.Rows(0).Item("idgrupo")
            If IsDBNull(dsg.Rows(0).Item("ID_Puesto")) Then ddlpuesto.SelectedValue = 0 Else ddlpuesto.SelectedValue = dsg.Rows(0).Item("ID_Puesto")
            If dsg.Rows(0).Item("per_elabora") = True Then chkelabora.Checked = True Else chkelabora.Checked = False
            If dsg.Rows(0).Item("per_revisa") = True Then chkrevisa.Checked = True Else chkrevisa.Checked = False
            If dsg.Rows(0).Item("per_autoriza") = True Then chkautoriza.Checked = True Else chkautoriza.Checked = False

        End If

        Dim script As String
        script = "continuar(4);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub

End Class
