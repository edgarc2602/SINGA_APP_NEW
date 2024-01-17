<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Cat_Clienteejecutivo.aspx.vb" Inherits="App_CGO_CGO_Cat_Clienteejecutivo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ENCARGADOS POR CLIENTE</title>
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
             cargaempleado();
             cargacliente();
             $('#btconsulta').click(function () {
                 cargalista();
             })
             $('#btagrega').click(function () {
                 PageMethods.actualiza($('#dlempleado').val(), $('#dlcliente').val(), function (res) {
                     $('#dlcliente').val(0);
                     cargalista();
                 }, iferror);
             })
             $('#btejecuta').click(function () {
                 PageMethods.ejecuta($('#dlempleado1').val(), $('#dlempleado').val(), function (res) {
                     cargalista();
                 }, iferror);
             })
             $('#btimprime').click(function () {
                 window.open('../RptForAll.aspx?v_nomRpt=ejecutivocgocliente.rpt&v_formula={tb_cliente.id_status} = 1', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
             });
         })
        function cargalista() {
            PageMethods.cliente($('#dlempleado').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                $('#tblista').delegate("tr .btquita", "click", function () {
                    PageMethods.elimina($('#dlempleado').val(), $(this).closest('tr').find('td').eq(0).text(), function (res) {
                        cargalista();
                    });
                });
            }, iferror)
        }
        function cargaempleado() {
            PageMethods.empleado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempleado').empty();
                $('#dlempleado').append(inicial);
                $('#dlempleado').append(lista);
                $('#dlempleado1').empty();
                $('#dlempleado1').append(inicial);
                $('#dlempleado1').append(lista);
            }, iferror)
        }
        function cargacliente() {
            PageMethods.clientes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <!--<asp:HiddenField ID="idcliente" runat="server" />-->
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" Value="0" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idencargado" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
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
                    <h1>Ejecutivos asignados por Cliente<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Clientes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info     ">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlempleado">Ejecutivo:</label>
                                </div>
                                <div class="col-lg-4 text-right">
                                    <select id="dlempleado" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-success" value="Mostrar" id="btconsulta" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-4 text-right">
                                    <label for="txclave">Cambiar todo al ejecutivo</label>
                                </div>
                                <div class="col-lg-4">
                                    <select class="form-control" id="dlempleado1"></select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-info" value="Aplicar cambio" id="btejecuta" />
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="row tbheader" style="height: 300px; overflow-y: scroll;">
                    <table class=" table table-condensed" id="tblista">
                        <thead>
                            <tr>
                                <th class="bg-light-blue-active">Id</th>
                                <th class="bg-light-blue-active">Cliente</th>
                                <th class="bg-light-blue-active"></th>
                            </tr>
                            <tr>
                                <td class=" col-lg-1"></td>
                                <td class=" col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </td>
                                <td class="col-lg-1">
                                    <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                </td>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <ol class="breadcrumb">
                    <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Listado de ejecutivos asignados</a></li>
                </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
