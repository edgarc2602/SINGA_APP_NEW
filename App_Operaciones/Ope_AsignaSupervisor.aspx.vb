Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class App_Operaciones_Ope_AsignaSupervisor
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
            Case "completadatos"
                Select Case Request.Params("__eventargument")
                    Case 0
                End Select
            Case "opcion"
                Select Case Request.Params("__eventargument")
                    Case 0, 1, 2
                        Select Case Request.Params("__eventargument")
                            Case 0, 2
                                CheckBox1.Checked = False
                            Case Else
                                CheckBox1.Checked = True
                        End Select
                        Dim sql As String = ""
                        sql = "Select a.ID_Sucursal,a.ID_Cliente,c.Estado,Cte_Dir_No_Surusal as No_Sucursal,Cte_Dir_Sucursal as Sucursal,isNull(Per_Paterno+' '+Per_Nombre,'SIN ASIGNAR') as Supervisor"
                        sql += " from Tbl_Cliente_Dir a inner join Tbl_Cliente_Dir_TS b on b.ID_Sucursal=a.ID_Sucursal"
                        sql += " inner join Estados c on c.Id_Estado=a.Cte_Dir_Estado"
                        sql += " left outer join Tbl_Cliente_Dir_Supervisor d on d.ID_Sucursal=a.ID_Sucursal and d.ID_Cliente=a.ID_Cliente"
                        sql += " left outer join Personal e on e.IdPersonal=d.IdPersonal"
                        sql += " where b.Id_TipoServicio = 2 And a.ID_Cliente = " & lblidcliente.Text & " And Cte_Dir_Estatus = 1"
                        sql += " order by Estado,Cte_Dir_No_Surusal"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        If dt.Rows.Count > 0 Then
                            gwsuc.DataSource = dt
                            gwsuc.DataBind()
                        End If
                    Case 3
                        Dim idsuc As String = "0"
                        For i As Integer = 0 To gwsuc.Rows.Count - 1
                            Dim chk As New CheckBox
                            chk = gwsuc.Rows(i).Cells(0).Controls(0)
                            If chk.Checked = True Then
                                idsuc += "," & gwsuc.DataKeys(i).Item("ID_Sucursal") & ""
                            End If
                        Next
                        Dim sql As String = ""
                        sql = "Delete from Tbl_Cliente_Dir_Supervisor where ID_Sucursal in(" & idsuc & ")"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)

                        sql = "Delete from Tbl_Cliente_Dir_Supervisor where ID_Sucursal in(" & idsuc & ")"
                        myCommand = New SqlDataAdapter(sql, myConnection)
                        dt = New DataTable
                        myCommand.Fill(dt)
                        If ddlsupervisor.SelectedValue <> 0 Then
                            sql = "insert into Tbl_Cliente_Dir_Supervisor "
                            sql += " select ID_Sucursal,ID_Cliente," & ddlsupervisor.SelectedValue & " from Tbl_Cliente_Dir"
                            sql += " where ID_Sucursal in(" & idsuc & ")"
                            myCommand = New SqlDataAdapter(sql, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                        End If
                End Select
        End Select
        If Not IsPostBack Then
            lblidcliente.Text = "0"
            Dim Sql As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            Sql += " FROM Personal where per_status=0 and IdArea=3 and Per_Puesto like '%Supervis%'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            ddlsupervisor.DataSource = dt
            ddlsupervisor.DataTextField = "personal"
            ddlsupervisor.DataValueField = "IdPersonal"
            ddlsupervisor.DataBind()
            ddlsupervisor.Items.Add(New ListItem("Sin Asignar", 0, True))
            ddlsupervisor.SelectedValue = 0

        End If
    End Sub

    Protected Sub txtrs_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtrs.TextChanged
        Dim sql As String = ""
        sql = "select ID_Cliente from Tbl_Cliente where Cte_Fis_Razon_Social like '%" & Trim(txtrs.Text) & "%'"
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            lblidcliente.Text = dt.Rows(0).Item("ID_Cliente")
        Else
            lblidcliente.Text = 0
        End If
    End Sub

    Protected Sub gwsuc_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gwsuc.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim chk As New CheckBox
            chk.ID = "ctlchk" & "-" & gwsuc.DataKeys(e.Row.DataItemIndex)("ID_Sucursal")
            If CheckBox1.Checked = True Then
                chk.Checked = True
            Else
                chk.Checked = False
            End If
            e.Row.Cells(0).Controls.Add(chk)
        End If

    End Sub

    Protected Sub gwsuc_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwsuc.SelectedIndexChanged

    End Sub
End Class
