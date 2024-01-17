Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class cargamenu

    'Public Sub New()

    'End Sub
    Public Function minombre(ByVal user As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        Dim sql As String = ""
        sqlbr.Append("select per_nombre + ' ' + per_paterno + ' ' + per_materno as nombre from personal where idpersonal = " & user & "")
        Dim da As New SqlDataAdapter(sqlbr.ToString, myConnection)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count > 0 Then
            sql += dt.Rows(0)("nombre")
        End If
        Return sql

    End Function
    Public Function mimenu(ByVal user As Integer) As String
        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        Dim sqlbr As New StringBuilder
        sqlbr.Append("with grupos " & vbCrLf)
        sqlbr.Append("  as (" & vbCrLf)
        sqlbr.Append("		select IdProceso,IdArea,sub,Ar_Path " & vbCrLf)
        sqlbr.Append("        from (" & vbCrLf)
        sqlbr.Append("				select IdProceso,IdArea,case when IdProceso=1 then 'Catalogos' when IdProceso=2 then 'Procesos' " & vbCrLf)
        sqlbr.Append("                when IdProceso=3 then 'Consultas' when IdProceso=4 then 'Reportes' else Ar_Label end sub," & vbCrLf)
        sqlbr.Append("				case when IdProceso in(1,2,3,4) then '#' else Ar_Path end Ar_Path" & vbCrLf)
        sqlbr.Append("               from tbl_UsuarioGrupos a inner join Tbl_Per_Grupos_Formas b on b.IdGrupos=a.IdGrupos" & vbCrLf)
        sqlbr.Append("				inner join Tbl_Formularios c on c.IdForma=b.idformulario where a.idpersonal=" & user & ") as tabla group by IdProceso,IdArea,sub,Ar_Path" & vbCrLf)
        sqlbr.Append("			)" & vbCrLf)
        sqlbr.Append("			select 'sidebar-menu' as '@class', (select 'header' as '@class', 'NAVEGACION' as 'text()' for xml path('li'), type)," & vbCrLf)
        sqlbr.Append("		(" & vbCrLf)
        sqlbr.Append("			select 'treeview' as '@class', e.ar_icon as 'a/i/@class',' ' as 'a/i/text()', e.ar_nombre as 'a/span','fa fa-angle-left pull-right' as 'a/i/@class',' ' as 'a/i/text()'," & vbCrLf)
        sqlbr.Append("			(" & vbCrLf)
        sqlbr.Append("				select 'treeview-menu' as '@class', " & vbCrLf)
        sqlbr.Append("				(" & vbCrLf)
        sqlbr.Append("					select Ar_Path as 'a/@href', 'fa fa-chevron-circle-down' as 'a/i/@class', ' ' as 'a/i/text()', secciones.sub as 'a/text()'," & vbCrLf)
        sqlbr.Append("					(" & vbCrLf)
        sqlbr.Append("						select 'treeview-menu' as '@class'," & vbCrLf)
        sqlbr.Append("						(" & vbCrLf)
        sqlbr.Append("							select  c2.Ar_Path as 'a/@href', 'fa fa-arrow-circle-right' as 'a/i/@class', ' ' as 'a/i/text()', c2.Ar_Label as 'a/text()'" & vbCrLf)
        sqlbr.Append("                           from tbl_UsuarioGrupos a2 inner join  Tbl_Per_Grupos_Formas b2 on a2.IdGrupos = b2.IdGrupos" & vbCrLf)
        sqlbr.Append("							inner join Tbl_Formularios c2 on b2.idformulario = c2.IdForma" & vbCrLf)
        sqlbr.Append("                          inner join Tbl_Area_Menu d2 on c2.IdArea = d2.IdArea " & vbCrLf)
        sqlbr.Append("							where a2.idpersonal = " & user & " and c2.IdProceso <> 0 and  d2.IdArea= e.IdArea and c2.IdProceso = secciones.IdProceso" & vbCrLf)
        sqlbr.Append("                          order by c2.Ar_Label for xml path('li'),type" & vbCrLf)
        sqlbr.Append("						)" & vbCrLf)
        sqlbr.Append("                       for xml path('ul'),type" & vbCrLf)
        sqlbr.Append("					)" & vbCrLf)
        sqlbr.Append("                    from grupos as secciones where  secciones.IdArea = e.idarea" & vbCrLf)
        sqlbr.Append("					for xml path('li'), type" & vbCrLf)
        sqlbr.Append("				)" & vbCrLf)
        sqlbr.Append("				for xml path('ul'), type" & vbCrLf)
        sqlbr.Append("			)" & vbCrLf)
        sqlbr.Append("from Tbl_Area_Menu as e where e.Ar_Estatus = 0" & vbCrLf)
        sqlbr.Append("order by e.Ar_Posicion for xml path('li'), type)" & vbCrLf)
        sqlbr.Append("for xml path('ul')")

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
End Class
