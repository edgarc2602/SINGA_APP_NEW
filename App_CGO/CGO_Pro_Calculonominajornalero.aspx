<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Calculonominajornalero.aspx.vb" Inherits="App_CGO_CGO_Pro_Calculonominajornalero" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CALCULO DE NOMINA DE JORNALEROS</title>
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
            $('#btprocesa').click(function () {
                $('#tblista tbody').remove();
                if (validaproceso()) {
                    $('#hdpagina').val(1);
                    carganomina();
                }
            })
            $('#btrecalcula').click(function () {
                if (validaproceso()) {
                    procesanomina();
                }
            })
            $('#btimprime').click(function () {
                if ($('#dlperiodo').val() != 0) {
                    if (validaproceso()) {

                        var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                        var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                        
                        var formula = '{tb_nominacalculadajornalero.id_periodo}=' + $('#dlperiodo').val() + ' and {tb_nominacalculadajornalero.anio}=' + anio + ' and {tb_nominacalculadajornalero.tipo}="' + tipo + '"'
                        window.open('../RptForAll.aspx?v_nomRpt=nominacalculadajornalero.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                    }
                } else {
                    alert('Debe elegir al menos un período de nómina');
                }
            })
        })
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
                        //cargalista();
                    });
                });
            }, iferror);
        }
        function carganomina() {
            //alert($('#dlencargado').val());
            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
            var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
            //alert($('#dltipo').val());
            PageMethods.procesada($('#dlperiodo').val(), tipo, anio, function (detalle) {
                //alert('hola');
                var datos = eval('(' + detalle + ')');
                if (datos.percepcion == '$0.00') {
                    //eliminanomina();
                    procesanomina();
                } else {
                    //alert('Este período de nomina ya ha sido procedado, se cargaran los valores ya calculados');
                    $('#txtotal').val(datos.percepcion);
                    
                    //cuentanomina();
                    cargalista();
                }
            }, iferror);
        }
        function cargalista() {
            //if (valida()) {
                waitingDialog({});
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                PageMethods.nomina( $('#dlperiodo').val(), tipo, anio,  function (res) {
                    closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    
                }, iferror);
           // }
        };
        function procesanomina() {
            //if (validaproceso()) {
                waitingDialog({});
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                PageMethods.procesa($('#dlperiodo').val(), tipo, anio, function () {
                    //alert(res);
                    closeWaitingDialog();
                    alert('Proceso concluido.');
                    carganomina();
                }, iferror);
            //}
        }
        function validaproceso() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir el período');
                return false;
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
        };
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <h1>Cálculo de nómina  jornaleros<small>Recursos humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Nomina</li>
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
                                    <label for="dlperiodo">Período:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlperiodo" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecini">F. Inicio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecfin">F. final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <input type="button" id="btprocesa" class="btn btn-success center-block" value="Procesar" />
                                </div>
                            </div>
                        </div>
                        <div class="tbheader" id="dvtabla" style="height:300px; overflow-y:scroll;">
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>No. Jornalero</span></th>
                                        <th class="bg-navy"><span>Nombre</span></th>
                                        <th class="bg-navy"><span>Pago</span></th>
                                    </tr>
                                </thead>
                            </table>                            
                            <!--
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
                            </nav>-->
                    </div>
                    <div class="row">
                        <div class="box-header">
                            <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txid">Total a pagar:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtotal" class="form-control text-right" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2">
                                <input type="button" id="btrecalcula" class="btn btn-primary" value="Recalcular Nómina" />
                            </div>
                            <div class="col-lg-2">
                                <input type="button" id="btimprime" class="btn btn-primary" value="Imprimir Nómina" />
                            </div>
                            <div class="col-lg-2">
                                <input type="button" id="btcerrar" class="btn btn-primary" value="Cerrar Nómina" />
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
