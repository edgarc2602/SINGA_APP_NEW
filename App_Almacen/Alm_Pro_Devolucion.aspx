<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_Devolucion.aspx.vb" Inherits="App_Almacen_Alm_Pro_Devolucion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>DEVOLUCION DE MATERIALES</title>
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
            cargacliente();
            $('#btbusca').click(function () {
                if ($('#dlalmacen').val() != 0) {
                    $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                    dialog1.dialog('open');
                } else {
                    alert('Primero debe elegir un almacén')
                }
            })
            $('#btbuscap').click(function () {

                PageMethods.productol($('#txbusca').val(), $('#dlalmacen').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        if (parseFloat($(this).children().eq(3).text()) == 0) {
                            alert('Antes de agregar este producto debe solicitar al área de compras colocar un precio base');
                        } else {
                            $('#txclave').val($(this).children().eq(0).text());
                            $('#txdesc').val($(this).children().eq(1).text());
                            $('#txunidad').val($(this).children().eq(2).text());
                            $('#txprecio').val($(this).children().eq(3).text());
                            dialog1.dialog('close');
                        }
                        
                    });
                }, iferror)
            })
            $('#txcantidad').change(function () {
                subtotal();
            })
            $('#btagrega').click(function () {
                if (validamat()) {
                    var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                    linea += '<input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistaj tbody').append(linea);
                    $('#tblistaj').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                    });
                    $('#tblistaj tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                    });
                    limpiaproducto();
                }
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    //waitingDialog({});
                    var xmlgraba = '<Movimiento> <salida documento="4" almacen1="0" factura="0"';
                    xmlgraba += ' cliente="' + $('#dlcliente').val() + '" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba += ' orden="' + $('#txfolio').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                    $('#tblistaj tbody tr').each(function () {
                        xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"';
                        xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find("input:eq(1)").val()) + '"/>';
                    });
                    xmlgraba += '</Movimiento>';
                    //alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        if (res == 0) {
                            alert('algo salio mal');
                        } else {
                            $('#txmov').val(res);
                            alert('Registro completado');
                        }
                    }, iferror);
                }
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
        })
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val(0);
            $('#txtotal').val('');
        }
        function subtotal() {
            var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val());
            $('#txtotal').val(tot.toFixed(2));
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
        function validamat() {
            
            if ($('#txclave').val() == '') {
                alert('Debe elegir la clave del material');
                return false;
            }
            if ($('#txcantidad').val() == '') {
                alert('Debe capturar la cantidad de material');
                return false;
            }
            for (var x = 0; x < $('#tblistaj tbody tr').length; x++) {
                if ($('#tblistaj tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                    alert('Este producto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            return true;
        }
        function valida() {
            if ($('#txmov').val() != 0) {
                alert('La devolución ya fue registrada, debe generar un nuevo movimiento');
                return false;
            }
            if ($('#txfolio').val() == '') {
                $('#txfolio').val(0);
            }
            if ($('#dlalmacen').val() == 0) {
                alert('Debe elegir un almacén');
                return false;
            }
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            return true;
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
                    <h1>Devolución de materiales<small>Almacén</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacén</a></li>
                        <li class="active">Devolución</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-5 text-right">
                                    <label for="txmov">Movimiento:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txmov" class="form-control" value="0" />
                                </div>
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
                                    <label for="dlalmacen">Almacén:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select class="form-control" id="dlalmacen"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select class="form-control" id="dlcliente"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div id="dvjarceria" class="tbheader" style="height: 300px; overflow-y: scroll;">
                            <table class=" table table-condensed h6" id="tblistaj">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-active" colspan="2">Clave</th>
                                        <th class="bg-light-blue-active">Descripción</th>
                                        <th class="bg-light-blue-active">Unidad</th>
                                        <th class="bg-light-blue-active">Cantidad</th>
                                        <th class="bg-light-blue-active">Precio</th>
                                        <th class="bg-light-blue-active">Total</th>
                                    </tr>
                                    <tr>
                                        <td class=" col-xs-1">
                                            <input type="text" class=" form-control" id="txclave" />
                                        </td>
                                        <td class="col-xs-1">
                                            <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                        </td>
                                        <td class="col-xs-2">
                                            <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                                        </td>
                                        <td class="col-xs-1">
                                            <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                                        </td>
                                        <td class="col-xs-1">
                                            <input type="text" class=" form-control text-right" id="txcantidad" />
                                        </td>
                                        <td class="col-xs-1">
                                            <input type="text" class=" form-control text-right" id="txprecio" disabled="disabled" />
                                        </td>
                                        <td class="col-xs-1">
                                            <input type="text" class=" form-control text-right" disabled="disabled" id="txtotal" />
                                        </td>
                                        <td class="col-lg-1">
                                            <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                        </td>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                    </ol>
                </div>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
