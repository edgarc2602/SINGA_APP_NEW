<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_Listadomateriala.aspx.vb" Inherits="App_Operaciones_Ope_Pro_Listadomateriala" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LISTADOS DE MATERIALES ADICIONALES</title>
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
            cargacliente();
            cargames();
            $('#txclave').change(function () {
                cargaproducto($('#txclave').val());
            })
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#txcantidad').change(function () {
                var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val())
                $('#txtotal').val(tot.toFixed(2));
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    var resp = true;
                    if ($('#dltipo').val() == 2) {
                        resp = confirm('Cuando se genera un listado de materiales adicionales, este se enviara al área de facturación para que se cobre al cliente, ¿esta seguro de continuar')
                    }                     
                    if (resp == true) {
                        waitingDialog({});
                        var xmlgraba = '<listado id="' + $('#txfolio').val() + '" tipo ="' + $('#dltipo').val() + '" cliente= "' + $('#dlcliente').val() + '" inmueble="' + $('#dlsucursal').val() + '" mes= "' + $('#dlmes').val() + '" mesa ="0" anio= "' + $('#txanio').val() + '"';
                        xmlgraba += ' usuario= "' + $('#idusuario').val() + '" opcion = "1" />';
                        $('#tblistaj tbody tr').each(function () {
                            xmlgraba += '<partida clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"';
                            xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find("input:eq(1)").val()) + '" total="' + parseFloat($(this).closest('tr').find("input:eq(2)").val()) + '"/>'
                        });
                        PageMethods.guarda(xmlgraba, function (res) {
                            closeWaitingDialog();
                            $('#txfolio').val(res);
                            alert('Registro completado');
                        })
                    }            
                }
            })
            $('#btagrega').click(function () {
                if (validamat()) {
                    var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                    linea += '<input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistaj tbody').append(linea);
                    subtotal();
                    $('#tblistaj tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        subtotal();
                       
                    });
                    limpiaproducto();
                }
            })
            $('#dltipo').change(function () {
                switch ($('#dltipo').val()) {
                    case '3':
                    case '4':
                        $('#dvvalidalista').show();
                        cargaptto();
                        break
                    default:
                        $('#txptto').val(0);
                        $('#txusado').val(0);
                        $('#txdisponible').val(0);
                        break
                }
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), $('#dlsucursal').val(), $('#dlcliente').val(), $('#dltipo').val(), function (res) {
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
            $('#btnuevo').click(function () {
                location.reload();
            })
        })
        function cargaptto() {
            if ($('#dlcliente').val() != 0 && $('#dltipo').val() != 0 && $('#dlmes').val() != 0 && $('#txanio').val() != '') {
                PageMethods.listadomes($('#dlcliente').val(), $('#dltipo').val(), $('#dlmes').val(), $('#txanio').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txptto').val(datos.ptto);
                    $('#txusado').val(datos.usado);
                    var disp = parseFloat(datos.ptto) - parseFloat(datos.usado)
                    $('#txdisponible').val(disp.toFixed(2));
                }, iferror);
            }            
        }
        function valida() {
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir un Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe elegir un Punto de atención');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de listado');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir el mes');
                return false;
            }           
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            if ($('#dltipo').val() != 2) {
                if (parseFloat($('#txsolicitado').val()) > parseFloat($('#txdisponible').val())) {
                    alert('El monto del listado supera el presupuesto disponible, no puede continuar');
                    return false;
                }
            }
            return true;
        }
        function cargadetalle() {
            PageMethods.listadod($('#txfolio').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    $(this).closest('tr').find('td').eq(6).text($(this).closest('tr').find("input:eq(0)").val() * $(this).closest('tr').find('td').eq(5).text());
                    subtotal();
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    PageMethods.eliminalinea($('#txfolio').val(), $(this).closest('tr').find('td').eq(0).text(), function () {
                    }, iferror);
                    $(this).parent().eq(0).parent().eq(0).remove();
                    subtotal();
                });
                subtotal();
            });
        }
        function subtotal() {            
            var total = 0;
            $('#tblistaj tbody tr').each(function () {
                total += parseFloat($(this).closest('tr').find("input:eq(2)").val());
            });
            $('#txsolicitado').val(total.toFixed(2));
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
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblistaj tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                    alert('Este producto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            if ($('#dltipo').val() != 2) {
                if (parseFloat($('#txsolicitado').val()) + parseFloat($('#txtotal').val()) > parseFloat($('#txdisponible').val())) {
                    alert('Al agregar este material supera el importe disponible, en un listado complementario no puede superar el disponible');
                    return false;
                }
            }
            return true;
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
                    cargainmueble($('#dlcliente').val());
                    cargaptto();
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
                $('#dlmes').change(function () {                    
                    cargaptto();
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
                if ($('#idsucursal').val() != '') {
                    $('#dlsucursal').val($('#idsucursal').val());
                };
            }, iferror);
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, $('#dlsucursal').val(), $('#dlcliente').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc').val(datos.producto);
                    $('#txunidad').val(datos.unidad);
                    $('#txprecio').val(datos.precio);
                    $('#txcantidad').focus();
                } else {
                    alert('La clave de producto capturada no existe o bien no puede ser utilizada con este Cliente, verifique');
                    limpiaproducto();
                }
            })
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val('');
            $('#txtotal').val('');
            $('#txclave').focus();
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
        <asp:HiddenField ID="idsucursal" runat="server" Value="0" />
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <h1>Listados de materiales adicionales<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Listados</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-6 text-right">
                                    <label for="txfolio">Folio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atencion:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlmes">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="2">Adicionales</option>
                                        <option value="3">Complemento de la iguala</option>
                                        <option value="4">Material para pulido</option>
                                    </select>
                                </div>                                                           
                            </div>                            
                            <div class="row" id="dvvalidalista">
                                <div class="col-lg-1 ">
                                    <label for="txptto">Presupuesto:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txptto" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txusado">Utilizado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txusado" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txdisponible">Disponible:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txdisponible" class="form-control text-right" disabled="disabled" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="dvjarceria" class="row tbheader" style="height: 350px; overflow-y: scroll;">
                        <table class=" table table-condensed h6" id="tblistaj">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active" colspan="2">Clave</th>
                                    <th class="bg-light-blue-active">Descripción</th>
                                    <th class="bg-light-blue-active">Unidad</th>
                                    <th class="bg-light-blue-active">Cantidad</th>
                                    <th class="bg-light-blue-active">Precio</th>
                                    <th class="bg-light-blue-active">total</th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                                <tr>
                                    <td class=" col-xs-1">
                                        <input type="text" class=" form-control" id="txclave" />
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                    </td>
                                    <td class="col-xs-2">
                                        <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control" id="txcantidad" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control" disabled="disabled" id="txprecio" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control" disabled="disabled" id="txtotal" />
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-lg-9 text-right">
                            <label for="txsolicitado">Total del listado:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" id="txsolicitado" class="form-control text-right" disabled="disabled" value="0" />
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>                        
                    </ol>
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label></div>
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
