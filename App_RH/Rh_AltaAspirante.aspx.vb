Imports System.Data
Imports System.Data.SqlClient
Partial Class App_RH_Rh_AltaAspirante
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
        'myCommandm.Fill(dtm)
        'labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "validarfc"
                If IsDate(Mid(txtrfc.Text, 9, 2) & "/" & Mid(txtrfc.Text, 7, 2) & "/" & Mid(txtrfc.Text, 5, 2)) Then
                    calculafecanio()
                    Dim sql As String = "select * from tbl_empleados where emp_rfc='" & txtrfc.Text & "'"
                    Dim myCommand As New SqlDataAdapter(sql, myConnection)
                    Dim dt As New DataTable
                    myCommand.Fill(dt)
                    If dt.Rows.Count > 0 Then
                        Dim script As String = "mensaje('El rfc corresponde a un empleado registrado con anterioridad, verifique');"
                        ScriptManager.RegisterStartupScript(Me, GetType(Page), "mensaje", script, True)
                    End If
                Else
                    Dim script As String = "mensaje('El RFC tiene un error en su captura, verifique');"
                    ScriptManager.RegisterStartupScript(Me, GetType(Page), "mensaje", script, True)
                End If
            Case "guardapros"
                guardapros()
            Case "busca"
                llenagridconsulta("")
                Dim script As String = "continuar(3);"
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "continuar", script, True)
        End Select

        If Not Page.IsPostBack Then
            txtnpros.Text = 0
            Response.ExpiresAbsolute = Now().AddDays(-1)
            Response.AddHeader("pragma", "no-cache")
            Response.AddHeader("cache-control", "private")
            Response.CacheControl = "no-cache"
            Dim sql As String = "select * from estados"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlestado.DataSource = dt
                ddlestado.DataTextField = "Estado"
                ddlestado.DataValueField = "Id_Estado"
                ddlestado.DataBind()
                ddlestado.SelectedValue = 9
            End If

            sql = "select a.ID_Puesto,a.Cve_Puesto+'|'+ a.Pue_Puesto as puesto From Tbl_Puesto a where a.pue_estatus=0 "
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                ddlPuesto.DataSource = dt
                ddlPuesto.DataTextField = "puesto"
                ddlPuesto.DataValueField = "ID_Puesto"
                ddlPuesto.DataBind()
                ddlPuesto.Items.Add(New ListItem("Sel. Puesto...", 0, True))
                ddlPuesto.SelectedValue = 0
            End If

        End If
    End Sub
    Protected Sub calculafecanio()
        txtfecnac.Text = Mid(txtrfc.Text, 9, 2) & "/" & Mid(txtrfc.Text, 7, 2) & "/" & Mid(txtrfc.Text, 5, 2)
        Dim años As Integer
        Dim fechanac As Date = txtfecnac.Text
        Dim fechaact As Date = Date.Today
        Dim mesn As Integer = fechanac.Month
        Dim añon As Integer = fechanac.Year
        Dim dian As Integer = fechanac.Day
        Dim mesa As Integer = fechaact.Month
        Dim añoa As Integer = fechaact.Year
        Dim diaa As Integer = fechaact.Day
        Dim años1 As Integer
        'txtfecnac.Text = UCase(Left(TextBox1.Text, 2)) & UCase(Left(TextBox2.Text, 1)) & UCase(Left(TextBox3.Text, 1))
        'txtfecnac.Text = Label41.Text & Right(añon, 2) & mesn & dian
        años = añoa - añon
        txtfecnac.Text = "Fec. Nac. " & txtfecnac.Text & "|" & años & " Años"

    End Sub
    Protected Sub guardapros()
        Dim fechanac As Date = Mid(txtrfc.Text, 9, 2) & "/" & Mid(txtrfc.Text, 7, 2) & "/" & Mid(txtrfc.Text, 5, 2)
        If txtnpros.Text = 0 Then
            Dim sql As String = "insert into Tbl_Empleados (Emp_Numero,Id_Plantilla,Emp_ApPaterno,Emp_ApMaterno,Emp_Nombres,Emp_FechaNacimiento,Emp_LugarNacimiento,Emp_Nacionalidad,Emp_sexo,	Emp_EstadoCivil,Emp_Curp,Emp_RFC,Emp_NSSocial,	Emp_Calle,	Emp_NumeroExt,	Emp_NumeroInt,Emp_Colonia,	Emp_CP,	Emp_Del_Municipio,	Emp_Ciudad,	IdEstado,	Emp_Tel1,	Emp_Tel2,	Id_TipoNomina,	Emp_Salario,	Emp_SDIntegrado,	Emp_SueBruto,	IdEmpresa,Idturno,	Emp_No_prospecto,	Emp_Observaciones_contra,	Emp_Fecha_alta_Prosp,	Emp_Correo,	Status,	Emp_Pago_lugar,	Id_Banco,	Emp_Cta_Deposito,	Emp_Cve_Patronal,Id_Puestos)"
            sql += " values (0,0,'" & txtapaterno.Text & "','" & txtamaterno.Text & "','" & txtnombre.Text & "','" & fechanac & "','" & txtln.Text & "','" & txtnac.Text & "'," & ddlsexo.SelectedValue & "," & ddledocivil.SelectedValue & ",'" & txtcurp.Text & "','" & txtrfc.Text & "','" & txtimss.Text & "','" & txtcalle.Text & "','" & txtnint.Text & "','" & txtnext.Text & "','" & txtcol.Text & "','" & txtcp.Text & "','" & txtdel.Text & "',''," & ddlestado.SelectedValue & ",'" & txttelp.Text & "','" & txttelemer.Text & "',0,0,0,0,0,0,(select isnull(max(emp_no_prospecto),0)+1 from tbl_empleados),'" & txtobs.Text & "','" & Date.Today & "','" & txtcorreo.Text & "',0,0,0,'',0," & ddlPuesto.SelectedValue & ")"
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            sql = "select MAX(ID_EMPLEADO) ID_EMPLEADO from Tbl_Empleados"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                id.Text = dt.Rows(0).Item("id_empleado")
                llenaprospecto(dt.Rows(0).Item("id_empleado"))
            End If
        Else
            Dim sql As String = "Update Tbl_Empleados set Emp_ApPaterno='" & txtapaterno.Text & "',Emp_ApMaterno='" & txtamaterno.Text & "',Emp_Nombres='" & txtnombre.Text & "',"
            sql += " Emp_FechaNacimiento='" & fechanac & "',Emp_LugarNacimiento='" & txtln.Text & "',Emp_Nacionalidad='" & txtnac.Text & "',Emp_sexo=" & ddlsexo.SelectedValue & ","
            sql += " Emp_EstadoCivil=" & ddledocivil.SelectedValue & ",Emp_Curp='" & txtcurp.Text & "',Emp_RFC='" & txtrfc.Text & "',Emp_NSSocial='" & txtimss.Text & "',"
            sql += " Emp_Calle='" & txtcalle.Text & "',Emp_NumeroExt='" & txtnint.Text & "',Emp_NumeroInt='" & txtnext.Text & "',Emp_Colonia='" & txtcol.Text & "',	Emp_CP='" & txtcp.Text & "',"
            sql += " Emp_Del_Municipio='" & txtdel.Text & "',Emp_Ciudad='',IdEstado=" & ddlestado.SelectedValue & ",Emp_Tel1='" & txttelp.Text & "',Emp_Tel2='" & txttelemer.Text & "',"
            sql += " Emp_Observaciones_contra='" & txtobs.Text & "',Emp_Correo='" & txtcorreo.Text & "',Status=0, Id_Puestos=" & ddlPuesto.SelectedValue & ""
            sql += " where ID_EMPLEADO=" & id.Text & ""
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
        End If
    End Sub

    Protected Sub llenaprospecto(ByVal id As Integer)
        Dim sql As String = "select * from Tbl_Empleados WHERE ID_EMPLEADO =" & id & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            txtnpros.Text = dt.Rows(0).Item("Emp_No_prospecto")
        End If
    End Sub
     Protected Sub llenagridconsulta(ByVal rfc As String)
        Dim sql As String = "select Id_Empleado,case when Status =0 then 'Prospecto' when Status =1 then 'Alta' when status=2 then 'suspendido' when status=3 then 'Baja' end Estatus,"
        sql += " case when Status =0 then Emp_No_prospecto else Emp_Numero end Numero,emp_RFC as RFC,Emp_Nombres+' '+ Emp_ApPaterno +' '+ Emp_ApMaterno as Empleado,"
        sql += " 'Calle '+ Emp_Calle +' No. Int'+ Emp_NumeroInt +' No. ext'+ Emp_NumeroExt+' Col. '+ Emp_Colonia	+' C.P. '+ Emp_CP as Direccion,"
        sql += " case when Status =0 then Emp_Fecha_alta_Prosp else Emp_FechaIngreso end Fecha_Alta,Emp_FechaBaja,Emp_NSSocial,Emp_Curp"
        sql += " from tbl_empleados where Id_empleado <> 0"
        If rfc = "" Then
            Select Case DropDownList6.SelectedValue
                Case 1
                    If TextBox1.Text <> "" Then sql += " and emp_RFC like '%" & TextBox1.Text & "%'"
                Case 2
                    If TextBox18.Text <> "" Or TextBox32.Text <> "" Or TextBox35.Text <> "" Then
                        sql += " and (Emp_Nombres +' '+ Emp_ApPaterno +' '+ Emp_ApMaterno) like '%" & TextBox18.Text & "%" & TextBox32.Text & "%" & TextBox35.Text & "%'"
                    End If
                Case 3
                    If TextBox1.Text <> "" Then sql += " and Emp_Numero=" & TextBox1.Text & ""
                Case 4
                    If TextBox1.Text <> "" Then sql += " and Emp_NSSocial='" & TextBox1.Text & "'"
                Case 5
                    If TextBox1.Text <> "" Then sql += " and Emp_Curp='" & TextBox1.Text & "'"
            End Select
        Else
            sql += " and emp_RFC='" & rfc & "'"
        End If
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        GridView2.DataSource = dt
        GridView2.DataBind()
    End Sub
    Protected Sub GridView2_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView2.DataBound

    End Sub

    Protected Sub GridView2_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView2.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.textDecoration='underline';")
                e.Row.Attributes.Add("onmouseout", "this.style.textDecoration='none';")
         
        End Select

    End Sub

    Protected Sub GridView2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView2.SelectedIndexChanged
        llenadatos(GridView2.SelectedDataKey("Id_Empleado"))
        Dim script As String = "continuar(1);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "continuar", script, True)

    End Sub
    Protected Sub llenadatos(ByVal idemp As Integer)
        Dim sql As String = "Select * from tbl_empleados where Id_empleado =" & idemp & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            id.Text = idemp
            txtrfc.Text = dt.Rows(0).Item("Emp_RFC")
            'txtfecnac.Text = dt.Rows(0).Item("")
            txtcurp.Text = dt.Rows(0).Item("Emp_Curp")
            txtnpros.Text = dt.Rows(0).Item("Emp_No_prospecto")
            txtnombre.Text = dt.Rows(0).Item("Emp_Nombres")
            txtapaterno.Text = dt.Rows(0).Item("Emp_ApPaterno")
            txtamaterno.Text = dt.Rows(0).Item("Emp_ApMaterno")
            ddlsexo.SelectedValue = dt.Rows(0).Item("Emp_sexo")
            txtcalle.Text = dt.Rows(0).Item("Emp_Calle")
            txtnint.Text = dt.Rows(0).Item("Emp_NumeroInt")
            txtnext.Text = dt.Rows(0).Item("Emp_NumeroExt")
            txtcol.Text = dt.Rows(0).Item("Emp_Colonia")
            txtdel.Text = dt.Rows(0).Item("Emp_Del_Municipio")
            ddlestado.SelectedValue = dt.Rows(0).Item("IdEstado")
            txtcp.Text = dt.Rows(0).Item("Emp_CP")
            txtln.Text = dt.Rows(0).Item("Emp_LugarNacimiento")
            txtnac.Text = dt.Rows(0).Item("Emp_Nacionalidad")
            ddledocivil.SelectedValue = dt.Rows(0).Item("Emp_EstadoCivil")
            txtimss.Text = dt.Rows(0).Item("Emp_NSSocial")
            txttelp.Text = dt.Rows(0).Item("Emp_Tel1")
            txttelemer.Text = dt.Rows(0).Item("Emp_Tel2")
            txtcorreo.Text = dt.Rows(0).Item("Emp_Correo")
            ddlPuesto.SelectedValue = dt.Rows(0).Item("Id_Puestos")
            txtobs.Text = dt.Rows(0).Item("Emp_Observaciones_contra")
            calculafecanio()
        End If
    End Sub
End Class
