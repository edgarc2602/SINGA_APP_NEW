Imports System.Data
Imports System.Data.SqlClient
Imports Newtonsoft.Json
'Imports RH_Conexion
'Imports dnConexion
'Imports WSConsume
Imports System.Net
Imports System.Net.Mail

Partial Class RH_RS_AltaAspirante
    Inherits System.Web.UI.Page
     Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public pros As Integer
    Dim s As String = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.ShortDatePattern
    Dim fecha As DateTime = DateTime.Now.ToUniversalTime().ToString(s)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Session("v_usuario") = 901
        'Session("v_empresa") = 1
        'Session("v_plaza") = 22
        'Response.Write(Session("v_usuario"))

        If Not Page.IsPostBack Then

            CargaDrop()
            TextBox37.Text = 78.51
            TextBox38.Text = 82.06
            lbnoempleado.Visible = False
            txnoempleado.Visible = False

            Select Case Request("tipo")
                Case 0
                    llenareq(Request("Plantilla"))
                    Cabecera.Text = "Registro de Aspirantes"
                    ImageButton3.Visible = False
                Case 1
                    Cabecera.Text = "Completar contratación de Aspirante"
                    llenaempleado(Request("Empleado"))
                Case 2
                    llenareq(Request("Plantilla"))
                    Cabecera.Text = "Contratación Directa"
                Case 3
                    Cabecera.Text = "Datos Generales del Empleado"
                    llenaempleado(Request("Empleado"))
                    'ImageButton6.ToolTip = "Datos de Salario"
            End Select
            'ImageButton6.Attributes.Add("OnClick", "Sueldo(" & Label66.Text & ");")
            'ImageButton11.Attributes.Add("OnClick", "Modal();")
        End If
    End Sub
    Protected Sub CargaDrop()
        Dim sql As String = "Select Id_Estado, estado from Estados order by estado "
        Dim mycommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataSet
        mycommand.Fill(ds)
        If ds.Tables(0).Rows.Count > 0 Then
            OboutDropDownList1.DataSource = ds
            OboutDropDownList1.DataTextField = "estado"
            OboutDropDownList1.DataValueField = "Id_Estado"
            OboutDropDownList1.DataBind()
            OboutDropDownList1.Items.Add(New ListItem("Seleccione...", 0, True))
            OboutDropDownList1.SelectedValue = 0
        End If
        ds.Clear()
        sql = "SELECT id_banco,banco FROM Tbl_bancos where status =0"
        mycommand = New SqlDataAdapter(sql, myConnection)
        ds = New DataSet
        'mycommand.Fill(ds)     
        DropDownList7.DataSource = ds
        DropDownList7.DataTextField = "banco"
        DropDownList7.DataValueField = "Id_banco"
        'DropDownList7.DataBind()
        DropDownList7.Items.Add(New ListItem("Seleccione...", 0, True))
        DropDownList7.SelectedValue = 0
        ds.Clear()
        sql = "SELECT Id_TipoNomina FROM Tbl_TipoNomina"
        mycommand = New SqlDataAdapter(sql, myConnection)
        ds = New DataSet
        'mycommand.Fill(ds)
        DropDownList5.DataSource = ds
        DropDownList5.DataTextField = "Id_TipoNomina"
        DropDownList5.DataValueField = "Id_TipoNomina"
        'DropDownList5.DataBind()
        DropDownList5.Items.Add(New ListItem("Seleccione...", 0, True))
        DropDownList5.SelectedValue = 0
        ds.Clear()
        sql = "SELECT Id_RegPat, REGISTROPAT FROM Tbl_RegPatronal order by REGISTROPAT"
        mycommand = New SqlDataAdapter(sql, myConnection)
        ds = New DataSet
        'mycommand.Fill(ds)
        DropDownList6.DataSource = ds
        DropDownList6.DataTextField = "REGISTROPAT"
        DropDownList6.DataValueField = "Id_RegPat"
        'DropDownList6.DataBind()
        DropDownList6.Items.Add(New ListItem("Seleccione...", 0, True))
        DropDownList6.SelectedValue = 0

        DlFormaPago0.Items.Add(New ListItem("Seleccione...", 0, True))
        DlFormaPago0.Items.Add(New ListItem("Transferencia", 2, True))
        DlFormaPago0.Items.Add(New ListItem("Cheque", 1, True))
        DlFormaPago0.SelectedValue = 0
    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        ImageButton1.ImageUrl = "~/Content/img/Botones/Generales1A.png"
        Panel1.Visible = True
        Panel2.Visible = False
        Panel7.Visible = False
        ImageButton2.ImageUrl = "~/Content/img/Botones/Generales2.png"
        ImageButton3.ImageUrl = "~/Content/img/Botones/Salarios.png"
        ' ScriptManager.GetCurrent(Me).SetFocus(TextBox1)
    End Sub

    Protected Sub ImageButton2_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton2.Click
        ImageButton2.ImageUrl = "~/Content/img/Botones/Generales2A.png"
        Panel1.Visible = False
        Panel2.Visible = True
        Panel7.Visible = False
        ImageButton1.ImageUrl = "~/Content/img/Botones/Generales1.png"
        ImageButton3.ImageUrl = "~/Content/img/Botones/Salarios.png"
        'ScriptManager.GetCurrent(Me).SetFocus(TextBox16)
    End Sub

    Protected Sub ImageButton3_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton3.Click
        ImageButton3.ImageUrl = "~/Content/img/Botones/SalariosA.png"
        Panel1.Visible = False
        Panel2.Visible = False
        Panel7.Visible = True
        ImageButton1.ImageUrl = "~/Content/img/Botones/Generales1.png"
        ImageButton2.ImageUrl = "~/Content/img/Botones/Generales2.png"
        'ScriptManager.GetCurrent(Me).SetFocus(TextBox16)
    End Sub

    Protected Sub TextBox16_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox16.TextChanged
        edad()
        RFC()
    End Sub

    Protected Sub TextBox3_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        RFC()
        ScriptManager.GetCurrent(Me).SetFocus(TextBox4)
    End Sub
    Protected Sub ImageButton6_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton6.Click
        Contrata()
    End Sub
    Protected Sub Contrata()
        If Label55.Text <> "0" Then
            'Dim selectp As String = "Select * from Plaza where Descplaza= '" & Label6.Text & " '"
            'Dim myCommandp As New SqlDataAdapter(selectp, myConnection)
            'Dim dsp As New DataSet
            'myCommandp.Fill(dsp) '
            Dim select1 As String = "Select * from empleados where id_empleado=" & Label66.Text & ""
            Dim myCommand1 As New SqlDataAdapter(select1, myConnection)
            Dim ds As New DataSet
            myCommand1.Fill(ds)
            'Dim asp As Integer = ds.Tables(0).Rows(0).Item("Id_Empleado")
            If Trim(ds.Tables(0).Rows(0).Item("ApPaterno")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("ApMaterno")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Nombres")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Calle")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Colonia")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Del_Municipio")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Ciudad")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If ds.Tables(0).Rows(0).Item("Cp") = 0 Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If IsDBNull(ds.Tables(0).Rows(0).Item("FechaNacimiento")) Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If Trim(ds.Tables(0).Rows(0).Item("Curp")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If

            If Trim(ds.Tables(0).Rows(0).Item("NSSocial")) = "" Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                Exit Sub
            End If
            If IsDBNull(ds.Tables(0).Rows(0).Item("salario")) Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                'Response.Write("<script>javascript:self.close()</script>")
                Exit Sub
            End If
            If ds.Tables(0).Rows(0).Item("salario") = 0 Then
                Response.Write("<script>alert('Los campos en color rojo son obligatorias, guardelas antes de continuar');</script>")
                'Response.Write("<script>javascript:self.close()</script>")
                Exit Sub
            End If
            'Response.Write("<script>window.open('RH_RS_AltaEmpleado1.aspx?IdEmp=" & Label66.Text & "&IdPla= " & Label2.Text & " &IdPue= " & Label69.Text & "','dialogHeight:320px; dialogWidth:100px')</script>")
        Else
            Response.Write("<script>alert('Debe de guardar al aspirante antes de continuar.');</script>")
        End If
    End Sub

    Protected Sub llenaempleado(ByVal numero As Integer)
        Dim sql As String
        sql = "SELECT a.Id_empleado, a.NumeroEmpleado, a.Id_Puestos, a.Id_Plantilla, a.ApPaterno, a.ApMaterno, a.Nombres, a.FechaNacimiento, a.LugarNacimiento, a.Nacionalidad, a.sexo, a.EstadoCivil, a.Curp, a.RFC, a.RFCGenerado," & vbCrLf
        sql += "a.NSSocial, a.Calle, a.NumeroExt, a.NumeroInt, a.Colonia, isnull(a.CP, '00000') as CP, a.Del_Municipio, a.Ciudad, isnull(a.IdEstado, 0) as IdEstado, a.Tel1, a.Tel2, a.IdPlaza, a.Id_TipoNomina, a.Salario, a.SDIntegrado, a.SueBruto" & vbCrLf
        sql += ", a.IdEmpresa, a.FechaIngreso, a.FechaBaja, a.Idturno, a.No_prospecto, a.Observaciones_contra, a.Fecha_alta_Prosp, a.Correo, a.Status, a.Pago_lugar, a.fecha_ven_Cont, a.Id_Banco, a.Cta_Deposito, a.id_inmueble, a.Id_Corporativo" & vbCrLf
        sql += ", a.Cve_Patronal, a.FechaInfonavit, isnull(a.NoCreditoInfonavit, 0) as NoCreditoInfonavit, a.TipoInfonavit, a.FactorInfonavit, a.FuenteR, a.Entrevista, a.IdEmpMiGin" & vbCrLf
        sql += ",descplaza, c.DESCRIPCION, d.descripcion, e.nombre, a.Id_Plantilla, SMNTopeRH ,g.IdInmueble,h.IdHuman"
        sql += " FROM Empleados a INNER JOIN siser.dbo.Plaza b on a.idplaza = b.idplaza "
        sql += " INNER JOIN Puestos c on a.id_puestos = c.id_puestos "
        sql += " INNER JOIN TURNOS d on a.idturno = d.id_Turno"
        sql += " INNER JOIN SISER.dbo.Empresas_AF e on a.IdEmpresa = e.id_empresa"
        sql += " INNER JOIN Plantilla_Detalle f on a.id_plantilla = f.id_plantilladet"
        sql += " INNER JOIN Plantilla g on f.idplantilla = g.id_plantilla"
        sql += " INNER JOIN siser.dbo.Inmuebles_ASMI h on h.Id_Inmueble=g.IdInmueble"
        sql += " where id_empleado = " & numero & " "
        Dim myCommand1 As New SqlDataAdapter(sql, myConnection)
        Dim ds1 As New DataSet
        myCommand1.Fill(ds1)
        If ds1.Tables(0).Rows.Count > 0 Then
            Label71.Text = ds1.Tables(0).Rows(0).Item("IdInmueble")
            Label5.Text = ds1.Tables(0).Rows(0).Item("IdHuman")
            Label4.Text = ds1.Tables(0).Rows(0).Item("nombre")
            Label6.Text = ds1.Tables(0).Rows(0).Item("descplaza")
            Label66.Text = ds1.Tables(0).Rows(0).Item("id_empleado") 'se toma el id de empleado aunque sea aspirante
            Label10.Text = ds1.Tables(0).Rows(0).Item("descripcion")
            Label12.Text = ds1.Tables(0).Rows(0).Item("descripcion1")
            Label69.Text = ds1.Tables(0).Rows(0).Item("Id_Puestos")
            DropDownList5.SelectedValue = ds1.Tables(0).Rows(0).Item("id_tiponomina")
            DropDownList6.SelectedValue = ds1.Tables(0).Rows(0).Item("cve_patronal")
            If Not IsDBNull(ds1.Tables(0).Rows(0).Item("FechaIngreso")) Then TextBox40.Text = ds1.Tables(0).Rows(0).Item("FechaIngreso")
            TextBox36.Text = ds1.Tables(0).Rows(0).Item("salario")
            TextBox38.Text = ds1.Tables(0).Rows(0).Item("sdintegrado")
            TextBox37.Text = ds1.Tables(0).Rows(0).Item("suebruto")
            If Not IsDBNull(ds1.Tables(0).Rows(0).Item("fecha_ven_Cont")) Then TextBox39.Text = ds1.Tables(0).Rows(0).Item("fecha_ven_Cont")
            DropDownList7.SelectedValue = ds1.Tables(0).Rows(0).Item("Id_banco")
            TextBox5.Text = ds1.Tables(0).Rows(0).Item("cta_deposito")
            If Not IsDBNull(ds1.Tables(0).Rows(0).Item("FechaInfonavit")) Then TextBox42.Text = ds1.Tables(0).Rows(0).Item("FechaInfonavit")
            TextBox41.Text = ds1.Tables(0).Rows(0).Item("noCreditoInfonavit")
            Select Case ds1.Tables(0).Rows(0).Item("tipoinfonavit")
                Case 1
                    RadioButtonList1.SelectedValue = 0
                Case 2
                    RadioButtonList1.SelectedValue = 1
                Case 3
                    RadioButtonList1.SelectedValue = 2
            End Select
            TextBox43.Text = ds1.Tables(0).Rows(0).Item("factorinfonavit")
            DlFormaPago0.SelectedValue = ds1.Tables(0).Rows(0).Item("pago_lugar")
            Label55.Text = ds1.Tables(0).Rows(0).Item("No_Prospecto")
            Label64.Text = ds1.Tables(0).Rows(0).Item("NumeroEmpleado")
            TextBox1.Text = ds1.Tables(0).Rows(0).Item("ApPaterno")
            TextBox2.Text = ds1.Tables(0).Rows(0).Item("ApMaterno")
            TextBox3.Text = ds1.Tables(0).Rows(0).Item("Nombres")
            If Not IsDBNull(ds1.Tables(0).Rows(0).Item("FechaNacimiento")) Then
                TextBox16.Text = ds1.Tables(0).Rows(0).Item("FechaNacimiento")
            End If
            edad()
            TextBox17.Text = ds1.Tables(0).Rows(0).Item("LugarNacimiento")
            TextBox18.Text = ds1.Tables(0).Rows(0).Item("Nacionalidad")
            DlGenero.SelectedValue = ds1.Tables(0).Rows(0).Item("sexo")
            DlCivil.SelectedValue = Trim(ds1.Tables(0).Rows(0).Item("Estadocivil"))
            TextBox15.Text = ds1.Tables(0).Rows(0).Item("Curp")
            TextBox14.Text = ds1.Tables(0).Rows(0).Item("RFC")
            TextBox44.Text = ds1.Tables(0).Rows(0).Item("RFCGenerado")
            TextBox19.Text = ds1.Tables(0).Rows(0).Item("NSSocial")
            TextBox4.Text = ds1.Tables(0).Rows(0).Item("Calle")
            TextBox35.Text = ds1.Tables(0).Rows(0).Item("NumeroExt")
            TextBox6.Text = ds1.Tables(0).Rows(0).Item("NumeroInt")
            TextBox7.Text = ds1.Tables(0).Rows(0).Item("Colonia")
            TextBox11.Text = ds1.Tables(0).Rows(0).Item("CP")
            TextBox9.Text = ds1.Tables(0).Rows(0).Item("Del_Municipio")
            TextBox10.Text = ds1.Tables(0).Rows(0).Item("Ciudad")
            OboutDropDownList1.SelectedValue = ds1.Tables(0).Rows(0).Item("IdEstado")
            TextBox12.Text = ds1.Tables(0).Rows(0).Item("Tel1")
            TextBox8.Text = ds1.Tables(0).Rows(0).Item("Tel2")
            TextBox34.Text = ds1.Tables(0).Rows(0).Item("Observaciones_contra")
            TextBox13.Text = ds1.Tables(0).Rows(0).Item("correo")
            Label94.Text = ds1.Tables(0).Rows(0).Item("Id_Corporativo")
            Label71.Text = ds1.Tables(0).Rows(0).Item("Id_Inmueble")
            Label70.Text = ds1.Tables(0).Rows(0).Item("IdTurno")
            Label73.Text = ds1.Tables(0).Rows(0).Item("IdPlaza")
            Label93.Text = ds1.Tables(0).Rows(0).Item("SMNTopeRH")
            Label2.Text = ds1.Tables(0).Rows(0).Item("Id_Plantilla")

            If Request("tipo") = 3 Then
                lbnoempleado.Visible = True
                txnoempleado.Visible = True
                If Cabecera.Text = "Datos Generales del Empleado" Then
                    If IsDBNull(ds1.Tables(0).Rows(0).Item("NumeroEmpleado")) Then
                        txnoempleado.Text = 0
                    Else
                        txnoempleado.Text = ds1.Tables(0).Rows(0).Item("NumeroEmpleado")
                    End If
                End If
            End If
        End If
    End Sub
    Protected Sub llenareq(ByVal Plantilla As Integer)
        Dim sql As String = ""
        sql = "Select Id_PlantillaDet, b.Descripcion as Puesto, c.Descripcion as Turno, e.Nombre as Empresa, f.DescPlaza, a.IdPuesto, a.idTurno, d.IdInmueble, d.IdPlaza, d.IdProyecto, SMNTopeRH ,IdHuman "
        sql += " from Plantilla_Detalle a INNER JOIN Puestos b ON a.IdPuesto = b.Id_Puestos "
        sql += " INNER JOIN Turnos c ON a.IdTurno = c.Id_Turno "
        sql += " INNER JOIN Plantilla d ON a.IdPlantilla = d.Id_Plantilla"
        sql += " INNER JOIN SISER.dbo.Empresas e ON d.IdEmpresa = e.Id_Empresa"
        sql += " INNER JOIN SISER.dbo.Plaza f On d.IdPlaza = f.IdPlaza "
        sql += " inner join siser.dbo.Inmuebles_ASMI g on g.Id_Inmueble=d.IdInmueble"
        sql += " where Id_PlantillaDet = " & Plantilla & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataSet
        Dim miComando As New SqlCommand
        myCommand.Fill(ds)
        If ds.Tables(0).Rows.Count > 0 Then
            Label2.Text = ds.Tables(0).Rows(0).Item("Id_PlantillaDet")
            Label4.Text = ds.Tables(0).Rows(0).Item("Empresa")
            Label6.Text = ds.Tables(0).Rows(0).Item("descplaza")

            Label10.Text = ds.Tables(0).Rows(0).Item("Puesto")
            Label12.Text = ds.Tables(0).Rows(0).Item("Turno")

            Label69.Text = ds.Tables(0).Rows(0).Item("IdPuesto")
            Label70.Text = ds.Tables(0).Rows(0).Item("IdTurno")
            Label71.Text = ds.Tables(0).Rows(0).Item("IdInmueble")
            Label73.Text = ds.Tables(0).Rows(0).Item("IdPlaza")
            Label94.Text = ds.Tables(0).Rows(0).Item("IdProyecto")
            Label93.Text = ds.Tables(0).Rows(0)("SMNTopeRH")
            Label5.Text = ds.Tables(0).Rows(0)("IdHuman")

            myCommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataSet
            miComando = New SqlCommand
            myCommand.Fill(ds)
        End If
    End Sub

    Protected Sub ValidaAlta()
        If TextBox36.Text = "" Then TextBox36.Text = 0
        If TextBox37.Text = "" Then TextBox37.Text = 0
        If TextBox38.Text = "" Then TextBox38.Text = 0
        If TextBox43.Text = "" Then TextBox43.Text = 0
        If TextBox5.Text = "" Then TextBox5.Text = 0
        If TextBox35.Text = "" Then TextBox35.Text = 0
        If TextBox6.Text = "" Then TextBox6.Text = 0
        If TextBox41.Text = "" Then TextBox41.Text = 0
        If TextBox8.Text = "" Then TextBox8.Text = 0


        If TextBox2.Text = "" Then Response.Write("<script>alert('Debe Capturar el Apellido Materno , verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox3.Text = "" Then Response.Write("<script>alert('Debe Capturar el Nombre, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox4.Text = "" Then Response.Write("<script>alert('Debe Capturar LA CALLE verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox7.Text = "" Then Response.Write("<script>alert('Debe Capturar LA COLONIA verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox9.Text = "" Then Response.Write("<script>alert('Debe Capturar LA DELEGACION verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox10.Text = "" Then Response.Write("<script>alert('Debe Capturar EL MUNICIPIO verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox11.Text = "" Then Response.Write("<script>alert('Debe Capturar EL C.P. verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If Not IsNumeric(TextBox11.Text) Then Response.Write("<script>alert('El C.P. debe ser un número, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If OboutDropDownList1.SelectedValue = 0 Then Response.Write("<script>alert('Debe Seleccionar EL Estado verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox12.Text = "" Then Response.Write("<script>alert('Debe Capturar al menos un numero de Telefono. verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox15.Text = "" Then Response.Write("<script>alert('Debe Capturar la CURP. verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox17.Text = "" Then Response.Write("<script>alert('Debe Capturar EL lugar de nacimiento verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox18.Text = "" Then Response.Write("<script>alert('Debe Capturar la Nacionalidad verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If DlGenero.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar el Genero. verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If DlCivil.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar el Estado civil. verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If TextBox16.Text = "" Then Response.Write("<script>alert('Debe Capturar la Fecha de Nacimiento verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If Not IsDate(TextBox16.Text) Then Response.Write("<script>alert('La fecha de nacimiento no es valida.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If Len(TextBox14.Text) <> 13 Then Response.Write("<script>alert('Debe Capturar El RFC Parece estar incompleto, debe incluir Homoclave verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If Len(TextBox44.Text) <> 13 Then Response.Write("<script>alert('Debe Generar El RFC, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        If Label66.Text = "" Then
            Dim sql As String = "Select Id_Empleado from Empleados where RFC = '" & TextBox14.Text & "' and Status = 1 "
            Dim mycommand As New SqlDataAdapter(sql, myConnection)
            Dim ds As New DataSet
            mycommand.Fill(ds)
            If ds.Tables(0).Rows.Count > 0 Then Response.Write("<script>alert('El RFC capturado ya existe para otro Empleado activo, no puede continuar, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            sql = "Select Id_Empleado from Empleados where RFCGenerado = '" & TextBox44.Text & "' and Status = 1 "
            mycommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataSet
            mycommand.Fill(ds)
            If ds.Tables(0).Rows.Count > 0 Then Response.Write("<script>alert('El RFC Generado ya existe para otro Empleado activo, no puede continuar, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        End If
        If Request("tipo") = 2 Or Request("tipo") = 1 Then
            If Len(TextBox19.Text) <> 11 Then Response.Write("<script>alert('Debe capturar el No. IMSS parece estar incompleto, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If DropDownList5.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar un Tipo de Nomina, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If DropDownList6.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar un Registro Patronal, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If Not IsNumeric(TextBox36.Text) Then Response.Write("<script>alert('Debe Capturar el salario Mensual verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If TextBox36.Text = 0 Then Response.Write("<script>alert('Debe Capturar el salario Mensual verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")

            If Val(TextBox36.Text) > Val(Label93.Text) Then
                Response.Write("<script>alert('El salario mensual capturado es superior al Salario Tope del Puesto,  no puede registrar al Empleado.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            End If

            If Not IsNumeric(TextBox37.Text) Or TextBox37.Text = 0 Then Response.Write("<script>alert('Debe Capturar el salario para IMSS verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If Not IsNumeric(TextBox38.Text) Or TextBox38.Text = 0 Then Response.Write("<script>alert('Debe Capturar el salario diario integrado verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If DlFormaPago0.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar una Forma de Pago, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If Not IsDate(TextBox40.Text) Then Response.Write("<script>alert('Debe capturar la Fecha de Inicio de contrato, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
            If DropDownList7.SelectedValue = 0 Then Response.Write("<script>alert('Debe seleccionar el Banco, verifique.');</script>") : Err.Raise(1001 + vbObjectError, , "")
        End If
    End Sub

    Protected Sub guardar()
        Dim No_prospecto As Integer = 0
        Dim sql As String = ""
        Dim mycommand1 As New SqlDataAdapter
        Dim mycommand2 As New SqlCommand
        Dim ds As New DataSet
        myConnection.Open()
        myConnection.Open()
        Select Case Request("tipo")
            Case 0
                sql = "select  FolioProspecto + 1 as Folio from plaza where IdPlaza = " & Label73.Text
                Dim myCommand As New SqlDataAdapter(sql, myConnection)
                ds = New DataSet
                myCommand.Fill(ds)
                If ds.Tables(0).Rows.Count > 0 Then
                    No_prospecto = ds.Tables(0).Rows(0).Item("Folio")
                End If
                sql = "Update Plaza set FolioProspecto = " & ds.Tables(0).Rows(0).Item("Folio") & " where IdPlaza = " & Label73.Text
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
            Case 1
                sql = "select folio + 1 as Folio from Folio_empleado "
                Dim command As New SqlDataAdapter(sql, myConnection)
                ds = New DataSet
                command.Fill(ds)
                sql = "Update Folio_empleado set folio = " & ds.Tables(0).Rows(0).Item("Folio")
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
                Label64.Text = ds.Tables(0).Rows(0).Item("Folio")
            Case 2
                sql = "select folio + 1 as Folio from Folio_empleado "
                Dim command As New SqlDataAdapter(sql, myConnection)
                ds = New DataSet
                command.Fill(ds)
                sql = "Update Folio_empleado set folio = " & ds.Tables(0).Rows(0).Item("Folio")
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
                Label64.Text = ds.Tables(0).Rows(0).Item("Folio")
            Case 3
                'Cabecera.Text = "Datos Generales del Empleado"
                sql = "Update Empleados set NumeroEmpleado = " & Label8.Text & " where Id_empleado = " & txnoempleado.Text & ";"
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
                Label64.Text = txnoempleado.Text
        End Select
        Dim vTipo As Integer
        Select Case RadioButtonList1.SelectedIndex
            Case 0
                vTipo = 1
            Case 1
                vTipo = 2
            Case 2
                vTipo = 3
            Case Else
                vTipo = 0
        End Select
        ' ACTUALIZAR LA PLANTILLA SUMANDO AL EMPLEADO CONTRATADO
        ds.Clear()
        If Request("tipo") <> 0 Then
            sql = "Select Contratado  + 1 as Contratado from Plantilla_Detalle where Id_PlantillaDet = " & Label2.Text
            mycommand1 = New SqlDataAdapter(sql, myConnection)
            mycommand1.Fill(ds)
            If ds.Tables(0).Rows.Count > 0 Then
                sql = " Update Plantilla_Detalle set Contratado = " & ds.Tables(0).Rows(0)("Contratado") & " where Id_PlantillaDet = " & Label2.Text
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
            End If
        End If
        myConnection.Close()

        sql = "Insert into Empleados(Id_Puestos, Id_Plantilla,"
        sql += "ApPaterno, ApMaterno, Nombres, "
        sql += " FechaNacimiento, "
        sql += " LugarNacimiento, Nacionalidad, "
        sql += " sexo, EstadoCivil ,Curp, RFC, NSSocial ,Calle, NumeroExt,"
        sql += " NumeroInt, Colonia, CP, Del_Municipio, Ciudad, IdEstado,"
        sql += " Tel1, Tel2, IdPlaza, IdEmpresa, Idturno,"
        sql += " No_prospecto, Observaciones_contra,"
        sql += "correo, id_inmueble, Cve_Patronal, "
        sql += "FechaIngreso,"
        sql += " Status, NumeroEmpleado,"
        sql += " Cta_Deposito, Id_Banco, SDIntegrado, suebruto, salario,"
        sql += "fecha_ven_Cont,"
        sql += "FechaInfonavit,"
        sql += " NoCreditoInfonavit, TipoInfonavit, FactorInfonavit,  Id_TipoNomina, Pago_Lugar, Id_Corporativo, RFCGenerado, Fecha_alta_prosp, "
        sql += " FuenteR, Entrevista)" & vbCrLf
        sql += " values (" & Label69.Text & "," & Label2.Text & ","
        sql += "'" & UCase(TextBox1.Text) & "' ,'" & UCase(TextBox2.Text) & "' , '" & UCase(TextBox3.Text) & "',"
        sql += "'" & IIf(IsDate(TextBox16.Text), Format(CDate(TextBox16.Text), "yyyyMMdd"), "19000101") & "',"
        sql += " '" & UCase(TextBox17.Text) & "','" & UCase(TextBox18.Text) & "',"
        sql += " " & DlGenero.SelectedValue & " ,'" & DlCivil.SelectedValue & "','" & UCase(TextBox15.Text) & "',"
        sql += " '" & TextBox14.Text & "','" & UCase(TextBox19.Text) & "','" & UCase(TextBox4.Text) & "', '" & TextBox35.Text & "' ,"
        sql += " '" & TextBox6.Text & "','" & UCase(TextBox7.Text) & "'," & TextBox11.Text & ","
        sql += " '" & UCase(TextBox9.Text) & "','" & UCase(TextBox10.Text) & "'," & OboutDropDownList1.SelectedValue & " ,"
        sql += " '" & TextBox12.Text & "','" & TextBox8.Text & "'," & Label73.Text & " ,"
        sql += " 1 ," & Label70.Text & "," & No_prospecto & ",'" & TextBox34.Text & "', "
        sql += " '" & TextBox13.Text & "', " & Label71.Text & "," & DropDownList6.SelectedValue & ", "
        sql += "'" & IIf(IsDate(TextBox40.Text), Format(CDate(TextBox40.Text), "yyyyMMdd"), "19000101") & "',"
        sql += " " & IIf(Request("tipo") = 0, "0", "1") & ","
        'sql += " " & Label64.Text & ", " & TextBox5.Text & ", " & DropDownList7.SelectedValue & ","
        sql += " 0, " & TextBox5.Text & ", " & DropDownList7.SelectedValue & ","
        sql += " " & TextBox38.Text & ", " & TextBox37.Text & "," & TextBox36.Text & ","
        If IsDate(TextBox39.Text) Then sql += "'" & Format(CDate(TextBox39.Text), "yyyyMMdd") & "', " Else sql += "null, "
        If IsDate(TextBox42.Text) Then sql += "'" & Format(CDate(TextBox42.Text), "yyyyMMdd") & "', " Else sql += "null, "
        sql += " " & TextBox41.Text & ", " & vTipo & ", " & TextBox43.Text & ", " & DropDownList5.SelectedValue & ", " & DlFormaPago0.SelectedValue & ","
        sql += " " & Label94.Text & ", '" & TextBox44.Text & "', '" & Format(Date.Today, "yyyy/MM/dd") & "',"
        sql += " '" & TextBox45.Text & "', '" & TextBox46.Text & "');" & vbCrLf & vbCrLf
        sql += "declare @emp bigint;" & vbCrLf & "set @emp = scope_identity();" & vbCrLf
        sql += "insert into  kardexEmpleado(FechaMov,Sueldo,Id_Empleado,"
        sql += "Id_Plantilla,Id_Puestos,Movimiento, FechaSis, Usuario)" & vbCrLf
        sql += "  values(cast(getdate() as date),"
        sql += " " & Trim(TextBox36.Text) & ", @emp,"
        sql += " " & Request("Plantilla") & ","
        sql += " " & Label69.Text & ","
        sql += " " & IIf(Request("tipo") = 0, "0", "1") & ","
        sql += " cast(getdate() as date), " & Session("v_usuario") & " );" & vbCrLf
        sql += "select @emp as idempleado;"

        Dim idemp As Integer = 0
        mycommand2 = New SqlCommand(sql, myConnection)
        mycommand2.CommandType = CommandType.Text
        myConnection.Open()
        idemp = mycommand2.ExecuteScalar()
        myConnection.Close()

        Try
            Select Case Request("tipo")
                Case 0
                    Response.Write("<script>alert('Se ha guardado el Prospecto No. " & Label55.Text & " para la Plantilla No. " & Label2.Text & ", correctamente.');</script>")
                Case 1, 2
                    sql = "Update Empleados set NumeroEmpleado = " & Label8.Text & " where Id_empleado = " & idemp & ";"
                    mycommand2 = New SqlCommand(sql, myConnection)
                    If myConnection.State = ConnectionState.Closed Then myConnection.Open()
                    mycommand2.ExecuteNonQuery()
                    myConnection.Close()

                    Label64.Text = Label8.Text
                    Response.Write("<script>alert('Se ha generado el Empleado No. " & Label8.Text & " correctamente');</script>")
            End Select
        Catch ex As Exception
            Response.Write("<script>alert('" & ex.Message & ".');</script>")
        End Try
    End Sub
    Protected Sub actualiza()
        On Error GoTo errpudate
        ValidaAlta()
        Dim sql As String = ""
        Dim ds As New DataSet
        Dim mycommand2 As New SqlCommand
        Dim mycommand1 As New SqlDataAdapter
        myConnection.Open()
        Select Case Request("tipo")
            Case 1
                sql = "select folio + 1 as Folio from Folio_empleado "
                Dim command As New SqlDataAdapter(sql, myConnection)
                ds = New DataSet
                command.Fill(ds)
                sql = "Update Folio_empleado set folio = " & ds.Tables(0).Rows(0).Item("Folio")
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
                Label64.Text = ds.Tables(0).Rows(0).Item("Folio")
            Case 3
                sql = "Update Empleados set NumeroEmpleado = " & Label8.Text & " where Id_empleado = " & txnoempleado.Text & ";"
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
                Label64.Text = txnoempleado.Text
        End Select
        Dim FechaNacimiento As Date = TextBox16.Text
        Dim vFec1 As Date = TextBox40.Text
        sql = "Update Empleados set NumeroEmpleado=" & Label64.Text & ","
        sql += " ApPaterno='" & UCase(TextBox1.Text) & "' ,ApMaterno='" & UCase(TextBox2.Text) & "',Nombres='" & UCase(TextBox3.Text) & "',"
        sql += " FechaNacimiento='" & Format(FechaNacimiento, "yyyy/MM/dd") & "',"
        sql += " LugarNacimiento='" & UCase(TextBox17.Text) & "',Nacionalidad='" & UCase(TextBox18.Text) & "',"
        sql += " sexo=" & DlGenero.SelectedValue & ",EstadoCivil='" & DlCivil.SelectedValue & "',Curp='" & UCase(TextBox15.Text) & "',"
        sql += " RFC='" & TextBox14.Text & "', RFCGenerado = '" & TextBox44.Text & "',NSSocial='" & UCase(TextBox19.Text) & "',Calle='" & UCase(TextBox4.Text) & "',"
        sql += " NumeroInt= '" & TextBox6.Text & "', NumeroExt = '" & TextBox35.Text & "' ,Colonia='" & UCase(TextBox7.Text) & "',CP=" & TextBox11.Text & ","
        sql += " Del_Municipio='" & UCase(TextBox9.Text) & "', Ciudad='" & UCase(TextBox10.Text) & "',IdEstado=" & OboutDropDownList1.SelectedValue & " ,"
        sql += " Tel1='" & TextBox12.Text & "', Tel2='" & TextBox8.Text & "', correo='" & TextBox13.Text & "',"
        sql += " Salario=" & TextBox36.Text & ", SueBruto = " & TextBox37.Text & ", SDIntegrado = " & TextBox38.Text & ","
        sql += " Observaciones_contra='" & TextBox34.Text & "', Id_TipoNomina = " & DropDownList5.SelectedValue & ", cve_Patronal = " & DropDownList6.SelectedValue & ","
        sql += " pago_lugar = " & DlFormaPago0.SelectedValue & ", FechaIngreso = '" & Format(vFec1, "yyyy/MM/dd") & "', "
        If IsDate(TextBox39.Text) Then
            Dim vfec2 As Date = TextBox39.Text
            sql += " fecha_ven_Cont = '" & Format(vfec2, "yyyy/MM/dd") & "',"
        End If
        If IsDate(TextBox42.Text) Then
            Dim vfec3 As Date = TextBox39.Text
            sql += " fechaInfonavit = '" & Format(vfec3, "yyyy/MM/dd") & "',"
        End If
        If Request("tipo") = 1 Then
            sql += " Status = 1,"
        End If
        Dim vTipo As Integer
        Select Case RadioButtonList1.SelectedIndex
            Case 0
                vTipo = 1
            Case 1
                vTipo = 2
            Case 2
                vTipo = 3
            Case Else
                vTipo = 0
        End Select
        sql += "TipoInfonavit = " & vTipo & ", NoCreditoInfonavit = " & TextBox41.Text & ", FactorInfonavit = " & TextBox43.Text & ","
        sql += " Id_banco = " & DropDownList7.SelectedValue & ", cta_deposito =" & TextBox5.Text & ", FuenteR = '" & TextBox45.Text & "',"
        sql += " Entrevista = '" & TextBox46.Text & "' where id_empleado = " & Label66.Text
        mycommand2 = New SqlCommand(sql, myConnection)
        mycommand2.ExecuteNonQuery()
        ds.Clear()
        ' ACTUALIZA PLANTILLA AL ACTIVAR ASPIRANTE COMO EMPLEADO
        If Request("tipo") = 1 Then
            sql = "Select Contratado  + 1 as Contratado from Plantilla_Detalle where Id_PlantillaDet = " & Label2.Text
            mycommand1 = New SqlDataAdapter(sql, myConnection)
            mycommand1.Fill(ds)
            If ds.Tables(0).Rows.Count > 0 Then
                sql = " Update Plantilla_Detalle set Contratado = " & ds.Tables(0).Rows(0)("Contratado") & " where Id_PlantillaDet = " & Label2.Text
                mycommand2 = New SqlCommand(sql, myConnection)
                mycommand2.ExecuteNonQuery()
            End If
        End If
        myConnection.Close()
        Select Case Request("tipo")
            Case 1
                Response.Write("<script>alert('El Aspirante No. " & Label55.Text & " se ha habilitado correctamente como Empleado, se ha cubierto una vacante mas de esta Plantilla, su numero de empleado es " & Label64.Text & "');</script>")
            Case 3
                Response.Write("<script>alert('El Empleado ha sido actualizado correctamente.');</script>")
        End Select

errpudate:
    End Sub

    Protected Sub RFC()
        Dim segunda As String = ""
        Dim tamaño As Integer = Len(Trim(TextBox1.Text))
        For i As Integer = 0 To tamaño
            If i > 1 Then
                Dim letra As String = UCase(Mid(TextBox1.Text, i, 1))

                If letra = "A" Or letra = "E" Or letra = "I" Or letra = "O" Or letra = "U" Then
                    segunda = letra
                    Exit For
                End If
            End If

        Next
        TextBox14.Text = UCase(Left(TextBox1.Text, 1)) & segunda & UCase(Left(TextBox2.Text, 1)) & UCase(Left(TextBox3.Text, 1))
        If TextBox16.Text <> "" Then
            Dim fecha As Date = TextBox16.Text
            TextBox16.Text = fecha
            TextBox14.Text = TextBox14.Text & Right(fecha, 2) & Mid(fecha, 4, 2) & Left(fecha, 2)
        End If
        TextBox15.Text = TextBox14.Text
    End Sub
    Protected Sub edad()
        If TextBox16.Text <> "" Then
            'Dim FechaNac As Date
            Dim Edad As Integer = 0
            Dim dInicio As Date = TextBox16.Text
            Dim dFin As Date = fecha
            'TuEdad(fechanac, fechaact)
            Dim Dias As Integer, Meses As Integer, Años As Integer
            Dim DiasMes As Integer
            Dias = Microsoft.VisualBasic.DateAndTime.Day(dFin) - Microsoft.VisualBasic.DateAndTime.Day(dInicio)
            Meses = DatePart("m", dFin) - DatePart("m", dInicio)
            Años = DateDiff("yyyy", dInicio, dFin)

            If Dias < 0 Then
                DiasMes = Microsoft.VisualBasic.DateAndTime.Day(DateSerial(Year(dInicio), Month(dInicio) + 1, 0))
                Dias = (DiasMes - Microsoft.VisualBasic.DateAndTime.Day(dInicio)) + Microsoft.VisualBasic.DateAndTime.Day(dFin)
                Meses = Meses - 1
            End If
            If Meses < 0 Then
                Meses = 12 + Meses
                Años = Años - 1
            End If
            'MsgBox("Tenes " & Format(Años, "00" & " Años") & Format(Meses, "00" & " Meses ") & Format(Dias, "00" & " Dias"))
            Label42.Text = Format(Años, "00")
        End If
        'ScriptManager.GetCurrent(Me).SetFocus(TextBox14)
    End Sub
    Protected Sub ImageButton7_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton7.Click
        Session("v_formula") = " {Empleados.Id_empleado} = " & Label66.Text
        Session("v_reporte") = "RHContrato.rpt"
        Response.Write("<script>window.open('../../../reporte.aspx','','width=850,height=600,left=80,top=120,resizable=yes,scrollbars=yes')</script>")
    End Sub

    Protected Sub ImageButton13_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton13.Click
        If Label5.Text = 0 Then Response.Write("<script>alert('Debe Capturar el Centro de Costo de MIGIN para continuar, verifique.');</script>") : Exit Sub
        If Label66.Text <> "" Then
            actualiza()
        Else
            On Error GoTo Err
            ValidaAlta()
            guardar()
        End If
Err:
    End Sub
    Protected Sub ImageButton14_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton14.Click
        Response.Write("<script>javascript:self.close()</script>")
    End Sub

    Protected Sub ImageButton15_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton15.Click
        ' CWGeneraRFCjson()
    End Sub

    Protected Sub Correo(ByVal Tipo As Integer)
        Dim mail As New MailMessage
        mail.From = New MailAddress("siseradmin@bauhaus.com.mx")
        mail.To.Add("rberistain@bauhaus.com.mx")
        'mail.To.Add("aperez@bauhaus.com.mx;eestrada@bauhaus.com.mx")
        mail.Subject = "NOTIFICACION DE ALTA DE EMPLEADO"
        mail.IsBodyHtml = True

        Dim sb As New StringBuilder()
        sb.Append("<html><head><title>Reporte</title><style type=""text/css"">")
        sb.Append("<!--.cabecero {color: #FFF;}body,td,th {")
        sb.Append("font-family: Tahoma, Geneva, sans-serif;")
        sb.Append("font-size: 11px;}-->")

        sb.Append("<body>")
        If Session("body") <> Nothing Then
            sb.Append("<p style=""text-align: left"">" & Session("body") & "</p>")
        End If
        sb.Append("<table width=""835"" height=""79"" >")
        sb.Append("<tr>")
        sb.Append("<td width=""835""><form id=""form1"" name=""form1"" method=""post"" action="""">")
        sb.Append("<label>")
        sb.Append("<input type=""image"" name=""logobau"" id=""logobau"" src=""cid:imagen001"" />")
        sb.Append("</label>")
        sb.Append("</form></td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td width=""830"" >")
        sb.Append("<table cellspacing=""1"" cellpadding=""0"" >")
        sb.Append("<col width=""31"" />")
        sb.Append("<col width=""63"" />")
        sb.Append("<col width=""119"" />")
        sb.Append("<col width=""189"" />")
        sb.Append("<col width=""47"" />")
        sb.Append("<col width=""80"" />")
        sb.Append("<col width=""47"" />")
        sb.Append("<col width=""107"" />")
        sb.Append("<col width=""47"" />")
        sb.Append("<col width=""114"" />")
        sb.Append("<col width=""43"" />")
        sb.Append("<tr align=""center"" bgcolor=""#092435"">")
        sb.Append("<td width=""90""class=""cabecero"">No. Plantilla</td>")
        sb.Append("<td width=""300""class=""cabecero"">Proyecto</td>")
        sb.Append("<td width=""350""class=""cabecero"">Centro de Costos</td>")
        sb.Append("<td width=""100""class=""cabecero"">Fecha de Movimiento</td>")
        sb.Append("</tr>")
        sb.Append("<td height=""5""></td>")
        sb.Append("<tr bgcolor=""#E9E9E9"">")
        sb.Append("<td width=""90"">" & Label2.Text & "</td>")
        sb.Append("<td width=""300"">" & Label94.Text & "</td>")
        sb.Append("<td width=""350"">" & Label71.Text & "</td>")
        sb.Append("<td width=""100"">" & Format(Date.Today, "dd/MM/yyyy") & "</td>")
        sb.Append("</tr>")
        sb.Append("<td height=""6""></td>")
        sb.Append("</table>")
        If Tipo = 1 Or Tipo = 3 Then
            sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
            sb.Append("<tr >")
            sb.Append("<td colspan=""2"" class=""cabecero"">")
            sb.Append("<input type=""image"" title=""Datos Generales del Reporte"" name=""logobau"" id=""logobau"" src=""cid:imagen002"" />")
            sb.Append("</td>")
            sb.Append("</tr>")
            sb.Append("<tr>    <td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">Datos Generales</td> </tr>")
            sb.Append("<td height=""8""></td>")
            sb.Append("</table>")
            sb.Append("<table width=""830"" cellpadding=""0"" cellspacing=""1"" >")
            sb.Append("<col width=""93"" />")
            sb.Append("<col width=""119"" />")
            sb.Append("<col width=""250"" />")
            sb.Append("<col width=""71"" />")
            sb.Append("<col width=""99"" />")
            sb.Append("<col width=""74"" />")
            sb.Append("<col width=""114"" />")
            sb.Append("<col width=""71"" />")
            sb.Append("<col width=""114"" />")
            sb.Append("<tr>")
            sb.Append("<td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">Puesto</td>")
            sb.Append("<td colspan=""3"" >" & Label10.Text & "</td>")
            sb.Append("<td width=""142"" bgcolor=""#092435"" class=""cabecero"">Turno</td>")
            sb.Append("<td width=""264"" colspan=""3"">" & Label12.Text & "</td>")
            sb.Append("</tr>")
            sb.Append("<tr>")
            sb.Append("<td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">No. Empleado</td>")
            sb.Append("<td colspan=""3"">" & Label64.Text & "</td>")
            sb.Append("<td bgcolor=""#092435"" class=""cabecero"">Sueldo</td>")
            sb.Append("<td colspan=""3"">" & TextBox36.Text & "</td>")
            sb.Append("</tr>")
            sb.Append("<tr>")
            sb.Append("<td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">Nombre</td>")
            sb.Append("<td colspan=""3"">" & TextBox3.Text & "</td>")
            sb.Append("<td bgcolor=""#092435"" class=""cabecero"">Plaza</td>")
            sb.Append("<td colspan=""3"">" & Label6.Text & "</td>")
            sb.Append("</tr>")
            sb.Append("<tr>")
            sb.Append("<td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">F. Ingreso</td>")
            sb.Append("<td colspan=""3"">" & TextBox40.Text & "</td>")
            sb.Append("<td bgcolor=""#092435"" class=""cabecero"">Nomina</td>")
            sb.Append("<td colspan=""3"">" & DropDownList5.SelectedItem.ToString & "</td>")
            sb.Append("<td height=""12""></td>")
            sb.Append("</table>")
        End If

        sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
        sb.Append("<tr >")
        sb.Append("<td colspan=""2"" class=""cabecero"">")
        sb.Append("<input type=""image"" title=""Datos Generales del Reporte"" name=""logobau"" id=""logobau"" src=""cid:imagen002"" />")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr><td colspan=""2"" bgcolor=""#092435"" class=""cabecero"">Comentarios</td> </tr>")
        Select Case Tipo
            Case 1
                sb.Append("<td height=""8""><p>ALTA DE NUEVA POSICION EN PLANTILLA</p>")
            Case 2
                sb.Append("<td height=""8"">SE HA CREADO UNA PLANTILLA NUEVA CON LA ESTRUCTURA QUE SE ENLISTA A CONTINUACION, FAVOR DE INGRESAR A SISER PARA REVISAR DETALLES</td>")
            Case 3
                sb.Append("<td height=""8""><p>MODIFICACION DE UNA POSICION EN PLANTILLA</p>")
        End Select
        sb.Append("</table>")
        'sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"">")
        'sb.Append("<tr>")
        'sb.Append("<td colspan=""2"" rowspan=""7""><form id=""form1"" name=""form1"" method=""post"" action="""">")
        'sb.Append("</form></td>")
        'sb.Append("</tr>")

        '        Select Case Tipo
        '            Case 2
        '        'DEFINE LOS TITULOS DE LA TABLA DE DETALLE
        '        sb.Append("<tr align=""center"" bgcolor=""#092435"">")
        '        sb.Append("<td width=""300""class=""cabecero"">Puesto</td>")
        '        sb.Append("<td width=""160""class=""cabecero"">Turno</td>")
        '        sb.Append("<td width=""90""class=""cabecero"">Jornal</td>")
        '        sb.Append("<td width=""100""class=""cabecero"">Tope Diseño</td>")
        '        sb.Append("<td width=""100""class=""cabecero"">Tope RH</td>")
        '        sb.Append("<td width=""90""class=""cabecero"">Autorizados</td>")
        '        sb.Append("</tr>")
        '        Dim sql As String = "select c.Descripcion as Puesto, d.Descripcion  as Turno, Jornal, smntope, SMNTopeRH, Cantidad"
        '        sql += " from Plantilla_Detalle a INNER JOIN Plantilla B ON A.IdPlantilla = B.Id_Plantilla"
        '        sql += " INNER JOIN Puestos c ON a.IdPuesto = c.Id_puestos  "
        '        sql += " INNER JOIN Turnos d ON a.IdTurno = d.Id_Turno "
        '        sql += " INNER JOIN SISER.dbo.Inmuebles_ASMI e ON b.IdInmueble = e.Id_Inmueble "
        '        sql += " INNER JOIN SISER.dbo.Corporativos f ON B.IdProyecto = f.Id_Corporativo "
        '        sql += " INNER JOIN SISER.dbo.Plaza g ON e.Id_Plaza = g.IdPlaza "
        '        sql += " WHERE(a.Estatus = 0 And a.IdPlantilla = " & Label21.Text & ")"
        '        sql += " order by f.Nombre, g.DescPlaza , e.Nombre , c.Descripcion "
        '        Dim mycommand As New SqlDataAdapter(sql, myConnection)
        '        Dim ds As New DataSet
        '        mycommand.Fill(ds)
        '        Dim j As Integer = 0
        '        For j = 0 To ds.Tables(0).Rows.Count - 1
        ' sb.Append("<tr>")
        ' sb.Append("<td width=""300"">" & ds.Tables(0).Rows(j)("Puesto") & "</td>")
        ' sb.Append("<td width=""160"">" & ds.Tables(0).Rows(j)("Turno") & "</td>")
        ' sb.Append("<td width=""90"">" & ds.Tables(0).Rows(j)("Jornal") & "</td>")
        ' sb.Append("<td width=""100"">" & ds.Tables(0).Rows(j)("smntope") & "</td>")
        ' sb.Append("<td width=""100"">" & ds.Tables(0).Rows(j)("smntoperh") & "</td>")
        ' sb.Append("<td width=""30"">" & ds.Tables(0).Rows(j)("Cantidad") & "</td>")
        'sb.Append("</tr>")
        'Next
        'End Select
        sb.Append("</table>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<input type=""image"" name=""logobau"" id=""logobau"" src=""cid:imagen002"" height=""56"" width=""836"" />")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("</body></html>")

        mail.Body = sb.ToString()
        Dim HTMLConImagenes As AlternateView
        HTMLConImagenes = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen As LinkedResource
        imagen = New LinkedResource((Server.MapPath("..\..\Content\img\mail\headerbk.png")))
        imagen.ContentId = "imagen001"
        HTMLConImagenes.LinkedResources.Add(imagen)
        mail.AlternateViews.Add(HTMLConImagenes)

        Dim HTMLConImagenes1 As AlternateView
        HTMLConImagenes1 = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen1 As LinkedResource
        imagen1 = New LinkedResource((Server.MapPath("..\..\Content\img\mail\menubk.png")))
        imagen1.ContentId = "imagen002"
        HTMLConImagenes1.LinkedResources.Add(imagen1)
        mail.AlternateViews.Add(HTMLConImagenes1)

        Dim HTMLConImagenes2 As AlternateView
        HTMLConImagenes2 = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim mailClient As New SmtpClient()
        Dim basicAuthenticationInfo As New NetworkCredential("siseradmin@bauhaus.com.mx", "cremoso")
        mailClient.Host = "mail.bauhaus.com.mx"
        mailClient.UseDefaultCredentials = True
        mailClient.Credentials = basicAuthenticationInfo
        mailClient.Port = 2525
        Try
            mailClient.Send(mail)
            Response.Write("<script>alert('Se ha enviado un correo electrónico notificando el Movimiento de Empleado');</script>")
        Catch ex As Exception
            Response.Write("<script>alert('ERROR: " & ex.Message & "');</script>")
        End Try
        Session("Destinos") = Nothing
        Session("v_adjunto") = Nothing
        Session("body") = Nothing
    End Sub

    Protected Sub TextBox15_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TextBox15.TextChanged

    End Sub
End Class
