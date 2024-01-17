<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_ordencompra.aspx.vb" Inherits="App_Compras_Com_Pro_ordencompra" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ORDEN DE COMPRA</title>
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
        .cb{
            width: 20px; 
            height: 20px; 
        }
        
        #tblistaj tbody td:nth-child(9){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var d = new Date();
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#txanio').val(d.getFullYear());
            dialog2 = $('#divmodal1').dialog({
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
            var f = new Date();
            var mm = f.getMonth() + 1
            //alert(mm.toString().length);
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(f.getDate() + "/" + mm + "/" + f.getFullYear());
            if ($('#idorden').val() != 0){
                cargaorden($('#idorden').val());
            }
            cargaempresa();
            cargaproveedor();
            cargaalmacen();
            cargacliente();
            cargacomprador();
            cargames();
            $('#idcomprador').val($('#idusuario').val());
            $('#txcomprador').val('<%=minombre%>');
            $('#txclave').change(function () {
                cargaproducto($('#txclave').val());
            })
            $('#btagrega').click(function () {
                if (validamat()) {
                    var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                    linea += '<input class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistaj tbody').append(linea);
                    $('#tblistaj').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                        total();
                    });
                    $('#tblistaj tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        total();
                    });
                    total()
                    limpiaproducto();
                }
            })
            $('#txcantidad').change(function () {
                subtotal();
            })
            $('#txprecio').change(function () {
                subtotal();
            })
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog2.dialog('open');
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        $('#txprecio').val($(this).children().eq(3).text());
                        dialog2.dialog('close');
                    });
                }, iferror)
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var matinv = 0;
                    if ($('#cbinventario').is(':checked')) {
                        matinv = 1;
                    }
                    var xmlgraba = '<movimiento> <compra id="' + $('#txfolio').val() + '" empresa="' + $('#dlempresa').val() + '"' ;
                    xmlgraba += ' proveedor="' + $('#dlproveedor').val() + '" cliente="' + $('#dlcliente').val() + '" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba += ' forma="' + $('#dlforma').val() + '" usuario="' + $('#idusuario').val() + '" observacion="' + $('#txobservacion').val() + '"';
                    xmlgraba += ' subtot= "' + $('#txsubtotalg1').val() + '" iva = "' + $('#txivag').val() + '" total = "' + $('#txtotalg').val() + '" idreq = "' + $('#idrequisicion').val() + '"';
                    xmlgraba += ' inventario="' + matinv + '" comprador="' + $('#idcomprador').val() + '" piva="' + $('#dliva').val() + '"';
                    xmlgraba += ' subtotp= "' + $('#txsubtotalg').val() + '" flete= "' + $('#txflete').val() + '" descuento= "' + $('#txdescuento').val() + '"';
                    xmlgraba += '  mes="' + $('#dlmes').val() + '" anio="' + $('#txanio').val() + '"/>';
                    $('#tblistaj tbody tr').each(function () {
                        xmlgraba += '<partida clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) +'"';
                        xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find("input:eq(1)").val()) + '" total="' + parseFloat($(this).closest('tr').find("input:eq(2)").val()) + '"';
                        xmlgraba += ' reqlinea="' + $(this).closest('tr').find('td').eq(8).text() + '"/>'
                    });
                    xmlgraba += '</movimiento>';
                    //alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado');
                        if ($('#idrequisicion').val() != 0) {
                            PageMethods.validareq($('#idrequisicion').val(), function (res) {
                                //alert(res);
                                if (res == 1) {
                                    alert('Se han completado los productos de la Requisición en ordenes de compra, se ha cambiado el estatus de la requisicion a COMPLETADO, ya no podra generar mas ordenes de compra de esta Requisición');
                                } else {
                                    alert('Aun quedan materiales pendientes de la requisicón seleccionada');
                                }
                            }, iferror);
                        }
                    }, iferror);
                }
            })
            $('#btimprime').click(function () {
                var formula = '{tb_ordencompra.id_orden}=' + $('#txfolio').val();
                window.open('../RptForAll.aspx?v_nomRpt=ordencompra.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
            if ($('#idrequisicion').val() != 0) {
                $('#txrequisicion').val($('#idrequisicion').val());
                cargarequisicion();
            }
            $('#dliva').change(function () {
                total();
            })
            $('#txflete').change(function () {
                if (isNaN($('#txflete').val())) {
                    alert('Debe colocar un importe correcto');
                    $('#txflete').val(0);
                } else {
                    total();
                }
            })
            $('#txdescuento').change(function () {
                total();
            })
            
        });
        function cargacomprador() {
            PageMethods.comprador($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idcomprador').val(datos.id);
            }, iferror)
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
                if ($('#idmes').val() != 0) {
                    $('#dlmes').val($('#idmes').val());
                }
            }, iferror);
        }
        function cargaorden(idorden) {
            PageMethods.orden(idorden, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfolio').val(datos.id);
                $('#txrequisicion').val(datos.req)
                $('#txfecha').val(datos.falta);
                $('#tiporeq').val(datos.tipo);
                $('#idcomprador').val(datos.idcomprador);
                $('#txcomprador').val(datos.comprador);
                $('#idempresa').val(datos.id_empresa);
                cargaempresa();
                $('#idproveedor').val(datos.id_proveedor);
                cargaproveedor();
                $('#dlforma').val(datos.formapago);
                $('#idalmacen').val(datos.id_almacen);
                cargaalmacen();
                $('#idcliente').val(datos.id_cliente);
                cargacliente();
                $('#txsubtotalg').val(datos.subtotalp);
                $('#txflete').val(datos.flete);
                $('#txdescuento').val(datos.descuento);
                $('#txsubtotalg1').val(datos.subtotal);
                $('#txivag').val(datos.iva);
                $('#txtotalg').val(datos.total);
                $('#txobservacion').val(datos.observacion);
                if (datos.inventario == "True") { $('#cbinventario').prop("checked", true); } else { $('#cbinventario').prop("checked", false); }
                $('#dliva').val(datos.piva);
                $('#idmes').val(datos.mes);
                cargames();
                $('#txanio').val(datos.anio);
                detalleoc(datos.id)
                
            })
        }
        function detalleoc(folio) { //, tiporeq
            PageMethods.cargadetalleoc(folio, function (res) { //tiporeq,
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                    $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                    total();
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    $(this).parent().eq(0).parent().eq(0).remove();
                    total();
                });
            }, iferror)
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val(0);
            $('#txtotal').val('');
        }
        function cargarequisicion() {
            PageMethods.requisicion($('#idrequisicion').val(),  function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idempresa').val(datos.empresa);
                cargaempresa();
                $('#idproveedor').val(datos.proveedor);
                cargaproveedor();
                $('#idcliente').val(datos.cliente);
                cargacliente();
                $('#idalmacen').val(datos.almacen);
                cargaalmacen();
                $('#dlforma').val(datos.formapago);
                //$('#txsubtotalg').val(datos.subtotal);
                //$('#txivag').val(datos.iva);
                //$('#txtotalg').val(datos.total);
                $('#idcomprador').val(datos.idcomprador);
                $('#txcomprador').val(datos.comprador);
                $('#dliva').val(datos.piva);
                $('#idmes').val(datos.mes);
                cargames();
                $('#txanio').val(datos.anio);

                detallereq($('#idrequisicion').val(), $('#idfamilia').val());
                
            }, iferror);
        }
        function detallereq(folio, familia) {
            PageMethods.cargadetalle(folio, familia,  function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                    $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                    total();
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    $(this).parent().eq(0).parent().eq(0).remove();
                    total();
                });
                total();
            }, iferror)
        }
        function valida() {
            if ($('#dlempresa').val() == 0) {
                alert('Debe elegir la empresa');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de orden de compra');
                return false;
            }
            if ($('#dlproveedor').val() == 0) {
                alert('Debe elegir el proveedor');
                return false;
            }
            if ($('#dlforma').val() == 0) {
                alert('Debe elegir la forma de pago');
                return false;
            }
            if ($('#cbinventario').is(':checked')) {
                if ($('#dlalmacen').val() == 0) {
                    alert('Si el material ingresa al inventario, deberá elegir un almacen');
                    return false;
                }
            }
            /*
            if ($('#dlalmacen').val() == 0) {
                alert('Debe elegir el almacén');
                return false;
            }*/
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir el mes de la compra');
                return false;
            }
            if ($('#txanio').val() == '') {
                alert('Debe colocar el año');
                return false;
            }
            return true;
        }
        function subtotal() {
            var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val());
            $('#txtotal').val(tot.toFixed(2));
        }
        function total() {
            var subtotal = 0;
            var iva = 0;
            var total = 0;
            $('#tblistaj tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(2)").val());
            });
            // ACTUALIZACION DE LOS TOTALES
            subtotal1 = subtotal
            if ($('#txflete').val() != 0) {
                subtotal1 = subtotal1 + parseFloat($('#txflete').val());
            }
            if ($('#txdescuento').val() != 0) {
                subtotal1 = subtotal1 - parseFloat($('#txdescuento').val());
            }
            
            iva = subtotal1 * parseFloat($('#dliva').val())
            total = subtotal1 + iva
            $('#txsubtotalg').val(subtotal.toFixed(2));
            $('#txsubtotalg1').val(subtotal1.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
        }
        function cargaproveedor() {
            PageMethods.catproveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
                if ($('#idproveedor').val() != 0) {
                    $('#dlproveedor').val($('#idproveedor').val());
                }
                /*
                $('#dlproveedor').change(function () {
                    detalleproveedor();
                })*/
            }, iferror);
        }
        function cargaempresa() {
            PageMethods.empresa(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempresa').empty();
                $('#dlempresa').append(inicial);
                $('#dlempresa').append(lista);
                if ($('#idempresa').val() != 0) {
                    $('#dlempresa').val($('#idempresa').val());
                }
            }, iferror);
        }
        function detalleproveedor() {
            PageMethods.datosproov($('#dlproveedor').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txrazon').val(datos.razon);
                $('#txcondicion').val(datos.credito);
                $('#txbanco').val(datos.banco);
                $('#txcuenta').val(datos.cuenta);
            }, iferror);
        }
        function cargaalmacen() {
            PageMethods.almacen(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlalmacen').empty();
                $('#dlalmacen').append(inicial);
                $('#dlalmacen').append(lista);
                if ($('#idalmacen').val() != 0) {
                    $('#dlalmacen').val($('#idalmacen').val());
                }
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
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val());
                }
            }, iferror);
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc').val(datos.producto);
                    $('#txunidad').val(datos.unidad);
                    $('#txprecio').val(datos.precio);
                    $('#txcantidad').focus();
                } else {
                    alert('La clave de producto capturada no existe, verifique');
                    limpiaproducto();
                }
            }, iferror)
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
        <asp:HiddenField ID="idrequisicion" runat="server" Value="0" />
        <asp:HiddenField ID="idempresa" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen" runat="server" Value="0" />
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="idcomprador" runat="server" Value="0" />
        <asp:HiddenField ID="idfamilia" runat="server" Value="0" />
        <asp:HiddenField ID="tiporeq" runat="server" Value="0" />
        <asp:HiddenField ID="idmes" runat="server" Value="0" />
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
                    <h1>Orden de Compra<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Orden de compra</li>
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
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfolio">No. OC:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txrequisicion">No. Req:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txrequisicion" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <!--
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo de compra:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Materiales</option>
                                        <option value="2">Servicios</option>
                                    </select>
                                </div>-->
                                <div class="col-lg-2 text-right">
                                    <label for="dlempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlempresa" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlproveedor">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txcomprador">Comprador:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcomprador" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlforma">Pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlforma" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Credito</option>
                                        <option value="2">Contado</option>
                                    </select>
                                </div>
                            </div>
                                
                            <!--
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcondicion">Pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txcondicion" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txbanco">Banco:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txbanco" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcuenta">Cuenta:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcuenta" class="form-control" disabled="disabled" />
                                </div>
                            </div>-->
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4" style="margin-left:200px;">
                                    <input type="checkbox" id="cbinventario" class="cb" /><label for="cbinventario" style="font-size: 20px; margin-left: 10px;">Este material ingresa al inventario</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlalmacen">Almacén:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlalmacen" class="form-control"></select>
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
                    </div>
                    <div class="tbheader" style="height: 300px; overflow-y: scroll;">
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
                                        <input type="text" class=" form-control text-right" id="txprecio" />
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
                    <hr />
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txsubtotalg">Subtotal Productos:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalg" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txflete">Fletes:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" id="txflete" value="0"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txdescuento">Descuento:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right"  id="txdescuento" value="0"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txsubtotalg1">Subtotal:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right"  id="txsubtotalg1" value="0"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txivag">IVA:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" disabled="disabled" id="txivag" />
                        </div>
                        <div class="col-lg-2">
                            <select id="dliva" class="form-control">
                                <option value="0.08">8 %</option>
                                <option value="0.16" selected="selected">16 %</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txtotalg">Total:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" disabled="disabled" id="txtotalg" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-2 text-right">
                            <label for="txobservacion">Observaciones:</label>
                        </div>
                        <div class="col-lg-5">
                            <textarea id="txobservacion" class=" form-control"></textarea>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Cancelar</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
