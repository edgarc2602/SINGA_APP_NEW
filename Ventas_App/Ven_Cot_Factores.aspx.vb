Imports System.Data
Imports System.Data.SqlClient

Partial Class Ventas_App_Ven_Cot_Factores
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
            Case "guardapp"
                guarda(Request.Params("__eventargument"))
                Select Case Request.Params("__eventargument")
                    Case 1
                    Case 2
                    Case 3

                End Select


        End Select

        If Not IsPostBack Then
            Dim sql As String = "SELECT Per_Nombre,Fecha_Alta,b.ar_descripcion from Personal a inner join area b on b.idarea=a.IdArea where IdPersonal=" & Session("v_usuario") & ""
            Dim myCommand As New SqlDataAdapter(sql, myConnection)
            Dim dt As New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                labeluser = dt.Rows(0).Item("per_nombre")
            End If
            llenaseresp()
            sql = "Select * from Tbl_Porcentaje where Por_Tipo=1 and Por_Status=0"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            If dt.Rows.Count > 0 Then
                txtpind.Text = dt.Rows(0).Item("Por_Indirecto")
                txtutil.Text = dt.Rows(0).Item("Por_Utilidad")
                txtcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
            Else
                txtpind.Text = "0"
                txtutil.Text = "0"
                txtcomer.Text = "0"
            End If

        End If

    End Sub

    Protected Sub gwp_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles gwp.SelectedIndexChanged
        Dim sql As String = "Update Tbl_ServiciosAdicionales set SAdi_Status=1 where IdPieza= " & gwp.SelectedDataKey("IdPieza")
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        llenaseresp()
    End Sub
    Protected Sub llenaseresp()
        Dim Sql As String = "SELECT IdPieza, SAdi_Clave, SAdi_DescPieza, SAdi_PrecioAutorizado, SAdi_Status , case when SAdi_Status=0 then 'Activo' else 'Cancelado' end estatus"
        Sql += " FROM Tbl_ServiciosAdicionales where SAdi_Status=0"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        gwp.DataSource = dt
        gwp.DataBind()

    End Sub

    Protected Sub Button4_Click(sender As Object, e As System.EventArgs) Handles Button4.Click
        Dim Sql As String = "Insert into Tbl_ServiciosAdicionales (SAdi_Clave, SAdi_DescPieza, SAdi_PrecioAutorizado, SAdi_Status )"
        Sql += " values ('" & txtclave.Text & "','" & txtdesc.Text & "', " & txtpv.Text & ",0)"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        llenaseresp()
        txtclave.Text = ""
        txtdesc.Text = ""
        txtpv.Text = ""
    End Sub

    Protected Sub Button5_Click(sender As Object, e As System.EventArgs) Handles Button5.Click
        Dim Sql As String = "Select * from Tbl_Porcentaje where Por_Tipo=1 and por_status=0"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            Sql = "update Tbl_Porcentaje set Por_Indirecto=" & txtpind.Text & ", Por_Utilidad=" & txtutil.Text & ", Por_Comercializacion=" & txtcomer.Text & ""
            Sql += " where Por_Tipo=1 and por_status=0"
        Else
            Sql = "Insert into Tbl_Porcentaje(Por_Tipo, Id, Por_Indirecto, Por_Utilidad, Por_Comercializacion,Por_Status)"
            Sql += " values (1,0," & txtpind.Text & ", " & txtutil.Text & "," & txtcomer.Text & ",0)"
        End If
        myCommand = New SqlDataAdapter(Sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)

    End Sub
    Protected Sub guarda(ByVal tipo As Integer)
        Dim id As Integer = 0
        Dim Sql As String = ""
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        Select Case tipo
            Case 1
                Sql = "select ID_Cliente as Id,Cte_Fis_Razon_Social from Tbl_Cliente where Cte_Fis_Razon_Social='" & txtrsc.Text & "'"
            Case 2
                Sql = " select ID_Prospecto as Id,Pros_Razon_Social as Id from tbl_prospecto where Pros_Razon_Social='" & txtrsp.Text & "'"
            Case 3
                Sql = "select ID_Cotizacion as Id,'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) from tbl_Cotizacion "
                Sql += " where cot_estatus=0 and ('COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version))='" & txtfc.Text & "'"
        End Select
        myCommand = New SqlDataAdapter(Sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            id = dt.Rows(0).Item("Id")
            Sql = " Update Tbl_Porcentaje set Por_Status=1 where Por_tipo=" & tipo + 1 & " and id=" & id & ""
            myCommand = New SqlDataAdapter(Sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)

            Sql = "Insert into Tbl_Porcentaje(Por_Tipo, Id, Por_Indirecto, Por_Utilidad, Por_Comercializacion,Por_Status)"
            Sql += " values (" & tipo + 1 & "," & id & "," & txtppind.Text & ", " & txtpputil.Text & "," & txtppcomer.Text & ",0)"
            myCommand = New SqlDataAdapter(Sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
        Else
            txtppind.Text = ""
            txtpputil.Text = ""
            txtppcomer.Text = ""
            chkcliente.Checked = False
            chkprospecto.Checked = False
            chkcotizacion.Checked = False

        End If
    End Sub
    Protected Sub Button3_Click(sender As Object, e As System.EventArgs) Handles Button3.Click
    End Sub

    Protected Sub txtrsc_TextChanged(sender As Object, e As System.EventArgs) Handles txtrsc.TextChanged
        Dim Sql As String = "SELECT Por_Indirecto, Por_Utilidad, Por_Comercializacion FROM Tbl_Porcentaje a inner join Tbl_Cliente b on b.ID_Cliente=a.Id and Por_Tipo=2 and Por_Status=0"
        Sql += "where ID=(select ID_Cliente from Tbl_Cliente where Cte_Fis_Razon_Social='" & txtrsc.Text & "')"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            txtppind.Text = dt.Rows(0).Item("Por_Indirecto")
            txtpputil.Text = dt.Rows(0).Item("Por_Utilidad")
            txtppcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
        Else
            txtppind.Text = ""
            txtpputil.Text = ""
            txtppcomer.Text = ""
        End If
    End Sub

    Protected Sub txtrsp_TextChanged(sender As Object, e As System.EventArgs) Handles txtrsp.TextChanged
        Dim Sql As String = "SELECT Por_Indirecto, Por_Utilidad, Por_Comercializacion FROM Tbl_Porcentaje a inner join Tbl_Prospecto b on b.ID_Prospecto=a.Id and Por_Tipo=3 and Por_Status=0"
        Sql += "where ID=(select ID_Cliente from Tbl_Cliente where Cte_Fis_Razon_Social='" & txtrsc.Text & "')"
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            txtppind.Text = dt.Rows(0).Item("Por_Indirecto")
            txtpputil.Text = dt.Rows(0).Item("Por_Utilidad")
            txtppcomer.Text = dt.Rows(0).Item("Por_Comercializacion")
        Else
            txtppind.Text = ""
            txtpputil.Text = ""
            txtppcomer.Text = ""
        End If

    End Sub

    Protected Sub txtfc_TextChanged(sender As Object, e As System.EventArgs) Handles txtfc.TextChanged
        txtppind.Text = ""
        txtpputil.Text = ""
        txtppcomer.Text = ""

    End Sub
End Class
