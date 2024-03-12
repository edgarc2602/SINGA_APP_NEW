Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Partial Class App_RH_RH_Descargaempleadocompleto
    Inherits System.Web.UI.Page

    Private Sub extoex(ByVal data As DataTable, ByVal nombre As String)
        Dim context As HttpContext = HttpContext.Current()
        context.Response.Clear()
        context.Response.Write("<html><body>")
        context.Response.Write("<table>")
        context.Response.Write("<tr>")
        For Each column As DataColumn In data.Columns
            context.Response.Write("<td>" & column.ColumnName & "</td>")
        Next
        context.Response.Write("</tr>")
        context.Response.Write(Environment.NewLine)

        For Each ren As DataRow In data.Rows
            context.Response.Write("<tr>")
            For i As Integer = 0 To data.Columns.Count - 1

                'If data.Columns.Item(i).ColumnName = "clabe" Then
                ' context.Response.Write("<td>" & Format(ren(i).ToString(), "0") & "</td>")
                ' End If
                context.Response.Write("<td>" & ren(i).ToString().Replace(";", String.Empty) & "</td>")
            Next
            context.Response.Write("</tr>")
            context.Response.Write(Environment.NewLine)
        Next

        context.Response.ContentType = "application/vnd.ms-excel"
        context.Response.AppendHeader("Content-Disposition", "attachment; filename=" & nombre & ".xls")
        context.Response.Charset = "UTF-8"
        context.Response.ContentEncoding = Encoding.Default
        context.Response.Write("</table>")
        context.Response.Write("</body></html>")
        context.Response.End()
    End Sub

    Protected Sub rptempleado()
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select ROW_NUMBER()Over(Order by a.paterno, a.materno, a.nombre) As RowNum, " & vbCrLf)
        sqlbr.Append(" a.id_empleado, a.paterno + ' ' + rtrim(a.materno) + ' ' + a.nombre as empleado, isnull(a.rfc,'') as rfc, isnull(curp,'') as curp," & vbCrLf)
        sqlbr.Append("isnull(SUBSTRING(ss,1,10) + '-' + SUBSTRING(ss,11,1),'') as ss, case when pensionado = 1 then 'Si'else 'No' end as pensionado," & vbCrLf)
        sqlbr.Append("case when a.tipo =1 then 'Administrativo' when a.tipo =2 then 'Operarivo' when a.tipo = 3 then 'Jornalero' end as tipo," & vbCrLf)
        sqlbr.Append("case when a.id_status = 1 then 'Candidato' when a.id_status =2 then 'Activo' when a.id_status = 3 then 'Baja' when a.id_status = 4 then 'No se presento' end as estatus," & vbCrLf)
        sqlbr.Append("isnull(c.nombre,'') as empresa, isnull(rtrim(b.nombre),'') as cliente, isnull(rtrim(e.nombre),'') as inmueble, isnull(rtrim(k.descripcion),'') as estado, " & vbCrLf)
        sqlbr.Append("isnull(d.descripcion,'') as puesto, isnull(f.descripcion,'') as turno, a.jornal," & vbCrLf)
        sqlbr.Append("isnull(convert(varchar(12),fnacimiento, 103),'') as fnacimiento, isnull(lugar,'') as lugar, isnull(nacionalidad,'') as nacionalidad,  " & vbCrLf)
        sqlbr.Append("case when genero = 1 then 'Masculino' when genero = 2 then 'Femenino' end as genero," & vbCrLf)
        sqlbr.Append("case when civil = 1 then 'Casado' when civil = 2 then 'Divorciado' when civil = 3 then 'Soltero' when civil = 4 then 'Unión libr' when civil = 5 then 'Viudo' else '' end as civil, " & vbCrLf)
        sqlbr.Append("isnull(talla,'') as talla, case when a.tipo = 1 then 0 else cast(a.sueldo as numeric(18,2)) end as sueldo, isnull(convert(varchar(12),fingreso, 103),'') as fingreso," & vbCrLf)
        sqlbr.Append("case when formapago = 1 then 'Quincenal' when formapago = 2 then 'Semanal' else '' end as formapago, " & vbCrLf)
        sqlbr.Append("h.descripcion as banco, '''' + SUBSTRING(clabe,1,len(clabe)) as clabe, '''' + SUBSTRING(cuenta,1,len(cuenta)) as cuenta, '''' + SUBSTRING(tarjeta,1,len(tarjeta)) as tarjeta," & vbCrLf)
        sqlbr.Append("isnull(convert(varchar(12),fbaja, 103),'') as fbaja,case when i.id_documento = 1 then 'Si' else 'No' end as AltaIMSS, a.correo, a.tel1, a.tel2, " & vbCrLf)
        sqlbr.Append("calle, noext, noint, a.colonia, a.cp, a.municipio, g.descripcion as estado, callef, coloniaf, cpf, municipiof, j.descripcion as estadof" & vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_empresa c on a.id_empresa = c.id_empresa" & vbCrLf)
        sqlbr.Append("left outer join tb_puesto d on a.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble e on a.id_inmueble = e.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join tb_turno f on a.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("left outer join tb_estado g on a.id_estado = g.id_estado " & vbCrLf)
        sqlbr.Append("left outer join tb_banco h on a.id_banco = h.id_banco " & vbCrLf)
        sqlbr.Append("left outer join tb_empleado_documento i on a.id_empleado = i.id_empleado and id_documento = 1 " & vbCrLf)
        sqlbr.Append("left outer join tb_estado j on a.id_estadof = j.id_estado " & vbCrLf)
        sqlbr.Append("left outer join tb_estado k on e.id_estado = k.id_estado" & vbCrLf)
        sqlbr.Append("where a.id_status <> 0" & vbCrLf)

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "Empleados")
    End Sub


    Protected Sub rptempleado1()
        Dim con As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder()

        sqlbr.Append("select isnull(rtrim(b.nombre),'') as cliente,  isnull(rtrim(e.nombre),'') as 'Punto de atención',  a.nombre as 'nombre(s)',"& vbCrLf)
        sqlbr.Append("a.paterno as Paterno, rtrim(a.materno) Materino, isnull(convert(varchar(12),fingreso, 103),'') as fingreso, isnull(convert(varchar(12),a.fbaja, 103),'') as ffin, '' AS 'cambio de servicio', " & vbCrLf)
        sqlbr.Append("isnull(SUBSTRING(ss,1,10) + '-' + SUBSTRING(ss,11,1),'') as ss,isnull(curp,'') as curp, "& vbCrLf)
        sqlbr.Append("isnull(a.rfc,'') as rfc, isnull(d.descripcion,'') as puesto,  a.id_empleado as 'Numero interno', isnull(convert(varchar(12),fnacimiento, 103),'') as fnacimiento," & vbCrLf)
        sqlbr.Append("case when genero = 1 then 'Masculino' when genero = 2 then 'Femenino' end as genero,"& vbCrLf)
        sqlbr.Append("isnull(a.tel1,'') as telefono, isnull(a.correo,'') as email," & vbCrLf)
        sqlbr.Append("callef, coloniaf, '' as pais, j.descripcion as estadof,"& vbCrLf)
        sqlbr.Append("calle, a.colonia, g.descripcion as estado, '' as 'contacto emergencia', a.tel2 as 'tel emergencia'," & vbCrLf)
        sqlbr.Append("'' as 'correo emergencia', '' as 'salario base cotizacion', cast(a.sueldo / 30.4167 as numeric(12,2)) as 'salario diario',"& vbCrLf)
        sqlbr.Append("1.0452 as 'factor integracion', cast((a.sueldo / 30.4167) * 1.0452  as numeric(12,2)) as 'salario diario integrado'," & vbCrLf)
        sqlbr.Append("cast(a.sueldo as numeric(12,2)) as sueldo, case when a.id_status = 1 then 'Candidato' when a.id_status =2 then 'Activo' when a.id_status = 3 then 'Baja' when a.id_status = 4 then 'No se presento' end as estatus"& vbCrLf)
        sqlbr.Append("from tb_empleado a left outer join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_empresa c on a.id_empresa = c.id_empresa"& vbCrLf)
        sqlbr.Append("left outer join tb_puesto d on a.id_puesto = d.id_puesto" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble e on a.id_inmueble = e.id_inmueble"& vbCrLf)
        sqlbr.Append("left outer join tb_turno f on a.id_turno = f.id_turno" & vbCrLf)
        sqlbr.Append("left outer join tb_estado g on a.id_estado = g.id_estado "& vbCrLf)
        sqlbr.Append("left outer join tb_banco h on a.id_banco = h.id_banco " & vbCrLf)
        sqlbr.Append("left outer join tb_empleado_documento i on a.id_empleado = i.id_empleado and id_documento = 1 "& vbCrLf)
        sqlbr.Append("left outer join tb_estado j on a.id_estadof = j.id_estado " & vbCrLf)
        sqlbr.Append("where a.id_status <> 0" & vbCrLf)

        Dim dt As New DataTable()
        Dim da As New SqlDataAdapter(sqlbr.ToString(), con)
        da.Fill(dt)

        extoex(dt, "Empleados")
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim otr As String = Request("ddd")
        Dim ojs As New JavaScriptSerializer()
        'Dim prm As parametro = ojs.Deserialize(Of parametro)(otr)
        If Request("folio") = 1 Then
            rptempleado()
        Else
            rptempleado1()
        End If

    End Sub
End Class
