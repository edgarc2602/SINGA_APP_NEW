<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Asistencia.aspx.vb" Inherits="App_RH_RH_Pro_Asistencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE ASISTENCIA</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <!-- LINK ESPECIAL -->
    <script src="http://momentjs.com/downloads/moment.min.js"></script>

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
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            cargaperiodo();
            cargacliente();
            cargaturno();
            cargaarea() 
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
            $('#btmostrar').click(function () {
                $('#tblista tbody').remove();
                if (valida()) {
                    $('#hdpagina').val(1);
                    cuentaempleado();
                    cargalista();
                }
            })
            $('#txfecha').change(function () {
                $('#tblista tbody').remove();
                if (valida()) {
                    $('#hdpagina').val(1);
                    cuentaempleado();
                    cargalista();
                }
            })
            $('#btguarda').click(function () {
                //waitingDialog({});
                var fecha = $('#txfecha').val().split('/');
                var finicio = fecha[2] + fecha[1] + fecha[0];
                var periodo = $('#dlperiodo option:selected').text();
                var anio = periodo.substring(3, 7);
                var tipo = periodo.substring(8, periodo.length);
                var xmlgraba = '';
                for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                    //if ($('#tblista tbody tr').eq(x).find("input:eq(0)").val() == 'Falta') {
                    xmlgraba += '<partida inmueble ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" empleado="' + $('#tblista tbody tr').eq(x).find('td').eq(3).text() + '"' 
                    xmlgraba += ' confirma="' + $('#tblista tbody tr').eq(x).find('input').eq(0).val() + '"'
                    if ($('#tblista tbody tr').eq(x).find('input').eq(1).val() == 'S') {
                        xmlgraba += ' mov = "A"';
                    } else {
                        if ($('#tblista tbody tr').eq(x).find('input').eq(2).val() == 'S') {
                            xmlgraba += ' mov = "F"';
                        } else {
                            if ($('#tblista tbody tr').eq(x).find('input').eq(3).val() == 'S') {
                                xmlgraba += ' mov = "FJ"';
                            } else {
                                if ($('#tblista tbody tr').eq(x).find('input').eq(4).val() == 'S') {
                                    xmlgraba += ' mov = "N"';
                                } else {
                                    if ($('#tblista tbody tr').eq(x).find('input').eq(5).val() == 'S') {
                                        xmlgraba += ' mov = "V"';
                                    } else {
                                        if ($('#tblista tbody tr').eq(x).find('input').eq(6).val() == 'S') {
                                            xmlgraba += ' mov = "IEG"';
                                        } else {
                                            if ($('#tblista tbody tr').eq(x).find('input').eq(7).val() == 'S') {
                                                xmlgraba += ' mov = "IRT"';
                                            } else {
                                                if ($('#tblista tbody tr').eq(x).find('input').eq(8).val() == 'S') {
                                                    xmlgraba += ' mov = "D"';
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    xmlgraba += '  periodo = "' + $('#dlperiodo').val() + '" fecha = "' + finicio + '" tipo = "' + tipo + '" anio = "' + anio + '" /> ';
                };
                //alert(xmlgraba);
                PageMethods.guarda(xmlgraba, function () {
                    closeWaitingDialog();
                    alert('Registro completado.');
                }, iferror);

            })
            $('#btimprime').click(function () {
                var fecha = $('#txfecini').val().split('/');
                var finicio = fecha[2] + fecha[1] + fecha[0];
                var fecha1 = $('#txfecfin').val().split('/');
                var ffin = fecha1[2] + fecha1[1] + fecha1[0];
                var periodo = $('#dlperiodo option:selected').text()
                var anio = periodo.substring(3, 7);
                var tipo = periodo.substring(8, periodo.length);
                /*var formap = 1
                if (tipo == 'Semanal') {
                    formap = 2;
                }*/
                //var xmlgraba = '<asistencia fini="' + finicio + '" ffin="' + ffin + '" periodo="'+ $('#dlperiodo').val() +'" anio="'+ anio +'"  tipo="' + tipo + '" usuario="' + $('#idusuario').val() + '" cliente="' + $('#dlcliente').val() + '" formap="' + formap + '" />';
               // alert(xmlgraba);
                //PageMethods.reporte(xmlgraba, function () {
                    var formula = '{tb_empleado_asistencia.id_periodo}=' + $('#dlperiodo').val() + ' and {tb_empleado_asistencia.anio}=' + anio + ' and {tb_empleado_asistencia.tipo}="' + tipo +  '" and {tb_cliente_inmueble.id_cliente}=' + $('#dlcliente').val()
                    if ($('#dlsucursal').val() != 0) {
                        formula += ' and {tb_empleado_asistencia.id_inmueble}=' + $('#dlsucursal').val() 
                    }
                    //alert(formula);
                    window.open('../RptForAll.aspx?v_nomRpt=controlasistencia.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
               // }, iferror);
            })
        });
        function valida() {
                     
            var freg = $('#txfecha').val().split("/");
            var dateval = new Date(freg[1] + "/" + freg[0] + "/" + freg[2]);
            
            var fdia = new Date;
            var resta = fdia - dateval
            //var diff = moment("2017-09-10").diff(moment("2017-09-01"), 'days');
            //var resta = fdia.diff(dateval, 'days')
            
            resta = Math.round(resta / (1000 * 60 * 60 * 24))
            //alert(resta);
            /* ESTA VALIDACION SE DEBE AGREGAR CUANDO LO AUTORICE VICTOR*/
            if ($('#idusuario').val() != 7 && $('#idusuario').val() != 100 && $('#idusuario').val() != 1) {
                if (resta > 3) {
                    alert('No puede capturar asistencia con mas de 3 días de diferencia');
                    return false;
                }
            }
            var fini = $('#txfecini').val().split("/");
            var dateini = new Date(fini[1] + "/" + fini[0] + "/" + fini[2]);

            var ffin = $('#txfecfin').val().split("/");
            var datefin = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);

            if (dateval < dateini || dateval > datefin) {
                $('#txfecha').val('');
                alert('La Fecha seleccionada esta fuera del rango del período, verifique');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe selecionar un Cliente');
                return false;
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe selecionar un Periodo de nomina');
                return false;
            }
            if ($('#dlarea').val() == 0) {
                alert('Debe selecionar el área');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe selecionar una fecha para registro de asistencia');
                return false;
            }
            return true;
        }
        function cargaturno() {
            PageMethods.turno(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlturno').append(inicial);
                $('#dlturno').append(lista);
                $('#dlturno').val(0);
            }, iferror);
        }
        function cargaarea() {
            PageMethods.area(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlarea').append(inicial);
                $('#dlarea').append(lista);
                $('#dlarea').val(0);
            }, iferror);
        }
        function cuentaempleado() {
            
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            //var anio = periodo.substring(3, 7);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.contarempleado(per, $('#dlcliente').val(), $('#dlsucursal').val(), $('#dlturno').val(), $('#txempleado').val(), $('#txnoemp').val(), $('#dlarea').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cargalista() {
            waitingDialog({});
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            //var anio = periodo.substring(3, 7);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.empleado($('#dlcliente').val(), $('#dlsucursal').val(), $('#txfecha').val(), $('#dlestado').val(), per, $('#hdpagina').val(), $('#dlturno').val(), $('#txempleado').val(), $('#txnoemp').val(), $('#dlarea').val(), function (res) {
                closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.tbstatus1', function () {
                    if ($(this).closest('tr').find('input').eq(1).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(1).val('S');
                        $(this).closest('tr').find('input').eq(1).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus2', function () {
                    if ($(this).closest('tr').find('input').eq(2).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(2).val('S');
                        $(this).closest('tr').find('input').eq(2).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus3', function () {
                    if ($(this).closest('tr').find('input').eq(3).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(3).val('S');
                        $(this).closest('tr').find('input').eq(3).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus4', function () {
                    if ($(this).closest('tr').find('input').eq(4).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(4).val('S');
                        $(this).closest('tr').find('input').eq(4).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus5', function () {
                    if ($(this).closest('tr').find('input').eq(5).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(5).val('S');
                        $(this).closest('tr').find('input').eq(5).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus6', function () {
                    if ($(this).closest('tr').find('input').eq(6).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(6).val('S');
                        $(this).closest('tr').find('input').eq(6).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus7', function () {
                    if ($(this).closest('tr').find('input').eq(7).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(7).val('S');
                        $(this).closest('tr').find('input').eq(7).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus8', function () {
                    if ($(this).closest('tr').find('input').eq(8).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(8).val('S');
                        $(this).closest('tr').find('input').eq(8).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
            }, iferror);
        };
        function limpiaboton(tr) {
            $('#tblista tbody tr').eq(tr).find('input').eq(1).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(2).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(3).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(4).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(5).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(6).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(7).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(8).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(1).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(2).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(3).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(4).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(5).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(6).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(7).val('N');
            $('#tblista tbody tr').eq(tr).find('input').eq(8).val('N');
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
            PageMethods.cliente($('#idusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').val(0);
                $('#dlcliente').change(function () {
                    cargaestado($('#dlcliente').val());
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
            }, iferror);
        }
        function cargaestado(idcte) {
            PageMethods.estados(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').empty();
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
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
                    <h1>Registro de Asistencia<small>Recursos humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Asistencia</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row">
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlestado">Estado:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlestado" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlturno">Turno:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlturno" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlarea">Área:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlarea" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnoemp">No Empleado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input id="txnoemp" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txempleado">Empleado:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input id="txempleado" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlperiodo">Período:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlperiodo" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecini">F. Inicio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 right">
                                    <input type="button" class="btn btn-primary" value="Mostrar" id="btmostrar" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Punto de atención</span></th>
                                            <th class="bg-navy"><span>Telefono</span></th>
                                            <th class="bg-navy"><span>No. Empleado</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Contacto</span></th>
                                            <th class="bg-navy"><span>Turno</span></th>
                                            <th class="bg-navy"><span>F. Ingreso</span></th>
                                            <th class="bg-navy"><span>Confirmado por</span></th>
                                            <th class="bg-navy"><span>A</span></th>
                                            <th class="bg-navy"><span>F</span></th>
                                            <th class="bg-navy"><span>FJ</span></th>
                                            <th class="bg-navy"><span>N</span></th>
                                            <th class="bg-navy"><span>V</span></th>
                                            <th class="bg-navy"><span>IEG</span></th>
                                            <th class="bg-navy"><span>IRT</span></th>
                                            <th class="bg-navy"><span>D</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir Registros</a></li>
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
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
