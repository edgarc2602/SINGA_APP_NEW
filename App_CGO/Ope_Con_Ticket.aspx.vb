Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Con_Ticket
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT id_mes, descripcion FROM tb_mes  order by id_mes")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_mes") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente(ByVal idcliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from Tb_Cliente where id_status = 1" & vbCrLf)
        If idcliente <> 0 Then sqlbr.Append("and id_cliente = " & idcliente & "" & vbCrLf)
        sqlbr.Append("order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_cliente") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function area(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT idarea, ar_nombre FROM Tbl_Area_Empresa where ar_estatus =0 " & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and idarea = 11" & vbCrLf)
        sqlbr.Append("order by ar_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idarea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("ar_nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tickets(ByVal fini As String, ByVal ffin As String, ByVal mes As Integer, ByVal folio As Integer, ByVal cliente As Integer, ByVal area As Integer, ByVal estatus As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select No_Ticket as 'td','', estatus as 'td','', falta as 'td','',halta as 'td','', " & vbCrLf)
        sqlbr.Append("isnull(fnotifica,'') as 'td','', isnull(fescala,'') as 'td','', bandera as 'td','', ffin as 'td','', hter as 'td','',")
        sqlbr.Append("descripcion as 'td','',isnull(cliente,'') as 'td','', isnull(inmueble,'') as 'td','',Tk_Inc_Descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("Tk_CuaOri_Descripcion as 'td','', isnull(Ar_Descripcion,'') as 'td','',  Tk_Reporta as 'td','', ejecutivo as 'td','', gerente as 'td' FROM(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by id_ticket) as rownum, a.no_ticket, tk_folio,  " & vbCrLf)
        sqlbr.Append("case when Tk_Estatus =0 then 'Alta' when tk_estatus = 1 then 'Atendido' when tk_estatus = 2 then 'Cerrado' when tk_estatus = 3 then 'Cancelado' when tk_estatus = 4 then 'Cerrado sin cubrir' end estatus," & vbCrLf)
        sqlbr.Append("convert(varchar(10),Tk_FechaAlta, 103) falta, convert(varchar(5),Tk_HoraAlta,108) halta, isnull(convert(varchar(10),Tk_FechaTermino,103),'') ffin, isnull(convert(varchar(5), Tk_HoraTermino,108) ,'') hter, " & vbCrLf)
        sqlbr.Append("g.descripcion," & vbCrLf)
        sqlbr.Append("b.nombre cliente, h.nombre inmueble, f.Tk_Inc_Descripcion, i.Tk_CuaOri_Descripcion, d.Ar_Descripcion,  " & vbCrLf)
        sqlbr.Append("Tk_Reporta, Per_Paterno+' '+Per_Materno +' ' +Per_Nombre ejecutivo, e.paterno + ' ' + e.materno + ' ' + e.nombre as gerente," & vbCrLf)
        sqlbr.Append("convert(varchar(17), j.fnotifica, 113) as fnotifica, convert(varchar(17), j.fescala, 113) as fescala," & vbCrLf)
        sqlbr.Append("case when j.fnotifica is not null then " & vbCrLf)
        sqlbr.Append("  Case when convert(varchar(17),getdate(),120) < convert(varchar(17), j.fnotifica,120) then (Select 'tbborrar colorverde' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("      when convert(varchar(17),getdate(),120) >= convert(varchar(17), j.fnotifica,120) and convert(varchar(17),getdate(),120) < convert(varchar(17), j.fescala,120) then (Select 'tbborrar coloramarillo' as '@class' for xml path('span'), type)" & vbCrLf)
        sqlbr.Append("      when convert(varchar(17),getdate(),120) >= convert(varchar(17), j.fescala,120) then (Select 'tbborrar colorrojo' as '@class' for xml path('span'), type) " & vbCrLf)
        sqlbr.Append("  end" & vbCrLf)
        sqlbr.Append("else " & vbCrLf)
        sqlbr.Append("  (Select 'tbborrar colorgris' as '@class' for xml path('span'), type) " & vbCrLf)
        sqlbr.Append("end as bandera" & vbCrLf)
        sqlbr.Append("from Tbl_Ticket a left outer join tb_cliente b On a.ID_Cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("inner join Personal c On a.Tk_ID_Ejecutivo = c.IdPersonal left outer join Tbl_Area_Empresa d On a.id_area = d.IdArea" & vbCrLf)
        sqlbr.Append("left outer join tb_empleado e On b.id_operativo = e.id_empleado inner join Tbl_tk_Incidencia f On a.ID_Incidencia = f.ID_Incidencia   " & vbCrLf)
        sqlbr.Append("inner join tb_mes g On a.Tk_MesServicio = g.id_mes left outer join tb_cliente_inmueble h On a.ID_Sucursal = h.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join Tbl_tk_CausaOrigen i On a.ID_CausaOrigen = i.ID_CausaOrigen" & vbCrLf)
        sqlbr.Append("left outer join tbl_ticket_escala j On a.no_ticket = j.no_ticket" & vbCrLf)
        sqlbr.Append("where Tk_FechaAlta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If estatus <> 99 Then sqlbr.Append("and tk_estatus = " & estatus & "")
        If mes <> 0 Then sqlbr.Append("and tk_messervicio =" & mes & "")
        If folio <> 0 Then sqlbr.Append("and a.no_ticket =" & folio & "")
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente =" & cliente & "")
        If area <> 0 Then sqlbr.Append("and a.id_area =" & area & "")
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by falta for xml path('tr'), root('tbody')")
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If

        myConnection.Close()
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contartickets(ByVal fini As String, ByVal ffin As String, ByVal mes As Integer, ByVal folio As Integer, ByVal cliente As Integer, ByVal area As Integer, ByVal estatus As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM Tbl_Ticket" & vbCrLf)
        sqlbr.Append("where Tk_FechaAlta between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "' and tk_estatus = " & estatus & "")
        If mes <> 0 Then sqlbr.Append("and tk_messervicio =" & mes & "")
        If folio <> 0 Then sqlbr.Append("and no_ticket =" & folio & "")
        If cliente <> 0 Then sqlbr.Append("and id_cliente =" & cliente & "")
        If area <> 0 Then sqlbr.Append("and id_area =" & area & "")
        Dim ds As New DataTable
        Dim myconnection As String = (New Conexion).StrConexion
        Dim comm As New SqlDataAdapter(sqlbr.ToString(), myconnection)
        comm.Fill(ds)
        sql = "["
        If ds.Rows.Count > 0 Then
            For x As Integer = 0 To ds.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{pag:" & ds.Rows(x)("Filas") & "}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idcliente1.Value = Request.Cookies("Cliente").Value

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
