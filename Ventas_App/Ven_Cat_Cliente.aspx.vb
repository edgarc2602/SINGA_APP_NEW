Imports System.Data
Imports System.Data.SqlClient

Partial Class Ventas_App_Ven_Cat_Cliente
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labelmenu As String = "
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'janx: revisar siempre carga el menu en cada pagina?
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "importa"

                Dim sql As String = "select ID_Cotizacion,case when cot_tipo=1 then 'Cliente' else 'Prospecto' end Tipo"
                sql += ",case when cot_tipo=1 then (select Cte_Fis_Nombre_Comercial from Tbl_Cliente where ID_Cliente=cot_id)"
                sql += "else (select Pros_Razon_Social from Tbl_Prospecto where ID_Prospecto=a.cot_id) end razonsocial"
                sql += ",'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as folio ,"
                sql += " case when Cot_Estatus=0 then 'Alta' when Cot_Estatus=1 then 'Autorizada' when Cot_Estatus=2 then 'Cancelada' end estatus"
                sql += ",b.TS_Descripcion,Cot_Subtotal,Cot_Subtotal*(1+(Cot_Por_Indirecto/100)) as [C/Indirecto]"
                sql += ",(Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100))as [C/Utilidad]"
                sql += ",((Cot_Subtotal*(1+(Cot_Por_Indirecto/100)))*(1+(Cot_Por_Utilidad/100)))*(1+(Cot_Por_Comercializacion/100))as [C/Comer],Cot_Estatus,Cot_Documento "
                sql += "from tbl_Cotizacion a inner join Tbl_TipoServicio b on b.IdTpoServicio=a.Cot_Id_TipoServicio"
                sql += "  where(cot_estatus >= 0) and a.Cot_Id_TipoServicio=" & ddltservicio.SelectedValue & "
                sql += " and ((cot_tipo=3 and cot_id=" & txtidp.Text & ")or (cot_tipo=1 and cot_id=" & txtid.Text & ") )"

                'If IsNumeric(txtidp.Text) Then sql += " and (cat_tipo=3 and cot_id=" & txtidp.Text & ")"
                'If IsNumeric(txtid.Text) Then sql += " and (cat_tipo=1 and cot_id=" & txtidp.Text & ")"
                Dim ds As New SqlDataAdapter(sql, myConnection)
                Dim dtu As New DataTable
                ds.Fill(dtu)
                If dtu.Rows.Count > 0 Then
                    gvData.DataSource = dtu
                    gvData.DataBind()
                Else
                    gvData.DataSource = Nothing
                    gvData.DataBind()
                End If
                Dim Script As String = "muestra(5);"
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)
                '    Case "importadatos"
                '        Response.Write("<script>alert('Mensaje enviado s" & gvData.SelectedDataKey("ID_Cotizacion") & "atisfactoriamente');</script>")
        End Select
        If Not IsPostBack Then
            Dim Sql1 As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            Sql1 += " FROM Personal where per_status=0 and IdArea=2 and Per_Puesto like '%Ejecu%venta%'"
            Dim myCommand1 As New SqlDataAdapter(Sql1, myConnection)
            Dim dt1 As New DataTable
            myCommand1.Fill(dt1)
            ddlejecutivo.DataSource = dt1
            ddlejecutivo.DataTextField = "personal"
            ddlejecutivo.DataValueField = "IdPersonal"
            ddlejecutivo.DataBind()
            ddlejecutivo.Items.Add(New ListItem("Sel. el ejecutivo...", 0, True))
            ddlejecutivo.SelectedValue = 0

            'ddlejecutivo.Items.Add(New ListItem("Seleccione...", 0, True))
            'ddlejecutivo.Items.Add(New ListItem("Barbara Villafan", 1, True))
            If Request("idp") <> Nothing Then
                Dim sql As String = "select 0 as Id,ID_Prospecto,Pros_Razon_Social as Razon_Social,Pros_Contacto as Contacto,Pros_Telefono as Telefono,Pros_Celular as Celular,"
                sql += " Pros_Mail as Mail,Pros_Ejecutivo,Pros_Estatus  from tbl_prospecto where Id_Prospecto=" & Request("idp") & "
                Dim ds As New SqlDataAdapter(sql, myConnection)
                Dim dt As New DataTable()
                ds.Fill(dt)
                If dt.Rows.Count > 0 Then
                    txtidp.Text = dt.Rows(0).Item("Id_Prospecto")
                    txtidp.Enabled = False
                    txtestatus.Text = "Alta"
                    txtrs.Text = dt.Rows(0).Item("Razon_Social")
                    txtncomercial.Text = dt.Rows(0).Item("Razon_Social")
                    txttel.Text = dt.Rows(0).Item("Telefono")
                    If Not IsDBNull(dt.Rows(0).Item("Celular")) Then txtcel.Text = dt.Rows(0).Item("Celular")
                    ddlejecutivo.SelectedValue = dt.Rows(0).Item("Pros_Ejecutivo")
                End If
            End If
            InitializeDataSource()
            BindGridData()
        End If
    End Sub
    Private Sub InitializeDataSource()
        Dim dt_cte As New DataTable()

        dt_cte.Columns.Add("ID")
        dt_cte.Columns.Add("ID_Cliente")
        dt_cte.Columns.Add("ID_Prospecto")
        dt_cte.Columns.Add("Cte_Fis_Clave_Cliente")
        dt_cte.Columns.Add("Cte_Fis_Razon_Social")
        dt_cte.Columns.Add("Cte_Fis_Nombre_Comercial")
        dt_cte.Columns.Add("Cte_Fis_Tipo")
        dt_cte.Columns.Add("Cte_Fis_RFC")
        dt_cte.Columns.Add("Cte_Fis_Telefono")
        dt_cte.Columns.Add("Cte_Fis_Celular")
        dt_cte.Columns.Add("Cte_Fis_Domicilio_Fiscal")
        dt_cte.Columns.Add("Cte_Fis_Representante_Legal")
        dt_cte.Columns.Add("Cte_Con_Contacto_Cliente")
        dt_cte.Columns.Add("Cte_Con_Ejecutivo")
        dt_cte.Columns.Add("Cte_Con_Mail")
        dt_cte.Columns.Add("Cte_Con_Telefono")
        dt_cte.Columns.Add("Cte_Con_Celular")
        dt_cte.Columns.Add("Cte_Con_Domicilio")
        dt_cte.Columns.Add("Cte_Con_Fecha_Firma")
        dt_cte.Columns.Add("Cte_Con_Vigencia")
        dt_cte.Columns.Add("Cte_Fac_Contacto_Cliente")
        dt_cte.Columns.Add("Cte_Fac_Importe_de_Facturacion")
        dt_cte.Columns.Add("Cte_Fac_Mail")
        dt_cte.Columns.Add("Cte_Fac_Telefono")
        dt_cte.Columns.Add("Cte_Fac_Celular")
        dt_cte.Columns.Add("Cte_Fac_Dias_pago")
        dt_cte.Columns.Add("Cte_Fac_Dias_Credito")
        dt_cte.Columns.Add("Cte_Fac_Mes_corriente")
        dt_cte.Columns.Add("Cte_Fac_Mes_anticipado")
        dt_cte.Columns.Add("Cte_Fac_Mes_vencido")
        dt_cte.Columns.Add("Cte_Ser_Encargado_Servicio")
        dt_cte.Columns.Add("Cte_Ser_Fecha_Inicio")
        dt_cte.Columns.Add("Cte_Ser_Mail")
        dt_cte.Columns.Add("Cte_Ser_Telefono")
        dt_cte.Columns.Add("Cte_Ser_Celular")
        dt_cte.Columns.Add("Cte_Ser_Tipos_Servicios")
        dt_cte.Columns.Add("Cte_Ser_Observaciones")
        dt_cte.Columns("Id").AutoIncrement = True
        dt_cte.Columns("Id").AutoIncrementSeed = 1
        dt_cte.Columns("Id").AutoIncrementStep = 1

        Dim dcKeys As DataColumn() = New DataColumn(0) {}
        dcKeys(0) = dt_cte.Columns("Id")
        dt_cte.PrimaryKey = dcKeys
        ViewState("dtcliente") = dt_cte
        Dim dt As DataTable = DirectCast(ViewState("dtcliente"), DataTable)

    End Sub
    Protected Sub BindGridData()
        Dim sql As String = "select a.ID_Cliente as Id,a.ID_Cliente,ID_Prospecto,Cte_Fis_Clave_Cliente,Cte_Fis_Razon_Social,Cte_Fis_Nombre_Comercial,Cte_Fis_Tipo,Cte_Fis_RFC,Cte_Fis_Telefono,Cte_Fis_Celular,Cte_Fis_Domicilio_Fiscal,Cte_Fis_Representante_Legal"
        sql += " ,Cte_Con_Contacto_Cliente,Cte_Con_Ejecutivo,Cte_Con_Mail,Cte_Con_Telefono,Cte_Con_Celular,Cte_Con_Domicilio,Cte_Con_Fecha_Firma,Cte_Con_Vigencia"
        sql += " ,Cte_Fac_Contacto_Cliente,Cte_Fac_Importe_de_Facturacion,Cte_Fac_Mail,Cte_Fac_Telefono,Cte_Fac_Celular,Cte_Fac_Dias_pago,Cte_Fac_Dias_Credito,Cte_Fac_Mes_corriente,Cte_Fac_Mes_anticipado,Cte_Fac_Mes_vencido"
        sql += " ,Cte_Ser_Encargado_Servicio,Cte_Ser_Fecha_Inicio,Cte_Ser_Mail,Cte_Ser_Telefono,Cte_Ser_Celular,Cte_Ser_Tipos_Servicios,Cte_Ser_Observaciones"
        sql += " from Tbl_Cliente a left outer join Tbl_Cliente_Cont b on b.ID_Cliente=a.ID_Cliente"
        sql += " left outer join Tbl_Cliente_Fac c on c.ID_Cliente=a.ID_Cliente"
        sql += " left outer join Tbl_Cliente_Ser d on d.ID_Cliente=a.ID_Cliente"
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable()
        ds.Fill(dt)
        'GridView1.DataSource = TryCast(ViewState("dtcliente") , DataTable)
        ViewState("dtcliente") = dt

        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub
    Protected Sub llenaview(ByVal ID As Integer, ByVal ID_Cliente As Integer, ByVal ID_Prospecto As Integer, ByVal Cte_Fis_Clave_Cliente As String, ByVal Cte_Fis_Razon_Social As String, ByVal Cte_Fis_Nombre_Comercial As String, ByVal Cte_Fis_Tipo As Integer, ByVal Cte_Fis_RFC As String _
                            , ByVal Cte_Fis_Telefono As String, ByVal Cte_Fis_Celular As String, ByVal Cte_Fis_Domicilio_Fiscal As String, ByVal Cte_Fis_Representante_Legal As String, ByVal Cte_Con_Contacto_Cliente As String, ByVal Cte_Con_Ejecutivo As String, ByVal Cte_Con_Mail As String _
                            , ByVal Cte_Con_Telefono As String, ByVal Cte_Con_Celular As String, ByVal Cte_Con_Domicilio As String, ByVal Cte_Con_Fecha_Firma As Date, ByVal Cte_Con_Vigencia As String, ByVal Cte_Fac_Contacto_Cliente As String, ByVal Cte_Fac_Importe_de_Facturacion As Double _
                            , ByVal Cte_Fac_Mail As String, ByVal Cte_Fac_Telefono As String, ByVal Cte_Fac_Celular As String, ByVal Cte_Fac_Dias_pago As String, ByVal Cte_Fac_Dias_Credito As String, ByVal Cte_Fac_Mes_corriente As Integer, ByVal Cte_Fac_Mes_anticipado As Integer, ByVal Cte_Fac_Mes_vencido As Integer _
                            , ByVal Cte_Ser_Encargado_Servicio As String, ByVal Cte_Ser_Fecha_Inicio As Date, ByVal Cte_Ser_Mail As String, ByVal Cte_Ser_Telefono As String, ByVal Cte_Ser_Celular As String, ByVal Cte_Ser_Tipos_Servicios As Integer, ByVal Cte_Ser_Observaciones As String)
        'janx: revisión de como actualizar las vistas, utilizar mvc
        If ViewState("dtcliente") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("dtcliente"), DataTable)

            dt.Rows.Add(Nothing, ID_Cliente, ID_Prospecto, Cte_Fis_Clave_Cliente, Cte_Fis_Razon_Social, Cte_Fis_Nombre_Comercial, Cte_Fis_Tipo, Cte_Fis_RFC _
                            , Cte_Fis_Telefono, Cte_Fis_Celular, Cte_Fis_Domicilio_Fiscal, Cte_Fis_Representante_Legal, Cte_Con_Contacto_Cliente, Cte_Con_Ejecutivo, Cte_Con_Mail _
                            , Cte_Con_Telefono, Cte_Con_Celular, Cte_Con_Domicilio, Cte_Con_Fecha_Firma, Cte_Con_Vigencia, Cte_Fac_Contacto_Cliente, Cte_Fac_Importe_de_Facturacion _
                            , Cte_Fac_Mail, Cte_Fac_Telefono, Cte_Fac_Celular, Cte_Fac_Dias_pago, Cte_Fac_Dias_Credito, Cte_Fac_Mes_corriente, Cte_Fac_Mes_anticipado, Cte_Fac_Mes_vencido _
                            , Cte_Ser_Encargado_Servicio, Cte_Ser_Fecha_Inicio, Cte_Ser_Mail, Cte_Ser_Telefono, Cte_Ser_Celular, Cte_Ser_Tipos_Servicios, Cte_Ser_Observaciones)
            BindGridData()
        End If
    End Sub
    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        Dim dt As DataTable = DirectCast(ViewState("dtcliente"), DataTable)
        Dim vst As New DataView(dt)
        vst.RowFilter = "Id=" & GridView1.SelectedDataKey("Id") & " "
        txtid.Text = vst.Item(0).Item("ID_Cliente")
        txtidp.Text = vst.Item(0).Item("ID_Prospecto")
        txtclave.Text = vst.Item(0).Item("Cte_Fis_Clave_Cliente")
        txtrs.Text = vst.Item(0).Item("Cte_Fis_Razon_Social")
        txtncomercial.Text = vst.Item(0).Item("Cte_Fis_Nombre_Comercial")
        ddltipo.SelectedValue = vst.Item(0).Item("Cte_Fis_Tipo")
        txtrfc.Text = vst.Item(0).Item("Cte_Fis_RFC")
        txttel.Text = vst.Item(0).Item("Cte_Fis_Telefono")
        txtcel.Text = vst.Item(0).Item("Cte_Fis_Celular")
        TextBox1.Text = vst.Item(0).Item("Cte_Fis_Domicilio_Fiscal")
        TextBox2.Text = vst.Item(0).Item("Cte_Fis_Representante_Legal")
        txt.Text = vst.Item(0).Item("Cte_Con_Contacto_Cliente")
        ddlejecutivo.SelectedValue = vst.Item(0).Item("Cte_Con_Ejecutivo")
        txtmail.Text = vst.Item(0).Item("Cte_Con_Mail")
        txttelc.Text = vst.Item(0).Item("Cte_Con_Telefono")
        txtcelc.Text = vst.Item(0).Item("Cte_Con_Celular")
        txtdomc.Text = vst.Item(0).Item("Cte_Con_Domicilio")
        If Not IsDBNull(vst.Item(0).Item("Cte_Con_Fecha_Firma")) Then txtfecfirma.Text = vst.Item(0).Item("Cte_Con_Fecha_Firma")
        txtvig.Text = vst.Item(0).Item("Cte_Con_Vigencia")
        txtconfac.Text = vst.Item(0).Item("Cte_Fac_Contacto_Cliente")
        txtMonto.Text = vst.Item(0).Item("Cte_Fac_Importe_de_Facturacion")
        txtmailfac.Text = vst.Item(0).Item("Cte_Fac_Mail")
        txtcelfac.Text = vst.Item(0).Item("Cte_Fac_Telefono")
        txtcelfac.Text = vst.Item(0).Item("Cte_Fac_Celular")
        txtdpago.Text = vst.Item(0).Item("Cte_Fac_Dias_pago")
        txtdcred.Text = vst.Item(0).Item("Cte_Fac_Dias_Credito")
        chkmcor.Checked = vst.Item(0).Item("Cte_Fac_Mes_corriente")
        chkmant.Checked = vst.Item(0).Item("Cte_Fac_Mes_anticipado")
        chkven.Checked = vst.Item(0).Item("Cte_Fac_Mes_vencido")
        txteser.Text = vst.Item(0).Item("Cte_Ser_Encargado_Servicio")
        If Not IsDBNull(vst.Item(0).Item("Cte_Ser_Fecha_Inicio")) Then txtfecini.Text = vst.Item(0).Item("Cte_Ser_Fecha_Inicio")
        txtmailser.Text = vst.Item(0).Item("Cte_Ser_Mail")
        txttelser.Text = vst.Item(0).Item("Cte_Ser_Telefono")
        txtcelser.Text = vst.Item(0).Item("Cte_Ser_Celular")
        ddltservicio.SelectedValue = vst.Item(0).Item("Cte_Ser_Tipos_Servicios")
        txtobs.Text = vst.Item(0).Item("Cte_Ser_Observaciones")


        BindGridData()
        'Dim script As String
        'script = "muestra();"
        'ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        'janx: mover los eventos al cliente, solo son para llamar un control?
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("OnClick", "oculta('" & GridView1.DataKeys(e.Row.DataItemIndex)("RFC") & "');")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(GridView1, "Select$" & e.Row.RowIndex.ToString())
        End Select
    End Sub
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim Sql As String = "
        Dim id As Integer = 0
        Dim fecha As Date
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet

        If IsNumeric(txtid.Text) Then
            id = txtid.Text
        End If
        If id = 0 Then
            'janx: cajas de texto enviadas desde el cliente, revisar sql injection
            Sql = "Insert into Tbl_Cliente (ID_Prospecto,Cte_Fis_Clave_Cliente,Cte_Fis_Razon_Social,Cte_Fis_Nombre_Comercial,Cte_Fis_Tipo,Cte_Fis_RFC"
            Sql += " ,Cte_Fis_Telefono,Cte_Fis_Celular,Cte_Fis_Domicilio_Fiscal,Cte_Fis_Representante_Legal)"
            Sql += " values (" & txtidp.Text & ",'" & txtclave.Text & "','" & txtrs.Text & "','" & txtncomercial.Text & "'," & ddltipo.SelectedValue & ",'" & txtrfc.Text & "',"
            Sql += "'" & txttel.Text & "','" & txtcel.Text & "','" & TextBox1.Text & "','" & TextBox2.Text & "')"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            'janx: utilizar scope_identity() en lugar de max, evitar conflicto multiusuarios
            Sql = "Select max(Id_Cliente) as idcliente from Tbl_Cliente "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            If IsDate(txtfecfirma.Text) Then fecha = txtfecfirma.Text
            txtid.Text = ds.Tables(0).Rows(0).Item("Idcliente")
            Sql = "Insert into Tbl_Cliente_Cont (ID_Cliente,Cte_Con_Contacto_Cliente,Cte_Con_Ejecutivo,Cte_Con_Mail,Cte_Con_Telefono,"
            Sql += " Cte_Con_Celular,Cte_Con_Domicilio,Cte_Con_Fecha_Firma,Cte_Con_Vigencia)"
            Sql += " values (" & txtid.Text & ",'" & txt.Text & "'," & ddltipo.SelectedValue & ",'" & txtmail.Text & "','" & txttelc.Text & "',"
            Sql += " '" & txtcelc.Text & "','" & txtdomc.Text & "',Null,'" & txtvig.Text & "')"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            Sql = "Insert into Tbl_Cliente_Fac (ID_Cliente,Cte_Fac_Contacto_Cliente,Cte_Fac_Importe_de_Facturacion,Cte_Fac_Mail,Cte_Fac_Telefono,"
            Sql += " Cte_Fac_Celular,Cte_Fac_Dias_pago,Cte_Fac_Dias_Credito,Cte_Fac_Mes_corriente,Cte_Fac_Mes_anticipado,Cte_Fac_Mes_vencido)"
            Sql += " values (" & txtid.Text & ",'" & txtconfac.Text & "',0,'" & txtmailfac.Text & "','" & txttelfac.Text & "',"
            Sql += " '" & txtcelfac.Text & "','" & txtdpago.Text & "','" & txtdcred.Text & "',0,0,0)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)

            Sql = "Insert into Tbl_Cliente_Ser (ID_Cliente,Cte_Ser_Encargado_Servicio,Cte_Ser_Fecha_Inicio,Cte_Ser_Mail,Cte_Ser_Telefono,"
            Sql += " Cte_Ser_Celular,Cte_Ser_Tipos_Servicios,Cte_Ser_Observaciones)"
            Sql += " values (" & txtid.Text & ",'" & txteser.Text & "',Null,'" & txtmailser.Text & "','" & txttelser.Text & "',"
            Sql += " '" & txtcelser.Text & "',0,'" & txtobs.Text & "')"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)


        Else
            Sql = " update Tbl_Cliente set ID_Prospecto=" & txtidp.Text & ",Cte_Fis_Clave_Cliente='" & txtclave.Text & "',Cte_Fis_Razon_Social='" & txtrs.Text & "',"
            Sql += " Cte_Fis_Nombre_Comercial='" & txtncomercial.Text & "',Cte_Fis_Tipo=" & ddltipo.SelectedValue & ",Cte_Fis_RFC='" & txtrfc.Text & "'"
            Sql += " ,Cte_Fis_Telefono='" & txttel.Text & "',Cte_Fis_Celular='" & txtcel.Text & "',Cte_Fis_Domicilio_Fiscal='" & TextBox1.Text & "',Cte_Fis_Representante_Legal='" & TextBox2.Text & "'"
            Sql += " where ID_Cliente =" & id & "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)

            Sql = " update Tbl_Cliente_Cont set Cte_Con_Contacto_Cliente='" & txt.Text & "',Cte_Con_Ejecutivo=" & ddlejecutivo.SelectedValue & "
            Sql += " ,Cte_Con_Mail='" & txtmail.Text & "',Cte_Con_Telefono='" & txttelc.Text & "',Cte_Con_Celular='" & txtcelc.Text & "'"
            Sql += ",Cte_Con_Domicilio='" & txtdomc.Text & "',Cte_Con_Vigencia='" & txtvig.Text & "'"
            If IsDate(txtfecfirma.Text) Then Sql += ", Cte_Con_Fecha_Firma='" & txtfecfirma.Text & "'"
            Sql += " where ID_Cliente =" & id & "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            If txtMonto.Text = " Then txtMonto.Text = 0
            Sql = " update Tbl_Cliente_Fac set Cte_Fac_Contacto_Cliente='" & txtconfac.Text & "',Cte_Fac_Importe_de_Facturacion=" & txtMonto.Text & "
            Sql += " ,Cte_Fac_Mail='" & txtmailfac.Text & "',Cte_Fac_Telefono='" & txttelfac.Text & "',Cte_Fac_Celular='" & txtcelfac.Text & "',"
            Sql += " Cte_Fac_Dias_pago ='" & txtdpago.Text & "',Cte_Fac_Dias_Credito='" & txtdcred.Text & "'"
            If chkmcor.Checked = True Then Sql += " ,Cte_Fac_Mes_corriente=1"
            If chkmant.Checked = True Then Sql += " ,Cte_Fac_Mes_anticipado=1"
            If chkven.Checked = True Then Sql += " ,Cte_Fac_Mes_vencido=1"
            Sql += " where ID_Cliente =" & id & "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)


            Sql = " update Tbl_Cliente_Ser set Cte_Ser_Encargado_Servicio='" & txteser.Text & "',"
            If IsDate(txtfecini.Text) Then Sql += " Cte_Ser_Fecha_Inicio='" & txtfecini.Text & "',"
            Sql += " Cte_Ser_Mail='" & txtmailser.Text & "', Cte_Ser_Telefono='" & txttelser.Text & "',Cte_Ser_Celular='" & txtcelser.Text & "'"
            Sql += ",Cte_Ser_Tipos_Servicios=" & ddltservicio.SelectedValue & ",Cte_Ser_Observaciones='" & txtobs.Text & "'"
            Sql += " where ID_Cliente =" & id & "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If
        BindGridData()
        'If ViewState("dtcliente")  IsNot Nothing Then
        ' Dim dt As DataTable = DirectCast(ViewState("dtcliente") , DataTable)
        ' dt.Rows.Add(Nothing, datos(7), datos(0), datos(1), datos(2), datos(3), datos(4), datos(5), datos(6))
        ' BindGridData()
        ' End If

    End Sub

    Protected Sub gvData_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvData.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("onclick", ClientScript.GetPostBackClientHyperlink(Me.GridView3, "Select$" + e.Row.RowIndex.ToString()))
                'Dim ctrlSel As Button = CType(e.Row.Cells(5).Controls(0), Button)
                'ctrlSel.OnClientClick = "importadatos();"

                'Dim ctrlSel As Button = CType(e.Row.Cells(5).Controls(0), Button)
                ''ctrlSel.OnClientClick = "return Confirmacion(" & dt.Rows(0).Item("Column1") & ");"
                'ctrlSel.OnClientClick = "return confirm('Esta Orden de produccion ya ha sido facturada con el folio(s): . ¿Desea Continuar?')"
        End Select
    End Sub

    Protected Sub gvData_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvData.SelectedIndexChanged
        ' Response.Write("<script>alert('Mensaje enviado s" & gvData.SelectedDataKey("ID_Cotizacion") & "atisfactoriamente');</script>")
        Dim Sql As String = "EXEC [spImportaDir] " & gvData.SelectedDataKey("ID_Cotizacion") & "," & txtid.Text & "
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dsd As New DataSet
        myCommand.Fill(dsd)
        Dim Script As String = "muestra(1);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", Script, True)

    End Sub
    Protected Sub TextBox1_TextChanged(sender As Object, e As EventArgs) Handles TextBox1.TextChanged

    End Sub
End Class
