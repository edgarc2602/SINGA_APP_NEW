    <%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_AsignaCoordina.aspx.vb" Inherits="App_RH_RH_Pro_AsignaCoordina" %>

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
            //cargagerente();
            cargacoordinador();
            //cargacoordinadorcgo();
            $('#btnuevo').click(function () {
                $('#dlgerente').val(0);
                $('#dlcoordinador').val(0);
                $('#dlcgo').val(0);
            })
            $('#btguarda').click(function () {
                if (validaasigna()) {
                    //PageMethods.guarda($('#dlgerente').val(), $('#dlcoordinador').val(), 0, function (res) {
                        var xmlgraba = '<Movimiento coordina="' + $('#dlcoordinador').val() + '">';
                        $('#tblista tr input[type=checkbox]:checked').each(function () {
                            xmlgraba += '<recluta recluta="' + $(this).closest('tr').find('td').eq(0).text() + '"/>"';
                        });
                        xmlgraba += '</Movimiento>';
                        PageMethods.guarda1(xmlgraba, function (res) {
                            alert('Registro completado.');
                        }, iferror);
                    //}, iferror);
                }
            });

        });
        function validaasigna() {
            if ($('#dlcoordinador').val() == 0) {
                alert('Debe seleccionar un Coordinador de reclutamiento');
                return false;
            }
            return true;
        }
        function cargagerente() {
            PageMethods.gerente( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
                $('#dlgerente').val(0);
                
                $('#dlgerente').change(function () {
                    PageMethods.asignados($('#dlgerente').val(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#dlcoordinador').val(datos.coordrg);
                        $('#dlcgo').val(datos.coordcgo);
                        cargarecluta();
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
                $('#dlcoordinador').val(0);
                $('#dlcoordinador').change(function () {
                    cargarecluta();
                })
            }, iferror);
        }
        function cargarecluta() {
            PageMethods.recluta($('#dlcoordinador').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
            }, iferror);
        }
        function cargacoordinadorcgo() {
            PageMethods.cgo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcgo').append(inicial);
                $('#dlcgo').append(lista);
                $('#dlcgo').val(0);
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
                    <h1>Asignar Reclutadores a Coordinadores
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Asignar Coordinadores de RH a Gerentes</li>
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
                                        <label for="dlcoordinador">Coordinador de Reclutamiento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlcoordinador" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="tblista">Reclutadores asignados:</label>
                                    </div>
                                    <div class="col-md-6 tbheader" style="height:300px; overflow-y:scroll;">
                                        <table class="table table-condensed" id="tblista">
                                            <thead>
                                                <tr>
                                                    <th class="bg-navy"><span>Id</span></th>
                                                    <th class="bg-navy"><span>Nombre</span></th>
                                                    <th class="bg-navy"></th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                                
                                <!--
                                <div class="row">
                                   
                                    <div class="col-lg-3">
                                        <label for="dlcgo">Coordinador de CGO:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlcgo" class="form-control"></select>
                                    </div>
                                </div>
                                    -->
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btsalir1"  class="puntero" onclick="history.back();"><a ><i class="fa fa-edit" ></i>Salir</a></li>
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
