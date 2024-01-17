Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Data.OleDb

Partial Class Ventas_App_Ven_Cotizador
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public lblcteinfo As String = ""
    ' Public lblsubtotal As String = ""
    'Public lblsubtotalanual As String = ""
    Public labelmenu As String = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "continua"
                llenacabecero()
            Case "agregap"
                Select Case Request.Params("__eventargument")
                    Case 1
                        llenaview(0)
                        txtcantidad.Text = ""
                End Select

            Case "consultadesglose"
                consultadesglose()
            Case "dir"
                Select Case Request.Params("__eventargument")
                    Case 1
                        Dim Sql As String = "SELECT Cot_Dir_No_Sucursal AS No_Sucursal, Cot_Dir_Sucursal AS Sucursal, Cot_Dir_Cve_Interna AS Cve_Interna, Cot_Dir_Calle AS Calle, Cot_Dir_Colonia AS Colonia, Cot_Dir_CP AS CP, "
                        Sql += " Cot_Dir_Delegacion AS Delegacion, Cot_Dir_Ciudad AS Ciudad, Cot_Dir_Estado AS Estado, Cot_Dir_Contacto AS Contacto, Cot_Dir_Mail AS Mail, Cot_Dir_Telefono AS Telefono"
                        If IsNumeric(lblidcot.Text) Then
                            Sql += " FROM Tbl_Cot_Dir WHERE ID_Cotizacion = " & lblidcot.Text & ""
                        Else
                            Sql += " FROM Tbl_Cot_Dir WHERE ID_Cotizacion = 0"
                        End If
                        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                        Dim dsd As New DataTable
                        myCommand.Fill(dsd)
                        If dsd.Rows.Count = 0 Then
                            Sql = "SELECT     '' AS No_Sucursal, '' AS Sucursal, '' AS Cve_Interna, '' AS Calle, '' AS Colonia, '' AS CP, '' AS Delegacion, '' AS Ciudad, '' AS Estado, '' AS Contacto, '' AS Mail, '' AS Telefono"
                            myCommand = New SqlDataAdapter(Sql, myConnection)
                            dsd = New DataTable
                            myCommand.Fill(dsd)
                        End If
                        Dim grid As New GridView
                        grid.AutoGenerateColumns = True
                        grid.DataSource = dsd
                        grid.DataBind()
                        ExportToExcel("directorio.xls", grid)
                    Case 4
                        importa()
                        llenacotizador()
                        If gwdirdat.Rows.Count > 0 Then
                            Dim script As String = "continuar(9);"
                            ScriptManager.RegisterStartupScript(Me, GetType(Page), "continuar", script, True)
                        Else
                            Response.Write("<script>alert('El archivo contiene estados que no son correctos. Verifiquelos!!!');</script>")
                            'Dim Script As String = "mensaje('El archivo contiene estados que no son correctos. Verifiquelos!!'," & lblcteinfo & ");"
                            'ScriptManager.RegisterStartupScript(Me, GetType(Page), "mensaje", Script, True)
                        End If
                        Exit Sub
                End Select

            Case "per"
                Select Case Request.Params("__eventargument")
                    Case 1
                        Dim ds As New DataSet
                        Dim dt As DataTable = DirectCast(ViewState("dtdir"), DataTable)
                        dt.TableName = "p"
                        ds.Tables.Add(dt)

                        Dim strxml As String = ds.GetXml()
                        Dim Sql As String = "EXEC [spConInmPuesto] '" & strxml & "'"

                        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                        Dim dsd As New DataSet
                        myCommand.Fill(dsd)
                        Dim grid As New GridView
                        'grid.Caption = ddlfam.SelectedItem.Text
                        grid.AutoGenerateColumns = True
                        grid.DataSource = dsd
                        grid.DataBind()
                        ExportToExcel("Puesto.xls", grid)

                    Case 4
                        importaper()
                    Case 5
                        Dim dt As DataTable = DirectCast(ViewState("dtp"), DataTable)
                        dt.TableName = "p"
                        Dim ds As New DataSet()
                        ds.Tables.Add(dt)

                        Dim strxml As String = ds.GetXml()
                        Dim Sql As String = "EXEC [spConPuestoUni] '" & strxml & "'"

                        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                        Dim dsd As New DataSet
                        myCommand.Fill(dsd)
                        Dim grid As New GridView
                        'grid.Caption = ddlfam.SelectedItem.Text
                        grid.AutoGenerateColumns = True
                        grid.DataSource = dsd
                        grid.DataBind()
                        ExportToExcel("Uniformes.xls", grid)
                    Case 8
                        importauni()
                    Case 9
                        Dim ds As New DataSet
                        Dim dt As DataTable = DirectCast(ViewState("dtdir"), DataTable)
                        dt.TableName = "p"
                        ds.Tables.Add(dt)

                        Dim strxml As String = ds.GetXml()
                        Dim Sql As String = "EXEC [spConInmMat] '" & strxml & "'"

                        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
                        Dim dsd As New DataSet
                        myCommand.Fill(dsd)
                        Dim grid As New GridView
                        'grid.Caption = ddlfam.SelectedItem.Text
                        grid.AutoGenerateColumns = True
                        grid.DataSource = dsd
                        grid.DataBind()
                        ExportToExcel("Materiales.xls", grid)
                    Case 12
                        importamat()

                End Select
        End Select
        If Not IsPostBack Then
            ' lblfolio.Text = "COT-00001"
            InitializeDataSource()
            Dim sql As String = "SELECT Per_Nombre,Fecha_Alta,b.ar_descripcion from Personal a inner join area b on b.idarea=a.IdArea where IdPersonal=" & Session("v_usuario") & ""
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                labeluser = dt.Rows(0).Item("per_nombre")
            End If

            sql = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            sql += " FROM Personal where per_status=0 and IdArea=2 and Per_Puesto like '%Ejecu%venta%'"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlejecutivo.DataSource = dt
            ddlejecutivo.DataTextField = "personal"
            ddlejecutivo.DataValueField = "IdPersonal"
            ddlejecutivo.DataBind()
            ddlejecutivo.Items.Add(New ListItem("Sel. el ejecutivo...", 0, True))
            ddlejecutivo.SelectedValue = 0

            'ddlejecutivo.Items.Add(New ListItem("Seleccione...", 0, True))
            'ddlejecutivo.Items.Add(New ListItem("Barbara Villafan", 1, True))
            'llenaestados("")

            'sql = "select * from Tbl_Region"
            'myCommand = New SqlDataAdapter(sql, myConnection)
            'dt = New DataTable
            'myCommand.Fill(dt)
            'If dt.Rows.Count > 0 Then
            '    ddlregion.DataSource = dt
            '    ddlregion.DataTextField = "Reg_Descripcion"
            '    ddlregion.DataValueField = "Id_Region"
            '    ddlregion.DataBind()
            '    ddlregion.SelectedValue = 1
            'End If

            sql = "select Convert(nvarchar(10),a.ID_Puesto) + '|'+Convert(nvarchar(10),ID_PuestoDet)"
            sql += " + '|'+Convert(nvarchar(10),(Pue_SueldoMensual+Pue_PPuntialidad+Pue_PAsistencia+Pue_Despensa+Pue_TiempoExtra+Pue_Bono+Pue_OtraPrestacion))"
            sql += " + '|'+Convert(nvarchar(10),Pue_SubTotalEmpleado) as gral, Cve_Puesto + '|'+Pue_Puesto as puesto"
            sql += " from Tbl_Puesto a inner join Tbl_PuestoDet b on b.ID_Puesto=a.ID_Puesto and a.Pue_Estatus=0 and b.Pue_Estatus =0"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlpuesto.DataSource = dt
                ddlpuesto.DataTextField = "puesto"
                ddlpuesto.DataValueField = "gral"
                ddlpuesto.DataBind()
            End If
            sql = "Select * from turno"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlturno.DataSource = dt
                ddlturno.DataTextField = "Descripcion"
                ddlturno.DataValueField = "Id_Turno"
                ddlturno.DataBind()
            End If
            ddljornal.Items.Add(New ListItem("8", 8, True))
            ddljornal.Items.Add(New ListItem("4", 4, True))
            If Request("idcot") <> Nothing Then
                llenacotizacion(Request("idcot"))
                llenacotizador()
                Dim script As String
                script = "continuar(8);"
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

            End If
        End If
    End Sub
    Protected Sub consultadesglose()
        Dim dtres1 As DataTable = DirectCast(ViewState("dtres"), DataTable)
        If Not dtres1 Is Nothing Then
            If dtres1.Rows.Count > 0 Then
                dtres1 = Nothing
            End If
        End If

        Dim dtres As New DataTable()
        dtres.Columns.Add("fila")
        dtres.Columns.Add("Concepto")
        dtres.Columns.Add("Cantidad")
        dtres.Columns.Add("CostoMensual", GetType(Double))
        dtres.Columns.Add("CostoAnual", GetType(Double))
        dtres.Columns.Add("PrecioMensual", GetType(Double))
        dtres.Columns.Add("PrecioAnual", GetType(Double))
        dtres.Columns.Add("tipo")

        dtres.Columns("fila").AutoIncrement = True
        dtres.Columns("fila").AutoIncrementSeed = 1
        dtres.Columns("fila").AutoIncrementStep = 1

        Dim dcresKeys As DataColumn() = New DataColumn(0) {}
        dcresKeys(0) = dtres.Columns("fila")
        dtres.PrimaryKey = dcresKeys
        ViewState("dtres") = dtres

        Dim dtp As DataTable = DirectCast(ViewState("dtp"), DataTable)
        '  Dim Cantidad, CostoMensual, CostoAnual, PrecioMensual, PrecioAnual As Double
        '  Cantidad = dtp.Compute("Sum(cantidad", "fila > 0")
        '  CostoMensual = dtp.Compute("Sum(sueldotot)", "fila > 0")
        '  CostoAnual = dtp.Compute("Sum(sueldotot)", "fila > 0")
        '  PrecioMensual = dtp.Compute("Sum(costot)", "fila > 0")
        '  PrecioAnual = dtp.Compute("Sum(costot)", "fila > 0")

        'muestradetalleproceso(Request.Params("__EVENTARGUMENT"))
        If Not IsDBNull(dtp.Compute("Sum(cantidad)", "fila > 0")) Then dtres.Rows.Add(Nothing, "Personal", dtp.Compute("Sum(cantidad)", "fila > 0"), dtp.Compute("Sum(sueldotot)", "fila > 0"), dtp.Compute("Sum(sueldotot)", "fila > 0") * 12, dtp.Compute("Sum(costot)", "fila > 0"), dtp.Compute("Sum(costot)", "fila > 0") * 12, 0)

        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =1")) Then dtres.Rows.Add(Nothing, "Uniformes", dtuhem.Compute("Sum(cantidad)", "tipo =1"), dtuhem.Compute("Sum(Costo)", "tipo =1"), dtuhem.Compute("Sum(Costo)", "tipo =1") * 12, dtuhem.Compute("Sum(Importe)", "tipo =1"), dtuhem.Compute("Sum(Importe)", "tipo =1") * 12, 1)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =2")) Then dtres.Rows.Add(Nothing, "Materiales", dtuhem.Compute("Sum(cantidad)", "tipo =2"), dtuhem.Compute("Sum(Costo)", "tipo =2"), dtuhem.Compute("Sum(Costo)", "tipo =2") * 12, dtuhem.Compute("Sum(Importe)", "tipo =2"), dtuhem.Compute("Sum(Importe)", "tipo =2") * 12, 2)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =3")) Then dtres.Rows.Add(Nothing, "Herramientas", dtuhem.Compute("Sum(cantidad)", "tipo =3"), dtuhem.Compute("Sum(Costo)", "tipo =3"), dtuhem.Compute("Sum(Costo)", "tipo =3") * 12, dtuhem.Compute("Sum(Importe)", "tipo =3"), dtuhem.Compute("Sum(Importe)", "tipo =3") * 12, 3)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =4")) Then dtres.Rows.Add(Nothing, "Equipos", dtuhem.Compute("Sum(cantidad)", "tipo =4"), dtuhem.Compute("Sum(Costo)", "tipo =4"), dtuhem.Compute("Sum(Costo)", "tipo =4") * 12, dtuhem.Compute("Sum(Importe)", "tipo =4"), dtuhem.Compute("Sum(Importe)", "tipo =4") * 12, 4)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =5")) Then dtres.Rows.Add(Nothing, "Servicios Adicionales", dtuhem.Compute("Sum(cantidad)", "tipo =5"), dtuhem.Compute("Sum(Costo)", "tipo =5"), dtuhem.Compute("Sum(Costo)", "tipo =5") * 12, dtuhem.Compute("Sum(Importe)", "tipo =5"), dtuhem.Compute("Sum(Importe)", "tipo =5") * 12, 5)
        gwpropuesta.DataSource = dtres
        gwpropuesta.DataBind()
        If dtres.Rows.Count > 0 Then
            calculautilidad()
        Else
            lblsubtotal.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalanual.Text = "$" & Format(0, "#,###,###.00")
            lblpind.Text = "$" & Format(0, "#,###,###.00")
            lblpindanual.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalind.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalinda.Text = "$" & Format(0, "#,###,###.00")
            lblutil.Text = "$" & Format(0, "#,###,###.00")
            lblutila.Text = "$" & Format(0, "#,###,###.00")
            lblsubutil.Text = "$" & Format(0, "#,###,###.00")
            lblsubutila.Text = "$" & Format(0, "#,###,###.00")
            lblcomer.Text = "$" & Format(0, "#,###,###.00")
            lblcomera.Text = "$" & Format(0, "#,###,###.00")
            lblsubcomer.Text = "$" & Format(0, "#,###,###.00")
            lblsubcomera.Text = "$" & Format(0, "#,###,###.00")
        End If

        Dim script As String = "continuar(8);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub
    Protected Sub llenacabecero()
        Dim msg As String = ""
        Dim sql As String = ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        lblcteinfo = "Datos Generales - "
        If chkcliente.Checked = True Then
            sql = " select  e.IdTpoServicio,a.ID_Cliente,'<small> CLAVE : '+ a.Cte_Fis_Clave_Cliente+' CLIENTE : '+a.Cte_Fis_Razon_Social+'	CONTACTO : '+b.Cte_Con_Contacto_Cliente"
            sql += " +' TELEFONO : '+b.Cte_Con_Telefono+ ' EMAIL : '+b.Cte_Con_Mail+' EJECUTIVO : '+c.Per_Nombre+' '+c.Per_Paterno +' TIPO SERVICIO : '+ts_Descripcion+'</small>' AS INFO,"
            sql += "  isnull(isnull(Por_Indirecto,(select Por_Indirecto from  Tbl_Porcentaje where Por_Status=0 and Id=0)),0) Por_Indirecto,"
            sql += " isnull(isnull(Por_Utilidad,(select Por_Utilidad from  Tbl_Porcentaje where Por_Status=0 and Id=0 )),0) Por_Utilidad,"
            sql += " isnull(isnull(Por_Comercializacion,(select Por_Comercializacion from  Tbl_Porcentaje where Por_Status=0 and Id=0)),0) Por_Comercializacion "

            'sql += " ,isnull(Por_Indirecto,0) Por_Indirecto,isnull(Por_Utilidad,0)Por_Utilidad,isnull(Por_Comercializacion,0)Por_Comercializacion"
            sql += " from Tbl_Cliente a inner join Tbl_Cliente_Cont b on a.ID_Cliente=b.ID_Cliente inner join Personal c on c.IdPersonal=b.Cte_Con_Ejecutivo"
            sql += " inner join Tbl_Cliente_Ser  d on d.ID_Cliente=a.ID_Cliente inner join Tbl_TipoServicio e on e.IdTpoServicio=d.Cte_Ser_Tipos_Servicios"
            sql += " left outer join Tbl_Porcentaje f on f.Id=a.ID_Cliente and f.Por_Tipo=2 and f.Por_Status=0"
            sql += " where a.Cte_Fis_Razon_Social = '" & txtrsc.Text & "'"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                lblcteinfo += dt.Rows(0).Item("INFO")
                ddltservicio.SelectedValue = dt.Rows(0).Item("IdTpoServicio")
                txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
                lblid.Text = dt.Rows(0).Item("ID_Cliente")
                lbltipo.Text = "1"
            Else
                sql = " select  * from Tbl_Porcentaje where Por_Status=0 and Por_Tipo=1"
                myCommand = New SqlDataAdapter(sql, myConnection)
                dt = New DataTable
                myCommand.Fill(dt)
                lblcteinfo = "0"
                txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
                lblid.Text = "0"
                lbltipo.Text = "0"
            End If
        End If
        If chkprospecto.Checked = True Then
            'Dim script As String
            sql = "select  ID_Prospecto,'<small>CLIENTE : '+Pros_Razon_Social +' CONTACTO : '+ Pros_Contacto +' TELEFONO : '+Pros_Telefono+ ' EMAIL : '+Pros_Mail+' EJECUTIVO : '+c.Per_Nombre+' '+c.Per_Paterno +' TIPO SERVICIO : '+'" & ddltservicio.SelectedItem.Text & "'+'</small>'AS INFO"
            sql += " ,isnull(Por_Indirecto,0) Por_Indirecto,isnull(Por_Utilidad,0)Por_Utilidad,isnull(Por_Comercializacion,0)Por_Comercializacion"
            sql += "  from Tbl_Prospecto a inner join Personal c on c.IdPersonal=a.Pros_Ejecutivo"
            sql += "  left outer join Tbl_Porcentaje d on d.Id=a.ID_Prospecto and d.Por_Tipo=3 and d.Por_Status=0"
            sql += "  where Pros_Razon_Social = '" & txtrsp.Text & "'"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                lblcteinfo += dt.Rows(0).Item("INFO")
                txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
                lblid.Text = dt.Rows(0).Item("ID_Prospecto")
                lbltipo.Text = "2"
            Else
                sql = " select  * from Tbl_Porcentaje where Por_Status=0 and Por_Tipo=1"
                myCommand = New SqlDataAdapter(sql, myConnection)
                dt = New DataTable
                myCommand.Fill(dt)
                lblcteinfo = "1"
                lblid.Text = "0"
                lbltipo.Text = "2"
                If dt.Rows.Count > 0 Then
                    txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                    txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                    txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
                Else
                    msg = "No se tienen registrados los porcentajes para la cotizacion. Verifique!!"
                    'script = "mensaje('No se tienen registrados los porcentajes para la cotizacion. Verifique!!',"");"
                    'ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
                End If
            End If
        End If
        If chknuevo.Checked = True Then
            'Dim script As String
            lblcteinfo += " <small>PROSPECTO : " & txtrs.Text & ""
            lblcteinfo += " CONTACTO : " & txtcontacto.Text & ""
            lblcteinfo += " TELEFONO : " & txttel.Text & ""
            lblcteinfo += " EMAIL : " & txtcontacto.Text & ""
            lblcteinfo += " EJECUTIVO : " & ddlejecutivo.SelectedItem.Text & ""
            lblcteinfo += " TIPO SERVICIO : " & ddltservicio.SelectedItem.Text & "</small>"
            sql = " select  * from Tbl_Porcentaje where Por_Status=0 and Por_Tipo=1"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            lblid.Text = 0
            lbltipo.Text = "3"
            If dt.Rows.Count > 0 Then
                txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
            Else
                msg = "No se tienen registrados los porcentajes para la cotizacion. Verifique!!"

                'Response.Write("<script>alert('No se tienen registrados los porcentajes para la cotizacion. Verifique!!');</script>")
                '  script = "mensaje('No se tienen registrados los porcentajes para la cotizacion. Verifique!!',"");"
                '  ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
            End If

        End If
        If Request.Params("__eventargument") = 1 Then
            Dim script As String
            If Len(lblcteinfo) = 1 Then
                script = "mensaje('No se encontro la razon social solicitada. Verifique!!'," & lblcteinfo & ");"
            Else
                script = "paso(" & Request.Params("__eventargument") & ",'" & msg & "');"
            End If
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        End If
        calculautilidad()

    End Sub
    Protected Sub llenainm()
        If ViewState("dtdir") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("dtdir"), DataTable)
            If dt.Rows.Count > 0 Then
                ddlinm.DataSource = dt
                ddlinm.DataTextField = "Sucursal"
                ddlinm.DataValueField = "fila"
                ddlinm.DataBind()
                If ID = "" Then ddlinm.SelectedValue = 9
                ddlregion.DataSource = dt
                ddlregion.DataTextField = "Sucursal"
                ddlregion.DataValueField = "fila"
                ddlregion.DataBind()
                If ID = "" Then ddlregion.SelectedValue = 9

            End If
        End If
    End Sub
    Protected Sub llenapue()
        If ViewState("dtp") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("dtp"), DataTable)
            If dt.Rows.Count > 0 Then

                Dim query = From q In dt.AsEnumerable() Select q Order By q.Item("idpuestodet")
                Dim idest As String = "0"
                ddlpue.Items.Add(New ListItem("Seleccione...", 0, True))
                Dim dtCopy = query.CopyToDataTable()
                dtCopy.Rows.Add()
                Dim dr As DataRow = dtCopy.NewRow()
                Dim i, value As Integer

                For j As Integer = 0 To dtCopy.Rows.Count - 2
                    Dim item = dtCopy.Rows(j)
                    Dim puesto = dtCopy.Compute("Sum(cantidad)", "puesto ='" & Convert.ToString(item(5)) & "'") & "|" & Convert.ToString(item(5))
                    Dim id = Convert.ToString(item(4))
                    Dim filaSig As String = Convert.ToString(dtCopy.Rows(i + 1).Item(4)) 'fila siguiente
                    If (id = filaSig) Then 'zona actual es igual a la siguiente zona
                    Else 'cuando cambie la zona insertar nueva fila y poner "Total" & Zona 
                        ddlpue.Items.Add(New ListItem(puesto, id, True))
                        value = 0
                    End If
                    i += 1 'indice
                Next





                'ddlpue.DataSource = dt
                'ddlpue.DataTextField = "Puesto"
                'ddlpue.DataValueField = "idpuestodet"
                ddlpue.DataBind()
            End If
        End If
    End Sub
    Protected Sub importa()
        If cargaarch.FileName.ToString() <> "" Then
            Dim ext As Array = Server.MapPath(cargaarch.FileName.ToString()).Split(".")
            Dim A_Nombre As String = "cargainm."
            A_Nombre += ext(ext.Length - 1)
            If cargaarch.HasFile Then
                cargaarch.SaveAs("c:\directorio\" + A_Nombre)
            End If
            'CargaArchivo(A_Nombre)
            Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & _
          "data source=" & "c:\directorio\" + A_Nombre & ";Extended Properties=Excel 12.0;")

            cnn.Open()
            Dim sqlExcel As String = "Select * From [directorio$] WHERE No_Sucursal IS NOT NULL"
            Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
            Dim da As New OleDbDataAdapter(myCommand1)
            Dim dt As New DataTable
            da.Fill(dt)
            dt.TableName = "p"
            Dim dsr As New DataSet
            dsr.Tables.Add(dt)
            cnn.Close()

            Dim strxmlinv As String = dsr.GetXml()
            Dim Sql As String = "EXEC [spcargaDir] '" & strxmlinv & "'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dsd As New DataTable
            myCommand.Fill(dsd)
            dsd.Columns("fila").AutoIncrement = True
            dsd.Columns("fila").AutoIncrementSeed = 1
            dsd.Columns("fila").AutoIncrementStep = 1
            Dim dcKeys As DataColumn() = New DataColumn(0) {}
            dcKeys(0) = dt.Columns("fila")
            dcKeys = New DataColumn(0) {}
            dcKeys(0) = dsd.Columns("fila")
            dsd.PrimaryKey = dcKeys
            ViewState("dtdir") = dsd
            BindGridData(6)

            'Dim query = From q In dsd.AsEnumerable() Select q Order By q.Item("Id_Estado")
            'Dim idest As String = "0"
            ''Dim dtResultado As New DataTable()
            ''dtResultado.Columns.Add("Estado")
            ''dtResultado.Columns.Add("Id_Estado")
            'Dim dtCopy = query.CopyToDataTable()
            'dtCopy.Rows.Add()
            'Dim dr As DataRow = dtCopy.NewRow()
            'Dim i, value As Integer

            'For j As Integer = 0 To dtCopy.Rows.Count - 2
            '    Dim item = dtCopy.Rows(j)
            '    Dim estado = Convert.ToString(item(9))
            '    Dim id = Convert.ToString(item(13))
            '    'Dim drr As DataRow = dtResultado.NewRow()
            '    'drr.Item(0) = estado
            '    'drr.Item(1) = id
            '    'dtResultado.ImportRow(item)
            '    Dim filaSig As String = Convert.ToString(dtCopy.Rows(i + 1).Item(9)) 'fila siguiente
            '    If (estado = filaSig) Then 'zona actual es igual a la siguiente zona
            '    Else 'cuando cambie la zona insertar nueva fila y poner "Total" & Zona 
            '        idest += "," & id
            '        value = 0
            '    End If
            '    i += 1 'indice
            'Next
            'llenaestados(idest)


        End If
    End Sub
    Protected Sub importaper()
        If FileUpload1.FileName.ToString() <> "" Then
            Dim dtplim As DataTable = DirectCast(ViewState("dtp"), DataTable)
            dtplim.Rows.Clear()
            'dtp.Rows.Remove(drp)

            Dim ext As Array = Server.MapPath(FileUpload1.FileName.ToString()).Split(".")
            Dim A_Nombre As String = "cargaper."
            A_Nombre += ext(ext.Length - 1)
            If FileUpload1.HasFile Then
                FileUpload1.SaveAs("c:\directorio\" + A_Nombre)
            End If
            'CargaArchivo(A_Nombre)
            Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & _
          "data source=" & "c:\directorio\" + A_Nombre & ";Extended Properties=Excel 12.0;")

            cnn.Open()
            Dim sqlExcel As String = "Select * From [Puesto$] WHERE [Jornal(hr)]<>0"
            Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
            Dim da As New OleDbDataAdapter(myCommand1)
            Dim dt As New DataTable
            da.Fill(dt)
            dt.TableName = "p"
            If dt.Rows.Count > 0 Then
                For j As Integer = 0 To dt.Rows.Count - 1
                    Dim Turno As Array = dt.Rows(j).Item("Turno").Split("|")
                    Dim Puesto As Array = dt.Rows(j).Item("Puesto").Split("|")
                    Dim Sueldo As Double = dt.Rows(j).Item("Sueldo")
                    Dim costo As Double = dt.Rows(j).Item("costo")
                    Dim Jornal As Integer = dt.Rows(j).Item("Jornal(hr)")
                    Dim puestodesc As String = Puesto(0) & "|" & Puesto(1)
                    For i As Integer = 0 To dt.Columns.Count - 1
                        If i >= 5 Then
                            Dim cant As Double = dt.Rows(j).Item(i)
                            If IsNumeric(cant) Then
                                If cant > 0 Then
                                    If ViewState("dtp") IsNot Nothing Then
                                        Dim dtp As DataTable = DirectCast(ViewState("dtp"), DataTable)

                                        Dim nombre As String = dt.Columns(i).ColumnName
                                        Dim inmue As Array = nombre.Split("|")
                                        dtp.Rows.Add(Nothing, inmue(0), nombre, Puesto(2), Puesto(3), puestodesc, _
                                                     Turno(0), Turno(1), Jornal, Jornal, cant, Sueldo, cant * Sueldo, costo, cant * costo)

                                    End If
                                End If
                            End If
                        End If
                    Next

                Next

            End If



            BindGridData(0)
            llenacotizador()



            'Dim dsr As New DataSet
            'dsr.Tables.Add(dt)
            'cnn.Close()

            'Dim strxmlinv As String = dsr.GetXml()
            'Dim Sql As String = "EXEC [spcargaDir] '" & strxmlinv & "'"
            'Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            'Dim dsd As New DataTable
            'myCommand.Fill(dsd)
            'dsd.Columns("fila").AutoIncrement = True
            'dsd.Columns("fila").AutoIncrementSeed = 1
            'dsd.Columns("fila").AutoIncrementStep = 1
            'Dim dcKeys As DataColumn() = New DataColumn(0) {}
            'dcKeys(0) = dt.Columns("fila")
            'dcKeys = New DataColumn(0) {}
            'dcKeys(0) = dsd.Columns("fila")
            'dsd.PrimaryKey = dcKeys
            'ViewState("dtdir") = dsd
            BindGridData(1)
        End If
    End Sub
    Protected Sub importauni()
        If FileUpload2.FileName.ToString() <> "" Then
            'Dim dtplim As DataTable = DirectCast(ViewState("dtp"), DataTable)
            'dtplim.Rows.Clear()
            'dtp.Rows.Remove(drp)

            Dim ext As Array = Server.MapPath(FileUpload2.FileName.ToString()).Split(".")
            Dim A_Nombre As String = "cargauni."
            A_Nombre += ext(ext.Length - 1)
            If FileUpload2.HasFile Then
                FileUpload2.SaveAs("c:\directorio\" + A_Nombre)
            End If
            'CargaArchivo(A_Nombre)
            Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & _
          "data source=" & "c:\directorio\" + A_Nombre & ";Extended Properties=Excel 12.0;")

            cnn.Open()
            Dim sqlExcel As String = "Select * From [Uniformes$] WHERE [Frecuencia:1,3,6,12]<>0"
            Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
            Dim da As New OleDbDataAdapter(myCommand1)
            Dim dt As New DataTable
            da.Fill(dt)
            Dim sql As String = " select * from Tbl_PorcentajesFamilias where id=1"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dtu As New DataTable
            myCommand.Fill(dtu)

            If dt.Rows.Count > 0 Then
                For j As Integer = 0 To dt.Rows.Count - 1
                    For i As Integer = 0 To dt.Columns.Count - 1
                        If i >= 4 Then
                            Dim cant As Double = dt.Rows(j).Item(i)
                            If IsNumeric(cant) Then
                                If cant > 0 Then
                                    If ViewState("dtuhem") IsNot Nothing Then
                                        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                                        Dim costouni, fre As Double
                                        costouni = dt.Rows(j).Item("Costo")
                                        fre = dt.Rows(j).Item(3)
                                        Dim tipo As Integer = 1
                                        Dim puesto As Array = dt.Columns(i).ColumnName.ToString.Split("|")
                                        Dim pieza As Array = dt.Rows(j).Item(1).ToString.Split("|")

                                        dtuhem.Rows.Add(Nothing, puesto(0), puesto(1) & "|" & puesto(2), pieza(1), dt.Rows(j).Item(0), pieza(0), cant, fre, fre, costouni, costouni * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costouni * cant) / fre, 0, "", 0)
                                        BindGridData(1)
                                    End If
                                End If
                            End If
                        End If
                    Next

                Next

            End If
            'BindGridData(1)
            llenacotizador()
        End If
    End Sub
    Protected Sub importamat()
        If FileUpload3.FileName.ToString() <> "" Then
            'Dim dtplim As DataTable = DirectCast(ViewState("dtp"), DataTable)
            'dtplim.Rows.Clear()
            'dtp.Rows.Remove(drp)

            Dim ext As Array = Server.MapPath(FileUpload3.FileName.ToString()).Split(".")
            Dim A_Nombre As String = "cargamat."
            A_Nombre += ext(ext.Length - 1)
            If FileUpload3.HasFile Then
                FileUpload3.SaveAs("c:\directorio\" + A_Nombre)
            End If
            'CargaArchivo(A_Nombre)
            Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & _
          "data source=" & "c:\directorio\" + A_Nombre & ";Extended Properties=Excel 12.0;")

            cnn.Open()
            Dim sqlExcel As String = "Select * From [Materiales$] WHERE [Frecuencia:1,3,6,12]<>0"
            Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
            Dim da As New OleDbDataAdapter(myCommand1)
            Dim dt As New DataTable
            da.Fill(dt)
            Dim sql As String = " select * from Tbl_PorcentajesFamilias where id=1"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dtu As New DataTable
            myCommand.Fill(dtu)
            Dim reg_por As Double = 0
            'reg_por = dtu.Rows(0)("reg_por")

            If dt.Rows.Count > 0 Then
                For j As Integer = 0 To dt.Rows.Count - 1
                    For i As Integer = 0 To dt.Columns.Count - 1
                        If i >= 6 Then
                            Dim cant As Double = dt.Rows(j).Item(i)
                            If IsNumeric(cant) Then
                                If cant > 0 Then
                                    If ViewState("dtuhem") IsNot Nothing Then
                                        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                                        Dim costouni, fre As Double
                                        costouni = dt.Rows(j).Item("Costo")
                                        fre = dt.Rows(j).Item(5)
                                        Dim tipo As Integer = 2
                                        Dim inm As Array = dt.Columns(i).ColumnName.ToString.Split("|")
                                        Dim pieza As Array = dt.Rows(j).Item(2).ToString.Split("|")

                                        dtuhem.Rows.Add(Nothing, inm(0), inm(0) & "|" & inm(1), pieza(1), dt.Rows(j).Item(1), pieza(0), cant, fre, fre, costouni, costouni * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costouni * cant) / fre, inm(0), inm(0) & "|" & inm(1), reg_por)
                                    End If
                                End If
                            End If
                        End If
                    Next

                Next

            End If
            BindGridData(2)
            llenacotizador()
        End If
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
    Protected Sub llenacotizacion(ByVal id As Integer)
        Dim msg As String = ""
        Dim sql As String = "select 'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as folio,* from tbl_Cotizacion where Id_Cotizacion=" & id & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            Dim idcot, version As Integer
            idcot = dt.Rows(0).Item("Cot_Folio")
            version = dt.Rows(0).Item("Cot_Version")

            lblfolio.Text = idcot
            lblver.Text = version
            lblidcot.Text = id
            ddltservicio.SelectedValue = dt.Rows(0).Item("Cot_Id_TipoServicio")
            'lblid.Text = dt.Rows(0).Item("Cot_Id")
            'lbltipo.Text = dt.Rows(0).Item("Cot_Tipo")


            lblcteinfo = "Datos Generales - "
            txtpind.Text = dt.Rows(0).Item("Cot_Por_Indirecto")
            txtutil.Text = dt.Rows(0).Item("Cot_Por_Utilidad")
            txtcomer.Text = dt.Rows(0).Item("Cot_Por_Comercializacion")
            lblid.Text = dt.Rows(0).Item("Cot_Id")
            If dt.Rows(0).Item("Cot_Tipo") = 1 Then
                sql = " select  a.Cte_Fis_Razon_Social,e.IdTpoServicio,a.ID_Cliente,'Cotizacion:" & dt.Rows(0).Item("folio") & "<small> CLAVE : '+ a.Cte_Fis_Clave_Cliente+' CLIENTE : '+a.Cte_Fis_Razon_Social+'	CONTACTO : '+b.Cte_Con_Contacto_Cliente"
                sql += " +' TELEFONO : '+b.Cte_Con_Telefono+ ' EMAIL : '+b.Cte_Con_Mail+' EJECUTIVO : '+c.Per_Nombre+' '+c.Per_Paterno +' TIPO SERVICIO : '+ts_Descripcion+'</small>' AS INFO"
                sql += " from Tbl_Cliente a inner join Tbl_Cliente_Cont b on a.ID_Cliente=b.ID_Cliente inner join Personal c on c.IdPersonal=b.Cte_Con_Ejecutivo"
                sql += " inner join Tbl_Cliente_Ser  d on d.ID_Cliente=a.ID_Cliente inner join Tbl_TipoServicio e on e.IdTpoServicio=d.Cte_Ser_Tipos_Servicios"
                sql += " where a.Id_Cliente = " & lblid.Text & ""
                myCommand = New SqlDataAdapter(sql, myConnection)
                dt = New DataTable
                myCommand.Fill(dt)
                If dt.Rows.Count > 0 Then
                    chkcliente.Checked = True
                    chkprospecto.Checked = False
                    chknuevo.Checked = False
                    txtrs.Text = dt.Rows(0).Item("Cte_Fis_Razon_Social")
                    lblcteinfo += dt.Rows(0).Item("INFO")
                    ddltservicio.SelectedValue = dt.Rows(0).Item("IdTpoServicio")
                    lbltipo.Text = "1"
                Else
                    lblcteinfo = "0"
                    lblid.Text = "0"
                    lbltipo.Text = "0"
                End If
            Else
                sql = "select  ID_Prospecto,'<small>Cotizacion:" & dt.Rows(0).Item("folio") & " PROSPECTO : '+Pros_Razon_Social +' CONTACTO : '+ Pros_Contacto +' TELEFONO : '+Pros_Telefono+ ' EMAIL : '+Pros_Mail+' EJECUTIVO : '+c.Per_Nombre+' '+c.Per_Paterno +' TIPO SERVICIO : '+'" & ddltservicio.SelectedItem.Text & "'+'</small>'AS INFO"
                sql += ",Pros_Razon_Social "
                'sql += " ,isnull(Por_Indirecto,0) Por_Indirecto,isnull(Por_Utilidad,0)Por_Utilidad,isnull(Por_Comercializacion,0)Por_Comercializacion"
                sql += "  from Tbl_Prospecto a inner join Personal c on c.IdPersonal=a.Pros_Ejecutivo"
                sql += "  where ID_Prospecto = " & lblid.Text & ""
                myCommand = New SqlDataAdapter(sql, myConnection)
                dt = New DataTable
                myCommand.Fill(dt)
                If dt.Rows.Count > 0 Then
                    chkcliente.Checked = False
                    chkprospecto.Checked = True
                    chknuevo.Checked = False
                    txtrsp.Text = dt.Rows(0).Item("Pros_Razon_Social")
                    lblcteinfo += dt.Rows(0).Item("INFO")
                    lbltipo.Text = "2"
                Else
                    lblcteinfo = "1"
                    lblid.Text = "0"
                    lbltipo.Text = "2"
                End If
            End If

            Dim script As String
            script = "paso(" & lbltipo.Text & ",'" & msg & "');"
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
            'InitializeDataSource()
            llenaviewconsulta(id, version)
            calculautilidad()
        End If

    End Sub

    Protected Sub llenaviewconsulta(ByVal idcot As Integer, ByVal ver As Integer)

        Dim sql As String = ""
        sql = " select ROW_NUMBER() OVER (ORDER BY ID_Fila) AS fila,Cot_Per_Id_edo as Id_edo,c.Cot_Dir_No_Sucursal+'|'+c.Cot_Dir_Sucursal as estado,Cot_Per_Idpuesto as idpuesto,Cot_Per_Idpuestodet as idpuestodet,Cve_Puesto+'|'+d.Pue_Puesto as puesto,Cot_Per_Idturno as idturno,b.Descripcion as turno,Cot_Per_Idjornal as idjornal,"
        'sql += " case when Cot_Per_Idjornal=1 then '8hrs' when Cot_Per_Idjornal=2 then '4hrs' else '' end jornal,"
        sql += " Cot_Per_Idjornal as jornal,"
        sql += " Cot_Per_cantidad as cantidad, Cot_Per_sueldo / Cot_Per_cantidad as sueldo, Cot_Per_sueldo as sueldotot, Cot_Per_costo as costo, Cot_Per_costo * Cot_Per_cantidad as costot"
        sql += " from Tbl_Cot_Personal a inner join turno b on a.Cot_Per_Idturno=b.Id_Turno "
        'sql += " inner join Estados c on c.Id_Estado= a.cot_per_id_edo "
        sql += " inner join Tbl_Cot_Dir c on a.cot_per_id_edo =c.Cot_Dir_No_Sucursal and c.id_Version=" & ver & ""
        sql += " inner join Tbl_Puesto d on d.ID_Puesto=a.Cot_Per_Idpuesto"
        sql += " where(a.ID_Cotizacion = " & idcot & " And Cot_Version = " & ver & ")"
        sql += " order by c.Cot_Dir_No_Sucursal+'|'+c.Cot_Dir_Sucursal "
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        dt.Columns("fila").AutoIncrement = True
        dt.Columns("fila").AutoIncrementSeed = 1
        dt.Columns("fila").AutoIncrementStep = 1

        Dim dcKeys As DataColumn() = New DataColumn(0) {}
        dcKeys(0) = dt.Columns("fila")
        dt.PrimaryKey = dcKeys
        ViewState("dtp") = dt

        gwp.DataSource = TryCast(ViewState("dtp"), DataTable)
        gwp.DataBind()

        sql = "select ROW_NUMBER() OVER (ORDER BY ID_Fila) AS fila,Cot_MHES_Id as Id,"
        sql += " case when Cot_MHES_tipo =1 then (select Cve_Puesto+'|'+ Pue_Puesto as puesto from Tbl_Puesto a inner join Tbl_PuestoDet b on b.ID_Puesto=a.ID_Puesto and ID_PuestoDet=7) else "
        sql += " (select Cot_Dir_No_Sucursal+'|'+Cot_Dir_Sucursal from Tbl_Cot_Dir where Cot_Dir_No_Sucursal=a.Cot_MHES_Id and ID_Cotizacion=15 and ID_version=10)end IdDesc,"
        sql += " Cot_MHES_Id_Pieza as IdPieza,b.Pza_Clave as cve,b.Pza_DescPieza as cvedesp,Cot_MHES_cantidad as cantidad,"
        sql += " Cot_MHES_idfrecuencia as idfrecuencia,"
        sql += " case when Cot_MHES_tipo in(1,2) then case when Cot_MHES_idfrecuencia=1 then 'Mensual' when Cot_MHES_idfrecuencia=3 then 'Trimestral' when Cot_MHES_idfrecuencia=6 then 'Semestral'"
        sql += " when Cot_MHES_idfrecuencia=12 then 'Anual'  end else convert(nvarchar(10), Cot_MHES_idfrecuencia) end as frecuencia,"
        sql += " Cot_MHES_Costo as Costo,Cot_MHES_Importe as Importe,Cot_MHES_tipo as tipo,Indirecto=0,Utilidad=0,Comercializacion=0,case when  Cot_MHES_tipo=5 then 0 else ((Cot_MHES_Costo * Cot_MHES_cantidad) / Cot_MHES_idfrecuencia) end Impdepreciado, "
        sql += " Cot_MHES_IdRegion as IdRegion,Cot_MHES_DecsRegion as DecsRegion, Cot_MHES_RegionPorc as RegionPorc"
        sql += " FROM         Tbl_Cot_MatHerEqpSE a inner join Tbl_Pieza b on a.Cot_MHES_Id_Pieza =b.IdPieza"
        sql += " where(ID_Cotizacion = " & idcot & " And Cot_Version = " & ver & ")"
        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        dt.Columns("fila").AutoIncrement = True
        dt.Columns("fila").AutoIncrementSeed = 1
        dt.Columns("fila").AutoIncrementStep = 1

        dcKeys = New DataColumn(0) {}
        dcKeys(0) = dt.Columns("fila")
        dt.PrimaryKey = dcKeys

        ViewState("dtuhem") = dt
        'gvuhem.DataSource = ViewState("dtuhem")
        'gvuhem.DataBind()

        sql = "SELECT ROW_NUMBER() OVER (ORDER BY Cot_Dir_No_Sucursal) AS fila,Cot_Dir_No_Sucursal AS NO_SUCURSAL, Cot_Dir_No_Sucursal +'|'+ Cot_Dir_Sucursal AS SUCURSAL, Cot_Dir_Cve_Interna AS CVE_INTERNA, Cot_Dir_Calle AS CALLE, Cot_Dir_Colonia AS COLONIA, Cot_Dir_CP AS CP, "
        sql += " Cot_Dir_Delegacion AS DELEGACION, Cot_Dir_Ciudad AS CIUDAD, Cot_Dir_Estado AS ESTADO, Cot_Dir_Contacto AS CONTACTO, Cot_Dir_Mail AS MAIL, Cot_Dir_Telefono AS TELEFONO"
        sql += " FROM Tbl_Cot_Dir where ID_Cotizacion = " & idcot & " And Id_Version = " & ver & ""
        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        dt.Columns("fila").AutoIncrement = True
        dt.Columns("fila").AutoIncrementSeed = 1
        dt.Columns("fila").AutoIncrementStep = 1

        dcKeys = New DataColumn(0) {}
        dcKeys(0) = dt.Columns("fila")
        dt.PrimaryKey = dcKeys

        ViewState("dtdir") = dt

        BindGridData(0)
        BindGridData(1)
        BindGridData(2)
        BindGridData(3)
        BindGridData(4)
        BindGridData(5)
        BindGridData(6)

    End Sub

    Protected Sub calculautilidad()
        Dim dtres As DataTable = DirectCast(ViewState("dtres"), DataTable)
        If dtres Is Nothing Then
        Else
            If dtres.Rows.Count > 1 Then
                Dim subtot, subtota, subtotind, subtotinda, subutil, subutila, subcomer, subcomera As Double
                lblsubtotal.Text = "$" & Format(dtres.Compute("Sum(PrecioMensual)", "tipo <100"), "#,###,###.00")
                lblsubtotalanual.Text = "$" & Format(dtres.Compute("Sum(PrecioAnual)", "tipo <100"), "#,###,###.00")
                subtot = lblsubtotal.Text
                subtota = lblsubtotalanual.Text
                lblpind.Text = "$" & Format(subtot * (Val(txtpind.Text) / 100), "#,###,###.00")
                lblpindanual.Text = "$" & Format(subtota * (Val(txtpind.Text) / 100), "#,###,###.00")

                lblsubtotalind.Text = "$" & Format(subtot * (1 + (Val(txtpind.Text) / 100)), "#,###,###.00")
                lblsubtotalinda.Text = "$" & Format(subtota * (1 + (Val(txtpind.Text) / 100)), "#,###,###.00")

                subtotind = lblsubtotalind.Text
                subtotinda = lblsubtotalinda.Text

                lblutil.Text = "$" & Format(subtotind * (Val(txtutil.Text) / 100), "#,###,###.00")
                lblutila.Text = "$" & Format(subtotinda * (Val(txtutil.Text) / 100), "#,###,###.00")

                lblsubutil.Text = "$" & Format(subtotind * (1 + (Val(txtutil.Text) / 100)), "#,###,###.00")
                lblsubutila.Text = "$" & Format(subtotinda * (1 + (Val(txtutil.Text) / 100)), "#,###,###.00")

                subutil = lblsubutil.Text
                subutila = lblsubutila.Text


                lblcomer.Text = "$" & Format(subutil * (Val(txtcomer.Text) / 100), "#,###,###.00")
                lblcomera.Text = "$" & Format(subutila * (Val(txtcomer.Text) / 100), "#,###,###.00")

                lblsubcomer.Text = "$" & Format(subutil * (1 + (Val(txtcomer.Text) / 100)), "#,###,###.00")
                lblsubcomera.Text = "$" & Format(subutila * (1 + (Val(txtcomer.Text) / 100)), "#,###,###.00")

                subcomer = lblsubcomer.Text
                subcomera = lblsubcomera.Text
            End If
        End If
    End Sub
    Protected Sub llenaview(ByVal val As Integer)
        Select Case val
            Case 0
                If ViewState("dtp") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtp"), DataTable)
                    Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    dt.Rows.Add(Nothing, ddlinm.SelectedValue, ddlinm.SelectedItem.Text, gral(0), gral(1), ddlpuesto.SelectedItem.Text, ddlturno.SelectedValue, ddlturno.SelectedItem.Text, ddljornal.SelectedValue, ddljornal.SelectedItem.Text, txtcantidad.Text, gral(2), txtcantidad.Text * gral(2), gral(3), txtcantidad.Text * gral(3))
                    BindGridData(0)
                    txtcosto.Text = ""
                    txtcostot.Text = ""
                    txtsueldo.Text = ""
                End If
            Case 1
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    'Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    Dim sql As String = ""
                    sql += "Select IdPieza,Pza_Clave,Pza_Clave,Pza_DescPieza,Pza_PrecioAutorizado ,indirecto,Utilidad,Comercializacion from Tbl_Pieza "
                    sql += "left outer join Tbl_PorcentajesFamilias b on b.id=1 where Pza_Clave ='" & txtclaveuni.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    If dtu.Rows.Count > 0 Then
                        txtdescuni.Text = dtu.Rows(0)("Pza_DescPieza")
                        If txtcostouni.Text = "" Then txtcostouni.Text = dtu.Rows(0)("Pza_PrecioAutorizado")
                    End If
                    Dim costouni, cant, fre As Double
                    costouni = txtcostouni.Text
                    cant = txtcantidaduni.Text
                    fre = ddlfrecuencia.SelectedValue
                    Dim tipo As Integer = 1
                    Dim puesto As Array = ddlpue.SelectedItem.Text.Split("|")

                    dt.Rows.Add(Nothing, ddlpue.SelectedValue, puesto(1) & "|" & puesto(2), dtu.Rows(0)("IdPieza"), txtclaveuni.Text, txtdescuni.Text, txtcantidaduni.Text, ddlfrecuencia.SelectedValue, ddlfrecuencia.SelectedItem.Text, costouni, costouni * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costouni * cant) / fre, 0, "", 0)
                    BindGridData(1)
                    txtclaveuni.Text = ""
                    txtdescuni.Text = ""
                    txtcantidaduni.Text = ""
                    txtcostouni.Text = ""
                    txtimporteuni.Text = ""
                    ddlfrecuencia.SelectedValue = 0
                End If
            Case 2
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    'Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    Dim sql As String = ""
                    sql += "Select IdPieza,Pza_Clave,Pza_Clave,Pza_DescPieza,Pza_PrecioAutorizado ,indirecto,Utilidad,Comercializacion "
                    sql += " ,(select Reg_Por_Porcentaje from Tbl_Region_Porcentaje where Cot_MHES_tipo=2 and id_region=" & ddlregion.SelectedValue & ") as reg_por"
                    sql += " from Tbl_Pieza left outer join Tbl_PorcentajesFamilias b on b.id=2 where Pza_Clave ='" & txtclavemat.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    Dim reg_por As Double = 0
                    If dtu.Rows.Count > 0 Then
                        txtdescmat.Text = dtu.Rows(0)("Pza_DescPieza")
                        If txtcostomat.Text = "" Then txtcostomat.Text = dtu.Rows(0)("Pza_PrecioAutorizado")
                        reg_por = dtu.Rows(0)("reg_por")
                    End If
                    Dim costomat, cant, fre As Double
                    costomat = txtcostomat.Text
                    cant = txtcantidadmat.Text
                    fre = ddlfrecuenciamat.SelectedValue
                    Dim tipo As Integer = 2
                    dt.Rows.Add(Nothing, ddlregion.SelectedValue, ddlregion.SelectedItem.Text, dtu.Rows(0)("IdPieza"), txtclavemat.Text, txtdescmat.Text, txtcantidadmat.Text, ddlfrecuenciamat.SelectedValue, ddlfrecuenciamat.SelectedItem.Text, costomat, costomat * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costomat * cant) / fre, ddlregion.SelectedValue, ddlregion.SelectedItem.Text, reg_por)
                    BindGridData(2)
                    txtclavemat.Text = ""
                    txtdescmat.Text = ""
                    txtcantidadmat.Text = ""
                    txtcostomat.Text = ""
                    txtimportemat.Text = ""
                    ddlfrecuenciamat.SelectedValue = 0
                End If
            Case 3
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    'Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    Dim sql As String = ""
                    sql += "Select IdPieza,Pza_Clave,Pza_Clave,Pza_DescPieza,Pza_PrecioAutorizado,indirecto,Utilidad,Comercializacion  from Tbl_Pieza "
                    sql += " left outer join Tbl_PorcentajesFamilias b on b.id=3 where Pza_Clave ='" & txtclaveher.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    If dtu.Rows.Count > 0 Then
                        txtdescher.Text = dtu.Rows(0)("Pza_DescPieza")
                        If txtcostoher.Text = "" Then txtcostoher.Text = dtu.Rows(0)("Pza_PrecioAutorizado")
                    End If
                    Dim costoher, cant, dep As Double
                    costoher = txtcostoher.Text
                    cant = txtcantidadher.Text
                    dep = txtamorher.Text
                    Dim tipo As Integer = 3
                    dt.Rows.Add(Nothing, dtu.Rows(0)("IdPieza"), txtclaveher.Text, txtdescher.Text, txtcantidadher.Text, txtamorher.Text, txtamorher.Text, costoher, costoher * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costoher * cant) / dep, 0, "", 0)
                    BindGridData(3)
                    txtclaveher.Text = ""
                    txtdescher.Text = ""
                    txtcantidadher.Text = ""
                    txtcostoher.Text = ""
                    txtimporteher.Text = ""
                End If
            Case 4
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    'Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    Dim sql As String = ""
                    sql += "Select IdPieza,Pza_Clave,Pza_Clave,Pza_DescPieza,Pza_PrecioAutorizado ,indirecto,Utilidad,Comercializacion from Tbl_Pieza "
                    sql += " left outer join Tbl_PorcentajesFamilias b on b.id=4 where Pza_Clave ='" & txtclaveeqp.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    If dtu.Rows.Count > 0 Then
                        txtdesceqp.Text = dtu.Rows(0)("Pza_DescPieza")
                        If txtcostoeqp.Text = "" Then txtcostoeqp.Text = dtu.Rows(0)("Pza_PrecioAutorizado")
                    End If
                    Dim costoeqp, cant, dep As Double
                    costoeqp = txtcostoeqp.Text
                    cant = txtcantidadeqp.Text
                    dep = txtamorteqp.Text
                    Dim tipo As Integer = 4
                    dt.Rows.Add(Nothing, dtu.Rows(0)("IdPieza"), txtclaveeqp.Text, txtdesceqp.Text, txtcantidadeqp.Text, txtamorteqp.Text, txtamorteqp.Text, costoeqp, costoeqp * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), (costoeqp * cant) / dep, 0, "", 0)
                    BindGridData(4)
                    txtclaveeqp.Text = ""
                    txtdesceqp.Text = ""
                    txtcantidadeqp.Text = ""
                    txtcostoeqp.Text = ""
                    txtimporteeqp.Text = ""
                End If
            Case 5
                If ViewState("dtuhem") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                    'Dim gral As Array = ddlpuesto.SelectedValue.Split("|")
                    Dim sql As String = ""
                    sql += "Select IdPieza,SAdi_Clave,SAdi_DescPieza,SAdi_PrecioAutorizado ,indirecto,Utilidad,Comercializacion from Tbl_ServiciosAdicionales "
                    sql += " left outer join Tbl_PorcentajesFamilias b on b.id=5 where SAdi_Clave='" & txtclavesa.Text & "' "
                    Dim ds As New SqlDataAdapter(sql, myConnection)
                    Dim dtu As New DataTable
                    ds.Fill(dtu)
                    If dtu.Rows.Count > 0 Then
                        txtdescsa.Text = dtu.Rows(0)("SAdi_DescPieza")
                        If txtcostosa.Text = "" Then txtcostosa.Text = dtu.Rows(0)("SAdi_PrecioAutorizado")
                    End If
                    Dim costosa, cant As Double
                    costosa = txtcostosa.Text
                    cant = txtcantidadsa.Text
                    Dim tipo As Integer = 5
                    dt.Rows.Add(Nothing, dtu.Rows(0)("IdPieza"), txtclavesa.Text, txtdescsa.Text, txtcantidadsa.Text, 0, "", costosa, costosa * cant, tipo, dtu.Rows(0)("Indirecto"), dtu.Rows(0)("Utilidad"), dtu.Rows(0)("Comercializacion"), 0, 0, "", 0)
                    BindGridData(5)
                    txtclavesa.Text = ""
                    txtdescsa.Text = ""
                    txtcantidadsa.Text = ""
                    txtcostosa.Text = ""
                    txtimportesa.Text = ""
                End If
            Case 6
                If ViewState("dtdir") IsNot Nothing Then
                    Dim dt As DataTable = DirectCast(ViewState("dtdir"), DataTable)
                    dt.Rows.Add(Nothing, txtnsuc.Text, txtsuc.Text, txtcvei.Text, txtcalle.Text, txtcol.Text, txtcp.Text, txtdel.Text, txtcd.Text, ddlestado.SelectedValue, ddlestado.SelectedItem.Text, txtcon.Text, TextBox1.Text, TextBox2.Text)
                    BindGridData(6)
                    txtnsuc.Text = ""
                    txtsuc.Text = ""
                    txtcvei.Text = ""
                    txtcalle.Text = ""
                    txtcol.Text = ""
                    txtcp.Text = ""
                    txtdel.Text = ""
                    txtcd.Text = ""
                    txtcon.Text = ""
                    TextBox1.Text = ""
                    TextBox2.Text = ""
                End If
        End Select
    End Sub

    Private Sub InitializeDataSource()
        Dim dtp As New DataTable()
        dtp.Columns.Add("fila")
        dtp.Columns.Add("Id_edo")
        dtp.Columns.Add("estado")
        dtp.Columns.Add("idpuesto")
        dtp.Columns.Add("idpuestodet")
        dtp.Columns.Add("puesto")
        dtp.Columns.Add("idturno")
        dtp.Columns.Add("turno")
        dtp.Columns.Add("idjornal")
        dtp.Columns.Add("jornal")
        dtp.Columns.Add("cantidad", GetType(Double))
        dtp.Columns.Add("sueldo", GetType(Double))
        dtp.Columns.Add("sueldotot", GetType(Double))
        dtp.Columns.Add("costo", GetType(Double))
        dtp.Columns.Add("costot", GetType(Double))

        dtp.Columns("fila").AutoIncrement = True
        dtp.Columns("fila").AutoIncrementSeed = 1
        dtp.Columns("fila").AutoIncrementStep = 1

        Dim dcKeys As DataColumn() = New DataColumn(0) {}
        dcKeys(0) = dtp.Columns("fila")
        dtp.PrimaryKey = dcKeys
        ViewState("dtp") = dtp


        Dim dtuhem As New DataTable()
        dtuhem.Columns.Add("fila")
        dtuhem.Columns.Add("Id")
        dtuhem.Columns.Add("Iddesc")
        dtuhem.Columns.Add("IdPieza")
        dtuhem.Columns.Add("cve")
        dtuhem.Columns.Add("cvedesp")
        dtuhem.Columns.Add("cantidad", GetType(Double))
        dtuhem.Columns.Add("idfrecuencia")
        dtuhem.Columns.Add("frecuencia")
        dtuhem.Columns.Add("Costo", GetType(Double))
        dtuhem.Columns.Add("Importe", GetType(Double))
        dtuhem.Columns.Add("tipo")
        dtuhem.Columns.Add("Indirecto")
        dtuhem.Columns.Add("Utilidad")
        dtuhem.Columns.Add("Comercializacion")
        dtuhem.Columns.Add("Impdepreciado", GetType(Double))
        dtuhem.Columns.Add("IdRegion")
        dtuhem.Columns.Add("descRegion")
        dtuhem.Columns.Add("RegionPorc", GetType(Double))

        dtuhem.Columns("fila").AutoIncrement = True
        dtuhem.Columns("fila").AutoIncrementSeed = 1
        dtuhem.Columns("fila").AutoIncrementStep = 1

        Dim dcuhemKeys As DataColumn() = New DataColumn(0) {}
        dcuhemKeys(0) = dtuhem.Columns("fila")
        dtuhem.PrimaryKey = dcuhemKeys
        ViewState("dtuhem") = dtuhem


        Dim dtdir As New DataTable()
        dtdir.Columns.Add("fila")
        dtdir.Columns.Add("no_Sucursal")
        dtdir.Columns.Add("sucursal")
        dtdir.Columns.Add("Cve_Interna")
        dtdir.Columns.Add("calle")
        dtdir.Columns.Add("Colonia")
        dtdir.Columns.Add("CP")
        dtdir.Columns.Add("Delegacion")
        dtdir.Columns.Add("Ciudad")
        dtdir.Columns.Add("IdEstado")
        dtdir.Columns.Add("Estado")
        dtdir.Columns.Add("Contacto")
        dtdir.Columns.Add("Mail")
        dtdir.Columns.Add("Telefono")

        dtdir.Columns("fila").AutoIncrement = True
        dtdir.Columns("fila").AutoIncrementSeed = 1
        dtdir.Columns("fila").AutoIncrementStep = 1

        Dim dcdirKeys As DataColumn() = New DataColumn(0) {}
        dcdirKeys(0) = dtdir.Columns("fila")
        dtdir.PrimaryKey = dcdirKeys
        ViewState("dtdir") = dtdir


    End Sub
    Protected Sub BindGridData(ByVal val As Integer)
        Select Case val
            Case 0
                gwp.DataSource = TryCast(ViewState("dtp"), DataTable)
                gwp.DataBind()
                Dim dt As DataTable = DirectCast(ViewState("dtp"), DataTable)
                llenapue()
            Case 1
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                vstuhem.RowFilter = "tipo=1"
                vstuhem.Sort = "Iddesc"
                gvuhem.DataSource = vstuhem
                gvuhem.DataBind()
            Case 2
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                vstuhem.RowFilter = "tipo=2"
                gwm.DataSource = vstuhem
                gwm.DataBind()
            Case 3
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                vstuhem.RowFilter = "tipo=3"
                gwh.DataSource = vstuhem
                gwh.DataBind()
            Case 4
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                vstuhem.RowFilter = "tipo=4"
                gwe.DataSource = vstuhem
                gwe.DataBind()
            Case 5
                Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
                Dim vstuhem As New DataView(dtuhem)
                vstuhem.RowFilter = "tipo=5"
                gwsa.DataSource = vstuhem
                gwsa.DataBind()
            Case 6
                Dim dtdir As DataTable = DirectCast(ViewState("dtdir"), DataTable)
                Dim vstdir As New DataView(dtdir)
                'vstuhem.RowFilter = "tipo=5"
                gwdirdat.DataSource = vstdir
                gwdirdat.DataBind()
                llenainm()
        End Select
        llenacotizador()
    End Sub


    Protected Sub gwp_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwp.SelectedIndexChanged
        If ViewState("dtp") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtp"), DataTable)
            Dim strtintaID As String = gwp.SelectedDataKey("fila")
            'Dim drp As Integer = dtp.Rows.Find(strtintaID)
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            BindGridData(0)
            Dim script As String
            script = "continuar(2);"
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        End If

    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        llenaview(0)
        txtcantidad.Text = ""
        Dim script As String
        script = "continuar(2);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()
    End Sub

    Protected Sub gvuhem_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvuhem.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gvuhem.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            Select Case gvuhem.SelectedDataKey("tipo")
                Case 1
                    BindGridData(1)
                    script = "continuar(3);"
            End Select
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
            llenacotizador()

        End If

    End Sub

    Protected Sub btnuni_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnuni.Click
        llenaview(1)
        txtcantidaduni.Text = ""
        Dim script As String
        script = "continuar(3);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()

    End Sub
    Protected Sub btnmat_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnmat.Click
        llenaview(2)
        txtcantidadmat.Text = ""
        Dim script As String
        script = "continuar(4);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()

    End Sub
    Protected Sub btnher_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnher.Click
        llenaview(3)
        txtcantidadher.Text = ""
        Dim script As String
        script = "continuar(5);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()

    End Sub
    Protected Sub btneqp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btneqp.Click
        llenaview(4)
        txtcantidadeqp.Text = ""
        Dim script As String
        script = "continuar(6);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()

    End Sub
    Protected Sub btnsa_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnsa.Click
        llenaview(5)
        txtcantidadsa.Text = ""
        Dim script As String
        script = "continuar(7);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()

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
                    script = "continuar(4);"
            End Select
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

        End If
        llenacotizador()

    End Sub
    Protected Sub gwh_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwh.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gwh.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            Select Case gwh.SelectedDataKey("tipo")
                Case 3
                    BindGridData(3)
                    script = "continuar(5);"
            End Select
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

        End If
        llenacotizador()

    End Sub
    Protected Sub gwe_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwe.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gwe.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            Select Case gwe.SelectedDataKey("tipo")
                Case 4
                    BindGridData(4)
                    script = "continuar(6);"
            End Select
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

        End If
        llenacotizador()

    End Sub
    Protected Sub gwsa_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwsa.SelectedIndexChanged
        If ViewState("dtuhem") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            Dim strtintaID As String = gwsa.SelectedDataKey("fila")
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            Dim script As String = ""
            Select Case gwsa.SelectedDataKey("tipo")
                Case 5
                    BindGridData(5)
                    script = "continuar(7);"
            End Select
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

        End If
        llenacotizador()

    End Sub

    Protected Sub txtcomer_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtcomer.TextChanged
        calculautilidad()
        txtcomer.Focus()
        Dim Script As String = "continuar(8);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
    End Sub

    Protected Sub txtutil_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtutil.TextChanged
        calculautilidad()
        txtcomer.Focus()
        Dim Script As String = "continuar(8);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
    End Sub

    Protected Sub txtpind_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtpind.TextChanged
        calculautilidad()
        txtutil.Focus()
        Dim Script As String = "continuar(8);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
    End Sub
    Protected Sub llenacotizador()
        Dim dtres1 As DataTable = DirectCast(ViewState("dtres"), DataTable)
        If Not dtres1 Is Nothing Then
            If dtres1.Rows.Count > 0 Then
                dtres1 = Nothing

            End If
        End If

        Dim dtres As New DataTable()
        dtres.Columns.Add("fila")
        dtres.Columns.Add("Concepto")
        dtres.Columns.Add("Cantidad")
        dtres.Columns.Add("CostoMensual", GetType(Double))
        dtres.Columns.Add("CostoAnual", GetType(Double))
        dtres.Columns.Add("PrecioMensual", GetType(Double))
        dtres.Columns.Add("PrecioAnual", GetType(Double))
        dtres.Columns.Add("tipo")

        dtres.Columns("fila").AutoIncrement = True
        dtres.Columns("fila").AutoIncrementSeed = 1
        dtres.Columns("fila").AutoIncrementStep = 1

        Dim dcresKeys As DataColumn() = New DataColumn(0) {}
        dcresKeys(0) = dtres.Columns("fila")
        dtres.PrimaryKey = dcresKeys
        ViewState("dtres") = dtres


        Dim dtdir As DataTable = DirectCast(ViewState("dtdir"), DataTable)

        If Not IsDBNull(dtdir.Compute("COUNT(No_Sucursal)", "fila > 0")) Then dtres.Rows.Add(Nothing, "Inmuebles", dtdir.Compute("COUNT(No_Sucursal)", "fila > 0"), Nothing, Nothing, Nothing, Nothing, 0)


        Dim dtp As DataTable = DirectCast(ViewState("dtp"), DataTable)
        '  Dim Cantidad, CostoMensual, CostoAnual, PrecioMensual, PrecioAnual As Double
        '  Cantidad = dtp.Compute("Sum(cantidad", "fila > 0")
        '  CostoMensual = dtp.Compute("Sum(sueldotot)", "fila > 0")
        '  CostoAnual = dtp.Compute("Sum(sueldotot)", "fila > 0")
        '  PrecioMensual = dtp.Compute("Sum(costot)", "fila > 0")
        '  PrecioAnual = dtp.Compute("Sum(costot)", "fila > 0")

        'muestradetalleproceso(Request.Params("__EVENTARGUMENT"))

        If Not IsDBNull(dtp.Compute("Sum(cantidad)", "fila > 0")) Then dtres.Rows.Add(Nothing, "Personal", dtp.Compute("Sum(cantidad)", "fila > 0"), dtp.Compute("Sum(sueldotot)", "fila > 0"), dtp.Compute("Sum(sueldotot)", "fila > 0") * 12, dtp.Compute("Sum(costot)", "fila > 0"), dtp.Compute("Sum(costot)", "fila > 0") * 12, 0)

        Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =1")) Then dtres.Rows.Add(Nothing, "Uniformes", dtuhem.Compute("Sum(cantidad)", "tipo =1"), dtuhem.Compute("Sum(Costo)", "tipo =1"), dtuhem.Compute("Sum(Costo)", "tipo =1") * 12, dtuhem.Compute("Sum(Impdepreciado)", "tipo =1"), dtuhem.Compute("Sum(Impdepreciado)", "tipo =1") * 12, 1)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =2")) Then dtres.Rows.Add(Nothing, "Materiales", dtuhem.Compute("Sum(cantidad)", "tipo =2"), dtuhem.Compute("Sum(Costo)", "tipo =2"), dtuhem.Compute("Sum(Costo)", "tipo =2") * 12, dtuhem.Compute("Sum(Impdepreciado)", "tipo =2"), dtuhem.Compute("Sum(Impdepreciado)", "tipo =2") * 12, 2)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =3")) Then dtres.Rows.Add(Nothing, "Herramientas", dtuhem.Compute("Sum(cantidad)", "tipo =3"), dtuhem.Compute("Sum(Costo)", "tipo =3"), dtuhem.Compute("Sum(Costo)", "tipo =3") * 12, dtuhem.Compute("Sum(Impdepreciado)", "tipo =3"), dtuhem.Compute("Sum(Impdepreciado)", "tipo =3") * 12, 3)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =4")) Then dtres.Rows.Add(Nothing, "Equipos", dtuhem.Compute("Sum(cantidad)", "tipo =4"), dtuhem.Compute("Sum(Costo)", "tipo =4"), dtuhem.Compute("Sum(Costo)", "tipo =4") * 12, dtuhem.Compute("Sum(Impdepreciado)", "tipo =4"), dtuhem.Compute("Sum(Impdepreciado)", "tipo =4") * 12, 4)
        If Not IsDBNull(dtuhem.Compute("Sum(cantidad)", "tipo =5")) Then dtres.Rows.Add(Nothing, "Servicios Adicionales", dtuhem.Compute("Sum(cantidad)", "tipo =5"), dtuhem.Compute("Sum(Costo)", "tipo =5"), dtuhem.Compute("Sum(Costo)", "tipo =5") * 12, dtuhem.Compute("Sum(Importe)", "tipo =5"), dtuhem.Compute("Sum(Importe)", "tipo =5") * 12, 5)
        gwpropuesta.DataSource = dtres
        gwpropuesta.DataBind()
        If dtres.Rows.Count > 0 Then
            calculautilidad()
        Else
            lblsubtotal.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalanual.Text = "$" & Format(0, "#,###,###.00")
            lblpind.Text = "$" & Format(0, "#,###,###.00")
            lblpindanual.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalind.Text = "$" & Format(0, "#,###,###.00")
            lblsubtotalinda.Text = "$" & Format(0, "#,###,###.00")
            lblutil.Text = "$" & Format(0, "#,###,###.00")
            lblutila.Text = "$" & Format(0, "#,###,###.00")
            lblsubutil.Text = "$" & Format(0, "#,###,###.00")
            lblsubutila.Text = "$" & Format(0, "#,###,###.00")
            lblcomer.Text = "$" & Format(0, "#,###,###.00")
            lblcomera.Text = "$" & Format(0, "#,###,###.00")
            lblsubcomer.Text = "$" & Format(0, "#,###,###.00")
            lblsubcomera.Text = "$" & Format(0, "#,###,###.00")
        End If

    End Sub

    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click
        Dim dtres As DataTable = DirectCast(ViewState("dtres"), DataTable)
        If dtres.Rows.Count > 0 Then
            Dim dtp As DataTable = DirectCast(ViewState("dtp"), DataTable)
            dtp.TableName = "personal"
            Dim dtuhem As DataTable = DirectCast(ViewState("dtuhem"), DataTable)
            dtuhem.TableName = "uhem"
            Dim dtdir As DataTable = DirectCast(ViewState("dtdir"), DataTable)
            dtdir.TableName = "dir"
            Dim ds As New DataSet
            ds.Tables.Add(dtp)
            ds.Tables.Add(dtuhem)
            ds.Tables.Add(dtdir)

            If lbltipo.Text = 3 Then
                Dim sql As String = ""
                sql = "select RS = '" & txtrs.Text & "', CONTACTO ='" & txtcontacto.Text & "',TELEFONO ='" & txttel.Text & "',cel='',"
                sql += " EMAIL ='" & txtcontacto.Text & "', EJECUTIVO =" & ddlejecutivo.SelectedValue & ""
                Dim dsd As New SqlDataAdapter(sql, myConnection)
                Dim dtpros As New DataTable
                dsd.Fill(dtpros)
                dtpros.TableName = "pros"
                ds.Tables.Add(dtpros)
            End If
            Dim strxml As String = ds.GetXml()
            If Not IsNumeric(lblidcot.Text) Then lblidcot.Text = 0
            Dim subtot As Double = lblsubtotal.Text
            'If myConnection.State = ConnectionState.Closed Then myConnection.Open()
            'Dim Ejecuta As String = "EXEC spXMLCotizacion '" & strxml & "'," & lblidcot.Text & "," & lbltipo.Text & "," & lblid.Text & "," & ddltservicio.SelectedValue & ","
            'Ejecuta += " " & ddlejecutivo.SelectedValue & "," & subtot & "," & txtpind.Text & "," & txtutil.Text & "," & txtcomer.Text & ""
            'Dim myCommand2 As New SqlCommand(Ejecuta, myConnection)
            'myCommand2.CommandTimeout = 0
            'myCommand2.ExecuteNonQuery()
            'myConnection.Close()


            Dim cmd As SqlCommand = New SqlCommand("spXMLCotizacion", myConnection)
            cmd.Connection = myConnection
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add(New SqlParameter("@XML", SqlDbType.Xml))
            cmd.Parameters.Add(New SqlParameter("@idusu", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@id_cot", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@tipo", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@id", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@ts", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@ejecu", SqlDbType.Int))
            cmd.Parameters.Add(New SqlParameter("@subt", SqlDbType.Money))
            cmd.Parameters.Add(New SqlParameter("@ind", SqlDbType.Decimal))
            cmd.Parameters.Add(New SqlParameter("@uti", SqlDbType.Decimal))
            cmd.Parameters.Add(New SqlParameter("@comer", SqlDbType.Decimal))

            Dim fol As SqlParameter = cmd.Parameters.Add(New SqlParameter("@fol", SqlDbType.Int))
            Dim version As SqlParameter = cmd.Parameters.Add(New SqlParameter("@version", SqlDbType.Int))
            Dim idcot As SqlParameter = cmd.Parameters.Add(New SqlParameter("@idcot", SqlDbType.Int))

            cmd.Parameters("@XML").Value = strxml
            cmd.Parameters("@idusu").Value = Session("v_usuario")
            cmd.Parameters("@id_cot").Value = lblidcot.Text
            cmd.Parameters("@tipo").Value = lbltipo.Text
            cmd.Parameters("@id").Value = lblid.Text
            cmd.Parameters("@ts").Value = ddltservicio.SelectedValue
            cmd.Parameters("@ejecu").Value = ddlejecutivo.SelectedValue
            cmd.Parameters("@subt").Value = subtot
            cmd.Parameters("@ind").Value = txtpind.Text
            cmd.Parameters("@uti").Value = txtutil.Text
            cmd.Parameters("@comer").Value = txtcomer.Text

            cmd.Parameters("@fol").Value = 0
            cmd.Parameters("@version").Value = 0
            cmd.Parameters("@idcot").Value = 0
            fol.Direction = ParameterDirection.Output
            version.Direction = ParameterDirection.Output
            idcot.Direction = ParameterDirection.Output
            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
            cmd.ExecuteNonQuery()

            lblfolio.Text = Int32.Parse(cmd.Parameters("@fol").Value.ToString())
            lblver.Text = Int32.Parse(cmd.Parameters("@version").Value.ToString())
            lblidcot.Text = Int32.Parse(cmd.Parameters("@idcot").Value.ToString())

        End If
    End Sub

    Protected Sub gwdirdat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwdirdat.SelectedIndexChanged
        If ViewState("dtdir") IsNot Nothing Then
            Dim dtp As DataTable = DirectCast(ViewState("dtdir"), DataTable)
            Dim strtintaID As String = gwdirdat.SelectedDataKey("fila")
            'Dim drp As Integer = dtp.Rows.Find(strtintaID)
            Dim drp As DataRow = dtp.Rows.Find(strtintaID)
            dtp.Rows.Remove(drp)
            BindGridData(6)
            Dim script As String
            script = "continuar(9);"
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        End If


    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button3.Click
        llenaview(6)
        Dim script As String
        script = "continuar(9);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)
        llenacotizador()
        script = "cargadat(3);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub

    Protected Sub Button4_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button4.Click
     


    End Sub

    Protected Sub Button6_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button6.Click
        Dim Script As String = "continuar(9);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
    End Sub
End Class
