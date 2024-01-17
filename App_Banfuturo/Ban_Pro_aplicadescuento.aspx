<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ban_Pro_aplicadescuento.aspx.vb" Inherits="App_Banfuturo_Ban_Pro_aplicadescuento" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>APLICA DESCUENTO POR PRESTAMOS</title>
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
            cargaperiodo();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                //cuentasolicitud();
                cargalista();
            })
            $('#btprocesa').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var xmlgraba = '';
                    $('#tblista tbody tr').each(function () {
                        var fecha = $(this).closest('tr').find('td').eq(3).text().split('/');
                        var finicio = fecha[2] + fecha[1] + fecha[0];

                        xmlgraba += '<descuento empleado="' + $(this).closest('tr').find('td').eq(0).text() + '" incidencia="16" cantidad="1"';
                        xmlgraba += ' monto="' + parseFloat($(this).closest('tr').find('td').eq(2).text()) + '" periodo="' + $(this).closest('tr').find('td').eq(4).text() + '"'
                        xmlgraba += ' anio="' + $(this).closest('tr').find('td').eq(5).text() + '" tipo="' + $(this).closest('tr').find('td').eq(6).text() + '" '
                        xmlgraba += ' fecha="' + finicio + '" esstatus="1" solicitud="' + $(this).closest('tr').find('td').eq(7).text() + '" usuario="' + $('#idusuario').val() + '"/> ';
                    });
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        
                        alert('Registro completado.');
                        cargalista();
                    }, iferror);
                }
                
            })
        })
        function valida() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir el período de nómina');
                return false;
            }
            if ($('#tblista tbody tr').length == 0) {
                alert('No ha cargado ninguna lista');
                return false;
            }
            return true;
        }
        function cargaperiodo() {
            PageMethods.periodo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlperiodo').append(inicial);
                $('#dlperiodo').append(lista);
                $('#dlperiodo').val(0);

                $('#dlperiodo').change(function () {
                    var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                    var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                    PageMethods.detalleperiodo($('#dlperiodo').val(), per, anio, function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txfecini').val(datos.fini);
                        $('#txfecfin').val(datos.ffin);
                    });
                });
            }, iferror);
        }
        function cargalista() {
            PageMethods.prestamos($('#txfecfin').val(), function (res) {
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
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
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
                    <h1>Aplicar descuentos por prestamo<small>Banfuturo</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Banfuturo</a></li>
                        <li class="active">Descuentos</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txid">Período:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlperiodo" class="form-control"></select>
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txfecini">F. Inicio:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfecini" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txfecfin">F. final:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfecfin" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="button" id="btconsulta" class="btn btn-success center-block" value="Consultar" />
                            </div>
                        </div>
                    </div>
                     <div class="row" id="dvtabla" style="height:300px; overflow-y:scroll;">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>No. Empleado</span></th>
                                    <th class="bg-navy"><span>Nombre</span></th>
                                    <th class="bg-navy"><span>Importe</span></th>
                                    <th class="bg-navy"><span>F. Aplicación</span></th>
                                    <th class="bg-navy" colspan="3"><span>Período</span></th>
                                    <th class="bg-navy"><span>Solicitud</span></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btimprime"  class="puntero"><a ><i class="fa fa-print"></i>Imprimir</a></li>
                        <li id="btprocesa"  class="puntero"><a ><i class="fa fa-save"></i>Procesar</a></li>
                        <!--<li id="btautoriza"  class="puntero"><a ><i class="fa fa-edit"></i>Aprobar</a></li>
                        <li id="btlibera"  class="puntero"><a ><i class="fa fa-undo"></i>Liberar</a></li>-->
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
