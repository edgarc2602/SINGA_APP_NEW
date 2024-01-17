<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_Conversion.aspx.vb" Inherits="App_Almacen_Alm_Pro_Conversion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>DILUCION DE MATERIALES</title>
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
            $('#btbusca').click(function () {
                if ($('#dlalmacen').val() != 0) {
                    $('#diluir').val(1);
                    $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                    dialog1.dialog('open');
                } else {
                    alert('Primero debe elegir un almacén')
                }
            })
            $('#btbusca1').click(function () {
                if ($('#dlalmacen').val() != 0) {
                    $('#diluir').val(2);
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
                            if ($('#diluir').val() == 1){
                                $('#txclave').val($(this).children().eq(0).text());
                                $('#txdesc').val($(this).children().eq(1).text());
                                $('#txunidad').val($(this).children().eq(2).text());
                                $('#txprecio').val($(this).children().eq(3).text());
                                $('#txdisp').val($(this).children().eq(4).text());
                            } else {
                                $('#txclave1').val($(this).children().eq(0).text());
                                $('#txdesc1').val($(this).children().eq(1).text());
                                $('#txunidad1').val($(this).children().eq(2).text());
                                $('#txprecio1').val($(this).children().eq(3).text());
                                $('#txdisp1').val($(this).children().eq(4).text());
                            }
                            
                            dialog1.dialog('close');
                        }

                    });
                }, iferror)
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var xmlgraba = '<Movimiento> <salida documento="17" almacen1="0" factura="0"';
                    xmlgraba += ' cliente="0" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba += ' orden="0" usuario="' + $('#idusuario').val() + '"/>'
                    xmlgraba += '<pieza clave="' + $('#txclave').val() + '" cantidad="' + $('#txcant').val() + '"';
                    xmlgraba += ' precio="' + $('#txprecio').val() + '"/>';
                    xmlgraba += '</Movimiento>';
                    //alert(xmlgraba);
                    var xmlgraba1 = '<Movimiento> <salida documento="18" almacen1="0" factura="0"';
                    xmlgraba1 += ' cliente="0" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba1 += ' orden="0" usuario="' + $('#idusuario').val() + '"/>'
                    xmlgraba1 += '<pieza clave="' + $('#txclave1').val() + '" cantidad="' + $('#txcant1').val() + '"';
                    xmlgraba1 += ' precio="' + $('#txprecio1').val() + '"/>';
                    xmlgraba1 += '</Movimiento>';
                    //alert(xmlgraba1);
                    PageMethods.guarda(xmlgraba, xmlgraba1, function () {
                        closeWaitingDialog();
                        limpia();
                        alert('Registro completado');
                    }, iferror);
                }
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
        })
        function limpia() {
            $('#txcant').val('');
            $('#txcant1').val('');
        }
        function valida() {
            if ($('#txclave').val() == '') {
                alert('Debe elegir el producto a diluir');
                return false;
            }
            if ($('#txcant').val() == '') {
                alert('Debe colocar la cantidad a diluir');
                return false;
            }
            if ($('#txclave1').val() == '') {
                alert('Debe elegir el producto diluido');
                return false;
            }
            if ($('#txcant1').val() == '') {
                alert('Debe colocar la cantidad del producto diluido');
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="diluir" runat="server" Value="0" />
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
                    <h1>Dilusión de productos químicos<small>Almacén</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacén</a></li>
                        <li class="active">Dilución</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
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
                                <div class="col-lg-3 text-center">
                                    <label for="txclave">Producto a diluir</label>
                                </div>
                                <div class="col-lg-3">
                                    <label for="txclave">Descripción</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Unidad</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Disponible</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Precio</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Cantidad</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="text" id="txclave" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txdesc" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txunidad" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txdisp" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txprecio" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcant" class="form-control" />
                                </div>
                            </div>
                            <hr />
                             <div class="row">
                                <div class="col-lg-3 text-center">
                                    <label for="txclave">Producto diluido</label>
                                </div>
                                <div class="col-lg-3">
                                    <label for="txclave">Descripción</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Unidad</label>
                                </div>
                                 <div class="col-lg-1">
                                    <label for="txclave">Disponible</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Precio</label>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txclave">Cantidad</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="text" id="txclave1" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="buscar" id="btbusca1" />
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txdesc1" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txunidad1" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txdisp1" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txprecio1" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcant1" class="form-control" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <ol class="breadcrumb">
                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                    <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>-->
                </ol>
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
                                    <th class="bg-navy"><span>Disponible</span></th>
                                </tr>
                            </thead>
                        </table>
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
