Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports Microsoft.Office.Interop.Excel
Partial Class Ventas_App_Ven_Pro_CargaIgualas
    Inherits System.Web.UI.Page
    'Dim connectionString As String = "Data Source=DESKTOP-291TI12\SQLEXPRESS;Initial Catalog=SINGA;Integrated Security=True"
    'xlsx
    Protected Sub btnUpload_Click(sender As Object, e As EventArgs) Handles btnUpload.Click
        Dim DS As DataSet
        Dim Reng As DataRow
        Dim cmdDS As OleDb.OleDbDataAdapter
        Dim ConOLE As OleDb.OleDbConnection
        Dim r As Integer = 0
        Dim wArchivo As String
        If FileUpload1.HasFile AndAlso Path.GetExtension(FileUpload1.FileName) = ".xlsx" Then
            wArchivo = "C:\Vicente\Tareas\3Facturacion\Documentos\Documentos31_07_2023 02_18_55 p. m..xlsx" '--FileUpload1.FileName
            ConOLE = New OleDb.OleDbConnection("provider=Microsoft.Jet.OLEDB.4.0;" & "data source=" + wArchivo + ";" &
            "Extended Properties='Excel 8.0;HDR=YES;IMEX=1'")

            cmdDS = New OleDb.OleDbDataAdapter("select * from [Documentos$]", ConOLE)

            DS = New DataSet
            cmdDS.Fill(DS)
        End If
    End Sub
End Class
