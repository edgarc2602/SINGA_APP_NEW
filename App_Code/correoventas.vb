﻿Imports System.Data
Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail
Imports Microsoft.VisualBasic
Public Class correoventas
    Public Function bajacliente(ByVal fecha As String, ByVal titulo As String, ByVal cliente As String, ByVal fbaja As String, ByVal motivo As String, ByVal ejecutivo As Integer, ByVal gerente As Integer) As String
        Dim sqlbr As New StringBuilder

        Dim myConnection As New SqlConnection((New Conexion).StrConexion)
        'Dim destinos = "ricardob@grupobatia.com.mx;"
        Dim destinos = "ricardob@grupobatia.com.mx;jonathano@grupobatia.com.mx;nomina2@grupobatia.com.mx;evairt@grupobatia.com.mx;cesarc@grupobatia.com.mx;cesarf@grupobatia.com.mx;alejandraa@grupobatia.com.mx;luisr@grupobatia.com.mx;miguelt@grupobatia.com.mx;christianr@grupobatia.com.mx;"
        Dim sql As String = ""
        sql = "select per_email as mail1 from personal where id_empleado  = " & ejecutivo & ";"
        sql += "select Per_Email as mail2 from Personal where id_empleado = " & gerente & ""
        Dim da As New SqlDataAdapter(sql, myConnection)
        Dim dt As New DataSet
        da.Fill(dt)
        If dt.Tables(0).Rows.Count > 0 Then
            destinos += dt.Tables(0).Rows(0)("mail1") + ";"
            destinos += dt.Tables(1).Rows(0)("mail2")
        End If

        sqlbr.Append("<html style=""width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<head>" & vbCrLf)
        sqlbr.Append("<meta charset=""UTF-8"">" & vbCrLf)
        sqlbr.Append("<meta content=""width=device-width, initial-scale=1"" name=""viewport"">" & vbCrLf)
        sqlbr.Append("<meta name=""x-apple-disable-message-reformatting"">" & vbCrLf)
        sqlbr.Append("<meta http-equiv=""X-UA-Compatible"" content=""IE=edge"">" & vbCrLf)
        sqlbr.Append("<meta content=""telephone=no"" name=""format-detection"">" & vbCrLf)
        sqlbr.Append("<title>Nuevo correo electrónico 2</title>" & vbCrLf)
        sqlbr.Append("<!--[if (mso 16)]>" & vbCrLf)
        sqlbr.Append("<style type=""text/css"">" & vbCrLf)
        sqlbr.Append("a {text-decoration: none;}" & vbCrLf)
        sqlbr.Append("</style>" & vbCrLf)
        sqlbr.Append("<![endif]-->" & vbCrLf)
        sqlbr.Append("<!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]-->" & vbCrLf)
        sqlbr.Append("<!--[if !mso]><!-- -->" & vbCrLf)
        sqlbr.Append("<link href=""https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400i,700,700i"" rel=""stylesheet"">" & vbCrLf)
        sqlbr.Append("<!--<![endif]-->" & vbCrLf)
        sqlbr.Append("<style type=""text/css"">" & vbCrLf)
        sqlbr.Append("@media only screen and (max-width:600px) {p, ul li, ol li, a { font-size:16px!important; line-height:150%!important } h1 { font-size:30px!important; text-align:center; line-height:120%!important } h2 { font-size:26px!important; text-align:center; line-hei" & vbCrLf)
        sqlbr.Append("#outlook a {" & vbCrLf)
        sqlbr.Append("	padding: 0;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append(".ExternalClass {" & vbCrLf)
        sqlbr.Append("	width: 100%;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append(".ExternalClass," & vbCrLf)
        sqlbr.Append(".ExternalClass p," & vbCrLf)
        sqlbr.Append(".ExternalClass span," & vbCrLf)
        sqlbr.Append(".ExternalClass font," & vbCrLf)
        sqlbr.Append(".ExternalClass td," & vbCrLf)
        sqlbr.Append(".ExternalClass div {" & vbCrLf)
        sqlbr.Append("	line-height:  100%;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append(".es-button {" & vbCrLf)
        sqlbr.Append("	mso-style-priority:100!important;" & vbCrLf)
        sqlbr.Append("	text-decoration: none!important;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append("a[x-apple-data-detectors] {" & vbCrLf)
        sqlbr.Append("	color:inherit!important;" & vbCrLf)
        sqlbr.Append("	text-decoration: none!important;" & vbCrLf)
        sqlbr.Append("	font-size:inherit!important;" & vbCrLf)
        sqlbr.Append("	font-family: inherit!important;" & vbCrLf)
        sqlbr.Append("	font-weight:inherit!important;" & vbCrLf)
        sqlbr.Append("	line-height: inherit!important;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append(".es-desk-hidden {" & vbCrLf)
        sqlbr.Append("	display:none;" & vbCrLf)
        sqlbr.Append("	float: Left;" & vbCrLf)
        sqlbr.Append("	overflow:hidden;" & vbCrLf)
        sqlbr.Append("	width:  0;" & vbCrLf)
        sqlbr.Append("	max-height:0;" & vbCrLf)
        sqlbr.Append("	line-height:  0;" & vbCrLf)
        sqlbr.Append("	mso-hide: all;" & vbCrLf)
        sqlbr.Append("}" & vbCrLf)
        sqlbr.Append("</style>" & vbCrLf)
        sqlbr.Append("</head>" & vbCrLf)
        sqlbr.Append("<body style=""width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<div class=""es-wrapper-color"" style=""background-color:#E4E5E7;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-header"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-header-body"" width=""600"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#34265F;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;"">" & vbCrLf)
        sqlbr.Append("<!--[if mso]><table width=""560"" cellpadding=""0"" cellspacing=""0""><tr><td width=""178"" valign=""top""><![endif]-->" & vbCrLf)
        sqlbr.Append("<table class=""es-left"" cellspacing=""0"" cellpadding=""0"" align=""left"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-p0r es-m-p20b"" width=""178"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-txt-c"" align=""left"" style=""padding:0;Margin:0;""><img src=""http://grupobatia.com.mx/images/gbblanco.png"" alt=""Logo Batia"" title=""Logo Batia"" width=""104"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<!--[if mso]></td><td width=""20""></td><td width=""362"" valign=""top""><![endif]-->" & vbCrLf)
        sqlbr.Append("<table cellspacing=""0"" cellpadding=""0"" align=""right"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""362"" align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-txt-c"" align=""right"" style=""padding:0;Margin:0;padding-top:15px;padding-bottom:20px;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#FFFFFF;"">Fecha:  " & fecha & "</p><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#FFFFFF;"" id=""txfechaenvio""></p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<!--[if mso]></td></tr></table><![endif]--></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""600"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;""><img class=""adapt-img"" src=""http://grupobatia.com.mx/images/47051523540803179.png"" alt style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" width=""600""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<table class=""es-content"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-content-body"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#EDEDED;"" width=""600"" cellspacing=""0"" cellpadding=""0"" bgcolor=""#ededed"" align=""center"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""600"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;padding-top:20px;padding-left:40px;padding-right:40px;""><h1 style=""Margin:0;line-height:36px;mso-line-height-rule:exactly;font-family:tahoma, verdana, segoe, sans-serif;font-size:30px;font-style:normal;font-weight:normal;color:#333333;"">Mensaje generado por SINGA</h1></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;""><img class=""adapt-img"" src=""http://grupobatia.com.mx/images/92931515066045884.jpg"" alt width=""600"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;padding-bottom:10px;padding-left:40px;padding-right:40px;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:24px;color:#333333;"" id=""txconcepto""></p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""600"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<table class=""es-content"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-content-body"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#EDEDED;"" width=""600"" cellspacing=""0"" cellpadding=""0"" bgcolor=""#ededed"" align=""center"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""Margin:0;padding-top:20px;padding-bottom:20px;padding-left:40px;padding-right:40px;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""520"" align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;""><h3 style=""Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:tahoma, verdana, segoe, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333;"">" & titulo & "</h3></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">Estimado usuario, el área de ventas ha registrado la baja programada de un Cliente, le agradecemos programar sus actividades para una salida controlada, a continuación un resumen de los datos de la baja.<br></p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;padding-bottom:10px;padding-top:15px;""><h3 style=""Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:tahoma, verdana, segoe, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333;"">Cliente: " & cliente & "</h3></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-p20b"" width=""580"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-table-not-adapt"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">Fecha de salida: " & fbaja & ".</p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("</td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">Motivo de la baja: " & motivo & ".</p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("</td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        'sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">llega a: " & inmuebleb & ".</p></td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("</table>" & vbCrLf)
        'sqlbr.Append("</td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        'sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">Fecha programada de la transferencia: " & fechamov & ".</p></td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("</table>" & vbCrLf)
        'sqlbr.Append("</td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        'sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">RFC: " & rfc & ".</p></td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("</table>" & vbCrLf)
        'sqlbr.Append("</td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        'sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">CURP: " & curp & ".</p></td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("</table>" & vbCrLf)
        'sqlbr.Append("</td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td valign=""top"" align=""left"" style=""padding:0;Margin:0;padding-top:10px;padding-bottom:10px;padding-right:10px;""><img src=""http://grupobatia.com.mx/images/Check_Mark_Black5.png"" alt=alt width=""16"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;"" /></td>" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        'sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        'sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        'sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:14px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;"">No. Seguro Social: " & ss & ".</p></td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        'sqlbr.Append("</table>" & vbCrLf)
        'sqlbr.Append("</td>" & vbCrLf)
        'sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<table class=""es-content"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-content-body"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#EDEDED;"" width=""600"" cellspacing=""0"" cellpadding=""0"" bgcolor=""#ededed"" align=""center"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""600"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;""><img class=""adapt-img"" src=""http://grupobatia.com.mx/images/94931515066951223.png"" alt width=""600"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td style=""Margin:0;padding-top:10px;padding-bottom:20px;padding-left:20px;padding-right:20px;background-color:#34265F;"" bgcolor=""#34265f"" align=""left"">" & vbCrLf)
        sqlbr.Append("<!--[if mso]><table width=""560"" cellpadding=""0"" cellspacing=""0""><tr><td width=""194""><![endif]-->" & vbCrLf)
        sqlbr.Append("<table class=""es-left"" cellspacing=""0"" cellpadding=""0"" align=""left"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-p0r es-m-p20b"" width=""174"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td esdev-links-color=""#ffffff"" align=""right"" style=""padding:0;Margin:0;padding-top:5px;""><h3 style=""Margin:0;line-height:48px;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:32px;font-style:normal;font-weight:normal;color:#FFFFFF;""><strong><a target=""_blank"" style=""-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:32px;text-decoration:none;color:#FFFFFF;line-height:48px;"" href=""https://viewstripo.email/"">SINGA</a></strong><br></h3></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("<td class=""es-hidden"" width=""20"" style=""padding:0;Margin:0;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<table class=""es-right"" cellspacing=""0"" cellpadding=""0"" align=""right"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td class=""es-m-p20b"" width=""173"" align=""left"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<!--[if mso]></td></tr></table><![endif]--></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("<table class=""es-footer"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table class=""es-footer-body"" width=""600"" cellspacing=""0"" cellpadding=""0"" align=""center"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""left"" style=""padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td width=""560"" valign=""top"" align=""center"" style=""padding:0;Margin:0;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" cellspacing=""0"" cellpadding=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:0;Margin:0;""><img src=""http://grupobatia.com.mx/images/logo%20batia.png"" alt=""Logo Batia"" title=""Logo Batia"" width=""104"" style=""display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:10px;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:12px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:18px;color:#333333;"">Usted esta recibiendo este correo de forma automática, favor de NO responder al remitente, si usted no es el destinatario correcto favor de hacer caso omiso del mismo.</p><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:12px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:18px;color:#333333;""><a target=""_blank"" href="""" style=""-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:12px;text-decoration:none;color:#34265F;"">quiero saber mas</a> | <a target=""_blank"" href=""http://singa.com.mx:8083/login.aspx"" style=""-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:12px;text-decoration:none;color:#34265F;"">sistema integral de gestión administrativa</a></p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""Margin:0;padding-top:5px;padding-bottom:5px;padding-left:20px;padding-right:20px;"">" & vbCrLf)
        sqlbr.Append("<table width=""100%"" height=""100%"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"">" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td style=""padding:0;Margin:0px 0px 0px 0px;border-bottom:1px solid #CCCCCC;background:none;height:1px;width:100%;margin:0px;""></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("<tr style=""border-collapse:collapse;"">" & vbCrLf)
        sqlbr.Append("<td align=""center"" style=""padding:10px;Margin:0;""><p style=""Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:12px;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:18px;color:#333333;"">Grupo Batia, Av. Coyoacán 1704,&nbsp;Acacias 03100 Ciudad de México</p></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table></td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("</td>" & vbCrLf)
        sqlbr.Append("</tr>" & vbCrLf)
        sqlbr.Append("</table>" & vbCrLf)
        sqlbr.Append("</div>" & vbCrLf)
        sqlbr.Append("</body>" & vbCrLf)
        sqlbr.Append("</html>" & vbCrLf)

        envia(sqlbr.ToString, destinos)

        Return ""
    End Function

    Public Sub bajacliente(fecha As String, v As String, cliente As String, puesto As Object, sucursal As Object, persona As Object, vacante As Object, idvacante As Object, usuario As Object)
        Throw New NotImplementedException()
    End Sub

    Protected Function envia(ByVal cuerpo As String, ByVal destino As String) As String

        Dim mail As New MailMessage
        mail.From = New MailAddress("adminsinga@grupobatia.com.mx")

        Dim v_par As Array
        v_par = (destino).Split(";")
        For i As Integer = 0 To v_par.Length - 1
            If v_par(i) <> "" Then mail.To.Add("" & v_par(i) & "")
        Next

        'mail.To.Add()
        mail.Subject = "NOTIFICACION DE SINGA"
        mail.IsBodyHtml = True
        mail.Body = cuerpo



        Dim pass As String = "Ad*Gb1001"
        Dim mailClient As New SmtpClient()
        Dim basicAuthenticationInfo As New NetworkCredential("adminsinga@grupobatia.com.mx", "" & pass & "")
        mailClient.Host = "smtp.office365.com"
        mailClient.UseDefaultCredentials = True
        mailClient.Credentials = basicAuthenticationInfo
        mailClient.Port = 587
        mailClient.EnableSsl = True

        Try
            mailClient.Send(mail)

        Catch ex As Exception
            Dim a = ex.Message.ToString()
        End Try

        Return ""

    End Function
End Class
