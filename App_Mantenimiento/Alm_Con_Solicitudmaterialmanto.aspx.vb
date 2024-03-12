Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class App_Almacen_Alm_Con_Solicitudmaterial
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""
    'Private Conexio As Conexion

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
    Public Shared Function contarsolicitud(ByVal fini As String, ByVal ffin As String, ByVal cli As Integer, ByVal est As Integer, ByVal folio As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("SELECT COUNT(*)/50 + 1 as Filas, COUNT(*) % 50 as Residuos FROM tb_solicitudmaterialmantto" & vbCrLf)
        sqlbr.Append("where id_servicio = 1 and id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(falta as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'")
        If cli <> 0 Then sqlbr.Append("and id_cliente =" & cli & "")

        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "")
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
    Public Shared Function solicitudes(ByVal fini As String, ByVal ffin As String, ByVal cli As Integer, ByVal inm As Integer, ByVal est As Integer, ByVal pagina As Integer, ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        Dim vfecini As Date
        If fini <> "" Then vfecini = fini
        Dim vfecfin As Date
        If ffin <> "" Then vfecfin = ffin

        sqlbr.Append("select id_solicitud as 'td','', falta as 'td','', almacen as 'td','', cliente as 'td','', inmueble as 'td','', estatus as 'td',''," & vbCrLf)
        sqlbr.Append("cast(total as numeric(12,2)) as 'td',''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btimprime' as '@class', 'Imprimir' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btedita' as '@class', 'Editar' as '@value', 'button' as '@type' for xml path('input'),root('td'),type),''," & vbCrLf)
        sqlbr.Append("case when id_status = 2 then " & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btdespacha' as '@class', 'Despachar' as '@value', 'button' as '@type' for xml path('input'),type)" & vbCrLf)
        sqlbr.Append(" when id_status = 1 then" & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btauto' as '@class', 'Autorizar/Rechazar' as '@value', 'button' as '@type' for xml path('input'),type)" & vbCrLf)
        sqlbr.Append(" when id_status = 2 then" & vbCrLf)
        sqlbr.Append("(select 'btn btn-primary btauto' as '@class', 'Autorizar' as '@value', 'button' as '@type' for xml path('input'),type)" & vbCrLf)
        sqlbr.Append("end as 'td','', id_cliente as 'td','', id_almacenent as 'td',''," & vbCrLf)

        sqlbr.Append("(select id_almacensal as '@text','display: none;' AS '@style' for xml path('td'),type) " & vbCrLf) 'Cambio Fide 13-02-2024, agregar el almacen de salida

        sqlbr.Append("from ( Select  ROW_NUMBER() over (order by a.id_solicitud ) as rownum, id_solicitud, d.nombre as cliente, b.nombre as almacen, " & vbCrLf)
        sqlbr.Append("e.descripcion as estatus, convert(varchar(12), falta,103) as falta , a.id_status, a.id_almacenent, a.id_cliente, " & vbCrLf)
        sqlbr.Append("(select sum(cantidad * precio) from tb_solicitudmaterialdmantto where id_solicitud = a.id_solicitud) as total, f.nombre as inmueble, a.id_almacensal" & vbCrLf)
        sqlbr.Append("from tb_solicitudmaterialmantto a inner join tb_almacen b on a.id_almacenent = b.id_almacen" & vbCrLf)
        sqlbr.Append("inner join tb_cliente d on a.id_cliente = d.id_cliente inner join tb_statusc e on a.id_status = e.id_status " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble f on a.id_inmueble = f.id_inmueble" & vbCrLf)
        sqlbr.Append("where a.id_servicio = 1 and a.id_status = " & est & "" & vbCrLf)
        If fini <> "" Then sqlbr.Append("and cast(a.falta as date) between '" & Format(vfecini, "yyyyMMdd") & "' And '" & Format(vfecfin, "yyyyMMdd") & "'" & vbCrLf)
        If cli <> 0 Then sqlbr.Append("and a.id_cliente =" & cli & "" & vbCrLf)
        If inm <> 0 Then sqlbr.Append("and a.id_inmueble =" & inm & "" & vbCrLf)
        If folio <> 0 Then sqlbr.Append("and id_solicitud =" & folio & "" & vbCrLf)


        sqlbr.Append(") as result where RowNum BETWEEN (" & pagina & " - 1) * 50 And " & pagina & " * 50 order by id_solicitud for xml path('tr'), root('tbody')")
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
    Public Shared Function detalles(ByVal folio As Integer, ByVal AlmacenSalida As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder


        sqlbr.Append("select a.clave as 'td','', d.descripcion as 'td','', e.descripcion as 'td','', cast(a.cantidad as numeric(12,2))-cast(a.entregado as numeric(12,2)) as 'td','', " & vbCrLf)
        sqlbr.Append("cast(isnull(c.costopromedio,0) as numeric(12,2)) as 'td','', cast(isnull(c.existencia,0) as numeric(12,2)) as 'td',''," & vbCrLf)

        sqlbr.Append("case when isnull(c.existencia,0)>0 and cast(a.cantidad as numeric(12,2))!=cast(a.entregado as numeric(12,2))  then " & vbCrLf)
        sqlbr.Append("(select cast(a.cantidad as numeric(12,2))-cast(a.entregado as numeric(12,2)) as '@cantidad','form-control text-right txcant' as '@class', case when isnull(c.existencia,0) < a.cantidad then 'border-width: thin; border-color: #CC3300' else '' end   as '@style', cast(case when isnull(c.existencia,0) > a.cantidad then isnull(a.cantidad,0) else isnull(c.existencia,0) end as numeric(12,2))  as '@value','Entregado: ' + cast(cast(a.entregado as numeric(12,2))as varchar(100)) +' de ' + cast(cast(a.cantidad as numeric(12,2))as varchar(100))  as '@title' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append(" else " & vbCrLf)
        sqlbr.Append("(select 'disabled' as '@disabled','form-control text-right' as '@class', cast(case when isnull(c.existencia,0) > a.cantidad then isnull(a.cantidad,0) else isnull(c.existencia,0) end as numeric(12,2))  as '@value','Entregado: ' + cast(cast(a.entregado as numeric(12,2))as varchar(100)) + ' de '  + cast(cast(a.cantidad as numeric(12,2))as varchar(100))  as '@title' for xml path('input'),root('td'),type)" & vbCrLf)
        sqlbr.Append("end " & vbCrLf)


        sqlbr.Append(", (select cast(a.cantidad as numeric(12,2)) as '@CantOrig', cast(a.entregado as numeric(12,2)) as '@entregado','display: none;' AS '@style' for xml path('td'),type) " & vbCrLf) 'Cambio Fide 13-02-2024, agregar el almacen de salida
        sqlbr.Append("from tb_solicitudmaterialdmantto a inner join tb_solicitudmaterialmantto b on a.id_solicitud = b.id_solicitud" & vbCrLf)
        sqlbr.Append("left join tb_inventario c on a.clave = c.clave " & vbCrLf) 'Cambio Fide left x inner, para que traiga todo aun que NO este en inventario, se usa  isnull,0  
        sqlbr.Append("inner join tb_producto d on a.clave = d.clave inner join tb_unidadmedida e on d.id_unidad = e.id_unidad " & vbCrLf)
        sqlbr.Append("where a.id_solicitud = " & folio & " and (c.id_almacen=" & AlmacenSalida & " or isnull(c.id_almacen,0)=0) for xml path('tr'), root('tbody')")
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
    Public Shared Function autoriza(ByVal status As Integer, ByVal sol As Integer) As String

        Dim sql As String = "Update tb_solicitudmaterialmantto set id_status = " & status & " where id_solicitud =" & sol & ";"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal incompleto As Integer) As String
        Dim aa As String = ""
        Dim folio As Integer = 0
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)

        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_salidaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 19) '   19 -> Salida por Despacho -> E -> 0
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
            mycommand.Parameters.AddWithValue("@incompleto", incompleto) 'Cambio Fide 14-02-2024, se envia si esta completa o no la salida de material
            mycommand.ExecuteNonQuery()

            folio = prmR.Value 'Folio de la salida

            'Cambio Fide 13-02-2024, se agrega SP de entrada a Almacen

            mycommand = New SqlCommand("sp_entradaalmacen", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@Cabecero", registro)
            mycommand.Parameters.AddWithValue("@docto", 1)  '   1 -> Entrada por Despacho -> E -> 0
            Dim prmREntrada As New SqlParameter("@Id", "0") 'Folio de la entrada
            prmR.Size = 10
            prmR.Direction = ParameterDirection.Output
            mycommand.Parameters.Add(prmREntrada)

            mycommand.ExecuteNonQuery()



            trans.Commit()
        Catch ex As Exception

            trans.Rollback()
            aa = ex.Message.ToString().Replace("'", "")
            'Response.Write("<script>alert('" & aa & "');</script>")

        End Try
        myConnection.Close()
        Return folio

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
