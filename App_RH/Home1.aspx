<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Home1.aspx.vb" Inherits="Home1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>DASHBOARD</title>
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
        //var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            cargadash();
        });
        function cargadash() {
            PageMethods.general(function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbcliente').text(datos.clientes);
                $('#lbiguala').text(datos.igualas);
                $('#lbempleado').text(datos.empleados);
;            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
    <style>
        .sombra{
            box-shadow: 3px 4px 5px 0px rgba(0,0,0,0.75);
        }
        .valor{
            margin-left:50px;
            font-size:30px;
            color:black;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
         <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
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
                    <h1>Dashboard</h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="container">
                        <div class="row my-3">
                            <div class="col-md-3 sombra">
                                <div class="card ">
                                    <div class="card-block">
                                        <h4 class="card-title">Clientes</h4>
                                        <h2><i class="fa fa-building text-orange"></i><a class="card card-block text-center valor" id="lbcliente"></a></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 sombra">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Igualas mensuales</h4>
                                        <h2><i class="fa fa-line-chart text-aqua"></i><a class="card card-block text-center valor" id="lbiguala"></a></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 sombra">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Empleados</h4>
                                        <h2><i class="fa fa-users text-purple"></i><a class="card card-block text-center valor" id="lbempleado"></a></h2>
                                    </div>
                                </div>
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
