<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Asistenciajornalero.aspx.vb" Inherits="App_CGO_CGO_Pro_Asistenciajornalero" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE JORNALEROS</title>
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
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            cargaperiodo();
            cargacliente();
            cargaturno();
            $('#txnoemp').change(function () {
                cargajornalero();
            })
            $('#btagrega').click(function () {
                if (validaemp()) {
                    var linea = '<tr><td>' + $('#dlcliente').val() + '</td><td>' + $('#dlcliente option:selected').text() + '</td><td>' + $('#dlsucursal').val() + '</td><td>' + $('#dlsucursal option:selected').text() + '</td><td>' + $('#txnoemp').val() + '</td><td>'
                    linea += $('#txempleado').val() + '</td><td>' + $('#dlturno option:selected').text() + '</td><td>' + $('#txfecha').val() + '</td><td>' + $('#tximporte').val() + '</td><td>' + $('#dlturno').val() + '</td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    
                    $('#tblista tbody').append(linea);
                    $('#tblista').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                    });
                    limpiajornalero();
                }
            })
            $('#btguarda').click(function () {
                
                if (validalista()) {
                    waitingDialog({});
                    var periodo = $('#dlperiodo option:selected').text();
                    var anio = periodo.substring(3, 7);
                    var tipo = periodo.substring(8, periodo.length);
                    var xmlgraba = '';
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        var fecha = $('#tblista tbody tr').eq(x).find('td').eq(7).text().split('/');
                        var finicio = fecha[2] + fecha[1] + fecha[0];
                        
                        xmlgraba += '<partida periodo = "' + $('#dlperiodo').val() + '" fecha = "' + finicio + '" tipo = "' + tipo + '" anio = "' + anio + '"';
                        xmlgraba += ' cliente ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" inmueble ="' + $('#tblista tbody tr').eq(x).find('td').eq(2).text() + '" empleado="' + $('#tblista tbody tr').eq(x).find('td').eq(4).text() + '"'
                        xmlgraba += ' turno="' + $('#tblista tbody tr').eq(x).find('td').eq(9).text() + '" importe="' + $('#tblista tbody tr').eq(x).find('td').eq(8).text() + '"/>'
                    }
                    PageMethods.guarda(xmlgraba, function () {
                        closeWaitingDialog();
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btbuscar').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Buscar empleado');
                dialog1.dialog('open');
            })
            $('#btbuscaemp').click(function () {
                cargaempleado();
            })
        })
        function validalista() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir un período de nomina');
                return false;
            }
            if ($('#tblista tbody tr').length == 0) {
                alert('Debe capturar al menos un jornalero en la asistencia');
                return false;
            }
            return true;
        }
        function cargalista() {
            //waitingDialog({});
            var periodo = $('#dlperiodo option:selected').text()
            var tipo = periodo.substring(8, periodo.length);
            var anio = periodo.substring(3, 7);
            PageMethods.asistencia($('#dlperiodo').val(), tipo, anio,  function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (res != '') {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                } else {
                    res ='<tbody></tbody>'
                    $('#tblista').append(ren);
                }
                /*
                $('#tblista tbody tr').on('click', '.tbstatus1', function () {
                    if ($(this).closest('tr').find('input').eq(1).val() == 'N') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(1).val('S');
                        $(this).closest('tr').find('input').eq(1).addClass("btn-success").removeClass("btn-secundary")
                    }
                });*/
            })
        }
        function limpiajornalero() {
            $('#txnoemp').val('');
            $('#txempleado').val('');
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#dlturno').val(0);
            $('#txfecha').val('');
            $('#tximporte').val('');
        }
        function validaemp() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir un período de nomina');
                return false;
            }
            if ($('#txnoemp').val() == '' ) {
                alert('Debe capturar el numero de jornalero');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe seleccionar un cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe seleccionar un punto de atención');
                return false;
            }
            if ($('#dlturno').val() == 0) {
                alert('Debe seleccionar un turno');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe seleccionar una fecha');
                return false;
            }
            if (isNaN($('#tximporte').val())) {
                alert('Debe capturar un importe');
                return false;
            }
            if ($('#tximporte').val() == '') {
                alert('Debe capturar un importe');
                return false;
            }
            var fini = $('#txfecini').val().split("/");
            var dateini = new Date(fini[1] + "/" + fini[0] + "/" + fini[2]);

            var ffin = $('#txfecfin').val().split("/");
            var datefin = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);

            var freg = $('#txfecha').val().split("/");
            var dateval = new Date(freg[1] + "/" + freg[0] + "/" + freg[2]);

            if (dateval < dateini || dateval > datefin) {
                $('#txfecha').val('');
                alert('La Fecha seleccionada esta fuera del rango del período, verifique');
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
        function cargajornalero() {
            PageMethods.jornalero($('#txnoemp').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.idemp == 0) {
                    alert('Debe colocar un numero de jornalero valido');
                    $('#txnoemp').val('');
                    $('#txnoemp').focus();
                } else {
                    $('#txnoemp').val(datos.idemp);
                    $('#txempleado').val(datos.nombre);
                }
                
            });
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
                        cargalista();
                    });
                });
            }, iferror);
        }
        function cargaempleado() {
            PageMethods.empleadolista($('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllista1 tbody').remove();
                $('#tbllista1').append(ren);
                $('#tbllista1 tbody tr').on('click', function () {
                    $('#txnoemp').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txempleado').val($(this).closest('tr').find('td').eq(1).text());
                    //$('#txempresa').val($(this).closest('tr').find('td').eq(2).text());
                    //$('#idempresa').val($(this).closest('tr').find('td').eq(3).text());
                    //window.open('RH_Cat_Empleado.aspx?idempleado=' + $(this).closest('tr').find('td').eq(0).text() + '&idvacante=' + $('#lbfolio1').text(), '_blank');
                    dialog1.dialog('close');
                });
            });
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
                    <h1>Registro de asistencia jornaleros<small>Recursos humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Asistencia</li>
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
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnoemp">No Jornalero:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input id="txnoemp" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscar" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txempleado">Empleado:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input id="txempleado" class="form-control" disabled="disabled" />
                                </div>
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
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control">
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlturno">Turno:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlturno" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="tximporte">Importe:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="tximporte" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Agregar" id="btagrega" />
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
                                            <th class="bg-navy"><span>Cliente</span></th>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Punto de atención</span></th>
                                            <th class="bg-navy"><span>No. Jornalero</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Turno</span></th>
                                            <th class="bg-navy"><span>Fecha</span></th>
                                            <th class="bg-navy"><span>Importe</span></th>
                                            <th class="bg-navy"></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
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
                    <div id="divmodal1">
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="dlbusca">Busca por:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlbusca" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="id_empleado">No. emp.</option>
                                <option value="rfc">RFC</option>
                                <option value="curp">CURP</option>
                                <option value="paterno+' '+RTRIM(materno)+ ' '+a.nombre">Nombre</option>
                            </select>
                        </div>
                        <div class="col-lg-5">
                            <input type="text" id="txbusca" class="form-control" />
                        </div>
                        <div class="col-lg-1">
                            <button type="button" id="btbuscaemp" value="Buscar" class="btn btn-info pull-right">Buscar</button>
                        </div>
                    </div>
                    <div class="row tbheader">
                        <table class="table table-condensed h6" id="tbllista1">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>Id</span></th>
                                    <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                    <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
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
