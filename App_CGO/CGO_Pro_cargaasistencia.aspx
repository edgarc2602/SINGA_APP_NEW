<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_cargaasistencia.aspx.vb" Inherits="App_CGO_CGO_Pro_cargaasistencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CARGA DE ASISTENCIAS DE CHECADOR</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="../Content/css/General.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../Content/css/proyectos/Generalftp.css" type="text/css" media="screen" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            cargames();
            $('#btguarda').click(function () {
                if ($('#tblista tbody tr').length == 0) {
                    alert('No ha cargado registros de asistencia para aplicar, verifique');
                } else {
                    PageMethods.guarda($('#idusuario').val(), function () {
                        $('#paginacion li').remove();
                        $('#tblista tbody').remove();
                        $('#txarchivo').val('');
                        alert('Registro completado');
                    }, iferror);
                }
            })
        });
        function cargames() {
            PageMethods.mes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlmes').append(inicial);
                $('#dlmes').append(lista);
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargaasistencia();
            $('#paginacion li').eq(np - 1).addClass("active");
        }
        function xmlUpFile(res) {
            if (valida()) {
                if ($('#txarchivo').val() != '') {
                    var fileup = $('#txarchivo').get(0);
                    var files = fileup.files;
                    var ndt = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        ndt.append(files[i].name, files[i]);
                    }
                    ndt.append('nmr', res);
                    $.ajax({
                        url: 'GH_UpXLS.ashx',
                        type: 'POST',
                        data: ndt,
                        contentType: false,
                        processData: false,
                        success: function (res) {
                            PageMethods.gtxml(res, $('#dlmes').val(), $('#txanio').val(), $('#idusuario').val(), function () {

                                cargaasistencia();
                                cuentaasistencia();
                            }, iferror);
                        },
                        error: function (err) {
                            alert(err.statusText);
                        }
                    });
                } else {
                    alert('Debe elegir un archivo a cargar');
                }
            }
        }
        function valida() {
            if ($('#dlmes').val() == 0) {
                alert('Debe seleccionar un Mes');
                return false;
            }
            return true;
        }
        function cuentaasistencia() {
            PageMethods.contarasistencia(function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargaasistencia() {
            PageMethods.asistencia($('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                if (ren != null) {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                }
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
                    <h1>Carga de asistencias de checador<small>CGO</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Control de asistencia</li>
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
                                    <label for="dlcliente">Archivo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="file" id="txarchivo" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlmes"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input class="form-control" id="txanio"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3">
                                    <input type="button" id="btfile" class="btn btn-success" value="cargar" onclick="xmlUpFile()" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="height:400px; overflow-y:scroll">
                        <div class="col-md-18 tbheader">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                        <th class="bg-light-blue-gradient"><span>No. emp</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                        <th class="bg-light-blue-gradient"><span>Fecha</span></th>
                                        <th class="bg-light-blue-gradient"><span>H. ent</span></th>
                                        <th class="bg-light-blue-gradient"><span>H. sal</span></th>
                                        <th class="bg-light-blue-gradient" colspan="3"><span>Período</span></th>
                                    </tr>
                                </thead>
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
                    </div>
                    <div class="box box-info">
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Procesar registros</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
