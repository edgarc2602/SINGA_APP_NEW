Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.OleDb
Imports System.Xml
Partial Class App_CGO_CGO_Pro_cargaasistencia
    Inherits System.Web.UI.Page

    Public listamenu As String = ""
    Public minombre As String = ""

    <Web.Services.WebMethod()>
    Public Shared Function gtxml(ByVal nmfile As String, ByVal mes As Integer, ByVal anio As Integer, ByVal usuario As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim respuesta As String = ""
        Dim filePath As String = "c:\inetpub\wwwroot\SINGA_APP\Doctos\cgo\"
        'Dim filePath As String = "C:\Doctos\cgo\"
        Dim salida As String = ""
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        If nmfile <> "" Then
            Dim fileext As String = IO.Path.GetExtension(filePath & nmfile)
            If LCase(fileext) = ".xls" Then
                Dim cnn As New OleDbConnection("provider=Microsoft.ACE.OLEDB.12.0;" & "Data Source=" & filePath + nmfile & ";Extended Properties=""Excel 12.0;HDR=YES"";Persist Security Info=false")
                cnn.Open()
                Dim sqlExcel As String = "select * From [Reporte de Asistencia$]"
                Dim myCommand1 As New OleDbCommand(sqlExcel, cnn)
                Dim da As New OleDbDataAdapter(myCommand1)
                Dim ds As New DataTable
                da.Fill(ds)

                Dim vmes As String = mes.ToString
                If Len(vmes) = 1 Then
                    vmes = "0" + vmes
                End If
                Dim vanio As Integer = anio
                Dim videmp As Integer = 0
                Dim vnombre As String = ""
                Dim vregistro As String = ""
                Dim vfecha As String = ""

                Dim dt1 As New DataTable
                dt1.TableName = "registro"
                Dim dt2 As New DataTable
                dt2.TableName = "dias"

                Dim ds1 As New DataSet
                ds1.DataSetName = "asistencia"

                ds1.Tables.Add(dt1)
                ds1.Tables.Add(dt2)
                ds1.Tables(0).Columns.Add("id_empleado")
                ds1.Tables(0).Columns.Add("fecha")
                ds1.Tables(0).Columns.Add("registro")
                ds1.Tables(0).Columns.Add("nombre")
                ds1.Tables(0).Columns.Add("usuario")
                ds1.Tables(1).Columns.Add("dia")
                For c As Integer = 0 To ds.Columns.Count - 1
                    If ds.Rows(2)(c).ToString <> "" Then
                        ds1.Tables(1).Rows.Add(ds.Rows(2)(c).ToString)
                    End If
                Next
                For c As Integer = 3 To ds.Rows.Count - 1
                    If ds.Rows(c)(0).ToString = "ID:" Then
                        videmp = Val(ds.Rows(c)(2).ToString)
                        vnombre = ds.Rows(c)(10).ToString
                        For j As Integer = 0 To ds1.Tables(1).Rows.Count - 1
                            If ds.Rows(c + 1)(j).ToString <> "" Then
                                Dim vdia As String = ""
                                If Len(ds1.Tables(1).Rows(j)(0).ToString) = 1 Then
                                    vdia = "0" + ds1.Tables(1).Rows(j)(0).ToString
                                Else
                                    vdia = ds1.Tables(1).Rows(j)(0).ToString
                                End If
                                vfecha = vanio.ToString + vmes.ToString + vdia
                                ds1.Tables(0).Rows.Add(videmp, vfecha, ds.Rows(c + 1)(j).ToString, vnombre, usuario)
                            End If

                        Next
                    End If
                Next
                cnn.Close()
                Dim col As String = ""
                For c As Integer = 0 To ds1.Tables(0).Columns.Count - 1
                    col = ds1.Tables(0).Columns(c).ToString
                    ds1.Tables(0).Columns(c).ColumnMapping = MappingType.Attribute
                Next
                salida = ds1.GetXml()
                myConnection.Open()
                Dim mycommand As New SqlCommand("sp_asistenciachecador", myConnection)
                mycommand.CommandType = CommandType.StoredProcedure
                mycommand.Parameters.AddWithValue("@Cabecero", salida)
                mycommand.ExecuteNonQuery()
                myConnection.Close()
            End If
        End If

        Return ""

    End Function

    <Web.Services.WebMethod()>
    Public Shared Function contarasistencia() As String
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""

        sqlbr.Append("SELECT COUNT(*)/100 + 1 as Filas, COUNT(*) % 100 as Residuos FROM tb_asistenciachecador where aplicado =0" & vbCrLf)
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
    Public Shared Function asistencia(ByVal pagina As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder

        sqlbr.Append("select cliente as 'td','', inmueble as 'td','', empleado as 'td','', nombre as 'td','', fecha as 'td','', entrada as 'td',''," & vbCrLf)
        sqlbr.Append("f.id_periodo as 'td','', forma as 'td','', f.anio as 'td'" & vbCrLf)
        sqlbr.Append("from ("& vbCrLf)
        sqlbr.Append("select ROW_NUMBER() over (order by c.nombre, d.nombre, b.paterno, b.materno, b.nombre) as rownum, cast(a.id_empleado as int) as empleado, c.nombre as cliente," & vbCrLf)
        sqlbr.Append("b.paterno + ' '+ rtrim(b.materno) + ' ' + b.nombre as nombre, d.nombre as inmueble," & vbCrLf)
        sqlbr.Append("convert(date, fecha) as fecha, isnull(registro,'sin registro') as entrada," & vbCrLf)
        sqlbr.Append("case when b.formapago = 1 then 'Quincenal' else 'Semanal' end as forma" & vbCrLf)
        sqlbr.Append("from tb_asistenciachecador a left outer join tb_empleado b on a.id_empleado = b.id_empleado " & vbCrLf)
        sqlbr.Append("left outer join tb_cliente c on b.id_cliente = c.id_cliente" & vbCrLf)
        sqlbr.Append("left outer join tb_cliente_inmueble d on b.id_inmueble = d.id_inmueble " & vbCrLf)
        sqlbr.Append("where aplicado =0 and registro is not null" & vbCrLf)
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

            Dim mycommand As New SqlCommand("sp_asistenciachecadorREG", myConnection, trans)
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
                sql += "{id:'" & dt.Rows(x)("id_mes") & "'," & vbCrLf
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
            idusuario.Value = usuario.Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub
End Class
