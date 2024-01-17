<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_Inventariofisico.aspx.vb" Inherits="App_Almacen_Alm_Pro_Inventariofisico" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>INVENTARIO FISICO</title>
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
            cargaalmacen();
            $('#btnuevo').click(function () {
                location.reload();
            })
            $('#btgenera').click(function () {
                if ($('#txfolio').val() == 0) {
                    waitingDialog({});
                    PageMethods.genera($('#dlalmacen').val(), $('#idusuario').val(), function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res)
                        cuentatoma($('#txfolio').val());
                        cargadetalle($('#txfolio').val());
                        alert('Registro completado.');
                    }, iferror);
                } else {
                    alert('La toma de inventario ya se esta generada');
                }
            })
            $('#btguarda').click(function () {
                if ($('#tblista tbody tr').length != 0) {
                    waitingDialog({});
                    var xmlgraba = ''
                    var cant = 0
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        if ($('#tblista tbody tr').eq(x).find("input:eq(0)").val() == '') {
                            cant = 0
                        } else {
                            cant = parseFloat($('#tblista tbody tr').eq(x).find("input:eq(0)").val())
                        }
                        xmlgraba += '<partida clave="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" toma="' + $('#txfolio').val()+'" contado="' + parseFloat(cant) + '"/>'
                    }
                    PageMethods.guarda(xmlgraba, function () {
                        closeWaitingDialog();
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btimprime').click(function () {
                if ($('#txfolio').val() != 0) {
                    var formula = '{tb_tomainventario.id_toma}=' + $('#txfolio').val()
                    window.open('../RptForAll.aspx?v_nomRpt=tomainventario.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                } else {
                    alert('Debe elegir primero una toma de inventario');
                }
                
            })
            $('#btimprime1').click(function () {
                if ($('#txfolio').val() != 0) {
                    var formula = '{tb_tomainventario.id_toma}=' + $('#txfolio').val()
                    window.open('../RptForAll.aspx?v_nomRpt=tomainventariodif.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                } else {
                    alert('Debe elegir primero una toma de inventario');
                }

            })
            $('#btelimina').click(function () {
                var res = confirm('Esta seguro de cancelar esta toma, se perderan todos los datos guardados');
                if (res == true) {
                    PageMethods.elimina($('#txfolio').val(), $('#dlalmacen').val(), function () {
                        alert('Registro eliminado.');
                    }, iferror);
                }
            })
            $('#btprocesa').click(function () {
                if ($('#txfolio').val() != 0) {
                    waitingDialog({});
                    PageMethods.procesa($('#txfolio').val(), $('#idusuario').val(), $('#dlalmacen').val(), function () {
                        closeWaitingDialog();
                        alert('La toma de inventario ha sido procesada correctamente, el almacén ha sido liberado para movimientos.');
                        location.reload();
                    }, iferror);
                } else {
                    alert('Debe elegir primero una toma de inventario');
                }
            })
        })
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargadetalle();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentatoma(toma) {
            PageMethods.contartoma(toma, function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargadetalle(toma) {
            PageMethods.tomadetalle(toma, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                /*
                $('#tblista').delegate("tr .btquita", "click", function () {
                    PageMethods.elimina($('#txclave').val(), $(this).closest('tr').find('td').eq(0).text(), function (res) {
                        cargaproveedor($('#txclave').val());
                    });
                });*/
            });
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
                $('#dlalmacen').change(function () {
                    cargatoma();
                })
            }, iferror);
        }
        function cargatoma() {
            PageMethods.toma($('#dlalmacen').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.id == 0) {
                    alert('No existe toma de inventario para el almacén seleccionado');
                } else {
                    $('#txfolio').val(datos.id);
                    cuentatoma(datos.id);
                    cargadetalle(datos.id);
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
                    <h1>Inventario Fìsico<small>Compras</small></h1>
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
                                <div class="col-lg-3 text-right">
                                    <label for="dlalmacen">Toma de inventario:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class="form-control text-right" id="txfolio" disabled="disabled" value="0"/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-1" style="margin-left:200px;">
                                    <input type="button" class="btn btn-primary " value="Generar" id="btgenera"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row tbheader" style="height: 400px; overflow-y: scroll;">
                        <table class=" table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Clave</th>
                                    <th class="bg-light-blue-active">Producto</th>
                                    <th class="bg-light-blue-active">Unidad</th>
                                    <th class="bg-light-blue-active">Contado</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
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
                    </div>
                    
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Cancelar toma</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li> 
                        <li id="btimprime1" class="puntero"><a><i class="fa fa-print"></i>Reporte de diferencias</a></li>
                        <li id="btprocesa" class="puntero"><a><i class="fa fa-save"></i>Procesar toma</a></li> 
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
