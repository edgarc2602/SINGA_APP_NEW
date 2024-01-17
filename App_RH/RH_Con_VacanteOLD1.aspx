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
    </style>
    <script type="text/javascript">
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        var dialog; var dialog1;
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecing').datepicker({ dateFormat: 'dd/mm/yy' });
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
            PageMethods.permiso($('#idusuario').val(), function (detalle) {
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
                height: 350,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#btconsulta').on('click', function () {
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
        });
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
                
            }, iferror);
        }
        function cargalista() {
            waitingDialog({});
            PageMethods.vacantes($('#dlcliente').val(), $('#txfecini').val(), $('#txfecfin').val(), $('#dlestatus').val(), $('#idempleado').val(), $('#revisa').val(), $('#idpuesto').val(), function (res) {
                closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista table tbody').remove();
                    $('#tblista table').append(ren);
                    $('#tblista table tbody tr').on('click', '.tbeditar', function () {
                        switch ($(this).closest('tr').find('td').eq(12).text()) {
                            case 'Cubierta':
                                alert('Esta vacante ya ha sido cubierta');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                var mywin = window.open('RH_Pro_Vacante.aspx?id=' + $(this).closest('tr').find('td').eq(3).text(), '_blank');
                                break;
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbaprobar', function () {
                        switch ($(this).closest('tr').find('td').eq(12).text()) {
                            case 'Cubierta':
                                alert('Esta vacante ya ha sido cubierta');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                $('#lbfolio').text($(this).closest('tr').find('td').eq(3).text());
                                $('#lbinmueble').text($(this).closest('tr').find('td').eq(5).text());
                                $('#dlrecluta').val(0);
                                $("#divmodal").dialog('option', 'title', 'Asignar Reclutador');
                                dialog.dialog('open');
                                break;
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbliberar', function () {
                        switch ($(this).closest('tr').find('td').eq(12).text()) {
                            case 'Cubierta':
                                alert('Esta vacante ya ha sido cubierta');
                                break;
                            case 'Cancelada':
                                alert('Esta vacante fue cancelada, no se puede modificar');
                                break;
                            default:
                                var mywin = window.open('RH_Cat_Empleado.aspx?idvacante=' + $(this).closest('tr').find('td').eq(3).text(), '_blank');
                                break;
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
        <asp:HiddenField ID="idcte" runat="server" Value="0"/>
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
        <asp:HiddenField ID="idempleado" runat="server" value="0"/>
        <asp:HiddenField ID="idpuesto" runat="server" value="0" />
        <asp:HiddenField ID="revisa" runat="server" value="0"/>
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
                 
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Lista de Vacantes
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Lista de vacantes</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecini">Fecha Inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecfin">Fecha Final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                                
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control">
                                        <option value="1">Sin cubrir</option>
                                        <option value="2">Cubierta por confirmar</option>
                                        <option value="3">Confirmado-Activo</option>
                                        <option value="3">Cancelada</option>
                                    </select>
                                </div>
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
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
                                            <th class="bg-light-blue-gradient"><span>Sueldo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sexo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                            <th class="bg-light-blue-gradient"><span>Horarios</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <!--<li id="btnuevoinm"  class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>-->
                                    <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                                </ol>
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
                        <div class="col-lg-4">
                            <label>Folio:</label>
                        </div>
                        <div class="col-lg-2">
                            <label id="lbfolio1" ></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label>Punto de atención:</label>
                        </div>
                        <div class="col-lg-4">
                            <label id="lbinmueble1"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label for="dlstatus">Estatus:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlstatus" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="2">Cubierta</option>
                                <option value="3">Cancelada</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label for="txnvoemp">Nombre del Empleado:</label>
                        </div>
                        <div class="col-lg-6">
                            <input type="text" id="txnvoemp" class="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4">
                            <label for="txmetodo">Medio de reclutamiento:</label>
                        </div>
                        <div class="col-lg-4">
                            <input type="text" id="txmetodo" class="form-control" />
                        </div>
                    </div>
                    <div class="row"> 
                        <div class="col-lg-4">
                            <label for="txfecing">Fecha de ingreso:</label>
                        </div>
                        <div class="col-lg-3">
                            <input type="text" id="txfecing" class="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <button type="button" id="btactualiza2" value="Actualizar" class="btn btn-info pull-right">Actualizar</button>
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
