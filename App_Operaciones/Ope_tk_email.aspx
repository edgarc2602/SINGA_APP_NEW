<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_tk_email.aspx.vb" Inherits="App_Operaciones_Ope_tk_email" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <base target="_self" />
    <title>Envia Ticket</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <script type="text/javascript" src="../Content/js/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="font-weight: 700">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">Envio de Ticket</h3>
            </div><!-- /.box-header -->
        </div>
        <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
            style="border-collapse: collapse; width:100%; height:80%;" id="filtros" >
                <tr>
                    <td align="right">
                        <small>Ticket:</small> </td>
                    <td align="right">
                        <small> Folio Ticket:</small> </td>
                    <td align="right">
                        <small> Fecha alta:</small> </td>
                    <td align="right">
                        <small> Hora:</small> </td>
                </tr>
            <tr>
                <td align ="left" >
                    <asp:Label ID="lblidticket"  runat="server" style="display:none"></asp:Label>
                    <asp:TextBox ID="txtmatid" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                </td>
                <td align ="left">
                    <asp:TextBox ID="txtmatfolio" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                </td>
                <td align ="left">
                    <asp:TextBox ID="txtmatfechaalta" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                </td>
                <td align ="left">
                    <asp:TextBox ID="txtmathoraalta" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                <small>Enviar a personal de Batia:</small>
                </td>
            </tr>
            <tr>
                <td align ="center" colspan="4">
                    <asp:TextBox ID="txtde" class="form-control"  runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                <small>Correo(s) de Cliente (saparados por &quot; ; &quot; ):</small>
                </td>
            </tr>
            <tr>
                <td align ="center" colspan="4">
                    <asp:TextBox ID="txtpara" class="form-control" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                <small>Asunto:</small>
                </td>
            </tr>
            <tr>
                <td align ="center" colspan="4">
                    <asp:TextBox ID="txtasunto" class="form-control"  runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                <small>Mensaje:</small>
                </td>
            </tr>
            <tr>
                <td align ="center" colspan="4"> 
                    <asp:TextBox ID="txtmensaje" class="form-control"  runat="server" Height="300px" 
                        TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="4">
                    <asp:ImageButton ID="ImageButton2" runat="server" Height="64px" 
                        ImageUrl="~/Content/img/Correo/email.jpg" 
                        Style="left: 152px; top: 128px" ToolTip="Enviar Correo" 
                        Width="96px" />
                </td>
            </tr>
        </table>
        <asp:Label ID="lblnreporte"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblcliente"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblreporta"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblejecutivo"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblarea"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblresparea"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblfecenvio"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblfecalta"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblreporte"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblac"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblap"  runat="server" style="display:none"></asp:Label>
        <asp:Label ID="lblestatus"  runat="server" style="display:none"></asp:Label>




        <br />




    </div>
    </form>
</body>
</html>
