Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports System.IO
Partial Class App_Mantenimiento_OP_Con_CorrectivoMayor
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function cambiaestatus(ByVal req As Integer, ByVal status As Integer, ByVal usuario As Integer, ByVal motivo As String) As String

        Dim sql As String = "Update tb_correctivo_mayor set id_status = " & status & " "
        Select Case status
            Case 2
                sql += ", usuarioautoriza = " & usuario & ", fautoriza = getdate()"
            Case 6
                sql += ", usuariorechaza = " & usuario & ", frechaza = getdate(), motivo ='" & motivo & "'"
        End Select

        sql += " where id_clavecm =" & req & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function actualiza(ByVal id_clavecm As String, ByVal archivo As String) As String

        Dim sql As String = "insert into tb_correctivomayor_documento(id_clavecm, archivo, id_documento) values (" & id_clavecm & ", '" & archivo & "', 2 );"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function
    <Web.Services.WebMethod()>
    Public Shared Function estatus() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select id_status, descripcion from tb_statuscm order by descripcion" & vbCrLf)
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
    Public Shared Function contarcm(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal estatus As Integer, ByVal cliente As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_correctivo_mayor where id_clavecm != 0" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and id_status = " & estatus & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_clavecm =" & folio & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and id_cliente = " & cliente & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and fregistro between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)

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
    Public Shared Function solicitudes(ByVal fini As String, ByVal ffin As String, ByVal folio As Integer, ByVal pagina As Integer, ByVal estatus As Integer, ByVal cliente As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_clavecm as 'td','', isnull(tipo,'') as 'td','', cliente as 'td','', inmueble as 'td','', estatus as 'td',''," & vbCrLf)
        sqlbr.Append("fregistro as 'td','', destrabajos as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btevidencia' as '@class', 'Evidencia' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when estatus = 'Alta' then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btauto' as '@class', 'Autorizar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Autorizado' then" & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btcierra' as '@class', 'Cerrar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Cerrado' then" & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btfactura' as '@class', 'Facturado' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("when estatus = 'Facturado' then" & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btcobra' as '@class', 'Cobrado' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("end, " & vbCrLf)
        sqlbr.Append("case when estatus ='Facturado' OR estatus ='Cobrado' then" & vbCrLf)
        sqlbr.Append("	(select 'btn btn-primary btver' as '@class', 'Ver factura' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("	end" & vbCrLf)
        sqlbr.Append("from (Select ROW_NUMBER() over (order by id_clavecm) as rownum, id_clavecm, c.descripcion as tipo, case when a.id_cliente != 0 then b.nombre else clienten end as cliente, " & vbCrLf)
        sqlbr.Append("case when a.id_inmueble != 0 then d.nombre else inmueblen end as inmueble, e.descripcion as estatus, " & vbCrLf)
        sqlbr.Append("convert(varchar(12), fregistro, 103) as fregistro, destrabajos" & vbCrLf)
        sqlbr.Append("from tb_correctivo_mayor a left outer join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("left join tb_tipomantenimiento c on a.id_servicio = c.id_servicio" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble d on a.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("inner join tb_statuscm e on a.id_status = e.id_status" & vbCrLf)
        sqlbr.Append("where id_clavecm != 0" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and a.id_clavecm =" & folio & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.fregistro as date) between '" & Format(vfecini, "yyyyMMdd") & "' and '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If estatus <> 0 Then sqlbr.Append("and a.id_status =" & estatus & "" & vbCrLf)
        If cliente <> 0 Then sqlbr.Append("and a.id_cliente =" & cliente & "" & vbCrLf)
        sqlbr.Append(") as tabla where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 for xml path('tr'), root('tbody')")
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
    Public Shared Function cierra(ByVal id_clavecm As Integer) As String

        Dim aa As String = ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_correctivomayorutilidad", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Id", id_clavecm)
            mycommand.ExecuteNonQuery()

            trans.Commit()

            Dim generacorreo As New correomanto()
            generacorreo.correctivocierre(id_clavecm)

        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cobra(ByVal id_clavecm As Integer) As String

        Dim sql As String = "Update tb_correctivo_mayor set id_status = 5 where id_clavecm = " & id_clavecm & ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing


        Dim generacorreo As New correomanto()
        generacorreo.correctivopago(id_clavecm)

        Return ""

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
    Public Shared Function guardafactura(ByVal registro As String, ByVal id_clavecm As Integer) As String
        Dim aa As String = ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_facturacm", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Material", registro)
            mycommand.ExecuteNonQuery()

            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
        End Try
        myConnection.Close()


        Dim generacorreo As New correomanto()
        generacorreo.correctivofac(id_clavecm)

        Return ""

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
    Public Shared Function listadocto(ByVal servicio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("select archivo as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btver' as '@class', 'Ver' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        'sqlbr.Append("(select 'btn btn-primary btquita' as '@class', 'Eliminar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("From  tb_correctivomayor_documento " & vbCrLf)
        sqlbr.Append("where  id_documento=4 and id_clavecm = " & servicio & "  for xml path('tr'), root('tbody')")
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
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")
        idcliente1.Value = Request.Cookies("Cliente").Value

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
