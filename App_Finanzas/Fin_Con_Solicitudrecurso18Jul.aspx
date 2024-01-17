<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Con_Solicitudrecurso.aspx.vb" Inherits="App_Finanzas_Fin_Con_Solicitudrecurso" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE SOLICITUDES</title>
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
        #tblista tbody td:nth-child(13){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        var inicial1 = '<option value=1>SIN SUPERVISOR</option>'
        $(function () {
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvempleado').hide();
            $('#dvproveedor').hide();
            cargacliente();
            cargaestatus();
            cargaproveedor();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 450,
                width: 900,
                modal: true,
                close: function () {
                }
            });
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 250,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog2 = $('#divmodal2').dialog({
                autoOpen: false,
                height: 450,
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
            $('#btconsulta').click(function () {
                if ($('#txfecini').val() == '' && $('#txfecfin').val() == '' && $('#txfolio').val() == 0) {
                    alert('Debe colocar al menos un numero de solicitud o bien un rango de fechas ')
                } else {
                    if ($('#txfolio').val() == '') {
                        $('#txfolio').val(0);
                    }
                    $('#hdpagina').val(1);
                    cuentasolicitud();
                    cargalista();
                }
            })
            $('#btautoriza').click(function () {
                if (validastatus()) {
                    waitingDialog({});
                    PageMethods.cambiaestatus($('#txreq').val(), $('#dlestatus1').val(), $('#idusuario').val(), $('#txmotivo').val(), function (res) {
                        cuentasolicitud();
                        cargalista();
                        dialog1.dialog('close');
                        closeWaitingDialog();
                    }, iferror);
                }
            })


            $('#dlbeneficia').change(function () {
                switch ($('#dlbeneficia').val()) {
                    case '0':
                        $('#dvempleado').hide();
                        $('#dvproveedor').hide();
                        break;
                    case '1':
                        $('#dvempleado').show();
                        $('#dvproveedor').hide();
                        break;
                    case '2':
                        $('#dvempleado').hide();
                        $('#dvproveedor').show();
                        break;
                }
            })
            $('#txnoemp').change(function () {
                PageMethods.empleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    if (datos.id == '') {
                        alert('El numero de empleado que ha capturado no es valido, verifique');
                        $('#txnoemp').val('');
                        $('#txnoemp').focus();
                    } else {
                        $('#txclave').val(datos.id);
                        $('#txnombre').val(datos.nombre);
                    }
                })
            })
            $('#btbuscap').click(function () {
                $("#divmodal2").dialog('option', 'title', 'Buscar empleado');
                dialog2.dialog('open');
            })
            $('#btbuscaemp').click(function () {
                cargaempleado();
            })
        })
        function cargaempleado() {
            PageMethods.empleadolista($('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllista1 tbody').remove();
                $('#tbllista1').append(ren);
                $('#tbllista1 tbody tr').on('click', function () {
                    $('#txnoemp').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txnombre').val($(this).closest('tr').find('td').eq(1).text());
                    dialog2.dialog('close');
                });
            });
        }
        function cargaproveedor() {
            PageMethods.proveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').empty();
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);                
            }, iferror);
        }
        function validastatus() {
            if ($('#dlestatus1').val() == 6 && $('#txmotivo').val() == '') {
                alert('Al rechazar una solicitud debe colocar un motivo para informar a la persona que elaboro la solicitud');
                return false;
            }
            return true;
        }
        function cuentasolicitud() {
            PageMethods.contarsolicitud($('#txfecini').val(), $('#txfecfin').val(), $('#txfolio').val(), $('#txnoemp').val(), $('#dlstatus').val(), $('#dlproveedor').val(), $('#dlbeneficia').val(), function (cont) {
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
        /*
        function validausuario() {
            PageMethods.validausaurio($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#valida').val(datos.valida);
            }, iferror)
        }*/
        function cargalista() {
            //waitingDialog({});
            PageMethods.solicitudes($('#txfecini').val(), $('#txfecfin').val(), $('#txfolio').val(), $('#hdpagina').val(), $('#txnoemp').val(), $('#dlstatus').val(), $('#dlproveedor').val(), $('#dlbeneficia').val(), function (res) {
                //closeWaitingDialog();

                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').on('click', '.btedita', function () {
                        
                        if ($(this).closest('tr').find('td').eq(6).text() == 'Alta') {
                            window.open('Fin_Pro_Solicitudrecurso.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
                        } else {
                            alert('El estatus actual de la solicitud no permite realizar cambios, verifique');
                        }
                    })
                    $('#tblista tbody tr').on('click', '.btdetalle', function () {
                        switch ($(this).closest('tr').find('td').eq(6).text()) {
                            case 'Cancelado':
                                alert('Esta solicitud fue cancelada, no se pueden consultar los detalles');
                                break;
                            
                            default:
                                $('#lbfolio').text($(this).closest('tr').find('td').eq(0).text());
                                $('#lbempleado').text($(this).closest('tr').find('td').eq(2).text());
                                $('#lbconcepto').text($(this).closest('tr').find('td').eq(12).text());
                                $('#lbtotal').text($(this).closest('tr').find('td').eq(7).text());
                                PageMethods.solicituddet($(this).closest('tr').find('td').eq(0).text(), $(this).closest('tr').find('td').eq(4).text(), function (res) {
                                    var ren = $.parseHTML(res);
                                    $('#tbdetalle tbody').remove();
                                    $('#tbdetalle').append(ren);
                                   
                                }, iferror);
                                $("#divmodal").dialog('option', 'title', 'Detalle de la solicitud');
                                dialog.dialog('open');
                                break;
                        }
                    });
                    $('#tblista tbody tr').delegate(".btvalida", "click", function () {
                        if ($('#idusuario').val() != 1 && $('#idusuario').val() != 59 && $('#idusuario').val() != 81 && $('#idusuario').val() != 85 && $('#idusuario').val() != 100 && $('#idusuario').val() != 130 && $('#idusuario').val() != 84) {
                            alert('Usted no esta autorizado para realizar esta operación');
                        } else {
                            $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                            $("#divmodal1").dialog('option', 'title', 'Validar/rechazar Solicitud');
                            dialog1.dialog('open');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btlibera", "click", function () {
                        if ($('#idusuario').val() != 5) {
                            alert('Usted no esta autorizado para realizar esta operación');
                        } else {
                            $('#dlestatus1').empty();
                            var lista = '<option value="0">Seleccione...</option>';
                            lista += '<option value="3">Liberar</option>'
                            lista += '<option value="6">Rechazar</option>'
                            $('#dlestatus1').append(lista);
                            $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                            $("#divmodal1").dialog('option', 'title', 'liberar/rechazar Solicitud');
                            dialog1.dialog('open');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btautoriza", "click", function () {
                        if ($('#idusuario').val() != 27) {
                            alert('Usted no esta autorizado para realizar esta operación');
                        } else {
                            $('#dlestatus1').empty();
                            var lista = '<option value="0">Seleccione...</option>';
                            lista += '<option value="4">Autorizar</option>'
                            lista += '<option value="6">Rechazar</option>'
                            $('#dlestatus1').append(lista);
                            $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                            $("#divmodal1").dialog('option', 'title', 'Autorizar/rechazar Solicitud');
                            dialog1.dialog('open');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btpagado", "click", function () {
                        if ($('#idusuario').val() != 139 && $('#idusuario').val() != 138) {
                            alert('Usted no esta autorizado para realizar esta operación');
                        } else {
                            waitingDialog({});
                            PageMethods.cambiaestatus($(this).closest('tr').find('td').eq(0).text(), 5, $('#idusuario').val(), $('#txmotivo').val(), function (res) {
                                cuentasolicitud();
                                cargalista();
                                closeWaitingDialog();
                            }, iferror);
                        }
                        
                    });
                }
            }, iferror);
        }
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').empty();
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
            }, iferror);
        }
        function cargaestatus() {
            PageMethods.estatus(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlstatus').empty();
                $('#dlstatus').append(inicial);
                $('#dlstatus').append(lista);
                $('#dlstatus').val(1);
            }, iferror);
        }
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
        <asp:HiddenField ID="valida" runat="server"  Value="0"/>
        <asp:HiddenField ID="idfolio" runat="server" />
        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a class="logo">
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
                    <h1>Consulta de Solicitudes de recursos<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Consulta de Solicitudes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txfolio">Folio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right"  value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecini">F. inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlbeneficia">Beneficiario:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlbeneficia" class="form-control">
                                        <option value ="0">Seleccione..</option>
                                        <option value ="1">Empleado</option>
                                        <option value ="2">Proveedor</option>
                                    </select>
                                </div>
                            </div>
                             <div class="row" id="dvempleado">
                                <div class="col-lg-1 text-right">
                                    <label for="txnoemp">Empleado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txnoemp" class="form-control text-right" value="0" />
                                </div>
                                 <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                </div>
                                 <div class="col-lg-4">
                                    <input type="text" class=" form-control" id="txnombre" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row" id="dvproveedor">
                                 <div class="col-lg-1 text-right">
                                    <label for="txnoemp">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                            </div>
                            <!--
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                
                            </div>
                            -->
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlstatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlstatus" class="form-control"></select>
                                </div>
                                
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <!--
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a Excel</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-save"></i>Imprimir detalle</a></li>
                            </ol>-->
                        </div>
                        <div class="col-md-18 tbheader" style=" height: 300px; overflow-y: scroll;">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                        <th class="bg-light-blue-gradient"><span>Tipo</span></th>
                                        <th class="bg-light-blue-gradient"><span>Proveedor/Empleado</span></th>
                                        <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                        <th class="bg-light-blue-gradient"><span>Gasto</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Alta</span></th>
                                        <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                        <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                        <th class="bg-light-blue-gradient"><span>Banco</span></th>
                                        <th class="bg-light-blue-gradient"><span>CLABE</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cuenta</span></th>
                                        <th class="bg-light-blue-gradient"><span>Área valida</span></th>
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
                                    <label>Beneficiario:</label>
                                </div>
                                <div class="col-lg-6">
                                    <label id="lbempleado"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Concepto:</label>
                                </div>
                                <div class="col-lg-8">
                                    <label id="lbconcepto"></label>
                                </div>
                            </div>
                            <div class="row" style="height:200px; overflow:scroll;">
                                <table class="table table-responsive h6" id="tbdetalle">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 text-right">
                                    <label>Total:</label>
                                </div>
                                <div class="col-lg-4">
                                    <label id="lbtotal"></label>
                                </div>
                            </div>
                        </div>
                        <div id="divmodal1" class="row">
                            <div class="row">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txreq">No. Sol:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control" id="txreq" disabled="disabled" />
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestatus1">Estatus:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlestatus1" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="2">Validar</option>
                                            <option value="6">Rechazar</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmotivo">Motivo:</label>
                                    </div>
                                    <div class="col-lg-6" >
                                        <textarea class="form-control" id="txmotivo" maxlength="300"></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-5">
                                        <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="divmodal2">
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
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
