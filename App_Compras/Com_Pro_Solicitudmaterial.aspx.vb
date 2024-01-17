Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Compras_Com_Pro_Solicitudmaterial
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function almacen() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, rtrim(nombre) as nombre from tb_almacen where id_status =1 and tipo = 1 and inventario = 0 and nombre like '%MANTENIMIENTO%' order by id_almacen")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_almacen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
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

        sqlbr.Append("select c.id_cliente, c.nombre from tb_cliente c" & vbCrLf)
        sqlbr.Append("join tb_cliente_lineanegocio cl on cl.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where cl.id_lineanegocio = 1 and c.id_status = 1" & vbCrLf)
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
    Public Shared Function sucursales(ByVal id_cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = "["

        sqlbr.Append("Select id_inmueble, nombre From tb_cliente_inmueble " & vbCrLf)
        sqlbr.Append("Where id_status = 1 and id_cliente = @id_cliente " & vbCrLf)
        sqlbr.Append("Order by nombre")

        Dim com As New SqlCommand(sqlbr.ToString(), myConnection)
        com.Parameters.AddWithValue("@id_cliente", id_cliente)
        Dim reader As SqlDataReader

        Try
            myConnection.Open()
            reader = com.ExecuteReader()

            If reader.HasRows Then

                While reader.Read()
                    If Not sql = "[" Then
                        sql += ","
                    End If
                    sql += "{id:'" & reader.Item("id_inmueble").ToString() & "'," & vbCrLf
                    sql += "desc:'" & reader.Item("nombre").ToString() & "'}" & vbCrLf
                End While

                reader.Close()

                sql += "]"

            Else

                sql = ""

            End If

        Catch ex As Exception
            sql = "error"
        Finally
            If myConnection.State = ConnectionState.Open Then
                myConnection.Close()
            End If
        End Try

        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal desc As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select b.clave as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', cast(b.preciobase as numeric(12,2))  as 'td'" & vbCrLf)
        sqlbr.Append("from tb_producto b" & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        sqlbr.Append("where b.id_servicio = 1 and b.descripcion like '%" & desc & "%' for xml path('tr'), root('tbody')")

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
    Public Shared Function producto(ByVal clave As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, b.descripcion as producto, c.descripcion as unidad, " & vbCrLf)
        sqlbr.Append("CAST(a.costopromedio as numeric(12,2))  as precio" & vbCrLf)
        sqlbr.Append("from tb_inventario a inner join tb_producto b on a.clave = b.clave  " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where a.clave = '" & clave & "' and a.id_almacen =" & almacen & " and b.id_status = 1 and b.tipo = 1 and b.id_servicio = 1")

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
    Public Shared Function guarda(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudmaterial", myConnection)
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

    <Web.Services.WebMethod()>
    Public Shared Function solicitud(ByVal idsol As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, id_cliente, convert(varchar(12), falta, 103) as falta, solicita, id_inmueble," & vbCrLf)
        sqlbr.Append("case when id_status = 1 then 'Alta' end as status " & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterial where id_solicitud = " & idsol & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{almacen:'" & dt.Rows(0)("id_almacen") & "', cliente:'" & dt.Rows(0)("id_cliente") & "', inmueble:'" & dt.Rows(0)("id_inmueble") & "', fecha:'" & dt.Rows(0)("falta") & "',"
            sql += " solicita:'" & dt.Rows(0)("solicita") & "', status:'" & dt.Rows(0)("status") & "'}"
        Else
            sql += "{almacen:0}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargadetalle(ByVal idsol As Integer, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select clave as 'td','','' as 'td','', producto as 'td','', unidad as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'form-control text-right tbeditar' as '@class', cast(cantidad as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled', 'form-control text-right' as '@class', cast(cantidad * precio as numeric(12,2)) as '@value' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-danger btquita' as '@class', 'Quitar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from( select a.clave, c.descripcion as producto, d.descripcion as unidad,  cantidad, precio" & vbCrLf)
        sqlbr.Append("From tb_solicitudmateriald a inner join tb_producto c on a.clave = c.clave inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("where a.id_solicitud  = " & idsol & ") as tabla  for xml path('tr'), root('tbody') " & vbCrLf)

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

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            idusuario.Value = usuario.Value
            idsol.Value = Request("folio")
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(usuario.Value)
        minombre = menui.minombre(usuario.Value)
    End Sub
End Class
