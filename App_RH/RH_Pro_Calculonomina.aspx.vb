Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_RH_RH_Pro_Calculonomina
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function periodo() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_periodo, RIGHT('00' + Ltrim(Rtrim(id_periodo)),2) + '-' + cast(anio as varchar(4)) + '-' + descripcion as periodo" & vbCrLf)
        sqlbr.Append("from tb_periodonomina where activo = 1")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_periodo") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("periodo") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function detalleperiodo(ByVal periodo As Integer, ByVal per As String, ByVal anio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select convert(varchar(10),finicio,103) as fini, convert(varchar(10),ffin,103) as ffin from tb_periodonomina where id_periodo = " & periodo & " and descripcion = '" & per & "' and anio = " & anio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{fini: '" & dt.Rows(0)("fini") & "',ffin:'" & dt.Rows(0)("ffin") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function procesada(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoemp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select '$' + convert(varchar(12), convert(money , isnull(sum(percepcion),0)),1) as perc, " & vbCrLf)
        sqlbr.Append("'$' + convert(varchar(12), convert(money , isnull(sum(deduccion),0)),1) as deduc," & vbCrLf)
        sqlbr.Append("'$' + convert(varchar(12), convert(money , isnull(sum(percepcion + deduccion),0)),1) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("where id_periodo = " & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and tipoempleado = " & tipoemp & "" & vbCrLf)
        'If empresa() <> 0 Then sqlbr.Append("and b.id_empresa = " & empresa() & "")
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{percepcion: '" & dt.Rows(0)("perc") & "',deduccion:'" & dt.Rows(0)("deduc") & "', total:'" & dt.Rows(0)("total") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function empresa() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empresa, nombre from tb_empresa where id_estatus = 1 order by nombre")
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
    Public Shared Function procesa(ByVal registro As String, ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal area As Integer, ByVal fecini As String, ByVal fecfin As String, ByVal forma As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()
        Dim aa As String = ""

        Dim vfecini As Date, vfecfin As Date
        If fecini <> "" Then vfecini = fecini
        If fecfin <> "" Then vfecfin = fecfin

        Dim vdias As Long = DateDiff(DateInterval.Day, vfecini, vfecfin)

        myConnection.Open()

        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_calculonomina", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.ExecuteNonQuery()

            sqlbr.Append("DECLARE @cols NVARCHAR (MAX),  @query NVARCHAR(MAX);" & vbCrLf)
            sqlbr.Append("SELECT @cols = COALESCE (@cols + ',[' + movimiento + ']', " & vbCrLf)
            sqlbr.Append("'[' + movimiento + ']')" & vbCrLf)
            sqlbr.Append("FROM (SELECT DISTINCT movimiento FROM tb_empleado_asistencia) PV  " & vbCrLf)
            sqlbr.Append("ORDER BY movimiento   " & vbCrLf)
            sqlbr.Append("SET @query = '" & vbCrLf)
            sqlbr.Append("            delete from tb_nominacalculadar1 where id_periodo=" & periodo & " and tipo=''" & tipo & "'' and anio =" & anio & " and id_area =" & area & "" & vbCrLf)
            sqlbr.Append("			  insert into tb_nominacalculadar1" & vbCrLf)
            sqlbr.Append("		      select id_periodo, tipo, anio, " & area & ", tabla.id_empleado, infonavit, primav, percepcion, deduccion, neto, isnull(a,0),isnull(d,0)," & vbCrLf)
            sqlbr.Append("			isnull(f,0),isnull(fj,0),isnull(ieg,0),isnull(irt,0),isnull(n,0),isnull(v,0) " & vbCrLf)
            sqlbr.Append("			from (" & vbCrLf)
            sqlbr.Append("			select id_periodo, tipo, anio, id_empleado, isnull(sum(infonavit),0) infonavit, isnull(sum(primav),0) primav, sum(percepcion) percepcion, sum(deduccion) deduccion, sum(neto) neto from(" & vbCrLf)
            sqlbr.Append("			select id_periodo, tipo, anio, id_empleado, case when id_incidencia = 8 then sum(deduccion) end as infonavit, case when id_incidencia = 15 then sum(percepcion) end as primav, " & vbCrLf)
            sqlbr.Append("			sum(percepcion) as percepcion, sum(deduccion) as deduccion , sum(percepcion + deduccion) as neto" & vbCrLf)
            sqlbr.Append("			from tb_nominacalculada where id_periodo = " & periodo & " and tipo =''" & tipo & "'' and anio =" & anio & " and tipoempleado = " & area & "" & vbCrLf)
            sqlbr.Append("			group by id_empleado, id_incidencia, id_periodo,tipo, anio ) result group by id_empleado, id_periodo, tipo, anio) tabla  left outer join" & vbCrLf)
            sqlbr.Append("             (" & vbCrLf)
            sqlbr.Append("                 SELECT a.id_empleado, movimiento" & vbCrLf)
            sqlbr.Append("				 FROM tb_empleado_asistencia a inner join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
            sqlbr.Append("				 " & vbCrLf)
            sqlbr.Append("				 where  id_periodo= ' + '" & periodo & "' +' and b.id_area= '+ '" & area & "'+' and a.anio= '+ '" & anio & "' +' and a.tipo= '+ '''" & tipo & "''' +' " & vbCrLf)
            sqlbr.Append("             ) x" & vbCrLf)
            sqlbr.Append("             PIVOT " & vbCrLf)
            sqlbr.Append("(" & vbCrLf)
            sqlbr.Append("                 count(movimiento)" & vbCrLf)
            sqlbr.Append("                 FOR movimiento IN (' + @cols + ')" & vbCrLf)
            sqlbr.Append("           ) p  on tabla.id_empleado = p.id_empleado " & vbCrLf)
            sqlbr.Append("			order by tabla.id_empleado'" & vbCrLf)
            sqlbr.Append("EXEC SP_EXECUTESQL @query ")

            mycommand = New SqlCommand(sqlbr.ToString, myConnection, trans)
            mycommand.ExecuteNonQuery()

            sqlbr.Clear()

            Select Case vdias
                Case 6
                    sqlbr.Append("DECLARE @cols1 NVARCHAR (MAX),  @query1 NVARCHAR(MAX);" & vbCrLf)
                    sqlbr.Append("SELECT @cols1 = COALESCE (@cols1 + ',[' + CONVERT(NVARCHAR, fecha, 103) + ']', " & vbCrLf)
                    sqlbr.Append("'[' + CONVERT(NVARCHAR, fecha, 103) + ']')" & vbCrLf)
                    sqlbr.Append("FROM (SELECT DISTINCT fecha FROM tb_empleado_asistencia) PV  " & vbCrLf)
                    sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
                    sqlbr.Append("ORDER BY fecha" & vbCrLf)
                    sqlbr.Append("SET @query1 = '" & vbCrLf)
                    sqlbr.Append("            delete from tb_nominacalculadar2 where id_periodo=" & periodo & " and tipo=''" & tipo & "'' and anio =" & anio & "" & vbCrLf)
                    sqlbr.Append("			  insert into tb_nominacalculadar2(id_periodo, tipo, anio, id_empleado, uno, dos, tres, cuatro, cinco, seis, siete)" & vbCrLf)
                    sqlbr.Append("              SELECT " & periodo & " as id_periodo, ''" & tipo & "'' as tipo, " & anio & " as anio, * FROM " & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 SELECT a.id_empleado, movimiento, CONVERT(NVARCHAR, fecha, 103) as fecha" & vbCrLf)
                    sqlbr.Append("				 FROM tb_empleado a left outer join tb_empleado_asistencia b on a.id_empleado = b.id_empleado" & vbCrLf)
                    sqlbr.Append("				 where  convert(varchar(8), fecha,112) between ' + '" & Format(vfecini, "yyyyMMdd") & "' +' and ' + '" & Format(vfecfin, "yyyyMMdd") & "' + ' and a.id_area = '+ '" & area & "'+' and a.formapago = '+ '" & forma & "'+'" & vbCrLf)
                    sqlbr.Append("             ) x" & vbCrLf)
                    sqlbr.Append("             PIVOT" & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 max(movimiento)" & vbCrLf)
                    sqlbr.Append("                 FOR fecha IN (' + @cols1 + ')" & vbCrLf)
                    sqlbr.Append("            ) p order by id_empleado'" & vbCrLf)
                    sqlbr.Append("EXEC SP_EXECUTESQL @query1")
                Case 14
                    sqlbr.Append("DECLARE @cols1 NVARCHAR (MAX),  @query1 NVARCHAR(MAX);" & vbCrLf)
                    sqlbr.Append("SELECT @cols1 = COALESCE (@cols1 + ',[' + CONVERT(NVARCHAR, fecha, 103) + ']', " & vbCrLf)
                    sqlbr.Append("'[' + CONVERT(NVARCHAR, fecha, 103) + ']')" & vbCrLf)
                    sqlbr.Append("FROM (SELECT DISTINCT fecha FROM tb_empleado_asistencia) PV  " & vbCrLf)
                    sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
                    sqlbr.Append("ORDER BY fecha" & vbCrLf)
                    sqlbr.Append("SET @query1 = '" & vbCrLf)
                    sqlbr.Append("            delete from tb_nominacalculadar2 where id_periodo=" & periodo & " and tipo=''" & tipo & "'' and anio =" & anio & "" & vbCrLf)
                    sqlbr.Append("			  insert into tb_nominacalculadar2 (id_periodo, tipo, anio, id_empleado, uno, dos, tres, cuatro, cinco, seis, siete,ocho," & vbCrLf)
                    sqlbr.Append("            nueve, diez, once, doce, trece, catorce, quince)" & vbCrLf)
                    sqlbr.Append("              SELECT " & periodo & " as id_periodo, ''" & tipo & "'' as tipo, " & anio & " as anio, * FROM " & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 SELECT a.id_empleado, movimiento, CONVERT(NVARCHAR, fecha, 103) as fecha" & vbCrLf)
                    sqlbr.Append("				 FROM tb_empleado a left outer join tb_empleado_asistencia b on a.id_empleado = b.id_empleado" & vbCrLf)
                    sqlbr.Append("				 where  convert(varchar(8), fecha,112) between ' + '" & Format(vfecini, "yyyyMMdd") & "' +' and ' + '" & Format(vfecfin, "yyyyMMdd") & "' + ' and a.id_area = '+ '" & area & "'+' and a.formapago = '+ '" & forma & "'+'" & vbCrLf)
                    sqlbr.Append("             ) x" & vbCrLf)
                    sqlbr.Append("             PIVOT" & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 max(movimiento)" & vbCrLf)
                    sqlbr.Append("                 FOR fecha IN (' + @cols1 + ')" & vbCrLf)
                    sqlbr.Append("            ) p order by id_empleado'" & vbCrLf)
                    sqlbr.Append("EXEC SP_EXECUTESQL @query1 ")
                Case 15
                    sqlbr.Append("DECLARE @cols1 NVARCHAR (MAX),  @query1 NVARCHAR(MAX);" & vbCrLf)
                    sqlbr.Append("SELECT @cols1 = COALESCE (@cols1 + ',[' + CONVERT(NVARCHAR, fecha, 103) + ']', " & vbCrLf)
                    sqlbr.Append("'[' + CONVERT(NVARCHAR, fecha, 103) + ']')" & vbCrLf)
                    sqlbr.Append("FROM (SELECT DISTINCT fecha FROM tb_empleado_asistencia) PV  " & vbCrLf)
                    sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
                    sqlbr.Append("ORDER BY fecha" & vbCrLf)
                    sqlbr.Append("SET @query1 = '" & vbCrLf)
                    sqlbr.Append("            delete from tb_nominacalculadar2 where id_periodo=" & periodo & " and tipo=''" & tipo & "'' and anio =" & anio & "" & vbCrLf)
                    sqlbr.Append("			  insert into tb_nominacalculadar2 (id_periodo, tipo, anio, id_empleado, uno, dos, tres, cuatro, cinco, seis, siete,ocho," & vbCrLf)
                    sqlbr.Append("            nueve, diez, once, doce, trece, catorce, quince, dieciseis)" & vbCrLf)
                    sqlbr.Append("              SELECT " & periodo & " as id_periodo, ''" & tipo & "'' as tipo, " & anio & " as anio, * FROM " & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 SELECT a.id_empleado, movimiento, CONVERT(NVARCHAR, fecha, 103) as fecha" & vbCrLf)
                    sqlbr.Append("				 FROM tb_empleado a left outer join tb_empleado_asistencia b on a.id_empleado = b.id_empleado" & vbCrLf)
                    sqlbr.Append("				 where  convert(varchar(8), fecha,112) between ' + '" & Format(vfecini, "yyyyMMdd") & "' +' and ' + '" & Format(vfecfin, "yyyyMMdd") & "' + ' and a.id_area = '+ '" & area & "'+' and a.formapago = '+ '" & forma & "'+'" & vbCrLf)
                    sqlbr.Append("             ) x" & vbCrLf)
                    sqlbr.Append("             PIVOT" & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 max(movimiento)" & vbCrLf)
                    sqlbr.Append("                 FOR fecha IN (' + @cols1 + ')" & vbCrLf)
                    sqlbr.Append("            ) p order by id_empleado'" & vbCrLf)
                    sqlbr.Append("EXEC SP_EXECUTESQL @query1 ")
                Case 12
                    sqlbr.Append("DECLARE @cols1 NVARCHAR (MAX),  @query1 NVARCHAR(MAX);" & vbCrLf)
                    sqlbr.Append("SELECT @cols1 = COALESCE (@cols1 + ',[' + CONVERT(NVARCHAR, fecha, 103) + ']', " & vbCrLf)
                    sqlbr.Append("'[' + CONVERT(NVARCHAR, fecha, 103) + ']')" & vbCrLf)
                    sqlbr.Append("FROM (SELECT DISTINCT fecha FROM tb_empleado_asistencia) PV  " & vbCrLf)
                    sqlbr.Append("where fecha between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
                    sqlbr.Append("ORDER BY fecha" & vbCrLf)
                    sqlbr.Append("SET @query1 = '" & vbCrLf)
                    sqlbr.Append("            delete from tb_nominacalculadar2 where id_periodo=" & periodo & " and tipo=''" & tipo & "'' and anio =" & anio & "" & vbCrLf)
                    sqlbr.Append("			  insert into tb_nominacalculadar2 (id_periodo, tipo, anio, id_empleado, uno, dos, tres, cuatro, cinco, seis, siete,ocho," & vbCrLf)
                    sqlbr.Append("            nueve, diez, once, doce, trece)" & vbCrLf)
                    sqlbr.Append("              SELECT " & periodo & " as id_periodo, ''" & tipo & "'' as tipo, " & anio & " as anio, * FROM " & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 SELECT a.id_empleado, movimiento, CONVERT(NVARCHAR, fecha, 103) as fecha" & vbCrLf)
                    sqlbr.Append("				 FROM tb_empleado a left outer join tb_empleado_asistencia b on a.id_empleado = b.id_empleado" & vbCrLf)
                    sqlbr.Append("				 where  convert(varchar(8), fecha,112) between ' + '" & Format(vfecini, "yyyyMMdd") & "' +' and ' + '" & Format(vfecfin, "yyyyMMdd") & "' + ' and a.id_area = '+ '" & area & "'+' and a.formapago = '+ '" & forma & "'+'" & vbCrLf)
                    sqlbr.Append("             ) x" & vbCrLf)
                    sqlbr.Append("             PIVOT" & vbCrLf)
                    sqlbr.Append("(" & vbCrLf)
                    sqlbr.Append("                 max(movimiento)" & vbCrLf)
                    sqlbr.Append("                 FOR fecha IN (' + @cols1 + ')" & vbCrLf)
                    sqlbr.Append("            ) p order by id_empleado'" & vbCrLf)
                    sqlbr.Append("EXEC SP_EXECUTESQL @query1 ")
            End Select


            mycommand = New SqlCommand(sqlbr.ToString, myConnection, trans)
            mycommand.ExecuteNonQuery()

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return aa

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function nominareporte(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal area As Integer, ByVal fecini As String, ByVal fecfin As String, ByVal forma As Integer) As String

        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        'Dim myConnection As New SqlConnection((New Conexion).StrConexion)


        ''Dim vfecini As Date, vfecfin As Date
        'If fecini <> "" Then vfecini = fecini
        'If fecfin <> "" Then vfecfin = fecfin

        '        Dim trans As SqlTransaction = con.BeginTransaction
        con.Open()
        '       Try



        '          trans.Commit()

        ' Catch ex As Exception
        ' trans.Rollback()
        ' Dim aa = ex.Message.ToString().Replace("'", "")
        'Response.Write("<script>alert('" & aa & "');</script>")
        'End Try
        con.Close()

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function elimina(ByVal periodo As Integer, ByVal anio As Integer, ByVal tipo As String, ByVal tipoemp As Integer) As String

        Dim sql As String = "delete from tb_nominacalculada where id_periodo =" & periodo & " and anio = " & anio & " and tipo='" & tipo & "' and tipoempleado = " & tipoemp & ";"
        sql += "delete from tb_nominacalculadar where id_periodo =" & periodo & " and anio = " & anio & " and tipo='" & tipo & "' and tipoempleado = " & tipoemp & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarnomina(ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoemp As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("Select COUNT(*)/30 + 1 As Filas, COUNT(*) % 30 As Residuos FROM(" & vbCrLf)
        sqlbr.Append("Select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, c.nombre As cliente, d.nombre As sucursal," & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, a.percepciones, a.deducciones, a.total from(" & vbCrLf)
        sqlbr.Append("select a.id_empleado, sum(percepcion) as percepciones, sum(deduccion) as deducciones, sum(percepcion) - sum(deduccion) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("where id_periodo =" & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and a.tipoempleado = " & tipoemp & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        sqlbr.Append("group by a.id_empleado) as a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble) as tabla")

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
    Public Shared Function nomina(ByVal pagina As Integer, ByVal periodo As Integer, ByVal tipo As String, ByVal anio As Integer, ByVal cliente As Integer, ByVal gerente As Integer, ByVal tipoemp As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("SELECT cliente as 'td','', sucursal as 'td','', id_empleado as 'td','', empleado as 'td','', cast(percepciones as numeric(18,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(deducciones as numeric(18,2)) As 'td','', cast(total as numeric(18,2)) as 'td' FROM(" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER()Over(Order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) As RowNum, rtrim(c.nombre) as cliente, d.nombre as sucursal," & vbCrLf)
        sqlbr.Append("a.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as empleado, a.percepciones, a.deducciones, a.total from(" & vbCrLf)
        sqlbr.Append("select a.id_empleado, sum(percepcion) as percepciones, sum(deduccion) as deducciones, sum(percepcion) + sum(deduccion) as total" & vbCrLf)
        sqlbr.Append("from tb_nominacalculada a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente " & vbCrLf)
        sqlbr.Append("where id_periodo =" & periodo & " and a.tipo = '" & tipo & "' and anio = " & anio & " and b.id_area = " & tipoemp & "" & vbCrLf)
        'If empresa() <> 0 Then sqlbr.Append("and b.id_empresa = " & empresa() & "")
        If cliente <> 0 Then sqlbr.Append("and b.id_cliente = " & cliente & "")
        If gerente <> 0 Then sqlbr.Append("and c.id_operativo = " & gerente & "")
        sqlbr.Append("Group by a.id_empleado) as a inner join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("inner join tb_cliente c on b.id_cliente = c.id_cliente inner join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble) as tabla" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 30 + 1 And " & pagina & " * 30 order by  cliente, sucursal,  empleado for xml path('tr'), root('tbody')" & vbCrLf)
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
    Public Shared Function empleado(ByVal area As Integer, ByVal tipo As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_empleado,nombre + ' '+ paterno + ' ' + materno as empleado from tb_empleado where id_status = 2 and " & tipo & " = 1 order by empleado")
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
        sql = "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cerrar(ByVal periodo As Integer, ByVal per As String, ByVal anio As String, ByVal tipoc As String, ByVal tipoctext As String) As String

        Dim sql As String = ""

        If per = "Semanal" Then
            'sql = "Update tb_periodonomina set activo = 0, estatus = 1 where id_periodo = " & periodo & " and descripcion ='" & per & "' and anio = " & anio & ";"
            sql += "insert into tb_periodonominac (id_periodo, tipo, anio, tipoc, id_status) values (" & periodo & ", '" & per & "', " & anio & "," & tipoc & ",1 );"
        Else
            sql = "insert into tb_periodonominac (id_periodo, tipo, anio, tipoc, id_status) values (" & periodo & ",'" & per & "', " & anio & "," & tipoc & ",1 );"
        End If
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        Dim generacorreo As New correocgo()
        generacorreo.cierrenomina(periodo, per, anio, tipoctext)

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function validaestado(ByVal periodo As Integer, ByVal per As String, ByVal anio As Integer, ByVal tipoc As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select case when id_status = 1 then 'Período Cerrado' when id_status = 2 then 'Período Liberado' when id_status = 3 then 'Período pagado' end as estatus  from tb_periodonominac where id_periodo =" & periodo & " and tipo ='" & per & "' and anio =" & anio & " and tipoc= " & tipoc & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{estatus:'" & dt.Rows(0)("estatus") & "'}" & vbCrLf
        Else
            sql += "{estatus:'Período abierto'}" & vbCrLf
        End If
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
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
