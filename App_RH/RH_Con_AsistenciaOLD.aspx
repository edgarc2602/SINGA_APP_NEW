<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_Asistencia.aspx.vb" Inherits="App_RH_RH_Con_Asistencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE ASISTENCIA</title>
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
            $('#dlsucursal').append(inicial);
            cargaperiodo();
            cargacliente();
            cargaturno();
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
                    cuentaasistencia();
                    cargalista();
                }
            })
            $('#btexporta').click(function () {
                var periodo = $('#dlperiodo option:selected').text()
                var tipo = periodo.substring(8, periodo.length);
                var per = 1
                if (tipo == 'Semanal') {
                    per = 2
                }
                window.open('RH_Descarga_Asistencia.aspx?cliente=' + $('#dlcliente').val() + '&inmueble=' + $('#dlsucursal').val() + '&fecini=' + $('#txfecini').val() + '&fecfin=' + $('#txfecfin').val() + '&per=' + per + '&turno=' + $('#dlturno').val(), '_blank');
            })
        });
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaasistencia() {
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.contarasistencia($('#dlcliente').val(), $('#dlsucursal').val(), $('#txfecini').val(), $('#txfecfin').val(), per, $('#dlturno').val(), function (cont) {
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
            waitingDialog({});
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var per = 1
            if (tipo == 'Semanal') {
                per = 2
            }
            PageMethods.asistencia($('#hdpagina').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#txfecini').val(), $('#txfecfin').val(), per, $('#dlturno').val(), function (res) {
                closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#dvtabla table').remove();
                $('#dvtabla').append(ren);
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
            }, iferror);
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
        function valida() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe selecionar un Periodo de nomina');
                return false;
            }
            return true;
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
                    <h1>Consulta de asistencia<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Consulta de asistencia</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-12">
                            <!-- Horizontal Form -->
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
                                    <div class="col-lg-1 right">
                                        <input type="button" class="btn btn-primary" value="Mostrar" id="btmostrar" />
                                    </div>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="box box-info">
                                    <div class="col-md-18 tbheader" id="dvtabla">
                                        <table class="table table-condensed h6" id="tblista">
                                            <thead>
                                                <tr>
                                                    <th class="bg-navy"><span>Cliente</span></th>
                                                    <th class="bg-navy"><span>Punto de atención</span></th>
                                                    <th class="bg-navy"><span>No. Empleado</span></th>
                                                    <th class="bg-navy"><span>Nombre</span></th>
                                                    <th class="bg-navy"><span>1</span></th>
                                                    <th class="bg-navy"><span>2</span></th>
                                                    <th class="bg-navy"><span>3</span></th>
                                                    <th class="bg-navy"><span>4</span></th>
                                                    <th class="bg-navy"><span>5</span></th>
                                                    <th class="bg-navy"><span>6</span></th>
                                                    <th class="bg-navy"><span>7</span></th>
                                                </tr>
                                            </thead>
                                        </table>
                                        <ol class="breadcrumb">
                                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                            <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                                            <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir Registros</a></li>-->
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
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
