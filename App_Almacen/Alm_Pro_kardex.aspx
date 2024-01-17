<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_kardex.aspx.vb" Inherits="App_Almacen_Alm_Pro_kardex" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>KARDEX DE INVENTARIOS</title>
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
            cargaalmacen();
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), $('#dlalmacen').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        $('#txprecio').val($(this).children().eq(3).text());
                        dialog1.dialog('close');
                    });
                }, iferror)
            })
            $('#btconsulta').click(function () {
                
                $('#hdpagina').val(1);
                cuentakd();
                cargalista();
            })
            $('#btimprime').click(function () {
                var fini = $('#txfecini').val().split('/');
                var ffin = $('#txfecfin').val().split('/');
                var formula = '{tb_kardex.clave} ="' + $('#txclave').val() + '" and {tb_kardex.fecha} in Date (' + fini[2] + ' , ' + fini[1] + ' , ' + fini[0] + ') to Date (' + ffin[2] + ' , ' + ffin[1] + ' , ' + ffin[0] + ')'
                
                window.open('../RptForAll.aspx?v_nomRpt=kardex.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        })
        function cuentakd() {
            PageMethods.contarkd($('#txfecini').val(), $('#txfecfin').val(), $('#txclave').val(), $('#dlalmacen').val(), function (cont) {
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
            if (valida()) {
                waitingDialog({});
                PageMethods.kardex($('#txfecini').val(), $('#txfecfin').val(), $('#txclave').val(), $('#dlalmacen').val(), $('#hdpagina').val(), function (res) {
                    closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    if (ren == null) {
                        $('#tblista tbody').remove();
                        alert('No se han encontrado registros con los criterios seleccionado');
                    }
                    else {
                        $('#tblista tbody').remove();
                        $('#tblista').append(ren);
                    }
                }, iferror);
            }
        }
        function valida() {
            if ($('#dlalmacen').val() == 0) {
                alert('Debe elegir un Almacén');
                return false;
            }
            if ($('#txclave').val() == '') {
                alert('Debe elegir un material');
                return false;
            }
            if ($('#txfecini').val() == '') {
                alert('Debe elegir una fecha de inicio');
                return false;
            }
            if ($('#txfecfin').val() == '') {
                alert('Debe elegir una fecha de final');
                return false;
            }
            return true;
        }
        function cargaalmacen() {
            PageMethods.almacen(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlalmacen').append(inicial);
                $('#dlalmacen').append(lista);
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
        <asp:HiddenField ID="hdpagina" runat="server" Value="0" />
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
                    <h1>Kardex de inventarios<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Kardex</li>
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
                                <div class="col-lg-1">
                                    <label for="dlalmacen">Almacén:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlalmacen"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txclave">Material:</label>
                                </div>
                                 <div class=" col-lg-2">
                                    <input type="text" class=" form-control" id="txclave" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                </div>
                                <div class="col-lg-4">
                                    <input class="form-control" disabled="disabled" id="txdesc" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecini">Fecha inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txfecfin">Fecha final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Consultar" id="btconsulta" />
                                </div>
                            </div>
                        </div>
                        <div class="tbheader" style=" height: 300px; overflow-y: scroll;">
                            <table class=" table table-condensed h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-active">Id</th>
                                        <th class="bg-light-blue-active">Documento</th>
                                        <th class="bg-light-blue-active">Registro</th>
                                        <th class="bg-light-blue-active">Fecha</th>
                                        <th class="bg-light-blue-active">Hora</th>
                                        <th class="bg-light-blue-active">Cantidad</th>
                                        <th class="bg-light-blue-active">Costo</th>
                                        <th class="bg-light-blue-active">Existencia</th>
                                        <th class="bg-light-blue-active">Cliente</th>
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
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <!--<li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>-->
                            <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>-->
                            <!--<li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>-->
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                            <!--<li id="btimprime1" class="puntero"><a><i class="fa fa-print"></i>Imprimir integración</a></li>-->
                            <!--<li id="btordenc" class="puntero"><a><i class="fa fa-save"></i>Generar Orden de compra</a></li>-->
                        </ol>
                    </div>
                    <div id="divmodal1">
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
                                <table class="table table-condensed" id="tbbusca">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Clave</span></th>
                                            <th class="bg-navy"><span>Producto</span></th>
                                            <th class="bg-navy"><span>Unidad</span></th>
                                            <th class="bg-navy"><span>Precio</span></th>
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
