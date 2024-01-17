<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_Asignacoordina.aspx.vb" Inherits="App_Operaciones_Ope_Pro_Asignacoordina" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ASIGNAR COORDINADORES DE RH A GERENTES</title>
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
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            cargagerente();
            cargacoordinador();
            $('#btguarda').click(function () {
                PageMethods.asigna($('#dlgerente').val(), $('#dlcoordinador').val(), function (res) {
                    alert('Registro completado');
                    
                }, iferror);
            })
        })
        function cargagerente() {
            PageMethods.gerente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
                $('#dlgerente').change(function () {
                    PageMethods.asignado($('#dlgerente').val(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#dlcoordinador').val(datos.coord);
                    });
                });
            }, iferror);
        }
        function cargacoordinador() {
            PageMethods.coordinador(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcoordinador').append(inicial);
                $('#dlcoordinador').append(lista);              
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
        <asp:HiddenField ID="idcte" runat="server" Value="0"/>
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
                                    <span class="hidden-xs" id="nomusr">></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="main-sidebar">
                <!-- sidebar: style can be found in sidebar.less -->
                <div class="sidebar" id="var1">
                    
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Asignar Coordinador de reclutamiento a Gerente
                        <small>Operaciones</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Coordinadores</li>
                    </ol>
                </div>
                <div id="diasigna" class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-10">
                            <div class="box box-info">
                                <div class="box-header">
                                </div>
                                <!--
                                <div class="row">
                                    <div class="col-lg-3">
                                        <label for="dlgerente">Gerente de Operaciones:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlgerente" class="form-control"></select>
                                    </div>
                                </div>
                               
                                <hr />
                                     -->
                                <div class="row">
                                    <!-- /.box-header -->
                                    <div class="col-lg-3 text-right">
                                        <label for="dlgerente">Gerente:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlgerente" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="dlcoordinador">Coordinador:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlcoordinador" class="form-control"></select>
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
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
