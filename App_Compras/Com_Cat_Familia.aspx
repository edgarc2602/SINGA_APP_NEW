<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Cat_Familia.aspx.vb" Inherits="App_Compras_Com_Cat_Familia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE FAMILIAS</title>
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
            cargalista();
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
            $('#dvdatos').hide();
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btnuevo1').click(function () {
                limpia();
                $('#dvdatos').show();
                $('#dvtabla').hide();
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var xmlgraba = '<familia id= "' + $('#txid').val() + '" tipo = "' + $('#dltipo').val() + '" descripcion = "' + $('#txnombre').val() + '" clave = "' + $('#txclave').val() + '"/>'
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        alert('Registro eliminado');
                        limpia();
                        cargalista();
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir un Empleado'); }
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
        });
        function limpia() {
            $('#txid').val(0);
            $('#dltipo').val(0);
            $('#txnombre').val('');
            $('#txclave').val('');
        }
        function valida() {
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de familia');
                return false;
            }
            if ($('#txnombre').val() == 0) {
                alert('Debe capturar la descripción de la familia');
                return false;
            }
            if ($('#txclave').val() == 0) {
                alert('Debe capturar la abreviación');
                return false;
            }
            if ($('#txclave').val().length < 3) {
                alert('La abreviación debe ser de tres caracteres');
                return false;
            }
            return true;
        }
        function cargalista() {
            PageMethods.familia( function (res) { //
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    limpia();
                    $('#txid').val($(this).children().eq(0).text());
                    $('#dltipo').val($(this).children().eq(4).text());
                    $('#txnombre').val($(this).children().eq(2).text());
                    $('#txclave').val($(this).children().eq(3).text());
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                });
            }, iferror);
        };
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
        };
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idbanco" runat="server" Value="0" />
        <asp:HiddenField ID="idestado" runat="server" Value="0" />
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
                    <h1>Catálogo de Familias<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Familias</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-12">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">Id:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo de Familia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Materiales</option>
                                            <option value="2">Herramienta y Equipo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Descripción:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txclave">Abreviación:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txclave" class="form-control" maxlength="3"/>
                                    </div>
                                </div>
                            </div>
                             <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                
                            </ol>
                        </div>
                    </div>
                    <div class="row" id="dvdetalle">
                        
                        <div class="col-md-18 tbheader" id="dvtabla">
                            <!--
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="id_proveedor">No. Proveedor</option>
                                        <option value="nombre">Nombre</option>
                                        <option value="rfc">RFC</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                            -->
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Tipo</span></th>
                                        <th class="bg-navy"><span>Descripción</span></th>
                                        <th class="bg-navy"><span>Abreviación</span></th>
                                    </tr>
                                </thead>
                            </table>
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
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
