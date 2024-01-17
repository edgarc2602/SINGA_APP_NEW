    <%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Oficinas.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Oficinas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>OFICINAS POR CLIENTE</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script>
        $(function () {
            $('#txctenom').text($('#nombre').val());
            PageMethods.oficina($('#idcte').val(), function (res) {
                var ren = $.parseHTML(res);
                //alert(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
            }, iferror);
            $('#btsalir').on('click', function () {                
                var xmlgraba = '<Movimiento cliente="' + $('#idcte').val() + '">';
                $('#tblista tr input[type=checkbox]:checked').each(function () {
                    xmlgraba += '<cte idcliente="' + $('#idcte').val() + '" idplaza="' + $(this).closest('tr').find('td').eq(0).text() + '"/>"';
                });
                xmlgraba += '</Movimiento>';
                //alert(xmlgraba);
                PageMethods.guarda(xmlgraba, function (res) {
                    window.close();
                }, iferror);
                
            })
        });
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idcte" runat="server" Value="0" />
        <asp:HiddenField ID="nombre" runat="server" Value="0" />
        <div class="content">
            <div class="row">
                <div class="col-md-4 tbheader">
                    <table class="table table-condensed" id="tblista">
                        <thead>
                            <tr>
                                <th class="bg-navy"><span>Oficina</span></th>
                                <th class="bg-navy"><span>Aplica</span></th>
                            </tr>
                        </thead>
                    </table>
                    <ol class="breadcrumb">
                        <li id="btsalir" class="puntero"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                    </ol>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
