<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Periodonomina.aspx.vb" Inherits="App_RH_RH_Cat_Periodonomina" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE PERIODOS DE NOMINA</title>
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
        //var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#txanio').change(function () {
                validaperiodo();
            })
            $('#dltipo').change(function () {
                validaperiodo();
            })
            $('#btnuevo').click(function () {
                $('#tblista tbody').remove();
                $('#txanio').val('')
                $('#dltipo').val(0)
                $('#txanio').focus();
            })
        });
        function validaperiodo() {
            if ($('#txanio').val() != '' && $('#dltipo').val() != 0) {
                PageMethods.existe($('#txanio').val(), $('#dltipo option:selected').text(), function (opcion) {
                    var datos = eval('(' + opcion + ')');
                    if (datos.id == 0) {
                        var r = confirm('No existen periodos de nomina para el ejercicio seleccionado, ¿desea crearlos?')
                        if (r == true) {
                            if ($('#dltipo').val() == 1) {
                                PageMethods.generasemana($('#txanio').val(), function (res) {
                                    alert('Registros generados.');
                                    cargaperiodo();
                                }, iferror);
                            } else {
                                PageMethods.generaquincena($('#txanio').val(), function (res) {
                                    alert('Registros generados.');
                                    cargaperiodo();
                                }, iferror);
                            }

                        } else { alert('elija otro período para consulta'); }
                    } else {
                        cargaperiodo();
                    }
                });
            }
        }
        function cargaperiodo() {
            PageMethods.periodos($('#txanio').val(), $('#dltipo option:selected').text(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.tbstatus', function () {
                    var valor = 0
                    if ($(this).closest('tr').find('input').eq(0).val() == 'Inactivo') {
                        valor = 1
                    }
                    PageMethods.activa($(this).closest('tr').find('td').eq(0).text(), $('#txanio').val(), $('#dltipo option:selected').text(), valor, function (res) {
                        cargaperiodo();
                    }, iferror);
                });
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
        <asp:HiddenField ID="idestado" runat="server" />
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
                                    <span class="hidden-xs"></span>
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
                    <h1>Períodos de nomina<small>Recursos humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Períodos</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txanio">Año:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txanio" class="form-control"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dltipo">Tipo Período:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Semanal</option>
                                            <option value="2">Quincenal</option>
                                        </select>
                                    </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Descripción</span></th>
                                            <th class="bg-navy"><span>Fecha Inicial</span></th>
                                            <th class="bg-navy"><span>Fecha final</span></th>
                                            <th class="bg-navy"><span>Estatus</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
