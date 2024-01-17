﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Cat_Empresa.aspx.vb" Inherits="App_Finanzas_Fin_Cat_Empresa" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE EMPRESAS</title>
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
            $('#dvdatos').hide();
            cargaestado();
            cargalista();
            $('#btguarda').click(function () {
                if (valida()) {
                    var xmlgraba = '<empresa id= "' + $('#txid').val() + '" nombre = "' + $('#txnombre').val() + '" tipo = "' + $('#dltipo').val() + '"  registro= "' + $('#txregistro').val() + '" razon ="' + $('#txrazon').val() + '" rfc = "' + $('#txrfc').val() + '" calle = "' + $('#txcalle').val() + '" ';
                    xmlgraba += ' colonia= "' + $('#txcolonia').val() + '" cp= "' + $('#txcp').val() + '" municipio = "' + $('#txmunicipio').val() + '" estado = "' + $('#dlestado').val() + '" />';
                    //alert(xmlgraba)
                    PageMethods.guarda(xmlgraba, function (res) {
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btlista').on('click', function () {
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btnuevo1').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btnuevo').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        alert('Registro eliminado');
                        limpia();
                        cargalista();
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir una Empresa');}
            })
        });
        function datosempresa() {
            PageMethods.detalle($('#txid').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txregistro').val(datos.registro);
                $('#dltipo').val(datos.tipo);
                $('#txcalle').val(datos.callenum);
                $('#txcolonia').val(datos.colonia);
                $('#txcp').val(datos.cp);
                $('#txmunicipio').val(datos.municipio);
                $('#idestado').val(datos.estado);
                cargaestado();
            }, iferror);
        };
        function cargalista() {
            PageMethods.empresa(function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', function () {
                    limpia();
                    $('#txid').val($(this).children().eq(0).text())
                    $('#txnombre').val($(this).children().eq(1).text())
                    $('#txrazon').val($(this).children().eq(3).text())
                    $('#txrfc').val($(this).children().eq(4).text())
                    datosempresa();
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                });
            }, iferror);
        }
        function limpia() {
            $('#txid').val(0);
            $('#txnombre').val('');
            $('#dltipo').val(0);
            $('#txregistro').val('');
            $('#txrazon').val('');
            $('#txrfc').val('');
            $('#txcalle').val('');
            $('#txcolonia').val('');
            $('#txcp').val('');
            $('#txmunicipio').val('');
            $('#dlestado').val(0);
        }

        function valida() {
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el nombre de la Empresa');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de empresa');
                return false;
            }
            if ($('#txrazon').val() == '') {
                alert('Debe capturar la razón social');
                return false;
            }
            if ($('#txrfc').val() == '') {
                alert('Debe capturar el RFC');
                return false;
            }
            return true;
        }
        function cargaestado() {
            PageMethods.estado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);
                if ($('#idestado').val() != '') {
                    $('#dlestado').val($('#idestado').val());
                };
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
        <asp:HiddenField ID="idestado" runat="server" />
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
                    <h1>Catálogo de Empresas<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Catálogo de Empresas</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-10">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <!-- /.box-header -->
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">ID:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txnombre">Nombre:</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <input type="text" id="txnombre" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Manejo de Personal</option>
                                            <option value="2">Operativa</option>
                                        </select>
                                    </div>
                                    <div  class="col-lg-3 text-right">
                                        <label for="txregistro">Registro Patronal</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txregistro" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrazon">Razón Social:</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <input type="text" id="txrazon" class="form-control"/>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txrfc">RFC:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txrfc" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcalle">Calle y num:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcalle" class="form-control"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcolonia">Colonia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcolonia" class="form-control"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcp">C.P.:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcp" class="form-control"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmunicipio">Municipio:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txmunicipio" class="form-control"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dlestado">Estado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestado" class="form-control"></select>
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empresas</a></li>
                                    <li id="btsalir1"  class="puntero" onclick="history.back();"><a ><i class="fa fa-edit" ></i>Salir</a></li>
                                </ol>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Tipo</span></th>
                                            <th class="bg-navy"><span>Razón Social</span></th>
                                            <th class="bg-navy"><span>RFC</span></th>
                                        </tr>
                                    </thead>
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
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
