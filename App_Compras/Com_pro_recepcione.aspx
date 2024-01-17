<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_pro_recepcione.aspx.vb" Inherits="App_Compras_Com_pro_recepcione" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>RECEPCION DE COMPRA</title>
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
            $('#txfacfec').datepicker({ dateFormat: 'dd/mm/yy' });
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
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear());
            if ($('#idorden').val() != 0) {
                cargaorden($('#idorden').val());
            }
            
            /*
            $('#btguarda').click(function () {
                if (valida()) {
                    //waitingDialog({});
                    
                    var fini = $('#txfacfec').val().split('/');
                    var falta = fini[2] + fini[1] + fini[0];
                    var xmlgraba = '<Movimiento> <salida documento="3" almacen1="0" factura= "' + $('#txfactura').val() + '"';
                    xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="0"';
                    xmlgraba += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '" fecfac="' + falta + '"/>';
                    xmlgraba += '</Movimiento>';
                    alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, function (res) {
                        
                        closeWaitingDialog();
                        if (res == 0) {
                            alert('algo salio mal');
                        } else {
                            $('#txfolio').val(res);
                            alert('Registro completado');
                        }
                    }, iferror);
                }
            })*/
        })
        function valida() {
            if ($('#estatus').val() == 4) {
                alert('Ya se ha registrado la factura de la orden de compra que eligio, no puede continuar');
                return false;
            }
            if ($('#txfolio').val() !=  0) {
                alert('El registro de la factura ya ha sido aplicado, no puede duplicar');
                return false;
            }
            if ($('#txfactura').val() == '') {
                alert('Debe colocar un numero de factura o remisión');
                return false;
            }
            if ($('#txfacfec').val() == '') {
                alert('Debe colocar al fecha de la factura');
                return false;
            }
            return true;
        }
        function cargaorden(idorden) {
            PageMethods.orden(idorden, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txoc').val(datos.id);
                $('#txrequisicion').val(datos.req)
                $('#txproveedor').val(datos.proveedor);
                $('#idproveedor').val(datos.idpro);
                $('#txempresa').val(datos.empresa);
                $('#txcliente').val(datos.cliente);
                $('#txsubtotal').val(datos.subtotal);
                $('#txiva').val(datos.iva);
                $('#txtotal').val(datos.total);
                $('#idcliente').val(datos.idcte);
                $('#estatus').val(datos.estatus);
                $('#txcredito').val(datos.credito);
            }, iferror)
        }
        function xmlUpFile(res) {
            if (valida()) {
                
                waitingDialog({});
                var fileup = $('#txarchivo').get(0);
                var files = fileup.files;

                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                ndt.append('oc', $('#txoc').val());
                $.ajax({
                    url: '../GH_Uppdf.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function () {
                        //closeWaitingDialog();
                        /*
                        for (var i = 0; i < files.length; i++) {
                            alert(files[i].name);
                        }*/
                        var fini = $('#txfacfec').val().split('/');
                        var falta = fini[2] + fini[1] + fini[0];
                        var xmlgraba = '<Movimiento> <salida documento="3" almacen1="0" factura= "' + $('#txfactura').val() + '"';
                        xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="0"';
                        xmlgraba += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '" fecfac="' + falta + '"';
                        xmlgraba += ' idproveedor ="' + $('#idproveedor').val() + '" dias ="' + $('#txcredito').val() + '"'
                        xmlgraba += ' sub ="' + $('#txsubtotal').val() + '" iva ="' + $('#txiva').val() + '" '
                        xmlgraba += ' total ="' + $('#txtotal').val() + '"/>'
                        for (var i = 0; i < files.length; i++) {
                            xmlgraba += '<archivo nombre="' + files[i].name +'"/>';
                        }
                        xmlgraba += '</Movimiento>';
                        //alert(xmlgraba);
                        
                        PageMethods.guarda(xmlgraba, function (res) {

                            closeWaitingDialog();
                            if (res == 0) {
                                alert('algo salio mal');
                            } else {
                                $('#txfolio').val(res);
                                alert('Registro completado');
                            }
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="estatus" runat="server" Value="0" />
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
                    <h1>Recepción de compra para Provisión<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Ordenes de compra</li>
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
                                <div class="col-lg-3 text-right">
                                    <label for="txfecha">Fecha recepción:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txfolio">No recepción:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txoc">No. OC:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txoc" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txrequisicion">No. Req:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txrequisicion" class="form-control text-right" disabled="disabled"  />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txempresa" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txproveedor">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txproveedor" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txcredito">días de crédito:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcredito" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txempresa">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Archivo PDF:</label>
                                </div>
                                <div class="col-lg-8">
                                    <input type="file" id="txarchivo" class="form-control" multiple="multiple"/>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfactura">Factura/Remisión:</label>
                                </div>
                                 <div class="col-lg-2">
                                    <input type="text" id="txfactura" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txfacfec">Fecha de factura:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfacfec" class="form-control" />
                                </div>
                                <!--
                                <div class="col-lg-2 text-right">
                                    <label for="txfacfec">Vencimiento:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecven" class="form-control" />
                                </div>
                                -->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txsubtotal">Subtotal:</label>
                                </div>
                                 <div class="col-lg-2">
                                    <input type="text" id="txsubtotal" class="form-control text-right" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txiva">IVA:</label>
                                </div>
                                 <div class="col-lg-2">
                                    <input type="text" id="txiva" class="form-control text-right" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txtotal">Total:</label>
                                </div>
                                 <div class="col-lg-2">
                                    <input type="text" id="txtotal" class="form-control text-right" />
                                </div>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <!--<li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>-->
                            <li id="btguarda" class="puntero" onclick="xmlUpFile()"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>-->
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
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
