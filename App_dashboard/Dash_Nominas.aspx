<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dash_Nominas.aspx.vb" Inherits="App_dashboard_Dash_Nominas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LIBERACION DE NOMINAS</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        var dialog; var dialog1;
        $(function () {
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            cargaperiodo();
            $('#btlibera').click(function () {
                if ($('#idusuario').val() != 27) {
                    alert('Usted no esta autorizado para realizar esta operación')
                } else {
                    if ($('#dlperiodo').val() != 0) {
                        var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                        var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                        PageMethods.libera($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (res) {
                            alert('La nómina ha sido liberada para pago');
                        }, iferror);

                    } else { alert('Para liberar debe elegir un período de nómina') }
                }
               
            })
            $('#btrechaza').click(function () {
                if ($('#idusuario').val() != 27) {
                    alert('Usted no esta autorizado para realizar esta operación')
                } else {
                    if ($('#dlperiodo').val() != 0) {
                        var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                        var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                        PageMethods.rechaza($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function () {
                            
                            alert('La nómina ha sido rechazada, el area de CGO recibira un correo con la indicación');
                        }, iferror);

                    } else { alert('Para rechazar debe elegir un período de nómina') }
                }
            })
            $('#btimprime').click(function () {
                if ($('#dlperiodo').val() != 0) {
                    if ($('#txestatus').text() != 'Nomina no procesada' && $('#txestatus').text() != 'Nomina en proceso') {
                        var periodo = $('#dlperiodo option:selected').text()
                        var anio = periodo.substring(3, 7);
                        var tipo = periodo.substring(8, periodo.length);
                        var formula = '{tb_nominacalculadar1.id_periodo}=' + $('#dlperiodo').val() + ' and {tb_nominacalculadar1.anio}=' + anio + ' and {tb_nominacalculadar1.tipo}="' + tipo + '" and {tb_empleado.id_area} = ' + $('#dltipo').val() + ''
                        
                        if (tipo == 'Semanal') {
                            window.open('../RptForAll.aspx?v_nomRpt=nominacalculadacgoq7.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        } else {
                            window.open('../RptForAll.aspx?v_nomRpt=nominacalculadacgoq15.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        }
                    } else {
                        alert('No se puede imprimir una nomina que aún no se ha procesado o concluido');
                    }
                } else {
                    alert('Debe elegir al menos un período de nómina');
                }
            })
            $('#dltipo').change(function () {
                cargadetalle();
            })
        });
        function cargadetalle() {
            if ($('#dlperiodo').val() != 0 && $('#dltipo').val() != 0) {
                var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                PageMethods.estatus($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txestatus').text(datos.estatus);
                }, iferror);

                PageMethods.resumen($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txpercepciones').val(datos.perc);
                    $('#txdeducciones').val(datos.dedc);
                    $('#txtotal').val(datos.total);
                }, iferror);
                PageMethods.detalle($('#dlperiodo').val(), per, anio, $('#dltipo').val(), function (res) {
                    var ren = $.parseHTML(res);
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                });
                PageMethods.detallea(parseInt($('#dlperiodo').val()) - 1, per, anio, $('#dltipo').val(), function (res) {
                    var ren = $.parseHTML(res);
                    $('#tblista1 tbody').remove();
                    $('#tblista1').append(ren);
                });
            }
        }
        function cargaperiodo() {
            PageMethods.periodo($('#txanio').val(), function (opcion) {
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
                        cargadetalle();
                        
                    }, iferror);
                })
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
        <asp:HiddenField ID="idcte" runat="server" Value="0"/>
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
        <asp:HiddenField ID="idempleado" runat="server" value="0"/>
        <asp:HiddenField ID="idpuesto" runat="server" value="0" />
        <asp:HiddenField ID="revisa" runat="server" value="0"/>
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
                 
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Liberación de nominas
                        <small>Dirección</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Dirección</a></li>
                        <li class="active">Orden de compra</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlperiodo">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input class="form-control" id="txanio"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlperiodo">Período de nómina:</label>
                                </div>
                                <div class="col-lg-3">
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
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dltipo" class="form-control">
                                         <option value="0">Seleccione...</option>
                                            <option value="6">Administrativa</option>
                                            <option value="4">Operativa</option>
                                            <option value="11">Mantenimiento</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecfin">Estatus:</label>
                                </div>
                                <div class="col-lg-4">
                                    <h4 class=" text-orange text-bold" id="txestatus"></h4>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="dlcliente">Percepciones</label>
                                </div>
                                <div class="col-lg-2">
                                    <label for="dlcliente">Deducciones</label>
                                </div>
                                <div class="col-lg-2">
                                    <label for="dlcliente">Total a pagar</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="text" class="form-control" id="txpercepciones"/>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class="form-control" id="txdeducciones"/>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class="form-control" id="txtotal"/>
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" id="btimprime" class="btn btn-primary" value="Imprimir Nómina" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Liberar nómina" id="btlibera" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <input type="button" class="btn btn-primary" value="Rechazar nómina" id="btrechaza" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 tbheader">
                            <h4>Período Actual</h4>
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Empleados</span></th>
                                        <th class="bg-light-blue-gradient"><span>Faltas</span></th>
                                        <th class="bg-light-blue-gradient"><span>Dobletes</span></th>
                                        <th class="bg-light-blue-gradient"><span>Percepciones</span></th>
                                        <th class="bg-light-blue-gradient"><span>Deducciones</span></th>
                                        <th class="bg-light-blue-gradient"><span>Total a pagar</span></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="col-md-6 tbheader">
                            <h4>Período Anterior</h4>
                            <table class="table table-responsive h6" id="tblista1">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Empleados</span></th>
                                        <th class="bg-light-blue-gradient"><span>Faltas</span></th>
                                        <th class="bg-light-blue-gradient"><span>Dobletes</span></th>
                                        <th class="bg-light-blue-gradient"><span>Percepciones</span></th>
                                        <th class="bg-light-blue-gradient"><span>Deducciones</span></th>
                                        <th class="bg-light-blue-gradient"><span>Total a pagar</span></th>
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
