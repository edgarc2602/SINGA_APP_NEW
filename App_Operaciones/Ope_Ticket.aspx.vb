Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Operaciones_Ope_Ticket
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
            Case "completadatos"
                Select Case Request.Params("__eventargument")
                    Case 0
                    Case 1
                    Case 2
                    Case 3
                End Select
            Case "guarda"
                Select Case Request.Params("__eventargument")
                    Case 0
                        Dim sql As String = " select * from Tbl_tk_CausaOrigen where Tk_CuaOri_Descripcion ='" & txtcatcauori.Text & "'"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        If dt.Rows.Count = 0 Then
                            sql = " insert into Tbl_tk_CausaOrigen (Tk_CuaOri_Descripcion) values ('" & txtcatcauori.Text & "')"
                            myCommand = New SqlDataAdapter(sql, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                            ' Response.Write("<script>alert('Se a agregado correctamente la Causa/Origen');</script>")
                        Else
                            'Response.Write("<script>alert('Validacion! La Causa/Origen ya existe verifique.');</script>")
                        End If
                        txtcauori.Text = ""
                        txtcatcauori.Text = ""
                    Case 1
                        Dim sql As String = " select * from Tbl_tk_Incidencia where Tk_Inc_Descripcion ='" & txtcatincidencia.Text & "'"
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)
                        If dt.Rows.Count = 0 Then
                            sql = " insert into Tbl_tk_Incidencia (Tk_Inc_Descripcion, ID_Area) values ('" & txtcatincidencia.Text & "'," & ddlcatarearesp.SelectedValue & ")"
                            myCommand = New SqlDataAdapter(sql, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                            ' Response.Write("<script>alert('Se a agregado correctamente la Causa/Origen');</script>")
                        Else
                            'Response.Write("<script>alert('Validacion! La Causa/Origen ya existe verifique.');</script>")
                        End If
                        txtincidencia.Text = ""
                        txtcatincidencia.Text = ""
                        ddlcatarearesp.SelectedValue = 0

                    Case 2
                        Dim fecha As Date = txtfechaalta.Text & " " & txthralta.Text
                        Dim sql As String = ""
                        Dim sqlr As String = ""
                        Dim fechasis As String = Format(Date.Today, "dd/MM/yyyy")
                        Dim hora As String = Now.ToString("HH:mm:ss")
                        Dim fecalta As String = Format(fecha, "dd/MM/yyyy")
                        Dim horaalta As String = Format(fecha, "HH:mm:ss")
                        Dim mensajebit As String = ""
                        'ListBox1.SelectedValue
                        Dim arearesp As String = ""
                        For i = 0 To ListBox1.Items.Count - 1
                            Dim ar As Array = ListBox1.Items(i).Text.Split("|")
                            If arearesp = "" Then arearesp = ar(0) Else arearesp += "," & ar(0)
                        Next
                        If txtid.Text = "" Then
                            If lblidpa.Text = "" Then
                                lblidpa.Text = 0
                            End If
                            sql = "insert into Tbl_Ticket ( No_Ticket, Tk_Folio, Tk_Estatus,Tk_Fechasistema, Tk_FechaAlta, Tk_HoraAlta, Tk_FechaTermino, Tk_HoraTermino, Tk_MesServicio, ID_Servicio, ID_Ambito, ID_Cliente, ID_Sucursal, sucursal, "
                            sql += " ID_Incidencia, ID_CausaOrigen, IdArea, Tk_Descripcion, Tk_Accion_Correctiva, Tk_Accion_Preventiva, Tk_Reporta, Tk_ID_Ejecutivo,Tk_ID_Responsable,ID_Estado,Id_Gerente)"
                            sql += " select isnull(max(no_ticket),0)+1,(select cte_fis_clave_cliente from Tbl_Cliente where id_cliente=" & lblidrs.Text & ")+'-'+CONVERT(nvarchar(10),isnull(max(no_ticket),0)+1), "
                            sql += " " & ddlstatus.SelectedValue & ", '" & fechasis & " " & hora & "','" & fecalta & "', '" & horaalta & "', NULL, NULL, " & ddlmes.SelectedValue & ", " & ddlservicio.SelectedValue & ", " & ddlambito.SelectedValue & ", " & lblidrs.Text & ", " & lblidpa.Text & ", '" & txtpa.Text & "',"
                            sql += " " & lblidincidencia.Text & ", " & lblidco.Text & ", '" & arearesp & "', '" & txtdescripcion.Text & "', '" & txtac.Text & "', '" & txtap.Text & "', '" & txtreporta.Text & "', " & ddlejecutivo.SelectedValue & ",0, " & ddlestadoalta.SelectedValue & "," & ddlgerente.SelectedValue & ""
                            sql += "  from Tbl_Ticket"

                            sqlr = "select * from Tbl_Ticket where ID_Ticket=(select isnull(max(ID_Ticket),0) as id from Tbl_Ticket)"
                            mensajebit = "Alta de Ticket"
                        Else
                            sql = "Update Tbl_Ticket set Tk_Estatus=" & ddlstatus.SelectedValue & ", Tk_FechaAlta='" & fecalta & "', Tk_HoraAlta='" & horaalta & "', "
                            Select Case ddlstatus.SelectedValue
                                Case 2, 3
                                    Dim fechater As Date = txtfecter.Text & " " & txthrter.Text
                                    Dim fecter As String = Format(fechater, "dd/MM/yyyy")
                                    Dim horater As String = Format(fechater, "HH:mm:ss")
                                    sql += " Tk_FechaTermino='" & fecter & "', Tk_HoraTermino='" & horater & "',"
                            End Select
                            sql += " Tk_MesServicio=" & ddlmes.SelectedValue & ", ID_Servicio=" & ddlservicio.SelectedValue & ", ID_Ambito= " & ddlambito.SelectedValue & ", "
                            sql += " ID_Sucursal=" & lblidpa.Text & ",sucursal='" & txtpa.Text & "',ID_Incidencia=" & lblidincidencia.Text & ",ID_CausaOrigen=" & lblidco.Text & ","
                            sql += " IdArea=  '" & arearesp & "', Tk_Descripcion='" & txtdescripcion.Text & "',Tk_Accion_Correctiva= '" & txtac.Text & "'"
                            sql += " , Tk_Accion_Preventiva='" & txtap.Text & "', Tk_Reporta='" & txtreporta.Text & "', Tk_ID_Ejecutivo=" & ddlejecutivo.SelectedValue & ",Tk_ID_Responsable=0"
                            sql += " ,ID_Estado = " & ddlestadoalta.SelectedValue & ",Id_Gerente=" & ddlgerente.SelectedValue & " where ID_Ticket=" & lblidticket.Text & ""


                            mensajebit = "Modificacion de Ticket"

                            Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                            dtuhem.TableName = "mat"
                            Dim dsmat As New DataSet
                            dsmat.Tables.Add(dtuhem)
                            Dim strxml As String = dsmat.GetXml()

                            Dim cmd As SqlCommand = New SqlCommand("spXMLtkMat", myConnection)
                            cmd.Connection = myConnection
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add(New SqlParameter("@XML", SqlDbType.Xml))
                            cmd.Parameters.Add(New SqlParameter("@idusu", SqlDbType.Int))
                            cmd.Parameters.Add(New SqlParameter("@id_tk", SqlDbType.Int))

                            cmd.Parameters("@XML").Value = strxml
                            cmd.Parameters("@idusu").Value = Session("v_usuario")
                            cmd.Parameters("@id_tk").Value = lblidticket.Text

                            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
                            cmd.ExecuteNonQuery()


                            sqlr = "select * from Tbl_Ticket where ID_Ticket=" & lblidticket.Text & ""
                        End If
                        Dim myCommand As New SqlDataAdapter(sql, myConnection)
                        Dim dt As New DataTable
                        myCommand.Fill(dt)


                        If sqlr <> "" Then
                            myCommand = New SqlDataAdapter(sqlr, myConnection)
                            dt = New DataTable
                            myCommand.Fill(dt)
                            If dt.Rows.Count > 0 Then
                                lblidticket.Text = dt.Rows(0).Item("ID_Ticket")
                                txtid.Text = dt.Rows(0).Item("No_Ticket")
                                txtfolio.Text = dt.Rows(0).Item("Tk_Folio")
                            End If
                        End If

                        grababitacora(lblidticket.Text, fechasis, hora, mensajebit, ddlarearesp.SelectedValue, ddlejecutivo.SelectedValue, ddlestado.SelectedValue, Session("v_usuario"))

                        llenaticket(lblidticket.Text)
                End Select
        End Select
        'Session("v_usuario") = 1
        If Not IsPostBack Then
            InitializeDataSource()
            Dim fecha As String = Date.Today
            Dim hora As String = Now.ToString("HH:mm:ss")
            lblfecha.Text = fecha & " " & hora
            'txtfechaalta.Text = fecha & " " & hora
            txtfechaalta.Text = fecha
            txthralta.Text = hora

            ddlmes.SelectedValue = Date.Today.Month
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

            ddlcatarearesp.DataSource = dt
            ddlcatarearesp.DataTextField = "Ar_Nombre"
            ddlcatarearesp.DataValueField = "IdArea"
            ddlcatarearesp.DataBind()
            ddlcatarearesp.Items.Add(New ListItem("Sel. el area...", 0, True))
            ddlcatarearesp.SelectedValue = 0


            sql = "  Select IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal FROM Personal where per_status=0 and idarea =9 order by per_paterno, per_materno, per_nombre "
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlejecutivo.DataSource = dt
            ddlejecutivo.DataTextField = "personal"
            ddlejecutivo.DataValueField = "IdPersonal"
            ddlejecutivo.DataBind()
            ddlejecutivo.Items.Add(New ListItem("Sel. el ejecutivo...", 0, True))
            ddlejecutivo.SelectedValue = 0
            sql = " SELECT    IdTpoServicio, ts_Descripcion FROM tbl_TipoServicio "
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlservicio.DataSource = dt
            ddlservicio.DataTextField = "ts_descripcion"
            ddlservicio.DataValueField = "IdTpoServicio"
            ddlservicio.DataBind()
            ddlservicio.Items.Add(New ListItem("Sel. el tipo de servicio...", 0, True))
            ddlservicio.SelectedValue = 2
            ddlservicio.Enabled = False
            sql = " SELECT Id_Estado, Estado, Clave FROM Estados"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlestado.DataSource = dt
            ddlestado.DataTextField = "Estado"
            ddlestado.DataValueField = "Id_Estado"
            ddlestado.DataBind()
            ddlestado.Items.Add(New ListItem("Sel. el Estado...", 0, True))
            ddlestado.SelectedValue = 0
            ddlestadoalta.DataSource = dt
            ddlestadoalta.DataTextField = "Estado"
            ddlestadoalta.DataValueField = "Id_Estado"
            ddlestadoalta.DataBind()
            ddlestadoalta.Items.Add(New ListItem("Sel. Localidad...", 0, True))
            ddlestadoalta.SelectedValue = 0

            sql = "SELECT IdPersonal, Per_Paterno +' '+ Per_Materno +' '+ Per_Nombre gerente FROM Personal where Id_Puesto=11"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlgerente.DataSource = dt
            ddlgerente.DataTextField = "gerente"
            ddlgerente.DataValueField = "IdPersonal"
            ddlgerente.DataBind()
            ddlgerente.Items.Add(New ListItem("Sel. el Gerente...", 0, True))
            ddlgerente.SelectedValue = 0

            ddlstatus.Enabled = False
            txtfecter.Enabled = False
            txthrter.Enabled = False
            txtdiast.Enabled = False
            If Request("id") <> Nothing Then
                ddlstatus.Enabled = True
                txtfecter.Enabled = True
                txthrter.Enabled = True
                txtdiast.Enabled = True
                llenaticket(Request("id"))
                cargabitacora(Request("id"))
            End If
        End If

    End Sub
    Protected Sub cargabitacora(ByVal id As Integer)
        Dim sql As String = "select a.ID_Ticket,tk_bit_fecha,a.Tk_Bit_Observacion,Per_Nombre+' '+Per_Paterno as Empleado"
        sql += " from Tbl_tk_Bitacora a inner join Personal b on a.IdUsuario=b.IdPersonal"
        sql += " where ID_Ticket =" & id & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        gvbit.DataSource = dt
        gvbit.DataBind()

    End Sub
    Protected Sub grababitacora(ByVal IDtk As Integer, ByVal fecha As String, ByVal hora As String, ByVal obs As String, ByVal idarea As Integer, ByVal IDEjec As Integer, ByVal IdEdo As Integer, ByVal idusu As Integer)
        Dim sql As String = "Insert into Tbl_tk_Bitacora(ID_Ticket,Tk_Bit_Fecha,Tk_Bit_Observacion,ID_Area"
        sql += ",ID_Ejecutivo,Id_Estatus,IdUsuario) values"
        sql += " (" & IDtk & ",'" & fecha & " " & hora & "','" & obs & "'," & idarea & "," & IDEjec & "," & IdEdo & "," & idusu & ")"
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        cargabitacora(IDtk)
    End Sub
    Protected Sub llenaticket(ByVal id As Integer)
        Dim sql As String = "select a.*,b.Cte_Fis_Razon_Social,Cte_Dir_Sucursal,d.Tk_Inc_Descripcion,e.Tk_CuaOri_Descripcion"
        sql += ",'Datos Generales del punto de atencion: Calle '+Cte_Dir_Calle+' Colonia '+Cte_Dir_Colonia+' CP '+Cte_Dir_CP+' Del/Mun '+Cte_Dir_Delegacion+' Ciudad '+Cte_Dir_Ciudad as Dir"
        sql += " from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        sql += " left outer join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
        sql += " inner join Tbl_tk_Incidencia d on d.ID_Incidencia=a.ID_Incidencia"
        sql += " inner join Tbl_tk_CausaOrigen e on e.ID_CausaOrigen=a.ID_CausaOrigen"
        sql += " where ID_Ticket = " & id & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            lblidticket.Text = id
            txtid.Text = dt.Rows(0).Item("No_Ticket")
            txtfolio.Text = dt.Rows(0).Item("Tk_Folio")

            lblidrs.Text = dt.Rows(0).Item("ID_Cliente")
            txtrs.Text = dt.Rows(0).Item("Cte_Fis_Razon_Social")
            If dt.Rows(0).Item("ID_Sucursal") = 0 Then txtpa.Text = dt.Rows(0).Item("sucursal") Else txtpa.Text = dt.Rows(0).Item("Cte_Dir_Sucursal")
            ddlestadoalta.SelectedValue = dt.Rows(0).Item("ID_Estado")
            If IsDBNull(dt.Rows(0).Item("dir")) Then lbldespa.Text = "" Else lbldespa.Text = dt.Rows(0).Item("dir")
            txtincidencia.Text = dt.Rows(0).Item("Tk_Inc_Descripcion")
            txtcauori.Text = dt.Rows(0).Item("Tk_CuaOri_Descripcion")
            ddlstatus.SelectedValue = dt.Rows(0).Item("Tk_Estatus")
            txtfechaalta.Text = dt.Rows(0).Item("Tk_FechaAlta")
            txthralta.Text = dt.Rows(0).Item("Tk_HoraAlta").ToString
            If Not IsDBNull(dt.Rows(0).Item("Tk_FechaTermino")) Then txtfecter.Text = dt.Rows(0).Item("Tk_FechaTermino")
            If Not IsDBNull(dt.Rows(0).Item("Tk_HoraTermino")) Then txthrter.Text = dt.Rows(0).Item("Tk_HoraTermino").ToString
            ddlmes.SelectedValue = dt.Rows(0).Item("Tk_MesServicio")
            ddlservicio.SelectedValue = dt.Rows(0).Item("ID_Servicio")
            ddlambito.SelectedValue = dt.Rows(0).Item("ID_Ambito")
            lblidpa.Text = dt.Rows(0).Item("ID_Sucursal")
            lblidincidencia.Text = dt.Rows(0).Item("ID_Incidencia")
            lblidco.Text = dt.Rows(0).Item("ID_CausaOrigen")
            Dim aresp As String = dt.Rows(0).Item("IdArea")
            txtdescripcion.Text = dt.Rows(0).Item("Tk_Descripcion")
            txtac.Text = dt.Rows(0).Item("Tk_Accion_Correctiva")
            txtap.Text = dt.Rows(0).Item("Tk_Accion_Preventiva")
            txtreporta.Text = dt.Rows(0).Item("Tk_Reporta")

            txtmatid.Text = dt.Rows(0).Item("ID_Ticket")
            txtmatfolio.Text = dt.Rows(0).Item("Tk_Folio")
            txtmatfechaalta.Text = dt.Rows(0).Item("Tk_FechaAlta")
            txtmathoraalta.Text = dt.Rows(0).Item("Tk_HoraAlta").ToString

            ddlejecutivo.SelectedValue = dt.Rows(0).Item("Tk_ID_Ejecutivo")
            ddlgerente.SelectedValue = dt.Rows(0).Item("ID_Gerente")
            'Dim resp As Integer = dt.Rows(0).Item("Tk_ID_Responsable")
            'sql = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            'sql += " FROM Personal a inner join Tbl_Area_empresa b on a.IdArea=b.IdArea "
            'sql += "  where per_status = 0 And a.IdArea = " & ddlarearesp.SelectedValue
            'myCommand = New SqlDataAdapter(sql, myConnection)
            'dt = New DataTable
            'myCommand.Fill(dt)
            'ddlresponsable.DataSource = dt
            'ddlresponsable.DataTextField = "personal"
            'ddlresponsable.DataValueField = "IdPersonal"
            'ddlresponsable.DataBind()
            'ddlresponsable.Items.Add(New ListItem("Sel. personal responsable...", 0, True))
            'ddlresponsable.SelectedValue = 0
            'ddlresponsable.SelectedValue = resp
            Dim dtm As DataTable
            InitializeDataSource()

            dtm = DirectCast(ViewState("dtuhem"), DataTable)

            sql = "select a.IdPieza,b.Pza_Clave,b.Pza_DescPieza,a.Tk_mat_cantidad,a.IdEstado,a.Tk_mat_Precio,(a.Tk_mat_cantidad*a.Tk_mat_Precio) as importe"
            sql += " from Tbl_tk_Material a inner join Tbl_Pieza b on b.IdPieza=a.IdPieza"
            sql += " where id_ticket=" & lblidticket.Text & ""
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            For i As Integer = 0 To dt.Rows.Count - 1
                ddlestado.SelectedValue = dt.Rows(0)("IdEstado")
                dtm.Rows.Add(Nothing, dt.Rows(0)("IdPieza"), dt.Rows(0)("Pza_Clave"), dt.Rows(0)("Pza_DescPieza"), dt.Rows(0)("Tk_mat_cantidad"), ddlestado.SelectedValue, ddlestado.SelectedItem.Text, dt.Rows(0)("Tk_mat_Precio"), dt.Rows(0)("importe"))
            Next
            BindGridData(2)
            txtclavemat.Text = ""
            txtdescmat.Text = ""
            txtcantidadmat.Text = ""
            txtcostomat.Text = ""
            txtimportemat.Text = ""


            Dim arearesp As DataTable = DirectCast(ViewState("arearesp"), DataTable)
            Dim sqlar As String = "SELECT IdArea, Ar_Nombre FROM Tbl_Area_Empresa where isnull(ar_estatus,0) =0 and idarea in(" & aresp & ")"
            myCommand = New SqlDataAdapter(sqlar, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            For i As Integer = 0 To dt.Rows.Count - 1
                arearesp.Rows.Add(Nothing, dt.Rows(i).Item("IdArea"), dt.Rows(i).Item("IdArea").ToString + "|" + dt.Rows(i).Item("Ar_Nombre"))
            Next

            ListBox1.DataSource = arearesp
            ListBox1.DataTextField = "Descripcion"
            ListBox1.DataValueField = "fila"
            ListBox1.DataBind()
            ddlarearesp.SelectedValue = 0


            Select Case ddlstatus.SelectedValue
                Case 2, 3
                    Dim script As String
                    script = "muestra(3);"
                    ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
            End Select
        End If
    End Sub
    Private Sub InitializeDataSource()

        Dim dtuhem As New DataTable()
        dtuhem.Columns.Add("fila")
        dtuhem.Columns.Add("IdPieza")
        dtuhem.Columns.Add("cve")
        dtuhem.Columns.Add("cvedesp")
        dtuhem.Columns.Add("cantidad", GetType(Double))
        dtuhem.Columns.Add("idestado")
        dtuhem.Columns.Add("estado")
        dtuhem.Columns.Add("Costo", GetType(Double))
        dtuhem.Columns.Add("Importe", GetType(Double))

        dtuhem.Columns("fila").AutoIncrement = True
        dtuhem.Columns("fila").AutoIncrementSeed = 1
        dtuhem.Columns("fila").AutoIncrementStep = 1

        Dim dcuhemKeys As DataColumn() = New DataColumn(0) {}
        dcuhemKeys(0) = dtuhem.Columns("fila")
        dtuhem.PrimaryKey = dcuhemKeys
        ViewState("dtuhem") = dtuhem

        Dim dtivap As New DataTable()
        dtivap.Columns.Add("fila")
        dtivap.Columns.Add("Id")
        dtivap.Columns.Add("Descripcion")

        dtivap.Columns("fila").AutoIncrement = True
        dtivap.Columns("fila").AutoIncrementSeed = 1
        dtivap.Columns("fila").AutoIncrementStep = 1

        Dim dcKeys1 As DataColumn() = New DataColumn(0) {}
        dcKeys1(0) = dtivap.Columns("fila")
        dtivap.PrimaryKey = dcKeys1
        ViewState("arearesp") = dtivap





    End Sub

    Protected Sub btnmat_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnmat.Click
        llenaview(2)
        txtcantidadmat.Text = ""
        Dim script As String
        script = "continuar(4);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub
    Protected Sub gwm_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwm.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gwm.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            BindGridData(2)
            script = "continuar(4);"
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

        End If

    End Sub
    Protected Sub llenaview(ByVal val As Integer)
        Select Case val
            Case 2
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    Dim sql As String = ""
                    sql += "Select IdPieza,Pza_Clave,Pza_Clave,Pza_DescPieza,Pza_PrecioAutorizado"
                    sql += " from Tbl_Pieza where Pza_Clave ='" & txtclavemat.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    If dtu.Rows.Count > 0 Then
                        txtdescmat.Text = dtu.Rows(0)("Pza_DescPieza")
                        If txtcostomat.Text = "" Then txtcostomat.Text = dtu.Rows(0)("Pza_PrecioAutorizado")
                    End If
                    Dim costomat, cant As Double
                    costomat = txtcostomat.Text
                    cant = txtcantidadmat.Text
                    'fre = ddlfrecuenciamat.SelectedValue
                    Dim tipo As Integer = 2
                    dt.Rows.Add(Nothing, dtu.Rows(0)("IdPieza"), txtclavemat.Text, txtdescmat.Text, txtcantidadmat.Text, ddlestado.SelectedValue, ddlestado.SelectedItem.Text, costomat, costomat * cant)


                    BindGridData(2)
                    txtclavemat.Text = ""
                    txtdescmat.Text = ""
                    txtcantidadmat.Text = ""
                    txtcostomat.Text = ""
                    txtimportemat.Text = ""
                End If
        End Select
    End Sub

    Protected Sub BindGridData(ByVal val As Integer)
        Select Case val
            Case 2
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                'vstuhem.RowFilter = "tipo=2"
                gwm.DataSource = vstuhem
                gwm.DataBind()
        End Select
    End Sub

    Protected Sub btnbitacora_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnbitacora.Click
        Dim fechasis As String = Format(Date.Today, "dd/MM/yyyy")
        Dim hora As String = Now.ToString("HH:mm:ss")
        grababitacora(lblidticket.Text, fechasis, hora, txtcomentario.Text, ddlarearesp.SelectedValue, ddlejecutivo.SelectedValue, ddlestado.SelectedValue, Session("v_usuario"))
        txtcomentario.Text = ""
        Dim Script As String = "muestra(2);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)

    End Sub

    Protected Sub txtrs_TextChanged(sender As Object, e As System.EventArgs) Handles txtrs.TextChanged
        If Trim(txtrs.Text) <> "" Then
            Dim sql As String = "select ID_Cliente from tbl_cliente where Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                lblidrs.Text = dt.Rows(0).Item("ID_Cliente")
                txtpa.Focus()
            Else
                lblidrs.Text = ""
            End If
        End If

    End Sub

    Protected Sub txtpa_TextChanged(sender As Object, e As System.EventArgs) Handles txtpa.TextChanged
        If Trim(txtpa.Text) <> "" Then
            Dim datos As Array = txtpa.Text.Split("|")
            If datos.Length > 1 Then
                txtpa.Text = datos(1)
                Dim sql As String = "select Cte_Dir_No_Surusal,Cte_Dir_Sucursal,Cte_Dir_Cve_Interna,"
                sql += " 'Datos Generales del punto de atencion: Calle '+Cte_Dir_Calle+' Colonia '+Cte_Dir_Colonia+' CP '+Cte_Dir_CP+' Del/Mun '+Cte_Dir_Delegacion+' Ciudad '+Cte_Dir_Ciudad as Dir, b.Estado"
                sql += " FROM Tbl_Cliente_Dir  a inner join Estados b on b.Id_Estado=a.Cte_Dir_Estado"
                sql += " where ID_Sucursal=" & datos(0) & ""
                Dim myCommand As New SqlDataAdapter(sql, myConnection)
                Dim dt As New DataTable
                myCommand.Fill(dt)
                If dt.Rows.Count > 0 Then
                    lbldespa.Text = dt.Rows(0).Item("dir")
                    lblidpa.Text = datos(0)
                Else
                    lbldespa.Text = ""
                    lblidpa.Text = ""
                End If
            End If
        Else
            lbldespa.Text = ""
        End If

    End Sub

    Protected Sub txtincidencia_TextChanged(sender As Object, e As System.EventArgs) Handles txtincidencia.TextChanged
        If Trim(txtincidencia.Text) <> "" Then
            Dim datos As Array = txtincidencia.Text.Split("|")
            If datos.Length > 1 Then
                lblidincidencia.Text = Trim(datos(0))
                txtincidencia.Text = Trim(datos(1))
                ddlarearesp.SelectedValue = Trim(datos(2))
                'Dim sql As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
                'sql += " FROM Personal a inner join Tbl_Area_empresa b on a.IdArea=b.IdArea "
                'sql += "  where per_status = 0 And a.IdArea = " & ddlarearesp.SelectedValue
                'Dim myCommand As New SqlDataAdapter(sql, myConnection)
                'Dim dt As New DataTable
                'myCommand.Fill(dt)
                'ddlresponsable.DataSource = dt
                'ddlresponsable.DataTextField = "personal"
                'ddlresponsable.DataValueField = "IdPersonal"
                'ddlresponsable.DataBind()
                'ddlresponsable.Items.Add(New ListItem("Sel. personal responsable...", 0, True))
                'ddlresponsable.SelectedValue = 0
            Else
                lblidincidencia.Text = ""
                txtincidencia.Text = ""
                ddlarearesp.SelectedValue = 0
            End If
        Else
            lblidincidencia.Text = ""
            txtincidencia.Text = ""
            ddlarearesp.SelectedValue = 0
        End If

    End Sub

    Protected Sub txtcauori_TextChanged(sender As Object, e As System.EventArgs) Handles txtcauori.TextChanged
        If Trim(txtcauori.Text) <> "" Then
            Dim datos As Array = txtcauori.Text.Split("|")
            If datos.Length > 1 Then
                lblidco.Text = Trim(datos(0))
                txtcauori.Text = Trim(datos(1))
            Else
                lblidco.Text = ""
                txtcauori.Text = ""
            End If
        Else
            lblidco.Text = ""
            txtcauori.Text = ""
        End If

    End Sub

    Protected Sub ddlarearesp_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlarearesp.SelectedIndexChanged
        If ddlarearesp.SelectedValue <> 0 Then
            Dim arearesp As DataTable = DirectCast(ViewState("arearesp"), DataTable)
            Dim val As Integer = 0
            For i = 0 To arearesp.Rows.Count - 1
                If ddlarearesp.SelectedValue = arearesp.Rows(i).Item("Id") Then
                    val = 1
                End If
            Next
            If val = 0 Then
                arearesp.Rows.Add(Nothing, ddlarearesp.SelectedValue, ddlarearesp.SelectedValue + "|" + ddlarearesp.SelectedItem.Text)
            End If
            ListBox1.DataSource = arearesp
            ListBox1.DataTextField = "Descripcion"
            ListBox1.DataValueField = "fila"
            ListBox1.DataBind()
            ddlarearesp.SelectedValue = 0
        End If
    End Sub



    Protected Sub ListBox1_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ListBox1.SelectedIndexChanged
        Dim arearesp As DataTable = DirectCast(ViewState("arearesp"), DataTable)
        For i = 0 To arearesp.Rows.Count - 1
            Dim strtintaIDi As Integer = ListBox1.SelectedValue
            If arearesp.Rows(i).Item("fila") = strtintaIDi Then
                Dim drpi As DataRow = arearesp.Rows.Find(strtintaIDi)
                arearesp.Rows.Remove(drpi)
                Exit For
            End If
        Next
        ListBox1.DataSource = arearesp
        ListBox1.DataTextField = "Descripcion"
        ListBox1.DataValueField = "fila"
        ListBox1.DataBind()
    End Sub
End Class
