Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class App_Finanzas_Fin_Pro_Cancelafacturas
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function contarfactura(ByVal mes As Integer, ByVal anio As Integer, ByVal cliente As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        'sqlbr.Append("SELECT COUNT(*)/20 + 1 as Filas, COUNT(*) % 20 as Residuos FROM tb_factura a where " & vbCrLf)
        'sqlbr.Append(" total > ((select isnull(sum(total),0) from tb_factura s where s.id_documento_pago = a.id_documento)) " & vbCrLf)
        'If campo <> "0" Then
        '    sqlbr.Append("and " & campo & " like '%" & dato & "%'" & vbCrLf)
        'End If
        sqlbr.Append("SELECT COUNT(*)/20 + 1 as Filas, COUNT(*) % 20 as Residuos FROM tb_clientependfactdet " & vbCrLf)
        sqlbr.Append(" where montoafacturar !=0 and mes = " & mes & " and anio = " & anio & "")
        If cliente <> 0 Then
            sqlbr.Append(" and id_cliente= " & cliente & "" & vbCrLf)
        End If
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
    <Web.Services.WebMethod()>
    Public Shared Function cancelarfactura(ByVal registro As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim aa As String = "", folio As Integer = 0
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            Dim mycommand As New SqlCommand("sp_cancelapendientefacturar", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.ExecuteNonQuery()
            trans.Commit()
        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return ""

    End Function


    <Web.Services.WebMethod()>
    Public Shared Function factura(ByVal pagina As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("SELECT id_cliente as 'td','', rtrim(cliente) as 'td','',  mes as 'td','',  anio as 'td','', " & vbCrLf)
        sqlbr.Append("lineanegocio as 'td','',  tiposervicio as 'td','', cast(montoafacturar as numeric(12,2)) as 'td','', cast(montofacturado as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("cast(isnull(cancelado,0) as numeric(12,2)) as 'td','', cast(isnull(saldo,0) - isnull(cancelado,0) as numeric(12,2)) as 'td','', id_mes as 'td','', id_lineanegocio as 'td', '', id_tiposervicio as 'td'" & vbCrLf)
        sqlbr.Append("from " & vbCrLf)
        sqlbr.Append("(SELECT ROW_NUMBER()Over(Order by ct.nombre) As RowNum, a.id_cliente, ct.nombre as cliente, m.descripcion as mes, a.anio,a.id_lineanegocio, l.descripcion lineanegocio," & vbCrLf)
        sqlbr.Append("case when a.Id_tiposervicio = 1 then 'Iguala' else 'Fuera de iguala' end tiposervicio, montoafacturar, montofacturado, montoafacturar - montofacturado as saldo, m.id_mes, a.Id_tiposervicio," & vbCrLf)
        sqlbr.Append("(select sum(montocancelafactura) from tb_clientependcancela b where a.id_cliente = b.id_cliente and a.mes = b.mes and a.anio = b.anio and a.id_lineanegocio = b.id_lineanegocio and a.id_tiposervicio = b.id_tipo) as cancelado" & vbCrLf)
        sqlbr.Append("FROM tb_clientependfactdet a inner join tb_cliente ct on ct.id_cliente = a.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_mes m on m.id_mes = a.mes " & vbCrLf)
        sqlbr.Append("inner join tb_lineanegocio l on l.id_lineanegocio = a.id_lineanegocio " & vbCrLf)
        sqlbr.Append("left outer join tb_clientependcancela b on a.id_cliente = b.id_cliente and a.mes = b.mes and a.anio = b.anio and a.id_lineanegocio = b.id_lineanegocio and a.id_tiposervicio = b.id_tipo" & vbCrLf)
        sqlbr.Append("WHERE a.montoafacturar !=0 and a.mes = " & mes & " and a.anio = " & anio & " " & vbCrLf)
        If cliente <> 0 Then
            sqlbr.Append(" and a.id_cliente= " & cliente & "" & vbCrLf)
        End If
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 20 + 1 And " & pagina & " * 20 order by cliente for xml path('tr'), root('tbody') ")
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
    Public Shared Function detalle(ByVal idCliente As Integer, ByVal Mes As Integer, ByVal Anio As String, ByVal idlineaneg As Integer, ByVal idtiposerv As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim SqlSaldo As String
        SqlSaldo = "select isnull(SUM(montofacturado),0) saldo from tb_clientependfactdet where id_cliente = '" & idCliente & "'"
        SqlSaldo = SqlSaldo & " And mes = " & Mes & " And anio = " & Anio & "  And id_lineanegocio = " & idlineaneg & " " & vbCrLf
        SqlSaldo = SqlSaldo & " And id_tipoServicio = " & idtiposerv & " " & vbCrLf
        Dim dsSaldo As New DataSet
        Dim daSaldo As New SqlDataAdapter(SqlSaldo, myConnection)
        daSaldo.Fill(dsSaldo)

        Dim sql As String = ""
        sqlbr.Append("Select a.id_cliente, c.nombre, a.id_lineanegocio, a.id_tiposervicio, a.mes, a.anio ,a.montoafacturar , a.montofacturado, a.faplica " & vbCrLf)
        sqlbr.Append("From tb_clientependfactdet a inner join tb_cliente c on a.id_cliente = c.id_cliente  where a.id_cliente = '" & idCliente & "' " & vbCrLf)
        sqlbr.Append("And a.mes = " & Mes & " And a.anio = " & Anio & "  And a.id_lineanegocio = " & idlineaneg & " " & vbCrLf)
        sqlbr.Append("And a.id_tipoServicio = " & idtiposerv & "   " & vbCrLf)

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim ds As New DataSet
        da.Fill(ds)
        Dim x As Integer = 0
        sql = "{" 'faplica
        If ds.Tables(0).Rows().Count > 0 Then
            sql += "id_cliente:" & ds.Tables(0).Rows(0).Item("id_cliente") & ", nombre:'" & ds.Tables(0).Rows(0).Item("nombre").ToString().ToUpper() & "', id_lineanegocio:'" & ds.Tables(0).Rows(0).Item("id_lineanegocio").ToString().ToUpper() & "', IdTipoServicio:'" & ds.Tables(0).Rows(0).Item("Id_TipoServicio").ToString().ToUpper() & "',"
            sql += "mes:'" & ds.Tables(0).Rows(0).Item("mes") & "', anio:'" & ds.Tables(0).Rows(0).Item("anio") & "', "
            sql += "montoafacturar:'" & ds.Tables(0).Rows(0).Item("montoafacturar") & "', montofacturado:'" & ds.Tables(0).Rows(0).Item("montofacturado") & "', "
            sql += "faplica:'" & ds.Tables(0).Rows(0).Item("faplica") & "' "

            If dsSaldo.Tables(0).Rows().Count > 0 Then
                sql += ",saldo:" & ds.Tables(0).Rows(0).Item("montoafacturar") - dsSaldo.Tables(0).Rows(0).Item("saldo") & " "
            End If
        End If
        ds.Dispose()
        dsSaldo.Dispose()
        sql += "}"
        Return sql

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function linea() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_lineanegocio, descripcion from tb_lineanegocio where reportes = 1 order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_lineanegocio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function calculosaldo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT SUM() FROM tbl_TipoServicio ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdTpoServicio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function tiposervicio() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT IdTpoServicio, ts_Descripcion as descripcion FROM tbl_TipoServicio ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdTpoServicio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function descrclave(Catalog As String, Clave As String, Descripcion As String, ValorDesc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select " & Clave & " as clave from " & Catalog & " where " & Descripcion & " = '" & ValorDesc & "' ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)

        'sql = "["
        If dt.Rows.Count > 0 Then
            sql += "{opt:" & dt.Rows(0)("clave") & "}" & vbCrLf
        End If
        'sql += "]"

        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_mes, descripcion from tb_mes order by id_mes")
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
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 and tipo = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empresa") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_pagofacturasinga", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Idregresa", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function galleta(ByVal cliente As String) As String
        Dim Cookieidcliente As HttpCookie = New HttpCookie("cliente")
        Cookieidcliente.Value = cliente
        HttpContext.Current.Response.Cookies.Add(Cookieidcliente)
        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 order by nombre")
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

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
