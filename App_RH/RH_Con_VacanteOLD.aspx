<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_Vacante.aspx.vb" Inherits="App_RH_RH_Con_Vacante" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE VACANTES</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>

    <style>
        .tbborrar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e801';
        }
        .tbeditar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e802';
        }
        .tbaprobar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\F064';
        }
        .tbliberar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\F032';
        }
        .tbreingresa:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\E803';
        }
        #tblista tbody td:nth-child(23){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        var dialog; var dialog1;
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecing').datepicker({ dateFormat: 'dd/mm/yy' });
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
            PageMethods.empleadoop($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idempleado').val(datos.id);
                $('#idpuesto').val(datos.puesto);
                cargaempleado();
            }, iferror)
            cargacliente();   
            cargaencargado();
;           PageMethods.permiso($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#revisa').val(datos.permiso);
            }, iferror)

            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
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
            $('#btconsulta').on('click', function () {
                $('#hdpagina').val(1);
                cuentavacante();
                cuentatotal();
                cargalista();
            });
            $('#btactualiza1').click(function () {
                if ($('#dlrecluta').val() != 0) {
                    PageMethods.asignarecluta(parseInt($('#lbfolio').text()), parseInt($('#dlrecluta').val()), function () {
                        alert('Se ha asignado correctamente al Reclutador')
                        cargalista();
                        dialog.dialog('close');
                    }, function (err) {
                        console.error(err);
                    });
                } else { alert('Debe elegir un Reclutador');}
            });
            $('#btactualiza2').click(function () {
                if (valida()) {
                    PageMethods.estatus(parseInt($('#dlstatus').val()), parseInt($('#lbfolio1').text()), $('#txnvoemp').val(), $('#txmetodo').val(), $('#txfecing').val(), function () {
                        alert('El Estatus de la vacante se ha actualizado');
                        cargalista();
                        dialog1.dialog('close');
                    }, function (err) {
                        console.error(err);
                    });
                }
            }); 
            $('#btbuscaemp').click(function () {
                cargareingreso();
            })
            $('#btexporta').click(function () {
                window.open('RH_Descarga_vacante.aspx?cliente='+ $('#dlcliente').val() + '&fecini='+ $('#txfecini').val() +' &fecfin='+ $('#txfecfin').val() +' &estatus=' + $('#dlestatus').val() + ' &sucursal='+ $('#dlsucursal').val() + '&gerente='+ $('#dlgerente').val(), '_blank');
            })
            $('#btexporta1').click(function () {
                window.open('RH_Descarga_vacante.aspx?cliente='+ $('#dlcliente').val() + '&fecini='+ $('#txfecini').val() +' &fecfin='+ $('#txfecfin').val() +' &estatus=' + $('#dlestatus').val() + ' &sucursal='+ $('#dlsucursal').val() + '&gerente='+ $('#dlgerente').val(), '_blank');
            })
        });
        
        function cargaencargado() {
            PageMethods.empleado('esencargado', function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').empty();
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
            }, iferror);
        }
        
        function cargareingreso() {
            PageMethods.reingresoempleado($('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllista1 tbody').remove();
                $('#tbllista1').append(ren);
                $('#tbllista1 tbody tr').on('click', function () {
                    window.open('RH_Cat_Empleado.aspx?idempleado=' + $(this).closest('tr').find('td').eq(0).text() + '&idvacante=' + $('#lbfolio1').text(), '_blank');
                    dialog1.dialog('close');
                });
            });
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentavacante() {
            
            PageMethods.contarvacante($('#dlcliente').val(), $('#txfecini').val(), $('#txfecfin').val(), $('#dlestatus').val(), $('#dlsucursal').val(), $('#dlgerente').val(),  function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cuentatotal() {
            PageMethods.contartotal($('#dlcliente').val(), $('#txfecini').val(), $('#txfecfin').val(), $('#dlestatus').val(), $('#dlsucursal').val(), $('#dlgerente').val(), function (cont) {
                var opt = eval('(' + cont + ')');
                $('#txtotal').val(opt.total);
            }, iferror);
        }
        function valida() {
            if ($('#dlstatus').val() == 0) {
                alert('Debe seleccionar el estatus a cambiar');
                return false;
            }
            if ($('#dlstatus').val() == 2 && $('#txnvoemp').val() == '') {
                alert('Debe capturar el nombre del Empleado contratado');
                return false;
            }
            if ($('#dlstatus').val() == 2 && $('#txmetodo').val() == '') {
                alert('Debe capturar el medio de reclutamiento');
                return false;
            }
            if ($('#dlstatus').val() == 2 && $('#txfecing').val() == '') {
                alert('Debe indicar la fecha de ingreso programada');
                return false;
            }
            return true;
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
            waitingDialog({});
            PageMethods.vacantes($('#dlcliente').val(), $('#txfecini').val(), $('#txfecfin').val(), $('#dlestatus').val(), $('#revisa').val(), $('#idpuesto').val(), $('#hdpagina').val(), $('#dlsucursal').val(), $('#dlgerente').val(), function (res) {
                closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista table tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista table tbody').remove();
                    $('#tblista table').append(ren);
                    $('#tblista table tbody tr').on('click', '.tbeditar', function () {
                        switch ($(this).closest('tr').find('td').eq(13).text()) {
                            case 'Cubierta por confirmar':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Confirmado-activo':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada previamente');
                                break;
                            default:
                                var res = confirm("Esta seguro de cancelar esta vacante?");
                                if (res == true) {
                                    PageMethods.cancelavacante($(this).closest('tr').find('td').eq(4).text(),  function () {
                                        alert('La vacante ha sido cancelada')
                                        cargalista();
                                    }, iferror);
                                }
                                break;
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbaprobar', function () {
                        switch ($(this).closest('tr').find('td').eq(13).text()) {
                            case 'Cubierta por confirmar':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Confirmado-activo':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                $('#lbfolio').text($(this).closest('tr').find('td').eq(4).text());
                                $('#lbinmueble').text($(this).closest('tr').find('td').eq(5).text());
                                $('#dlrecluta').val(0);
                                $("#divmodal").dialog('option', 'title', 'Asignar Reclutador');
                                dialog.dialog('open');
                                break;
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbliberar', function () {
                        switch ($(this).closest('tr').find('td').eq(13).text()) {
                            case 'Cubierta por confirmar':
                                alert('Esta vacante ya ha sido cubierta');
                                break;
                            case 'Confirmado-Activo':
                                alert('Esta vacante ya ha sido cubierta');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                if ($(this).closest('tr').find('td').eq(14).text() == '') {
                                    alert('Para poder registrar candidatos, la vacante debe tener asignado un reclutador')
                                } else {
                                    var mywin = window.open('RH_Cat_Empleado.aspx?idvacante=' + $(this).closest('tr').find('td').eq(4).text(), '_blank');
                                    break;
                                }
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbreingresa', function () {
                        switch ($(this).closest('tr').find('td').eq(13).text()) {
                            case 'Cubierta por confirmar':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Confirmado-activo':
                                alert('Esta vacante ya ha sido cubierta no puede cancelar');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                if ($(this).closest('tr').find('td').eq(14).text() == '') {
                                    alert('Para poder registrar un reingreso, la vacante debe tener asignado un reclutador')
                                } else {
                                    $('#lbfolio1').text($(this).closest('tr').find('td').eq(4).text());
                                    $('#lbinmueble1').text($(this).closest('tr').find('td').eq(5).text());
                                    $('#tbllista1 table tbody').remove();
                                    $("#divmodal1").dialog('option', 'title', 'Reingresar empleado');
                                    dialog1.dialog('open');
                                    break;
                                }
                        }
                    });
                }
            }, iferror);
        }
        function cargaempleado() {
            PageMethods.reclutador($('#idempleado').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlrecluta').append(inicial);
                $('#dlrecluta').append(lista);
            });
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Consulta...');
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
        <asp:HiddenField ID="idcte" runat="server" Value="0"/>
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
        <asp:HiddenField ID="idempleado" runat="server" value="0"/>
        <asp:HiddenField ID="idpuesto" runat="server" value="0" />
        <asp:HiddenField ID="revisa" runat="server" value="0"/>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <div class="wrapper">  
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home1.aspx" class="logo">
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
                 
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Consulta de Vacantes
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Orden de compra</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
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
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecini">Fecha Inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-3 text-right">
                                    <label for="txfecfin">Fecha Final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control">
                                        <option value="1">Sin cubrir</option>
                                        <option value="2">Cubierta por confirmar</option>
                                        <option value="3">Confirmado-Activo</option>
                                        <option value="4">Cancelada</option>
                                    </select>
                                </div >
                                
                                <div class="col-lg-3 text-right">
                                    <label for="dlestatus">Gerente:</label>
                                </div>
                                 <div class="col-lg-3">
                                    <select id="dlgerente" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4 text-right">
                                    <label>Total de vacantes:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotal" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevoinm1"  class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>
                                <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                            </ol>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"><span>Id</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Pto Atn</span></th>
                                            <th class="bg-light-blue-gradient"><span>Solicita</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Registro</span></th>
                                            <th class="bg-light-blue-gradient"><span>Tipo</span></th>
                                            <th class="bg-light-blue-gradient"><span>RH</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Comp</span></th>
                                            <th class="bg-light-blue-gradient"><span>Semaforo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                            <th class="bg-light-blue-gradient"><span>Reclutador</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ubicación</span></th>
                                            <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sueldo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sexo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                            <th class="bg-light-blue-gradient"><span>Horarios</span></th>
                                            <th class="bg-light-blue-gradient"><span>Observaciones</span></th>
                                            <th class="bg-light-blue-gradient"></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevoinm"  class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>
                                    <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                                </ol>
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
                <div id="divmodal">
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Folio:</label>
                        </div>
                        <div class="col-lg-2">
                            <label id="lbfolio" ></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Punto de atención:</label>
                        </div>
                        <div class="col-lg-4">
                            <label id="lbinmueble"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Reclutador:</label>    
                        </div>
                        <div class="col-lg-5">
                            <select id="dlrecluta" class="form-control"></select>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" id="btactualiza1" value="Actualizar" class="btn btn-info pull-right">Actualizar</button>
                        </div>
                    </div>
                </div>
                <div id="divmodal1">
                    <div class="row">
                        <div class="col-lg-2">
                            <label>Vacante:</label>
                        </div>
                        <div class="col-lg-2">
                            <label id="lbfolio1" ></label>
                            
                        </div>
                        <div class="col-lg-4">
                            <label id="lbinmueble1"></label>
                        </div>
                    </div>
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
                                <option value="paterno+' '+RTRIM(materno)+ ' '+nombre">Nombre</option>
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
                                    <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                    <th class="bg-light-blue-gradient"><span>CRUP</span></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
