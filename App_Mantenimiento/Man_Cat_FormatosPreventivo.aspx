<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Man_Cat_FormatosPreventivo.aspx.vb" Inherits="App_Mantenimiento_Man_Cat_FormatosPreventivo" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>FORMATOS PREVENTIVO</title>
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

            $('#dlcliente').append(inicial);

            cargacliente();
            cargalista();

            $('#btagrega').click(function () {
                if (valida()) {
                    PageMethods.guarda($('#dlcliente').val(), function () {
                        cargalista();
                        $('#dlcliente').val('0');
                    }, iferror);
                }
            });

            $('#btagregapr').click(function () {
                if (validapr()) {
                    PageMethods.guardapr($('#idformato').val(), $('#dltrabajos').val(), $('#dlpuntos').val(), function () {
                        muestradetalle();
                        $('#dlpuntos').val('0');
                        $('#dltrabajos').val('0');
                    }, iferror);
                }
            });
        });

        function cuentatrabajospunto() {
            PageMethods.contartrabajos($('#idformato').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#navpagination').show();                
                $('#paginacion').append(pag);
            }, iferror);
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
            }, iferror);
        }

        function cargapuntos() {
            PageMethods.puntos(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlpuntos').empty();
                $('#dlpuntos').append(inicial);
                $('#dlpuntos').append(lista);
            }, iferror);
        }

        function cargatrabajos() {
            PageMethods.trabajos(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltrabajos').empty();
                $('#dltrabajos').append(inicial);
                $('#dltrabajos').append(lista);
            }, iferror);
        }

        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            muestradetalle();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cargalista() {
            PageMethods.formatospreventivo($('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);

                $('#tblista  tbody tr input').on('click', function () {
                    $('#idformato').val(this.getAttribute("idformato"));
                    ocultalista();
                    cargapuntos();
                    cargatrabajos();
                    muestradetalle();
                });
            }, iferror);
        }

        function ocultalista() {
            $("#dvdatos").hide();
            $("#tblista").hide();
        }

        function muestradetalle() {
            cuentatrabajospunto();

            PageMethods.formato($('#idformato').val(), $('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbpuntotrabajo tbody').remove();
                $('#tbpuntotrabajo').append(ren);

                $('#tbpuntotrabajo').show();
                $('#dvpuntotrabajo').show();

                $('.btborra').on('click', function () {
                    PageMethods.borrartrabajopunto(this.getAttribute("idtrabajopunto"), function (res) {
                        muestradetalle();
                    }, iferror);
                });

            }, iferror);
        }

        function valida() {
            if ($('#dlcliente').val() == '0') {
                alert('Debe seleccionar un cliente');
                return false;
            }
            return true;
        }
        function validapr() {
            if ($('#dlpuntos').val() == '0') {
                alert('Debe seleccionar un punto de revisión');
                return false;
            }
            else if ($('#dltrabajos').val() == '0') {
                alert('Debe seleccionar un trabajo a realizar');
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
        <asp:HiddenField ID="idformato" runat="server" value="0"/>
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
                    <h1>Formatos de Preventivo<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimiento</a></li>
                        <li class="active">Formatos de Preventivo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                               
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                 <div class="col-lg-1">
                                    <input type="button" id="btagrega" value="Agregar" class="form-control btn-primary"/> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tbheader">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id Formato</span></th>
                                    <th class="bg-navy"><span>Cliente</span></th>
                                    <th class="bg-navy"></th>
                                </tr>
                            </thead>
                        </table>
                    </div>

                    <div class="row" id="dvpuntotrabajo" hidden>
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                               
                                <div class="col-lg-4 col-lg-offset-1">
                                    <label>Punto de revisión:</label>
                                    <select id="dlpuntos" class="form-control"></select>
                                </div>
                                <div class="col-lg-4">
                                    <label>Trabajo a realizar:</label>
                                    <select id="dltrabajos" class="form-control"></select>
                                </div>                                
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-1 col-lg-offset-8">
                                    <input type="button" id="btagregapr" value="Agregar" class="form-control btn-primary"/> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tbheader" >
                        <table class="table table-condensed" id="tbpuntotrabajo" hidden>
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Punto de revisión</span></th>
                                    <th class="bg-navy"><span>Trabajo a realizar</span></th>
                                    <th class="bg-navy"><span>Área</span></th>
                                    <th class="bg-navy"></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <nav aria-label="Page navigation example" class="navbar-right" id="navpagination" hidden>
                        <ul class="pagination justify-content-end" id="paginacion">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">Previous</a>
                            </li>
                            <li class="page-item"><a class="page-link" href="#">1</a></li>
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

