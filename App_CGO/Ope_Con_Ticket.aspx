<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Con_Ticket.aspx.vb" Inherits="App_Operaciones_Ope_Con_Ticket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>CONSULTA DE TICKETS</title>
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
        .tbborrar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e801';
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
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
            $('#dlmes').append(inicial);
            $('#dlcliente').append(inicial);
            $('#dlarea').append(inicial);
            var f = new Date();
            var mm = f.getMonth() + 1
            //alert(mm.toString().length);
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecini').val('01' + "/" + mm + "/" + f.getFullYear());
            $('#txfecfin').val(f.getDate() + "/" + mm + "/" + f.getFullYear());
            cargames();
            cargacliente();
            cargaarea();
            
            
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentaticket();
                cargalista();
            })
            $('#btexporta1').click(function () {
                window.open('CGO_Descarga_ticket.aspx?fecini= ' + $('#txfecini').val() + '&fecfin= ' + $('#txfecfin').val() + ' &mes= ' + $('#dlmes').val() + ' &folio= ' + $('#txid').val() + ' &cliente=' + $('#dlcliente').val() + '&area=' + $('#dlarea').val() + '&estatus=' + $('#dlestatus').val(), '_blank');
            })
        });
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaticket() {
            PageMethods.contartickets($('#txfecini').val(), $('#txfecfin').val(), $('#dlmes').val(), $('#txid').val(), $('#dlcliente').val(), $('#dlarea').val(), $('#dlestatus').val(),  function (cont) {
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
            //alert($('#dlarea').val());
            //waitingDialog({});
            PageMethods.tickets($('#txfecini').val(), $('#txfecfin').val(), $('#dlmes').val(), $('#txid').val(), $('#dlcliente').val(), $('#dlarea').val(), $('#dlestatus').val(), $('#hdpagina').val(),  function (res) {
                //closeWaitingDialog();
                
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').click(function(){
                        window.open('OPe_Pro_Ticket.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
                    })
                }
            }, iferror);
        }
        function cargames() {
            PageMethods.mes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlmes').append(inicial);
                $('#dlmes').append(lista);
                $('#dlmes').val(0);
            }, iferror);
        }
        function cargacliente() {
            PageMethods.cliente($('#idcliente1').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').empty();
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').val($('#idcliente1').val());
                cuentaticket();
                cargalista();
            }, iferror);
        }
        function cargaarea() {
            PageMethods.area($('#idcliente1').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlarea').empty();
                $('#dlarea').append(inicial);
                $('#dlarea').append(lista);
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
        <asp:HiddenField ID="idcliente1" runat="server" />
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
                    <h1>Consulta de ticket<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Consulta de ticket</li>
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
                                    <div class="col-lg-1">
                                        <label for="dltipo">Mes de Servicio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlmes" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dltipo">No. ticket:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" value ="0"/>
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
                                        <label for="dlarea">Area:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlarea" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dlestatus">Estatus:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestatus" class="form-control">
                                            <option value="99">Seleccione...</option>
                                            <option value="0">Alta</option>
                                            <option value="1">Atendido</option>
                                            <option value="2">Cerrado</option>
                                            <option value="4">Cerrado sin cubrir</option>
                                            <option value="3">Cancelado</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-10">
                                        <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                                </ol>
                            </div>
                            <div class="col-md-18 tbheader" style="overflow-x:scroll">
                                <table class="table table-responsive h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <!--<th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>-->
                                            <th class="bg-light-blue-gradient"><span>Ticket</span></th>
                                            <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Alta</span></th>
                                            <th class="bg-light-blue-gradient"><span>H. Alta</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Notifica</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Escala</span></th>
                                            <th class="bg-light-blue-gradient"><span>Semáforo</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Termino</span></th>
                                            <th class="bg-light-blue-gradient"><span>H. termino</span></th>
                                            <th class="bg-light-blue-gradient"><span>Mes</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sucursal</span></th>
                                            <th class="bg-light-blue-gradient"><span>Incidencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Causa</span></th>
                                            <th class="bg-light-blue-gradient"><span>Area</span></th>
                                            <th class="bg-light-blue-gradient"><span>Reporta</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ejecutivo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Gerente</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
