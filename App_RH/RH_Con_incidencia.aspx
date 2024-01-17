<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_incidencia.aspx.vb" Inherits="App_RH_RH_Con_incidencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE INCIDENCIAS</title>
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
            cargaperiodo();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 400,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#btbusca1').on('click', function () {
                $("#divmodal").dialog('option', 'title', 'Buscar Empleado');
                $('#tbbusca tbody').remove();
                $('#txbusca').val('');
                dialog.dialog('open');
            });
            $('#btbusca').click(function () {
                if ($('#txbusca').val() != '') {
                    cargaempleado($('#txbusca').val());
                } else {
                    alert('Debe capturar un valor de búsqueda');
                }
            })
            $('#txnoemp').change(function () {
                PageMethods.detempleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txempleado').val(datos.nombre);
                });
            })
            $('#btmostrar').click(function () {
                $('#tblista tbody').remove();
                if (valida()) {
                    cargalista();
                }
            })
        });
        function cargalista() {
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var anio = periodo.substring(3, 7);
            PageMethods.incidencias($('#txnoemp').val(), $('#dlperiodo').val(), tipo, anio, function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.tbstatus1', function () {
                    PageMethods.elimina($('#txnoemp').val(), $(this).closest('tr').find('td').eq(0).text(), $('#dlperiodo').val(), tipo, anio, function (res) {
                        alert('Registro eliminado');
                        cargalista();
                    }, iferror);
                });
            }, iferror);
        }
        function valida() {
            if ($('#txnoemp').val() == '') {
                alert('Debe capturar un numero de empleado');
                return false;
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe seleccionar un Período');
                return false;
            }
            return true;
        }
        function cargaempleado() {
            PageMethods.empleado($('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                $('#tbbusca tbody tr').click(function () {
                    $('#txnoemp').val($(this).children().eq(0).text());
                    $('#txempleado').val($(this).children().eq(1).text());
                    dialog.dialog('close');
                });
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
                    <h1>Eliminar incidencias<small>Recursos humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Incidencias</li>
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
                                    <label for="txnoemp">No. Empleado:</label>
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
                                    <input id="txempleado" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca1" />
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
                    </div>
                    <div class="row" id="dvtabla">
                        <table class="table table-condensed h6" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id</span></th>
                                    <th class="bg-navy"><span>Incidencia</span></th>
                                    <th class="bg-navy"><span>F. Registro</span></th>
                                    <th class="bg-navy"><span>Cantidad</span></th>
                                    <th class="bg-navy"><span>Monto</span></th>
                                </tr>
                            </thead>
                        </table>
                        <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <div id="divmodal">
            <div class="box-header"></div>
            <div class="row">
                <div class="col-lg-2 text-right">
                    <label for="txbusca">Buscar</label>
                </div>
                <div class="col-lg-5">
                    <input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />
                </div>
                <div class="col-lg-1">
                    <input type="button" class="btn btn-primary" value="Mostrar" id="btbusca" />
                </div>
            </div>
            <div class="tbheader">
                <table class="table table-condensed" id="tbbusca">
                    <thead>
                        <tr>
                            <th class="bg-navy"><span>No. Empleado</span></th>
                            <th class="bg-navy"><span>Empleado</span></th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
