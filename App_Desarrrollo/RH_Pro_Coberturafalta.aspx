<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Coberturafalta.aspx.vb" Inherits="App_RH_RH_Pro_Coberturafalta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>COBERTURA DE FALTAS</title>
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
        #tblista tbody td:nth-child(8){
            width:80px;
        }
        #tblista tbody td:nth-child(9),#tblista tbody td:nth-child(4){
            width:200px;
        }
        #tblista tbody td:nth-child(11),#tblista tbody td:nth-child(12){
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
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            cargaperiodo();
            cargacliente();
            dialog2 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
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
                    //$('#hdpagina').val(1);
                    //cuentaempleado();
                    cargalista();
                }
            })
            $('#btbuscap').click(function () {
                $('#tbbusca tbody').remove();
                if (validaemp()) {
                    cargalistaemp();
                }
            })
            $('#btguarda').click(function () {
                waitingDialog({});
                
                var periodo = $('#dlperiodo option:selected').text();
                var anio = periodo.substring(3, 7);
                var tipo = periodo.substring(8, periodo.length);
                var fecha = '';
                //var finicio = '';
                var xmlgraba = '';
                for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                    //alert($(this).closest('tr').find('td').eq(10).text() );
                    if ($('#tblista tbody tr').eq(x).find('input').eq(1).val() != '' && $('#tblista tbody tr').eq(x).find('td').eq(10).text() == '0') {
                        xmlgraba += '<partida periodo ="' + $('#dlperiodo').val() + '" tipo ="' + tipo + '" anio="' + anio + '"'
                        xmlgraba += ' inmueble= "' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '"'
                        xmlgraba += ' empleado= "' + $('#tblista tbody tr').eq(x).find('td').eq(2).text() + '"'
                        fecha = $('#tblista tbody tr').eq(x).find('td').eq(4).text().split('/');
                        //finicio = ;
                        xmlgraba += ' fecha = "' + fecha[2] + fecha[1] + fecha[0] + '"';
                        xmlgraba += ' cubre= "' + $('#tblista tbody tr').eq(x).find('input').eq(1).val() + '"';
                        xmlgraba += ' tipoemp= "' + $('#tblista tbody tr').eq(x).find('td').eq(11).text() + '" />'
                    }
                };
                //alert(xmlgraba);
                PageMethods.guarda(xmlgraba, function () {
                    closeWaitingDialog();
                    cargalista();
                    alert('Registro completado.');
                }, iferror);
                
            })
        })
        function cargalistaemp() {
            PageMethods.listaempleado($('#dltipo').val(),$('#txbusca').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                $('#tbbusca tbody tr').click(function () {
                    $('#tblista tbody tr').eq($('#tbfila').val()).find('input').eq(1).val($(this).children().eq(0).text());
                    $('#tblista tbody tr').eq($('#tbfila').val()).find('input').eq(2).val($(this).children().eq(1).text());
                    var btn = '<input type="button" class="btquita btn btn-danger" value="Borrar" />'
                    $('#tblista tbody tr').eq($('#tbfila').val()).find('td').eq(9).append(btn);
                    $('#tblista tbody tr').eq($('#tbfila').val()).find('td').eq(10).text('0');
                    $('#tblista tbody tr').eq($('#tbfila').val()).find('td').eq(11).text($('#dltipo').val());
                   
                    dialog2.dialog('close');
                });

            }, iferror);
        }
        function validaemp() {
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de persona');
                return false;
            }
            if ($('#txbusca').val() == '') {
                alert('Debe colocar un numero de empleado o nombre a buscar');
                return false;
            }
            return true;
        }
        function cargalista() {
            //waitingDialog({});
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var anio = periodo.substring(3, 7);
            
            PageMethods.empleado($('#dlcliente').val(), $('#dlsucursal').val(), $('#txfecha').val(), $('#dlperiodo').val(), tipo, anio, function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btbusca', function () {
                    
                    $(this).closest('tr').find('input').eq(1).val('');
                    $(this).closest('tr').find('input').eq(2).val('');
                    $(this).closest('tr').find('input').eq(3).remove();
                    $('#tbfila').val($(this).closest('tr').index());
                    $("#divmodal1").dialog('option', 'title', 'Elegir Empleado');
                    dialog2.dialog('open');
                });
                $('#tblista tbody tr').on('click', '.btquita', function () {
                    
                    if ($(this).closest('tr').find('td').eq(11).text() == 1) {
                        $(this).closest('tr').find('input').eq(1).val('');
                        $(this).closest('tr').find('input').eq(2).val('');
                        PageMethods.elimina($(this).closest('tr').find('td').eq(2).text(), $('#dlperiodo').val(), anio, tipo, $(this).closest('tr').find('td').eq(0).text(), $(this).closest('tr').find('td').eq(4).text(),  function () {
                            //closeWaitingDialog();
                            cargalista();
                            //alert('Registro completado.');
                        }, iferror);
                    }
                });
            }, iferror);
        }
        function valida() {

            var freg = $('#txfecha').val().split("/");
            var dateval = new Date(freg[1] + "/" + freg[0] + "/" + freg[2]);
            var fdia = new Date
            var resta = fdia.getTime() - dateval.getTime()
            resta = Math.round(resta / (1000 * 60 * 60 * 24))

            var fini = $('#txfecini').val().split("/");
            var dateini = new Date(fini[1] + "/" + fini[0] + "/" + fini[2]);

            var ffin = $('#txfecfin').val().split("/");
            var datefin = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);

            if (dateval < dateini || dateval > datefin) {
                $('#txfecha').val('');
                alert('La Fecha seleccionada esta fuera del rando del período, verifique');
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
            /*
            if ($('#dlarea').val() == 0) {
                alert('Debe selecionar el área');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe selecionar una fecha para registro de asistencia');
                return false;
            }*/
            return true;
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
                    //cargaestado($('#dlcliente').val());
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
        <asp:HiddenField ID="tbfila" runat="server" />
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
                    <h1>Cobertura de faltas<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Cobertura de faltas</li>
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
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlperiodo">Período:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlperiodo" class="form-control"></select>
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
                                            <th class="bg-navy"><span>No. Empleado</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Falta</span></th>
                                            <th class="bg-navy"><span>Movimiento</span></th>
                                            <th class="bg-navy"></th>
                                            <th class="bg-navy"><span>Cubierta por</span></th>
                                            <th class="bg-navy"></th>
                                            <th class="bg-navy"></th>
                                            <th class="bg-navy"></th>
                                            <th class="bg-navy"></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir Registros</a></li>-->
                    </ol>
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Tipo de persona</label>
                                </div>
                                <div class="col-lg-5">
                                    <select class="form-control" id="dltipo">
                                        <option value="0">Sleccione...</option>
                                        <option value="1">Empleado</option>
                                        <option value="2">Jornalero</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label>
                                </div>
                                <div class="col-lg-5">
                                    <input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                </div>
                            </div>
                            <div class="tbheader">
                                <table class="table table-condensed" id="tbbusca">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>No. Emp</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Punto de atención</span></th>
                                        </tr>
                                    </thead>
                                </table>
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
