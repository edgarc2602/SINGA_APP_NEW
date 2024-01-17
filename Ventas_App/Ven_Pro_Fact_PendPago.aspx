<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Pro_Fact_PendPago.aspx.vb" Inherits="Ventas_App_Ven_Pro_Fact_PendPago" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FACTURAS PENDIENTE DE PAGO</title>
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

    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            $("#loadingScreen").dialog({
                autoOpen: false,    // set this to false so we can manually open it
                dialogClass: "loadingScreenWindow",
                closeOnEscape: false,
                draggable: false,
                width: 460,
                minHeight: 50,
                modal: true,
                buttons: {},
                resizable: false,
                open: function () {
                    $('body').css('overflow', 'hidden');
                },
                close: function () {
                    $('body').css('overflow', 'auto');
                }
            });
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#txfecemision').datepicker({ dateFormat: 'dd/mm/yy' });
            cargacliente();
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });

            $('#btguarda').on('click', function () {
                if (validaguarda()) {
                    waitingDialog({});
                    var vtotal = 0;
                    var xmlgraba = '';
                    $('#tblista tbody tr').each(function () {
                        vtotal = parseFloat($(this).closest('tr').find("input:eq(0)").val());//('#tblista tbody tr').eq(x).find('input').eq(0).val();
                        if (vtotal > 0)
                        { 
                            xmlgraba = ''
                            xmlgraba += '<pagos> <pago iddocumentoapagar ="' + $(this).closest('tr').find('td').eq(12).text() + '"'
                            xmlgraba += ' total="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"'

                            xmlgraba += '/> ';
                            xmlgraba += '</pagos>';
                            //alert(xmlgraba);
                            PageMethods.guarda(xmlgraba, function (res) {
                            }, iferror);
                        }
                    });

                    closeWaitingDialog();
                    alert('Registro completado.');
                    //limpia();
                    cargalista();
                }
            })


            $('#btbusca').click(function () {
                if (valida()) {
                    cargalista();
                }
            })
        });
        function valida() {            
            if ($('#txfactura').val() == 0 && $('#dlcliente').val() == 0) {
                alert('Debe colocar un folio de factura o seleccionar un cliente, no puedo continuar, verifique')
                return false;
            }
            return true;
        }

        function validaguarda() {
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if (parseFloat($('#tblista tbody tr').eq(x).find('input').eq(0).val()) > parseFloat($('#tblista tbody tr').eq(x).find('td').eq(10).text()) ) {
                    alert('Existe algun renglon donde el importe capturado es mayor que el saldo, verifique por favor');
                    return false;
                }
            }
            return true;
        }

        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
            }, iferror);
        }

        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentafacturas() {
            PageMethods.contarfactura($('#txfactura').val(), $('#dlcliente').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }

        function calculatotal() {
            var vdia = 0;
            var farr = $('#txfolio').val().split('/');
            var finicio = farr[2] + '/' + farr[1] + '/' + farr[0];
            var da = new Date(finicio);
            da.setMonth(da.getMonth() + parseInt($('#txvigencia').val()));
            if (da.getDate() < 10) {
                vdia = '0' + da.getDate();
            } else { vdia = da.getDate() }
            if (da.getMonth() + 1 < 10) {
                vmes = '0' + (da.getMonth() + 1);
            } else { vmes = da.getMonth() + 1 }
            var dfin = vdia + '/' + (vmes) + '/' + da.getFullYear();
            $('#txfecter').val(dfin);
        }

        function iferror(err) {
            alert('ERROR ' + err._message);
        };

        function limpia()
        {
            $('#dlcliente').val(0);
            $('#txfactura').val(0);
                cargalista();
        }

        function cargalista() {
            PageMethods.factura($('#txfactura').val(), $('#dlcliente').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);

                $('#tblista tbody tr').on('input', '.tbeditar', function () {
                    var valor = $(this).val();
                    valor = valor.replace(/[^0-9.]/g, "");
                    var partes = valor.split(".");
                    if (partes.length > 2) {
                        valor = partes[0] + "." + partes[1];
                    }
                    $(this).val(valor);
                });

                $('#tblista tbody tr').on('blur', 'input', function () {
                    var fila = $(this).closest('tr');
                    var valorInput = parseFloat($(this).val());
                    //var valorTd = parseFloat(fila.find('.valorTd').text());
                    var valorTd = parseFloat(fila.find('td:eq(10)').text());
                    if (!isNaN(valorInput) && !isNaN(valorTd) && valorInput > valorTd) {
                        alert('El valor del importe del pago no debe ser mayor al saldo');
                        $(this).val('0');
                    }
                });

                $('#tblista tbody tr').change('.tbeditar', function ()
                {
                    total();
                });
            }, iferror);
        };
        function total() {
            var subtotal = 0;            
            $('#tblista tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(0)").val());
            });            
            $('#txsubtotalg').val(subtotal.toFixed(2));
        }

        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            position: relative;
            min-height: 1px;
            top: -4px;
            left: 46px;
            float: left;
            width: 83%;
            padding-left: 15px;
            padding-right: 15px;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <!--<asp:HiddenField ID="idcliente" runat="server" />-->
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" Value="0" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idencargado" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
        <div class="wrapper">
            <div class="main-header">
                <a href="../Home.aspx" class="logo">
                    <span class="logo-mini"><b>S</b>GA</span>
                    <span class="logo-lg"><b>SIN</b>GA</span>
                </a>
                <div class="navbar navbar-static-top" role="navigation">
                    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button" id="menu">
                        <span class="sr-only">Toggle navigation</span>
                    </a>
                    <div class="navbar-custom-menu">
                        <ul class="nav navbar-nav">
                            <li class="dropdown notifications-menu">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <i class="fa fa-bell-o"></i>
                                    <span class="label label-warning">0</span>
                                </a>
                            </li>
                            <li class="dropdown user user-menu">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <img src="../Content/form/img/incognito.jpg" class="user-image" alt="User Image" />
                                    <span class="hidden-xs" id="nomusr"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="main-sidebar">
                <div class="sidebar" id="var1">
                </div>
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Aplicación de pagos de Cliente<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Clientes</li>
                    </ol>
                </div>
                
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="auto-style1">
                            <div class="box box-info     " style="left: -52px; top: 0px; width: 121%;">
                                <div class="box-header">
                                </div>
                                <ol class="breadcrumb">
                                </ol>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfactura">Folio:</label>
                                </div>
                                 <div class="col-lg-1">
                                    <input type="text" id="txfactura" class="form-control" value="0"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlcliente"></select>
                                </div>                               
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca"/>
                                </div>
                            </div>
                            <div class="col-md-18 tbheader" style="height:300px; overflow:scroll;">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Factura</span></th>
                                            <th class="bg-navy"><span>Cliente</span></th>
                                            <th class="bg-navy"><span>R.F.C.</span></th>
                                            <th class="bg-navy"><span>Mes</span></th>
                                            <th class="bg-navy"><span>Año</span></th>
                                            <th class="bg-navy"><span>Línea de negocio</span></th>
                                            <th class="bg-navy"><span>Tipo servicio</span></th>
                                            <th class="bg-navy"><span>Fecha emisión</span></th>
                                            <th class="bg-navy"><span>Total</span></th>
                                            <th class="bg-navy"><span>Pagos</span></th>
                                            <th class="bg-navy"><span>Saldo</span></th>
                                            <th class="bg-navy"><span>Importe del pago</span></th>
                                            <th class="bg-navy"><span>UUID</span></th>
                                        </tr>
                                    </thead>
                                </table>                                
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-8 text-right">
                                    <label for="txsubtotalg">Total del pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalg" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btguarda" class="puntero"><a><i class="fa fa-edit"></i>Guardar</a></li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
