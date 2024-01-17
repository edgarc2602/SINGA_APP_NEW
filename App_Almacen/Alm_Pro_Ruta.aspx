<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_Ruta.aspx.vb" Inherits="App_Almacen_Alm_Pro_Ruta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>RUTAS DE ENTREGAS</title>
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
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 550,
                width: 900,
                modal: true,
                close: function () {
                }
            });
            cargacliente();
            cargalista();
            $('#btagrega').click(function () {
                if (valida()) {
                    PageMethods.guarda($('#idruta').val(), $('#txnombre').val(), function () {
                        cargalista();
                        $('#idruta').val(0);
                        $('#txnombre').val('');
                    }, iferror);
                }
            })
            $('#btagrega1').click(function () {
                PageMethods.agrega($('#idruta').val(), $('#dlsucursal').val(), function () {
                    cargainmueblelista();
                    cargainmueble($('#dlcliente').val());
                }, iferror);
            })
        })
        function cargainmueblelista() {
            PageMethods.inmuebles($('#idruta').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblistai tbody').remove();
                $('#tblistai').append(ren);
                $('#tblistai').delegate("tr .btquita", "click", function () {
                    PageMethods.eliminainmueble($('#idruta').val(), $(this).closest('tr').find('td').eq(0).text(), function () {
                        cargainmueble($('#dlcliente').val());
                    }, iferror);
                    $(this).parent().eq(0).parent().eq(0).remove();
                });
            }, iferror);
        }
        function cargalista() {
            PageMethods.rutas( $('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btver', function () {
                    $('#idruta').val($(this).closest('tr').find('td').eq(0).text());
                    $('#lbfolio').text($(this).closest('tr').find('td').eq(0).text());
                    $('#lbnombre').text($(this).closest('tr').find('td').eq(1).text());
                    cargainmueblelista();
                    $("#divmodal").dialog('option', 'title', 'Puntos de atención');
                    dialog.dialog('open');
                });
            }, iferror);
        }
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
                    cargainmueble($('#dlcliente').val());
                });
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
            }, iferror);
        }
        function valida() {
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el nombre de la Ruta');
                return false;
            }
            return true;
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
        <asp:HiddenField ID="idruta" runat="server" value="0"/>
        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home1.aspx" class="logo">
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
                    <h1>Rutas de entregas<small>Almacén</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacén</a></li>
                        <li class="active">Rutas</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Ruta:</label>
                                </div >
                                <div class="col-lg-3">
                                    <input class="form-control" id="txnombre"/>
                                </div>
                                 <div class="col-lg-1">
                                    <input type="button" id="btagrega" value="+" class="form-control btn-primary"/> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tbheader">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id</span></th>
                                    <th class="bg-navy"><span>Descripción</span></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div id="divmodal">
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Ruta:</label>
                            </div>
                            <div class="col-lg-2">
                                <label id="lbfolio" ></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Nombre:</label>
                            </div>
                            <div class="col-lg-6">
                                <label id="lbnombre"></label>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="dlcliente">Cliente:</label>
                            </div >
                            <div class="col-lg-4">
                                <select id="dlcliente" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="dlsucursal">Punto de atención:</label>
                            </div >
                            <div class="col-lg-4">
                                <select id="dlsucursal" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2">
                                <input type="button" id="btagrega1" value="Agregar" class="form-control btn-primary"/> 
                            </div>
                        </div>
                        
                        <!--
                        <div class="row">
                             <div class="col-lg-3">
                                <input type="button" class="btn btn-info" value="Imprimir" id="btimprime1" />
                            </div>
                        </div>
                        -->
                        <div class="row">
                            <div  id="dvjarceria" class="tbheader" style="height:400px; overflow-y:scroll;">
                                <table class=" table table-condensed h6" id="tblistai">
                                        <thead>
                                        <tr>
                                            <th class="bg-light-blue-active">Id</th>
                                            <th class="bg-light-blue-active">Cliente</th>
                                            <th class="bg-light-blue-active">Punto de atención</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
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
