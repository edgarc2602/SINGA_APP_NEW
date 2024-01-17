<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_recepcion.aspx.vb" Inherits="App_Compras_Com_Pro_recepcion" %>

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
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
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
            $('#txoc').val($('#idorden').val());
            if ($('#idorden').val() != 0) {
                cargaorden();
                cargalista();
            }
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var fini = $('#txfacfec').val().split('/');
                    var falta = fini[2] + fini[1] + fini[0];
                    var xmlgraba = '<Movimiento> <salida documento="3" almacen1="0" factura= "' + $('#txfactura').val() + '"';
                    xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                    xmlgraba += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '" fecfac="' + falta + '"/>'
                    $('#tblista tbody tr').each(function () {
                        xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"';
                        xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find('td').eq(3).text()) + '"/>';
                    });
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
                }
            })
        })
        function valida() {
            if ($('#txfolio').val() != 0) {
                alert('Ya aplico la recepción, no puede duplicar');
                return false;
            }
            if ($('#txfactura').val() == '') {
                alert('Debe colocar un numero de Factura o Remisión');
                return false;
            }
            return true;
        }
        function cargalista() {
            waitingDialog({});
            PageMethods.detalleoc($('#idorden').val(), function (res) {
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
        function cargaorden(){
            PageMethods.cargaoc($('#idorden').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txrequisicion').val(datos.req);
                $('#txproveedor').val(datos.proveedor);
                $('#txalmacen').val(datos.almacen);
                $('#txempresa').val(datos.empresa);
                $('#txcliente').val(datos.cliente);
                $('#idalmacen').val(datos.idalmacen);
                $('#idcliente').val(datos.idcliente);
            }, iferror)
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
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="idempresa" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen" runat="server" Value="0" />
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
                    <h1>Recepción de Compra<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Recepción de compra</li>
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
                                    <label for="txfecha">Fecha recepción:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-lefth">
                                    <label for="txfolio">NoRecepción:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control" disabled="disabled" />
                                </div>
                                 <div class="col-lg-1 text-right">
                                    <label for="txalmacen">Almacen:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txalmacen" class="form-control" disabled="disabled" />
                                </div>                               
                            </div>
                             <div class="row">   
                                <div class="col-lg-2 text-right">
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
                                    <label for="txproveedor">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txproveedor" class="form-control" disabled="disabled" />
                                </div>                                
                            </div>

                            <div class="row">
                                 <div class="col-lg-2 text-right ">
                                    <label for="txempresa">Cliente:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                                </div>
                                   <div class="col-lg-1">
                                    <label for="txempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txempresa" class="form-control" disabled="disabled" />
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
                            </div>
                        </div>
                        <div class="row ">
                            <div class="tbheader" style="height: 300px; overflow-y: scroll;">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Clave</span></th>
                                            <th class="bg-navy"><span>Producto</span></th>
                                            <th class="bg-navy"><span>Unidad</span></th>
                                            <th class="bg-navy"><span>Precio</span></th>
                                            <th class="bg-navy"><span>Cantidad pendiente</span></th>
                                            <th class="bg-navy"><span>Recibido</span></th>  
                                            <th class="bg-navy"><span></span></th> 
                                            <th class="bg-navy"><span></span></th>  
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <!--<li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>-->
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>-->
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                        </ol>
                        <div id="divmodal1">
                        <div class="row">
                            <div class="tbheader">
                                <table class="table table-condensed" id="tbbusca">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Clave</span></th>
                                            <th class="bg-navy"><span>Producto</span></th>
                                            <th class="bg-navy"><span>N.Serie</span></th>
                                            <th class="bg-navy"><span>Modelo</span></th>
                                            <th class="bg-navy"><span>Marca</span></th>
                                        </tr>
                                    </thead>
                                </table>
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
