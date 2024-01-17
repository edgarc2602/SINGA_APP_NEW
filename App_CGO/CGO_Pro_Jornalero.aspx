<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Jornalero.aspx.vb" Inherits="App_CGO_CGO_Pro_Jornalero" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE JORNALEROS</title>
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
            cargabancos();
            cargalista();
            cuentajornalero();
            $('#dvdatos').hide();
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btnuevo1').click(function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
            })
            $('#btelimina').on('click', function () {
                if ($('#txnojor').val() != '0') {
                    PageMethods.elimina($('#txnojor').val(), function (res) {
                        alert('Registro eliminado');
                        limpia();
                        cargalista();
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir un Empleado'); }
            })
            $('#btguarda').click(function () {
                if(valida()){
                    waitingDialog({});
                    var xmlgraba = '<jornalero id= "' + $('#txnojor').val() + '"  paterno= "' + $('#txpaterno').val() + '" materno = "' + $('#txmaterno').val() + '" nombre= "' + $('#txnombre').val() + '"';
                    xmlgraba += ' banco="' + $('#dlbanco').val() + '" cuenta="' + $('#txcuenta').val() + '"/>'
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btbusca').click(function () {
                $('#hdpagina').val(1);
                cuentajornalero();
                cargalista();
            })
            $('#btimprime').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=catalogojornalero.rpt&v_formula={tb_jornalero.id_status}=1', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                // window.open('Ope_Ticket_PDF.aspx?id=' + $('#idticket').val(), '_blank', 'top = 100, left = 300, width = 1000, height = 500')
            })
            $('#btimprime1').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=catalogojornalero.rpt&v_formula={tb_jornalero.id_status}=1', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                // window.open('Ope_Ticket_PDF.aspx?id=' + $('#idticket').val(), '_blank', 'top = 100, left = 300, width = 1000, height = 500')
            })
        })
        function valida() {
            if ($('#txnombre').val() == 0) {
                alert('Debe capturar el nombre del Jornalero');
                return false;
            }
            if ($('#txpaterno').val() == 0) {
                alert('Debe capturar el Apellido Paterno del Jornalero');
                return false;
            }
            return true;
        }
        function limpia() {
            $('#txnojor').val(0);
            $('#txpaterno').val('');
            $('#txmaterno').val('');
            $('#txnombre').val('');
            $('#dlbanco').val(0);
            $('#txcuenta').val('');
        }
        function cargabancos() {
            PageMethods.banco(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlbanco').append(inicial);
                $('#dlbanco').append(lista);
                $('#dlbanco').val(0);
                if ($('#idbanco').val() != '') {
                    $('#dlbanco').val($('#idbanco').val());
                };
            }, iferror);
        }
        function cargalista() {
            PageMethods.jornalero($('#hdpagina').val(), $('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    $('#txnojor').val($(this).children().eq(0).text());
                    $('#txpaterno').val($(this).children().eq(1).text());
                    $('#txmaterno').val($(this).children().eq(2).text());
                    $('#txnombre').val($(this).children().eq(3).text());
                    $('#idbanco').val($(this).children().eq(6).text());
                    cargabancos();
                    $('#txcuenta').val($(this).children().eq(5).text());
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                });
            }, iferror);
        };
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentajornalero() {
            PageMethods.contarjornal($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
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
        };
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idbanco" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" />
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
                    <h1>Catálogo de jornaleros<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Jornaleros</li>
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
                                    <label for="txnojor">No. Jornalero:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input class="form-control" id="txnojor" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txpaterno">Apellido Paterno:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txpaterno" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txmaterno">Apellido Materno:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txmaterno" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnombre">Nombre(s):</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombre" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlbanco">Banco:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlbanco" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcuenta">No. Cuenta:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcuenta" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Jornaleros</a></li>
                            <li id="btimprime1" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                        </ol>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="id_jornalero">No. Jornalero</option>
                                        <option value="paterno">Apellidos Paterno</option>
                                        <option value="materno">Apellidos Materno</option>
                                        <option value="nombre">Nombre</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Paterno</span></th>
                                            <th class="bg-navy"><span>Materno</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Banco</span></th>
                                            <th class="bg-navy"><span>Cuenta</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                                </ol>
                            </div>
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
