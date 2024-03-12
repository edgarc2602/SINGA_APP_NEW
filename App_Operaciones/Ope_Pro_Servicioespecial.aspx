<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_Servicioespecial.aspx.vb" Inherits="App_Operaciones_Ope_Pro_Servicioespecial" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CORRECTIVO MAYOR</title>
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
        var dialog, dialog1, dialog2;
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha1').datepicker({ dateFormat: 'dd/mm/yy' });
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            var fecfac = new Date();
            var yyyy = fecfac.getFullYear().toString();
            var mm = (fecfac.getMonth() + 1).toString();
            var dd = fecfac.getDate().toString();
            if (dd < 10) {
                dd = "0" + dd;
            }
            if (mm < 10) {
                mm = "0" + mm;
            }
            $('#txfecha').val(dd + '/' + mm + '/' + yyyy);
            $('#dvrecursos').hide();
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
            cargacliente();
            cargatrabajo();
            $('#txcostodirecto').change(function () {
                if (isNaN($('#txcostodirecto').val())) {
                    alert('Debe coloca un importe')
                    $('#txcostodirecto').val('')
                    $('#txcostodirecto').focus();
                } else {
                    calculatotales();
                }
            });
            $('#txindirecto').change(function () {
                if (isNaN($('#txindirecto').val())) {
                    alert('Debe coloca un valor numerico')
                    $('#txindirecto').val('');
                    $('#txindirecto').focus();
                } else {
                    calculatotales();
                }
            });
            $('#txutilidad').change(function () {
                if (isNaN($('#txutilidad').val())) {
                    alert('Debe coloca un valor numerico')
                    $('#txutilidad').val('');
                    $('#txutilidad').focus();
                } else {
                    calculatotales();
                }
            })
            $('#btguarda').click(function () {
                if (validar()) {
                    waitingDialog({});
                    var farr = $('#txfecha').val().split('/');
                    var fregistro = farr[2] + farr[1] + farr[0];
                    var xmlgraba = '<servicio id= "' + $('#txfolio').val() + '" descripcion = "' + $('#txdesc').val() + '"';
                    xmlgraba += ' fregistro="' + fregistro + '" presupuesto="' + $('#txpresupuesto').val() + '"';
                    xmlgraba += ' indirecto="' + $('#txindirecto').val() + '" indirectom="' + $('#txindirectom').val() + '"';
                    xmlgraba += ' utilidad="' + $('#txutilidad').val() + '" utilidadm="' + $('#txutilidadm').val() + '" tope ="' + $('#txcostodirecto').val() + '"';
                    xmlgraba += ' trabajo="' + $('#dltrabajo').val() + '" usuario="' + $('#idusuario').val() + '"';
                    xmlgraba += ' inmueble="' + $('#dlsucursal').val() + '" proyecto="' + $('#dlcliente').val() + '"/>';
                    //alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, $('#txfolio').val(), function (res) {
                        closeWaitingDialog();
                        var rsl = eval('(' + res + ')');
                        $('#txfolio').val(res);
                        alert('Registro completado.');
                        //$('#dvrecursos').toggle('slide', { direction: 'down' }, 500);
                    }, iferror);
                }
            });
            $('#btsolicitudrecur').click(function () {
                window.open('../App_Finanzas/Fin_Pro_Solicitudrecurso.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
            })
            if ($('#idservicio').val() != 0) {                
                cargaservicio();
            }
            $('#btnuevo').click(function () {
                location.reload();
            })            
        })
        function cargaservicio() {
            PageMethods.servicio($('#idservicio').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfecha').val(datos.fregistro);
                $('#txstatus').val(datos.estatus);
                $('#idcliente').val(datos.id_cliente);
                cargacliente();
                $('#idinmueble').val(datos.id_inmueble);
                cargainmueble(datos.id_cliente);
                $('#idtrabajo').val(datos.id_trabajo);
                cargatrabajo();
                $('#txdesc').val(datos.concepto);                
                $('#txcostodirecto').val(datos.costodirecto);
                $('#txindirecto').val(datos.indirectop);
                $('#txindirectom').val(datos.indirectom);
                $('#txutilidad').val(datos.utilidadp);
                $('#txutilidadm').val(datos.utilidadm);
                $('#txpresupuesto').val(datos.presupuesto);
                $('#txutilizado').val(datos.solicitado)
            }, iferror);
        }
        function validar() {
            return true;
        }
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlcliente').empty()
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val());
                }
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                });
            }, iferror);
        }
        function cargainmueble(cliente) {
            PageMethods.inmueble(cliente, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);
                if ($('#idinmueble').val() != 0) {
                    $('#dlsucursal').val($('#idinmueble').val());
                }
            }, iferror);
        }
        function cargatrabajo() {
            PageMethods.trabajo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltrabajo').append(inicial);
                $('#dltrabajo').append(lista);
                if ($('#idtrabajo').val() != 0) {
                    $('#dltrabajo').val($('#idtrabajo').val());
                }
            }, iferror);
        }
        
        function calculatotales() {
            var indirecto = 0
            var utilidadm = 0
            var ptto = 0
            if ($('#txcostodirecto').val() != '' && $('#txindirecto').val() != '') {
                indirecto = parseFloat($('#txcostodirecto').val()) * parseFloat(($('#txindirecto').val() / 100))
                $('#txindirectom').val(parseFloat(indirecto).toFixed(2))
            }
            if ($('#txcostodirecto').val() != '' && $('#txutilidad').val() != '') {
                var utilidadm = parseFloat($('#txcostodirecto').val()) * parseFloat(($('#txutilidad').val() / 100));
                $('#txutilidadm').val(parseFloat(utilidadm).toFixed(2))
            }
            var ptto = parseFloat($('#txcostodirecto').val()) + parseFloat($('#txindirectom').val()) + parseFloat($('#txutilidadm').val());
            $('#txpresupuesto').val(parseFloat(ptto).toFixed(2))
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Creando registros');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idservicio" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idtrabajo" runat="server" Value="0" />
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
                <div class="content-header" id="lbtipotrabajo">
                    <h1>Servicios Especiales<small>Limpieza</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Limpieza</a></li>
                        <li class="active">Servicios</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div id="dvdetalle">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfolio">Folio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="status">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txstatus" class="form-control" disabled="disabled" value="Alta" />
                                </div>
                            </div>

                            <br />
                            <div class="row">
                                <div id="cliente0">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlcliente">Cliente:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlcliente" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dlsucursal">Punto de atención</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlsucursal" class="form-control"></select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltrabajo">Trabajo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltrabajo" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txdesc">Descripcion Trabajo:</label>
                                </div>
                                <div class="col-lg-6">
                                    <textarea id="txdesc" class="form-control"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcostodirecto">Costo directo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txcostodirecto" class="form-control text-right" />
                                </div>
                                <div class="col-lg-3 text-right">
                                    <label for="txutilizado">Importe solicitado hasta ahora:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txutilizado" class="form-control text-right" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txindirecto">Costo Indirecto:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txindirecto" class="form-control text-right" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txindirecto">%</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txindirectom" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txutilidad">Utilidad:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txutilidad" class="form-control text-right" value="" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txutilidad">%</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txutilidadm" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txpresupuesto">Precio de venta s/IVA:</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txpresupuesto" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                            </div>
                        </div>
                        <hr />
                        <div class="row" id="dvrecursos">
                            <div id="dvtrabajos" class="col-md-2">
                                <ul class="list-group">
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btsolicitudrecur">Solicitar de Recursos</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btsolicitudrecver">Ver Recursos solicitados</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
