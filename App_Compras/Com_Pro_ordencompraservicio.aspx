<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_ordencompraservicio.aspx.vb" Inherits="App_Compras_Com_Pro_ordencompraservicio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ORDEN DE COMPRA DE SERVICIOS</title>
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
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
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
            $('#txanio').val(d.getFullYear());
            var f = new Date();
            var mm = f.getMonth() + 1
            //alert(mm.toString().length);
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(f.getDate() + "/" + mm + "/" + f.getFullYear());
            if ($('#idorden').val() != 0) {
                cargaorden($('#idorden').val());
            }
            $('#txcomprador').val('<%=minombre%>');
            cargacomprador();
            cargaempresa();
            cargaproveedor();
            cargacliente();
            cargames();
            if ($('#idorden').val() != 0) {
                cargaorden($('#idorden').val());
            }
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var xmlgraba = '<compra id="' + $('#txfolio').val() + '" empresa="' + $('#dlempresa').val() + '"';
                    xmlgraba += ' proveedor="' + $('#dlproveedor').val() + '" cliente="' + $('#dlcliente').val() + '" concepto="' + $('#txconcepto').val() + '"';
                    xmlgraba += ' forma="' + $('#dlforma').val() + '" usuario="' + $('#idusuario').val() + '" observacion="' + $('#txobservacion').val() + '"';
                    xmlgraba += ' subtot= "' + $('#txsubtotalg1').val() + '" iva = "' + $('#txivag').val() + '" total = "' + $('#txtotalg').val() + '" ';
                    xmlgraba += ' comprador="' + $('#idcomprador').val() + '" piva="' + $('#dliva').val() + '"';
                    xmlgraba += ' subtotp= "' + $('#txsubtotalg').val() + '" retencion= "' + $('#txretencion').val() + '" descuento= "' + $('#txdescuento').val() + '"';
                    xmlgraba += '  mes="' + $('#dlmes').val() + '" anio="' + $('#txanio').val() + '"/>';
                    //alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado');
                        
                    }, iferror);
                }
            })
            $('#txsubtotalg').change(function () {
                if (isNaN($('#txsubtotalg').val())) {
                    alert('Debe colocar un importe correcto');
                    $('#txsubtotalg').val(0);
                } else {
                    total();
                }
            })
            $('#txretencion').change(function () {
                if (isNaN($('#txretencion').val())) {
                    alert('Debe colocar un importe correcto');
                    $('#txretencion').val(0);
                } else {
                    total();
                }
            })
            $('#txdescuento').change(function () {
                if (isNaN($('#txdescuento').val())) {
                    alert('Debe colocar un importe correcto');
                    $('#txdescuento').val(0);
                } else {
                    total();
                }
            })
            $('#dliva').change(function () {
                total();
            })
            $('#btimprime').click(function () {
                var formula = '{tb_ordencompra.id_orden}=' + $('#txfolio').val();
                window.open('../RptForAll.aspx?v_nomRpt=ordencompraservicio.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        })
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
                $('#idcliente').val(datos.id_cliente);
                cargacliente();
                $('#txsubtotalg').val(datos.subtotalp);
                $('#txretencion').val(datos.retencion);
                $('#txdescuento').val(datos.descuento);
                $('#txsubtotalg1').val(datos.subtotal);
                $('#txivag').val(datos.iva);
                $('#txtotalg').val(datos.total);
                $('#txobservacion').val(datos.observacion);
                $('#dliva').val(datos.piva);
                $('#idmes').val(datos.mes);
                cargames();
                $('#txanio').val(datos.anio);
                $('#txconcepto').val(datos.concepto);
            })
        }
        function total() {
            var subtotal1 = 0;
            var iva = 0;
            var total = 0;
            // ACTUALIZACION DE LOS TOTALES
            subtotal1 = parseFloat($('#txsubtotalg').val());
            if ($('#txretencion').val() != 0) {
                subtotal1 = parseFloat(subtotal1) - parseFloat($('#txretencion').val());
            }
            if ($('#txdescuento').val() != 0) {
                subtotal1 = parseFloat(subtotal1) - parseFloat($('#txdescuento').val());
            }
            
            iva = subtotal1 * parseFloat($('#dliva').val())
            total = parseFloat(subtotal1) + parseFloat(iva)
            $('#txsubtotalg1').val(subtotal1.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
        }
        function cargacomprador() {
            PageMethods.comprador($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idcomprador').val(datos.id);
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
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir el mes de la compra');
                return false;
            }
            if ($('#txanio').val() == '') {
                alert('Debe colocar el año');
                return false;
            }
            if ($('#txconcepto').val() == '') {
                alert('Debe capturar el concepto del servicio');
                return false;
            }
            if ($('#txsubtotalg').val() == 0) {
                alert('Debe capturar el importe del servicio');
                return false;
            }
            return true;
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
                    <h1>Orden de Compra de Servicios<small>Compras</small></h1>
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
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-3 text-right">
                                    <label for="txfolio">No. OC:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <!--
                                <div class="col-lg-1">
                                    <label for="txrequisicion">No. Req:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txrequisicion" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                -->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlempresa" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
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
                            <div class="row">
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
                                <div class="col-lg-1 text-right">
                                    <label for="dlmes">Concepto:</label>
                                </div >
                                <div class="col-lg-7">
                                    <textarea class=" form-control" id="txconcepto"></textarea>
                                </div>
                            </div>
                            <hr />
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txsubtotalg">Importe:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" id="txsubtotalg" value="0" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txretencion">Retención:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" id="txretencion" value="0"/>
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
                            <input type="text" class=" form-control text-right"  id="txsubtotalg1" disabled="disabled" value="0"/>
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
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
