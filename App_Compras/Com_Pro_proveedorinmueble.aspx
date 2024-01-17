<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_proveedorinmueble.aspx.vb" Inherits="App_Compras_Com_Pro_proveedorinmueble" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>INMUEBLES POR PROVEEDOR</title>
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
        #tblista tbody td:nth-child(4){
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
            proveedor();
            cargacliente();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentainm();
                cargalista();
            })
            $('#btejecuta').click(function () {
                if ($('#tblista tbody tr').length != 0) {
                    var xmlgraba = ''
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        xmlgraba += '<partida proveedor="' + $('#dlproveedor1').val() + '" inmueble="' + $('#tblista tbody tr').eq(x).find('td').eq(2).text() + '"/>'
                    }
                    PageMethods.guarda(xmlgraba, function () {
                        alert('Registro completado.');
                        cuentainm()
                        cargalista();
                    }, iferror);
                }
            })
            $('#btagrega').click(function () {
                PageMethods.agrega($('#dlproveedor').val(), $('#dlsucursal').val(), function () {
                    //alert('Registro completado.');
                    $('#dlsucursal').val(0);
                    $('#dlcliente').val(0);
                    
                    cuentainm()
                    cargalista();
                }, iferror);
            })
            $('#btimprime').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=proveedorinmueble.rpt', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
            $('#btimprime1').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=proveedorNOinmueble.rpt', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
        })
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
                $('#dlcliente1').empty();
                $('#dlcliente1').append(inicial);
                $('#dlcliente1').append(lista);
                $('#dlcliente1').change(function () {
                    cargainmueble($('#dlcliente1').val())
                })
            }, iferror);
        }
        function proveedor() {
            PageMethods.catproveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
                $('#dlproveedor1').append(inicial);
                $('#dlproveedor1').append(lista);
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentainm() {
            PageMethods.contarinm($('#dlproveedor').val(), $('#dlcliente').val(), function (cont) {
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
            PageMethods.inmuebles($('#dlproveedor').val(), $('#dlcliente').val(), $('#hdpagina').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                $('#tblista').delegate("tr .btquita", "click", function () {
                    
                    PageMethods.elimina($(this).closest('tr').find('td').eq(3).text(), function (res) {
                        cuentainm();
                        cargalista();
                    });
                });
            }, iferror)

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
            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idunidad" runat="server" Value="0" />
        <asp:HiddenField ID="idfamilia" runat="server" Value="0" />
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
                    <h1>Asignar Proveedor a Sucursales<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Proveedores</li>
                    </ol>
                </div>
                <div class="content">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txclave">Proveedor</label>
                            </div>
                            <div class="col-lg-4">
                                <select class="form-control" id="dlproveedor"></select>
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txclave">Cliente</label>
                            </div>
                            <div class="col-lg-4">
                                <select class="form-control" id="dlcliente"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-success" value="Mostrar" id="btconsulta" />
                            </div>
                        </div>
                        <!--
                        <hr />

                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="txclave">Cambiar todo al proveedor</label>
                            </div>
                            <div class="col-lg-4">
                                <select class="form-control" id="dlproveedor1"></select>
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-success" value="Aplicar" id="btejecuta" />
                            </div>
                        </div>
                        -->
                    </div>
                    <div class="row tbheader" style="height: 300px; overflow-y: scroll;">
                        <table class=" table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Num</th>
                                    <th class="bg-light-blue-active">Cliente</th>
                                    <th class="bg-light-blue-active">Punto de atención</th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                                <tr>
                                    <td class=" col-lg-1"></td>
                                    <td class=" col-lg-3">
                                        <select id="dlcliente1" class="form-control"></select>
                                    </td>
                                    <td class="col-lg-3">
                                        <select id="dlsucursal" class="form-control"></select>
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
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
                     <ol class="breadcrumb">
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Detalle de inmuebles asignados</a></li>
                        <li id="btimprime1" class="puntero"><a><i class="fa fa-print"></i>Inmuebles no asignados</a></li>
                        <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Productos</a></li> -->
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
