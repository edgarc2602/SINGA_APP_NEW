<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Cancelafacturas.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Cancelafacturas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CANCELACIÓN DE FACTURAS</title>
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
    <style>
        #tblista tbody td:nth-child(11), #tblista tbody td:nth-child(12), #tblista tbody td:nth-child(13){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            var d = new Date();
            $('#txanio').val(d.getFullYear());
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
                    // scrollbar fix for IE
                    $('body').css('overflow', 'hidden');
                },
                close: function () {
                    // reset overflow
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
            $('#txfecancela').datepicker({ dateFormat: 'dd/mm/yy' });
            cargames();
            cargacliente();
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });            
            $('#btcancela').click(function () {
                if (valida()) {                    
                    var res = confirm('¿Esta seguro de cancelar este pendiente de facturar?');
                    if (res == true) {
                        var xmlgraba = ''
                        xmlgraba += '<cancelacion id_cliente="' + $('#idcliente').val() + '" monto="' + $('#txtotacancelar').val() + '" motivo="' + $('#txmotivo').val() + '"' 
                        xmlgraba += ' mes = "' + $('#idmes').val() + '" anio = "' + $('#txanio1').val() + '" linea = "' + $('#idlinea').val() + '"' 
                        xmlgraba += ' tipo = "' + $('#idtipo').val() + '" usuario = "' + $('#idusuario').val() + '" />'
                        //alert(xmlgraba);
                        PageMethods.cancelarfactura(xmlgraba, function () {
                            alert('El Saldo pendiente fué cancelada.');
                            cargalista();
                            $('#dvtabla').show();
                            $('#dvdatos').hide();                            
                        }, iferror);
                    }
                }
            })
            $('#btelimina').click(function () {
                $("#divmodal").dialog('option', 'title', 'Programar baja de Cliente');
                dialog.dialog('open');
            })
            $("#txtotacancelar").on('input', function () {
                var valor = $(this).val();
                valor = valor.replace(/[^0-9.]/g, "");
                var partes = valor.split(".");
                if (partes.length > 2) {
                    valor = partes[0] + "." + partes[1];
                }
                var desppunto = valor.split(".");
                if (desppunto.length > 1) {
                    var dosdec = partes[1];
                    valor = partes[0] + "." + dosdec.substring(0, 2);
                }

                $(this).val(valor);
            });
            
            $('#btbusca').click(function () {
                asignapagina(1)
                cuentafacturas();                
                cargalista();
            })
        });
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
            PageMethods.contarfactura($('#dlmes').val(), $('#txanio').val(), $('#dlcliente').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }        
        function valida() {
            if ($('#txtotacancelar').val() =='') {
                alert('Debe capturar el monto de la cancelación');
                return false;
            }
            if ($('#txmotivo').val() == '') {
                alert('Debe capturar el motivo por el que se realiza la cancelación');
                return false;
            }            
            return true;
        };               
        function limpia() {
            $('#txid').val(0)
            $('#txrazonsoc').val('')
            $('#txUUIDaPagar').val('')
            $('#txmontofacturado').val('')
            $('#txcontacto').val('')
            $('#dlmes').val('')
            $('#txtelefono').val('')
            $('#txcorreo').val('');
            $('#dldirector').val(0);
            $('#dlejecutivo').val(0);
            $('#dlencargado').val(0);
            $('#dlperfac').val(0);
            $('#dltipfac').val(0);
            $('#txcred').val(0);
            $('#txvigencia').val(0);
            $('#txfecter').val('');
            $('#txpmat').val(0);
            $('#txpind').val(0);
            $('#txtotacancelar').val(0);
            $('#txmetodopago').val(0);
            $('#dlempresa').val(0);
        }
        function cargalista() {
            PageMethods.factura($('#hdpagina').val(), $('#dlmes').val(), $('#txanio').val(), $('#dlcliente').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);                
                $('#tblista  tbody tr').click( function () {
                    $('#txcliente').val($(this).children().eq(1).text());
                    $('#txtipo').val($(this).children().eq(5).text());
                    $('#txlinea').val($(this).children().eq(4).text());
                    $('#txmes').val($(this).children().eq(2).text());
                    $('#txanio1').val($(this).children().eq(3).text());
                    $('#txpendiente').val($(this).children().eq(6).text());
                    $('#txfacturado').val($(this).children().eq(7).text());
                    $('#txsaldo').val($(this).children().eq(9).text());
                    $('#txtotacancelar').val($(this).children().eq(9).text());
                    $('#idcliente').val($(this).children().eq(0).text());
                    $('#idmes').val($(this).children().eq(10).text());
                    $('#idlinea').val($(this).children().eq(11).text());
                    $('#idtipo').val($(this).children().eq(12).text());
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);                    
                });
            }, iferror);
        };       
        function cargames() {
            PageMethods.mes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlmes').append(inicial);
                $('#dlmes').append(lista);
            }, iferror);
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
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
    
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />        
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server"/>
        <asp:HiddenField ID="idmes" runat="server"/>
        <asp:HiddenField ID="idlinea" runat="server" />
        <asp:HiddenField ID="idtipo" runat="server" />
        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home.aspx" class="logo">
                    <!-- mini logo for sidebar mini 50x50 pixels -->
                    <span class="logo-mini"><b>S</b>GA</span>
                    <!-- logo for regular state and mobile devices -->
                    <span class="logo-lg"><b>SIN</b>GA</span>
                </a>
                <!-- Header Navbar: style can be found in header.less -->
                <div class="navbar navbar-static-top" role="navigation">
                    <!-- Sidebar toggle button-->
                    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button" id="menu">
                        <span class="sr-only">Toggle navigation</span>
                    </a>
                    <div class="navbar-custom-menu">
                        <ul class="nav navbar-nav">
                            <!-- Notifications: style can be found in dropdown.less -->
                            <li class="dropdown notifications-menu">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <i class="fa fa-bell-o"></i>
                                    <span class="label label-warning">0</span>
                                </a>
                            </li>
                            <!-- User Account: style can be found in dropdown.less -->
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
                <!-- sidebar: style can be found in sidebar.less -->
                <div class="sidebar" id="var1">
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <%--<%=listamenu%>--%>
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Cancelación de pendientes de facturar<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Cancelación de facturas</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="auto-style1">
                            <div class="box box-info">
                                <div class="box-header">
                                </div>
                                <div class="row mb-3">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcliente">Cliente:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcliente" class="form-control" disabled="disabled" value="" />
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtipo">Tipo:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtipo" class="form-control" disabled="disabled" value="" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dllinea">Línea Negocio:</label>
                                    </div>
                                    <div class="col-lg-2 text-left">
                                        <input type="text" id="txlinea" class="form-control" disabled="disabled" value="" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txanio1">Año:</label>
                                    </div>
                                    <div class="col-lg-1 text-left">
                                        <input class="form-control" type="text" id="txanio1" maxlength="4" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txmes">Mes:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txmes" class="form-control" disabled="disabled"></input>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txpendiente">Pendiente:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txpendiente" class="form-control" disabled="disabled" value="" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txfacturado">Facturado:</label>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <input type="text" id="txfacturado" class="form-control" disabled="disabled" value="" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txsaldo">Saldo:</label>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <input type="text" id="txsaldo" class="form-control" disabled="disabled" value="" />
                                    </div>
                                </div>
                                <hr />
                                <div class="row mb-3">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtotacancelar">Total a cancelar:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtotacancelar" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmotivo">Motivo:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <textarea id="txmotivo" class="form-control"></textarea>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Cancelar Importe" id="btcancela" />
                                    </div>
                                </div>                                
                                <ol class="breadcrumb">
                                    <%--<li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>--%>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i> Ir a Lista de Pendientes</a></li>
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
                                    <label for="txfuente">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlmes"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control" />
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
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id cliente</span></th>
                                            <th class="bg-navy"><span>cliente</span></th>
                                            <th class="bg-navy"><span>Mes</span></th>
                                            <th class="bg-navy"><span>Año</span></th>
                                            <th class="bg-navy"><span>Linéa negocio</span></th>
                                            <th class="bg-navy"><span>Tipo</span></th>
                                            <th class="bg-navy"><span>Monto a facturar</span></th>
                                            <th class="bg-navy"><span>Facturado</span></th>
                                            <th class="bg-navy"><span>Cancelado</span></th>
                                            <th class="bg-navy"><span>Saldo</span></th>
                                            <%--<th class="bg-navy"><span>Fecha Emisión</span></th>
                                            <th class="bg-navy"><span>Total</span></th>--%>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <%--<li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>--%>
                                </ol>
                            </div>
                            <nav aria-label="Page navigation example" class="navbar-right">
                                <ul class="pagination justify-content-end" id="paginacion">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divmodal" class="col-md-18">
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Fecha de baja:</label>
                    </div>
                    <div class="col-lg-3">
                        <input type="text" class="form-control" id="txfbaja" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Comentarios:</label>
                    </div>
                    <div class="col-lg-8">
                        <textarea id="txcomentario" class="form-control"></textarea>
                    </div>
                </div>
                <div class="box-footer">
                    <input type="button" class="btn btn-primary pull-right" value="Actualizar" id="btbaja" />
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
