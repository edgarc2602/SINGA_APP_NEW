Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class Ventas_App_Ven_Pro_Fact_PendPago
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function factura(ByVal folio As Integer, ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select factura as 'td','', cliente as 'td','', rfc as 'td','', mes as 'td','', Anio as 'td','', linea as 'td','', tipo as 'td',''," & vbCrLf)
        sqlbr.Append("fecha as 'td','', total as 'td','', pago as 'td','', total - pago as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', 0 as '@value' for xml path('input'),root('td'),type),'', uuid as 'td'" & vbCrLf)
        sqlbr.Append("from (select a.serie + a.folio as factura, c.nombre as cliente, a.rfc_receptor as rfc, d.descripcion as mes, a.Anio, e.descripcion as linea," & vbCrLf)
        sqlbr.Append("case when a.IdTpoServicio =1 then 'Iguala' else 'Fuera de iguala' end as tipo, convert(varchar(12), fecha_emision_docto ,103) as fecha," & vbCrLf)
        sqlbr.Append("a.total, (select isnull(SUM(total),0) from tb_factura as b where a.id_documento = b.id_documento_pago) As pago, a.id_documento As uuid" & vbCrLf)
        sqlbr.Append("from tb_factura a left outer join tb_cliente_razonsocial b on a.rfc_receptor = b.rfc " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("inner join tb_mes d on a.mes = d.id_mes" & vbCrLf)
        sqlbr.Append("inner join tb_lineanegocio e on a.id_lineanegocio = e.id_lineanegocio" & vbCrLf)
        sqlbr.Append("where a.tipo_documento = 1 " & vbCrLf)
        If folio <> 0 Then
            sqlbr.Append("and a.folio = " & folio & "")
        End If
        If cliente <> 0 Then
            sqlbr.Append("and c.id_cliente = " & cliente & "")
        End If
        sqlbr.Append(") as tabla where total - pago > 0 for xml path('tr'), root('tbody') ")

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
    Public Shared Function guarda(ByVal registro As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_pagofacturasingav", myConnection)
        Try
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            myConnection.Open()
            mycommand.ExecuteNonQuery()
            myConnection.Close()
        Catch ex As Exception
            Throw ex
        End Try
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
    <Web.Services.WebMethod()>
    Public Shared Function galleta(ByVal cliente As String) As String
        Dim Cookieidcliente As HttpCookie = New HttpCookie("cliente")
        Cookieidcliente.Value = cliente
        HttpContext.Current.Response.Cookies.Add(Cookieidcliente)
        Return ""
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
