﻿Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Pro_Listadomateriala
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select distinct a.id_cliente, nombre from tb_cliente_lineanegocio a inner join tb_cliente b on a.id_cliente = b.id_cliente  where a.id_lineanegocio = 2 and  b.id_status = 1 order by nombre")
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
    Public Shared Function inmueble(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente =" & cliente & " order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_inmueble") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function producto(ByVal clave As String, ByVal inmueble As Integer, ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, a.descripcion as producto, b.descripcion as unidad, " & vbCrLf)
        sqlbr.Append("cast(case when d.precio is null then a.preciobase else d.precio end as numeric(12,2)) as precio" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad " & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where a.clave = '" & clave & "' and id_status = 1 and tipo =1")
        If cliente = 130 Then
            sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        Else
            sqlbr.Append("and a.id_cliente != 130" & vbCrLf)
        End If
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{clave:'" & dt.Rows(0)("clave") & "', producto:'" & dt.Rows(0)("producto") & "', unidad:'" & dt.Rows(0)("unidad") & "', precio:'" & dt.Rows(0)("precio") & "'}"
        Else
            sql += "{clave:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal desc As String, ByVal inmueble As Integer, ByVal cliente As Integer, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(case when d.precio is null then a.preciobase else d.precio end as numeric(12,2))  as 'td' " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        If tipo <> 2 Then sqlbr.Append("inner join tb_cliente_listaautorizada e on a.clave = e.clave and e.id_cliente = " & cliente & "")
        sqlbr.Append("where tipo = 1 and id_status = 1 and a.descripcion like '%" & desc & "%'")
        'If cliente = 130 Then
        ' sqlbr.Append("and a.id_cliente = " & cliente & "" & vbCrLf)
        ' Else
        ' sqlbr.Append("and a.id_cliente != 130" & vbCrLf)
        ' End If
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
    Public Shared Function guardalinea(ByVal folio As Integer, ByVal clave As String, ByVal cantidad As Double, ByVal precio As Double) As String

        Dim sql As String = "insert into tb_listadomateriald (id_listado, clave, cantidad, precio) values (" & folio & ",'" & clave & "'," & cantidad & "," & precio & ");"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadod(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.clave as 'td','', '' as 'td','', b.descripcion as 'td','', c.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(a.cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type) ,''," & vbCrLf)
        sqlbr.Append("cast(a.precio as numeric(12,2)) as 'td','', cast(a.cantidad * a.precio as numeric(12,2)) as 'td','',")
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_listadomateriald a inner join tb_producto b on a.clave = b.clave " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad " & vbCrLf)
        sqlbr.Append("where id_listado = " & folio & " order by b.descripcion  for xml path('tr'), root('tbody')")

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
    Public Shared Function eliminalinea(ByVal folio As Integer, ByVal clave As String) As String

        Dim sql As String = "delete from tb_listadomateriald where id_listado = " & folio & " and clave = '" & clave & "';"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadomes(ByVal cliente As String, ByVal tipo As Integer, ByVal mes As Integer, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        Dim vtipo As Integer = 0

        sqlbr.Append("select isnull(sum(importe),0) as ptto from tb_cliente_material where id_cliente = " & cliente & " ")
        Select Case tipo
            Case 1, 3
                sqlbr.Append("and id_concepto in(1,2);")
                vtipo = 1
            Case 4
                sqlbr.Append("and id_concepto=3;")
                vtipo = 4
            Case 2
                sqlbr.Append("and id_concepto=0;")
                vtipo = 2
        End Select
        sqlbr.Append("select isnull(SUM(cantidad * precio),0) as usado from tb_listadomateriald a inner join tb_listadomaterial b on a.id_listado = b.id_listado " & vbCrLf)
        sqlbr.Append("where b.id_cliente = " & cliente & " and mes =" & mes & "  and anio =" & anio & " and tipo=" & vtipo & " AND B.id_status != 5")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{ptto: '" & dt.Tables(0).Rows(0)("ptto") & "', usado:'" & dt.Tables(1).Rows(0)("usado") & "'}"
        Else
            sql += "{ptto:0, usado:0}"
        End If

        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function listadoesp(ByVal cliente As Integer, ByVal mes As Integer, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select isnull(d.importe,0) as presupuestol, isnull(sum(c.cantidad * c.precio),0) as usado, isnull(d.importe - isnull(sum(c.cantidad * c.precio),0),0) as disp" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_listadomaterial b on a.id_inmueble = b.id_inmueble  and b.mes = " & mes & " and b.anio =" & anio & " and b.tipo = 4" & vbCrLf)
        sqlbr.Append("left outer join tb_listadomateriald c on b.id_listado = c.id_listado" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_material d on a.id_cliente = d.id_cliente and id_lineanegocio = 6 and d.id_status = 1" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & " Group by  importe " & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{ptto:'" & dt.Rows(0)("presupuestol") & "', usado:'" & dt.Rows(0)("usado") & "', disp:'" & dt.Rows(0)("disp") & "'}"
        Else
            sql += "{ptto:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function validacomp(ByVal inmueble As Integer, ByVal mes As Integer, ByVal anio As Integer, ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        If tipo = 3 Then
            sqlbr.Append("select id_listado from tb_listadomaterial where id_inmueble = " & inmueble & " and mes = " & mes & " and anio = " & anio & " and tipo = 3")
            Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
            Dim dt As New DataTable
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql += "{id: '" & dt.Rows(0)("id_listado") & "'}"
            Else
                sql += "{id:0}"
            End If
        Else
            sql += "{id:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_listadomaterial", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prmR.Value

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class