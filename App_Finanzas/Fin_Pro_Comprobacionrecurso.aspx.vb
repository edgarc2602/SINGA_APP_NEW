Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Finanzas_Fin_Pro_Comprobacionrecurso
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function cargasol(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_solicitud, concepto, beneficiario, total, comprobado, total - comprobado as saldo, estatus from (" & vbCrLf)
        sqlbr.Append("select a.id_solicitud, concepto, case when a.id_empleado != 0 then b.nombre + ' ' + b.paterno + ' ' + b.materno" & vbCrLf)
        sqlbr.Append("when a.id_proveedor != 0 then c.razonsocial when a.id_jornalero != 0 then d.nombre + ' ' + d.paterno + ' ' + d.materno" & vbCrLf)
        sqlbr.Append("end as beneficiario, total, e.descripcion as estatus," & vbCrLf)
        sqlbr.Append("(select isnull(SUM(importe),0) as total from tb_solicitudrecursocomp where id_solicitud = a.id_solicitud and id_status in(1,2))as comprobado" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecurso a left outer join tb_empleado b on a.id_empleado = b.id_empleado" & vbCrLf)
        sqlbr.Append("left outer join tb_proveedor c on a.id_proveedor = c.id_proveedor" & vbCrLf)
        sqlbr.Append("left outer join tb_jornalero d on a.id_jornalero = d.id_jornalero " & vbCrLf)
        sqlbr.Append("inner join tb_statussr e on a.id_status = e.id_status " & vbCrLf)
        sqlbr.Append(") as tabla " & vbCrLf)
        sqlbr.Append("where id_solicitud = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_solicitud") & "', concepto: '" & dt.Rows(0)("concepto") & "',  beneficiario:'" & dt.Rows(0)("beneficiario") & "', total:'" & dt.Rows(0)("total") & "', comprobado:'" & dt.Rows(0)("comprobado") & "',"
            sql += " saldo: '" & dt.Rows(0)("saldo") & "', estatus: '" & dt.Rows(0)("estatus") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String) As Integer

        Dim aa As String = ""
        Dim folio As Integer
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_comprobacion", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@comprobante", registro)
            Dim prmR As New SqlParameter("@completo", "0")
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

        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function comprobacion(ByVal solicitud As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select convert(varchar(10), fecha, 103) as 'td','', case when documento = 1 then 'Factura' when documento = 2 then 'Nota de remisión' when documento = 3 then 'Vale azul' when documento = 4 then 'Depósito' when documento = 5 then 'Convenio' when documento = 6 then 'Excel' when documento = 7 then 'Complemento de pago' end as 'td',''," & vbCrLf)
        sqlbr.Append("folio as 'td','', '', '' as 'td', cast(importe as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver documento' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when id_status = 1 then 'Sin confirmar' when id_status = 2 then 'Confirmado' when id_status = 6 then 'Rechazado' end as 'td', ''," & vbCrLf)
        sqlbr.Append("isnull(motivo,'') as 'td', '', id_comprobacion as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btvalida' as '@class', 'Confirmar/Rechazar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("from tb_solicitudrecursocomp where id_solicitud = " & solicitud & " order by id_comprobacion for xml path('tr'), root('tbody')")
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
    Public Shared Function listadocto(ByVal servicio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select documento as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btquita' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From tb_solicitudrecursocompf " & vbCrLf)
        sqlbr.Append("where id_comprobacion = " & servicio & "  for xml path('tr'), root('tbody')")
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
    Public Shared Function cambiaestatus(ByVal registro As String, ByVal status As Integer, ByVal solicitud As Integer) As Integer

        Dim aa As String = ""
        Dim folio As Integer
        Dim sqlbr As New StringBuilder
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try
            Dim mycommand As New SqlCommand("sp_comprobacionconf", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@comprobante", registro)
            Dim prmR As New SqlParameter("@completo", "0")
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

        Dim generacorreo As New correofinanzas()
        If status = 6 Then
            generacorreo.rechazacomprobacion(solicitud)
        End If


        Return folio

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function enviacorreo(ByVal registro As String) As String

        Dim sql As String = "Update tb_solicitudrecurso set id_status = 7 where id_solicitud =  " & registro & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Dim generacorreo As New correofinanzas()
        generacorreo.compruebasolicitud(registro)

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function enviacorreocierre(ByVal registro As String) As String

        Dim sql As String = "Update tb_solicitudrecurso set id_status = 8 where id_solicitud =  " & registro & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()

        Dim generacorreo As New correofinanzas()
        generacorreo.terminasolicitud(registro)

        Return ""

    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        'Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idsol.Value = Request("folio")
        'seresp.Value = Request("seresp")

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
