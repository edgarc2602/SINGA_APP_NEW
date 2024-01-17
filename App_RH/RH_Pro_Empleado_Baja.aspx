<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Empleado_Baja.aspx.vb" Inherits="App_RH_RH_Pro_Empleado_Baja" %>

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
        
        #tblista tbody td:nth-child(8),#tblista tbody td:nth-child(9),#tblista tbody td:nth-child(11),#tblista tbody td:nth-child(12){
            width:0px;
            display:none;
        }
        .cb{
            width: 25px; 
            height: 25px; 
        }
    </style>
        
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvconfirma').hide();
            $('#dlsucursal').append(inicial);
            $('#dvvancate').hide();
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
            cargamotivo();
            cargacliente();
            /*
            PageMethods.empleadoop(parseInt($('#idusuario').val()), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idempleado').val(datos.id);
                
                cargacoordina();
            });
            */
            $('#btmostrar').click(function () {
                if (validainm()) {
                    waitingDialog({});
                    cuentaempleado(); 
                    cargalista();
                    totalempleado();
                }
            })
            $('#btguarda').on('click', function () {
                if (valida()) {
                    var vacante = 0
                    if ($("#cbvacante").is(':checked')) {
                        vacante = 1
                    }
                    // ESTA MODIFICACION ES PARA VALIDAR LAS POSICIONES DE PLANTILLA CUBIERTAS VS PERSONAL ACTIVO
                    PageMethods.validaposiciones($('#idplantilla').val(), $('#txidemp').val(), vacante, function (detalle) {
                        var datos = eval('(' + detalle + ')');

                        if (parseInt(datos.activos) >= parseInt(datos.espacios)) {
                            alert('Al aplicar la baja de este empleado no puede generar vacante ya que las posiciones actuales de plantilla superan o cubren la cantidad de personal autorizado');
                            return false;
                        } else {
                            waitingDialog({});
                            var fini = $('#txfecha').val().split('/');
                            var finicio = fini[2] + fini[1] + fini[0];
                            var xmlgraba = '<vacante id= "' + $('#txid').val() + '" tipo = "1" cliente = "' + $('#dlcliente').val() + '" inmueble= "' + $('#dlsucursal').val() + '" ubicacion ="1" puesto = "' + $('#idpuesto').val() + '" turno = "' + $('#idturno').val() + '" ';
                            xmlgraba += ' experiencia= "' + $('#txexperiencia').val() + '" observacion= "' + $('#txobservacion').val() + '" usuario="' + $('#idusuario').val() + '" ';
                            xmlgraba += ' idemp = "' + $('#txidemp').val() + '" fbaja = "' + finicio + '" coordina = "' + $('#idcoordina').val() + '" vacantesi= "' + vacante + '" '
                            xmlgraba += ' motivo= "' + $('#dlmotivo').val() + '" plantilla= "' + $('#idplantilla').val() + '" comentbaja= "' + $('#txcomentbaja').val() + '" posicion= "' + $('#posicion').val() + '"/>'
                            var f = new Date();
                            var mm = f.getMonth() + 1
                            if (mm.toString.length == 1) {
                                mm = "0" + mm
                            }
                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                            //alert(xmlgraba);
                            
                            PageMethods.guarda(xmlgraba, fecha, $('#dlcliente option:selected').text(), $('#txpuesto').val(), $('#dlsucursal option:selected').text(), $('#txubicacion').val(), $('#txdefinicion').val(), $('#txfecha').val(), $('#txidemp').val(), $('#dlcliente').val(), vacante, $('#dlmotivo option:selected').text(), function (res) {
                                closeWaitingDialog();
                                $('#txid').val(res)
                                alert('Registro completado.');
                            }, iferror);
                        }
                    }, iferror);
                }
            })
            $('#btlista').click(function () {
                $('#tblista').show();
                $('#dvdatos').hide();
                cargalista() 
                limpia();
            })
            $('#btnuevo').click(function () {
                $('#tblista').show();
                $('#dvdatos').hide();
                limpia();
            })
            $('#cbvacante').click(function () {
                if ($("#cbvacante").is(':checked')) {
                    $('#dvvancate').show();
                } else {
                    $('#dvvancate').hide();
                }
            })
        });
        function cargamotivo() {
            PageMethods.motivos( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlmotivo').append(inicial);
                $('#dlmotivo').append(lista);
            }, iferror);
        }
        function limpia() {
            $('#txidemp').val('');
            $('#txnombre').val('');
            $('#txrfc').val('');
            $('#txcurp').val('');
            $('#txss').val('');
            $('#txpuesto').val('');
            $('#txturno').val('');
            $('#idpuesto').val('');
            $('#idturno').val('');
            $('#txid').val(0);
            $('#dltipo').val(0);
            $('#txfecha').val('');
            $('#dlubicacion').val(0);
            $('#txexperiencia').val('');
            $('#txobservacion').val('');
            $('#dlmotivo').val(0);
        }
        function validainm() {
            if ($('#txnoemp').val() == '' && $('#txnombrebusca').val() == '') {
                if ($('#dlcliente').val() == 0) {
                    alert('Debe seleccionar al menos un Cliente');
                    return false;
                }
            }
            /*if ($('#dlsucursal').val() == 0) {
                alert('Debe seleccionar un Punto de atención');
                return false;
            }*/
            return true 
        }
        function valida() {
            if ($('#txid').val() != 0) {
                alert('El registro de baja ya ha sido guardado, no puede duplicar');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe seleccionar un Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe seleccionar un Punto de atención');
                return false;
            }
            if ($('#dlmotivo').val() == '') {
                alert('Debe seleccionar el motivo de la baja');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe capturar la fecha de baja');
                return false;
            }
            if ($("#cbvacante").is(':checked')) {
                if ($('#dltipo').val() == 0) {
                    alert('Debe seleccionar el tipo de vacante');
                    return false;
                }
                if ($('#dlubicacion').val() == 0) {
                    alert('Debe seleccionar la ubicación de la vacante');
                    return false;
                }
            }
            if ($('#idplantilla').val() == 0) {
                alert('Este empleado no esta asociado con ninguna plantilla, para poder aplicar su baja necesita validar con el área de sistemas');
                return false;
            }
            return true 
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaempleado() {
            var noemp = 0
            if ($('#txnoemp').val() != '') {
                noemp = $('#txnoemp').val();
            }
            PageMethods.contarempleado($('#dlcliente').val(), $('#dlsucursal').val(), noemp, $('#txnombrebusca').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargacliente() {
            PageMethods.cliente( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    cargacoordina()
                    $('#tblista table tbody').remove();
                    cargainmueble($('#dlcliente').val());
                });
            }, iferror);
        }
        function cargacoordina() {
            PageMethods.coordina($('#dlcliente').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txcoordina').val(datos.nombre);
                $('#idcoordina').val(datos.id);
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
                $('#dlsucursal').change(function () {
                    $('#tblista table tbody').remove();
                    PageMethods.ubicacion($('#dlsucursal').val(), function (res) {
                        var datos = eval('(' + res + ')');
                        $('#txubicacion').val(datos.ubicacion);
                    });
                })
            }, iferror);
        }
        function totalempleado() {
            var noemp = 0
            if ($('#txnoemp').val() != '') {
                noemp = $('#txnoemp').val();
            }
            PageMethods.totalempleados($('#dlcliente').val(), $('#dlsucursal').val(), noemp, $('#txnombrebusca').val(), function (res) {
                var datos = eval('(' + res + ')');
                $('#txtotalemp').val(datos.total);
            });
        }
        function cargalista() {
            var noemp = 0
            if ($('#txnoemp').val() != '') {
                noemp = $('#txnoemp').val();
            }
            PageMethods.empleados($('#hdpagina').val(), $('#dlcliente').val(), $('#dlsucursal').val(), noemp,$('#txnombrebusca').val(), function (res) {
                closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista tbody tr').on('click', function () {
                    /*if ($(this).children().eq(9).text() == 'Baja Programada') {
                        $('#dvconfirma').show();
                    } else {
                        $('#dvconfirma').hide();
                        nobloquea();
                    }*/
                    $('#txidemp').val($(this).children().eq(0).text());
                    $('#txnombre').val($(this).children().eq(1).text());
                    $('#txrfc').val($(this).children().eq(2).text());
                    $('#txcurp').val($(this).children().eq(3).text());
                    $('#txss').val($(this).children().eq(4).text());
                    $('#txpuesto').val($(this).children().eq(5).text());
                    $('#txturno').val($(this).children().eq(6).text());
                    $('#idpuesto').val($(this).children().eq(7).text());
                    $('#idturno').val($(this).children().eq(8).text());
                    PageMethods.datosextra($(this).children().eq(10).text(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txdefinicion').val(datos.horario);
                    }, iferror);
                    $('#idplantilla').val($(this).children().eq(10).text());
                    $('#posicion').val($(this).children().eq(11).text());
                    //cargabaja($(this).children().eq(0).text());
                    $("#cbvacante").prop("checked", false);
                    $('#dvvancate').hide();
                    $('#tblista').hide();
                    $('#dvdatos').show();
                });
            }, iferror);
        }
        function cargabaja(idemp) {
            PageMethods.baja(idemp, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfecha').val(datos.fprogramada);
                $('#txid').val(datos.vacante);
                $('#dltipo').val(datos.tipo);
                $('#dlubicacion').val(datos.ubicacion);
                $('#txexperiencia').val(datos.experiencia);
                $('#txobservacion').val(datos.observacion);
                bloquea();
            });
        }
        function bloquea() {
            $('#txfecha').prop("disabled", true);
            $('#dltipo').prop("disabled", true);
            $('#dlubicacion').prop("disabled", true);
            $('#txexperiencia').prop("disabled", true);
            $('#txobservacion').prop("disabled", true);
        }
        function nobloquea() {
            $('#txfecha').prop("disabled", false);
            $('#dltipo').prop("disabled", false);
            $('#dlubicacion').prop("disabled", false);
            $('#txexperiencia').prop("disabled", false);
            $('#txobservacion').prop("disabled", false);
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" />
        <asp:HiddenField ID="idempleado" runat="server" />
        <asp:HiddenField ID="idpuesto" runat="server" />
        <asp:HiddenField ID="idturno" runat="server" />
        <asp:HiddenField ID="idcoordina" runat="server" />
        <asp:HiddenField ID="idplantilla" runat="server" />
        <asp:HiddenField ID="posicion" runat="server" />
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
                <div class="sidebar" id="var1">
                </div>
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Baja de Empleado<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Baja de Empleado</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row">
                        <div class="box box-info">
                            <!-- Horizontal Form -->
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-4">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnoemp">No. Empleado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoemp" class="form-control" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txnombrebusca">Nombre:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombrebusca" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txtotalemp">Empleados activos:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotalemp" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Mostrar" id="btmostrar" />
                                </div>
                            </div>
                            
                        </div>
                        <div id="dvdatos" class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txidemp">No. Empleado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txidemp" class="form-control" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txrfc">RFC:</label>
                                </div>
                                <div class="col-lg-2">
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
                                    <label for="txpuesto">Puesto:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txturno">Turno:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txturno" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcoordina">Coordinador RH:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcoordina" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlmotivo">Motivo de la baja:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlmotivo" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Comentarios de baja:</label>
                                </div>
                                <div class="col-lg-6">
                                    <textarea id="txcomentbaja" class="form-control"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha de baja:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div>
                                    <div class="col-lg-6 text-center">
                                        <input type="checkbox" id="cbvacante" class="cb"/><label for="cbvacante" style="font-size:20px;">La baja genera vacante</label>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row" id="dvvancate">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">Folio:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Ubicación:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txubicacion" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Datos para vacante:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <input type="text" id="txdefinicion" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <!--
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo de movimiento:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Urgente</option>
                                            <option value="2">Programada</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dlubicacion">Ubicación:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlubicacion" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Local</option>
                                            <option value="2">Foraneo</option>
                                        </select>
                                    </div>
                                </div>
                                -->
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txexperiencia">Experiencia laboral:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <textarea id="txexperiencia" class="form-control"></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txobservacion">Observaciones:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <input type="text" id="txobservacion" class="form-control" />
                                    </div>
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Salir</a></li>
                            </ol>
                        </div>
                    </div>
                    <div class="col-md-18 tbheader" id="tblista">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>No. Empleado</span></th>
                                    <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                    <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                    <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                    <th class="bg-light-blue-gradient"><span>No. SS</span></th>
                                    <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                    <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                    <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                </tr>
                            </thead>
                        </table>
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
