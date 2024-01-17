<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Incidencia.aspx.vb" Inherits="App_RH_RH_Pro_Incidencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE INCIDENCIAS</title>
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
    <!--<style>
        #tblista thead th:nth-child(6), #tblista tbody td:nth-child(6),
        #tblista thead th:nth-child(6), #tblista tbody td:nth-child(7){
            width:0px;
            display:none;
        }
    </style>-->
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dlsucursal').append(inicial);
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
            cargaperiodo();
            cargacliente();
            cargaincidencia();
            $('#btmostrar').click(function () {
                if (valida()) {
                    cargaincidenciadia();
                }
            })
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var fecha = $('#txfecha').val().split('/');
                    var finicio = fecha[2] + fecha[1] + fecha[0];
                    var periodo = $('#dlperiodo option:selected').text()
                    var anio = periodo.substring(3, 7);
                    var tipo = periodo.substring(8, periodo.length);
                    
                    var vcant = 0;
                    var vmonto = 0;
                    //alert(vmonto);
                    if ($('#txformula').val() == 'Monto') {
                        vcant = 1;
                        vmonto = $('#txcantidad').val();
                    } else {
                        vcant = $('#txcantidad').val();
                        var vform = $('#txformula').val().substring(0, 2);
                        //alert(vform);
                        var vfact = $('#txformula').val().substring(3);
                        //alert(vfact);
                        if (vform == 'SD') {
                            //alert('hola');
                            vmonto = parseFloat($('#txcantidad').val()) * parseFloat($('#txsalario').val()) * parseFloat(vfact);
                        } else if (vform == 'SH') {
                            vmonto = (parseFloat($('#txsalario').val()) /8).toFixed(2) * parseFloat(vfact) * parseFloat($('#txcantidad').val()) 
                        }
                    }
                    xmlgraba = '<partida empleado="' + $('#dlempleado').val() + '" incidencia="' + $('#dlincidencia').val() + '" cantidad="' + vcant + '"  monto="' + vmonto + '" periodo="' + $('#dlperiodo').val() + '" fecha="' + finicio + '" tipo="' + tipo + '" anio="' + anio + '"/>';
                    //alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function () {
                        closeWaitingDialog();
                        alert('Registro completado');
                        //cargaincidenciadia();
                    }, iferror);
                }
            })
        });
        function limpia() {
            $('#dlperiodo').val(0);
            $('#txfecini').val('');
            $('#txfecfin').val('');
            $('#txfecha').val('');
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#dlempleado').empty();
            $('#txsalario').val('');
            $('#dlincidencia').val(0);
            $('#txtipo').val('');
            $('#txformula').val('');
            $('#txcantidad').val('');
        }
        function valida() {
            var freg = $('#txfecha').val().split("/");
            var dateval = new Date(freg[1] + "/" + freg[0] + "/" + freg[2]);

            var fini = $('#txfecini').val().split("/");
            var dateini = new Date(fini[1] + "/" + fini[0] + "/" + fini[2]);

            var ffin = $('#txfecfin').val().split("/");
            var datefin = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);
            if (dateval < dateini || dateval > datefin) {
                alert('La Fecha seleccionada esta fuera del rando del período, verifique');
                return false;
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe seleccionar un período de nómina');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe seleccionar la fecha de aplicación de incidencias');
                return false;
            }
            return true;
        }
        function cargaincidenciadia() {
            var periodo = $('#dlperiodo option:selected').text()
            var anio = periodo.substring(3, 7);
            var tipo = periodo.substring(8, periodo.length);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.incidenciadia($('#dlperiodo').val(), anio, tipo, $('#txfecha').val(), $('#dlcliente').val(), $('#dlsucursal').val(),per, function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                
            }, iferror);
        }
        function cargaincidencia() {
            PageMethods.incidencia(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlincidencia').append(inicial);
                $('#dlincidencia').append(lista);
                $('#dlincidencia').val(0);
                $('#dlincidencia').change(function () {
                    waitingDialog({});
                    PageMethods.detincidencia($('#dlincidencia').val(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txtipo').val(datos.tipo);
                        $('#txformula').val(datos.formula);
                        closeWaitingDialog();
                    });
                })
            }, iferror);
        }
        function cargaempleado() {
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.empleado($('#dlcliente').val(), $('#dlsucursal').val(), per, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempleado').empty();
                $('#dlempleado').append(inicial);
                $('#dlempleado').append(lista);
                $('#dlempleado').val(0);
                $('#dlempleado').change(function () {
                    PageMethods.sueldo($('#dlempleado').val(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txsalario').val(datos.sdiario);
                    });
                })
            }, iferror);
        }
        function cargaperiodo() {
            PageMethods.periodo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlperiodo').append(inicial);
                $('#dlperiodo').append(lista);
                $('#dlperiodo').val(0);
                $('#dlperiodo').change(function () {
                    var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                    var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                    PageMethods.detalleperiodo($('#dlperiodo').val(), per, anio, function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txfecini').val(datos.fini);
                        $('#txfecfin').val(datos.ffin);
                    });
                });
            }, iferror);
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
                $('#dlcliente').val(0);
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
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
                $('#dlsucursal').val(0);
                $('#dlsucursal').change(function () {
                    cargaempleado();
                })
            }, iferror);
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
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
                                    <span class="hidden-xs" id="nomusr"> </span>
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
                    <h1>Registro de Incidencias individuales<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Incidencias individuales</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">

                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlperiodo">Período de Nómina:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlperiodo" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecini">F. Inicio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" disabled="disabled" />
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlempresa">Fecha de Aplicación:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlempleado">Empleado:</label>
                                </div>
                                <div
                                    class="col-lg-3">
                                    <select id="dlempleado" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txsalario">Salario diario:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txsalario" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlincidencia">Incidencia:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlincidencia" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txtipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtipo" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txformula">Formula:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txformula" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcantidad">Cantidad:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcantidad" class="form-control" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
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
