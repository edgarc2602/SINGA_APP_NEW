Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Partial Class App_Operaciones_Ope_tk_Dash
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
            Case "opcion"
                Select Case Request.Params("__eventargument")
                    Case 0
                        llenagrafica()
                End Select

        End Select


        If Not IsPostBack Then

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
            ddlstatus.SelectedValue = -1
            ddlmes.SelectedValue = 0


            sql = "SELECT year(Tk_FechaAlta) as anio FROM Tbl_Ticket group by year(Tk_FechaAlta)"
            myCommand = New SqlDataAdapter(sql, myConnection)
            dt = New DataTable
            myCommand.Fill(dt)
            ddlanio.DataSource = dt
            ddlanio.DataTextField = "anio"
            ddlanio.DataValueField = "anio"
            ddlanio.DataBind()
            ddlanio.Items.Add(New ListItem("Sel. el Año...", 0, True))
            ddlanio.SelectedValue = 0


            If Session("v_consulta") <> Nothing Then
                Dim filtro As Array = Session("v_consulta").ToString.Split("|")
                Dim fecini As Date = filtro(0)
                ddlanio.SelectedValue = fecini.Year
                ddlmes.SelectedValue = filtro(2)
                txtnumtk.Text = filtro(3)
                txtfolio.Text = filtro(4)
                If filtro(5) <> "" Then
                    Dim sql1 As String = "select ID_Cliente,Cte_Fis_Razon_Social from tbl_cliente where ID_Cliente=" & filtro(5)
                    Dim myCommand1 As New SqlDataAdapter(sql1, myConnection)
                    Dim dt1 As New DataTable
                    myCommand1.Fill(dt1)
                    If dt1.Rows.Count > 0 Then
                        txtrs.Text = dt1.Rows(0).Item("ID_Cliente").ToString & "|" & dt1.Rows(0).Item("Cte_Fis_Razon_Social").ToString
                    End If

                End If

                ddlarearesp.SelectedValue = filtro(6)
                ddlstatus.SelectedValue = filtro(7)

                llenagrafica()
                Session("v_consulta") = Nothing
            End If


        End If
    End Sub
    Private Sub InitializeDataSource()
        Dim dtmes As New DataTable()
        dtmes.Columns.Add("fila")
        dtmes.Columns.Add("mes")
        dtmes.Columns.Add("MesServicio")
        dtmes.Columns.Add("alta", GetType(Integer))
        dtmes.Columns.Add("atendido", GetType(Integer))
        dtmes.Columns.Add("total", GetType(Integer))
        dtmes.Columns("fila").AutoIncrement = True
        dtmes.Columns("fila").AutoIncrementSeed = 1
        dtmes.Columns("fila").AutoIncrementStep = 1

        Dim dtmesKeys As DataColumn() = New DataColumn(0) {}
        dtmesKeys(0) = dtmes.Columns("fila")
        dtmes.PrimaryKey = dtmesKeys
        ViewState("dtmes") = dtmes

        Dim dtcte As New DataTable()
        dtcte.Columns.Add("fila")
        dtcte.Columns.Add("mes")
        dtcte.Columns.Add("MesServicio")
        dtcte.Columns.Add("total", GetType(Integer))
        dtcte.Columns.Add("alta", GetType(Integer))
        dtcte.Columns.Add("atendido", GetType(Integer))
        dtcte.Columns.Add("Local", GetType(Integer))
        dtcte.Columns.Add("Foraneo", GetType(Integer))
        dtcte.Columns.Add("ID_Cliente", GetType(Integer))
        dtcte.Columns.Add("RS")
        dtcte.Columns("fila").AutoIncrement = True
        dtcte.Columns("fila").AutoIncrementSeed = 1
        dtcte.Columns("fila").AutoIncrementStep = 1

        Dim dtcteKeys As DataColumn() = New DataColumn(0) {}
        dtcteKeys(0) = dtcte.Columns("fila")
        dtcte.PrimaryKey = dtcteKeys
        ViewState("dtcte") = dtcte

        Dim dtinc As New DataTable()
        dtinc.Columns.Add("fila")
        dtinc.Columns.Add("ID_Incidencia")
        dtinc.Columns.Add("Tk_Inc_Descripcion")
        dtinc.Columns.Add("total", GetType(Integer))
        dtinc.Columns.Add("alta", GetType(Integer))
        dtinc.Columns.Add("atendido", GetType(Integer))
        dtinc.Columns.Add("Local", GetType(Integer))
        dtinc.Columns.Add("Foraneo", GetType(Integer))
        dtinc.Columns("fila").AutoIncrement = True
        dtinc.Columns("fila").AutoIncrementSeed = 1
        dtinc.Columns("fila").AutoIncrementStep = 1

        Dim dtincKeys As DataColumn() = New DataColumn(0) {}
        dtincKeys(0) = dtinc.Columns("fila")
        dtinc.PrimaryKey = dtincKeys
        ViewState("dtinc") = dtinc

        Dim dtar As New DataTable()
        dtar.Columns.Add("fila")
        dtar.Columns.Add("idarea")
        dtar.Columns.Add("ar_nombre")
        dtar.Columns.Add("total", GetType(Integer))
        dtar.Columns.Add("alta", GetType(Integer))
        dtar.Columns.Add("atendido", GetType(Integer))
        dtar.Columns.Add("Local", GetType(Integer))
        dtar.Columns.Add("Foraneo", GetType(Integer))
        dtar.Columns("fila").AutoIncrement = True
        dtar.Columns("fila").AutoIncrementSeed = 1
        dtar.Columns("fila").AutoIncrementStep = 1

        Dim dtarKeys As DataColumn() = New DataColumn(0) {}
        dtarKeys(0) = dtar.Columns("fila")
        dtar.PrimaryKey = dtarKeys
        ViewState("dtar") = dtar


    End Sub
    Protected Sub llenagrafica()
        Dim sql As String = "SELECT IdArea, Ar_Nombre FROM Tbl_Area_Empresa where isnull(ar_estatus,0) =0"
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        Dim filtro As String = ""
        'Dim emp As String = ""
        Dim mes As String = "" '"['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']"
        'Dim valoresi As String = ""
        'Dim valoresc As String = ""
        'Dim valoresf As String = ""

        'Dim empdatoTF As String = "["
        'Dim empdatoTC As String = "["
        'Dim empdatoTI As String = "["
        Dim categoria As String = ""
        Dim Serie1 As String = ""
        Dim Serie2 As String = ""
        Dim Serie3 As String = ""
        Dim Serie4 As String = ""
        Dim Serie5 As String = ""

        Dim grafica As String = ""
        'Dim grafica_cte As String = ""
        'Dim grafica_inc As String = ""
        'Dim grafica_ar As String = ""

        InitializeDataSource()


        If ddlmes.SelectedValue <> 0 Then filtro += " and a.Tk_MesServicio=" & ddlmes.SelectedValue & " "
        If IsNumeric(txtnumtk.Text) Then filtro += " and a.No_Ticket=" & txtnumtk.Text & " "
        If txtfolio.Text <> "" Then filtro += " and a.Tk_Folio='" & txtfolio.Text & "'"
        If txtrs.Text <> "" Then
            Dim sql1 As String = "select ID_Cliente from tbl_cliente where Cte_Fis_Razon_Social like '%" & txtrs.Text & "%'"
            Dim myCommand1 As New SqlDataAdapter(sql1, myConnection)
            Dim dt1 As New DataTable
            myCommand1.Fill(dt1)
            If dt1.Rows.Count > 0 Then
                filtro += " and a.ID_Cliente=" & dt1.Rows(0).Item("ID_Cliente") & ""
            End If
        End If
        If ddlarearesp.SelectedValue <> 0 Then filtro += " and a.IdArea=" & ddlarearesp.SelectedValue & " "
        If ddlstatus.SelectedValue <> -1 Then filtro += " and a.Tk_Estatus=" & ddlstatus.SelectedValue & " "
        If ddlmes.SelectedValue <> 0 Then filtro += " and month(Tk_FechaAlta) = " & ddlmes.SelectedValue & ""
        If txtnumtk.Text <> "" Then filtro += " and month(Tk_FechaAlta) = " & ddlmes.SelectedValue & ""

        sql = "select mes,MesServicio,alta=sum(alta),atendido = sum(atendido),total= sum(total) from ("
        sql += " Select mes = month(Tk_FechaAlta) ,DATENAME(MM,Tk_FechaAlta) as MesServicio"
        sql += " ,case when Tk_Estatus= 0 then 1 else 0 end alta"
        sql += " ,case when Tk_Estatus in (1,2) then 1 else 0 end atendido,total = 1 from Tbl_Ticket a"
        sql += " where year(Tk_FechaAlta) =" & ddlanio.SelectedValue & " "
        sql += filtro
        sql += ") as res group by mes,MesServicio order by mes"
        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        Dim dtmes As New DataTable
        dtmes = DirectCast(ViewState("dtmes"), DataTable)
        categoria = "" : Serie1 = "" : Serie2 = "" : Serie3 = ""
        For i = 0 To dt.Rows.Count - 1
            If categoria = "" Then
                categoria += "" & dt.Rows(i)("MesServicio") & "" : Serie1 += "" & dt.Rows(i)("alta") & "" : Serie2 += "" & dt.Rows(i)("atendido") & "" : Serie3 += "" & dt.Rows(i)("total") & ""
            Else
                categoria += "," & dt.Rows(i)("MesServicio") & "" : Serie1 += "," & dt.Rows(i)("alta") & "" : Serie2 += "," & dt.Rows(i)("atendido") & "" : Serie3 += "," & dt.Rows(i)("total") & ""
            End If
            dtmes.Rows.Add(Nothing, dt.Rows(i)("mes"), dt.Rows(i)("MesServicio"), dt.Rows(i)("alta"), dt.Rows(i)("atendido"), dt.Rows(i)("total"))
        Next
        If categoria <> "" Then categoria += "" : Serie1 += "" : Serie2 += "" : Serie3 += ""

       
        grafica_mes.Text = categoria & "|" & Serie1 & "|" & Serie2 & "|" & Serie3 & "|'Grafica por Mes de servicio'||"
        

        sql = "select mes=0,mes_servicio='',total= sum(total),alta=sum(alta),atendido = sum(atendido),Local = sum(a_local),Foraneo= sum(a_foraneo),ID_Cliente,Cte_Fis_Nombre_Comercial from ("
        sql += " Select mes = month(Tk_FechaAlta) ,DATENAME(MM,Tk_FechaAlta) as MesServicio, a.ID_Cliente,b.Cte_Fis_Nombre_Comercial"
        sql += " ,case when Tk_Estatus= 0 then 1 else 0 end alta"
        sql += " ,case when Tk_Estatus in (1,2) then 1 else 0 end atendido,total = 1"
        sql += " ,case when ID_Ambito=1 then 1 else 0 end a_local"
        sql += " ,case when ID_Ambito=2 then 1 else 0 end a_foraneo"
        sql += " from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        sql += " where year(Tk_FechaAlta) =" & ddlanio.SelectedValue & " "
        sql += filtro
        sql += " ) as res group by ID_Cliente,Cte_Fis_Nombre_Comercial --order by ID_Cliente, mes"
        sql += " union"
        sql += " select mes,MesServicio,total= sum(total),alta=sum(alta),atendido = sum(atendido),Local = sum(a_local),Foraneo= sum(a_foraneo),ID_Cliente,Cte_Fis_Nombre_Comercial from ("
        sql += " Select mes = month(Tk_FechaAlta) ,DATENAME(MM,Tk_FechaAlta) as MesServicio, a.ID_Cliente,b.Cte_Fis_Nombre_Comercial"
        sql += " ,case when Tk_Estatus= 0 then 1 else 0 end alta"
        sql += " ,case when Tk_Estatus in (1,2) then 1 else 0 end atendido,total = 1"
        sql += " ,case when ID_Ambito=1 then 1 else 0 end a_local"
        sql += " ,case when ID_Ambito=2 then 1 else 0 end a_foraneo"
        sql += " from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        sql += " where year(Tk_FechaAlta) =" & ddlanio.SelectedValue & " "
        sql += filtro
        sql += " ) as res group by mes,MesServicio,ID_Cliente,Cte_Fis_Nombre_Comercial order by ID_Cliente, mes"

        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        Dim dtcte As New DataTable
        dtcte = DirectCast(ViewState("dtcte"), DataTable)
        categoria = "" : Serie1 = "" : Serie2 = "" : Serie3 = "" : Serie4 = "" : Serie5 = ""
        For i = 0 To dt.Rows.Count - 1
            If categoria = "" Then
                categoria += "" & dt.Rows(i)("Cte_Fis_Nombre_Comercial") & "" : Serie1 += "" & dt.Rows(i)("alta") & "" : Serie2 += "" & dt.Rows(i)("atendido") & "" : Serie3 += "" & dt.Rows(i)("total") & "" : Serie4 += "" & dt.Rows(i)("Local") & "" : Serie5 += "" & dt.Rows(i)("Foraneo") & ""
            Else
                categoria += "," & dt.Rows(i)("Cte_Fis_Nombre_Comercial") & "" : Serie1 += "," & dt.Rows(i)("alta") & "" : Serie2 += "," & dt.Rows(i)("atendido") & "" : Serie3 += "," & dt.Rows(i)("total") & "" : Serie4 += "," & dt.Rows(i)("Local") & "" : Serie5 += "," & dt.Rows(i)("Foraneo") & ""
            End If
            dtcte.Rows.Add(Nothing, dt.Rows(i)("mes"), dt.Rows(i)("Mes_Servicio"), dt.Rows(i)("total"), dt.Rows(i)("alta"), dt.Rows(i)("atendido"), dt.Rows(i)("Local"), dt.Rows(i)("Foraneo"), dt.Rows(i)("ID_Cliente"), dt.Rows(i)("Cte_Fis_Nombre_Comercial"))
        Next

        'If categoria <> "" Then categoria += "]" : Serie1 += "]" : Serie2 += "]" : Serie3 += "]" : Serie4 += "]" : Serie5 += "]"
        grafica_cte.Text = categoria & "|" & Serie1 & "|" & Serie2 & "|" & Serie3 & "|'Grafica por Cliente'|" & Serie4 & "|" & Serie5 & ""




        sql = "select total= sum(total),alta=sum(alta),atendido = sum(atendido),Local = sum(a_local),Foraneo= sum(a_foraneo),ID_Incidencia,Tk_Inc_Descripcion from ("
        sql += " Select  a.ID_Incidencia,b.Tk_Inc_Descripcion"
        sql += ",case when Tk_Estatus= 0 then 1 else 0 end alta"
        sql += ",case when Tk_Estatus in (1,2) then 1 else 0 end atendido,total = 1"
        sql += ",case when ID_Ambito=1 then 1 else 0 end a_local"
        sql += ",case when ID_Ambito=2 then 1 else 0 end a_foraneo"
        sql += " from Tbl_Ticket a inner join Tbl_tk_Incidencia b on b.ID_Incidencia=a.ID_Incidencia"
        sql += " where year(Tk_FechaAlta) =" & ddlanio.SelectedValue & " "
        sql += filtro
        sql += " ) as res group by ID_Incidencia,Tk_Inc_Descripcion order by ID_Incidencia"

        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        Dim dtinc As New DataTable
        dtinc = DirectCast(ViewState("dtinc"), DataTable)
        categoria = "" : Serie1 = "" : Serie2 = "" : Serie3 = "" : Serie4 = "" : Serie5 = ""
        For i = 0 To dt.Rows.Count - 1
            If categoria = "" Then
                categoria += "" & dt.Rows(i)("Tk_Inc_Descripcion") & "" : Serie1 += "" & dt.Rows(i)("alta") & "" : Serie2 += "" & dt.Rows(i)("atendido") & "" : Serie3 += "" & dt.Rows(i)("total") & "" : Serie4 += "" & dt.Rows(i)("Local") & "" : Serie5 += "" & dt.Rows(i)("Foraneo") & ""
            Else
                categoria += "," & dt.Rows(i)("Tk_Inc_Descripcion") & "" : Serie1 += "," & dt.Rows(i)("alta") & "" : Serie2 += "," & dt.Rows(i)("atendido") & "" : Serie3 += "," & dt.Rows(i)("total") & "" : Serie4 += "," & dt.Rows(i)("Local") & "" : Serie5 += "," & dt.Rows(i)("Foraneo") & ""
            End If
            dtinc.Rows.Add(Nothing, dt.Rows(i)("ID_Incidencia"), dt.Rows(i)("Tk_Inc_Descripcion"), dt.Rows(i)("total"), dt.Rows(i)("alta"), dt.Rows(i)("atendido"), dt.Rows(i)("Local"), dt.Rows(i)("Foraneo"))
        Next
        'If categoria <> "" Then categoria += "]" : Serie1 += "]" : Serie2 += "]" : Serie3 += "]" : Serie4 += "]" : Serie5 += "]"
        grafica_inc.Text = categoria & "|" & Serie1 & "|" & Serie2 & "|" & Serie3 & "|'Grafica por Cliente'|" & Serie4 & "|" & Serie5 & ""




        sql = "select total= sum(total),alta=sum(alta),atendido = sum(atendido),Local = sum(a_local),Foraneo= sum(a_foraneo),idarea,ar_nombre from ("
        sql += " Select a.IdArea ,"
        sql += " (SELECT STUFF((SELECT '/' + Tbl_Area_Empresa.Ar_Nombre FROM Tbl_Area_Empresa WHERE convert(nvarchar(100),Tbl_Area_Empresa.IdArea) in(select substring from funcionSplit(a.IdArea,',',1000) )"
        sql += " FOR XML PATH (''), TYPE).value('.[1]', 'nvarchar(4000)'), 1, 1, '')) AS Ar_Nombre"
        sql += " ,case when Tk_Estatus= 0 then 1 else 0 end alta"
        sql += " ,case when Tk_Estatus in (1,2) then 1 else 0 end atendido,total = 1"
        sql += " ,case when ID_Ambito=1 then 1 else 0 end a_local"
        sql += " ,case when ID_Ambito=2 then 1 else 0 end a_foraneo"
        sql += " from Tbl_Ticket a"
        sql += " where year(Tk_FechaAlta) =" & ddlanio.SelectedValue & " "
        sql += filtro
        sql += " ) as res group by idarea,ar_nombre order by idarea"

        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        Dim dtar As New DataTable
        dtar = DirectCast(ViewState("dtar"), DataTable)
        categoria = "" : Serie1 = "" : Serie2 = "" : Serie3 = "" : Serie4 = "" : Serie5 = ""
        For i = 0 To dt.Rows.Count - 1
            If categoria = "" Then
                categoria += "" & dt.Rows(i)("ar_nombre") & "" : Serie1 += "" & dt.Rows(i)("alta") & "" : Serie2 += "" & dt.Rows(i)("atendido") & "" : Serie3 += "" & dt.Rows(i)("total") & "" : Serie4 += "" & dt.Rows(i)("Local") & "" : Serie5 += "" & dt.Rows(i)("Foraneo") & ""
            Else
                categoria += "," & dt.Rows(i)("ar_nombre") & "" : Serie1 += "," & dt.Rows(i)("alta") & "" : Serie2 += "," & dt.Rows(i)("atendido") & "" : Serie3 += "," & dt.Rows(i)("total") & "" : Serie4 += "," & dt.Rows(i)("Local") & "" : Serie5 += "," & dt.Rows(i)("Foraneo") & ""
            End If
            dtar.Rows.Add(Nothing, dt.Rows(i)("idarea"), dt.Rows(i)("ar_nombre"), dt.Rows(i)("total"), dt.Rows(i)("alta"), dt.Rows(i)("atendido"), dt.Rows(i)("Local"), dt.Rows(i)("Foraneo"))
        Next
        'If categoria <> "" Then categoria += "]" : Serie1 += "]" : Serie2 += "]" : Serie3 += "]" : Serie4 += "]" : Serie5 += "]"
        grafica_ar.Text = categoria & "|" & Serie1 & "|" & Serie2 & "|" & Serie3 & "|'Grafica por Cliente'|" & Serie4 & "|" & Serie5 & ""

        grafica = "muestra(0);"
        ScriptManager.RegisterStartupScript(Me, GetType(Page), "demo", grafica, True)


    End Sub

End Class
