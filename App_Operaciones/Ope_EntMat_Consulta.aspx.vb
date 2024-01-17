Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class App_Operaciones_Ope_EntMat_Consulta
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
            Case "opcion"
                Select Case Request.Params("__eventargument")
                    Case 1
                        Dim idlistado As String = "0"
                        For i As Integer = 0 To gwm.Rows.Count - 1
                            Dim chk As New CheckBox
                            chk = gwm.Rows(i).Cells(0).Controls(0)
                            If chk.Checked = True Then
                                idlistado += "," & gwm.DataKeys(i).Item("IdSurtido") & ""
                            End If
                        Next
                        Dim sql As String = ""
                        sql = "update Tbl_Ent_Material set IdEstatus=1 where IdSurtido in(" & idlistado & ")"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        llenagrid()
                    Case 2
                        Dim idlistado As String = "0"
                        For i As Integer = 0 To gwm.Rows.Count - 1
                            Dim chk As New CheckBox
                            chk = gwm.Rows(i).Cells(0).Controls(0)
                            If chk.Checked = True Then
                                idlistado += "," & gwm.DataKeys(i).Item("IdSurtido") & ""
                            End If
                        Next
                        Dim sql As String = ""
                        sql = "update Tbl_Ent_Material set IdEstatus=0 where IdSurtido in(" & idlistado & ")"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        llenagrid()
                    Case 3
                        Dim idlistado As String = "0"
                        For i As Integer = 0 To gwm.Rows.Count - 1
                            Dim chk As New CheckBox
                            chk = gwm.Rows(i).Cells(0).Controls(0)
                            If chk.Checked = True Then
                                idlistado += "," & gwm.DataKeys(i).Item("IdSurtido") & ""
                            End If
                        Next
                        Dim sql As String = ""
                        sql = "update Tbl_Ent_Material set IdEstatus=3 where IdSurtido in(" & idlistado & ")"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        llenagrid()
                    Case 4
                        Dim idlistado As String = "0"
                        For i As Integer = 0 To gwm.Rows.Count - 1
                            Dim chk As New CheckBox
                            chk = gwm.Rows(i).Cells(0).Controls(0)
                            If chk.Checked = True Then
                                idlistado += "," & gwm.DataKeys(i).Item("IdSurtido") & ""
                            End If
                        Next
                        Dim sql As String = ""
                        sql = "select d.PzaF_DescFamilia as Familia,c.Pza_Clave as Clave,c.Pza_DescPieza as Descripcion,c.Pza_IdUnidad as UM,sum(em_cantidad) as Cantidad,SUM(b.EM_Importe)as Importe"
                        sql += " from Tbl_Ent_Material a inner join Tbl_Ent_Mat_Detalle b on a.IdSurtido=b.IdSurtido"
                        sql += " inner join Tbl_Pieza c on c.IdPieza=b.IdPieza inner join Tbl_Pza_Familia d on d.IdFamilia=c.Pza_IdFamilia"
                        sql += " where a.IdSurtido In( " & idlistado & ")"
                        sql += "  group by c.Pza_Clave,c.Pza_DescPieza,c.Pza_IdUnidad,d.PzaF_DescFamilia"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        Dim grid As New GridView
                        Dim nombre As String = txtAnio.Text & "_" & ddlmes.SelectedItem.Text
                        If txtrs.Text <> "" Then nombre += "-" & txtrs.Text
                        If ddlsupervisor.SelectedValue <> 0 Then nombre += "-" & ddlsupervisor.SelectedItem.Text
                        If dllsucursal.Items.Count > 0 Then If dllsucursal.SelectedValue <> "0" Then nombre += "-" & dllsucursal.SelectedItem.Text
                        If txtfolio.Text <> "" Then nombre += "-" & txtfolio.Text

                        grid.Caption = nombre
                        grid.AutoGenerateColumns = True
                        grid.DataSource = dt
                        grid.DataBind()
                        ExportToExcel("" & nombre & ".xls", grid)
                End Select

        End Select



        If Not IsPostBack Then
            lblidcliente.Text = "0"
            txtAnio.Text = Date.Today.Year
            ddlmes.SelectedValue = Date.Today.Month
            Dim Sql As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            Sql += " FROM Personal where per_status=0 and IdArea=3 and Per_Puesto like '%Supervis%'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            ddlsupervisor.DataSource = dt
            ddlsupervisor.DataTextField = "personal"
            ddlsupervisor.DataValueField = "IdPersonal"
            ddlsupervisor.DataBind()
            ddlsupervisor.Items.Add(New ListItem("Seleccione...", 0, True))
            ddlsupervisor.SelectedValue = 0
        End If
    End Sub
    Protected Sub llenagrid()

        Dim sql As String = "select a.Id_Sucursal,d.IdPersonal,a.IdEstatus,c.Cte_Fis_Nombre_Comercial,b.Cte_Dir_Ciudad,b.Cte_Dir_Sucursal,convert(nvarchar(4),a.Ent_Mat_Anio)+'/'+convert(nvarchar(3),a.Ent_Mat_mes) as mes,a.IdSurtido"
        sql += " ,Ent_Mat_Presupuesto,Ent_Mat_ImporteLib,Ent_Mat_Acumulado,Ent_Mat_FechaAlta"
        sql += " ,case when a.IdEstatus=0 then 'Alta' when a.IdEstatus=1 then 'Autorizado' when a.IdEstatus=2 then 'Surtido' when a.IdEstatus=3 then 'Cancelado' end estatus"
        sql += " from Tbl_Ent_Material a inner join Tbl_Cliente_Dir b on a.Id_Sucursal=b.ID_Sucursal"
        sql += " inner join Tbl_Cliente c on c.ID_Cliente=a.Idcliente"
        sql += " inner join Tbl_Cliente_Dir_Supervisor d on d.ID_Sucursal=a.Id_Sucursal"
        sql += " where a.IdEstatus<> 10"
        If IsNumeric(txtAnio.Text) Then sql += " and Ent_Mat_Anio =" & txtAnio.Text & ""
        If ddlmes.SelectedValue <> 0 Then sql += " and Ent_Mat_mes =" & ddlmes.SelectedValue & ""
        If lblidcliente.Text <> 0 Then sql += " and c.ID_Cliente =" & lblidcliente.Text & ""
        If ddlsupervisor.SelectedValue <> 0 Then sql += " and IdPersonal =" & ddlsupervisor.SelectedValue & ""
        If dllsucursal.Items.Count > 0 Then
            If dllsucursal.SelectedValue <> 0 Then sql += " and a.Id_Sucursal =" & dllsucursal.SelectedValue & ""
        End If
        If IsNumeric(txtfolio.Text) Then sql += " and a.IdSurtido =" & txtfolio.Text & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dtr As New DataTable
        myCommand.Fill(dtr)

        gwm.DataSource = dtr
        gwm.DataBind()

    End Sub
    Protected Sub txtrs_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtrs.TextChanged
        If Trim(txtrs.Text) <> "" Then
            Dim Sql As String = " select * from Tbl_Cliente where Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                lblidcliente.Text = dt.Rows(0).Item("ID_Cliente")
            Else
                lblidcliente.Text = 0
            End If
        End If
    End Sub

    Protected Sub ddlsupervisor_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlsupervisor.SelectedIndexChanged
        If IsNumeric(lblidcliente.Text) Then
            Dim Sql As String = " select a.id_sucursal, Cte_Dir_No_Surusal+'-'+ Cte_Dir_Sucursal as sucursal,"

            Sql += " (select sum(costomes) as costomes from ("
            Sql += " select a.ID_Cotizacion,a.Cot_Version, case when Cot_MHES_idfrecuencia=0 then 0 "
            Sql += " else(b.Cot_MHES_cantidad*b.Cot_MHES_Costo)/Cot_MHES_idfrecuencia end costomes"
            Sql += " from Tbl_Cotizacion a inner join Tbl_Cot_MatHerEqpSE b "
            Sql += " on b.ID_Cotizacion=a.ID_Cotizacion and b.Cot_Version=a.Cot_Version "
            '--and Cot_MHES_tipo=2"
            Sql += " where(a.Cot_Tipo = 1 And a.Cot_Estatus = 1 And a.Cot_Id_TipoServicio = 2 And a.Cot_Id = c.ID_Cliente)"
            Sql += " ) as res group by ID_Cotizacion,Cot_Version) costomes"


            Sql += " from Tbl_Cliente_Dir a inner join "
            Sql += " Tbl_Cliente_Dir_Supervisor b on a.ID_Sucursal=b.ID_Sucursal"
            Sql += " and a.ID_Cliente=b.ID_Cliente "
            Sql += " inner join Tbl_Cliente c on c.ID_Cliente=b.ID_Cliente and Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
            Sql += " where IdPersonal =" & ddlsupervisor.SelectedValue & " "
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            dllsucursal.DataSource = dt
            dllsucursal.DataTextField = "sucursal"
            dllsucursal.DataValueField = "id_sucursal"
            dllsucursal.DataBind()
            dllsucursal.Items.Add(New ListItem("Sucursal...", 0, True))
            dllsucursal.SelectedValue = 0
            'If dt.Rows.Count > 0 Then txtpres.Text = dt.Rows(0).Item("costomes")
        End If
    End Sub

    Protected Sub gwm_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gwm.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim chk As New CheckBox
            chk.ID = "ctlchk" & "-" & gwm.DataKeys(e.Row.DataItemIndex)("IdSurtido")
            If CheckBox1.Checked = True Then
                chk.Checked = True
            Else
                chk.Checked = False
            End If
            e.Row.Cells(0).Controls.Add(chk)
        End If

    End Sub

    Protected Sub CheckBox1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked = True Then
            CheckBox1.Text = "Quitar marca a todos los Listados"
        Else
            CheckBox1.Text = "Selecciona Todos los Listados"
        End If
        If gwm.Rows.Count > 0 Then llenagrid()
    End Sub

    Protected Sub gwm_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwm.SelectedIndexChanged
        Response.Redirect("~/App_Operaciones/Ope_EntregaMat.aspx?id=" & gwm.SelectedDataKey("IdSurtido") & "")
    End Sub

    Protected Sub btnmat_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnmat.Click
        llenagrid()
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
End Class
