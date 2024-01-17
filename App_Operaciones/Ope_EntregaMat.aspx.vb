Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class App_Operaciones_Ope_EntregaMat
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
                        Response.Redirect("~/App_Operaciones/Ope_EntregaMat.aspx")

                    Case 2
                        Dim Script As String
                        Dim pres, acum As Double
                        pres = txtpres.Text
                        acum = txtacumula.Text
                        If pres < acum Then
                            txtacumula.ForeColor = Drawing.Color.Red
                            txtclavemat.Enabled = False
                            Script = "mensaje(1);"
                            ScriptManager.RegisterStartupScript(Me, GetType(Page), "mensaje()", Script, True)
                            Exit Sub
                        End If


                        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                        dtuhem.TableName = "uhem"
                        Dim ds As New DataSet
                        ds.Tables.Add(dtuhem)
                        Dim strxml As String = ds.GetXml()
                        If myConnection.State = ConnectionState.Closed Then myConnection.Open()
                        Dim cmd As SqlCommand = New SqlCommand("spXMLEntMat", myConnection)
                        cmd.Connection = myConnection
                        cmd.CommandType = CommandType.StoredProcedure
                        cmd.Parameters.Add(New SqlParameter("@XML", SqlDbType.Xml))
                        cmd.Parameters.Add(New SqlParameter("@idcli", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@idsup", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@idsuc", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@pres", SqlDbType.Money))
                        cmd.Parameters.Add(New SqlParameter("@acum", SqlDbType.Money))
                        cmd.Parameters.Add(New SqlParameter("@mes", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@anio", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@implib", SqlDbType.Money))
                        cmd.Parameters.Add(New SqlParameter("@idsur", SqlDbType.Int))
                        cmd.Parameters.Add(New SqlParameter("@idusu", SqlDbType.Int))

                        Dim fol As SqlParameter = cmd.Parameters.Add(New SqlParameter("@idsursal", SqlDbType.Int))

                        cmd.Parameters("@XML").Value = strxml
                        cmd.Parameters("@idcli").Value = lblidcliente.Text
                        cmd.Parameters("@idsup").Value = ddlsupervisor.SelectedValue
                        cmd.Parameters("@idsuc").Value = dllsucursal.SelectedValue
                        cmd.Parameters("@pres").Value = txtpres.Text
                        cmd.Parameters("@acum").Value = txtacumula.Text
                        cmd.Parameters("@mes").Value = ddlmes.SelectedValue
                        cmd.Parameters("@anio").Value = txtAnio.Text
                        cmd.Parameters("@implib").Value = 0
                        cmd.Parameters("@idsur").Value = txtfolio.Text
                        cmd.Parameters("@idusu").Value = Session("v_usuario")

                        cmd.Parameters("@idsursal").Value = 0
                        fol.Direction = ParameterDirection.Output
                        If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                        cmd.ExecuteNonQuery()

                        txtfolio.Text = Int32.Parse(cmd.Parameters("@idsursal").Value.ToString())
                        Script = "mensaje(2);"
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
            ddlsupervisor.DataSource = dt
            ddlsupervisor.DataTextField = "personal"
            ddlsupervisor.DataValueField = "IdPersonal"
            ddlsupervisor.DataBind()
            ddlsupervisor.Items.Add(New ListItem("Seleccione...", 0, True))
            ddlsupervisor.SelectedValue = 0
            txtpres.Text = "$0.00"
            txtAnio.Text = Date.Today.Year
            txtfolio.Text = 0
            ddlmes.SelectedValue = Date.Today.Month
            InitializeDataSource()
            BindGridData(2)
            lblestatus.Text = "Alta"

            If Request("id") <> Nothing Then
                txtfolio.Text = Request("id")
                Sql = " select a.* ,b.Cte_Fis_Razon_Social"
                Sql += " ,case when a.IdEstatus=0 then 'Alta' when a.IdEstatus=1 then 'Autorizado' end estatus"
                Sql += " from Tbl_Ent_Material a inner join Tbl_Cliente b on b.ID_Cliente=a.Idcliente"
                Sql += " where IdSurtido=" & Request("id") & ""
                myCommand = New SqlDataAdapter(Sql, myConnection)
                dt = New DataTable
                myCommand.Fill(dt)
                If dt.Rows.Count > 0 Then
                    lblestatus.Text = dt.Rows(0).Item("Estatus")
                    ddlmes.SelectedValue = dt.Rows(0).Item("Ent_Mat_Mes")
                    txtAnio.Text = dt.Rows(0).Item("Ent_Mat_Anio")
                    txtrs.Text = dt.Rows(0).Item("Cte_Fis_Razon_Social")
                    lblidcliente.Text = dt.Rows(0).Item("Idcliente")
                    ddlsupervisor.SelectedValue = dt.Rows(0).Item("idsupervisor")
                    llenasucursal()
                    dllsucursal.SelectedValue = dt.Rows(0).Item("Id_Sucursal")
                    llenadespuessuc()
                    cargalistado(Request("id"))
                End If
            End If
        End If
    End Sub
    Private Sub InitializeDataSource()
        Dim dtuhem As New DataTable()
        dtuhem.Columns.Add("fila")
        dtuhem.Columns.Add("IdPieza")
        dtuhem.Columns.Add("cve")
        dtuhem.Columns.Add("cvedesp")
        dtuhem.Columns.Add("cantidad", GetType(Double))
        dtuhem.Columns.Add("Costo", GetType(Double))
        dtuhem.Columns.Add("Importe", GetType(Double))
        dtuhem.Columns.Add("tipo")

        dtuhem.Columns("fila").AutoIncrement = True
        dtuhem.Columns("fila").AutoIncrementSeed = 1
        dtuhem.Columns("fila").AutoIncrementStep = 1

        Dim dcuhemKeys As DataColumn() = New DataColumn(0) {}
        dcuhemKeys(0) = dtuhem.Columns("fila")
        dtuhem.PrimaryKey = dcuhemKeys
        ViewState("dtuhem") = dtuhem
    End Sub
    Protected Sub ddlsupervisor_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlsupervisor.SelectedIndexChanged
        If IsNumeric(lblidcliente.Text) Then
            llenasucursal()
        End If
    End Sub
    Protected Sub llenasucursal()
        Dim Sql As String = " select a.id_sucursal, Cte_Dir_No_Surusal+'-'+ Cte_Dir_Sucursal as sucursal"
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

    End Sub
    Protected Sub txtrs_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtrs.TextChanged

    End Sub

    Protected Sub dllsucursal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles dllsucursal.SelectedIndexChanged
        If dllsucursal.SelectedValue <> 0 Then
            llenadespuessuc()
        End If
    End Sub
    Protected Sub llenadespuessuc()
        dllsucursal.Enabled = False
        Dim Sql As String = "  select z.ID_Cliente,z.Cte_Fis_Razon_Social,a.ID_Sucursal,Cte_Dir_Ciudad,isnull(Presupuesto,0)Presupuesto, isnull(c.Ent_Mat_ImporteLib,0) Ent_Mat_ImporteLib"
        Sql += " from Tbl_Cliente z inner join Tbl_Cliente_Dir a  on z.ID_Cliente=a.ID_Cliente"
        Sql += " left outer join Tbl_Cliente_Dir_TS_Presupuesto b on "
        Sql += " b.Id_Sucursal = a.Id_Sucursal And b.Id_TipoServicio = 2"
        Sql += " left outer join Tbl_Ent_Material_Libera c on c.Id_Sucursal=a.ID_Sucursal"
        Sql += " and c.Id_TipoServicio = 2 and c.Ent_Mat_Anio=" & txtAnio.Text & " and c.Ent_Mat_Mes=" & ddlmes.SelectedValue & " "
        Sql += " where a.id_sucursal =" & dllsucursal.SelectedValue & " "
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            lblidcliente.Text = dt.Rows(0).Item("ID_Cliente")
            txtrs.Text = dt.Rows(0).Item("Cte_Fis_Razon_Social")
            txtcd.Text = dt.Rows(0).Item("cte_dir_ciudad")
            txtpres.Text = dt.Rows(0).Item("Presupuesto") + dt.Rows(0).Item("Ent_Mat_ImporteLib")
        End If
        cargalistado(txtfolio.Text)

    End Sub
    Protected Sub btnmat_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnmat.Click
        llenaview(2)
        txtcantidadmat.Text = ""
        Dim script As String
        script = "continuar(4);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        txtrs.Enabled = False
        ddlsupervisor.Enabled = False
        dllsucursal.Enabled = False
        txtcd.Enabled = False
        txtpres.Enabled = False

    End Sub

    Protected Sub llenaview(ByVal val As Integer)
        Select Case val
            Case 2
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    Dim costomat, cant As Double
                    costomat = txtcostomat.Text
                    cant = txtcantidadmat.Text
                    Dim tipo As Integer = 2
                    dt.Rows.Add(Nothing, txtidmat.Text, txtcve.Text, txtdescmat.Text, txtcantidadmat.Text, costomat, costomat * cant, tipo)
                    BindGridData(2)
                    txtclavemat.Text = ""
                    txtcve.Text = ""
                    txtdescmat.Text = ""
                    txtcantidadmat.Text = ""
                    txtcostomat.Text = ""
                End If
        End Select
    End Sub
    Protected Sub cargalistado(ByVal val As Integer)
        InitializeDataSource()


        Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)

        Dim sql As String = " select a.IdSurtido,IdEstatus,b.IdPieza,c.Pza_Clave,c.Pza_DescPieza,b.EM_Cantidad,b.EM_Costo,b.EM_Importe "
        sql += " from Tbl_Ent_Material a left outer join "
        sql += " Tbl_Ent_Mat_Detalle b on b.IdSurtido=a.IdSurtido left outer join "
        sql += " Tbl_Pieza c on c.IdPieza=b.IdPieza"
        If val = 0 Then
            sql += " where a.Id_Sucursal=" & dllsucursal.SelectedValue & " and IdEstatus in(0,1) "
            sql += " and Ent_Mat_Anio=" & txtAnio.Text & " and Ent_Mat_Mes=" & ddlmes.SelectedValue & ""
        Else
            sql += " where a.IdSurtido=" & val & ""
        End If
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dtr As New DataTable
        myCommand.Fill(dtr)
        If dtr.Rows.Count > 0 Then
            txtfolio.Text = dtr.Rows(0)("IdSurtido")
            txtrs.Enabled = False
            ddlsupervisor.Enabled = False
            dllsucursal.Enabled = False
            txtcd.Enabled = False
            txtpres.Enabled = False
            For i As Integer = 0 To dtr.Rows.Count - 1
                dt.Rows.Add(Nothing, dtr.Rows(i)("IdPieza"), dtr.Rows(i)("Pza_Clave"), dtr.Rows(i)("Pza_DescPieza"), dtr.Rows(i)("EM_Cantidad"), dtr.Rows(i)("EM_Costo"), dtr.Rows(i)("EM_Importe"), 2)
            Next
        End If

        BindGridData(2)

    End Sub
    Protected Sub BindGridData(ByVal val As Integer)
        Select Case val
            Case 0
            Case 1
            Case 2
                llenalista()
            Case 3
            Case 4
            Case 5
        End Select
    End Sub
    Protected Sub llenalista()
        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
        Dim vstuhem As New DataView(dtuhem)
        vstuhem.RowFilter = "tipo=2"
        gwm.DataSource = vstuhem
        gwm.DataBind()
        If Not IsDBNull(dtuhem.Compute("Sum(importe)", "tipo =2")) Then txtacumula.Text = "$" & dtuhem.Compute("Sum(importe)", "tipo =2") Else txtacumula.Text = "$0.00"

        Dim pres, acum As Double
        pres = txtpres.Text
        acum = txtacumula.Text
        If pres < acum Then
            txtacumula.ForeColor = Drawing.Color.Red
            txtclavemat.Enabled = False
            Dim Script As String = "mensaje(1);"
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "mensaje()", Script, True)
        Else
            txtclavemat.Enabled = True

            txtacumula.ForeColor = Drawing.Color.Blue
        End If
    End Sub
    Protected Sub gwm_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwm.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gwm.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            Select Case gwm.SelectedDataKey("tipo")
                Case 2
                    BindGridData(2)
            End Select
        End If

    End Sub

End Class
