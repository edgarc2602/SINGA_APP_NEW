<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_empleadobaja.aspx.vb" Inherits="App_RH_RH_Con_empleadobaja" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>CONSULTA DE VACANTES</title>
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
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        var dialog; var dialog1;
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#btconsulta').click(function () {
                cargaempleado();
            })
            $('#btnuevo').click(function () {
                limpia();
            })
        });
        function limpia() {
            $('#txnoemp').val('');
            $('#txnombre').val('');
            $('#txfecreg').val('');
            $('#txregistro').val('');
            $('#txfecpro').val('');
            $('#txfeccon').val('');
            $('#txmotivo').val('');
            $('#txcomentbaja').val('');
        }
        function cargaempleado() {
            if ($('#txnoemp').val() != '') {
                PageMethods.empleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txnombre').val(datos.nombre);
                    $('#txfecreg').val(datos.fregistro);
                    $('#txregistro').val(datos.registro);
                    $('#txfecpro').val(datos.fprogramada);
                    $('#txfeccon').val(datos.fconfirmada);
                    $('#txmotivo').val(datos.motivo);
                    $('#txcomentbaja').val(datos.comentbaja);
                }, iferror);
            } else {
                alert('El numero de empleado capturado no existe o no tiene estatus de baja, verifique')
            }
            
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
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
        <asp:HiddenField ID="idempleado" runat="server" value="0"/>
        <asp:HiddenField ID="idpuesto" runat="server" value="0" />
        <asp:HiddenField ID="revisa" runat="server" value="0"/>
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
                 
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Consulta de Empleados en baja
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Consulta de empleados</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">No. emp:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoemp" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" value="Buscar" id="btconsulta" class="btn btn-info" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txnombre" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecreg">Fecha Registro:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecreg" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txregistro">Registrado por:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txregistro" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecpro">Fecha programada de baja:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecpro" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txmotivo">Motivo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txmotivo" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcomentbaja">Comentarios de baja:</label>
                                </div>
                                <div class="col-lg-6">
                                    <textarea id="txcomentbaja" class="form-control" disabled="disabled"></textarea>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfeccon">Fecha confirmada de baja IMSS:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfeccon" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            </ol>
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
