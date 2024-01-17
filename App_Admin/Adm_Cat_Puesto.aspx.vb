Imports System.Data
Imports System.Data.SqlClient
Partial Class Admin_App_Adm_Cat_Puesto
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
        If Request.Params("__EVENTTARGET") = "limpia" Then
            limpia()
        End If

        If Not IsPostBack Then
            BindGridData()
        End If
    End Sub
    Protected Sub limpia()
        txtidc.Text = ""
        txtclave.Text = ""
        txtPuesto.Text = ""
        txtsm.Text = ""
        txtpp.Text = ""
        txtpa.Text = ""
        txtdesp.Text = ""
        txtte.Text = ""
        txtbono.Text = ""
        txtpext.Text = ""
        txtptot.Text = ""
        txtImss.Text = ""
        txtinfonavit.Text = ""
        txtrcv.Text = ""
        txtimpnom.Text = ""
        txtcstot.Text = ""
        txtctot.Text = ""
        txtaguinaldo.Text = ""
        txtvac.Text = ""
        txtpvac.Text = ""
        txttgf.Text = ""
        txtsubt.Text = ""

    End Sub
    Protected Sub BindGridData()
        Dim sql As String = "select a.ID_Puesto as Id,Cve_Puesto as Clave,Pue_Puesto as Puesto,case when a.Pue_Estatus=0 then 'Activo' else 'Baja' end Estatus "
        sql += " ,b.pue_sueldomensual as[Sueldo Mensual] ,b.pue_cuotaIMSSSM+b.Pue_CuotaINFONAVITSM+b.Pue_CuotaRCVSM+b.Pue_ImpuestoNomina as [Carga Social]"
        sql += " ,b.Pue_SubTotalEmpleado as [S.Total Empleado]"
        sql += " from Tbl_Puesto a left outer join Tbl_Puestodet b on b.id_puesto=a.ID_Puesto and b.pue_estatus=0"
        'If IsNumeric(txtidc.Text) Then If txtidc.Text <> 0 Then sql += " where(ID_Cliente = " & txtidc.Text & ")"
        Dim ds As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable()
        ds.Fill(dt)
        ViewState("dtpuesto") = dt

        GridView1.DataSource = dt
        GridView1.DataBind()
    End Sub

    Protected Sub txtsm_TextChanged(sender As Object, e As System.EventArgs) Handles txtsm.TextChanged
        calculasalario(0)
        txtpp.Focus()
    End Sub

    Protected Sub txtpp_TextChanged(sender As Object, e As System.EventArgs) Handles txtpp.TextChanged
        calculasalario(1)
        txtpa.Focus()
    End Sub
    Protected Sub txtpa_TextChanged(sender As Object, e As System.EventArgs) Handles txtpa.TextChanged
        calculasalario(2)
        txtdesp.Focus()
    End Sub

    Protected Sub txtdesp_TextChanged(sender As Object, e As System.EventArgs) Handles txtdesp.TextChanged
        calculasalario(3)
        txtte.Focus()
    End Sub

    Protected Sub txtte_TextChanged(sender As Object, e As System.EventArgs) Handles txtte.TextChanged
        calculasalario(4)
        txtbono.Focus()
    End Sub

    Protected Sub txtbono_TextChanged(sender As Object, e As System.EventArgs) Handles txtbono.TextChanged
        calculasalario(5)
        txtpext.Focus()
    End Sub

    Protected Sub txtpext_TextChanged(sender As Object, e As System.EventArgs) Handles txtpext.TextChanged
        calculasalario(6)
        txtImss.Focus()
    End Sub

    Protected Sub txtptot_TextChanged(sender As Object, e As System.EventArgs) Handles txtptot.TextChanged
        calculasalario(7)
    End Sub

    Protected Sub txtImss_TextChanged(sender As Object, e As System.EventArgs) Handles txtImss.TextChanged
        calculasalario(8)
        txtinfonavit.Focus()
    End Sub

    Protected Sub txtinfonavit_TextChanged(sender As Object, e As System.EventArgs) Handles txtinfonavit.TextChanged
        calculasalario(9)
        txtrcv.Focus()
    End Sub

    Protected Sub txtrcv_TextChanged(sender As Object, e As System.EventArgs) Handles txtrcv.TextChanged
        calculasalario(10)
    End Sub

    Protected Sub txtimpnom_TextChanged(sender As Object, e As System.EventArgs) Handles txtimpnom.TextChanged
        calculasalario(11)
    End Sub
    Protected Sub calculasalario(ByVal paso As Integer)
        If IsNumeric(txtsm.Text) Then
            Dim sm As Double = txtsm.Text
            Dim pp As Double = 0
            If paso >= 1 Then pp = txtpp.Text Else pp = Format(sm * 0.1, "#.00")
            txtpp.Text = pp
            Dim pa As Double = 0
            If paso >= 2 Then pa = txtpa.Text Else pa = Format(sm * 0.1, "#.00")
            txtpa.Text = pa
            Dim despensa As Double = 0
            If paso >= 3 Then despensa = txtdesp.Text Else despensa = Format(sm * 0.4, "#.00")
            txtdesp.Text = despensa

            Dim tiempoe As Double = 0
            Dim bono As Double = 0
            Dim presextra As Double = 0
            Dim Totalsalario As Double = 0
            If IsNumeric(txtte.Text) Then tiempoe = txtte.Text Else txtte.Text = 0
            If IsNumeric(txtbono.Text) Then bono = txtbono.Text Else txtbono.Text = 0
            If IsNumeric(txtpext.Text) Then presextra = txtpext.Text Else txtpext.Text = 0
            Totalsalario = Format(sm + pp + pa + despensa + tiempoe + bono + presextra, "#.00")
            txtptot.Text = Totalsalario
            'calculo Carga social
            Dim cimss As Double = 0
            If paso >= 8 Then cimss = txtImss.Text Else cimss = Format((sm * 1.0452) * 0.28, "#.00")
            txtImss.Text = cimss
            Dim cinfo As Double = 0
            If paso >= 9 Then cinfo = txtinfonavit.Text Else cinfo = Format((sm * 1.0452) * 0.05, "#.00")
            txtinfonavit.Text = cinfo
            Dim rcv As Double = 0
            If paso >= 10 Then rcv = txtrcv.Text Else rcv = Format((sm * 1.0452) * 0.06, "#.00")
            txtrcv.Text = rcv
            Dim impnom As Double = 0
            If paso >= 11 Then impnom = txtimpnom.Text Else impnom = Format((Totalsalario * 0.025), "#.00")
            txtimpnom.Text = impnom
            txtcstot.Text = Format(cimss + cinfo + rcv + impnom, "###,###,###,###.00")
            Dim totcs As Double = Format(cimss + cinfo + rcv + impnom + Totalsalario, "###,###,###,###.00")
            txtctot.Text = totcs
            'calculo Provisiones
            Dim aguinaldo As Double = Format((((Totalsalario / 30) * 15) / 365) * 30, "#.00")
            txtaguinaldo.Text = aguinaldo
            Dim vac As Double = Format((((Totalsalario / 30) * 6) / 12), "#.00")
            txtvac.Text = vac
            Dim privac As Double = Format((vac * 0.25) / 12, "#.00")
            txtpvac.Text = privac
            txttgf.Text = aguinaldo + vac + privac
            txtsubt.Text = aguinaldo + vac + privac + totcs
        End If
    End Sub

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        graba(0)
    End Sub

    Protected Sub graba(ByVal datosg As String)
        Dim datos As Array = datosg.Split("#")
        Dim Sql As String = ""
        Dim id As Integer = 0
        Dim fecha As Date = Date.Today
        If IsNumeric(txtidc.Text) Then id = txtidc.Text
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet

        If id = 0 Then
            Sql = "Insert into Tbl_Puesto values ('" & txtclave.Text & "','" & txtPuesto.Text & "','',0)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            Sql = "select MAX(ID_Puesto) as id from Tbl_Puesto "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
            id = ds.Tables(0).Rows(0).Item("id")
            txtidc.Text = id
        Else
            Sql = " update Tbl_Puesto set Cve_puesto='" & txtclave.Text & "',pue_puesto='" & txtPuesto.Text & "',Pue_Estatus=" & ddlstatus.SelectedValue & ""
            Sql += " where ID_Puesto =" & id & ""
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)

            Sql = "Update Tbl_PuestoDet set Pue_Estatus=1 where ID_Puesto=" & id & ""
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataSet
            myCommand.Fill(ds)
        End If

        Sql = "Insert into Tbl_PuestoDet ( ID_Puesto, Pue_SueldoMensual, Pue_PPuntialidad, Pue_PAsistencia, Pue_Despensa, Pue_TiempoExtra"
        Sql += " ,Pue_Bono,Pue_OtraPrestacion, Pue_CuotaIMSSSM, Pue_CuotaINFONAVITSM,"
        Sql += " Pue_CuotaRCVSM, Pue_ImpuestoNomina, Pue_TotalCostoFijo, Pue_SubTotalEmpleado, Pue_FechaMod, Pue_Estatus) "
        Sql += " values (" & id & "," & txtsm.Text & "," & txtpp.Text & "," & txtpa.Text & "," & txtdesp.Text & "," & txtte.Text & ","
        Sql += " " & txtbono.Text & "," & txtpext.Text & "," & txtImss.Text & "," & txtinfonavit.Text & ","
        Sql += " " & txtrcv.Text & "," & txtimpnom.Text & "," & txtctot.Text & "," & txtsubt.Text & ",'" & fecha & "',0)"
        myCommand = New SqlDataAdapter(Sql, myConnection)
        ds = New DataSet
        myCommand.Fill(ds)
        BindGridData()
        'consultaprospecto()
    End Sub

    Protected Sub GridView1_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
                ' e.Row.Attributes.Add("OnClick", "oculta('" & GridView1.DataKeys(e.Row.DataItemIndex)("RFC") & "');")
                e.Row.Attributes("OnClick") = Page.ClientScript.GetPostBackClientHyperlink(GridView1, "Select$" & e.Row.RowIndex.ToString())
        End Select
    End Sub

    Protected Sub GridView1_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles GridView1.SelectedIndexChanged
        limpia()
        Dim dt As DataTable = DirectCast(ViewState("dt"), DataTable)
        Dim vst As New DataView(dt)
        vst.RowFilter = "Id=" & GridView1.SelectedDataKey("Id") & " "
        Dim sql As String = "select a.*,b.*"
        sql += " from Tbl_Puesto a left outer join Tbl_Puestodet b on b.id_puesto=a.ID_Puesto and b.pue_estatus=0"
        sql += " where a.ID_Puesto =" & GridView1.SelectedDataKey("Id") & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)

        txtidc.Text = ds.Tables(0).Rows(0).Item("ID_Puesto")
        txtclave.Text = ds.Tables(0).Rows(0).Item("Cve_Puesto")
        txtPuesto.Text = ds.Tables(0).Rows(0).Item("Pue_Puesto")
        ddlstatus.SelectedValue = ds.Tables(0).Rows(0).Item("Pue_Puesto")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_SueldoMensual")) Then txtsm.Text = ds.Tables(0).Rows(0).Item("Pue_SueldoMensual")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_PPuntialidad")) Then txtpp.Text = ds.Tables(0).Rows(0).Item("Pue_PPuntialidad")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_PAsistencia")) Then txtpa.Text = ds.Tables(0).Rows(0).Item("Pue_PAsistencia")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_Despensa")) Then txtdesp.Text = ds.Tables(0).Rows(0).Item("Pue_Despensa")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_TiempoExtra")) Then txtte.Text = ds.Tables(0).Rows(0).Item("Pue_TiempoExtra")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_Bono")) Then txtbono.Text = ds.Tables(0).Rows(0).Item("Pue_Bono")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_OtraPrestacion")) Then txtpext.Text = ds.Tables(0).Rows(0).Item("Pue_OtraPrestacion")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_CuotaIMSSSM")) Then txtImss.Text = ds.Tables(0).Rows(0).Item("Pue_CuotaIMSSSM")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_CuotaINFONAVITSM")) Then txtinfonavit.Text = ds.Tables(0).Rows(0).Item("Pue_CuotaINFONAVITSM")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_CuotaRCVSM")) Then txtrcv.Text = ds.Tables(0).Rows(0).Item("Pue_CuotaRCVSM")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_ImpuestoNomina")) Then txtimpnom.Text = ds.Tables(0).Rows(0).Item("Pue_ImpuestoNomina")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_TotalCostoFijo")) Then txtcstot.Text = ds.Tables(0).Rows(0).Item("Pue_TotalCostoFijo")
        If Not IsDBNull(ds.Tables(0).Rows(0).Item("Pue_SubTotalEmpleado")) Then txtctot.Text = ds.Tables(0).Rows(0).Item("Pue_SubTotalEmpleado")
        calculasalario(11)
        BindGridData()

    End Sub
End Class
