Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
    Partial Class App_Movil_Default
        Inherits System.Web.UI.Page

        Public listamenu As String = ""
        Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function supervision(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select fechaini, fechafin, b.nombre as cliente, c.nombre as inmueble, d.Per_Nombre + ' ' + d.Per_Materno as usuario," & vbCrLf)
        sqlbr.Append("case when listaexiste = 1 then 'Si' else 'No' end as tienelista," & vbCrLf)
        sqlbr.Append("case when listaregistro = 1 then 'Si' else 'No' end as listaregistro," & vbCrLf)
        sqlbr.Append("case when personaluniforme = 1 then 'Si' else 'No' end as personaluniforme," & vbCrLf)
        sqlbr.Append("case when personalcredencial = 1 then 'Si' else 'No' end as personalcredencial, REPLACE(Replace(personalcomentario, CHAR(13), '') , CHAR(10),'') as personalcomentario, " & vbCrLf)
        sqlbr.Append("case when herramientacompleta = 1 then 'Si' else 'No' end as herramientacompleta," & vbCrLf)
        sqlbr.Append("case when materialordenado = 1 then 'Si' else 'No' end as materialordenado," & vbCrLf)
        sqlbr.Append("case when materialinventario = 1 then 'Si' else 'No' end as materialinventario," & vbCrLf)
        sqlbr.Append("case when materialbitacora = 1 then 'Si' else 'No' end as materialbitacora," & vbCrLf)
        sqlbr.Append("case when limpiezarutina = 1 then 'Si' else 'No' end as limpiezarutina," & vbCrLf)
        sqlbr.Append("case when materialvisual = 1 then 'Si' else 'No' end as materialvisual, REPLACE(Replace(materialcomentario, CHAR(13), '') , CHAR(10),'') as materialcomentario," & vbCrLf)
        sqlbr.Append("case when clienteentrevista = 1 then 'Si' else 'No' end as clienteentrevista, clientenombre," & vbCrLf)
        sqlbr.Append("case when evalua = 3 then 'Bueno' when evalua = 2 then 'Regular' when evalua = 1 then 'Malo' when evalua = 0 then 'No Aplica'  end evalua," & vbCrLf)
        sqlbr.Append("case when trabrealizados = 3 then 'Bueno' when trabrealizados = 2 then 'Regular' when trabrealizados = 1 then 'Malo' when trabrealizados = 0 then 'No Aplica'  end trabrealizados," & vbCrLf)
        sqlbr.Append("case when uniformcompleto = 1 then 'Si' else 'No' end as uniformcompleto," & vbCrLf)
        sqlbr.Append("case when tratopersonal = 3 then 'Bueno' when tratopersonal = 2 then 'Regular' when tratopersonal = 1 then 'Malo' when tratopersonal = 0 then 'No Aplica'  end tratopersonal," & vbCrLf)
        sqlbr.Append("case when suprecorrido = 1 then 'Si' else 'No' end as suprecorrido," & vbCrLf)
        sqlbr.Append("case when areaoportunidad = 1 then 'Si' else 'No' end as areaoportunidad," & vbCrLf)
        sqlbr.Append("case when plancorrectivo = 1 then 'Si' else 'No' end as plancorrectivo," & vbCrLf)
        sqlbr.Append("case when calificasup = 3 then 'Bueno' when calificasup = 2 then 'Regular' when calificasup = 1 then 'Malo' when calificasup = 0 then 'No Aplica'  end calificasup," & vbCrLf)
        sqlbr.Append("case when ejecutivocgo = 3 then 'Bueno' when ejecutivocgo = 2 then 'Regular' when ejecutivocgo = 1 then 'Malo' when ejecutivocgo = 0 then 'No Aplica'  end ejecutivocgo," & vbCrLf)
        sqlbr.Append("case when reporteasiscgo = 1 then 'Si' else 'No' end as reporteasiscgo," & vbCrLf)
        sqlbr.Append("case when matetiquetados = 1 then 'Si' else 'No' end as matetiquetados," & vbCrLf)
        sqlbr.Append("case when matrequerimientos = 1 then 'Si' else 'No' end as matrequerimientos, REPLACE(Replace(clientecomentario, CHAR(13), '') , CHAR(10),'') as clientecomentario " & vbCrLf)
        sqlbr.Append("from tb_supervision a inner join tb_cliente b on a.id_cliente = b.id_cliente" & vbCrLf)
        sqlbr.Append("inner join tb_cliente_inmueble c on a.id_inmueble = c.id_inmueble" & vbCrLf)
        sqlbr.Append("inner join personal d on a.usuario = d.IdPersonal " & vbCrLf)
        sqlbr.Append("where id_supervision = " & folio & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql = "{fechaini:'" & dt.Rows(0)("fechaini") & "', fechafin:'" & dt.Rows(0)("fechafin") & "' ," & vbCrLf
            sql += "cliente:'" & dt.Rows(0)("cliente") & "', inmueble:'" & dt.Rows(0)("inmueble") & "' ," & vbCrLf
            sql += "usuario:'" & dt.Rows(0)("usuario") & "', tienelista:'" & dt.Rows(0)("tienelista") & "' ," & vbCrLf
            sql += "listaregistro:'" & dt.Rows(0)("listaregistro") & "', personaluniforme:'" & dt.Rows(0)("personaluniforme") & "' ," & vbCrLf
            sql += "personalcredencial:'" & dt.Rows(0)("personalcredencial") & "', personalcomentario:'" & dt.Rows(0)("personalcomentario") & "'," & vbCrLf
            sql += "herramientacompleta:'" & dt.Rows(0)("herramientacompleta") & "', materialordenado:'" & dt.Rows(0)("materialordenado") & "'," & vbCrLf
            sql += "materialinventario:'" & dt.Rows(0)("materialinventario") & "', materialbitacora:'" & dt.Rows(0)("materialbitacora") & "'," & vbCrLf
            sql += "limpiezarutina:'" & dt.Rows(0)("limpiezarutina") & "', materialvisual:'" & dt.Rows(0)("materialvisual") & "'," & vbCrLf
            sql += "materialcomentario:'" & dt.Rows(0)("materialcomentario") & "', clienteentrevista:'" & dt.Rows(0)("clienteentrevista") & "'," & vbCrLf
            sql += "clientenombre:'" & dt.Rows(0)("clientenombre") & "', evalua:'" & dt.Rows(0)("evalua") & "'," & vbCrLf
            sql += "trabrealizados:'" & dt.Rows(0)("trabrealizados") & "', uniformcompleto:'" & dt.Rows(0)("uniformcompleto") & "'," & vbCrLf
            sql += "tratopersonal:'" & dt.Rows(0)("tratopersonal") & "', suprecorrido:'" & dt.Rows(0)("suprecorrido") & "'," & vbCrLf
            sql += "areaoportunidad:'" & dt.Rows(0)("areaoportunidad") & "', plancorrectivo:'" & dt.Rows(0)("plancorrectivo") & "'," & vbCrLf
            sql += "calificasup:'" & dt.Rows(0)("calificasup") & "', ejecutivocgo:'" & dt.Rows(0)("ejecutivocgo") & "'," & vbCrLf
            sql += "reporteasiscgo:'" & dt.Rows(0)("reporteasiscgo") & "', matetiquetados:'" & dt.Rows(0)("matetiquetados") & "'," & vbCrLf
            sql += "matrequerimientos:'" & dt.Rows(0)("matrequerimientos") & "', clientecomentario:'" & dt.Rows(0)("clientecomentario") & "'}" & vbCrLf
        End If
        Return sql
    End Function


    <Web.Services.WebMethod()>
    Public Shared Function fotos(ByVal folio As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select case when b.seccion = 1 then 'Personal' when b.seccion =2 then 'Materiales' when b.seccion= 3 then 'Recorrido' when b.seccion=5 then 'Evaluación' end  as 'td','',(select '../Doctos/supervision/F' + convert(varchar(6), a.fechaini,112) +'/'+ b.archivo as '@src', '100' as '@width', '100' as '@height' for xml path('img'), type) as 'td' " & vbCrLf)
        sqlbr.Append("from tb_supervision a inner join tb_supervision_foto b on a.id_supervision = b.id_supervision " & vbCrLf)
        sqlbr.Append("where a.id_supervision = " & folio & " for xml path('tr'), root('tbody')")
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

        idfolio.Value = Request("folio")
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
