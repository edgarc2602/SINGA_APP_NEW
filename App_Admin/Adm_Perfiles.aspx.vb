Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Admin_Adm_Perfiles

    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public labeluser As String = ""
    Public labelmenu As String = ""
    Protected Function forma() As DataTable
        Dim ds As New DataTable
        ds = Cache("f" & Session("v_usuario") & "")
        If ds Is Nothing Then
            Dim Sq As String = "SELECT conse=0, fila=0,ar_nombre='',grupo='',Modulo='',IdForma as Forma, ar_label as label FROM Tbl_Formularios where IdForma=0"
            Dim da As New SqlDataAdapter(Sq, myConnection)
            ds = New DataTable
            da.Fill(ds)
            Cache.Insert("f" & Session("v_usuario") & "", ds)
        End If
        Return ds
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim Sqlm As String = "select * from func_Menu_nav(" & Session("v_usuario") & ")											"
        Dim myCommandm As New SqlDataAdapter(Sqlm, myConnection)
        Dim dtm As New DataTable
        myCommandm.Fill(dtm)
        labelmenu = dtm.Rows(0).Item("menu1")
        Select Case Request.Params("__EVENTTARGET")
            Case "guarda"
                guarda()
            Case "elimina"
                elimina()
        End Select

        If Not Page.IsPostBack Then
            Response.ExpiresAbsolute = Now().AddDays(-1)
            Response.AddHeader("pragma", "no-cache")
            Response.AddHeader("cache-control", "private")
            Response.CacheControl = "no-cache"
            Cache.Remove("f" & Session("v_usuario") & "")

            Dim Sql As String = "SELECT IdArea, Ar_Nombre, Ar_Descripcion, Ar_Posicion, ar_Estatus FROM tbl_area_menu WHERE ar_Estatus=0"
            Dim myCommand As New SqlDataAdapter(Sql, myConnection)
            Dim ds As New DataTable
            myCommand.Fill(ds)
            ddlarea.DataSource = ds
            ddlarea.DataTextField = "Ar_Nombre"
            ddlarea.DataValueField = "Idarea"
            ddlarea.DataBind()
            ddlarea.Items.Add(New ListItem("Sel.-Area...", 0, True))
            ddlarea.SelectedValue = 0
            Sql = "Select * from Tbl_Per_Grupos where gr_status=0 "
            myCommand = New SqlDataAdapter(Sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
            If ds.Rows.Count > 0 Then
                For x As Integer = 0 To ds.Rows.Count - 1
                    ListBox1.Items.Add(New ListItem(ds.Rows(x).Item("IdGrupos") & "-" & ds.Rows(x).Item("Gr_Nombre"), ds.Rows(x).Item("IdGrupos")))
                Next
            End If
        End If
    End Sub
    Protected Sub guarda()
        Dim dt As New DataTable
        dt = forma()
        On Error GoTo faltdat
        If dt.Rows.Count = 0 Then
            Err.Raise(1001 + vbObjectError, , "No puede generar el perfil porque no tiene selecionada ningun formulario")
        End If
        Dim sql As String
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim ds As New DataTable
        If txtid.Text = "" Then
            sql = "Select isnull(max(idgrupos),0) as no from Tbl_Per_Grupos"
            myCommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
            txtid.Text = ds.Rows(0).Item("no") + 1
            sql = "insert into Tbl_Per_Grupos (idgrupos,Gr_Nombre) values (" & txtid.Text & ",'" & txtnombre.Text & "')"
            myCommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
        Else
            sql = "Update Tbl_Per_Grupos set gr_Nombre ='" & txtnombre.Text & "' where IdGrupos=" & txtid.Text & ""
            myCommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
        End If
        sql = "delete from Tbl_Per_Grupos_Formas where IdGrupos=" & txtid.Text & ""
        myCommand = New SqlDataAdapter(sql, myConnection)
        ds = New DataTable
        myCommand.Fill(ds)

        Dim x As Integer
        For x = 0 To dt.Rows.Count - 1
            sql = "insert into Tbl_Per_Grupos_Formas (idgrupos,idformulario) values (" & txtid.Text & "," & dt.Rows(x).Item("forma") & ")"
            myCommand = New SqlDataAdapter(sql, myConnection)
            ds = New DataTable
            myCommand.Fill(ds)
        Next
        Response.Write("<script>alert('El Perfil se ha guardado correctamente ');</script>")
        ListBox1.Items.Clear()
        sql = "Select * from Tbl_Per_Grupos where gr_status=0 "
        myCommand = New SqlDataAdapter(sql, myConnection)
        ds = New DataTable
        myCommand.Fill(ds)
        If ds.Rows.Count > 0 Then
            For x = 0 To ds.Rows.Count - 1
                ListBox1.Items.Add(New ListItem(ds.Rows(x).Item("IdGrupos") & "-" & ds.Rows(x).Item("Gr_Nombre"), ds.Rows(x).Item("IdGrupos")))
            Next
        End If
faltdat:
        If Err.Number <> 0 Then
            If Err.Number <> -2147220503 Then
                Response.Write("Error Occurred Reading Records: " & Err.Description)
                Response.End()
            Else
                'Response.Write("Error Occurred Reading Records: " & Err.Description)
                Response.Write("<script>alert('" & Err.Description & "');</script>")
            End If
        End If
    End Sub
    Protected Sub elimina()
        Dim Sql As String = "delete from Grupos where IdGrupos=" & txtid.Text & ""
        Dim myCommand As New SqlDataAdapter(Sql, myConnection)
        Dim ds As New DataTable
        myCommand.Fill(ds)
        Sql = "delete from UsuarioGrupos where IdGrupos=" & txtid.Text & ""
        myCommand = New SqlDataAdapter(Sql, myConnection)
        ds = New DataTable
        myCommand.Fill(ds)
    End Sub
    Protected Sub ddlarea_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlarea.SelectedIndexChanged
        llenagrid_formularios()
        If ddlareaagregada.SelectedValue <> "" Then
            agregadas(ddlareaagregada.SelectedValue)
        End If
    End Sub

    Protected Sub llenagrid_formularios()
        Dim dt As New DataTable
        Dim Sql As String = "select b.Ar_Nombre,IdPadre as padre,"
        Sql += " case when IdProceso =1 then 'Catalogos' when IdProceso=2 then 'Procesos' when IdProceso = 3 then 'Consultas' else '' end as grupo,"
        Sql += " a.IdForma as Forma,Ar_Label as label"
        Sql += " from Tbl_Formularios a inner join tbl_area_menu b on a.IdArea=b.IdArea"
        Sql = Sql + " where a.IdArea = " & ddlarea.SelectedValue
        If Val(ListBox1.SelectedValue) > 0 Then
            Sql += " and a.IdForma not in (select idformulario from Tbl_Per_Grupos_Formas where idgrupos=" & ListBox1.SelectedValue & ") "
        End If
        Dim f As String
        If gvagregado.Rows.Count > 0 Then
            f = " and a.IdForma not in ("
            For i As Integer = 0 To gvagregado.Rows.Count - 1
                f += gvagregado.DataKeys(i)("Forma") & ","
            Next
            f = Left(f, Len(f) - 1)
            Sql += f & ")"
        End If
        Sql += "order by ar_nombre,ar_label"
        Dim ds As New SqlDataAdapter(Sql, myConnection)
        ds.Fill(dt)
        gwagrega.DataSource = dt
        gwagrega.DataBind()
    End Sub

    Protected Sub agregaformas()
        Dim dt As New DataTable
        dt = forma()
        Dim fila As Integer = 0
        With gwagrega
            If .Rows.Count > 0 Then
                Dim i As Integer = gwagrega.SelectedIndex
                Dim ren As DataRow
                fila = fila + 1
                ren = dt.NewRow()
                ren.Item("grupo") = HttpUtility.HtmlDecode(gwagrega.DataKeys(i).Item("grupo"))
                ren.Item("Modulo") = ddlarea.SelectedValue
                ren.Item("ar_nombre") = HttpUtility.HtmlDecode(.Rows(i).Cells(0).Text)
                ren.Item("Forma") = gwagrega.DataKeys(i).Item("Forma")
                ren.Item("label") = HttpUtility.HtmlDecode(.Rows(i).Cells(1).Text)
                dt.Rows.Add(ren)
            End If
        End With
        Dim vst As New DataView(dt)
        Dim x As Integer
        For x = 0 To vst.Count - 1
            vst.Item(x).Item("conse") = x + 1
            If x = 0 Then
                vst.Item(x).Item("fila") = 1
            Else
                If vst.Item(x - 1).Item("Modulo") <> vst.Item(x).Item("Modulo") Then
                    vst.Item(x).Item("fila") = 1
                Else
                    vst.Item(x).Item("fila") = 2
                End If
            End If
        Next
        vst.RowFilter = "modulo= '" & ddlarea.SelectedValue & "'"
        vst.Sort = "ar_nombre"
        gvagregado.DataSource = vst
        gvagregado.DataBind()
    End Sub

    Protected Sub ddlareaagregada_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlareaagregada.SelectedIndexChanged
        agregadas(ddlareaagregada.SelectedValue)
    End Sub
    Protected Sub agregadas(ByVal modulo As Integer)
        Dim dt As New DataTable
        dt = forma()
        Dim vst As New DataView(dt)
        vst.RowFilter = "Modulo = " & modulo & ""
        vst.Sort = "ar_nombre"
        gvagregado.DataSource = vst
        gvagregado.DataBind()
    End Sub
    Private Class TreeMenu
        Public Codigo As Integer
        Public Padre As Integer
        Public Desc As String
        Public URL As String
    End Class
    Protected Sub llenatre()
        Dim dt As New DataTable
        dt = forma()

        tvestructura.Nodes.Clear()
        'se crea nodo padre 
        Dim vst As New DataView()
        Dim x As Integer
        Dim nodos As TreeNodeCollection
        Dim Nodo As New TreeNode
        For i As Integer = 0 To ddlareaagregada.Items.Count - 1
            tvestructura.Nodes.Add(New TreeNode(ddlareaagregada.Items(i).Text, "N/A"))
            Nodo = New TreeNode("Catalogos")
            tvestructura.Nodes(i).ChildNodes.Add(Nodo)
            nodos = tvestructura.Nodes(i).ChildNodes
            vst = New DataView(dt)
            vst.RowFilter = "grupo = 'Catalogos' and modulo = " & ddlareaagregada.Items(i).Value & ""
            For x = 0 To vst.ToTable.Rows.Count - 1
                nodos(nodos.Count - 1).ChildNodes.Add(New TreeNode(vst.Item(x).Item("label"), "", "", "", ""))
            Next

            Nodo = New TreeNode("Procesos")
            tvestructura.Nodes(i).ChildNodes.Add(Nodo)
            nodos = tvestructura.Nodes(i).ChildNodes
            vst = New DataView(dt)
            vst.RowFilter = "grupo = 'Procesos' and modulo = " & ddlareaagregada.Items(i).Value & ""
            For x = 0 To vst.ToTable.Rows.Count - 1
                nodos(nodos.Count - 1).ChildNodes.Add(New TreeNode(vst.Item(x).Item("label"), "", "", "", ""))
            Next

            Nodo = New TreeNode("Consultas")
            tvestructura.Nodes(i).ChildNodes.Add(Nodo)
            nodos = tvestructura.Nodes(i).ChildNodes
            vst = New DataView(dt)
            vst.RowFilter = "Grupo = 'Consultas' and modulo = " & ddlareaagregada.Items(i).Value & ""
            For x = 0 To vst.ToTable.Rows.Count - 1
                nodos(nodos.Count - 1).ChildNodes.Add(New TreeNode(vst.Item(x).Item("label"), "", "", "", ""))
            Next

        Next
    End Sub
    Protected Sub limpiar()
        ddlarea.SelectedValue = 0
        txtid.Text = ""
        Cache.Remove("f" & Session("v_usuario") & "")

        llenagrid_formularios()
        Dim dt As New DataTable
        dt = forma()
        Dim vst As New DataView(dt)
        vst.RowFilter = "fila = 1"
        ddlareaagregada.DataSource = vst
        ddlareaagregada.DataTextField = "Ar_Nombre"
        ddlareaagregada.DataValueField = "modulo"
        ddlareaagregada.DataBind()
        ddlareaagregada.SelectedValue = ddlarea.SelectedValue
        txtnombre.Text = ""
        tvestructura.Nodes.Clear()
        If Val(ListBox1.SelectedValue) > "0" Then ListBox1.SelectedItem.Selected = False
    End Sub

    Protected Sub ListBox1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ListBox1.SelectedIndexChanged
        agregaformasexistentes(ListBox1.SelectedValue)
        Dim v_par As Array
        v_par = (ListBox1.SelectedItem.Text).Split("-")
        txtnombre.Text = v_par(1)
        txtid.Text = ListBox1.SelectedValue
        llenagrid_formularios()

    End Sub

    Protected Sub agregaformasexistentes(ByVal grupo As Integer)
        Cache.Remove("f" & Session("v_usuario") & "")
        Dim Sql As String = "SELECT Ar_Nombre,"
        Sql += " case when IdProceso=1 then 'Catalogos' when IdProceso=2 then 'Procesos' when IdProceso = 3 then 'Consultas' else '' end as grupo "
        Sql += " ,IdForma as Forma, ar_label as label,a.IdArea"
        Sql += " FROM Tbl_Formularios a inner join tbl_area_menu b on a.IdArea=b.IdArea"
        Sql += " inner join Tbl_Per_Grupos_Formas c on c.idformulario =a.IdForma"
        Sql += " where idgrupos=" & grupo & " ORDER BY Ar_nombre"
        Dim ds As New SqlDataAdapter(Sql, myConnection)
        Dim dt1 As New DataTable
        ds.Fill(dt1)
        If dt1.Rows.Count > 0 Then
            Dim dt As New DataTable
            dt = forma()
            Dim fila As Integer = 0
            With dt1
                If .Rows.Count > 0 Then
                    For i As Integer = 0 To .Rows.Count - 1
                        Dim ren As DataRow
                        fila = fila + 1
                        ren = dt.NewRow()
                        ren.Item("grupo") = HttpUtility.HtmlDecode(dt1.Rows(i).Item("grupo"))
                        ren.Item("Modulo") = dt1.Rows(i).Item("Idarea")
                        ren.Item("ar_nombre") = HttpUtility.HtmlDecode(dt1.Rows(i).Item("ar_nombre"))
                        ren.Item("Forma") = dt1.Rows(i).Item("Forma")
                        ren.Item("label") = HttpUtility.HtmlDecode(dt1.Rows(i).Item("label"))
                        dt.Rows.Add(ren)
                    Next
                End If
            End With
            Dim vst As New DataView(dt)
            Dim x As Integer
            For x = 0 To vst.Count - 1
                vst.Item(x).Item("conse") = x + 1
                If x = 0 Then
                    vst.Item(x).Item("fila") = 1
                Else
                    If vst.Item(x - 1).Item("Modulo") <> vst.Item(x).Item("Modulo") Then
                        vst.Item(x).Item("fila") = 1
                    Else
                        vst.Item(x).Item("fila") = 2
                    End If
                End If
            Next
            vst.Sort = "ar_nombre"
            gvagregado.DataSource = vst
            gvagregado.DataBind()

            vst.RowFilter = "fila = 1"
            ddlareaagregada.DataSource = vst
            ddlareaagregada.DataTextField = "Ar_Nombre"
            ddlareaagregada.DataValueField = "modulo"
            ddlareaagregada.DataBind()

            agregadas(ddlareaagregada.SelectedValue)
            llenatre()
        End If
    End Sub

    Protected Sub gwagrega_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gwagrega.SelectedIndexChanged
        If gwagrega.Rows.Count > 0 Then
            agregaformas()
            llenagrid_formularios()
            Dim dt As New DataTable
            dt = forma()
            Dim vst As New DataView(dt)
            vst.RowFilter = "fila = 1"

            ddlareaagregada.DataSource = vst
            ddlareaagregada.DataTextField = "Ar_Nombre"
            ddlareaagregada.DataValueField = "modulo"
            ddlareaagregada.DataBind()
            ddlareaagregada.SelectedValue = ddlarea.SelectedValue
            llenatre()
            gwagrega.SelectedIndex = -1
        End If
    End Sub

    Protected Sub gvagregado_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvagregado.SelectedIndexChanged
        If gvagregado.Rows.Count > 0 Then
            Dim dt As New DataTable
            dt = forma()
            With gvagregado
                If .Rows.Count > 0 Then
                    dt.Rows(gvagregado.DataKeys(gvagregado.SelectedIndex)("conse") - 1).Delete()
                End If
            End With
            Dim vst As New DataView(dt)
            Dim x As Integer
            For x = 0 To vst.Count - 1
                vst.Item(x).Item("conse") = x + 1
                If x = 0 Then
                    vst.Item(x).Item("fila") = 1
                Else
                    If vst.Item(x - 1).Item("Modulo") <> vst.Item(x).Item("Modulo") Then
                        vst.Item(x).Item("fila") = 1
                    Else
                        vst.Item(x).Item("fila") = 2
                    End If
                End If
            Next
            vst.RowFilter = "ar_nombre = '" & ddlareaagregada.SelectedItem.Text & "'"
            vst.Sort = "ar_nombre"
            gvagregado.DataSource = vst
            gvagregado.DataBind()
            dt = forma()
            vst = New DataView(dt)
            vst.RowFilter = "fila = 1"

            ddlareaagregada.DataSource = vst
            ddlareaagregada.DataTextField = "Ar_Nombre"
            ddlareaagregada.DataValueField = "modulo"
            ddlareaagregada.DataBind()
            llenatre()
            If ddlareaagregada.SelectedValue <> "" Then
                agregadas(ddlareaagregada.SelectedValue)
            End If
            gvagregado.SelectedIndex = -1
            llenagrid_formularios()
        End If
    End Sub
End Class
