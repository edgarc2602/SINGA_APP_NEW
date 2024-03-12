Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Xml
Imports Microsoft.VisualBasic
Partial Class Ventas_App_Ven_Rep_PendFacturar
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""
    <Web.Services.WebMethod()>
    Public Shared Function contarcliente(anio As String, mes As String) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/20 + 1 as Filas, COUNT(*) % 20 as Residuos FROM tb_clientependfactdet a inner join tb_cliente b on a.id_cliente = b.id_cliente INNER Join tb_lineanegocio l On a.id_lineanegocio=l.id_lineanegocio where b.id_status = 1 and  montoafacturar != 0 and a.mes = " & mes & " and a.anio = " & anio & " " & vbCrLf)
        'If campo <> "0" Then
        '    sqlbr.Append("and " & campo & " like '%" & dato & "%'" & Microsoft.VisualBasic.vbCrLf)
        'End If
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
    Public Shared Function pendientes(anio As String, mes As String, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select '' as 'td','', nombre as 'td','', descripcion as 'td','', 'Iguala' as 'td','', " & vbCrLf)
        sqlbr.Append("mes as 'td','', anio as 'td','',")
        sqlbr.Append("CAST(CAST(montoafacturar AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','',CAST(CAST(montofacturado AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','',CAST(CAST(montoafacturar - montofacturado AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','' ")
        sqlbr.Append("FROM(select ROW_NUMBER()Over(Order by b.nombre) As RowNum, b.nombre," & vbCrLf)
        sqlbr.Append("c.descripcion, d.descripcion as mes, anio, montoafacturar, montofacturado, montoafacturar - montofacturado as Saldo  " & vbCrLf)
        sqlbr.Append("FROM tb_clientependfactdet a inner join tb_cliente b on a.id_cliente = b.id_cliente  ")
        sqlbr.Append("INNER Join tb_lineanegocio  c on a.id_lineanegocio = c.id_lineanegocio  " & vbCrLf)
        sqlbr.Append("INNER join tb_mes d on a.mes = d.id_mes where b.id_status = 1 and  montoafacturar != 0 and a.mes = " & mes & " and a.anio = " & anio & " " & vbCrLf)
        '7 Nov 2023 que no aparezcan los pagos
        'sqlbr.Append(" and tipo_documento <> 4 " & vbCrLf)
        '7 Nov 2023 quitar los registros que se cancelaron en SINGA
        sqlbr.Append(" and a.id_cliente not in (select id_cliente from tb_clientefactcancela )) AS facturas " & vbCrLf)
        'MAL es con la tabla: tb_clientefactcancela sqlbr.Append("and a.id_cliente not in (select r.id_cliente from tb_cliente_razonsocial r inner join tb_cliente c on r.id_cliente = c.id_cliente  inner join tb_cancelacion ca on r.rfc = ca.rfc_emisor )) AS facturas " & vbCrLf)
        sqlbr.Append("WHERE RowNum BETWEEN (" & pagina & " - 1) * 20 + 1 And " & pagina & " * 20 order by nombre for xml path('tr'), root('tbody') ")

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
    'pendientesglobales
    <Web.Services.WebMethod()>
    Public Shared Function pendientesglobales(anio As String, mes As String, ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        'Select Case'' as 'td','', totmontoafacturar as 'td','', totmontofacturado as 'td','', totsaldo as 'td','' 
        'FROM(select sum(montoafacturar) As totmontoafacturar, sum(montofacturado) As totmontofacturado, sum(montoafacturar - montofacturado) As totsaldo  
        'From tb_clientependfactdet Where mes = 7 And anio = 2023) As facturas 
        ' For xml path('tr'), root('tbody')

        'sqlbr.Append("Select '' as 'td','',CAST(CAST(totmontoafacturar AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','', CAST(CAST(totmontofacturado AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','', CAST(CAST(totsaldo AS DECIMAL(18, 2)) AS VARCHAR(20)) as 'td','' " & vbCrLf)
        sqlbr.Append("Select '' as 'td','',totmontoafacturar as 'td','', totmontofacturado as 'td','', totsaldo as 'td','' " & vbCrLf)
        sqlbr.Append("FROM(select sum(montoafacturar) As totmontoafacturar, sum(montofacturado) As totmontofacturado, sum(montoafacturar - montofacturado) As totsaldo " & vbCrLf)
        sqlbr.Append("FROM tb_clientependfactdet a inner join tb_cliente b on a.id_cliente = b.id_cliente  ")
        sqlbr.Append("Where b.id_status = 1 and  montoafacturar != 0 and mes = " & mes & " And anio = '" & anio & "') As facturas  " & vbCrLf)
        sqlbr.Append("For xml path('tr'), root('tbody') ")

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
    Public Shared Function mes() As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("select id_mes, descripcion from tb_mes order by id_mes")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        sql = "["
        If dt.Rows.Count > 0 Then
            For x As Integer = 0 To dt.Rows.Count - 1
                If x > 0 Then sql += ","
                sql += "{id:" & dt.Rows(x)("id_mes") & "," & vbCrLf
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
            idusuario.Value = Request.Cookies("Usuario").Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
    Private Sub Ventas_App_Ven_Rep_PendFacturar_Init(sender As Object, e As EventArgs) Handles Me.Init
        If Not IsPostBack Then
            ' Verificar si ha pasado el tiempo de espera
            If Session("LastAccessTime") IsNot Nothing Then
                Dim lastAccessTime As DateTime = DirectCast(Session("LastAccessTime"), DateTime)
                Dim currentTime As DateTime = DateTime.Now

                Dim timeoutMinutes As Integer = (currentTime - lastAccessTime).TotalMinutes

                If timeoutMinutes >= Session.Timeout Then
                    ' Si ha pasado el tiempo de espera, cerrar sesión
                    Session.Clear()
                    Response.Redirect("CerrarSesion.aspx") ' Redirige a la página de cierre de sesión
                Else
                    ' Actualizar el tiempo de último acceso
                    Session("LastAccessTime") = DateTime.Now
                End If
            Else
                ' Si es la primera vez que se accede, establecer el tiempo de último acceso
                Session("LastAccessTime") = DateTime.Now
            End If
        End If
    End Sub
End Class
