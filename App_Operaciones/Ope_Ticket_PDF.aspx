<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Ticket_PDF.aspx.vb" Inherits="App_Operaciones_Ope_Ticket_PDF" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width:800px;">
            <tr>
                <td style=" text-align:left; width:100px;">
                    <img alt="" 
                        src="../Content/img/batia.png" /></td>
                <td class="titulorecibomuestras" 
                    style="font-family: Arial Narrow; font-size: 20pt; color: rgb(0, 0, 0); text-align:center;">    
                    Convertimos sus preocupaciones en satisfacciones</td>
            </tr>
        </table>
        <table style="width:800px; font-family: Times New Roman; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-style: initial; text-decoration-color: initial;" >
            <tr style="height:40px;" >
                <td colspan="5">
                    <p class="textonormalsmall" 
                        style="font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; padding-left: 5px;">
                        
                    </p>
                </td>
            </tr>
        </table>
        <table style="border: thin solid #000000; width:800px;" >
            <tr style="height:35px;">
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt; text-align:left;  width:100px;">
                    <b>Folio:</b>&nbsp;&nbsp;</td>
                <td style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt;">
                    <%= txtFolio%>
                </td>                
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt; text-align:left;  width:150px;">
                    <b>Fecha</b>&nbsp;&nbsp;</td>
                <td style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; ">
                    <%= txtFec%></td>
            </tr>
            <tr style="height:35px;">
                <td style=" width:150px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt; text-align:left;">
                    <b>Cliente:</b>
                </td>
                <td style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; width: 755.344px;">
                    <%= txtcliente%> </td>
                <td style=" width:150px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt; text-align:left;">
                    <b>Ejecutivo que Atiende:</b>
                </td>
                <td style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; width: 755.344px;">
                    <%= txtejecutivo%> </td>
            </tr>
            <tr style="height:35px;">
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;text-align:left;  width:150px;">
                    <b>Centro:</b>&nbsp;&nbsp;</td>
                <td class="textoimpresion" 
                    style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; ">
                    <%= txtcentro%></td>
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;text-align:left;  width:150px;">
                    <b>Areas de Ejecucion:</b>&nbsp;&nbsp;</td>
                <td class="textoimpresion" 
                    style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; ">
                    <%= txtaeje%></td>
            </tr>
            <tr>
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt; text-align:left; width:100px;">
                    <b>Reporte emitido por:</b>&nbsp;&nbsp;</td>
                <td style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; ">
                    <%= txtgerente%></td>
                <td style="text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;text-align:left;  width:150px;">
                    <b>Responsable de Area Ejecutora:</b>&nbsp;&nbsp;</td>
                <td class="textoimpresion" 
                    style="font-family: Arial; font-size: 9pt; color: rgb(0, 0, 0); border-style: solid; border-width: 1pt; ">
                    <%= txtaeje%></td>
            </tr>

        </table>
        <br />
        <table style="border: thin solid #000000; width:800px;" >
            <tr style="height:35px; text-align:center; background-color: rgb(217, 217, 217);">
                <td style=" width:150px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <b>Reporte</b>
                </td>
            </tr>

            <tr style="height:100px; text-align:Left; ">
                <td style="margin-left: 50%; width:500px; text-align:left; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <%= txtreporte%>
                </td>
            </tr>

        </table>
<br />
<br />
        <table style="border: thin solid #000000; width:800px;" >
            <tr style="height:35px; text-align:center; background-color: rgb(217, 217, 217);">
                <td style=" width:35px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <b>Accion Correctiva</b>
                </td>
            </tr>

            <tr style="height:100px; text-align:Left; ">
                <td style="margin-left: 50%; width:500px; text-align:left; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <%= txtacorrectiva%>
                </td>
            </tr>

        </table>

        <br />
        <table style="border: thin solid #000000; width:800px;" >
            <tr style="height:35px; text-align:center; background-color: rgb(217, 217, 217);">
                <td style=" width:150px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <b>Accion Preventiva</b>
                </td>
            </tr>

            <tr style="height:100px; text-align:Left; ">
                <td style="margin-left: 50%; width:500px; text-align:left; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <%= txtapreventiva%>
                </td>
            </tr>

        </table>
        <br />
        <table style="border: thin solid #000000; width:800px;" >
            <tr style="height:35px; text-align:center; background-color: rgb(217, 217, 217);">
                <td style=" width:150px; text-align:center; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <b>Seguimiento o comentarios adicionales</b>
                </td>
            </tr>

            <tr style="height:100px; text-align:Left; ">
                <td style="margin-left: 50%; width:500px; text-align:left; font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0); text-decoration: none; border-style: solid; border-width: 1pt;">
                    <%= txtbitacora%>
                </td>
            </tr>

        </table>
            
    </div>
    </form>
</body>
</html>
