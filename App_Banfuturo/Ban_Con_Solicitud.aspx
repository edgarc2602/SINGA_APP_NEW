<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ban_Con_Solicitud.aspx.vb" Inherits="App_Banfuturo_Ban_Con_Solicitud" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA SOLICITUD DE PRESTAMO</title>
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
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
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
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentasolicitud();
                cargalista();
            })
            $('#btautoriza').click(function () {
                if (valida()) {
                    waitingDialog({});
                    //alert();
                    PageMethods.autoriza($('#txreq').val(), $('#dlestatus1').val(), function () {                        
                        window.open('../RptPdf.aspx?v_id=' + $('#txreq').val() + '&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txreq').val());

                        var xmlgraba = '<movimiento>'
                        xmlgraba += '<solicitud id= "' + $('#txreq').val() + '" status="0" tamano="0"';
                        xmlgraba += ' archivo="preautorizacion' + $('#txreq').val() + '.pdf" documento="Pre-Autorizacion" descripcion="Carta para Preautorizar el prestamo" />';
                        xmlgraba += '<solicitud id= "' + $('#txreq').val() + '" status="0" tamano="0"';
                        xmlgraba += ' archivo="prestamo' + $('#txreq').val() + '.pdf" documento="Prestamo" descripcion="Carta solicitud de prestamo" />';
                        xmlgraba += '<solicitud id= "' + $('#txreq').val() + '" status="0" tamano="0"';
                        xmlgraba += ' archivo="autorizacion' + $('#txreq').val() + '.pdf" documento="Autorizacion" descripcion="Carta autorizacion del prestamo" />';
                        xmlgraba += '<solicitud id= "' + $('#txreq').val() + '" status="0" tamano="0"';
                        xmlgraba += ' archivo="contrato' + $('#txreq').val() + '.pdf" documento="Contrato" descripcion="Carta contrato del prestamo" />';
                        xmlgraba += '<solicitud id= "' + $('#txreq').val() + '" status="0" tamano="0"';
                        xmlgraba += ' archivo="amortizacion' + $('#txreq').val() + '.pdf" documento="Amortizacion" descripcion="Tabla de amortizacion" />';
                        xmlgraba += '</movimiento>'
                        //alert(xmlgraba);
                        
                        PageMethods.documentos(xmlgraba, function (res) {
                            alert('La Solicitud de prestamo ha sido actualizada correctamente');
                            closeWaitingDialog();
                        }, iferror);
                        dialog1.dialog('close');
                    }, iferror);
                }
            })
        })
        function valida() {
            if ($('#dlestatus1').val() == 0) {
                alert('Debe elegin un estatus');
                return false;
            }
            return true;
        }
        function cargalista() {
            PageMethods.solicitudes($('#txfecini').val(), $('#txfecfin').val(), $('#dlstatus').val(), $('#hdpagina').val(), $('#txfolio').val(), function (res) {
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').delegate(".btedita", "click", function () {
                        if ($(this).closest('tr').find('td').eq(9).text() != 'Rechazado') { //&& $(this).closest('tr').find('td').eq(9).text() != 'Liberado' && $(this).closest('tr').find('td').eq(9).text() != 'Pagado'
                            window.open('Ban_Pro_Solicitud.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                        } else {
                            alert('El estatus actual de la requisición no permite realizar cambios, verifique');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btauto", "click", function () {
                        if ($(this).closest('tr').find('td').eq(9).text() == 'Autorizado' || $(this).closest('tr').find('td').eq(9).text() == 'Liberado' || $(this).closest('tr').find('td').eq(9).text() == 'Pagado') {
                            alert('No se puede cambiar estatus en una Solicitud ya autorizada, liberada o pagada');
                        } else {
                            if ($('#idusuario').val() == 5 || $('#idusuario').val() == 44 || $('#idusuario').val() == 43 || $('#idusuario').val() == 156 || $('#idusuario').val() == 27 || $('#idusuario').val() == 170 || $('#idusuario').val() == 1 || $('#idusuario').val() == 190) {
                                $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                                $("#divmodal1").dialog('option', 'title', 'Autorizar/rechazar Solicitud de prestamo');
                                dialog1.dialog('open');
                            } else {
                                alert('Usted no tiene permisos para ejecutar esta acción')
                            }
                            
                        }
                    });
                    $('#tblista tbody tr').delegate(".btpago", "click", function () {
                        waitingDialog({});
                        PageMethods.paga($(this).closest('tr').find('td').eq(0).text(), function (res) {
                            closeWaitingDialog();
                            alert('La solicitud de prestamo ha sido registrada como pagada, a partir del próximo período de nomina se generan los descuentos automaticos');
                        }, iferror)
                    });
                    $('#tblista tbody tr').delegate(".btdoctos", "click", function () {
                        //waitingDialog({});
                        var fol = $(this).closest('tr').find('td').eq(0).text();
                        window.open('Ban_Con_SolicitudD.aspx?folio=' + fol, '_blank', 'width=650, height=600, left=80, top=120, resizable=no, scrollbars=no ');                        
                    });
                }
            }, iferror);
        }
        function cuentasolicitud() {
            PageMethods.contarsolicitud($('#txfecini').val(), $('#txfecfin').val(), $('#dlstatus').val(), $('#txfolio').val(), function (cont) {
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <h1>Consulta de Solicitud de prestamo<small>Banfuturo</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Banfuturo</a></li>
                        <li class="active">Solicitud de prestamo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txfolio">Folio:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfolio" class="form-control" value="0"/>
                            </div>
                        </div>
                        <div class="row">
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
                                <label for="dlstatus">Estatus:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlstatus" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Alta</option>
                                    <option value="2">Autorizado</option>
                                    <option value="3">Liberado</option>
                                    <%--<option value="4">Rechazado</option>--%>
                                    <option value="5">Pagada</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-10">
                                <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-18 tbheader" style="height: 400px; overflow-y: scroll;">
                        <table class="table table-responsive h6" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                    <th class="bg-light-blue-gradient"><span>No. Emp.</span></th>
                                    <th class="bg-light-blue-gradient"><span>Empleado</span></th>
                                    <th class="bg-light-blue-gradient"><span>Empresa</span></th>
                                    <th class="bg-light-blue-gradient"><span>Autoriza</span></th>
                                    <th class="bg-light-blue-gradient"><span>F. Registro</span></th>
                                    <th class="bg-light-blue-gradient"><span>Monto</span></th>
                                    <th class="bg-light-blue-gradient"><span>Plazo</span></th>
                                    <th class="bg-light-blue-gradient"><span>Plan</span></th>
                                    <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                    <!--<th class="bg-light-blue-gradient"><span>Operaciones</span></th>
                                    <th class="bg-light-blue-gradient"><span>CGO</span></th>
                                    <th class="bg-light-blue-gradient"><span>Materiales</span></th>-->
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
                <%-- <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txreq">No. Solicitud</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class=" form-control" id="txreq" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="dlestatus1">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus1" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="2">Autorizar</option>
                                        <option value="4">Rechazar</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
                                </div>
                            </div>
                        </div>
                    </div>--%>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
