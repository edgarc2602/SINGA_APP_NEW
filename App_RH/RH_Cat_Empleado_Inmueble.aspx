<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Empleado_Inmueble.aspx.vb" Inherits="App_RH_RH_Cat_Empleado_Inmueble" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>EMPLEADOS-INMUEBLES</title>
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
        #tblista tbody td:nth-child(3){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            cargacliente();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 400,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#btbusca').click(function () {
                if ($('#txbusca').val() != '') {
                    cargaempleado($('#txbusca').val());
                } else {
                    alert('Debe capturar un valor de búsqueda');
                }
            })
            $('#btagrega').click(function () {
                if (valida()) {
                    PageMethods.agrega($('#idempleado').val(), $('#dlsucursal').val(), function () {
                        cargaasignados($('#idempleado').val());
                        $('#dlcliente').val(0);
                        $('#dlsucursal').val(0);
                    })
                }
            })
            $('#btbusca1').on('click', function () {
                $("#divmodal").dialog('option', 'title', 'Buscar Empleado');
                $('#tbbusca tbody').remove();
                $('#txbusca').val('');
                dialog.dialog('open');
            });
        })
        function valida() {
            if ($('#dlcliente').val() == 0) {
                alert('Debe seleccionar un Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe seleccionar un Punto de atención');
                return false;
            }
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('td').eq(2).text() == $('#dlsucursal').val()) {
                    alert('El Punto de atención ya esta asignado a este Empleado, no puede duplicar');
                    return false;
                }
            }
            return true;
        }
        function cargaempleado() {
            PageMethods.empleado($('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                $('#tbbusca tbody tr').click(function () {
                    $('#idempleado').val($(this).children().eq(0).text());
                    $('#txempleado').val($(this).children().eq(1).text());
                    cargaasignados($('#idempleado').val());
                    dialog.dialog('close');
                });
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
                });
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
        function cargaasignados(emp) {
            PageMethods.asignados(emp, function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.tbquita', function () {
                    PageMethods.elimina($('#idempleado').val(), $(this).closest('tr').find('td').eq(2).text(), function () {
                        cargaasignados(emp);
                    })
                });
            }, iferror);
        };
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idempleado" runat="server" />
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
                                    <span class="hidden-xs"></span>
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
                    <h1>Puntos de atención por empleado<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Empleado</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-12">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlempleado">Empleado:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txempleado" class="form-control" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Buscar" id="btbusca1"/> 
                                    </div>
                                </div>
                                <div class="col-md-12 tbheader">
                                    <table class="table table-condensed" id="tblista">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>Cliente</span></th>
                                                <th class="bg-navy"><span>Punto de atención</span></th>
                                            </tr>
                                            <tr>
                                                <td class="col-lg-3">
                                                    <select id="dlcliente" class="form-control"></select>
                                                </td>
                                                <td class="col-lg-4">
                                                    <select id="dlsucursal" class="form-control"></select>
                                                </td>
                                                <td>
                                                    <input type="button" class="btn btn-primary" value="Agregar" id="btagrega"/>
                                                </td>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divmodal">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-lg-2 text-right"><label for="txbusca">Buscar</label></div>
                            <div class="col-lg-5"><input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />    </div>                                    
                            <div class="col-lg-1"><input type="button" class="btn btn-primary" value="Mostrar" id="btbusca"/>  </div>
                        </div>
                        <div class="tbheader">
                            <table class="table table-condensed" id="tbbusca">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Empleado</span></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
