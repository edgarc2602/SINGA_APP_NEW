<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Empleadocuenta.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Empleadocuenta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ACTUALIZACION DE CUENTAS DE EMPLEADOS</title>
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
            #tblista tbody td:nth-child(9),#tblista tbody td:nth-child(10),#tblista tbody td:nth-child(11){
                display:none;
                width:0px;
            }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdetalle').hide();
            cargabancos();
            $('#btbusca').click(function () {                
                cargalista();
            })
            $('#btguarda').click(function () {
                if ($('#idusuario').val() == 57) {
                    PageMethods.actualizabanco($('#txid').val(), $('#dlbanco').val(), $('#txclabe').val(), $('#txcuenta').val(), $('#txclabed').val(), $('#txnumd').val(), $('#txnombred').val(), function () {
                        alert('Registro completo');
                        if ($('#idbanco').val() != $('#dlbanco').val()) {
                            PageMethods.cambiobanco($('#txid').val(), $('#idbanco').val(), $('#dlbanco').val(), 'Cambio de banco', $('#idusuario').val(), function () {
                                $('#idbanco').val($('#dlbanco').val())
                            }, iferror)
                        }
                        if ($('#idclabe').val() != $('#txclabe').val()) {
                            PageMethods.cambiobanco($('#txid').val(), $('#idclabe').val(), $('#txclabe').val(), 'Cambio de clabe', $('#idusuario').val(), function () {
                                $('#idclabe').val($('#txclabe').val())
                            }, iferror)
                        }
                        if ($('#idcuenta').val() != $('#txcuenta').val()) {
                            PageMethods.cambiobanco($('#txid').val(), $('#idcuenta').val(), $('#txcuenta').val(), 'Cambio de cuenta', $('#idusuario').val(), function () {
                                $('#idcuenta').val($('#txcuenta').val())
                            }, iferror)
                        }
                    }, iferror);
                } else {
                    alert('Usted no esta autorizado para realizar esta acción')
                }
            })
            $('#btlista').click(function () {
                cargalista();
                $('#dvdetalle').hide();
                $('#tblista').show();
            })
        });
        function cargalista() {
            PageMethods.empleados($('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    $('#txid').val($(this).children().eq(2).text());
                    $('#txnombre').val($(this).children().eq(3).text());
                    $('#idbanco').val($(this).children().eq(8).text());
                    cargabancos();
                    $('#txclabe').val($(this).children().eq(5).text());
                    $('#idclabe').val($(this).children().eq(5).text());
                    $('#txcuenta').val($(this).children().eq(6).text());
                    $('#idcuenta').val($(this).children().eq(6).text());
                    $('#txclabed').val($(this).children().eq(7).text());
                    $('#txnumd').val($(this).children().eq(9).text());
                    $('#txnombred').val($(this).children().eq(10).text());
                    $('#dvdetalle').show();
                    $('#tblista').hide();
                });
            }, iferror);
        };
        function cargabancos() {
            PageMethods.banco(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlbanco').empty();
                $('#dlbanco').append(inicial);
                $('#dlbanco').append(lista);
                //$('#dlbanco').val(0);
                if ($('#idbanco').val() != '') {
                    $('#dlbanco').val($('#idbanco').val());
                };
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
        };
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idbanco" runat="server" value="0"/>
        <asp:HiddenField ID="idclabe" runat="server" Value="0" />
        <asp:HiddenField ID="idcuenta" runat="server" Value="0" />
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
                    <h1>Cuentas de Empleados<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Cuentas de empleados</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="a.id_empleado">No. Empleado</option>
                                        <option value="a.paterno">Apellidos Paterno</option>
                                        <option value="a.materno">Apellidos Materno</option>
                                        <option value="a.nombre">Nombre</option>
                                        <option value="a.rfc">RFC</option>
                                        <option value="a.curp">CURP</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-18 tbheader">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Cliente</span></th>
                                    <th class="bg-navy"><span>Punto de atención</span></th>
                                    <th class="bg-navy"><span>No. Emp.</span></th>
                                    <th class="bg-navy"><span>Nombre</span></th>
                                    <th class="bg-navy"><span>Banco</span></th>
                                    <th class="bg-navy"><span>Clabe</span></th>
                                    <th class="bg-navy"><span>Cuenta</span></th>
                                    <th class="bg-navy"><span>Clabe Dispersión</span></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div class="box box-info" id="dvdetalle">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txid">No. empleado:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txid" class="form-control"  disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <label for="txnombre">Nombre:</label>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txnombre" class="form-control" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dlbanco">Banco:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlbanco" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txclabe">Clabe:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txclabe" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txcuenta">Cuenta:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcuenta" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txclabed">Clabe dispersión:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txclabed" class="form-control"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txclabed">Nombre dispersión:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txnombred" class="form-control"/>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txclabed">Numero dispersión:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txnumd" class="form-control"/>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
