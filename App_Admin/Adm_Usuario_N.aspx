<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Adm_Usuario_N.aspx.vb" Inherits="App_Admin_Adm_Usuario_N" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Catalogo de usuarios</title>
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
    <script> 
        var inicial = '<option value=0>Seleccione...</option>';
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#tbdatos').hide();
            carga();
            //cargaarea();
            //cargapuesto();
            cargagrupo();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 400,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#btlista').on('click', function () {
                carga()
                $('#tblista').show();
                $('#tbdatos').hide();
            });
            $('#btnuevo1').on('click', function () {
                limpia();
                $('#tblista').hide();
                $('#tbdatos').toggle('slide', { direction: 'down' }, 500);
            });
            $('#btnuevo').on('click', function () {
                limpia();
                $('#tblista').hide();
                $('#tbdatos').show();
            });
            $('#btguarda').on('click', function () {
                if (validar()) {
                    var xmlgraba = '<usuario id= "' + $('#txid').val() + '" estatus ="' + $('#dlestatus').val() + '" paterno = "' + $('#txpaterno').val() + '" materno = "' + $('#txmaterno').val() + '" ';
                    xmlgraba += ' nombre= "' + $('#txnombre').val() + '" correo= "' + $('#txcorreo').val() + '" tipo = "' + $('#dltipo').val() + '" usuario="' + $('#txusuario').val() + '" cont= "' + $('#txcont1').val() + '"';
                    xmlgraba += ' empleado = "' + $('#idempleado').val() + '" grupo = "' + $('#dlgrupo').val() + '"';
                    if ($('#cbelabora').is(':checked')) {
                        xmlgraba += ' elabora ="1"';
                    } else {
                        xmlgraba += ' elabora ="0"';
                    }
                    if ($('#cbrevisa').is(':checked')) {
                        xmlgraba += ' revisa ="1"';
                    } else {
                        xmlgraba += ' revisa ="0"';
                    }
                    if ($('#cbautoriza').is(':checked')) {
                        xmlgraba += ' autoriza ="1"';
                    } else {
                        xmlgraba += ' autoriza ="0"';
                    }
                    xmlgraba += '/>';
                    PageMethods.guarda(xmlgraba, function (res) {
                        $('#txid').val(res)
                        alert('El Usuario se ha guardado correctamente.');
                    }, iferror);
                };
            });
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        alert('El Usuario se ha eliminado correctamente');
                        limpia();
                        carga();
                        $('#dvgenerales').hide();
                        $('#tblista').show();
                        $('#tbdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir un Usuario'); }
            })
            $('#btempleado').on('click', function () {
                $("#divmodal").dialog('option', 'title', 'Buscar Empleado');
                $('#tbbusca tbody').remove();
                $('#txbusca').val('');
                dialog.dialog('open');
            });
            $('#btbusca').click(function () {
                if ($('#txbusca').val() != '') {
                    cargaempleado($('#txbusca').val());
                } else {
                    alert('Debe capturar un valor de búsqueda');
                }
            })
        });
        function carga() {
            PageMethods.cargausuario(function (res) {
                var ren = $.parseHTML(res);
                if (ren != null) {
                    $('#tblista table tbody').remove();
                    $('#tblista table').append(ren);
                    $('#tblista table tbody tr').on('click', function () {
                        limpia();
                        $('#txid').val($(this).children().eq(0).text());
                        $('#txusuario').val($(this).children().eq(3).text());
                        PageMethods.datosusuario($(this).children().eq(0).text(), function (opcion) {
                            var opt = eval('(' + opcion + ')');
                            $('#dlestatus').val(opt.status);
                            $('#txpaterno').val(opt.paterno);
                            $('#txmaterno').val(opt.materno);
                            $('#txnombre').val(opt.nombre);
                            $('#txcorreo').val(opt.mail);
                            $('#dltipo').val(opt.interno);
                            $('#txcont1').val(opt.pass);
                            $('#txcont2').val(opt.pass);
                            $('#txempleado').val(opt.empleado);
                            $('#txarea').val(opt.area);
                            $('#txpuesto').val(opt.puesto);
                            $('#idgrupo').val(opt.grupo);
                            cargagrupo();
                            if (opt.elabora == 'True') {
                                $('#cbelabora').prop("checked", true);
                            } else {
                                $('#cbelabora').prop("checked", false);
                            }
                            if (opt.revisa == 'True') {
                                $('#cbrevisa').prop("checked", true);
                            } else {
                                $('#cbrevisa').prop("checked", false);
                            }
                            if (opt.autoriza == 'True') {
                                $('#cbautoriza').prop("checked", true);
                            } else {
                                $('#cbautoriza').prop("checked", false);
                            }
                        }, iferror);
                        $('#tbdatos').toggle('slide', { direction: 'down' }, 500);
                        $('#tblista').hide();
                    });
                };
            });
        }
        function cargaarea() {
            PageMethods.area(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlarea').append(inicial);
                $('#dlarea').append(lista);
                           }, iferror);
        }
        function cargapuesto() {
            PageMethods.puesto(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlpuesto').append(inicial);
                $('#dlpuesto').append(lista);

            }, iferror);
        }
        function cargagrupo() {
            PageMethods.grupo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlgrupo').append(inicial);
                $('#dlgrupo').append(lista);
                if ($('#idgrupo').val() != '') {
                    $('#dlgrupo').val($('#idgrupo').val());
                }

            }, iferror);
        }
        function limpia() {
            $('#txid').val('');
            $('#txusuario').val('');
            $('#dlestatus').val(0);
            $('#txpaterno').val('');
            $('#txmaterno').val('');
            $('#txnombre').val('');
            $('#txcorreo').val('');
            $('#dltipo').val(0);
            $('#txcont1').val('');
            $('#txcont2').val('');
            $('#txempleado').val('');
            $('#txarea').val('');
            $('#txpuesto').val('');
            $('#dlgrupo').val(0);
            $('#cbelabora').prop("checked", false);
            $('#cbrevisa').prop("checked", false);
            $('#cbautoriza').prop("checked", false);
        }
        function validar() {
            if ($('#txpaterno').val() == '') {
                alert('Debe capturar el Apellido Paterno');
                return false;
            };
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el Nombre(s)');
                return false;
            };
            if ($('#txcorreo').val() == '') {
                alert('Debe capturar el Email');
                return false;
            };
            if ($('#txusuario').val() == '') {
                alert('Debe capturar el usuario');
                return false;
            };
            if ($('#txcont1').val() == '') {
                alert('Debe capturar la contraseña');
                return false;
            };
            if ($('#txcont2').val() == '') {
                alert('Debe capturar la confirmación de la contraseña');
                return false;
            };
            if ($('#txcont1').val() != $('#txcont2').val()) {
                alert('La contraseña colocada y su confirmación no coinciden, verifique');
                return false;
            };
            if ($('#dlarea').val() == 0) {
                alert('Debe seleccionar el Área');
                return false;
            };
            if ($('#dlpuesto').val() == 0) {
                alert('Debe seleccionar el Puesto');
                return false;
            };
            if ($('#dlgrupo').val() == 0) {
                alert('Debe seleccionar el Grupo');
                return false;
            };
            return true;
        }
        function cargaempleado() {
            PageMethods.empleado($('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                $('#tbbusca tbody tr').click(function () {
                    $('#idempleado').val($(this).children().eq(0).text());
                    $('#txempleado').val($(this).children().eq(1).text());
                    $('#txarea').val($(this).children().eq(2).text());
                    $('#txpuesto').val($(this).children().eq(3).text());
                    dialog.dialog('close');
                });
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
        <asp:HiddenField ID="idgrupo" runat="server" />
        <asp:HiddenField ID="idempleado" runat="server" />
        <asp:HiddenField ID="idarea" runat="server" />
        <asp:HiddenField ID="idpuesto" runat="server" />
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
                    <h1>Catálogo de Usuarios<small>Administración</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Administración</a></li>
                        <li class="active">Catálogo de usuarios</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="tbdatos">
                        <div class="col-md-10">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class=" box-header with-border">
                                    <!--<h3 class="box-title">Datos Usuario</h3>-->
                                </div>
                                <!-- /.box-header -->
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">ID:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dlestatus">Estatus:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlestatus" class="form-control">
                                            <option value="0">Activo</option>
                                            <option value="1">Suspendido</option>
                                            <option value="2">Baja</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txpaterno">Apellido Paterno:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txpaterno" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmaterno">Apellido Materno:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txmaterno" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre(s):</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcorreo">Email:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txcorreo" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo Usuario:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Interno</option>
                                            <option value="1">Externo</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txusuario">Usuario:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txusuario" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcont1">Contraseña:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="password" id="txcont1" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcont2">Repetir contraseña:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="password" id="txcont2" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlarea">Empleado:</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <input type="text" class="form-control" id="txempleado" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="button" value="Ligar con Empleado" id="btempleado" class="btn btn-info pull-right" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlarea">Area:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" class="form-control" id="txarea" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlpuesto">Puesto:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" class="form-control" id="txpuesto" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlgrupo">Grupo de accesos:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <select id="dlgrupo" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label>Privilegios:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbelabora" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbelabora">Elabora</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbrevisa" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbrevisa">Revisa</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbautoriza" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbautoriza">Autoriza</label>
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a ><i class="fa fa-save"></i> Guardar</a></li>
                                    <li id="btelimina" class="puntero"><a ><i class="fa fa-eraser"></i> Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a ><i class="fa fa-navicon"></i> Ir a Lista de Usuarios</a></li>
                                </ol>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <h3 class="box-title">Lista de Usuarios</h3>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Usuario</span></th>
                                            <th class="bg-navy"><span>F. Alta</span></th>
                                            <th class="bg-navy"><span>Estatus</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1"  class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>
                                </ol>
                            </div>
                        </div>
                    </div>
                    <div id="divmodal">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-lg-2 text-right"><label for="txbusca">Buscar</label></div>
                            <div class="col-lg-5"><input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />    </div>                                    
                            <div class="col-lg-1"><input type="button" class="btn btn-primary" value="Mostrar" id="btbusca"/>  </div>
                        </div>
                        <div class="tbheader">
                            <table class="table table-condensed" id="tbbusca">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Empleado</span></th>
                                        <th class="bg-navy"><span>Area</span></th>
                                        <th class="bg-navy"><span>Puesto</span></th>
                                    </tr>
                                </thead>
                            </table>
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
