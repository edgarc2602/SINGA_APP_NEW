<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Empleado_Permuta.aspx.vb" Inherits="App_RH_RH_Pro_Empleado_Permuta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Baja de Empleados</title>
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
            dialog1 = $('#divmodal').dialog({
                autoOpen: false,
                height: 350,
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
            $('#btbusca').click(function () {
                $('#opcion').val(1);
                $("#divmodal").dialog('option', 'title', 'Elegir Empleado');
                dialog1.dialog('open');
            });
            $('#btbusca1').click(function () {
                $('#opcion').val(2);
                $("#divmodal").dialog('option', 'title', 'Elegir Empleado');
                dialog1.dialog('open');
            });
            $('#btbuscap').click(function () {
                $('#tbbusca1 tbody').remove();
                if (validaemp()) {
                    cargalistaemp();
                }
            })
            $('#txidemp').focusout(function () {
                if ($('#txidemp').val() != '') {                    
                    if (isNaN($('#txidemp').val()) == true) {
                        alert('Debe colocar un numero de empleado correcto')
                        $('#txidemp').val('');
                        $('#txidemp').focus();
                    } else {
                        PageMethods.valempleado($('#txidemp').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            if (datos.estatus == 2) {
                                $('#opcion').val(1);
                                //limpie();
                                cargaempleado($('#txidemp').val());
                            } else {
                                switch (datos.estatus) {
                                    case "1":
                                        alert('El numero de empleado capturado tiene estatus de candidato, no puede continuar');
                                        limpie();
                                        break;
                                    case "3":
                                        alert('El numero de empleado capturado tiene estatus de baja, no puede continuar');
                                        limpie();
                                        break;
                                    case "4":
                                        alert('El numero de empleado capturado tiene estatus de no presentado, no puede continuar');
                                        limpie();
                                        break;
                                    case "0":
                                        alert('El numero de empleado capturado no existe, no puede continuar');
                                        limpie();
                                        break;
                                }
                            }
                        }, iferror)
                    }
                }
            })
            $('#txidemp1').focusout(function () {
                if ($('#txidemp1').val() != '') {
                    if (isNaN($('#txidemp1').val()) == true) {
                        alert('Debe colocar un numero de empleado correcto')
                        $('#txidemp1').val('');
                        $('#txidemp1').focus();
                    } else {
                        PageMethods.valempleado($('#txidemp1').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            if (datos.estatus == 2) {
                                $('#opcion').val(2);
                                //limpie();
                                cargaempleado($('#txidemp1').val());
                            } else {
                                switch (datos.estatus) {
                                    case "1":
                                        alert('El numero de empleado capturado tiene estatus de candidato, no puede continuar');
                                        limpie();
                                        break;
                                    case "3":
                                        alert('El numero de empleado capturado tiene estatus de baja, no puede continuar');
                                        limpie();
                                        break;
                                    case "4":
                                        alert('El numero de empleado capturado tiene estatus de no presentado, no puede continuar');
                                        limpie();
                                        break;
                                    case "0":
                                        alert('El numero de empleado capturado no existe, no puede continuar');
                                        limpie();
                                        break;
                                }
                            }
                        }, iferror)
                    }
                }
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    PageMethods.guarda($('#txidemp').val(), $('#txidemp1').val(), function (res) {
                        closeWaitingDialog();
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
        })
        function valida() {
            if ($('#txidemp').val() == '') {
                alert('Debe colocar el numero del primer Empleado');
                return false;
            }
            if ($('#txidemp1').val() == '') {
                alert('Debe colocar el numero del segundo Empleado');
                return false;
            }
            return true;
        }
        function validaemp() {
            if ($('#txbusca').val() == '') {
                alert('Debe colocar un numero de empleado o nombre a buscar');
                return false;
            }
            return true;
        }
        function cargalistaemp() {
            PageMethods.listaempleado($('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca1 tbody').remove();
                $('#tbbusca1').append(ren);
                $('#tbbusca1 tbody tr').click(function () {
                    cargaempleado($(this).children().eq(0).text())
                    dialog1.dialog('close');
                });
            }, iferror);
        }
        function limpie() {
            if ($('#opcion').val() == 1) {
                $('#txidemp').val('');
                $('#txnombre').val('');
                $('#txcliente').val('');
                $('#txsucursal').val('');
                $('#txpuesto').val('');
                $('#txturno').val('');
                $('#txsueldo').val('');
                $('#txjornal').val('');
                $('#txplantilla').val('');
                $('#txposicion').val('');
            } else {
                $('#txidemp1').val('');
                $('#txnombre1').val('');
                $('#txcliente1').val('');
                $('#txsucursal1').val('');
                $('#txpuesto1').val('');
                $('#txturno1').val('');
                $('#txsueldo1').val('');
                $('#txjornal1').val('');
                $('#txplantilla1').val('');
                $('#txposicion1').val('');
            }
        }
        function cargaempleado(emp) {
            PageMethods.empleado(emp, function (detalle) {
                var datos = eval('(' + detalle + ')');
                if ($('#opcion').val() == 1) {
                    $('#txidemp').val(datos.emp);
                    $('#txnombre').val(datos.empleado);
                    $('#txcliente').val(datos.cliente);
                    $('#txsucursal').val(datos.inmueble);
                    $('#txpuesto').val(datos.puesto);
                    $('#txturno').val(datos.turno);
                    $('#txsueldo').val(datos.sueldo);
                    $('#txjornal').val(datos.jornal);
                    $('#txplantilla').val(datos.plantilla);
                    $('#txposicion').val(datos.posicion);
                } else {
                    $('#txidemp1').val(datos.emp);
                    $('#txnombre1').val(datos.empleado);
                    $('#txcliente1').val(datos.cliente);
                    $('#txsucursal1').val(datos.inmueble);
                    $('#txpuesto1').val(datos.puesto);
                    $('#txturno1').val(datos.turno);
                    $('#txsueldo1').val(datos.sueldo);
                    $('#txjornal1').val(datos.jornal);
                    $('#txplantilla1').val(datos.plantilla);
                    $('#txposicion1').val(datos.posicion);
                }
            })
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
        <asp:HiddenField ID="opcion" runat="server" />

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
                    <h1>Permuta de Empleados<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Transferencia de Empleado</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <!-- Horizontal Form -->
                        <div class="box-header">
                            <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <h3>Primer Empleado</h3>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txidemp">Empleado:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txidemp" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcliente">Cliente:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txcliente">Punto de atención:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txsucursal" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txpuesto">Puesto:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txturno">Turno:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txturno" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txjornal">Jornal:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txjornal" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txsueldo">Sueldo:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txsueldo" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txplantilla">Plantilla:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txplantilla" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txposicion">Posición:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txposicion" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-lg-4">
                                <h3>Segundo Empleado</h3>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txidemp">Empleado:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txidemp1" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="Buscar" id="btbusca1" />
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txnombre1" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcliente1">Cliente:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcliente1" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txsucursal1">Punto de atención:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txsucursal1" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txpuesto1">Puesto:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txpuesto1" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txturno1">Turno:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txturno1" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txjornal1">Jornal:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txjornal1" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txsueldo1">Sueldo:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txsueldo1" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txplantilla1">Plantilla:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txplantilla1" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txposicion1">Posición:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txposicion1" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        </ol>
                    </div>


                    <div id="divmodal">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label>
                                </div>
                                <div class="col-lg-5">
                                    <input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                </div>
                            </div>
                            <div class="tbheader">
                                <table class="table table-condensed" id="tbbusca1">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>No. Emp</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Cliente</span></th>
                                        </tr>
                                    </thead>
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
