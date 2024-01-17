<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dash_Cliente.aspx.vb" Inherits="App_dashboard_Dash_Cliente" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE CLIENTES</title>
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
    <script src="http://code.highcharts.com/highcharts.js" type="text/javascript"></script>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#dlmes').val(d.getMonth() + 1);
            PageMethods.cliente($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.id != 0) {
                    $('#dvcte').show();
                    $('#dvmaster').hide();
                    $('#idcliente').val(datos.id);
                    $('#txcliente').val(datos.nombre);
                    asistenciag();
                    materialg();
                    supervisiong();
                    evaluaciong();
                    cargainmueble($('#idcliente').val());
                    PageMethods.asistenciacli($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                        var opt = eval('(' + res + ')');
                        $('#chrsuc').highcharts(opt);
                    });
                    PageMethods.asistenciacli1($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                        var opt = eval('(' + res + ')');
                        $('#chrsuc1').highcharts(opt);
                    });
                } else {
                    cargacliente();
                    $('#dvcte').hide();
                    $('#dvmaster').show();
                }
            })
            $('#dlmes').change(function () {
                asistenciag();
                materialg();
                supervisiong();
                evaluaciong();
                PageMethods.asistenciacli($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                    var opt = eval('(' + res + ')');
                    $('#chrsuc').highcharts(opt);
                });
                PageMethods.asistenciacli1($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                    var opt = eval('(' + res + ')');
                    $('#chrsuc1').highcharts(opt);
                });
            })
        });
        function cargacliente() {
            PageMethods.clientelista( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    $('#idcliente').val($('#dlcliente').val());
                    asistenciag();
                    materialg();
                    supervisiong();
                    cargainmueble($('#idcliente').val());
                    PageMethods.asistenciacli($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                        var opt = eval('(' + res + ')');
                        $('#chrsuc').highcharts(opt);
                    });
                    PageMethods.asistenciacli1($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                        var opt = eval('(' + res + ')');
                        $('#chrsuc1').highcharts(opt);
                    });
                });
            }, iferror);
        }
        function asistenciag() {
            PageMethods.asistenciag($('#idcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbasistencia').text(datos.prom);
            })
        }
        function materialg() {
            PageMethods.materialg($('#idcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbentrega').text(datos.total);
            })
        }
        function supervisiong() {
            PageMethods.supervisiong($('#idcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbsupervision').text(datos.total);
            })
        }
        function evaluaciong() {
            PageMethods.evaluaciong($('#idcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbevaluacion').text(datos.total);
            })
        }
        function cargainmueble(idcte) {
            PageMethods.inmueble(idcte, function (res) {
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista table tbody tr').click(function () {
                    if ($(this).closest('tr').find('td').eq(0).text() == 0) {
                        PageMethods.asistenciacli($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                            var opt = eval('(' + res + ')');
                            $('#chrsuc').highcharts(opt);
                        });
                        PageMethods.asistenciacli1($('#idcliente').val(), $('#txcliente').val(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                            var opt = eval('(' + res + ')');
                            $('#chrsuc1').highcharts(opt);
                        });
                        asistenciag();
                        materialg();
                        supervisiong();
                        evaluaciong();
                    } else {
                        PageMethods.asistenciasuc($(this).closest('tr').find('td').eq(0).text(), $(this).closest('tr').find('td').eq(1).text(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                            var opt = eval('(' + res + ')');
                            $('#chrsuc').highcharts(opt);
                        });
                        PageMethods.asistenciasuc1($(this).closest('tr').find('td').eq(0).text(), $(this).closest('tr').find('td').eq(1).text(), $('#txanio').val(), $('#dlmes').val(), function (res) {
                            var opt = eval('(' + res + ')');
                            $('#chrsuc1').highcharts(opt);
                        });
                        PageMethods.asistenciaind($(this).closest('tr').find('td').eq(0).text(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            $('#lbasistencia').text(datos.prom);
                        })
                        PageMethods.materialind($(this).closest('tr').find('td').eq(0).text(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            $('#lbentrega').text(datos.total);
                        })
                        PageMethods.supervisioind($(this).closest('tr').find('td').eq(0).text(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            $('#lbsupervision').text(datos.total);
                        })
                        PageMethods.evaluacionind($(this).closest('tr').find('td').eq(0).text(), $('#txanio').val(), $('#dlmes').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            $('#lbevaluacion').text(datos.total);
                        })
                    }
                });
            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
    <style>
        .sombra{
           /* box-shadow: -2px 14px 64px -25px rgba(0,0,0,0.75);*/
           background-color:white;
        }
        .valor{
            margin-left:50px;
            font-size:20px;
            color:black;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini" >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" />
        <div class="wrapper" >
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
                    <h1>Dashboard<small>Clientes</small></h1>
                    <ol class="breadcrumb">
                        <li><a ><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Clientes</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </div>
                <div class="content" style="background-color:#F2F2F2;">
                    <div class="row">
                        <div class="col-lg-1 text-right">
                            <label for="txanio">Año</label>
                        </div>
                        <div class="col-lg-1">
                            <input type="text" id="txanio" class="form-control"/>
                        </div>
                        <div class="col-lg-1 text-right">
                            <label for="dlmes">Mes</label>
                        </div>
                        <div class="col-lg-2">
                            <select id="dlmes" class="form-control">
                                <option value="1">Enero</option>
                                <option value="2">Febrero</option>
                                <option value="3">Marzo</option>
                                <option value="4">Abril</option>
                                <option value="5">Mayo</option>
                                <option value="6">Junio</option>
                                <option value="7">Julio</option>
                                <option value="8">Agosto</option>
                                <option value="9">Septiembre</option>
                                <option value="10">Octubre</option>
                                <option value="11">Noviembre</option>
                                <option value="12">Diciembre</option>
                            </select>
                        </div>
                        <div class="col-lg-1 text-right">
                            <label for="dlcliente">Cliente</label>
                        </div>
                        <div class="col-lg-3" id="dvmaster"> 
                            <select id="dlcliente" class="form-control"></select>
                        </div>
                        <div class="col-lg-3" id="dvcte">
                            <input type="text" id="txcliente" class="form-control" disabled="disabled"/>
                        </div>
                    </div>
                    <br />
                    <div class="container">
                        <div class="row my-4">
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Asistencia</h4>
                                        <h2><i class="fa fa-calendar text-orange"></i><a class="card card-block text-center valor" id="lbasistencia">98%</a></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Entregas</h4>
                                        <h2><i class="fa fa-taxi text-aqua"></i><a class="card card-block text-center valor" id="lbentrega">0</a></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Supervisión</h4>
                                        <h2><i class="fa fa-users text-purple"><a class="card card-block text-center valor" id="lbsupervision">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div>
                                        <h4 class="card-title">Evaluaciones</h4>
                                        <h2><i class="fa fa-thumbs-up text-green"><a class="card card-block text-center valor" id="lbevaluacion">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container">
                        <div class="row my-2">
                            <div class="col-md-3 sombra margin">
                                <div class="card text-center">
                                    <div id="tblista" class="tbheader" style="height:300px; overflow-y:scroll;" >
                                        <table class="table table-condensed">
                                            <thead>
                                                <tr>
                                                    <th class="bg-light-blue-gradient">Id</th>
                                                    <th class="bg-light-blue-gradient">Nombre</th>
                                                    <th class="bg-light-blue-gradient">Plantilla</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5 sombra margin" >
                                <div class="card text-center">
                                    <div id="chrsuc" style="height:300px;"> 
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 sombra margin" >
                                <div class="card text-center">
                                    <div id="chrsuc1" style="height:300px;"> 
                                    </div>
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
