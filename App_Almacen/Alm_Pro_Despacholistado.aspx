<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_Despacholistado.aspx.vb" Inherits="App_Almacen_Alm_Pro_Despacholistado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>DESPACHO DE LISTADOS</title>
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
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#txfentrega').datepicker({ dateFormat: 'dd/mm/yy' });
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 550,
                width: 800,
                modal: true,
                close: function () {
                    cargalistados();
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
            cargaalmacen();
            cargacliente();
            cargames();
            $('#btmostrar').click(function () {
                if (validacte()) {
                    $('#hdpagina').val(1);
                    cuentalistados();
                    cargalistados();
                }
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var incompleto = 0

                    var xmlgraba = '<Movimiento> <salida documento="8" almacen1="0" factura="0"';
                    xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba += ' orden="' + $('#lbfolio').text() + '" usuario="' + $('#idusuario').val() + '"/>'
                    $('#tblistaj tbody tr').each(function () {
                        if (parseFloat($(this).closest('tr').find('td').eq(6).text()) != 0) {
                            xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find('td').eq(6).text()) + '"';
                            xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find('td').eq(4).text()) + '"/>';
                        } else {
                            incompleto = 1
                        }
                    });

                    if (incompleto == 1) {
                        alert('Solo se despachara material con existencias disponibles');
                    }
                    xmlgraba += '</Movimiento>';
                    alert(xmlgraba);

                    PageMethods.guarda(xmlgraba, function (res) {
                        $('#lbdespacho').text(res);
                        closeWaitingDialog();
                        alert('Registro completo');
                    }, iferror);
                }
            })
            $('#btcargar').click(function () {
                cargadetalle();
            })
        })
        function valida() {
            if ($('#dlalmacen').val() == 0) {
                alert('Debe elegir el almacén para el despacho');
                return false;
            }
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Antes de despachar primero debe cargar el listado');
                return false;
            }
            if ($('#lbdespacho').text() != '') {
                alert('El listado ya ha sido despachado, no puede duplicar');
                return false;
            }
            return true;
        }
        function cargadetalle() {
            PageMethods.listadod($('#lbfolio').text(), $('#dlalmacen').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
            }, iferror);
        }
        function cuentalistados() {
            PageMethods.contarlistados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), $('#txfolio').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalistados() {
            PageMethods.listados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#hdpagina').val(), $('#dltipo').val(), $('#txfolio').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btver', function () {
                    $('#tblistaj tbody').remove();
                    $('#dlalmacen').val(0);
                    $('#lbdespacho').text('');
                    $('#idcliente').val($(this).closest('tr').find('td').eq(0).text());
                    $('#lbfolio').text($(this).closest('tr').find('td').eq(4).text());
                    $('#lbinmueble').text($(this).closest('tr').find('td').eq(3).text());
                    $('#lbtipo').text($(this).closest('tr').find('td').eq(5).text());
                    $("#divmodal").dialog('option', 'title', 'Detalle de listado');
                    dialog.dialog('open');
                });
               
            }, iferror);
        }

        function validacte() {
            if ($('#txanio').val() == '') {
                alert('Debe capturar el año');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe seleccionar un mes');
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
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    cargaestado();
                });
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen" runat="server" Value="0" />
        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home1.aspx" class="logo">
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
                    <h1>Despachar listados de materiales<small>Almacén</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacén</a></li>
                        <li class="active">Despacho</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfolio">No. Listado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfolio" class="form-control" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo de listado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Iguala</option>
                                        <option value="2">Adicionales</option>
                                        <option value="3">Complemento de la iguala</option>
                                        <option value="4">Material para pulido</option>
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btmostrar" class="btn btn-primary" value="mostrar"/>
                                </div>
                            </div>
                        </div>
                        <div class="tbheader" style="height:300px; overflow-y:scroll;">
                            <table class="table table-condensed" id="tblista" >
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>No.</span></th>
                                        <th class="bg-navy"><span>Cliente</span></th>
                                        <th class="bg-navy"><span>No.</span></th>
                                        <th class="bg-navy"><span>Punto de atención</span></th>
                                        <th class="bg-navy"><span>Listado</span></th>
                                        <th class="bg-navy"><span>Tipo</span></th>
                                        <th class="bg-navy"><span>Estatus</span></th>
                                        <th class="bg-navy"><span>F. Creación</span></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                            <li id="btimprime"  class="puntero"><a ><i class="fa fa-print"></i>Imprimir Matriz</a></li>
                            <li id="btimprimec"  class="puntero"><a ><i class="fa fa-print"></i>Imprimir concentrado</a></li>
                            <!--<li id="btautoriza"  class="puntero"><a ><i class="fa fa-edit"></i>Aprobar</a></li>
                            <li id="btlibera"  class="puntero"><a ><i class="fa fa-undo"></i>Liberar</a></li>-->
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
                        <div id="divmodal">
                            <div class="row">
                                <div class="col-lg-3">
                                    <label>Listado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <label id="lbfolio" ></label>
                                </div>
                                <div class="col-lg-3">
                                    <label>Despacho:</label>
                                </div>
                                <div class="col-lg-2">
                                    <label id="lbdespacho"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <label>Punto de atención:</label>
                                </div>
                                <div class="col-lg-6">
                                    <label id="lbinmueble"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <label>Tipo:</label>
                                </div>
                                <div class="col-lg-6">
                                    <label id="lbtipo"></label>
                                </div>
                            </div>
                            <div class="row">
                                 <div class="col-lg-3">
                                    <label>Almacén:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select class="form-control" id="dlalmacen">  </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <input type="button" class="btn btn-primary" value="Cargar" id="btcargar" />
                                </div>
                            </div>
                            <div class="row">
                                <div  id="dvjarceria" class="tbheader" style="height:300px; overflow-y:scroll;">
                                    <table class=" table table-condensed h6" id="tblistaj">
                                            <thead>
                                            <tr>
                                                <th class="bg-light-blue-active">Clave</th>
                                                <th class="bg-light-blue-active">Descripción</th>
                                                <th class="bg-light-blue-active">Unidad</th>
                                                <th class="bg-light-blue-active">Cantidad</th>
                                                <th class="bg-light-blue-active">Precio</th>
                                                <th class="bg-light-blue-active">Disponible</th>
                                                <th class="bg-light-blue-active">Se despacha</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="row">
                                 <div class="col-lg-3">
                                    <input type="button" class="btn btn-info" value="Despachar" id="btguarda" />
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
