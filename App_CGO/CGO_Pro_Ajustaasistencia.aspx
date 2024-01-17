<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Ajustaasistencia.aspx.vb" Inherits="App_CGO_CGO_Pro_Ajustaasistencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>AJUSTAR ASISTENCIA PARA NOMINAS</title>
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
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
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
            $('#txnoemp').change(function () {
                PageMethods.detempleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txempleado').val(datos.nombre);
                });
            })
            $('#btmostrar').click(function () {
                cargalista();
            })
            $('#btguarda').click(function () {
                waitingDialog({});
                var periodo = $('#dlperiodo option:selected').text();
                var anio = periodo.substring(3, 7);
                var tipo = periodo.substring(8, periodo.length);
                var xmlgraba = '';
                for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                    var fecha = $('#tblista tbody tr').eq(x).find('td').eq(2).text().split('/');
                    var finicio = fecha[2] + fecha[1] + fecha[0];
                    xmlgraba += '<partida inmueble ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" empleado="' + $('#txnoemp').val() + '"';
                    xmlgraba += ' confirma="" mov="' + $('#tblista tbody tr').eq(x).find('input').eq(0).val() + '"';
                    xmlgraba += ' periodo = "' + $('#dlperiodo').val() + '" fecha = "' + finicio + '" tipo = "' + tipo + '" anio = "' + anio + '" />';
                }
                PageMethods.guarda(xmlgraba, function (res) {
                    closeWaitingDialog();
                    alert('Registro completado.');
                }, iferror);
            })
            $('#btagrega').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var periodo = $('#dlperiodo option:selected').text();
                    var anio = periodo.substring(3, 7);
                    var tipo = periodo.substring(8, periodo.length);
                    
                    var fecha = $('#txfecha').val().split('/');
                    var finicio = fecha[2] + fecha[1] + fecha[0];
                    var xmlgraba = '<partida inmueble ="' + $('#dlsucursal').val() + '" empleado="' + $('#txnoemp').val() + '"';
                    xmlgraba += ' confirma="" mov="' + $('#txmov').val() + '"';
                    xmlgraba += ' periodo = "' + $('#dlperiodo').val() + '" fecha = "' + finicio + '" tipo = "' + tipo + '" anio = "' + anio + '" />';

                    PageMethods.agrega(xmlgraba, function () {
                        closeWaitingDialog();
                        cargalista();
                        limpia();
                    }, iferror);
                }
            })
            $('#txmov').change(function () {
                $('#txmov').val($('#txmov').val().toUpperCase());
                if (esvalida($('#txmov').val())) {
                } else {
                    alert('La letra que ha colocado no es válida en el registro de asistencia');
                    $('#txmov').val('');
                    $('#txmov').focus();
                }
            })
        })
        function limpia() {
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#txfecha').val('');
            $('#txmov').val('');
        }
        function valida() {
            if ($('#txnoemp').val() == '') {
                alert('Debe colocar un numero de empleado valido');
                return false;
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe selecionar un Periodo de nomina');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe selecionar un Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe selecionar un Punto de atención');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe selecionar una fecha para registro de asistencia');
                return false;
            }
            var freg = $('#txfecha').val().split("/");
            var dateval = new Date(freg[1] + "/" + freg[0] + "/" + freg[2]);

            var fini = $('#txfecini').val().split("/");
            var dateini = new Date(fini[1] + "/" + fini[0] + "/" + fini[2]);

            var ffin = $('#txfecfin').val().split("/");
            var datefin = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);
            if (dateval < dateini || dateval > datefin) {
                $('#txfecha').val('');
                alert('La Fecha seleccionada esta fuera del rango del período, verifique');
                return false;
            }
            if ($('#txmov').val() == '') {
                alert('Debe colocar el Movimiento a registrar');
                return false;
            }
            return true;
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
        function cargalista() {
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var anio = periodo.substring(3, 7);
            PageMethods.asistencias($('#txnoemp').val(), $('#dlperiodo').val(), tipo, anio, function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').change('.tbeditar', function () {
                    $(this).closest('tr').find("input:eq(0)").val($(this).closest('tr').find("input:eq(0)").val().toUpperCase())
                    if (esvalida($(this).closest('tr').find("input:eq(0)").val())) {
                    } else {
                        alert('La letra que ha colocado no es válida en el registro de asistencia');
                        $(this).closest('tr').find("input:eq(0)").val('')
                        $(this).closest('tr').find("input:eq(0)").focus();
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus1', function () {
                    $(this).parent().eq(0).parent().eq(0).remove();
                });
            }, iferror);
        }
        function esvalida(letra) {
            if (letra == 'A' || letra == 'F' || letra == 'FJ' || letra == 'N'
                || letra == 'V' || letra == 'IEG' || letra == 'IRT' || letra == 'D')
                return true;
            else
                return false;
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
        <!--<asp:HiddenField ID="idcliente" runat="server" />-->
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" Value="0" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idencargado" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
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
                    <h1>Ajuste de asistencias<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Asistencias</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnoemp">No. Empleado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input id="txnoemp" class="form-control" />
                                </div>
                                <!--
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca1" />
                                </div>
                                -->
                                <div class="col-lg-4">
                                    <input id="txempleado" class="form-control" disabled="disabled" />
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
                                <div class="col-lg-2 text-right">
                                    <label for="txfecini">F. Inicio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 right">
                                    <input type="button" class="btn btn-primary" value="Mostrar" id="btmostrar" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-3">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txmov">Movimiento:</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txmov" class="form-control" />
                                </div>
                                <div class="col-lg-1 right">
                                    <input type="button" class="btn btn-success" value="Agregar registro" id="btagrega" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id</span></th>
                                    <th class="bg-navy"><span>Inmueble</span></th>
                                    <th class="bg-navy"><span>F. Registro</span></th>
                                    <th class="bg-navy"><span>Movimiento</span></th>
                                </tr>
                            </thead>
                        </table>
                        <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
