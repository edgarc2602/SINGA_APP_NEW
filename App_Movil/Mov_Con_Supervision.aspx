<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Mov_Con_Supervision.aspx.vb" Inherits="App_Movil_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>CONSULTA DE SUPERVISIONES</title>
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
        var inicial1 = '<option value=1>SIN SUPERVISOR</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            cargacliente();
            cargaencargado();
            cargasupervisor();
            cargaestado();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentaencuesta();
                cargalista();
            })
            $('#btnuevo1').click(function () {
                location.reload();
            })
            $('#btexporta1').click(function () {
                window.open('Mov_Descarga_supervision.aspx?fecini=' + $('#txfecini').val() + ' &fecfin=' + $('#txfecfin').val() + ' &cliente=' + $('#dlcliente').val() + '&supervisor=' + $('#dlsupervisor').val() + '&gerente=' + $('#dlgerente').val() + '&estado=' + $('#dlestado').val(), '_blank');
            })
            $('#btimprime').click(function () {
                var fini = $('#txfecini').val().split('/');
                var ffin = $('#txfecfin').val().split('/');
                var formula = '{tb_supervision.fechaini} in Date (' + fini[2] + ' , ' + fini[1] + ' , ' + fini[0] + ') to Date (' + ffin[2] + ' , ' + ffin[1] + ' , ' + ffin[0] + ')'
                if ($('#dlcliente').val() != 0) {
                    formula += ' and {tb_cliente.id_cliente} =' + $('#dlcliente').val();
                }
                if ($('#dlsupervisor').val() != 0) {
                    formula += ' and {tb_supervision.usuario} =' + $('#dlsupervisor').val();
                }
                if ($('#dlgerente').val() != 0) {
                    formula += ' and {tb_cliente.id_operativo} =' + $('#dlgerente').val();
                }
                if ($('#dlestado').val() != 0) {
                    formula += ' and {tb_cliente_inmueble.id_estado} =' + $('#dlestado').val();
                }
                alert(formula);
                window.open('../RptForAll.aspx?v_nomRpt=supervisionlista.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        });
        function cargaestado() {
            PageMethods.estado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);               
            }, iferror);
        }
        function cargaencargado() {
            //alert('hola');
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
        function cargasupervisor() {
            //alert('hola');
            PageMethods.supervisor( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsupervisor').empty();
                $('#dlsupervisor').append(inicial);
                $('#dlsupervisor').append(lista);
            }, iferror);
        }
        function asignapagina(np) {
            //alert('hola');
            $('#paginacion ul').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion ul').eq(np - 1).addClass("active");
        };
        function cuentaencuesta() {
            
            PageMethods.contarencuesta($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlsupervisor').val(), $('#dlgerente').val(), $('#dlestado').val(), function (cont) {
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
        function cargalista() {
            //waitingDialog({});
            PageMethods.encuestas($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlsupervisor').val(), $('#dlgerente').val(), $('#dlestado').val(), $('#hdpagina').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').click(function () {
                        window.open('Mov_Rep_Supervision.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
                    })
                }
            }, iferror);
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
        <asp:HiddenField ID="idfolio" runat="server" />
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
                    <h1>Consulta de Supervisiones<small>App Movil</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>App Movil</a></li>
                        <li class="active">Consulta de Supervisiones</li>
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
                                    <label for="dltipo">F. inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlsupervisor">Supervisor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsupervisor" class="form-control"></select>
                                </div>
                            </div>                            
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlgerente">Gerente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlgerente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlestado">Estado:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlestado" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-18 tbheader" style="height:400px; overflow:scroll;">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                        <th class="bg-light-blue-gradient"><span>Fecha</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                        <th class="bg-light-blue-gradient"><span>Supervisor</span></th>
                                        <th class="bg-light-blue-gradient"><span>Entrevista Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                        <th class="bg-light-blue-gradient"><span>Calif. General</span></th>
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
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a Excel</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir detalle</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
    </html>