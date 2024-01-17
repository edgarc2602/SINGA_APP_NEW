Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class App_Operaciones_Ope_EntregaMat_Libera
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
                        Response.Redirect("~/App_Operaciones/Ope_EntregaMat_Libera.aspx")

                    Case 2
                        Dim importe As Double = txtliberar.Text
                        Dim Sql As String = "  select * from Tbl_Ent_Material_Libera "
                        Sql += " where Id_TipoServicio = 2 And Ent_Mat_Anio = " & txtAnio.Text & " And Ent_Mat_Mes = " & ddlmes.SelectedValue & " And Id_Sucursal=" & dllsucursal.SelectedValue & ""
                        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        If dt.Rows.Count > 0 Then
                            Sql = "Update Tbl_Ent_Material_Libera set Ent_Mat_ImporteLib=" & importe & " , Idlibera=" & Session("v_usuario") & " , Fecha='" & Date.Today & " " & Now.ToString("HH:mm:ss") & "'"
                            Sql += " where Id_TipoServicio = 2 And Ent_Mat_Anio = " & txtAnio.Text & " And Ent_Mat_Mes = " & ddlmes.SelectedValue & " And Id_Sucursal=" & dllsucursal.SelectedValue & ""
                            myCommand = New SqlDataAdapter(Sql, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                        Else
                            Sql = "insert into Tbl_Ent_Material_Libera select " & dllsucursal.SelectedValue & "," & ddlmes.SelectedValue & "," & txtAnio.Text & "," & importe & "," & Session("v_usuario") & ",2,'" & Date.Today & " " & Now.ToString("HH:mm:ss") & "'"
                            myCommand = New SqlDataAdapter(Sql, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                        End If
                        Dim msg As String = "Se ha agregado correctamente el importe al presupuesto"
                        Dim Script As String = "mensaje('" & msg & "');"
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)

                End Select

        End Select



        If Not IsPostBack Then
            lblidcliente.Text = "0"
            Dim Sql As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            Sql += " FROM Personal where per_status=0 and IdArea=3 and Per_Puesto like '%Supervis%'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            txtpres.Text = "$0.00"
            txtAnio.Text = Date.Today.Year
            txtliberar.Text = "$0.00"
            ddlmes.SelectedValue = Date.Today.Month
        End If
    End Sub

    Protected Sub txtrs_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtrs.TextChanged
        If IsNumeric(lblidcliente.Text) Then
            Dim Sql As String = " select a.id_sucursal, Cte_Dir_No_Surusal+'-'+ Cte_Dir_Sucursal as sucursal"
            Sql += " from Tbl_Cliente_Dir a inner join "
            Sql += " Tbl_Cliente_Dir_Supervisor b on a.ID_Sucursal=b.ID_Sucursal"
            Sql += " and a.ID_Cliente=b.ID_Cliente "
            Sql += " inner join Tbl_Cliente c on c.ID_Cliente=b.ID_Cliente and Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
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

    Protected Sub dllsucursal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dllsucursal.SelectedIndexChanged
        If dllsucursal.SelectedValue <> 0 Then
            dllsucursal.Enabled = False
            Dim Sql As String = "  select Cte_Dir_Ciudad,isnull(Presupuesto,0)Presupuesto, isnull(c.Ent_Mat_ImporteLib,0) Ent_Mat_ImporteLib"
            Sql += " from Tbl_Cliente_Dir a left outer join Tbl_Cliente_Dir_TS_Presupuesto b on "
            Sql += " b.Id_Sucursal = a.Id_Sucursal And b.Id_TipoServicio = 2"
            Sql += " left outer join Tbl_Ent_Material_Libera c on c.Id_Sucursal=a.ID_Sucursal"
            Sql += " and c.Id_TipoServicio = 2 and c.Ent_Mat_Anio=" & txtAnio.Text & " and c.Ent_Mat_Mes=" & ddlmes.SelectedValue & " "
            Sql += " where a.id_sucursal =" & dllsucursal.SelectedValue & " "

            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                txtcd.Text = dt.Rows(0).Item("cte_dir_ciudad")
                If Not IsDBNull(dt.Rows(0).Item("Presupuesto")) Then txtpres.Text = dt.Rows(0).Item("Presupuesto")
                txtliberar.Text = dt.Rows(0).Item("Ent_Mat_ImporteLib")
            End If
        End If

    End Sub
End Class
