<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_Aguinaldo.aspx.vb" Inherits="App_Admin_RH_Con_Aguinaldo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CALCULO DE AGUINALDO</title>
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
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#txfecha').val("01/12/" + d.getFullYear());
            $('#btprocesa').click(function () {
                $('#tblista tbody').remove();
                if (validaproceso()) {
                    $('#hdpagina').val(1);
                    cargaaguinaldo();
                }
            })
            $('#btimprime').click(function () {
                if (validaproceso()) {
                    var formula = '{tb_calculoaguinaldog.anio} =' + $('#txanio').val() + ' and {tb_calculoaguinaldog.id_area} =' + $('#dltipo').val() + ''
                    window.open('../RptForAll.aspx?v_nomRpt=aguinaldocalculado.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            });
            $('#btcerrar').click(function () {
                if (validaproceso()) {
                    if ($('#txestatus').val() == 'Cerrado') {
                        var r = confirm("El Aguinaldo será liberado para pago, ¿estas seguro de continuar?");
                        if (r == true) {
                            PageMethods.cerrar($('#txanio').val(), $('#dltipo').val(), $('#dltipo option:selected').text(), function () {
                                $('#txestatus').val('Liberado');
                                alert('El aguinaldo ha sido liberado, ya no se pueden realizar movimientos');
                            }, iferror);
                        } else { alert('No se ejecuta liberación'); }
                    } else { alert('El proceso de aguinaldo solo se puede liberar si se encuentra en estatus cerrado, no puede continuar');}
                }
            })
            
            $('#btnuevo').click(function () {
                location.reload();
            })
            $('#btpagado').click(function () {
                if (validaproceso()) {
                    if ($('#txestatus').val() == 'Liberado') {
                        var r = confirm("El Aguinaldo será registrado como pagado, ¿estas seguro de continuar?");
                        if (r == true) {
                            PageMethods.pagar($('#txanio').val(), $('#dltipo').val(), function () {
                                $('#txestatus').val('Pagado');
                                alert('El aguinaldo ha sido registrado como pagado, ya no se pueden realizar movimientos');
                            }, iferror);
                        } else { alert('No se ejecuta el pago'); }
                    } else { alert('El proceso de aguinaldo solo se puede marcar como pagado si se encuentra en estatus liberado, no puede continuar'); }
                }
            })
        });
        function cargaaguinaldo() {
            PageMethods.procesado($('#txanio').val(), $('#dltipo').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.estatus == '0') {
                    alert('El calculo de aguinaldo aun no se ha procesado o bien no ha sido cerrado, debe revisar con el área de CGO')
                    //procesaaguinaldo();
                    //cargaaguinaldo()
                } else {
                    $('#tximporte').val(datos.importe);
                    $('#txestatus').val(datos.estado);
                    cuentaaguinaldo();
                    cargalista();
                }
            }, iferror);
        }
        function cuentaaguinaldo() {
            PageMethods.contaraguinaldo($('#txanio').val(), $('#dltipo').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalista() {
            PageMethods.aguinaldo($('#txanio').val(), $('#dltipo').val(),$('#hdpagina').val(),  function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                });
            }, iferror);
        };
        
        function validaproceso() {
            if ($('#txanio').val() == '') {
                alert('Debe colocar el año');
                return false;
            }
            if ($('#txfecha').val() == '') {
                alert('Debe elegir la fecha para cálculo');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de nómina');
                return false;
            }
            /*
            if ($('#dltipo').val() == 6) {
                if (($('#idusuario').val() != 1 && $('#idusuario').val() != 97)) {
                    alert('Usted no cuenta con permisos para procesar esta nomina');
                    return false;
                }
            }*/
            /*
            if ($('#txestatus').text() != 'Período abierto') {
                alert('El estatus del período no permite ejecutar este proceso');
                return false;
            }*/
            return true;
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
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
                    <h1>Consulta de Aguinaldo<small>Administración</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Administración</a></li>
                        <li class="active">Nóminas</li>
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
                                    <label for="txid">Año:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txanio" class="form-control" />
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
                                    <label for="txid">Fecha para calculo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btprocesa" class="btn btn-success center-block" value="Mostrar" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="tximporte">Importe total:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="tximporte" class="form-control text-right" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txestatus" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="dvtabla" style="height: 300px; overflow-y: scroll;">
                            <div class="box box-info">
                                <div class="col-md-18 tbheader">
                                    <table class="table table-condensed" id="tblista">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>Cliente</span></th>
                                                <th class="bg-navy"><span>Punto de atención</span></th>
                                                <th class="bg-navy"><span>No. Empleado</span></th>
                                                <th class="bg-navy"><span>Nombre</span></th>
                                                <th class="bg-navy"><span>F. Ingreso</span></th>
                                                <th class="bg-navy"><span>Antiguedad</span></th>
                                                <th class="bg-navy"><span>Sueldo</span></th>
                                                <th class="bg-navy"><span>Importe</span></th>
                                            </tr>
                                        </thead>
                                    </table>
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
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btcerrar" class="puntero"><a><i class="fa fa-save"></i>Liberar Aguinaldo</a></li>
                            <!--<li id="btcalcular" class="puntero"><a><i class="fa fa-navicon"></i>Recalcular</a></li>-->
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                            <li id="btpagado" class="puntero"><a><i class="fa fa-save"></i>Aguinaldo pagado</a></li>
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
