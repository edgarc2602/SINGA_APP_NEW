
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Xml
Imports Newtonsoft.Json

Partial Class OP_PR_OrdenTrabajo
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function Trae_id_Orden_Compra(ByVal id_orden_trabajo As Integer) As Int32

        Dim Aux_id_Orden_Compra As Int32 = 0

        Using connection As New SqlConnection((New Conexion).StrConexion)
            Dim command As New SqlCommand("SELECT isnull([id_orden],0) id_Orden_Compra FROM tb_ordencompra where id_orden_trabajo=@id_orden_trabajo", connection)
            command.Parameters.AddWithValue("@id_orden_trabajo", id_orden_trabajo)
            'Try
            connection.Open()
            Dim reader As SqlDataReader = command.ExecuteReader()
            If reader.Read() Then Aux_id_Orden_Compra = reader("id_Orden_Compra")
            reader.Close()
            'Catch ex As Exception
            '    Console.WriteLine(ex.Message)
            'End Try
        End Using
        Return Aux_id_Orden_Compra

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tipos() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select id_servicio, descripcion From tb_tipomantenimiento where id_status = 1" & vbCrLf)
        sqlbr.Append("order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_servicio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function unidad() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_unidad, descripcion from tb_unidadmedida" & vbCrLf)
        sqlbr.Append("order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_unidad") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tiposmant() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select id_servicio, descripcion From tb_tipomantenimiento where id_status = 1" & vbCrLf)
        sqlbr.Append("order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_servicio") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function localidad(ByVal inmueble As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select direccion + ' ' + colonia +' ' + cp + ' ' + delegacionmunicipio + ' ' + ciudad as ubicacion from tb_cliente_inmueble  where id_inmueble = " & inmueble & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{ubicacion:'" & dt.Rows(0)("ubicacion") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function especialidad(ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select id_especialidad, Descripcion From tb_tipomantenimientoe where id_status = 1 and id_servicio = " & tipo & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_especialidad") & "'," & vbCrLf
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

        sqlbr.Append("select a.id_cliente, a.nombre  from tb_cliente a inner join tb_cliente_lineanegocio b on a.id_cliente = b.id_cliente " & vbCrLf)
        sqlbr.Append("where a.id_status =1 and b.id_lineanegocio= 1 order by nombre")
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
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
    Public Shared Function tecnico(ByVal TipoTecnico As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""


        If TipoTecnico = "P" Then
            sqlbr.Append("select id_proveedor as id_empleado, nombre as empleado  from tb_proveedor where id_status=1 and id_lineanegocio=1 and idarea=11  order by nombre")
        Else sqlbr.Append("select id_empleado, nombre + ' ' + paterno + ' ' + rtrim(materno) as empleado  from tb_empleado where id_status = 2 and id_area = 11 order by empleado")
        End If


        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("empleado") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function proyectodes(ByVal pro As Integer, ByVal pla As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select nombre From Corporativos a inner join plaza_corporativo b on a.id_corporativo = b.id_corporativo" & vbCrLf)
        sqlbr.Append("inner join CorporativoServicio c on a.id_corporativo = c.id_corporativo" & vbCrLf)
        sqlbr.Append("where a.id_corporativo = " & pro & " and a.id_status = 1 and c.id_lineanegocio in(1,2,9) and b.id_plaza = " & pla & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{desc:'" & dt.Rows(0)("nombre") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function inmuebledes(ByVal prm As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select direccion + ' ' + colonia + ' ' + cp + ' ' + delegacionmunicipio + ' ' + b.descripcion as direccion" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_estado b on a.id_estado = b.id_estado where id_inmueble = " & prm & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString(), myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{direccion:'" & dt.Rows(0)("direccion") & "'}" & vbCrLf
        Else
            sql = "{direccion:''}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function almacenes(ByVal almacen As String, ByVal plaza As Integer, ByVal empresa As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select (select 'id' as 'th/span','', 'Descripción' as 'th/span','', 'Clave' as 'th/span' for xml path('tr'), root('thead'),type)," & vbCrLf)
        sqlbr.Append("(select a.idalmacen as 'td','', rtrim(Alm_Nombre) as 'td','', rtrim(Alm_Clave) as 'td'" & vbCrLf)
        sqlbr.Append("from Almacen a where alm_status = 0 And alm_inventario = 0 And IdPlaza = " & plaza & " And Id_Empresa = " & empresa & "" & vbCrLf)
        If almacen <> "" Then sqlbr.Append(" And alm_clave + ' ' + alm_nombre Like '%" & almacen.Trim().Replace(" ", "%") & "%'" & vbCrLf)
        sqlbr.Append("order by Alm_Nombre for xml path('tr'), root ('tbody'),type) for xml path('table')")
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        myConnection = Nothing
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function getalmacen(ByVal almacen As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_almacen as 'td','', nombre as 'td' from tb_almacen where Tipo<>1 and id_status=1 " & vbCrLf)
        If almacen <> "" Then sqlbr.Append("And nombre Like'%" & almacen & "%'" & vbCrLf)
        sqlbr.Append("For xml path('tr'), root('tbody')" & vbCrLf)

        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        myConnection.Close()
        myConnection = Nothing
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function material(ByVal desc As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        If (almacen > 0) Then


            sqlbr.Append("SELECT")

            If desc = "" Then sqlbr.Append(" TOP 100")
            sqlbr.Append(" a.clave as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', cast(a.costoultimo as numeric(12,2)) as 'td','', cast(a.existencia as numeric(12))  as 'td' " & vbCrLf)
            sqlbr.Append(",(select b.id_unidad as '@id_unidad','display: none;' AS '@style' for xml path('td'),type) " & vbCrLf)
            sqlbr.Append("From tb_inventario a" & vbCrLf)
            sqlbr.Append("inner join tb_producto b on a.clave=b.clave" & vbCrLf)
            sqlbr.Append("inner Join tb_unidadmedida c on b.id_unidad=c.id_unidad" & vbCrLf)
            sqlbr.Append("where id_almacen=" & almacen & vbCrLf)
            'sqlbr.Append("where id_almacen=14" & vbCrLf)
            If desc <> "" Then sqlbr.Append("and b.descripcion like '%" & desc & "%'" & vbCrLf)
            sqlbr.Append(" order by b.descripcion  for xml path('tr'), root('tbody')" & vbCrLf)

        Else
            'Para compra directa
            sqlbr.Append("SELECT")
            If desc = "" Then sqlbr.Append(" TOP 100")

            sqlbr.Append(" a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(a.preciobase as numeric(12,2))  as 'td', '', 0  as 'td'" & vbCrLf)
            sqlbr.Append(",(select b.id_unidad as '@id_unidad','display: none;' AS '@style' for xml path('td'),type) " & vbCrLf)
            sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
            sqlbr.Append("where tipo in(1,2) and id_status = 1 ")

            If desc <> "" Then sqlbr.Append("and a.descripcion like '%" & desc & "%'" & vbCrLf)
            sqlbr.Append(" order by b.descripcion  for xml path('tr'), root('tbody')" & vbCrLf)

        End If





        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        myConnection = Nothing
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function materialdes(ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.clave, a.descripcion , b.descripcion, cast(a.preciobase as numeric(12,2)) as precio  " & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on a.id_unidad = b.id_unidad" & vbCrLf)
        'sqlbr.Append("left outer join tb_proveedorinmueble c on " & inmueble & " = c.id_inmueble" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        sqlbr.Append("where tipo = 3 and id_status = 1 and a.descripcion like '%" & desc & "%' ")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("clave") & "', desc:'" & dt.Rows(0)("descripcion") & "', exist:'" & dt.Rows(0)("inv_existencia") & "'," & vbCrLf
            sql += "prom:'" & dt.Rows(0)("inv_promedio") & "'}" & vbCrLf
        Else
            sql = "{}"
        End If
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function pisos(ByVal idinmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select idpiso, rtrim(descripcion) as descripcion from PisoInmueble where idinmueble = " & idinmueble & " order by descripcion" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpiso") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function equipos(ByVal idpiso As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("Select idequipo, rtrim(cveequipo + '' + descripcion) as descripcion from InmueblesEquipo where idpiso = " & idpiso & " order by descripcion" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable()
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idequipo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empleados(ByVal nombre As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append(" select id_empleado as 'td', '', nombre + ' ' + paterno + ' ' + rtrim(materno) as 'td', '', " & vbCrLf)
        sqlbr.Append(" Cast(CONVERT(DECIMAL(10,2), (sueldo/30.4167)/8) as nvarchar)  as 'td'  " & vbCrLf)
        sqlbr.Append(" from tb_empleado where id_status = 2 and id_area = 11 and CAST(id_empleado AS char)+paterno+materno+nombre like '%" & nombre & "%' order by id_empleado for xml path('tr'), root('tbody')" & vbCrLf)
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        myConnection = Nothing
        Return xdoc1.OuterXml()
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ordendet(ByVal orden As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_orden, id_servicio, id_cliente, id_inmueble, id_tecnico, fregistro, id_repcliente, desctrabajos, id_status, " & vbCrLf)
        sqlbr.Append("edificio, piso, area, subarea, fejecucion, trabajosejecutados, tipo, id_especialidad, id_Proveedor From tb_ordentrabajo" & vbCrLf)
        sqlbr.Append("Where id_orden = " & orden & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)

        If dt.Rows.Count > 0 Then
            sql += "{id_orden:'" & dt.Rows(0)("id_orden") & "',"
            sql += "id_cliente:'" & dt.Rows(0)("id_cliente") & "',"
            sql += "id_servicio:'" & dt.Rows(0)("id_servicio") & "',"
            sql += "id_inmueble:'" & dt.Rows(0)("id_inmueble") & "',"
            sql += "id_tecnico:'" & dt.Rows(0)("id_tecnico") & "',"
            sql += "id_Proveedor:'" & dt.Rows(0)("id_Proveedor") & "',"

            sql += "fregistro:'" & Format(dt.Rows(0)("fregistro"), "dd/MM/yyyy") & "',"
            sql += "id_repcliente:'" & dt.Rows(0)("id_repcliente") & "',"
            sql += "id_status:'" & dt.Rows(0)("id_status") & "',"
            sql += "edificio:'" & dt.Rows(0)("edificio") & "',"
            sql += "piso:'" & dt.Rows(0)("piso") & "',"
            sql += "area:'" & dt.Rows(0)("area") & "',"
            sql += "subarea:'" & dt.Rows(0)("subarea") & "',"
            sql += "trabajos:'" & dt.Rows(0)("desctrabajos").ToString().Replace("'", "") & "'"
            If IsDBNull(dt.Rows(0)("fejecucion")) Then
                sql += " , fejecucion:'' "
            Else
                sql += " , fejecucion:'" & Format(dt.Rows(0)("fejecucion"), "dd/MM/yyyy") & "'"
            End If
            sql += " , trabajosejecutados:'" & dt.Rows(0)("trabajosejecutados").ToString().Replace("'", "") & "',"
            sql += "tipo: " & dt.Rows(0)("tipo") & ", especialidad: " & dt.Rows(0)("id_especialidad") & ""

            sql += " }"

        Else
            sql = "{}"
        End If

        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ordendetmat(ByVal prm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sqlb As New StringBuilder
        Dim sql As String = ""
        'Dim dto As New Generic.Dictionary(Of String, String)
        'dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)

        sqlbr.Append("Select RTrim(a.clave) as clave, rtrim(replace(a.Descripcion, '""', '')) as descripcion, cast(Cantidad as numeric(8,2)) as cantidad, " & vbCrLf)
        sqlbr.Append("d.descripcion as unidad, cast(c.costoultimo As numeric(8, 2)) As costo, cast(a.cantidadacobrar As numeric(8,2)) As cantcob, " & vbCrLf)
        sqlbr.Append("cast(precioventa As numeric(8, 2)) As precio, cast(total As numeric(8,2)) As total, cast(a.cantidadUtilizada as numeric(8,2)) cantidadUtilizada " & vbCrLf)
        sqlbr.Append("From tb_ordentrabajo_material a  " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida d on a.id_unidad=d.id_unidad " & vbCrLf)
        sqlbr.Append("left Join tb_inventario c on a.clave=c.clave and a.id_almacen=c.id_almacen " & vbCrLf)
        sqlbr.Append("Where a.id_orden = " & prm & " Order By a.clave   " & vbCrLf)


        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{clave:'" & dt.Rows(x)("clave") & "',"
                sql += "desc:'" & dt.Rows(x)("descripcion") & "',"
                sql += "cant:'" & dt.Rows(x)("cantidad") & "',"
                sql += "uni:'" & dt.Rows(x)("unidad") & "',"
                sql += "costo:'" & dt.Rows(x)("costo") & "',"
                sql += "cantcob:'" & dt.Rows(x)("cantcob") & "',"
                sql += "precio:'" & dt.Rows(x)("precio") & "', "
                sql += "cantidadUtilizada:'" & dt.Rows(x)("cantidadUtilizada") & "',"
                sql += "total:'" & dt.Rows(x)("total") & "'}"
            Next
        End If
        sql += "]"
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function ordenalm(ByVal prm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlb As New StringBuilder
        Dim sql As String = ""
        'Dim dto As New Generic.Dictionary(Of String, String)
        'dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)
        sqlb.Append("select top(1) a.id_almacen, b.nombre from tb_ordentrabajo_material a inner join tb_almacen b on a.id_almacen=b.id_almacen " & vbCrLf)
        sqlb.Append(" where id_orden=" & prm & ";" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlb.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = ""
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_almacen") & "',"
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}"
            Next
        End If
        sql += ""
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ordendetper(ByVal prm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        'Dim dto As New Generic.Dictionary(Of String, String)
        'dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)

        sqlbr.Append("SELECT a.id_empleado,  nombre + ' ' + paterno + ' ' + rtrim(materno) as empleado , cast(costoxhora as numeric(8,2)) as chora , " & vbCrLf)
        sqlbr.Append("cast(horas As numeric(8, 2))  as horas, cast(Total as numeric(8,2)) as total " & vbCrLf)
        sqlbr.Append(" From tb_ordentrabajo_mobra a " & vbCrLf)
        sqlbr.Append(" inner join tb_empleado b on a.Id_Empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append(" where id_orden=" & prm & vbCrLf)
        sqlbr.Append(" Order By nombre " & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_empleado") & "',"
                sql += "empleado:'" & dt.Rows(x)("empleado") & "',"
                sql += "chora:'" & dt.Rows(x)("chora") & "',"
                sql += "horas:'" & dt.Rows(x)("horas") & "',"
                sql += "total:'" & dt.Rows(x)("total") & "'}"
            Next
        End If
        sql += "]"
        Return sql

    End Function

    '<Web.Services.WebMethod()>
    'Public Shared Function valida(ByVal prm As String) As String
    'Dim dto As New Generic.Dictionary(Of String, String)
    'dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)

    'Dim con As String = (New Conexion).StrConexion
    'Dim sql As String = "Declare @ord int, @fec Date, @plaza smallint, @emp tinyint;" & vbCrLf
    'sql += "Select @ord = " & dto("orden") & ", @fec = convert(Date, '" & dto("fecha") & "', 103)"
    'sql += ", @plaza = " & dto("plaza") & ", @emp = " & dto("emp") & ";" & vbCrLf
    'sql += "select a.Id_Orden, a.Id_Status, a.FechaAlta, b.Id_Plaza, b.Id_Mes, b.ano as anio" & vbCrLf
    'sql += "from OrdenTrabajo a" & vbCrLf
    'sql += "left outer join Mes_Cierre b on a.Id_Plaza = b.Id_Plaza And month(a.FechaAlta) = b.Id_Mes And year(a.FechaAlta) = b.ano" & vbCrLf
    'sql += "where a.Id_Orden = @ord And a.Id_Plaza = @plaza And a.Id_Empresa = @emp;"

    'Dim dt As New DataTable()
    'Dim da As New SqlDataAdapter(sql, con)
    'sql = ""
    'da.Fill(dt)
    'If dt.Rows.Count > 0 Then
    '    If IsDBNull(dt.Rows(0)("Id_Mes")) Then
    '        If dt.Rows(0)("Id_Status") > 2 Then
    '            sql = "{cmd: false, msg: 'La orden de trabajo esta cerrada o cancelada, no puede modificarse.'}"
    '        Else
    '            sql = "{cmd: true, msg: 'Puede modificarse.'}"
    '        End If
    '    Else
    '        sql = "{cmd: false, msg: 'El periodo se encuentra cerrado, verifique.'}"
    '    End If
    'Else
    '    sql = "{cmd: false, msg: 'La Orden de trabajo " & dto("orden") & " no existe.'}"
    'End If
    'Return sql
    'End Function


    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal orden As String, ByVal material As String, ByVal empleado As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ordentrabajo", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecera", orden)
        Dim prm1 As New SqlParameter("@FolioOT", 0)
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return prm1.Value
        'Return 15
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaevidencia(tipo As Integer, orden As Integer, usuario As Integer, archivo As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("insert into tb_evidencias_ordentrabajo values(@orden, @tipo, @usuario, getdate(), @archivo)", myConnection)
        mycommand.CommandType = CommandType.Text
        mycommand.Parameters.AddWithValue("@tipo", tipo)
        mycommand.Parameters.AddWithValue("@orden", orden)
        mycommand.Parameters.AddWithValue("@usuario", usuario)
        mycommand.Parameters.AddWithValue("@archivo", archivo)

        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        Return ""
        'Return 15
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function obtieneevidencias(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select case when id_evidencia = 1 then 'Reporte' when id_evidencia = 2 then 'CheckList' end as 'td','', convert(datetime,fecha_alta,120) as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary evidencia' as '@class', archivo as '@archivo', 'button' as '@type', 'Descargar' as '@value' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_evidencias_ordentrabajo where id_ordentrabajo = @orden for xml path('tr'), root('tbody')")

        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        mycommand.Parameters.AddWithValue("@orden", folio)
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
    Public Shared Function DownloadFile(idorden As Integer, fileName As String) As String
        'Set the File Folder Path.
        Dim path As String = "c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\ordenes\" + idorden.ToString() + "/evidencias/" + fileName

        'Read the File as Byte Array.
        Dim bytes As Byte() = File.ReadAllBytes(path)

        'Convert File to Base64 string and send to Client.
        Return Convert.ToBase64String(bytes, 0, bytes.Length)
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaemp(ByVal emp As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ordentrabajo_personal", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecera", emp)
        'Dim prm1 As New SqlParameter("@FolioOT", 0)
        'prm1.Size = 10
        'prm1.Direction = ParameterDirection.Output
        'mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        'Return prm1.Value
        Return 0
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminaemp(ByVal prm As String) As String
        Dim dto As New Generic.Dictionary(Of String, String)
        dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)

        Dim sql As String = "Delete from manodeobra where idorden =" & dto("ord") & " and idplaza =" & dto("pla") & " and id_empresa =" & dto("empr") & " and idempleado = " & dto("empleado") & ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function EntradaSalida_Almacen(ByVal xmlgrabamat As String, ByVal xmlEntrada_Almacen As String, ByVal xmlSalida_Almacen As String) As String
        Dim AuxReturn As String = "Ok"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_ordentrabajo_material", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@cabecera", xmlgrabamat)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", xmlEntrada_Almacen)
            mycommand.Parameters.AddWithValue("@docto", 3)
            Dim prm1 As New SqlParameter("@Id", 0)
            prm1.Size = 10
            prm1.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prm1)
            mycommand.ExecuteNonQuery()


            mycommand = New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", xmlSalida_Almacen)
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", xmlSalida_Almacen)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            'folio = prmR.Value
            trans.Commit()
        Catch ex As Exception
            trans.Rollback()
            AuxReturn = ex.Message.ToString()
        Finally
            myConnection.Close()
        End Try

        Return AuxReturn

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function Elimina_EntradaSalida_Almacen(ByVal xmlgrabamat As String, ByVal xmlEntrada_Almacen As String, ByVal xmlSalida_Almacen As String) As String
        Dim AuxReturn As String = "Ok"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_ordentrabajo_material", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@cabecera", xmlgrabamat)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", xmlEntrada_Almacen)
            mycommand.Parameters.AddWithValue("@docto", 3)
            Dim prm1 As New SqlParameter("@Id", 0)
            prm1.Size = 10
            prm1.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prm1)
            mycommand.ExecuteNonQuery()


            mycommand = New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", xmlSalida_Almacen)
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", xmlSalida_Almacen)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            'folio = prmR.Value
            trans.Commit()
        Catch ex As Exception
            trans.Rollback()
            AuxReturn = ex.Message.ToString()
        Finally
            myConnection.Close()
        End Try

        Return AuxReturn

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardamat(ByVal emp As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ordentrabajo_material", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecera", emp)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Return 0
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaMatSalida(ByVal xmlgrabamat As String, ByVal xmlgrabasalida As String) As String
        Dim AuxReturn As String = "Ok"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            Dim mycommand As New SqlCommand("sp_ordentrabajo_material", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@cabecera", xmlgrabamat)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", xmlgrabasalida)
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", xmlgrabasalida)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            'folio = prmR.Value

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            AuxReturn = ex.Message.ToString()
        Finally
            myConnection.Close()
        End Try

        Return AuxReturn

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardasalida(ByVal registro As String) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            'myConnection.Open()
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

        End Try
        myConnection.Close()
        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaentrada(xmlgrabamat As String, ByVal registro As String) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            Dim mycommand As New SqlCommand("sp_ordentrabajo_material", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@cabecera", xmlgrabamat)
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 2)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            'myConnection.Open()
            mycommand.ExecuteNonQuery()

            mycommand = New SqlCommand("sp_kardexsalida", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            mycommand.Parameters.AddWithValue("@Kdval", prmR.Value)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

        End Try
        myConnection.Close()
        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function eliminamat(ByVal material As String) As String
        Dim aa As String = ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim prmR As New SqlParameter
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            If material <> "" Then
                Dim mycommand As New SqlCommand("uop_EntradaAlmacen", myConnection, trans)
                mycommand.CommandType = CommandType.StoredProcedure
                mycommand.Parameters.AddWithValue("@Material", material)
                mycommand.Parameters.AddWithValue("@Kdval", 0)
                Dim prmR1 As New SqlParameter("@IdMov", 0)
                prmR1.Direction = ParameterDirection.Output
                mycommand.Parameters.Add(prmR1)
                mycommand.ExecuteNonQuery()

                mycommand = New SqlCommand("uop_GeneraOTADevolucion", myConnection, trans)
                mycommand.CommandType = CommandType.StoredProcedure
                mycommand.Parameters.AddWithValue("@Material", material)
                mycommand.Parameters.AddWithValue("@folio", prmR1.Value)
                mycommand.ExecuteNonQuery()
            End If
            trans.Commit()
            aa = "{cmd: true, ord: 0}"
        Catch ex As Exception
            trans.Rollback()
            aa = "{cmd: false, msg: '" & ex.Message.ToString().Replace("'", "") & "'}"
        End Try
        myConnection.Close()
        myConnection = Nothing
        Return aa
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cierraorden(ByVal prm As String) As String
        Dim dto As New Generic.Dictionary(Of String, String)
        dto = JsonConvert.DeserializeObject(Of Generic.Dictionary(Of String, String))(prm)

        Dim rw As Integer = 0

        Dim sql As String = "Update tb_ordentrabajo set id_status = 3, fcierre = getdate() " & vbCrLf
        sql += "where id_orden =" & dto("ord") & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        rw = mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing

        If rw > 0 Then
            Return "{cmd: true, msg: 'Se ha cerrado la orden.'}"
        Else
            Return "{cmd: false, msg: 'No se ha cerrado la orden.'}"
        End If

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_status, descripcion from tb_statusot" & vbCrLf)
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_status") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualiza(ByVal folio As String, ByVal archivo As String) As String

        Dim sql As String = "insert into tb_ordentrabajo_foto (id_orden, archivo, fecha, tamano) values (" & folio & ", '" & archivo & "', getdate(), 0);"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function validaFile(ByVal Namefiles As String(), ByVal id_clavecm As Integer) As String

        Dim Aux As String = "Ok"
        Dim rutaArchivo As String = ""

        Try
            For Each nombreArchivo As String In Namefiles
                rutaArchivo = "c:\inetpub\wwwroot\SINGA_APP\Doctos\OrdenTrabajo\" + id_clavecm.ToString() + "\" + nombreArchivo '
                If File.Exists(rutaArchivo) Then
                    Aux = "El archivo " + nombreArchivo + " ya existe."
                    Exit For ' Salir del bucle si encuentras un archivo existente
                End If
            Next

        Catch ex As Exception
            Aux = "Error: " & ex.Message
        End Try

        Return Aux

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function foto(ByVal grabafoto As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ordentrabajo_foto", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecero", grabafoto)
        'Dim prm1 As New SqlParameter("@FolioOT", 0)
        'prm1.Size = 10
        'prm1.Direction = ParameterDirection.Output
        'mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        'Return prm1.Value
        Return 0
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargafoto(ByVal orden As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        'sqlbr.Append("select archivo from tb_ordentrabajo_foto where id_orden=" & orden & " order by fecha asc" & vbCrLf)
        sqlbr.Append("select (select '../Doctos/OrdenTrabajo/' + cast(id_orden as varchar(120)) +'/'+ archivo as '@src', archivo as '@alt' , '100' as '@width', '100' as '@height' for xml path('img'), type) as 'td' " & vbCrLf)
        sqlbr.Append("from tb_ordentrabajo_foto where id_orden = " & orden & " for xml path('tr'), root('tbody')")
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
    Public Shared Function alcance(ByVal orden As Integer, ByVal esp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_alcance as 'td','', descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("(select case when b.id_alcance Is Not null then 'checked' end as '@checked', 'symbol1 icono1 tbeditar' as '@class', 'checkbox' as '@type' for xml path('input'), root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_tipomantenimientoa a left outer join tb_ordentrabajo_alcance b on a.id_alcance = b.id_alcance" & vbCrLf)
        sqlbr.Append("and b.id_orden = " & orden & "" & vbCrLf)
        sqlbr.Append("where id_especialidad = " & esp & " And id_status = 1 order by descripcion for xml path('tr'), root('tbody')")
        Dim mycommand As New SqlCommand(sqlbr.ToString(), myConnection)
        myConnection.Open()
        Dim xdoc1 As New XmlDocument()
        Dim xrdr1 As XmlReader
        xrdr1 = mycommand.ExecuteXmlReader()
        If xrdr1.Read() Then
            xdoc1.Load(xrdr1)
        End If
        myConnection.Close()
        myConnection = Nothing
        Return xdoc1.OuterXml()
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load


        idplaza.Value = Session("v_plaza")
        idempresa.Value = Session("v_empresa")
        'usuario.Value = Session("v_usuario")

        Dim usuario As HttpCookie
        Dim userid As Integer

        'idfolio.Value = Request("folio")
        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = usuario.Value
            idusuario.Value = usuario.Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
