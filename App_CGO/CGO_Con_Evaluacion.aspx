<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Con_Evaluacion.aspx.vb" Inherits="App_CGO_CGO_Con_Evaluacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE EVALUACIONES</title>
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
            $('#dlsucursal').append(inicial);
            cargacliente();
            cargagerente(); 
            cargasup();
            cargacomprador();
            cargacgo();
            cargaelaborado();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentaencuesta();
                cargalista();
            })
            $('#btexporta1').click(function () {
                window.open('CGO_Descarga_encuesta.aspx?fecini='+$('#txfecini').val()+' &fecfin='+$('#txfecfin').val()+' &cliente=' + $('#dlcliente').val() + '&inmueble=' + $('#dlsucursal').val(), '_blank');
            })
            $('#btimprime').click(function () {
                var fini = $('#txfecini').val().split('/');
                var ffin = $('#txfecfin').val().split('/');
                var formula = '{tb_encuesta_registro.fecha} in Date (' + fini[2] + ' , ' + fini[1] + ' , ' + fini[0] + ') to Date (' + ffin[2] + ' , ' + ffin[1] + ' , ' + ffin[0] + ')'
                window.open('../RptForAll.aspx?v_nomRpt=encuestaresumen.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        });
        function cuentaencuesta() {
            PageMethods.contarencuesta($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#dlgerente').val(), $('#dlcgo').val(), $('#dlcomprador').val(), $('#dlsupervisor').val(), $('#dlelabora').val(), function (cont) {
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
        function cargagerente() {
            PageMethods.gerente(30, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
                $('#dlgerente').val(0);
            }, iferror);
        }
        function cargasup() {
            PageMethods.gerente(1000, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsupervisor').append(inicial);
                $('#dlsupervisor').append(inicial1);
                $('#dlsupervisor').append(lista);
                $('#dlsupervisor').val(0);
            }, iferror);
        }
        function cargacomprador() {
            PageMethods.atiende(8, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcomprador').empty();
                $('#dlcomprador').append(inicial);
                $('#dlcomprador').append(lista);
                $('#dlcomprador').val(0);
            });
        }
        function cargacgo() {
            PageMethods.atiende(9, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcgo').empty();
                $('#dlcgo').append(inicial);
                $('#dlcgo').append(lista);
                $('#dlcgo').val(0);
            });
        }
        function cargaelaborado() {
            PageMethods.elaborado( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlelabora').empty();
                $('#dlelabora').append(inicial);
                $('#dlelabora').append(lista);
                $('#dlelabora').val(0);
            });
        }
        function cargalista() {
            //waitingDialog({});
            PageMethods.encuestas($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#hdpagina').val(), $('#dlgerente').val(), $('#dlcgo').val(), $('#dlcomprador').val(), $('#dlsupervisor').val(), $('#dlelabora').val(), function (res) {
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
                        window.open('CGO_Pro_Evaluacion.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
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
                    <h1>Consulta de Encuestas de calidad<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Consulta de ticket</li>
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
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlgerente">Gerente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlgerente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlcgo">CGO:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlcgo" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row"> 
                                <div class="col-lg-1 text-right">
                                    <label for="dlcomprador">Comprador:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlcomprador" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlsupervisor">Supervisor:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlsupervisor" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="dlelabora">Elaborado por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlelabora" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a Excel</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-save"></i>Imprimir detalle</a></li>
                            </ol>
                        </div>
                        <div class="col-md-18 tbheader">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                        <th class="bg-light-blue-gradient"><span>Encuesta</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Alta</span></th>
                                        <th class="bg-light-blue-gradient"><span>Persona encuestada</span></th>
                                        <th class="bg-light-blue-gradient"><span>Personal</span></th>
                                        <th class="bg-light-blue-gradient"><span>Operaciones</span></th>
                                        <th class="bg-light-blue-gradient"><span>CGO</span></th>
                                        <th class="bg-light-blue-gradient"><span>Materiales</span></th>
                                        <th class="bg-light-blue-gradient"><span>Miscelaneos</span></th>
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
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
