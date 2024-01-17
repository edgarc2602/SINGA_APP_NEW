Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Cat_Empleado
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

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
    Public Shared Function puesto() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_puesto, descripcion from tb_puesto where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_puesto") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function turno() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_turno, descripcion from tb_turno where id_status = 1 order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_turno") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function area() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select IdArea, Ar_Nombre from tbl_area_empresa where Ar_Estatus =0 and empleados =1 order by Ar_Nombre ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdArea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("Ar_Nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarempleado(ByVal campo As String, ByVal valor As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/30 + 1 as Filas, COUNT(*) % 30 as Residuos FROM tb_empleado a where id_status in (1,2)" & vbCrLf)
        If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
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
    Public Shared Function empleado(ByVal pagina As Integer, ByVal campo As String, ByVal valor As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select id_empleado as 'td','', tipo as 'td','', estatus as 'td','', empleado as 'td','', pagadora as 'td','', rfc as 'td','', " & vbCrLf)
        sqlbr.Append("curp as 'td','',cliente as 'td','', inmueble as 'td' from(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by paterno, materno, a.nombre) As RowNum,  id_empleado, case when a.tipo = 1 then 'Administrativo' else 'Operatiivo' end as tipo," & vbCrLf)
        sqlbr.Append("case when a.id_status = 1 then 'Candidato' when a.id_status = 2 then 'Activo' end as estatus,")
        sqlbr.Append("ltrim(paterno + ' ' + materno + ' '+ a.nombre) as empleado , isnull(b.nombre,'') as pagadora, isnull(a.rfc,'') as rfc, isnull(curp,'') as curp, isnull(c.nombre,'')as cliente, isnull(d.nombre, '')  as inmueble" & vbCrLf)
        sqlbr.Append("From tb_empleado a left outer join tb_empresa b on a.id_empresa = b.id_empresa " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on a.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("Left outer join tb_cliente_inmueble d on a.id_inmueble = d.id_inmueble where a.id_status in (1,2)" & vbCrLf)
        If campo <> "0" Then sqlbr.Append(" and " & campo & " like '%" & valor & "%'")
        sqlbr.Append(") as result" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 30 + 1 And " & pagina & " * 30 order by RowNum For xml path('tr'), root('tbody') " & vbCrLf)
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
    Public Shared Function detalle(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select tipo, id_empresa, id_cliente, a.id_inmueble, a.id_puesto,a.id_turno, a.jornal, paterno, materno, nombre,"& vbCrLf)
        sqlbr.Append("ss, convert(varchar(10), fnacimiento,103) as fnac, lugar, nacionalidad, genero, civil, talla, correo, fuente, " & vbCrLf)
        sqlbr.Append("cast(datediff(dd,fnacimiento,GETDATE()) / 365.25 as int) as edad, tallac, id_area, case when pensionado = 0 then 0 else 1 end as pensionado," & vbCrLf)
        sqlbr.Append("calle, noext, noint, colonia, cp, municipio, id_estado, tel1, tel2, contacto, sueldo, sueldoimss, sdi, fingreso, a.formapago, id_banco, clabe, cuenta, tarjeta," & vbCrLf)
        sqlbr.Append("case when tienecredito = 0 then 0 else 1 end as tienecredito, fcredito, tipocredito, montocredito, case when confirmaimss = 0 then 0 else 1 end confirma," & vbCrLf)
        sqlbr.Append("a.id_plantilla,b.smntope from tb_empleado a left outer join tb_cliente_plantilla b on a.id_plantilla = b.id_plantilla" & vbCrLf)
        sqlbr.Append("where id_empleado =  " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{tipo: '" & dt.Rows(0)("tipo") & "',empresa:'" & dt.Rows(0)("id_empresa") & "',cliente:'" & dt.Rows(0)("id_cliente") & "'," & vbCrLf
            sql += "inmueble:'" & dt.Rows(0)("id_inmueble") & "', puesto:'" & dt.Rows(0)("id_puesto") & "', turno:'" & dt.Rows(0)("id_turno") & "'," & vbCrLf
            sql += "jornal:'" & dt.Rows(0)("jornal") & "', paterno:'" & dt.Rows(0)("paterno") & "', materno:'" & dt.Rows(0)("materno") & "'," & vbCrLf
            sql += "nombre:'" & dt.Rows(0)("nombre") & "', ss:'" & dt.Rows(0)("ss") & "', fnac:'" & dt.Rows(0)("fnac") & "'," & vbCrLf
            sql += "lugar:'" & dt.Rows(0)("lugar") & "', nacion:'" & dt.Rows(0)("nacionalidad") & "', genero:'" & dt.Rows(0)("genero") & "'," & vbCrLf
            sql += "civil:'" & dt.Rows(0)("civil") & "', talla:'" & dt.Rows(0)("talla") & "', correo:'" & dt.Rows(0)("correo") & "'," & vbCrLf
            sql += "fuente:'" & dt.Rows(0)("fuente") & "', edad:'" & dt.Rows(0)("edad") & "', tallac:'" & dt.Rows(0)("tallac") & "'," & vbCrLf
            sql += "area:'" & dt.Rows(0)("id_area") & "', pensionado:'" & dt.Rows(0)("pensionado") & "', calle:'" & dt.Rows(0)("calle") & "',"
            sql += "noext:'" & dt.Rows(0)("noext") & "', noint:'" & dt.Rows(0)("noint") & "', colonia:'" & dt.Rows(0)("colonia") & "',"
            sql += "cp:'" & dt.Rows(0)("cp") & "', municipio:'" & dt.Rows(0)("municipio") & "', estado:'" & dt.Rows(0)("id_estado") & "',"
            sql += "tel1:'" & dt.Rows(0)("tel1") & "', tel2:'" & dt.Rows(0)("tel2") & "', contacto:'" & dt.Rows(0)("contacto") & "',"
            sql += "sueldo:'" & dt.Rows(0)("sueldo") & "', sueldoimss:'" & dt.Rows(0)("sueldoimss") & "', sdi:'" & dt.Rows(0)("sdi") & "',"
            sql += "fingreso:'" & dt.Rows(0)("fingreso") & "', formapago:'" & dt.Rows(0)("formapago") & "', banco:'" & dt.Rows(0)("id_banco") & "', clabe:'" & dt.Rows(0)("clabe") & "',"
            sql += "cuenta:'" & dt.Rows(0)("cuenta") & "', tarjeta:'" & dt.Rows(0)("tarjeta") & "', tienecredito:'" & dt.Rows(0)("tienecredito") & "',"
            sql += "fcredito:'" & dt.Rows(0)("fcredito") & "', tipocredito:'" & dt.Rows(0)("tipocredito") & "', montocredito:'" & dt.Rows(0)("montocredito") & "', confirma:'" & dt.Rows(0)("confirma") & "', sueldoplantilla:'" & dt.Rows(0)("smntope") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reingreso(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select tipo, paterno, materno, nombre,rfc, curp," & vbCrLf)
        sqlbr.Append("ss, convert(varchar(10), fnacimiento,103) as fnac, lugar, nacionalidad, genero, civil, talla, correo, fuente, " & vbCrLf)
        sqlbr.Append("cast(datediff(dd,fnacimiento,GETDATE()) / 365.25 as int) as edad, tallac, case when pensionado = 0 then 0 else 1 end as pensionado," & vbCrLf)
        sqlbr.Append("calle, noext, noint, colonia, cp, municipio, id_estado, tel1, tel2, contacto, id_banco, clabe, cuenta, tarjeta" & vbCrLf)
        sqlbr.Append("from tb_empleado where id_empleado = " & empleado & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{tipo: '" & dt.Rows(0)("tipo") & "',paterno:'" & dt.Rows(0)("paterno") & "', materno:'" & dt.Rows(0)("materno") & "'," & vbCrLf
            sql += "rfc:'" & dt.Rows(0)("rfc") & "', curp:'" & dt.Rows(0)("curp") & "'," & vbCrLf
            sql += "nombre:'" & dt.Rows(0)("nombre") & "', ss:'" & dt.Rows(0)("ss") & "', fnac:'" & dt.Rows(0)("fnac") & "'," & vbCrLf
            sql += "lugar:'" & dt.Rows(0)("lugar") & "', nacion:'" & dt.Rows(0)("nacionalidad") & "', genero:'" & dt.Rows(0)("genero") & "'," & vbCrLf
            sql += "civil:'" & dt.Rows(0)("civil") & "', talla:'" & dt.Rows(0)("talla") & "', correo:'" & dt.Rows(0)("correo") & "'," & vbCrLf
            sql += "fuente:'" & dt.Rows(0)("fuente") & "', edad:'" & dt.Rows(0)("edad") & "', tallac:'" & dt.Rows(0)("tallac") & "'," & vbCrLf
            sql += "pensionado:'" & dt.Rows(0)("pensionado") & "', calle:'" & dt.Rows(0)("calle") & "',"
            sql += "noext:'" & dt.Rows(0)("noext") & "', noint:'" & dt.Rows(0)("noint") & "', colonia:'" & dt.Rows(0)("colonia") & "',"
            sql += "cp:'" & dt.Rows(0)("cp") & "', municipio:'" & dt.Rows(0)("municipio") & "', estado:'" & dt.Rows(0)("id_estado") & "',"
            sql += "tel1:'" & dt.Rows(0)("tel1") & "', tel2:'" & dt.Rows(0)("tel2") & "', contacto:'" & dt.Rows(0)("contacto") & "',"
            sql += "banco:'" & dt.Rows(0)("id_banco") & "', clabe:'" & dt.Rows(0)("clabe") & "', cuenta:'" & dt.Rows(0)("cuenta") & "', tarjeta:'" & dt.Rows(0)("tarjeta") & "'}"

        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargavacante(ByVal vacante As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select a.id_cliente, a.id_inmueble, a.id_puesto, a.id_turno, a.id_plantilla, b.smntope, b.jornal , b.formapago, isnull(c.id_empresa,0) as id_empresa  " & vbCrLf)
        sqlbr.Append("from tb_vacante a inner join tb_cliente_plantilla b on a.id_plantilla = b.id_plantilla" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on a.id_cliente = c.id_cliente ")
        sqlbr.Append("where id_vacante = " & vacante & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{cliente: '" & dt.Rows(0)("id_cliente") & "',inmueble:'" & dt.Rows(0)("id_inmueble") & "',puesto:'" & dt.Rows(0)("id_puesto") & "', turno:'" & dt.Rows(0)("id_turno") & "'," & vbCrLf
            sql += "plantilla:'" & dt.Rows(0)("id_plantilla") & "', salario:'" & dt.Rows(0)("smntope") & "',jornal:'" & dt.Rows(0)("jornal") & "',"
            sql += "formapago:'" & dt.Rows(0)("formapago") & "', empresa:'" & dt.Rows(0)("id_empresa") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal empleado As String) As String

        Dim sql As String = "Update tb_empleado set id_status = 3 where id_empleado =" & empleado & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal fecha As String, ByVal cliente As String, ByVal puesto As String, ByVal sucursal As String, ByVal persona As String, ByVal vacante As String, ByVal idvacante As Integer, ByVal usuario As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_empleado", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prmR As New SqlParameter("@Id", "0")
        prmR.Size = 10
        prmR.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prmR)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        If idvacante <> 0 Then
            Dim generacorreo As New enviocorreo()
            generacorreo.correocandidato(fecha, "Registro de Candidato", cliente, puesto, sucursal, persona, vacante, idvacante, usuario)
        End If
        Return prmR.Value

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function actualizavacante(ByVal vacante As String) As String

        Dim sql As String = "Update tb_vacante set id_status = 2 where id_vacante =" & vacante & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function banco() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_banco, descripcion from tb_banco order by descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_banco") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function estado() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_estado, descripcion from tb_estado order by descripcion ")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_estado") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscacurp(ByVal curp As String, ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado from tb_empleado where curp ='" & curp & "' and id_status =2")
        If emp <> 0 Then sqlbr.Append(" and id_empleado != " & emp & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_empleado") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscarfc(ByVal rfc As String, ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado from tb_empleado where rfc ='" & rfc & "' and id_status =2")
        If emp <> 0 Then sqlbr.Append(" and id_empleado != " & emp & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_empleado") & "'}" & vbCrLf
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscarss(ByVal ss As String, ByVal emp As Integer, ByVal pens As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        If pens = 1 Then
            sql += ""
        Else
            sqlbr.Append("select id_empleado from tb_empleado where ss ='" & ss & "' and id_status =2")
            If emp <> 0 Then sqlbr.Append(" and id_empleado != " & emp & "")
            Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
            Dim dt As New DataTable
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql += "{id:'" & dt.Rows(0)("id_empleado") & "'}"
            End If
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscarclabe(ByVal clabe As String, ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        If clabe = "" Then
            sql = ""
        Else
            sqlbr.Append("select id_empleado from tb_empleado where clabe ='" & clabe & "' and id_status =2")
            If emp <> 0 Then sqlbr.Append(" and id_empleado != " & emp & "")
            Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
            Dim dt As New DataTable
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{id:'" & dt.Rows(0)("id_empleado") & "'}"
            End If
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function buscarcuenta(ByVal cuenta As String, ByVal emp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        If cuenta = "" Then
            sql = ""
        Else
            sqlbr.Append("select id_empleado from tb_empleado where cuenta ='" & cuenta & "' and id_status =2")
            If emp <> 0 Then sqlbr.Append(" and id_empleado != " & emp & "")
            Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
            Dim dt As New DataTable
            da.Fill(dt)
            If dt.Rows.Count > 0 Then
                sql = "{id:'" & dt.Rows(0)("id_empleado") & "'}"
            End If
        End If
        Return sql
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        If Request("idvacante") <> "" Then
            idvacante.Value = Request("idvacante")
        End If
        If Request("idempleado") <> "" Then
            idreingreso.Value = Request("idempleado")
        End If
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
