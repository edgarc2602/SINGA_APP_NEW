Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI.WebControls.DataGridItemEventArgs
Imports System.Web.SessionState.HttpSessionStateContainer
Imports System.Web.SessionState.HttpSessionState


<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
<System.Web.Script.Services.ScriptService()> _
Public Class Catalogo
    Inherits System.Web.Services.WebService
    Private clase As New Conexion
    Private con As String = clase.StrConexion
    Private myconnection As New SqlConnection(con)
    Public campo As String
    <WebMethod(enableSession:=True)> _
    Public Function qrycliente(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "select Cte_Fis_Razon_Social from Tbl_Cliente "
        sql += " where Cte_Fis_Razon_Social like '%" & prefixText & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Cte_Fis_Razon_Social")
        Next
        Return items
    End Function

    <WebMethod(enableSession:=True)> _
    Public Function qryprospecto(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "select Pros_Razon_Social from  Tbl_Prospecto"
        sql += " where pros_Estatus=1 and Pros_Razon_Social like '%" & prefixText & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pros_Razon_Social")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qrycotizacion(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "select ID_Cotizacion,'COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version) as Cot from tbl_Cotizacion where cot_estatus=0"
        sql += "and ('COT-'+'0000'+convert(nvarchar(12),Cot_Folio)+'-V-'+ convert(nvarchar(2),Cot_Version)) like '%" & prefixText & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Cot")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qryuniforme(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select Pza_Clave,Pza_Clave+'|'+Pza_DescPieza+'|'+ convert(nvarchar(30),Pza_PrecioAutorizado) as Pza_DescPieza from Tbl_Pieza "
        sql += " where Pza_Status=0 and Pza_IdFamilia like 'uni' and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pza_DescPieza")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qryequipo(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select Pza_Clave,Pza_Clave+'|'+Pza_DescPieza+'|'+ convert(nvarchar(30),Pza_PrecioAutorizado) as Pza_DescPieza from Tbl_Pieza "
        sql += " where Pza_Status=0  and Pza_IdFamilia like 'eqp' and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pza_DescPieza")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qryHerramienta(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select Pza_Clave,Pza_Clave+'|'+Pza_DescPieza+'|'+ convert(nvarchar(30),Pza_PrecioAutorizado) as Pza_DescPieza from Tbl_Pieza "
        sql += " where Pza_Status=0 and Pza_IdFamilia like 'her' and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pza_DescPieza")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qryMateriales(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select Pza_Clave,Pza_Clave+'|'+Pza_DescPieza+'|'+ convert(nvarchar(30),Pza_PrecioAutorizado)+'|'+ convert(nvarchar(4),Pza_IdUnidad)  as Pza_DescPieza from Tbl_Pieza "
        sql += " where Pza_Status=0 and Pza_IdFamilia not in('HER','EQP','UNI') and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pza_DescPieza")
        Next
        Return items
    End Function
    <WebMethod(enableSession:=True)> _
    Public Function qryMaterialessur(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select Pza_Clave,Pza_Clave+'|'+Pza_DescPieza+'|'+ convert(nvarchar(30),Pza_PrecioAutorizado)+'|'+ convert(nvarchar(4),Pza_IdUnidad)+'|'+ convert(nvarchar(6),IdPieza) as Pza_DescPieza from Tbl_Pieza "
        sql += " where Pza_Status=0 and Pza_IdFamilia not in('HER','EQP','UNI') and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("Pza_DescPieza")
        Next
        Return items
    End Function

    <WebMethod(enableSession:=True)> _
    Public Function qrySAdi(ByVal prefixText As String, ByVal count As Integer) As String()
        Dim sql As String = ""
        sql += "Select SAdi_Clave,SAdi_Clave+'|'+SAdi_DescPieza+'|'+ convert(nvarchar(30),SAdi_PrecioAutorizado) as SAdi_DescPieza from Tbl_ServiciosAdicionales"
        sql += " where SAdi_Status=0  and SAdi_Clave+SAdi_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items(dt.Rows.Count) As String
        For i As Integer = 0 To dt.Rows.Count - 1
            items(i) = dt.Rows(i)("SAdi_DescPieza")
        Next
        Return items
    End Function
    '  <WebMethod(enableSession:=True)> _
    'Public Function qrypuntoatencion(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As String()
    <System.Web.Script.Services.ScriptMethod(), _
    System.Web.Services.WebMethod()>
    Public Function qrypuntoatencion(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)
        Dim sql As String = ""
        sql += "SELECT convert(nvarchar(10),ID_Sucursal) +' | '+ Cte_Dir_Sucursal as puntoatencion "
        sql += " FROM Tbl_Cliente_Dir a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente "
        sql += " where  Cte_Dir_Estatus=1 and Cte_Dir_Sucursal like '%" & prefixText & "%'"
        If contextKey <> "" Then sql += " and Cte_Fis_Razon_Social like '%" & contextKey & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        'Dim items(dt.Rows.Count) As String
        Dim items As List(Of String) = New List(Of String)
        For i As Integer = 0 To dt.Rows.Count - 1
            'items(i) = dt.Rows(i)("puntoatencion")
            items.Add(dt.Rows(i).Item("puntoatencion").ToString)
        Next
        Return items
    End Function
    <System.Web.Script.Services.ScriptMethod(), _
    System.Web.Services.WebMethod()>
    Public Function qryincidencia(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim sql As String = ""
        sql += "SELECT     CONVERT(nvarchar(10), ID_Incidencia) + ' | ' + Tk_Inc_Descripcion + '|' +   CONVERT(nvarchar(10),id_area) AS incidencia FROM Tbl_tk_Incidencia  "
        sql += " where Tk_Inc_Descripcion like '%" & prefixText & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        'Dim items(dt.Rows.Count) As String
        Dim items As List(Of String) = New List(Of String)
        For i As Integer = 0 To dt.Rows.Count - 1
            'items(i) = dt.Rows(i)("puntoatencion")
            items.Add(dt.Rows(i).Item("incidencia").ToString)
        Next
        Return items
    End Function
    <System.Web.Script.Services.ScriptMethod(), _
    System.Web.Services.WebMethod()>
    Public Function qrycausaori(ByVal prefixText As String, ByVal count As Integer) As List(Of String)
        Dim sql As String = ""
        sql += "SELECT     CONVERT(nvarchar(10),  ID_CausaOrigen) + ' | ' + Tk_CuaOri_Descripcion AS cauori FROM Tbl_tk_CausaOrigen  "
        sql += " where Tk_CuaOri_Descripcion like '%" & prefixText & "%'"
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        'Dim items(dt.Rows.Count) As String
        Dim items As List(Of String) = New List(Of String)
        For i As Integer = 0 To dt.Rows.Count - 1
            'items(i) = dt.Rows(i)("puntoatencion")
            items.Add(dt.Rows(i).Item("cauori").ToString)
        Next
        Return items
    End Function
    <System.Web.Script.Services.ScriptMethod(), _
    System.Web.Services.WebMethod()>
    Public Function qryMaterialedo(ByVal prefixText As String, ByVal contextKey As String) As List(Of String)
        Dim sql As String = ""
        sql += "Select Pza_Clave+'|UNIDAD - '+Pza_IdUnidad+' - '+Pza_DescPieza +'|'+ convert(nvarchar(30),b.Pza_PrecioAutorizado) as Pza_DescPieza "
        sql += " from Tbl_Pieza a inner join Tbl_Pieza_Precios b on b.IdPieza=a.IdPieza and Id_estado=" & contextKey & ""
        sql += " where Pza_Status=0 and Pza_IdFamilia not in('HER','EQP','UNI') and Pza_Clave+ Pza_DescPieza like '%" & prefixText & "%' "
        Dim ds As New SqlDataAdapter(sql, con)
        Dim dt As New DataTable
        ds.Fill(dt)
        Dim items As List(Of String) = New List(Of String)
        For i As Integer = 0 To dt.Rows.Count - 1
            items.Add(dt.Rows(i).Item("Pza_DescPieza").ToString)
        Next
        Return items
    End Function

End Class
