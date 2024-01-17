<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_Regionentrega.aspx.vb" Inherits="App_Compras_Com_Pro_Regionentrega" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ASINAR REGIONES DE ENTREGA</title>
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
    <style>
        #tblista thead td:nth-child(3),#tblista tbody td:nth-child(3){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            cargacliente();
            cargaregion();
            $('#btagrega').click(function () {
                PageMethods.elimina($('#txid').val(), $('#dlregion').val(), $('#txubicacion').val(), function (res) {
                    //alert('Registro eliminado');
                    limpia();
                    cargalista();
                    
                }, iferror);
            })
        });
        function limpia() {
            $('#txid').val('');
            $('#txinmueble').val('');
            $('#dlregion').val(0);
            $('#txubicacion').val('');
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    cuentainmueble();
                    cargalista();
                })
            }, iferror);
        }
        function cargaregion() {
            PageMethods.region(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlregion').append(inicial);
                $('#dlregion').append(lista);
            }, iferror);
        }
        function cargalista() {
            PageMethods.inmuebles($('#hdpagina').val(), $('#dlcliente').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btquita', function () {
                    $('#txid').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txinmueble').val($(this).closest('tr').find('td').eq(1).text());
                    $('#dlregion').val($(this).closest('tr').find('td').eq(2).text());
                    $('#txubicacion').val($(this).closest('tr').find('td').eq(4).text());
                });
            });
        }
        function cuentainmueble() {
            PageMethods.contarinmueble($('#dlcliente').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idbanco" runat="server" Value="0" />
        <asp:HiddenField ID="idestado" runat="server" Value="0" />
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
                    <h1>Asignar regiones para entrega de material<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Regiones para entrega</li>
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
                                    <label for="txid">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-1">
                                    <label>Id</label>
                                </div>
                                <div class="col-lg-2">
                                    <label>Punto de atención</label>
                                </div>
                                <div class="col-lg-2">
                                    <label>Región</label>
                                </div>
                                <div class="col-lg-2">
                                    <label>Ubicación</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input class="form-control" id="txid" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2">
                                    <input class="form-control" id="txinmueble" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlregion"></select>
                                </div>
                                <div class="col-lg-5">
                                    <textarea class="form-control" id="txubicacion"></textarea>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btagrega" class="btn btn-primary" value="Agregar"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-18 tbheader" style="height:350px; overflow-y:scroll">
                        <table class="table table-condensed" id="tblista">
                            
                        </table>
                        <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
