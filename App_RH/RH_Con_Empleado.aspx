<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_Empleado.aspx.vb" Inherits="App_RH_RH_Con_Empleado" %>

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
        #tbdatos thead th:nth-child(2), #tbdatos tbody td:nth-child(2){
            width:300px;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        var dialog; var dialog1;
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dlsucursal').append(inicial);
            setTimeout(function () {
                $("#menu").click();
            }, 50);
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
            cargacliente();
            cargaturno();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1); 
                cuentaempleado();
                cargalista();
            })
            $('#btexporta').click(function () {
                window.open('RH_Descargaempleado.aspx?cliente=' + $('#dlcliente').val() + '&sucursal=' + $('#dlsucursal').val() + '&noemp=' + $('#txnoemp').val() + '&nombre=' + $('#txnombre').val() + '&tipo=' + $('#dltipo').val() + '&forma=' + $('#dlforma').val() + '&estatus=' + $('#dlestatus').val(), '_blank');
            })
            $('#btexporta1').click(function () {
                window.open('RH_Descargaempleado.aspx?cliente=' + $('#dlcliente').val() + '&sucursal=' + $('#dlsucursal').val() + '&noemp=' + $('#txnoemp').val() + '&nombre=' + $('#txnombre').val() + '&tipo=' + $('#dltipo').val() + '&forma=' + $('#dlforma').val() + '&estatus=' + $('#dlestatus').val() + '&turno=' + $('#dlturno').val(), '_blank');
            })
        });
        function cargaturno() {
            PageMethods.turno(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlturno').append(inicial);
                $('#dlturno').append(lista);
               
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
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaempleado() {

            PageMethods.contarempleado($('#dlcliente').val(), $('#dlsucursal').val(), $('#txnoemp').val(), $('#txnombre').val(), $('#dltipo').val(), $('#dlforma').val(), $('#dlestatus').val(), $('#dlturno').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalista() {
            waitingDialog({});
            PageMethods.empleado($('#hdpagina').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#txnoemp').val(), $('#txnombre').val(), $('#dltipo').val(), $('#dlforma').val(), $('#dlestatus').val(), $('#dlturno').val(), function (res) {
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
                        var emp = $(this).closest('tr').find('td').eq(2).text();
                        window.open('RH_Con_EmpleadoD.aspx?emp=' + emp, '_blank', 'width=650, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                    });
                    $('#tblista table tbody tr').on('click', '.tbcontrato', function () {
                        //alert($(this).closest('tr').find('td').eq(2).text());
                        var formula = '{tb_empleado.id_empleado}=' + $(this).closest('tr').find('td').eq(2).text() 
                        window.open('../RptForAll.aspx?v_nomRpt=contratoempleate.rpt&v_formula=' + formula + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no')
                    });
                }
            }, iferror);
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
                    <h1>Consulta general de Empleados
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Consulta de empleados</li>
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
                                    <label for="txnoemp">No. empleado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoemp" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombre" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Turno:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlturno" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="6">Administrativa</option>
                                        <option value="4">Operativa</option>
                                        <option value="11">Mantenimiento</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlforma">Forma de pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlforma" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Quicenal</option>
                                        <option value="2">Semanal</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Candidato</option>
                                        <option value="2">Activo</option>
                                        <option value="3">Baja</option>
                                        <option value="4">No se presento</option>
                                    </select>
                                </div>
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                        </ol>
                        <div class="col-md-18 tbheader" style ="overflow-x:scroll;">
                            <table class="table table-condensed h6" id="tbdatos">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"></th>
                                        <th class="bg-light-blue-gradient"></th>
                                        <th class="bg-light-blue-gradient"><span>No. Emp</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                        <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                        <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                        <th class="bg-light-blue-gradient"><span>NSS</span></th>
                                        <th class="bg-light-blue-gradient"><span>Pensionado</span></th>
                                        <th class="bg-light-blue-gradient"><span>Tipo</span></th>
                                        <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                        <th class="bg-light-blue-gradient"><span>Empresa</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Pto Atn</span></th>
                                        <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                        <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                        <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Nacimiento</span></th>
                                        <th class="bg-light-blue-gradient"><span>Lugar</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nacionalidad</span></th>
                                        <th class="bg-light-blue-gradient"><span>Genero</span></th>
                                        <th class="bg-light-blue-gradient"><span>Civil</span></th>
                                        <th class="bg-light-blue-gradient"><span>Talla</span></th>
                                        <th class="bg-light-blue-gradient"><span>Sueldo</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Ingreso</span></th>
                                        <th class="bg-light-blue-gradient"><span>Forma pago</span></th>
                                        <th class="bg-light-blue-gradient"><span>Banco</span></th>
                                        <th class="bg-light-blue-gradient"><span>Clabe</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cuenta</span></th>
                                        <th class="bg-light-blue-gradient"><span>Tarjeta</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Baja</span></th>
                                        <th class="bg-light-blue-gradient"><span>Alta IMSS</span></th>
                                    </tr>
                                </thead>
                            </table>
                            <ol class="breadcrumb">
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
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
