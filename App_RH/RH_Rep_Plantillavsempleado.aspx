<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Rep_Plantillavsempleado.aspx.vb" Inherits="App_RH_RH_Rep_Plantillavsempleado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE ASISTENCIA PARA CLIENTES</title>
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
    <script>
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dlsucursal').append(inicial);
            cargacliente();
            $('#btimprime').click(function () {
                if (valida()) {
                    var formula = ''
                    if ($('#dlcliente').val() == 0) {
                        formula += '{vt_plantillaempleado.id_cliente} <>136';
                    } else {
                        formula += '{vt_plantillaempleado.id_cliente} =' + $('#dlcliente').val();
                    }
                    if ($('#dlsucursal').val() != 0) {
                        formula += ' and {vt_plantillaempleado.id_inmueble}=' + $('#dlsucursal').val();
                    }
                    //alert(formula);
                    window.open('../RptForAll.aspx?v_nomRpt=plantillavsempleado.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
                
            })
        })
        function valida() {
            if ($('#dlcliente').val() == 136 && ($('#idusuario').val() != 1 && $('#idusuario').val() != 100)) { //
                alert('Usted no tiene permiso para generar el reporte de este cliente');
                return false;
            }
            return true;
        }
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').empty();
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
            }, iferror);
        }
        function cargainmueble(idcte) {
            PageMethods.inmueble(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);
                $('#dlsucursal').val(0);
            }, iferror);
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
                    <h1>Reporte de Plantilla vs Empleados<small>RH</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>RH</a></li>
                        <li class="active">Plantilla</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row">
                        <div class="box box-info">
                            <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-1" style="margin-left:200px;">
                                    <input type="button" class="btn btn-primary " value="Imprimir" id="btimprime"/>
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
