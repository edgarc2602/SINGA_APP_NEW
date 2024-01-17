Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.OleDb
Imports System.Xml
Partial Class App_CGO_CGO_Pro_Asistenciaapp
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function gtxml(ByVal nmfile As String, ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim respuesta As String = ""
        Dim filePath As String = "c:\inetpub\wwwroot\SINGA_APP\Doctos\cgo\"
        'Dim filePath As String = "C:\Doctos\cgo\"
        Dim salida As String = ""
        Dim vfec As Date = Date.Today
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        If nmfile <> "" Then
            Dim fileext As String = IO.Path.GetExtension(filePath & nmfile)
            If LCase(fileext) = ".xlsx" Then
                Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & "Data Source=" & filePath + nmfile & ";Extended Properties=""Excel 12.0;HDR=YES"";Persist Security Info=false")
                cnn.Open()
                Dim sqlExcel As String = "select * From [Hoja1$]"
                Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
                Dim da As New OleDbDataAdapter(myCommand1)
                Dim ds As New DataSet
                da.Fill(ds)
                cnn.Close()
                Dim col As String = ""
                For c As Integer = 0 To ds.Tables(0).Columns.Count - 1
                    col = ds.Tables(0).Columns(c).ToString
                    ds.Tables(0).Columns(c).ColumnMapping = MappingType.Attribute
                Next
                salida = ds.GetXml()
                myConnection.Open()
                Dim mycommand As New SqlCommand("sp_asistenciaapp", myConnection)
                mycommand.CommandType = CommandType.StoredProcedure
                mycommand.Parameters.AddWithValue("@Cabecero", salida)
                mycommand.Parameters.AddWithValue("@usu", usuario)
                mycommand.ExecuteNonQuery()
                myConnection.Close()
            End If
        End If
        Return ""
    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarasistencia(ByVal usuario As Integer) As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/100 + 1 as Filas, COUNT(*) % 100 as Residuos FROM tb_asistenciaapp where aplicado =0 and usuario =" & usuario & "" & vbCrLf)
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
    Public Shared Function asistencia(ByVal pagina As Integer, ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select cliente as 'td','', inmueble as 'td','', empleado as 'td','', nombre as 'td','', fecha as 'td','', entrada as 'td',''," & vbCrLf)
        sqlbr.Append("f.id_periodo as 'td','', forma as 'td','', f.anio as 'td'" & vbCrLf)
        sqlbr.Append("from (" & vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) as rownum, cast(a.id_empleado as int) as empleado, c.nombre as cliente," & vbCrLf)
        sqlbr.Append("b.paterno + ' '+ rtrim(b.materno) + ' ' + b.nombre as nombre, d.nombre as inmueble," & vbCrLf)
        sqlbr.Append("convert(date, a.fecha,103) as fecha, isnull(movimiento,'sin registro') as entrada," & vbCrLf)
        sqlbr.Append("case when b.formapago = 1 then 'Quincenal' else 'Semanal' end as forma" & vbCrLf)
        sqlbr.Append("from tb_asistenciaapp a left outer join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on b.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("where aplicado =0 and a.usuario =" & usuario & "" & vbCrLf)
        sqlbr.Append(") as result " & vbCrLf)
        sqlbr.Append("left outer join tb_periodonomina f on forma = f.descripcion  and finicio <= fecha and ffin >= fecha" & vbCrLf)
        sqlbr.Append("where RowNum BETWEEN (" & pagina & " - 1) * 100 And " & pagina & " * 100 order by cliente, inmueble, empleado for xml path('tr'), root('tbody')")
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
    Public Shared Function guarda(ByVal usuario As Integer) As String

        Dim vfecha As Date = Date.Today

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        myConnection.Open()
        Dim trans As SqlTransaction = myConnection.BeginTransaction
        Try

            Dim mycommand As New SqlCommand("sp_asistenciaappREG", myConnection, trans)
            mycommand.CommandType = CommandType.StoredProcedure
            mycommand.Parameters.AddWithValue("@usuario", usuario)
            mycommand.Parameters.AddWithValue("@fecha", Format(vfecha, "yyyyMMdd"))
            mycommand.ExecuteNonQuery()

            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            Dim aa = ex.Message.ToString().Replace("'", "")
        End Try

        myConnection.Close()
        Return ""

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
