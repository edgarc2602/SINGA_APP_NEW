<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Lineas.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Lineas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LINEAS DE NEGOCIO POR CLIENTE</title>
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
            PageMethods.lineas($('#idcte').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);

                $('#tblista tbody tr').each(function (index, row)
                {
                    var monto = parseFloat($(row).find('input[name="txmonto"]').val());
                    var montoFormateado = monto.toFixed(2);
                    $(row).find('.formatted-td').text(montoFormateado);
                });

                $('#tblista tbody tr input[type="checkbox"]').on('click', function () {
                    var checkbox = $(this);
                    var input = checkbox.closest('tr').find('input[name="txmonto"]');
                    if (!checkbox.prop('checked'))
                    {
                        input.val(''); 
                    }
                });

                $('#tblista tbody tr').on('input', '.txmonto', function () {
                    var valor = $(this).val();
                    valor = valor.replace(/[^0-9.]/g, "");
                    var partes = valor.split(".");
                    if (partes.length > 2) {
                        valor = partes[0] + "." + partes[1];
                    }
                    $(this).val(valor);
                });

            }, iferror);

            $('#btsalir').on('click', function ()
            {
                for (var x = 0; x < $('#tblista tbody tr').length; x++)
                {
                    xmlgraba = '';
                    var checkbox = $('#tblista tbody tr:eq(' + x + ') input[type="checkbox"]');
                    if (checkbox.prop('checked'))
                    {
                        if ($('#tblista tbody tr').eq(x).find('input').eq(1).val() == '')
                        {
                            $('#tblista tbody tr').eq(x).find('input').eq(1).val(0)
                        }
                        var xmlgraba = '<Movimiento cliente="' + $('#idcte').val() + '">';
                        xmlgraba += '<cte idcliente="' + $('#idcte').val() + '" idlinea="' + $('#tblista tbody tr:eq(' + x + ') td:eq(0)').text() + '" monto="' + $('#tblista tbody tr').eq(x).find('input').eq(1).val() + '"/>"';
                        xmlgraba += '</Movimiento>';
                        PageMethods.guarda(xmlgraba, function (res)
                        {
                            window.close();
                        }, iferror);
                    }
                }
                
                
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
        <div class="wrapper">
            <div class="content">
                <div class="row">
                    <div class="col-md-4 tbheader">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Clave cliente</span></th>
                                    <th class="bg-navy"><span>Línea de negocio</span></th>
                                    <th class="bg-navy"><span>Aplica</span></th>
                                    <th class="bg-navy"><span>Monto</span></th>
                                </tr>
                            </thead>
                        </table>
                        <ol class="breadcrumb">
                            <li id="btsalir" class="puntero"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
