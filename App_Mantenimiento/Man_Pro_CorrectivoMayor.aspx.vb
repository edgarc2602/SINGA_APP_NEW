Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Xml
Partial Class App_Mantenimiento_Man_Pro_Correctivomayor
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function tecnico() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, nombre + ' ' + paterno + ' ' + rtrim(materno) as empleado  from tb_empleado " & vbCrLf)
        sqlbr.Append("where id_status = 2 and id_area = 11 order by empleado")
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
    Public Shared Function validaFile(ByVal Namefiles As String(), ByVal id_clavecm As Integer) As String

        Dim Aux As String = "Ok"
        Dim rutaArchivo As String = ""

        Try
            For Each nombreArchivo As String In Namefiles
                'rutaArchivo = "c:\Doctos\CM\" + id_clavecm.ToString() + "\" + nombreArchivo ' Especifica la ruta del archivo que deseas verificar
                rutaArchivo = "c:\inetpub\wwwroot\SINGA_APP\Doctos\CM\" + id_clavecm.ToString() + "\" + nombreArchivo '
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
    Public Shared Function solicitud(ByVal idsolm As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacenent, id_almacensal, id_cliente, convert(varchar(12), falta, 103) as falta, solicita, id_inmueble, observacion," & vbCrLf)
        sqlbr.Append("case when id_status = 1 then 'Alta' end as status " & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterialmantto where id_solicitud = " & idsolm & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{almacen1:'" & dt.Rows(0)("id_almacenent") & "',"
            sql += "almacen0:'" & dt.Rows(0)("id_almacensal") & "',observacion:'" & dt.Rows(0)("observacion") & "', inmueble:'" & dt.Rows(0)("id_inmueble") & "',"
            sql += "solicita:'" & dt.Rows(0)("solicita") & "', status:'" & dt.Rows(0)("status") & "'}"
        Else
            sql += "{almacen:0}"
        End If
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function producto(ByVal clave As String, ByVal almacen As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.clave, a.existencia as disponible, b.descripcion as producto, c.descripcion as unidad, " & vbCrLf)
        sqlbr.Append("CAST(a.costopromedio as numeric(12,2))  as precio" & vbCrLf)
        sqlbr.Append("from tb_inventario a inner join tb_producto b on a.clave = b.clave  " & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida c on b.id_unidad = c.id_unidad" & vbCrLf)
        'sqlbr.Append("left outer join tb_productoprecio d on a.clave = d.clave and d.id_proveedor = c.id_proveedor " & vbCrLf)
        'Jorge Mtz - Se agrega filtro por servicio = 2 (limpieza)
        sqlbr.Append("where a.clave = '" & clave & "' and a.id_almacen =" & almacen & " and b.id_status = 1 and b.tipo = 1 and b.id_servicio = 1")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{clave:'" & dt.Rows(0)("clave") & "', producto:'" & dt.Rows(0)("producto") & "', disponible:'" & dt.Rows(0)("disponible") & "', unidad:'" & dt.Rows(0)("unidad") & "', precio:'" & dt.Rows(0)("precio") & "'}"
        Else
            sql += "{clave:0}"
        End If
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function productol(ByVal tipo As String, ByVal desc As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select a.clave as 'td','', a.descripcion as 'td','', b.descripcion as 'td','', cast(a.preciobase as numeric(12,2)) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_producto a inner join tb_unidadmedida b on b.id_unidad = a.id_unidad" & vbCrLf)
        sqlbr.Append("inner join tb_familia c on c.id_familia = a.id_familia" & vbCrLf)
        sqlbr.Append("where c.tipo = '" & tipo & "' and a.descripcion Like '%" & desc & "%' and a.id_servicio = 1 for xml path('tr'), root('tbody')")

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
    Public Shared Function almacen(ByVal tipo As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_almacen, rtrim(nombre) as nombre from tb_almacen where id_status = 1 and inventario = 0  and tipo =" & tipo & " order by nombre ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id: '" & dt.Rows(x)("id_almacen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function concepto() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_concepto, descripcion from tb_conceptosolicitud where id_status = 1 order by descripcion")
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
    Public Shared Function empleadolista(ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', paterno + ' ' + rtrim(materno) + ' ' + a.nombre as 'td','', b.nombre as 'td','', a.id_empresa as 'td'" & vbCrLf)
        sqlbr.Append("from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa where id_status = 2" & vbCrLf)
        sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append("order by paterno, materno, a.nombre for xml path('tr'), root('tbody')")
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
    Public Shared Function empleado(ByVal id As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado, a.nombre + ' ' + paterno + ' ' + materno as nombre, b.nombre as empresa, a.id_empresa as idemp from tb_empleado a inner join tb_empresa b on a.id_empresa = b.id_empresa ")
        sqlbr.Append("where id_status =2 and id_empleado = " & id & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id: '" & dt.Rows(0)("id_empleado") & "', nombre: '" & dt.Rows(0)("nombre") & "'}" ', empresa: '" & dt.Rows(0)("empresa") & "', idemp: '" & dt.Rows(0)("idemp") & "'}"
        Else
            sql += "{id:''}"
        End If
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
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre + '  ' + case when clase = 1 then '(NOMINAS)' ELSE '(PROVEEDORES)' End as nombre from tb_empresa where id_estatus = 1 and clase in(1,2) order by nombre")
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
    Public Shared Function proveedor() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_proveedor, nombre from tb_proveedor where id_status = 1 order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_proveedor") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function tipo1() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_tipo, descripcion from tb_solicitudrecurso_tipo where id_status = 1 and cm = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_tipo") & "'," & vbCrLf
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
    Public Shared Function trabajo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_servicio, descripcion from tb_tipomantenimiento where id_status = 1 and cm = 1 ")
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
    Public Shared Function guardaemp(ByVal emp As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_correctivomayor_personal", myConnection)
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
    Public Shared Function guardam(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_solicitudmaterialmantto", myConnection)
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
    Public Shared Function guarda(ByVal orden As String, ByVal folio As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_correctivomayor", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@cabecera", orden)
        Dim prm1 As New SqlParameter("@FolioCM", 0)
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        If folio = 0 Then
            Dim generacorreo As New correomanto()
            generacorreo.correctivo(prm1.Value)
        End If

        Return prm1.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardasolicitud(ByVal registro As String, ByVal tipo As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim aa As String = "", folio As Integer = 0

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_solicitudrecurso", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@tipo", tipo)
            Dim prmR As New SqlParameter("@Id", "0")
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmR)
            mycommand.ExecuteNonQuery()

            folio = prmR.Value
            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        'If folio = 0 Then
        Dim generacorreo As New correofinanzas()
        generacorreo.solicitudrecurso(folio)
        'End If

        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargacorrectivo(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_clavecm, a.id_cliente, id_inmueble, convert(varchar(12), fregistro, 103) as fregistro, " & vbCrLf)
        sqlbr.Append("tope_gasto, indirecto, indirectom,  utilidad, utilidadm, presupuesto, a.id_servicio, destrabajos, tipocliente, clienten, inmueblen, c.descripcion as estatus " & vbCrLf)
        sqlbr.Append("from tb_correctivo_mayor a " & vbCrLf)
        sqlbr.Append("inner join tb_statuscm c on a.id_status = c.id_status" & vbCrLf)
        sqlbr.Append("where id_clavecm= " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_clavecm") & "',  cliente:'" & dt.Rows(0)("id_cliente") & "', inmueble:'" & dt.Rows(0)("id_inmueble") & "', fregistro:'" & dt.Rows(0)("fregistro") & "',"
            sql += " topegasto: '" & dt.Rows(0)("tope_gasto") & "', indirecto:'" & dt.Rows(0)("indirecto") & "', indirectom:'" & dt.Rows(0)("indirectom") & "',"
            sql += " utilidad: '" & dt.Rows(0)("utilidad") & "', utilidadm: '" & dt.Rows(0)("utilidadm") & "',  servicio:'" & dt.Rows(0)("id_servicio") & "',"
            sql += " presupuesto: '" & dt.Rows(0)("presupuesto") & "', trabajos:'" & dt.Rows(0)("destrabajos") & "',tipocliente:'" & dt.Rows(0)("tipocliente") & "',"
            sql += " clienten:'" & dt.Rows(0)("clienten") & "', inmueblen:'" & dt.Rows(0)("inmueblen") & "', estatus:'" & dt.Rows(0)("estatus") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargacorrectivogasto(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT (SELECT ISNULL(CAST(SUM(subtotal) AS numeric(12, 2)), 0.00) AS Expr1 FROM dbo.tb_solicitudrecurso WHERE id_status !=6 and (id_clavecm  = a.id_clavecm)) + ")
        sqlbr.Append("(SELECT    ISNULL(CAST(SUM(total) AS numeric(12, 2)), 0.00) AS Expr1 FROM dbo.tb_solicitudmaterialmantto a inner join dbo.tb_solicitudmaterialdmantto b on a.id_solicitud = b.id_solicitud  WHERE id_clavecm = a.id_clave_cm and a.id_status != 3) AS utilizado  ")
        'sqlbr.Append("(SELECT    ISNULL(CAST(SUM(total) AS numeric(12, 2)), 0.00) AS Expr1 FROM dbo.tb_correctivomayor_mobra   WHERE(id_clavecm = a.id_clavecm)) ")
        sqlbr.Append("FROM dbo.tb_correctivo_mayor  AS a WHERE id_clavecm= " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{utilizado:'" & dt.Rows(0)("utilizado") & "'}"
        End If
        Return sql
    End Function
    <Web.Services.WebMethod()>
    Public Shared Function cargasolicitudrec(ByVal cm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_solicitud as 'td','', b.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("case when a.id_tipo = 5 then d.razonsocial else c.nombre + ' ' + c.paterno + ' ' + trim(c.materno) end as 'td','', " & vbCrLf)
        sqlbr.Append("e.nombre as 'td','', convert(varchar(12), a.falta, 103) as 'td','', f.descripcion as 'td','', cast(a.subtotal as numeric(12,2)) as 'td' " & vbCrLf)
        sqlbr.Append("from tb_solicitudrecurso a inner join tb_solicitudrecurso_tipo b on a.id_tipo = b.id_tipo " & vbCrLf)
        sqlbr.Append("left outer join tb_empleado c on a.id_empleado = c.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_proveedor d on a.id_proveedor = d.id_proveedor  " & vbCrLf)
        sqlbr.Append("inner join tb_empresa e on a.id_empresa = e.id_empresa " & vbCrLf)
        sqlbr.Append("inner join tb_statussr f on a.id_status = f.id_status " & vbCrLf)
        sqlbr.Append("where id_clavecm = " & cm & " for xml path('tr'), root('tbody')")
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
    Public Shared Function cargasolicitudmat(ByVal cm As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select a.id_solicitud as 'td','', convert(varchar(12), a.falta, 103) as 'td','', b.nombre as 'td','', " & vbCrLf)
        sqlbr.Append("e.descripcion as 'td','', (select cast(sum(total) as numeric(12,2)) from tb_solicitudmaterialdmantto where id_solicitud = a.id_solicitud) as 'td','', " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type) " & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterialmantto a inner join tb_almacen b on a.id_almacenent = b.id_almacen  " & vbCrLf)
        sqlbr.Append("inner join tb_statusc e on a.id_status = e.id_status  " & vbCrLf)
        sqlbr.Append("where a.id_clave_cm = " & cm & " And a.id_status!= 3 for xml path('tr'), root('tbody')")
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
    Public Shared Function listadod(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select b.clave as 'td','', c.descripcion as 'td','', d.descripcion as 'td',''," & vbCrLf)
        sqlbr.Append("cast(b.cantidad as numeric(12,2)) as 'td' ,''," & vbCrLf)
        sqlbr.Append("cast(b.precio as numeric(12,2)) as 'td','', cast(b.cantidad * b.precio as numeric(12,2)) as 'td'")
        sqlbr.Append("from tb_solicitudmaterialmantto  a inner join tb_solicitudmaterialdmantto  b on a.id_solicitud  = b.id_solicitud  " & vbCrLf)
        sqlbr.Append("inner join tb_producto c on b.clave  = c.clave" & vbCrLf)
        sqlbr.Append("inner join tb_unidadmedida d on c.id_unidad = d.id_unidad" & vbCrLf)
        sqlbr.Append("where a.id_solicitud = " & folio & " order by c.descripcion  for xml path('tr'), root('tbody')")

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
    Public Shared Function cargaEviDoc(ByVal orden As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        'sqlbr.Append("select (select 'responsive-image' as '@class','../Doctos/cm/' + cast(id_clavecm as varchar(120)) +'/'+ archivo as '@src', archivo as '@alt' for xml path('img'), type) as 'td' " & vbCrLf)
        sqlbr.Append("select archivo as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)

        sqlbr.Append("from vt_correctivo_mayor_Doc where id_clavecm = " & orden & " for xml path('tr'), root('tbody')")
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
    Public Shared Function cargafoto(ByVal orden As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        'sqlbr.Append("select archivo from tb_ordentrabajo_foto where id_orden=" & orden & " order by fecha asc" & vbCrLf)
        sqlbr.Append("select (select 'responsive-image' as '@class','../Doctos/cm/' + cast(id_clavecm as varchar(120)) +'/'+ archivo as '@src', archivo as '@alt' for xml path('img'), type) as 'td' " & vbCrLf)
        sqlbr.Append("from vt_correctivo_mayor_IMAGEN where id_clavecm = " & orden & " for xml path('tr'), root('tbody')")
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
    Public Shared Function actualiza(ByVal id_clavecm As String, ByVal archivo As String, ByVal tipo As String) As String

        Dim sql As String = "insert into tb_correctivomayor_documento(id_clavecm, archivo, id_documento,Fecha) values (" & id_clavecm & ", '" & archivo & "', " & tipo & ",getdate());"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        usuario = Request.Cookies("Usuario")
        idorden.Value = Request("folio")
        tipotrabajo.Value = Request("tipotrabajo")
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