Imports System.Data
Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail

Partial Class App_Operaciones_Ope_tk_email
    Inherits System.Web.UI.Page
    Private clase As New Conexion
    Private con As String = clase.StrConexion
    Private myconnection As New SqlConnection(con)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Request("id") <> Nothing Then
                'Dim sql As String = "select (select Per_Email from Personal where IdPersonal=1) as de,"
                'sql += " Asunto ='BATIA - Ticket de Servicio No.'+ convert(nvarchar(10), no_ticket) ,"
                'sql += "  ID_Ticket as ID,No_Ticket as Ticket,Tk_Folio as Folio,c.Cte_Dir_Mail para,"
                'sql += " case when Tk_Estatus=0 then 'Alta' when Tk_Estatus=1 then 'Atendido'"
                'sql += " when Tk_Estatus=2 then 'Cerrado' when Tk_Estatus=4 then 'Cancelado'  end Estatus"
                'sql += " ,Tk_FechaAlta as FechaAlta,Tk_HoraAlta as HoraAlta,Tk_FechaTermino as FechaTermino,Tk_HoraTermino as HoraTermino"
                'sql += " ,Tk_MesServicio as Valor,case when ID_Ambito=1 then 'Local' else 'Foraneo' end Ambito"
                'sql += " ,b.Cte_Fis_Nombre_Comercial as Cliente,d.Estado,c.Cte_Dir_Sucursal as Sucursal,e.Tk_Inc_Descripcion as Incidencia,"
                'sql += " f.Tk_CuaOri_Descripcion as CausaOrigen,a.Tk_Descripcion as Descripcion,a.Tk_Accion_Correctiva as AccionCorrectiva,"
                'sql += " a.Tk_Accion_Preventiva as AccionPreventiva,h.Per_Nombre +' '+h.Per_Paterno as PersonalRespuesta,"
                'sql += " a.Tk_Reporta,i.Per_Nombre +' '+i.Per_Paterno as Ejecutivo"
                'sql += "  from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
                'sql += " inner join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
                'sql += " inner join Estados d on d.Id_Estado=c.Cte_Dir_Estado"
                'sql += " inner join Tbl_tk_Incidencia e on e.ID_Incidencia=a.ID_Incidencia"
                'sql += " inner join Tbl_tk_CausaOrigen f on f.ID_CausaOrigen=a.ID_CausaOrigen"
                ''sql += " inner join Tbl_Area_Empresa g on g.IdArea=a.IdArea"
                'sql += " inner join Personal h on h.IdPersonal=a.Tk_ID_Responsable"
                'sql += " inner join Personal i on i.IdPersonal=a.Tk_ID_Ejecutivo"

                Dim sql As String = "select (SELECT STUFF((SELECT '/' + Tbl_Area_Empresa.Ar_Nombre FROM Tbl_Area_Empresa WHERE convert(nvarchar(100),Tbl_Area_Empresa.IdArea) in(select substring from funcionSplit(a.IdArea,',',1000) ) FOR XML PATH (''), TYPE).value('.[1]', 'nvarchar(4000)'), 1, 1, '')) AS Ar_Nombre,"
                'sql += " a.*,j.Per_Nombre + ' ' + j.Per_Paterno + ' ' + j.Per_Materno as ejecutivo,K.Per_Nombre + ' ' + K.Per_Paterno + ' ' + K.Per_Materno as GERENTE,b.Cte_Fis_Razon_Social,Cte_Dir_Sucursal,d.Tk_Inc_Descripcion,e.Tk_CuaOri_Descripcion"
                'sql += ",'Datos Generales del punto de atencion: Calle '+Cte_Dir_Calle+' Colonia '+Cte_Dir_Colonia+' CP '+Cte_Dir_CP+' Del/Mun '+Cte_Dir_Delegacion+' Ciudad '+Cte_Dir_Ciudad as Dir"

                sql += " Asunto ='BATIA - Ticket de Servicio No.'+ convert(nvarchar(10), no_ticket) ,"
                sql += "  ID_Ticket as ID,No_Ticket as Ticket,Tk_Folio as Folio,c.Cte_Dir_Mail para,"
                sql += " case when Tk_Estatus=0 then 'Alta' when Tk_Estatus=1 then 'Atendido'"
                sql += " when Tk_Estatus=2 then 'Cerrado' when Tk_Estatus=4 then 'Cancelado' end Estatus"
                sql += " ,Tk_FechaAlta as FechaAlta,Tk_HoraAlta as HoraAlta,Tk_FechaTermino as FechaTermino,Tk_HoraTermino as HoraTermino"
                sql += " ,Tk_MesServicio as Valor,case when ID_Ambito=1 then 'Local' else 'Foraneo' end Ambito"
                sql += " ,b.Cte_Fis_Nombre_Comercial as Cliente,l.Estado,c.Cte_Dir_Sucursal as Sucursal,d.Tk_Inc_Descripcion as Incidencia,"
                sql += " e.Tk_CuaOri_Descripcion as CausaOrigen,a.Tk_Descripcion as Descripcion,a.Tk_Accion_Correctiva as AccionCorrectiva,"
                sql += " a.Tk_Accion_Preventiva as AccionPreventiva,k.Per_Nombre +' '+k.Per_Paterno as PersonalRespuesta,"
                sql += " a.Tk_Reporta,j.Per_Nombre + ' ' + j.Per_Paterno + ' ' + j.Per_Materno as ejecutivo"

                sql += " from Tbl_Ticket a inner join Tbl_Cliente b on b.ID_Cliente=a.ID_Cliente"
                sql += " left outer join Tbl_Cliente_Dir c on c.ID_Sucursal=a.ID_Sucursal"
                sql += " inner join Tbl_tk_Incidencia d on d.ID_Incidencia=a.ID_Incidencia"
                sql += " inner join Tbl_tk_CausaOrigen e on e.ID_CausaOrigen=a.ID_CausaOrigen"
                sql += " inner join personal j on j.idpersonal =a.Tk_ID_Ejecutivo"
                sql += " inner join personal k on k.idpersonal =a.ID_Gerente"
                sql += "  left outer join Estados l on l.Id_Estado=a.Id_Estado"

                Sql += " where ID_Ticket = " & Request("id") & ""
                Dim myCommand As New SqlDataAdapter(sql, myconnection)
                Dim dt As New DataTable
                myCommand.Fill(dt)
                If dt.Rows.Count > 0 Then

                    lblnreporte.Text = dt.Rows(0).Item("Ticket")
                    lblcliente.Text = dt.Rows(0).Item("Cliente") & " - " & dt.Rows(0).Item("Sucursal")
                    lblreporta.Text = dt.Rows(0).Item("Tk_Reporta")
                    lblejecutivo.Text = dt.Rows(0).Item("Ejecutivo")
                    lblarea.Text = dt.Rows(0).Item("Ar_Nombre")
                    lblresparea.Text = dt.Rows(0).Item("PersonalRespuesta")
                    lblfecenvio.Text = Date.Today
                    lblfecalta.Text = dt.Rows(0).Item("FechaAlta")
                    lblreporte.Text = dt.Rows(0).Item("Descripcion")
                    lblac.Text = dt.Rows(0).Item("AccionCorrectiva")
                    lblap.Text = dt.Rows(0).Item("AccionPreventiva")
                    lblestatus.text = dt.Rows(0).Item("Estatus")


                    txtmatfechaalta.Text = dt.Rows(0).Item("FechaAlta")
                    txtmathoraalta.Text = dt.Rows(0).Item("HoraAlta").ToString
                    txtmatid.Text = dt.Rows(0).Item("Ticket")
                    txtmatfolio.Text = dt.Rows(0).Item("Folio")
                    lblidticket.Text = dt.Rows(0).Item("ID")
                    'txtde.Text = dt.Rows(0).Item("de")
                    'txtpara.Text = dt.Rows(0).Item("para")
                    txtasunto.Text = dt.Rows(0).Item("Asunto")
                    'txtmensaje.Text = dt.Rows(0).Item("Comentario")
                    Dim mensaje As String = ""
                    mensaje = "Buen Dia estimado Cliente ." & Chr(13)
                    mensaje += "" & Chr(13)
                    mensaje += " Le enviamos el Ticket, para su revision." & Chr(13)
                    mensaje += "" & Chr(13)
                    mensaje += " Nos despedimos y quedamos a sus ordenes para cualquier duda o aclaración." & Chr(13)
                    mensaje += "" & Chr(13)
                    mensaje += " Atentamente." & Chr(13)
                    mensaje += "" & Chr(13)
                    mensaje += "" & Chr(13)
                    mensaje += " Call Center" & Chr(13)
                    mensaje += " Grupo Batia S.A. de C.V." & Chr(13)
                    mensaje += " cuenta@batia.com.mx" & Chr(13)
                    mensaje += " Tel. ## ## ## ## Ext. ### " & Chr(13)
                    txtmensaje.Text = mensaje

                End If
            End If

        End If
    End Sub
    Protected Sub ImageButton2_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton2.Click
        Dim cc As String = txtpara.Text & ""
        Dim mail As New MailMessage
        mail.From = New MailAddress("" & txtde.Text & "")
        mail.Bcc.Add(txtde.Text)
        Dim v_par As Array
        v_par = (cc).Split(";")
        Dim i As Integer = 0
        For i = 0 To v_par.Length - 1
            mail.To.Add("" & v_par(i) & "")
        Next
        mail.Subject = "" & txtasunto.Text & ""


        'Dim FilePath As String = ""
        ''el archivo se adjunta indicándole la ruta  
        'For i = 0 To ListBox1.Items.Count - 1
        '    FilePath = ListBox1.Items.Item(i).Value
        '    mail.Attachments.Add(New Attachment(FilePath))
        'Next

        Dim sb As New StringBuilder()
        sb.Append("<html>")




        sb.Append("<table width=""835"" height=""79"" >")
        sb.Append("<tr>")
        sb.Append("<td width=""835""><form id=""form1"" name=""form1"" method=""post"" action="""">")
        sb.Append("<label>")
        sb.Append("<input type=""image"" name=""logo"" id=""logo"" src=""cid:imagen001"" />")
        sb.Append("</label>")
        sb.Append("</form></td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td width=""830"" >")
        sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
        sb.Append("<tr><td align=""right"" colspan=""2"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 12pt; font-style: italic; color: #092435"">Convertimos sus preocupaciones en satisfacciones</td> </tr>")
        sb.Append("<tr><td> </td> </tr>")
        sb.Append("<tr><td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 10pt; color: #FFFFFF"">Datos Generales:</td> </tr>")
        sb.Append("</table>")

        sb.Append("<table width=""835"" height=""79"" >")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245""> No. de Reporte:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""3"" width=""320"">" & lblnreporte.Text & "</td>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Fecha de Envio:</td>")
        sb.Append("<td align=""left"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" width=""183"" colspan=""2""> " & lblfecenvio.Text & "</td></tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245""> Estatus:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""3"" width=""320"">" & lblestatus.Text & "</td>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Fecha de Reporte:</td>")
        sb.Append("<td align=""left"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""2"">" & lblfecalta.Text & "</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Cliente:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""6"">" & lblcliente.Text & "</td>")
        sb.Append(" </tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Reporta:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""2"" width=""648"">" & lblreporta.Text & "</td>")
        'sb.Append("</tr>")
        'sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Ejecutivo que Atiende:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""3"" width=""648"">" & lblejecutivo.Text & "</td>")
        sb.Append(" </tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Area de Ejecucion:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""2"" width=""648"">" & lblarea.Text & "</td>")
        'sb.Append("</tr>")
        'sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" width=""245"">Gerente:</td>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""3"" width=""648"">" & lblresparea.Text & "</td>")
        sb.Append("</tr>")
        sb.Append("</table>")

        sb.Append("<table border=""0"" cellpadding=""0"" cellspacing=""0"" style=""border-collapse:collapse;width:631pt"" width=""841"">")
        sb.Append("<colgroup>")
        sb.Append("<col style=""mso-width-source:userset;mso-width-alt:7058;width:145pt"" width=""245"" />")
        sb.Append("<col span=""4"" style=""width:60pt"" width=""80"" />")
        sb.Append("<col style=""mso-width-source:userset;mso-width-alt:5302;width:109pt"" width=""145"" />")
        sb.Append("<col style=""mso-width-source:userset;mso-width-alt:6692;width:137pt"" width=""183"" />")
        sb.Append("</colgroup>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" colspan=""7"" width=""841"">Reporte</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""7"" height=""45"">" & lblreporte.Text & "</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" colspan=""7"">Accion Correctiva</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""7"" height=""45"">" & lblac.Text & "</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"" colspan=""7"" width=""841"">Accion Preventiva</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"" colspan=""7"" height=""45"">" & lblap.Text & "</td>")
        sb.Append("</tr>")
        sb.Append("</table>")



        'sb.Append("<tr>")
        'sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">Fecha Envio:</td>")
        'sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & Format(Date.Today, "dd/MM/yyyy") & "</td>")
        'sb.Append("</tr>")
        'sb.Append("<tr>")
        'sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">Cliente:</td>")
        ''sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & Label1.Text & "</td>")
        'sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">Cliente </td>")
        'sb.Append("</tr>")
        'sb.Append("<tr>")
        'sb.Append("<td colspan=""2"" bgcolor=""#092435"" style=""font-family: Tahoma; font-size: 9pt; color: #FFFFFF"">No. Factura:</td>")
        ''sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">" & TextBox8.Text & "</td>")
        'sb.Append("<td colspan=""3"" bgcolor=""#E9E9E9"" style=""font-family: Tahoma; font-size: 9pt"">factura</td>")
        'sb.Append("</tr>")
        'sb.Append("</table>")

        sb.Append("</table>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<input type=""image"" name=""logo1"" id=""logo2"" src=""cid:imagen002"" height=""56"" width=""836"" />")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("<table cellspacing=""0"" cellpadding=""0"" width=""835"" height=""25"">")
        sb.Append("<td height=""8"">")

        Dim mensaje As String = ""
        mensaje = Replace(txtmensaje.Text, Chr(13), "<br />")
        sb.Append("<p><br />" & mensaje & "</p>")
        sb.Append("</table>")

        sb.Append("</html>")

        mail.Body = sb.ToString()

        Dim HTMLConImagenes As AlternateView
        HTMLConImagenes = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen As LinkedResource
        imagen = New LinkedResource((Server.MapPath("..\Content\img\Correo\headerbk.png")))
        imagen.ContentId = "imagen001"
        HTMLConImagenes.LinkedResources.Add(imagen)
        mail.AlternateViews.Add(HTMLConImagenes)

        Dim HTMLConImagenes1 As AlternateView
        HTMLConImagenes1 = AlternateView.CreateAlternateViewFromString(sb.ToString(), Nothing, "text/html")
        Dim imagen1 As LinkedResource
        imagen1 = New LinkedResource((Server.MapPath("..\Content\img\Correo\footerbk.png")))
        imagen1.ContentId = "imagen002"
        HTMLConImagenes1.LinkedResources.Add(imagen1)
        mail.AlternateViews.Add(HTMLConImagenes1)

        'Dim pass As String = "J4v13r#H3rn4nd35"
        Dim pass As String = "barbosa1"
        Dim mailClient As New SmtpClient()
        Dim basicAuthenticationInfo As New NetworkCredential("lhernandez@interlabel.com.mx", "" & pass & "")
        mailClient.Host = "smtp.alestraune.net.mx"
        mailClient.UseDefaultCredentials = True
        mailClient.Credentials = basicAuthenticationInfo
        mailClient.Port = 587
        'Dim basicAuthenticationInfo As New NetworkCredential("javier.hernandez@isatel.mx", "" & pass & "")
        'mailClient.Host = "secure.emailsrvr.com"
        'mailClient.UseDefaultCredentials = True
        'mailClient.Credentials = basicAuthenticationInfo
        'mailClient.Port = 465

        Try
            mailClient.Send(mail)
            Response.Write("<script>alert('Mensaje enviado satisfactoriamente');</script>")
            'Response.Write("<script>javascript:self.close()</script>")
        Catch ex As Exception
            Response.Write("<script>alert('ERROR: " & ex.Message & "');</script>")
        End Try

    End Sub
End Class
