Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class App_Finanzas_Fin_Pro_PendientePago
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function facturas(ByVal idCliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id as 'td','', id_documento as 'td','', folio as 'td','', " & vbCrLf)
        sqlbr.Append("cast(total - (SELECT isnull(SUM(ft.total),0) FROM tb_factura ft WHERE ft.id_documento_pago = fa.id_documento) as numeric(12,2)) As 'td','', " & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(total - (SELECT isnull(SUM(ft.total),0) FROM tb_factura ft WHERE ft.id_documento_pago = fa.id_documento) as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbaplica' as '@class', 'checkbox' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_factura fa inner join tb_cliente_razonsocial rs on fa.rfc_receptor = rs.rfc where rs.id_cliente  = " & idCliente & " and fa.tipo_documento = 1 and cast(total - (SELECT isnull(SUM(ft.total),0) FROM tb_factura ft WHERE ft.id_documento_pago = fa.id_documento) as numeric(12,2)) != 0 order by fecha_emision_docto desc for xml path('tr'), root('tbody')")
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
    Public Shared Function detfacturas(ByVal sol As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_provision as 'td','', a.factura as 'td','', convert(char(11), b.ffactura,103) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(b.total - b.Pago as numeric(12,2)) As 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(monto as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'symbol1 icono1 tbaplica' as '@class', 'checkbox' as '@type', 'checked' as '@checked' for xml path('input'),root('td'),type)" & vbCrLf)
        'sqlbr.Append("cast(monto as numeric(12,2)) as 'td','','' as 'td'" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecursof a inner join tb_provision b on a.id_provision = b.id_provision where id_solicitud = " & sol & "" & vbCrLf)
        sqlbr.Append("for xml path('tr'), root('tbody')")
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
    Public Shared Function guarda(ByVal registro As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim aa As String = "", folio As Integer = 0
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            Dim mycommand As New SqlCommand("sp_pagofacturasingav", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            'mycommand.Parameters.AddWithValue("@tipo", tipo)
            'Dim prmR As New SqlParameter("@Idregresa", "0")
            'prmR.Size = 10
            'prmR.Direction = ParameterDirection.Output
            'mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()
            'folio = prmR.Value
            trans.Commit()
        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return folio

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function concepto(idCliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select distinct id id_concepto, convert(varchar(12),serie) + '-' + convert(varchar(12), folio) descripcion, fecha_emision_docto " & vbCrLf)
        sqlbr.Append("From tb_factura f inner Join tb_cliente_razonsocial r on f.rfc_receptor = r.rfc Where id_cliente = " & idCliente & " " & vbCrLf)
        'sqlbr.Append("And f.metodopago = 'PUE' And total > ((select isnull(sum(total),0) from tb_factura s where s.id_documento_pago = f.id_documento))  order by fecha_emision_docto desc")
        sqlbr.Append("And f.tipo_documento = 1 And total > ((select isnull(sum(total),0) from tb_factura s where s.id_documento_pago = f.id_documento)) ")
        sqlbr.Append("And f.metodopago not in ('PAG','PGS') order by fecha_emision_docto desc ")
        '
        'sqlbr.Append("select id id_concepto, convert(varchar(50),folio) descripcion from tb_factura f inner join tb_cliente_razonsocial r on f.rfc_receptor = r.rfc where id_cliente = " & idCliente & " and f.metodopago = 'PUE' order by fecha_emision_docto desc")
        '
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_concepto") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1 ")
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
    Public Shared Function cargaid(iddocumento As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id from tb_factura where id_documento = '" & iddocumento & "' ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        'sql = "["
        If dt.Rows.Count > 0 Then
            sql = dt.Rows(0)("id")
        End If
        'sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function cargasaldo(Serie As String, Folio As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select fa.total - (SELECT isnull(SUM(ft.total),0) as saldo FROM tb_factura ft WHERE ft.id_documento_pago = fa.id_documento) saldo " & vbCrLf)
        sqlbr.Append("from tb_factura fa where serie  = '" & Serie & "' and folio = '" & Folio & "' ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        'sql = "["
        If dt.Rows.Count > 0 Then
            sql += dt.Rows(0)("saldo").ToString()
        End If
        'sql += "]"
        Return sql
    End Function
    '
    <Web.Services.WebMethod()>
    Public Shared Function regresadatos(Serie As String, Folio As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sqlbriddoc As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select fa.total - (SELECT isnull(SUM(ft.total),0) as saldo FROM tb_factura ft WHERE ft.id_documento_pago = fa.id_documento) saldo,fa.id_documento, fa.id  " & vbCrLf)
        sqlbr.Append("from tb_factura fa where serie  = '" & Serie & "' and folio = '" & Folio & "' ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)

        If dt.Rows.Count > 0 Then
            sql += dt.Rows(0)("saldo").ToString() + "|" + dt.Rows(0)("id_documento").ToString() + "|" + dt.Rows(0)("id").ToString()
        End If
        'sql += "]"
        Return sql
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")
        idsol.Value = Request("folio")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            'userid = Request.Cookies("Usuario").Value
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
