<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Con_Requisicion.aspx.vb" Inherits="App_Compras_Com_Con_Requisicion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA REQUISICION DE COMPRA</title>
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
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
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
                height: 250,
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
            cargaempresa();
            cargaproveedor();
            cargacliente();
            cargastatus();
            cargacomprador();
            cargafamilia();
            $('#btconsulta').click(function () {
                if ($('#txfolio').val() == '') {
                    $('#txfolio').val(0);
                }
                $('#hdpagina').val(1);
                cuentareq();
                cargalista();
            })
            $('#btautoriza').click(function () {
                if ($('#dlestatus1').val() != 0) {
                    waitingDialog({});
                    PageMethods.autoriza($('#txreq').val(), $('#dlestatus1').val(), function () {
                        alert('La requisición ha sido actualizada correctamente')
                        dialog1.dialog('close');
                        cargalista();
                        closeWaitingDialog();
                    }, iferror);
                } else {
                    alert('Debe elegir el estatus para la Requisición')
                }
            })
            $('#btcontinuar').click(function () {
                window.open('Com_Pro_ordencompra.aspx?idreq=' + $('#txreq1').val() + '&familia=' + $('#dlfamilia').val(), '_blank')
            })
        })
        function cargalista() {
            //alert($('#dlarea').val());
            //waitingDialog({});
            PageMethods.requisiciones($('#txfecini').val(), $('#txfecfin').val(), $('#dlempresa').val(), $('#dlproveedor').val(), $('#dlcliente').val(), $('#dlestatus').val(), $('#hdpagina').val(), $('#txfolio').val(), $('#dltipo').val(), $('#dlcomprador').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').delegate(".btimprime", "click", function () {
                        window.open('../RptForAll.aspx?v_nomRpt=requisicioncompra.rpt&v_formula={tb_requisicion.id_requisicion}= ' + $(this).closest('tr').find('td').eq(0).text() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                    });
                    $('#tblista tbody tr').delegate(".btimprime1", "click", function () {
                        window.open('../RptForAll.aspx?v_nomRpt=requisicioncompraintegra.rpt&v_formula={tb_requisicion.id_requisicion}= ' + $(this).closest('tr').find('td').eq(0).text() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                    });

                    $('#tblista tbody tr').delegate(".btedita", "click", function () {
                        if ($(this).closest('tr').find('td').eq(7).text() != 'Autorizada' ) {
                            window.open('Com_Pro_Requisicion.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                        } else {
                            alert('El estatus actual de la requisición no permite realizar cambios, verifique');
                        }
                    }); 
                    $('#tblista tbody tr').delegate(".btauto", "click", function () {
                        if ($(this).closest('tr').find('td').eq(7).text() == 'Completa') {
                            alert('No se puede cambiar estatus en una Requisición ya Completada');
                        } else {
                            $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                            $("#divmodal1").dialog('option', 'title', 'Autorizar/rechazar Requisición');
                            dialog1.dialog('open');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btoc", "click", function () {
                        if ($(this).closest('tr').find('td').eq(7).text() == 'Autorizada') {
                            if ($(this).closest('tr').find('td').eq(3).text() == 'GRUPO BATIA') {
                                $('#txreq1').val($(this).closest('tr').find('td').eq(0).text());
                                $("#divmodal2").dialog('option', 'title', 'Elegir Familia para la orden de compra');
                                dialog2.dialog('open');
                            } else {
                                window.open('Com_Pro_ordencompra.aspx?idreq=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
                            }
                        } else {
                            alert('Solo se puede generar Ordenes de compra en Requisiciones autorizadas');
                        }
                    });
                }
            }, iferror);
        }
        function cargaempresa() {
            PageMethods.empresa(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempresa').append(inicial);
                $('#dlempresa').append(lista);
                
            }, iferror);
        }
        function cargaproveedor() {
            PageMethods.catproveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
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
            }, iferror);
        }
        function cargastatus() {
            PageMethods.estatus(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestatus').append(inicial);
                $('#dlestatus').append(lista);
                $('#dlestatus').val(1);
            }, iferror);
        }
        function cargacomprador() {
            PageMethods.comprador(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcomprador').append(inicial);
                $('#dlcomprador').append(lista);
            }, iferror);
        }
        function cargafamilia() {
            PageMethods.familia(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlfamilia').append(inicial);
                $('#dlfamilia').append(lista);

            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentareq() {
            PageMethods.contarreq($('#txfecini').val(), $('#txfecfin').val(), $('#dlempresa').val(), $('#dlproveedor').val(), $('#dlcliente').val(), $('#dlestatus').val(), $('#txfolio').val(), $('#dltipo').val(), $('#dlcomprador').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
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
        }
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
                    <h1>Consulta de Requisiciones de Compra<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Requisiciones de compra</li>
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
                                <div class="col-lg-1 text-right">
                                    <label for="txfolio">No. req:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfolio" class="form-control" value="0" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecini">F. inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlempresa" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlproveedor">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Entrega mensual</option>
                                        <option value="2">Solicitado por el cliente</option>
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlcomprador">Comprador:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcomprador" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                        </div>
                        <div class="tbheader" style=" height: 300px; overflow-y: scroll;">
                            <table class=" table table-condensed h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-active">Requisición</th>
                                        <th class="bg-light-blue-active">F. Alta</th>
                                        <th class="bg-light-blue-active">Empresa</th>
                                        <th class="bg-light-blue-active">Proveedor</th>
                                        <th class="bg-light-blue-active">Tipo</th>
                                        <th class="bg-light-blue-active">Comprador</th>
                                        <th class="bg-light-blue-active">Cliente</th>
                                        <th class="bg-light-blue-active">Estatus</th>
                                        <th class="bg-light-blue-active">Elaboró</th>
                                        <th class="bg-light-blue-active">Valor</th>
                                        <th class="bg-light-blue-active">Comentarios</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
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
                        <ol class="breadcrumb">
                            <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                            <li id="btimprime"  class="puntero"><a ><i class="fa fa-print"></i>Imprimir listado</a></li>
                        </ol>
                        <div id="divmodal1" class="row">
                            <div class="row">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txreq">No. Req</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control" id="txreq" disabled="disabled" />
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestatus1">Estatus</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlestatus1" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="2">Autorizar</option>
                                            <option value="3">Rechazar</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="divmodal2" class="row">
                            <div class="row">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlfamilia">Requisición</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control" id="txreq1" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlfamilia">Familia</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlfamilia" class="form-control">
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Continuar" id="btcontinuar" />
                                    </div>
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
