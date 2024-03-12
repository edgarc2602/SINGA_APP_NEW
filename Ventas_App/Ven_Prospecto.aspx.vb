Imports System.Data
Imports System.Data.SqlClient

Partial Class Ventas_App_Ven_Prospecto
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
            lblid.Text = "0"
            consultaprospecto()
        End If


        If Not IsPostBack Then
            Dim Sql As String = " SELECT    IdPersonal, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre as personal"
            Sql += " FROM Personal where per_status=0 and IdArea=2 and Per_Puesto like '%Ejecu%venta%'"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            ddlejecutivo.DataSource = dt
            ddlejecutivo.DataTextField = "personal"
            ddlejecutivo.DataValueField = "IdPersonal"
            ddlejecutivo.DataBind()
            ddlejecutivo.Items.Add(New ListItem("Sel. el ejecutivo...", 0, True))
            ddlejecutivo.SelectedValue = 0


            'ddlejecutivo.Items.Add(New ListItem("Seleccione...", 0, True))
            'ddlejecutivo.Items.Add(New ListItem("Barbara Villafan", 2, True))
            ddlstatus.Items.Add(New ListItem("Seleccione...", 0, True))
            ddlstatus.Items.Add(New ListItem("Activo", 1, True))
            ddlstatus.Items.Add(New ListItem("Baja", 2, True))
            ddlstatus.Items.Add(New ListItem("Cliente", 3, True))


            'consultaprospecto()
            InitializeDataSource()
            BindGridData()
        End If
    End Sub
    Protected Sub consultaprospecto()
        Dim dt As New DataTable()
        Dim sql As String = "select 0 as Id,ID_Prospecto,Pros_Razon_Social as Razon_Social,Pros_Contacto as Contacto,Pros_Telefono as Telefono,Pros_Celular as Celular,"
        sql += " Pros_Mail as Mail,case when Pros_Ejecutivo = 1 then 'Barbara Villafan' else ''  end Ejecutivo,Pros_Ejecutivo,"
        sql += " case when Pros_Estatus =1 then 'Activo' when Pros_Estatus =2 then 'Baja' else 'Baja' end Estatus ,Pros_Estatus  from tbl_prospecto "
        Dim ds As New SqlDataAdapter(sql, myConnection)
        ds.Fill(dt)
        ViewState("dt") = dt
        BindGridData()
    End Sub
    Private Sub InitializeDataSource()
        Dim dtprospecto As New DataTable()

        dtprospecto.Columns.Add("Id")
        dtprospecto.Columns.Add("Id_Prospecto")
        dtprospecto.Columns.Add("Razon_Social")
        dtprospecto.Columns.Add("Contacto")
        dtprospecto.Columns.Add("Telefono")
        dtprospecto.Columns.Add("Celular")
        dtprospecto.Columns.Add("correo")
        dtprospecto.Columns.Add("Ejecutivo")
        dtprospecto.Columns.Add("Estatus")

        dtprospecto.Columns("Id").AutoIncrement = True
        dtprospecto.Columns("Id").AutoIncrementSeed = 1
        dtprospecto.Columns("Id").AutoIncrementStep = 1

        Dim dcKeys As DataColumn() = New DataColumn(0) {}
        dcKeys(0) = dtprospecto.Columns("Id")
        dtprospecto.PrimaryKey = dcKeys
        ViewState("dt") = dtprospecto
        Dim dt As DataTable = DirectCast(ViewState("dt"), DataTable)
        consultaprospecto()
        'llenaview(0, 1, "Famarmacias similares s.a. de c.v.", "Lorena Hernandez", "58-38-20-00", "044-55-58-38-20-00", "ljhb25@hotmial.com", "Barbara", "1")
        'llenaview(0, "Universidad s.a. de c.v.", "Rolando Gutierrez", "58-38-20-00", "044-55-58-38-20-00", "ljhb25@hotmial.com", "Barbara")

    End Sub


    Protected Sub BindGridData()
        GridView1.DataSource = TryCast(ViewState("dt"), DataTable)
        GridView1.DataBind()
    End Sub
    Protected Sub llenaview(ByVal id As Integer, ByVal idpros As Integer, ByVal Razon_Social As String, ByVal Contacto As String, ByVal Telefono As String, ByVal Celular As String, ByVal Correo As String, ByVal IdEjecutivo As String, ByVal Idstatus As String)
        If ViewState("dt") IsNot Nothing Then
            Dim dt As DataTable = DirectCast(ViewState("dt"), DataTable)

            dt.Rows.Add(Nothing, idpros, Razon_Social, Contacto, Telefono, Celular, Correo, IdEjecutivo, Idstatus)
            BindGridData()
        End If

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
        Dim dt As DataTable = DirectCast(ViewState("dt"), DataTable)
        Dim vst As New DataView(dt)
        vst.RowFilter = "Id_Prospecto=" & GridView1.SelectedDataKey("Id_Prospecto") & " "
        lblidc.Text = 0
        txtrs.Text = vst.Item(0).Item("Razon_Social")
        txtcontacto.Text = vst.Item(0).Item("Contacto")
        txttel.Text = vst.Item(0).Item("Telefono")
        If Not IsDBNull(vst.Item(0).Item("Celular")) Then txtcel.Text = vst.Item(0).Item("Celular")
        txtmail.Text = vst.Item(0).Item("mail")
        lblid.Text = vst.Item(0).Item("Id_Prospecto")
        'ddlejecutivo.SelectedValue = vst.Item(0).Item("Pros_Ejecutivo")
        ddlstatus.SelectedValue = vst.Item(0).Item("Pros_Estatus")
        Dim sql As String = "SELECT * FROM Tbl_Cliente WHERe ID_Prospecto = " & lblid.Text & ""
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)
        If ds.Tables(0).Rows.Count > 0 Then
            lblidc.Text = ds.Tables(0).Rows(0).Item("ID_Cliente")
        End If
        BindGridData()
        'Dim script As String
        'script = "muestra();"
        'ScriptManager.RegisterStartupScript(Me, GetType(Page), "callform", script, True)

    End Sub
    Protected Sub graba(ByVal datosg As String)
        Dim datos As Array = datosg.Split("#")
        Dim Sql As String = ""
        If datos(7) = 0 Then
            Sql = "Insert into Tbl_Prospecto values ('" & datos(0) & "','" & datos(1) & "','" & datos(2) & "','" & datos(3) & "','" & datos(4) & "'," & datos(5) & "," & datos(6) & ")"
        Else
            Sql = " update Tbl_Prospecto set Pros_Razon_Social='" & datos(0) & "',Pros_Contacto='" & datos(1) & "',Pros_Telefono='" & datos(2) & "',"
            Sql += " Pros_Celular='" & datos(3) & "',Pros_Mail='" & datos(4) & "',Pros_Ejecutivo=" & datos(5) & ",Pros_Estatus=" & datos(6) & ""
            Sql += " where ID_Prospecto =" & datos(7) & ""
        End If
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataSet
        myCommand.Fill(ds)

        'If ViewState("dt") IsNot Nothing Then
        ' Dim dt As DataTable = DirectCast(ViewState("dt"), DataTable)
        ' dt.Rows.Add(Nothing, datos(7), datos(0), datos(1), datos(2), datos(3), datos(4), datos(5), datos(6))
        ' BindGridData()
        ' End If
        consultaprospecto()
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click

        Dim datos As String
        datos = txtrs.Text & "#" & txtcontacto.Text & "#" & txttel.Text & "#" & txtcel.Text & "#" & txtmail.Text & "#" & ddlejecutivo.SelectedValue & "#" & ddlstatus.SelectedValue & "#" & lblid.Text
        graba(datos)
    End Sub
End Class
