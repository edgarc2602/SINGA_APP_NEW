<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Calculonomina.aspx.vb" Inherits="App_RH_RH_Pro_Calculonomina" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CALCULO DE NOMINA</title>
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
            cargaperiodo();
            cargaempresa();
            cargacliente();
            cargaencargado();
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
            $('#btprocesa').click(function () {
                $('#tblista tbody').remove();
                if (validaproceso()) {
                    $('#hdpagina').val(1);
                    carganomina();
                }
            })
            $('#btrecalcula').click(function () {
                if (validaproceso()) {
                    eliminanomina();
                    procesanomina();
                }
            })
            $('#btexporta').click(function () {
                var periodo = $('#dlperiodo option:selected').text()
                var tipo = periodo.substring(8, periodo.length);
                var per = 1
                if (tipo == 'Semanal') {
                    per = 2
                }
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);

                window.open('RH_Descarga_Nomina.aspx?periodo=' + $('#dlperiodo').val() + '&tipo=' + tipo + '&anio=' + anio, '_blank');
            })
            $('#btimprime').click(function () {
                if ($('#dlperiodo').val() != 0) {
                    if (validaproceso()) {
                        /*waitingDialog({});
                        var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                        var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                        var vforma = 2;
                        if (tipo == 'Quincenal') {
                            vforma = 1;
                        }*/
                        /*
                        var fecha1 = $('#txfecini').val().split('/');
                        var finicio = fecha1[2] + fecha1[1] + fecha1[0];
                        var fecha2 = $('#txfecfin').val().split('/');
                        var ffinal = fecha2[2] + fecha2[1] + fecha2[0];
                        */
                        //xmlgraba = '<procesa periodo="' + $('#dlperiodo').val() + '" forma="' + vforma + '" anio="' + anio + '" tipo="' + tipo + '" fini="' + finicio + '" ffin="' + ffinal + '" tipoemp="' + $('#dltipo').val() + '"/>';
                        //alert(xmlgraba);
                        
                        //PageMethods.nominareporte(xmlgraba, function () {
                        //    closeWaitingDialog();
                            var periodo = $('#dlperiodo option:selected').text()
                            var anio = periodo.substring(3, 7);
                            var tipo = periodo.substring(8, periodo.length);

                            var formula = '{tb_nominacalculadar.id_periodo}=' + $('#dlperiodo').val() + ' and {tb_nominacalculadar.anio}=' + anio + ' and {tb_nominacalculadar.tipo}="' + tipo + '" and {tb_empleado.id_area} = ' + $('#dltipo').val() + ''
                            if ($('#dlcliente').val() != 0) {
                                formula += 'and {tb_cliente.id_cliente}=' + $('#dlcliente').val()
                            }
                            if ($('#dlencargado').val() != 0) {
                                formula += ' and {tb_cliente.id_operativo}=' + $('#dlencargado').val()
                            }
                            if (tipo == 'Semanal') {
                                window.open('../RptForAll.aspx?v_nomRpt=nominacalculadacgo.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                            } else {
                                window.open('../RptForAll.aspx?v_nomRpt=nominacalculadacgoq.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                            }
                        //}, iferror);
                    }
                } else {
                    alert('Debe elegir al menos un período de nómina');
                }
            })
            $('#btcerrar').click(function () {
                if (validaproceso()) {
                    if ($('#dlperiodo').val() != 0) {
                        var r = confirm("El cierre de nomina ya no permite realizar cambios al cálculo actual, ¿estas seguro de continuar?");
                        if (r == true) {
                            var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                            PageMethods.cerrar($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (res) {
                                alert('La nómina ha sido cerrada, ya no se pueden realizar movimientos');
                            }, iferror);
                        } else { alert('No se ejecuta cierre'); }
                    } else { alert('Para Cerrar debe elegir un período de nómina') }
                }
            })
            $('#dltipo').change(function () {
                var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                PageMethods.validaestado($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txestatus').text(datos.estatus);
                }, iferror);
            })
        });
        function validaproceso() {
            if ($('#dltipo').val() == 6) {
                if (($('#idusuario').val() != 1 && $('#idusuario').val() != 97)) {
                    alert('Usted no cuenta con permisos para procesar esta nomina');
                    return false;
                }
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir el período');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de nómina');
                return false;
            }
            if ($('#txestatus').text() != 'Período abierto') {
                alert('El estatus del período no permite ejecutar este proceso');
                return false;
            }
            return true;
        }
        /* ESTA SECCION PARA TOMAR EN CUENTA EL AÑO BISCIESTO
        function days_of_a_year(year) {

            return isLeapYear(year) ? 366 : 365;
        }
        function isLeapYear(year) {
            return year % 400 === 0 || (year % 100 !== 0 && year % 4 === 0);
        }
        */
        function cuentanomina() {
            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
            var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
            PageMethods.contarnomina($('#dlperiodo').val(), tipo, anio, $('#dlcliente').val(), $('#dlencargado').val(), $('#dltipo').val(),  function (cont) {
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
            if (valida()) {
                //waitingDialog({});
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                PageMethods.nomina($('#hdpagina').val(), $('#dlperiodo').val(), tipo, anio, $('#dlcliente').val(), $('#dlencargado').val(), $('#dltipo').val(), function (res) {
                    //closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista  tbody tr').on('click', function () {
                    });
                }, iferror);
            }
        };
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
        function cargaencargado() {
            PageMethods.empleado(4, 'esencargado', function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlencargado').empty();
                $('#dlencargado').append(inicial);
                $('#dlencargado').append(lista);
            }, iferror);
        }
        function eliminanomina() {
            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
            var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
            PageMethods.elimina($('#dlperiodo').val(), anio, tipo, $('#dltipo').val(), function () {
                
            }, iferror);
        }
        
        function procesanomina() {
            if (valida()) {
                waitingDialog({});
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                var vdias = 7;
                var vforma = 2;
                if (tipo == 'Quincenal') {
                    /*var d = new Date();
                    var a = days_of_a_year(d.getFullYear());
                    var vdias = (a / 12 / 2).toFixed(2)*/
                    //alert(vdias);
                    var vdias = 15.20835;
                    vforma = 1;
                }
                var fecha1 = $('#txfecini').val().split('/');
                var finicio = fecha1[2] + fecha1[1] + fecha1[0];
                var fecha2 = $('#txfecfin').val().split('/');
                var ffinal = fecha2[2] + fecha2[1] + fecha2[0];
                
                xmlgraba = '<procesa periodo="' + $('#dlperiodo').val() + '" dias="' + vdias + '" forma="' + vforma + '" anio="' + anio + '" tipo="' + tipo + '" fini="' + finicio + '" ffin="' + ffinal + '" tipoemp="' + $('#dltipo').val() + '"/>';
                //alert(xmlgraba);

                PageMethods.procesa(xmlgraba, function () {
                    closeWaitingDialog();
                    alert('Proceso concluido.');
                    carganomina();
                }, iferror);
            }
        }
        function valida() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir el período de nómina');
                return false;
            }
            return true;
        }
        function carganomina() {
            //alert($('#dlencargado').val());
            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
            var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
            //alert($('#dltipo').val());
            PageMethods.procesada($('#dlperiodo').val(), tipo, anio, $('#dlcliente').val(), $('#dlencargado').val(), $('#dltipo').val(),  function (detalle) {
                //alert('hola');
                var datos = eval('(' + detalle + ')');
                if (datos.percepcion == '$0.00') {
                    //eliminanomina();
                    procesanomina();
                } else {
                    //alert('Este período de nomina ya ha sido procedado, se cargaran los valores ya calculados');
                    $('#txprecepcion').val(datos.percepcion);
                    $('#txdeduccion').val(datos.deduccion);
                    $('#txtotal').val(datos.total);
                    cuentanomina();
                    cargalista();
                }
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
                    PageMethods.detalleperiodo($('#dlperiodo').val(), per, function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txfecini').val(datos.fini);
                        $('#txfecfin').val(datos.ffin);
                    });
                });
            }, iferror);
        }
        function cargaempresa() {
            PageMethods.empresa(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempresa').append(inicial);
                $('#dlempresa').append(lista);
                $('#dlempresa').val(0);
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <h1>Cálculo de Nóminas<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Nóminas</li>
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
                                    <label for="txid">Período:</label>
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
                            <!--
                                <div class="row">
                                     <div class="col-lg-2 text-right">
                                        <label for="txid">Empresa:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlempresa" class="form-control"></select>
                                    </div>
                                </div>
                                -->
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dltipo" class="form-control">
                                         <option value="0">Seleccione...</option>
                                            <option value="6">Administrativa</option>
                                            <option value="4">Operativa</option>
                                            <option value="11">Mantenimiento</option>
                                    </select>
                                </div>
                                <div class="col-lg-2">
                                    <h4 class=" text-maroon" id="txestatus"></h4>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlencargado">Gerente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlencargado" class="form-control"></select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="button" id="btprocesa" class="btn btn-success center-block" value="Procesar" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla" style="height:300px; overflow-y:scroll;">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Cliente</span></th>
                                            <th class="bg-navy"><span>Punto de atención</span></th>
                                            <th class="bg-navy"><span>No. Empleado</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Percepciones</span></th>
                                            <th class="bg-navy"><span>Deducciones</span></th>
                                            <th class="bg-navy"><span>Neto</span></th>
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
                    <div class="row">
                        <div class="box-header">
                            <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txid">Total de Percepciones:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txprecepcion" class="form-control text-right" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txid">Total de Deducciones:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txdeduccion" class="form-control text-right" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txid">Total a pagar:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtotal" class="form-control text-right" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2">
                                <input type="button" id="btrecalcula" class="btn btn-primary" value="Recalcular Nómina" />
                            </div>
                            <div class="col-lg-2">
                                <input type="button" id="btimprime" class="btn btn-primary" value="Imprimir Nómina" />
                            </div>
                            <div class="col-lg-2">
                                <input type="button" id="btcerrar" class="btn btn-primary" value="Cerrar Nómina" />
                            </div>
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
