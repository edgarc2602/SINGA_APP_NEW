Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class Ventas_App_Ven_Con_Cliente_Cedula
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cliente() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_cliente, nombre from tb_cliente where id_status = 1  order by nombre")
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
    Public Shared Function resumen(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select iguala, salario, cargasocial, (aguinaldo + primavac) as provision, isnull(uniforme,0) as uniforme, material, herramienta, otroequipo, subcontrato, viatico," & vbCrLf)
        sqlbr.Append("(salario + cargasocial + aguinaldo + primavac + isnull(uniforme,0) + material + herramienta + otroequipo + subcontrato + viatico) as tcosto," & vbCrLf)
        sqlbr.Append("iguala - (salario + cargasocial + aguinaldo + primavac + isnull(uniforme,0) + material + herramienta + otroequipo + subcontrato + viatico) as margen," & vbCrLf)
        sqlbr.Append("cast(((iguala - (salario + cargasocial + aguinaldo + primavac + isnull(uniforme,0) + material + herramienta + otroequipo + subcontrato + viatico))/iguala) * 100 As numeric(12,2))  As pmargen " & vbCrLf)
        sqlbr.Append("from vt_cliente_cedula where id_cliente   = '" & cliente & "'")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{iguala:'" & Format(dt.Rows(0)("iguala"), "#0,0.00") & "', salario:'" & Format(dt.Rows(0)("salario"), "#0,0.00") & "', cargasocial:'" & Format(dt.Rows(0)("cargasocial"), "#0,0.00") & "', provision:'" & Format(dt.Rows(0)("provision"), "#0,0.00") & "', uniforme:'" & Format(dt.Rows(0)("uniforme"), "#0,0.00") & "', material:'" & Format(dt.Rows(0)("material"), "#0,0.00") & "'," & vbCrLf
            sql += "herramienta:'" & Format(dt.Rows(0)("herramienta"), "#0,0.00") & "', otroequipo:'" & Format(dt.Rows(0)("otroequipo"), "#0,0.00") & "', subcontrato:'" & Format(dt.Rows(0)("subcontrato"), "#0,0.00") & "'," & vbCrLf
            sql += "viatico:'" & Format(dt.Rows(0)("viatico"), "#0,0.00") & "', tcosto:'" & Format(dt.Rows(0)("tcosto"), "#0,0.00") & "', margen:'" & Format(dt.Rows(0)("margen"), "#0,0.00") & "'," & vbCrLf
            sql += "pmargen:'" & dt.Rows(0)("pmargen") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function generales(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.nombre, codigo, b.nombre  +' '+ b.paterno + ' ' + b.materno as operativo, a.contacto, puesto, departamento, email, telefono1, cast(fechainicio as date) fechainicio, cast(fechatermino as date) fechatermino, periodofactura, tipofactura, " & vbCrLf)
        sqlbr.Append("credito, descmateriales, descservicios, descplantillas, descplazoentrega, c.nombre  +' '+ c.paterno + ' ' + rtrim(c.materno) as ventas" & vbCrLf)
        sqlbr.Append("from tb_cliente a inner join tb_empleado b on a.id_operativo = b.id_empleado  " & vbCrLf)
        sqlbr.Append("inner join tb_empleado c on a.id_ejecutivo = c.id_empleado where a.id_cliente = '" & cliente & "';" & vbCrLf)
        sqlbr.Append("select count(id_inmueble) as inmuebles from tb_cliente_inmueble where id_cliente = " & cliente & " and id_status = 1;" & vbCrLf)
        sqlbr.Append("select sum(cantidad) as personas from tb_cliente_plantilla a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where b.id_cliente = " & cliente & " and a.id_status = 1")

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{nombre:'" & dt.Tables(0).Rows(0)("nombre") & "', codigo:'" & dt.Tables(0).Rows(0)("codigo") & "', operativo:'" & dt.Tables(0).Rows(0)("operativo") & "', contacto:'" & dt.Tables(0).Rows(0)("contacto") & "', puesto:'" & dt.Tables(0).Rows(0)("puesto") & "'," & vbCrLf
            sql += "departamento:'" & dt.Tables(0).Rows(0)("departamento") & "', email:'" & dt.Tables(0).Rows(0)("email") & "', telefono:'" & dt.Tables(0).Rows(0)("telefono1") & "'," & vbCrLf
            sql += "fechainicio:'" & dt.Tables(0).Rows(0)("fechainicio") & "', fechatermino:'" & dt.Tables(0).Rows(0)("fechatermino") & "', periodofactura:'" & dt.Tables(0).Rows(0)("periodofactura") & "'," & vbCrLf
            sql += "tipofactura:'" & dt.Tables(0).Rows(0)("tipofactura") & "', credito:'" & dt.Tables(0).Rows(0)("credito") & "', descmateriales:'" & dt.Tables(0).Rows(0)("descmateriales") & "'," & vbCrLf
            sql += "descservicios:'" & dt.Tables(0).Rows(0)("descservicios") & "', descplantillas:'" & dt.Tables(0).Rows(0)("descplantillas") & "', descplazoentrega:'" & dt.Tables(0).Rows(0)("descplazoentrega") & "'," & vbCrLf
            sql += "totinm: " & dt.Tables(1).Rows(0)("inmuebles") & ", totpers: " & dt.Tables(2).Rows(0)("personas") & ", ventas: '" & dt.Tables(0).Rows(0)("ventas") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function generalesrfc(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select rfc as 'td','', razonsocial as 'td',''," & vbCrLf)
        sqlbr.Append("calle + ' ' + numExt + ' ' + numInt + ' '+ colonia + ' ' + deleg + ' ' + cp + ' ' + ciudad + ' ' + b.descripcion as 'td' " & vbCrLf)
        sqlbr.Append("from tb_cliente_razonsocial a inner join tb_estado b on a.id_estado = b.id_estado where a.id_cliente = " & cliente & " and id_status = 1 for xml path('tr'), root('tbody')")

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
    Public Shared Function lineas(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select b.descripcion as 'td','', case when AplicaIguala = 1 then 'Si' else 'No' end as 'td' " & vbCrLf)
        sqlbr.Append("from tb_cliente_lineanegocio a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("where id_cliente = " & cliente & " for xml path('tr'), root('tbody')")

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
    Public Shared Function contarpuntos(ByVal cliente As Integer, ByVal dato As String, ByVal campo As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/25 + 1 as Filas, COUNT(*) % 25 as Residuos FROM tb_cliente_inmueble a where Id_Status  = 1 And id_cliente = " & cliente & "" & vbCrLf)
        If campo <> "" Then sqlbr.Append("and " & campo & " like '%" & dato & "%'")

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
    Public Shared Function puntos(ByVal cliente As Integer, ByVal pagina As Integer, ByVal dato As String, ByVal campo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_inmueble as 'td','', oficina as 'td','',nombre as 'td','', nosuc as 'td','', plantilla as 'td','', direccion as 'td',''," & vbCrLf)
        sqlbr.Append("ptto1 as 'td','', ptto2 as 'td','',ptto3 as 'td','', ptto4 as 'td' " & vbCrLf)
        sqlbr.Append("from (select ROW_NUMBER()Over(Order by a.nombre) As RowNum, id_inmueble, isnull(c.nombre,'') as oficina, a.nombre, a.nosuc, " & vbCrLf)
        sqlbr.Append("(select isnull(SUM(cantidad),0)  from tb_cliente_plantilla where id_status = 1 and id_inmueble = a.id_inmueble) as plantilla," & vbCrLf)
        sqlbr.Append("a.direccion + ' ' + a.colonia + ' ' + a.cp + ' ' + a.delegacionmunicipio + ' ' + a.ciudad + ' ' + d.descripcion as direccion," & vbCrLf)
        sqlbr.Append("cast(a.presupuestol as numeric (12,2)) as ptto1, cast(a.presupuestom as numeric (12,2)) as ptto2," & vbCrLf)
        sqlbr.Append("cast(a.presupuestoh as numeric (12,2)) As ptto3, cast(a.presupuestob As numeric (12,2)) As ptto4" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a" & vbCrLf)
        sqlbr.Append("left outer join tb_oficina c on a.id_oficina = c.id_oficina" & vbCrLf)
        sqlbr.Append("inner join tb_estado d on a.id_estado = d.id_estado " & vbCrLf)
        sqlbr.Append("where a.id_status = 1 and a.id_cliente = " & cliente & " " & vbCrLf)
        If campo <> "" Then sqlbr.Append("and " & campo & " like '%" & dato & "%'" & vbCrLf)
        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 25 + 1 And " & pagina & " * 25 order by nombre for xml path('tr'), root('tbody')")

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
    Public Shared Function puntosdetalle(ByVal inmueble As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.nombre, nosuc, CentroCosto, isnull(b.nombre,'') as oficina, c.descripcion, a.direccion, a.entrecalles," & vbCrLf)
        sqlbr.Append("a.colonia, a.delegacionmunicipio,a.cp,a.ciudad ,d.descripcion, a.tel1 , a.tel2, a.nombrecontacto," & vbCrLf)
        sqlbr.Append("a.emailcontacto,a.cargocontacto,a.presupuestol, a.presupuestoh, a.presupuestom,a.presupuestob" & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble a left outer join tb_oficina b on a.id_oficina = b.id_oficina  " & vbCrLf)
        sqlbr.Append("inner join tb_tipoinmueble c on a.id_tipoinmueble = c.id_tipoinmueble " & vbCrLf)
        sqlbr.Append("inner join tb_estado d on a.id_estado = d.id_estado" & vbCrLf)
        sqlbr.Append("where id_inmueble = " & inmueble & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = "{nombre:'" & dt.Rows(0)("nombre") & "', nosuc:'" & dt.Rows(0)("nosuc") & "', CentroCosto:'" & dt.Rows(0)("CentroCosto") & "'," & vbCrLf
            sql += "oficina:'" & dt.Rows(0)("oficina") & "',tipo:'" & dt.Rows(0)("descripcion") & "',direccion:'" & dt.Rows(0)("direccion") & "'," & vbCrLf
            sql += "entrecalles:'" & dt.Rows(0)("entrecalles") & "',colonia:'" & dt.Rows(0)("colonia") & "',delmun:'" & dt.Rows(0)("delegacionmunicipio") & "'," & vbCrLf
            sql += "cp:'" & dt.Rows(0)("cp") & "',ciudad:'" & dt.Rows(0)("ciudad") & "',estado:'" & dt.Rows(0)("descripcion") & "'," & vbCrLf
            sql += "tel1:'" & dt.Rows(0)("tel1") & "',tel2:'" & dt.Rows(0)("tel2") & "',contacto:'" & dt.Rows(0)("nombrecontacto") & "'," & vbCrLf
            sql += "correo:'" & dt.Rows(0)("emailcontacto") & "',cargo:'" & dt.Rows(0)("cargocontacto") & "',ptto1:'" & dt.Rows(0)("presupuestol") & "'," & vbCrLf
            sql += "ptto2:'" & dt.Rows(0)("presupuestoh") & "',ptto3:'" & dt.Rows(0)("presupuestom") & "',ptto4:'" & dt.Rows(0)("presupuestob") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contariguala(ByVal cliente As Integer, ByVal linea As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/25 + 1 as Filas, COUNT(*) % 25 as Residuos FROM tb_cliente_inmueble_ig where id_cliente = " & cliente & " and id_lineanegocio = " & linea & "" & vbCrLf)

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
    Public Shared Function igualas(ByVal cliente As Integer, ByVal linea As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select oficina as 'td','', inmueble as 'td','', linea as 'td','', importe as 'td','', faplica as 'td'  from(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by b.nombre) As RowNum, isnull(d.nombre,0) as oficina, b.nombre  as inmueble, c.descripcion as linea, " & vbCrLf)
        sqlbr.Append("cast(importe as numeric(12,2)) as importe, convert(varchar(10), faplica, 103) as faplica " & vbCrLf)
        sqlbr.Append("from tb_cliente_inmueble_ig a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_lineanegocio c on a.id_lineanegocio = c.id_lineanegocio" & vbCrLf)
        sqlbr.Append("left outer join tb_oficina d on b.id_oficina = d.id_oficina" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & " and a.id_lineanegocio = " & linea & ") as result" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 25 + 1 And " & pagina & " * 25 order by inmueble  for xml path('tr'), root('tbody')")

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
    Public Shared Function contarplantilla(ByVal cliente As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/25 + 1 as Filas, COUNT(*) % 25 as Residuos FROM tb_cliente_plantilla a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble where b.id_cliente = " & cliente & "" & vbCrLf)

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
    Public Shared Function plantilla(ByVal cliente As Integer, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select id_plantilla  as 'td','', inmueble as 'td','', puesto as 'td','', cantidad as 'td','', turno as 'td','', " & vbCrLf)
        sqlbr.Append("jornal as 'td','', salario as 'td','', carga as 'td','', uniforme as 'td','', faplica  as 'td' from" & vbCrLf)
        sqlbr.Append("(select ROW_NUMBER()Over(Order by b.nombre, c.descripcion) As RowNum, a.id_plantilla, b.nombre as inmueble, c.descripcion as puesto, a.cantidad, d.descripcion as turno, " & vbCrLf)
        sqlbr.Append("cast(a.jornal as numeric(12,2)) As jornal, cast(a.smntope As numeric(12,2)) As salario, cast(a.cargasocial As numeric(12,2)) As carga, cast(a.uniforme As numeric (12,2)) As uniforme, " & vbCrLf)
        sqlbr.Append("isnull(convert(varchar(10),a.fechaaplica, 103),'') as faplica" & vbCrLf)
        sqlbr.Append("from tb_cliente_plantilla a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join tb_puesto c on a.id_puesto = c.id_puesto" & vbCrLf)
        sqlbr.Append("inner join tb_turno d on a.id_turno = d.id_turno where a.id_status = 1 and b.id_cliente = " & cliente & ") as result " & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 25 + 1 And " & pagina & " * 25 order by inmueble, puesto For xml path('tr'), root('tbody')")

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
    Public Shared Function materiales(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select d.descripcion as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("cast(a.importe as numeric(12,2)) As 'td','', convert(varchar(10),a.fechaaplica, 103) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_material a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("inner join tb_periodo c on a.id_periodo = c.id_periodo inner join tb_conceptoptto d on a.id_concepto = d.id_concepto " & vbCrLf)
        sqlbr.Append("where id_status = 1 and id_cliente = " & cliente & " for xml path('tr'), root('tbody')")

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
    Public Shared Function herramientas(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select concepto as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("cast(a.importe as numeric(12,2)) As 'td','', convert(varchar(10),a.fechaaplica, 103) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_herramienta a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("inner join tb_periodo c on a.id_periodo = c.id_periodo where id_status = 1 and id_cliente = " & cliente & " for xml path('tr'), root('tbody')")

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
    Public Shared Function otroequipo(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select b.descripcion as 'td','', c.descripcion as 'td','', d.descripcion as 'td','', a.cantidad as 'td','', a.importe as 'td','', a.fechaaplica as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_otroequipo a inner join tb_otroequipo b on a.id_tipoEquipo = b.id_tipoequipo" & vbCrLf)
        sqlbr.Append("inner join tb_lineanegocio c on a.id_lineanegocio = c.id_lineanegocio " & vbCrLf)
        sqlbr.Append("inner join tb_periodo d on a.id_periodo = d.id_periodo where id_status = 1 and id_cliente = 30 for xml path('tr'), root('tbody')")

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
    Public Shared Function viaticos(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select concepto as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("cast(a.importe as numeric(12,2)) As 'td','', convert(varchar(10),a.fechaaplica, 103) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_viatico a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("inner join tb_periodo c on a.id_periodo = c.id_periodo where id_status = 1 and id_cliente = " & cliente & " for xml path('tr'), root('tbody')")

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
    Public Shared Function subcontratos(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select concepto as 'td','', b.descripcion as 'td','', c.descripcion as 'td','', " & vbCrLf)
        sqlbr.Append("cast(a.importe as numeric(12,2)) As 'td','', convert(varchar(10),a.fechaaplica, 103) as 'td'" & vbCrLf)
        sqlbr.Append("from tb_cliente_subcontrato a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("inner join tb_periodo c on a.id_periodo = c.id_periodo where id_status = 1 and id_cliente = " & cliente & " for xml path('tr'), root('tbody')")

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
    Public Shared Function lineacliente(ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select a.id_lineanegocio, b.descripcion " & vbCrLf)
        sqlbr.Append("from tb_cliente_lineanegocio a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio" & vbCrLf)
        sqlbr.Append("where a.id_cliente = " & cliente & "")
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


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        Dim usuario As HttpCookie
        Dim userid As Integer
        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = userid
        End If
        Dim menui As New cargamenu()

        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
