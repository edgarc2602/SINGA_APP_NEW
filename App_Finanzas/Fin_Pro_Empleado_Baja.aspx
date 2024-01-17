<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Empleado_Baja.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Empleado_Baja" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Baja de Empleados</title>
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
        .cb{
            width: 30px; 
            height: 30px; 
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfechafin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecharh').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfectrans').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvdatos').hide();
            $('#alptrans').hide();
            $('#dvconfirma').hide();
            //cargacliente();
            setTimeout(function () {
                $("#menu").click();
            }, 50);
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
            /*
            if ($('#tipomov').val() == 1) {
                $('#txfechafin').prop("disabled", false);
                $('#txfecharh').prop("disabled", true);
            } else {
                $('#txfechafin').prop("disabled", true);
                $('#txfecharh').prop("disabled", false);
            }*/
            cuentaemopleado();
            cargalista();
            
            $('#btlista').click(function () {
                $('#tblista').show();
                $('#dvdatos').hide();
                cargalista();
            })
            $('#btguarda').click(function () {
                if ($('#txfechafin').val() != '') {
                    PageMethods.baja($('#txfechafin').val(), $('#txidemp').val(), function () { //$('#tipomov').val(), 
                        alert('Registro actualizado');
                        $('#tblista').show();
                        $('#dvdatos').hide();
                        cargalista();
                    }, iferror);
                } else {
                    alert('Debe elegir una fecha de baja');
                }
                /*
                if ($('#tipomov').val() == 1) {
                    if ($("#cbtransfer").is(':checked')) {
                        PageMethods.transfiere($('#dlcliente').val(), $('#dlsucursal').val(), $('#txfectrans').val(), $('#txidemp').val(), function () {
                            alert('Registro actualizado');
                        }, iferror);
                    } else {
                        
                    }
                } else {
                    if ($('#txfecharh').val() != '') {
                        PageMethods.baja($('#tipomov').val(), $('#txfecharh').val(), $('#txidemp').val(), function () {
                            alert('Registro actualizado');
                        }, iferror);
                    }
                }*/
            })
            $('#cbtransfer').click(function () {
                if ($("#cbtransfer").is(':checked')) {
                    $('#alptrans').show();
                    $('#txfecharh').prop("disabled", true);
                } else {
                    $('#alptrans').hide();
                    $('#txfecharh').prop("disabled", false);
                }
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
                $('#dlcliente').change(function () {
                    $('#tblista table tbody').remove();
                    cargainmueble($('#dlcliente').val());
                });
            }, iferror);
        }
        function cargainmueble(idcte) {
            PageMethods.inmueble(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);
                if ($('#idsucursal').val() != 0) {
                    $('#dlsucursal').val($('#idsucursal').val());
                }
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentaemopleado() {
            PageMethods.contarempleado( function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalista() {
            PageMethods.empleados($('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista tbody tr').on('click', function () {
                    $('#txcliente').val($(this).children().eq(0).text());
                    $('#txsucursal').val($(this).children().eq(1).text());
                    $('#txidemp').val($(this).children().eq(2).text());
                    $('#txnombre').val($(this).children().eq(3).text());
                    $('#txrfc').val($(this).children().eq(4).text());
                    $('#txcurp').val($(this).children().eq(5).text());
                    $('#txss').val($(this).children().eq(6).text());
                    $('#txfechar').val($(this).children().eq(7).text());
                    $('#txfecha').val($(this).children().eq(8).text());
                    $('#txrecomienda').val($(this).children().eq(8).text());
                    /*if ($(this).children().eq(8).text() == 'Transferible') {
                        $('#dvtransfiere').show();
                    } else {
                        $('#dvtransfiere').hide();
                    }
                    if ($(this).children().eq(9).text() == '1') {
                        $('#cbtransfer').prop('checked', true);
                        $('#dlcliente').val($(this).children().eq(10).text());
                        $('#idsucursal').val($(this).children().eq(11).text());
                        cargainmueble($(this).children().eq(10).text());
                    }*/
                    $('#txfechafin').val('');
                    $('#tblista').hide();
                    $('#dvdatos').show();
                });
            }, iferror);
        }

        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idsucursal" runat="server" />
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
                    <h1>Baja de Empleado<small>Confirmación</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Confirmación</a></li>
                        <li class="active">Baja de Empleado</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info" id="dvdatos">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcliente">Cliente:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txsucursal">Punto de atención:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txsucursal" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txidemp">No. Empleado:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txidemp" class="form-control" disabled="disabled" value="0" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txnombre">Nombre:</label>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txrfc">RFC:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txrfc" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txcurp">CURP:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcurp" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txss">No. SS:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txss" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txfecha">Fecha programada:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txrecomienda">Recomendación:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txrecomienda" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txfechar">Fecha de registro:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txfechar" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <!--
                            <div class="row" id="dvtransfiere">
                                <div class="col-lg-6 text-center">
                                    <input type="checkbox" id="cbtransfer" class="cb"/><label for="cbtransfer" style="font-size:20px;">No procede la baja, aplica transferencia</label>
                                </div>
                            </div>
                            -->
                        <hr />
                        <div class="row" id="alptrans">
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfectrans">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfectrans" class="form-control" />
                                </div>
                            </div>
                            <div class="row" id="dvconfirma">
                                <div class="col-lg-6 text-center">
                                    <input type="checkbox" id="cbconfirma" class="cb" /><label for="cbconfirma" style="font-size: 20px;">Confirmar transferencia del Empleado</label>
                                </div>
                            </div>
                            <hr />
                        </div>
                        <div class="row" id="aplfin">
                            <div class="col-lg-2 text-right">
                                <label for="txfechafin">Fecha de baja ante IMSS:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfechafin" class="form-control" />
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                            <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Salir</a></li>
                        </ol>
                    </div>
                    
                    <div class="row" id="tblista">
                        <div class="tbheader" style="height: 400px; overflow-y: scroll">
                            <table class="table table-condensed">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                        <th class="bg-light-blue-gradient"><span>No. Empleado</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                        <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                        <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                        <th class="bg-light-blue-gradient"><span>No. SS</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Registro</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Programada</span></th>
                                    </tr>
                                </thead>
                            </table>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
