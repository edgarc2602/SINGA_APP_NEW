Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Partial Class App_Operaciones_Ope_Pro_Ticket
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function tipo(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""


        If usuario <> 0 Then
            sqlbr.Append("select a.id_lineanegocio, b.descripcion from tb_cliente_lineanegocio a inner join tb_lineanegocio b on a.id_lineanegocio = b.id_lineanegocio where a.id_cliente = " & usuario & " order by descripcion")
        Else
            sqlbr.Append("select id_lineanegocio, descripcion from tb_lineanegocio order by descripcion")
        End If
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

    <Web.Services.WebMethod()>
    Public Shared Function cliente(ByVal idcte As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        If idcte = 0 Then
            sqlbr.Append("select id_cliente, nombre from Tb_Cliente where id_status = 1 order by nombre")
        Else
            sqlbr.Append("select id_cliente, nombre from Tb_Cliente where id_status = 1 and id_cliente = " & idcte & " order by nombre")
        End If
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
        sqlbr.Append("select id_inmueble, nombre from tb_cliente_inmueble where id_status = 1 and id_cliente = " & cliente & " order by nombre")
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
    Public Shared Function gerente(ByVal cliente As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select b.id_empleado, b.paterno + ' ' + rtrim(b.materno) + ' ' + b.nombre as gerente from tb_cliente a inner join tb_empleado b on a.id_operativo = b.id_empleado where a.id_cliente = " & cliente & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_empleado") & "', desc:'" & dt.Rows(0)("gerente") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function ejecutivo(ByVal empleado As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        If empleado <> 0 Then
            sqlbr.Append(" Select IdPersonal, Per_Paterno+' '+ rtrim(Per_Materno) +' ' +Per_Nombre as personal FROM Personal where per_status=0 and idarea = 11 order by per_paterno, per_materno, per_nombre")
        Else
            sqlbr.Append(" Select IdPersonal, Per_Paterno+' '+ rtrim(Per_Materno) +' ' +Per_Nombre as personal FROM Personal where per_status=0 and idarea in(9) order by per_paterno, per_materno, per_nombre")
        End If

        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("IdPersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("personal") & "'}" & vbCrLf
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
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT id_mes, descripcion FROM tb_mes  order by id_mes")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_mes") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function incidencia(ByVal linea As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT id_incidencia, Tk_Inc_Descripcion FROM Tbl_tk_Incidencia where id_lineanegocio = " & linea & " and id_status = 1 order by Tk_Inc_Descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_incidencia") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("Tk_Inc_Descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function causa(ByVal incidencia As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT id_causaorigen, Tk_cuaori_Descripcion FROM Tbl_tk_CausaOrigen where id_status =1" & vbCrLf)
        ' If tipo = 1 Then
        sqlbr.Append(" and id_incidencia = " & incidencia & "" & vbCrLf)
        ' Else
        'sqlbr.Append(" and id_lineanegocio = " & tipo() & "" & vbCrLf)
        'End If
        sqlbr.Append("order by Tk_cuaori_Descripcion")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("id_causaorigen") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("Tk_cuaori_Descripcion") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function area(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT idarea, ar_nombre FROM Tbl_Area_Empresa" & vbCrLf)
        If usuario <> 0 Then sqlbr.Append("where idarea = 11" & vbCrLf)
        sqlbr.Append("order by ar_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idarea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("ar_nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function atiende(ByVal area As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT idpersonal, Per_Nombre+' '+ Per_Paterno+' '+ Per_Materno as nombre FROM personal" & vbCrLf)
        sqlbr.Append(" where per_status= 0 and idarea = " & area & "" & vbCrLf)
        sqlbr.Append("order by nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idpersonal") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function areaasignada(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT a.idarea, a.ar_nombre FROM Tbl_Area_Empresa a inner join Tbl_Ticket_area b on a.idarea = b.id_area where b.id_ticket = " & folio & "  order by ar_nombre")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:'" & dt.Rows(x)("idarea") & "'," & vbCrLf
                sql += "desc:'" & dt.Rows(x)("ar_nombre") & "'}" & vbCrLf
            Next
        End If
        sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cargaticket(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("SELECT id_ticket, a.no_Ticket, Tk_Folio, ID_Servicio, Tk_FechaAlta, convert (varchar(20), Tk_HoraAlta ,8) as hora, Tk_MesServicio, ID_Cliente, ID_Gerente, id_Sucursal, ID_Estado," & vbCrLf)
        sqlbr.Append("ID_Ambito, Tk_Reporta, Tk_ID_Ejecutivo, Tk_origen, ID_Incidencia, ID_CausaOrigen, REPLACE(Tk_Descripcion, CHAR(13), '') Tk_Descripcion, Tk_Estatus, ubicacion," & vbCrLf)
        sqlbr.Append("Tk_Accion_Correctiva, Tk_Accion_Preventiva, tk_cubre, tk_nombrecubre, tk_fechatermino, convert (varchar(20), tk_horatermino ,8) as tk_horatermino, id_area, correos, id_atiende,  " & vbCrLf)
        sqlbr.Append("convert(varchar(17), b.fnotifica, 113) as fnotifica, convert(varchar(17), b.fescala, 113) as fescala" & vbCrLf)
        sqlbr.Append("from Tbl_Ticket a left outer join tbl_ticket_escala b on a.no_ticket = b.no_ticket where a.no_Ticket = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{id:'" & dt.Rows(0)("id_ticket") & "', idticket: '" & dt.Rows(0)("no_Ticket") & "',  folio:'" & dt.Rows(0)("Tk_Folio") & "', servicio:'" & dt.Rows(0)("ID_Servicio") & "', falta:'" & dt.Rows(0)("Tk_FechaAlta") & "',"
            sql += " hora:'" & dt.Rows(0)("hora") & "',  mes:'" & dt.Rows(0)("Tk_MesServicio") & "', cliente:'" & dt.Rows(0)("ID_Cliente") & "',"
            sql += " gerente:'" & dt.Rows(0)("ID_Gerente") & "',sucursal:'" & dt.Rows(0)("id_Sucursal") & "', ubicacion:'" & dt.Rows(0)("ubicacion") & "',"
            sql += " ambito:'" & dt.Rows(0)("ID_Ambito") & "',reporta:'" & dt.Rows(0)("Tk_Reporta") & "', ejecutivo:'" & dt.Rows(0)("Tk_ID_Ejecutivo") & "',"
            sql += " origen:'" & dt.Rows(0)("Tk_origen") & "',incidencia:'" & dt.Rows(0)("ID_Incidencia") & "', causa:'" & dt.Rows(0)("ID_CausaOrigen") & "',"
            sql += " desc:'" & dt.Rows(0)("Tk_Descripcion") & "', estatus:'" & dt.Rows(0)("Tk_Estatus") & "', accionc:'" & dt.Rows(0)("Tk_Accion_Correctiva") & "'," '" & dt.Rows(0)("Tk_Descripcion") & "
            sql += " accionp:'" & dt.Rows(0)("Tk_Accion_Preventiva") & "', cubre:'" & dt.Rows(0)("tk_cubre") & "', ncubre:'" & dt.Rows(0)("tk_nombrecubre") & "',"
            sql += " ftermino:'" & dt.Rows(0)("tk_fechatermino") & "', htermino:'" & dt.Rows(0)("tk_horatermino") & "', area:'" & dt.Rows(0)("id_area") & "', correos:'" & dt.Rows(0)("correos") & "', atiende:'" & dt.Rows(0)("id_atiende") & "',"
            sql += " fnotifica: '" & dt.Rows(0)("fnotifica") & "', fescala: '" & dt.Rows(0)("fescala") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function extras(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select ID_Ticket, Tk_Folio FROM Tbl_Ticket where NO_Ticket = " & folio & ";")
        sqlbr.Append("select fnotifica, fescala from tbl_ticket_escala where NO_Ticket = " & folio & ";")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            sql += "{idticket: '" & dt.Tables(0).Rows(0)("ID_Ticket") & "',  folio:'" & dt.Tables(0).Rows(0)("Tk_Folio") & "',"
            sql += "fnotifica: '" & dt.Tables(1).Rows(0)("fnotifica") & "', fescala: '" & dt.Tables(1).Rows(0)("fescala") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guarda(ByVal registro As String, ByVal folio As Integer) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_ticket", myConnection)
        mycommand.CommandType = CommandType.StoredProcedure
        mycommand.Parameters.AddWithValue("@Cabecero", registro)
        Dim prm1 As New SqlParameter("@idtk", 0)
        prm1.Size = 10
        prm1.Direction = ParameterDirection.Output
        mycommand.Parameters.Add(prm1)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        If folio = 0 Then
            Dim generacorreo As New correocgo()
            generacorreo.ticket(prm1.Value)
        End If
        Return prm1.Value
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function reenviacorreo(ByVal folio As Integer, ByVal direcciones As String) As String

        Dim generacorreo As New correocgo()
        generacorreo.ticketreenvio(folio, direcciones)

        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaincidencia(ByVal registro As String) As String

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand("sp_incidenciacausa", myConnection)
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
    Public Shared Function bitacoras(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("set language spanish" & vbCrLf)
        sqlbr.Append("select ID_Ticket as 'td','', convert( varchar(20), Tk_Bit_Fecha, 113) as 'td','', b.Per_Paterno + ' ' + rtrim(Per_Materno) + ' ' + Per_Nombre as 'td','', a.Tk_Bit_Observacion  as 'td'" & vbCrLf)
        sqlbr.Append("From Tbl_tk_Bitacora a inner join Personal b on a.IdUsuario = b.IdPersonal  where ID_Ticket = " & folio & " for xml path('tr'), root('tbody')")

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
    Public Shared Function guardabitacora(ByVal folio As Integer, ByVal coment As String, ByVal usuario As Integer) As String

        Dim sql As String = "insert into Tbl_tk_Bitacora (id_ticket, tk_bit_fecha, tk_bit_observacion, idusuario) values (" & folio & ", getdate(),'" & coment & "'," & usuario & ")"
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function guardaacciones(ByVal folio As Integer, ByVal accionc As String, ByVal accionp As String) As String

        Dim sql As String = "update tbl_ticket set tk_accion_correctiva = '" & accionc & "', tk_accion_preventiva = '" & accionp & "' where id_ticket =" & folio & ""
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim mycommand As New SqlCommand(sql, myConnection)
        myConnection.Open()
        mycommand.ExecuteNonQuery()
        myConnection.Close()
        myConnection = Nothing
        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function cteuser(ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select per_interno from personal where idpersonal = " & usuario & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        'sql = "["
        If dt.Rows.Count > 0 Then
            '   For x As Integer = 0 To dt.Rows.Count - 1
            '  If x > 0 Then sql += ","
            sql = "{cliente:'" & dt.Rows(0)("per_interno") & "'}" & vbCrLf
            ' Next
        End If
        'sql += "]"
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function correosadicionales(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select correos1 as originales from (" & vbCrLf)
        sqlbr.Append("select c.Per_Email+';'+ e.correo +';'+ correos +';' + i.Per_Email +';' as correos1" & vbCrLf)
        sqlbr.Append("from Tbl_Ticket a inner join tb_cliente b on a.ID_Cliente = b.id_cliente  " & vbCrLf)
        sqlbr.Append("inner join Personal c on a.Tk_ID_Ejecutivo = c.IdPersonal " & vbCrLf)
        sqlbr.Append("inner join tb_empleado e on b.id_operativo = e.id_empleado " & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble h on a.id_sucursal = h.id_inmueble" & vbCrLf)
        sqlbr.Append("left outer join Personal i on a.id_atiende = i.IdPersonal" & vbCrLf)
        sqlbr.Append("where No_Ticket = " & folio & ") as result")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{correos:'" & dt.Rows(0)("originales") & "'}"
        End If
        Return sql
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function horas(ByVal problema As String) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select tiempo from Tbl_tk_CausaOrigen  where id_causaorigen = " & problema & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += "{horas:'" & dt.Rows(0)("tiempo") & "'}"
        End If
        Return sql
    End Function
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        'idvacante.Value = Request("id")
        idticket.Value = Request("folio")

        Dim usuario As HttpCookie
        Dim userid As Integer


        usuario = Request.Cookies("Usuario")
        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = usuario.Value
            idusuario.Value = usuario.Value
            cteusuario.Value = Request.Cookies("Cliente").Value
        End If
        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
