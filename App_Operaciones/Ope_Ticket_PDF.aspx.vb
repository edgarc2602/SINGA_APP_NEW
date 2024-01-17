
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Operaciones_Ope_Ticket_PDF
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private ConnectionString As String = clase.StrConexion()
    Private myConnection As New SqlConnection(ConnectionString)
    Public txtFolio As String
    Public txtFec As String
    Public txtcliente As String
    Public txtejecutivo As String
    Public txtcentro As String
    Public txtaeje As String
    Public txtgerente As String
    Public txtreporte As String
    Public txtacorrectiva As String
    Public txtapreventiva As String
    Public txtbitacora As String

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Request("id") <> Nothing Then
                llenaticket(Request("id"))
            End If

        End If
    End Sub


    Protected Sub llenaticket(ByVal id As Integer)
        Dim sql As String = "select (SELECT STUFF((SELECT '/' + Tbl_Area_Empresa.Ar_Nombre FROM Tbl_Area_Empresa WHERE convert(nvarchar(100),Tbl_Area_Empresa.IdArea) in(select substring from funcionSplit(a.IdArea,',',1000) ) FOR XML PATH (''), TYPE).value('.[1]', 'nvarchar(4000)'), 1, 1, '')) AS Ar_Nombre,"
        sql += " a.*,j.Per_Nombre + ' ' + j.Per_Paterno + ' ' + j.Per_Materno as ejecutivo,K.Per_Nombre + ' ' + K.Per_Paterno + ' ' + K.Per_Materno as GERENTE,b.Cte_Fis_Razon_Social,Cte_Dir_Sucursal,d.Tk_Inc_Descripcion,e.Tk_CuaOri_Descripcion"
        sql += ",'Datos Generales del punto de atencion: Calle '+Cte_Dir_Calle+' Colonia '+Cte_Dir_Colonia+' CP '+Cte_Dir_CP+' Del/Mun '+Cte_Dir_Delegacion+' Ciudad '+Cte_Dir_Ciudad as Dir"
        sql += " from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
        sql += " left outer join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
        sql += " inner join Tbl_tk_Incidencia d on d.ID_Incidencia=a.ID_Incidencia"
        sql += " inner join Tbl_tk_CausaOrigen e on e.ID_CausaOrigen=a.ID_CausaOrigen"
        sql += " inner join personal j on j.idpersonal =a.Tk_ID_Ejecutivo"
        sql += " inner join personal k on k.idpersonal =a.ID_Gerente"

        sql += " where ID_Ticket = " & id & ""
        Dim myCommand As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataTable
        myCommand.Fill(dt)
        If dt.Rows.Count > 0 Then
            txtFolio = dt.Rows(0).Item("Tk_Folio")
            txtcliente = dt.Rows(0).Item("Cte_Fis_Razon_Social")
            If dt.Rows(0).Item("ID_Sucursal") = 0 Then txtcentro = dt.Rows(0).Item("sucursal") Else txtcentro = dt.Rows(0).Item("Cte_Dir_Sucursal")
            txtFec = dt.Rows(0).Item("Tk_FechaAlta")
            txtejecutivo = dt.Rows(0).Item("ejecutivo")
            txtaeje = dt.Rows(0).Item("Ar_Nombre")
            txtgerente = dt.Rows(0).Item("GERENTE")

            txtreporte = dt.Rows(0).Item("Tk_Descripcion")
            txtacorrectiva = dt.Rows(0).Item("Tk_Accion_Correctiva")
            txtapreventiva = dt.Rows(0).Item("Tk_Accion_Preventiva")
        End If
        sql = "select a.ID_Ticket,tk_bit_fecha,a.Tk_Bit_Observacion,Per_Nombre+' '+Per_Paterno as Empleado"
        sql += " from Tbl_tk_Bitacora a inner join Personal b on a.IdUsuario=b.IdPersonal"
        sql += " where ID_Ticket =" & id & " and a.Tk_Bit_Observacion not in ('Modificacion de Ticket','Alta de Ticket')"
        myCommand = New SqlDataAdapter(sql, myConnection)
        dt = New DataTable
        myCommand.Fill(dt)
        For i As Integer = 0 To dt.Rows.Count - 1
            txtbitacora += " " & dt.Rows(0).Item("Tk_Bit_Observacion") & " "
        Next
    End Sub
End Class
