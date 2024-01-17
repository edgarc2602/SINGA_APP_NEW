<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Act_Vacante.aspx.vb" Inherits="App_RH_RH_Act_Vacante" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ACTIVAR EMPLEADOS</title>
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
    <style>
        #tbdatos thead th:nth-child(4), #tbdatos tbody td:nth-child(4){
            display:none;
            width:0px;
        }
        .tbeditar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e802';
        }
        .tbrechaza:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\f1f8';
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        
        $(function () {
            $('#var1').html('<%=listamenu%>');
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            cargacliente();
            $('#btconsulta').click(function () { 
                cargalista();
            })
        })
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
               
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').val(0);
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
            }, iferror);
        }
        function cargainmueble(idcte) {
            PageMethods.inmueble(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlinmueble').empty();
                $('#dlinmueble').append(inicial);
                $('#dlinmueble').append(lista);
                $('#dlinmueble').val(0);
            }, iferror);
        }
        function cargalista() {
            //alert('hola');
            PageMethods.vacantes($('#dlcliente').val(), $('#dlinmueble').val(), function (res) {
                if (ren != '') {
                    var ren = $.parseHTML(res);
                    $('#tblista table tbody').remove();
                    $('#tblista table').append(ren);
                    $('#tblista table tbody tr').on('click', '.tbeditar', function () {
                        var r = confirm("Al confirmar el ingreso de esta persona, se registra como Empleado activo, ¿estas seguro de continuar?");
                        if (r == true) {
                            var f = new Date();
                            var mm = f.getMonth() + 1
                            if (mm.toString.length == 1) {
                                mm = "0" + mm
                            }
                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                            var cliente = $(this).closest('tr').find('td').eq(4).text();
                            var puesto = $(this).closest('tr').find('td').eq(11).text();
                            var sucursal = $(this).closest('tr').find('td').eq(5).text();
                            var persona = $(this).closest('tr').find('td').eq(6).text();
                            var empleado = $(this).closest('tr').find('td').eq(2).text();
                            var vacante = $(this).closest('tr').find('td').eq(3).text();
                            var rfc = $(this).closest('tr').find('td').eq(7).text();
                            var curp = $(this).closest('tr').find('td').eq(8).text();
                            var ss = $(this).closest('tr').find('td').eq(9).text();
                            PageMethods.activaemp(fecha, cliente, puesto, sucursal, persona, empleado, vacante, $('#idusuario').val(),rfc, curp, ss, function () {
                                alert('La persona ha sido activada correctamente')
                                cargalista();
                            }, iferror);
                        } else {
                            alert('No se ejecuta ninguna acción!');
                        }
                    });
                    $('#tblista table tbody tr').on('click', '.tbrechaza', function () {
                        var r = confirm("Al indicar que el personal no ingreso, la vacante se reactiva, ¿Esta seguro de continuar?");
                        if (r == true) {
                            //alert($('#idusuario').val())
                            var f = new Date();
                            var mm = f.getMonth() + 1
                            if (mm.toString.length == 1) {
                                mm = "0" + mm
                            }
                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                            var cliente = $(this).closest('tr').find('td').eq(4).text();
                            var puesto = $(this).closest('tr').find('td').eq(8).text();
                            var sucursal = $(this).closest('tr').find('td').eq(5).text();
                            var persona = $(this).closest('tr').find('td').eq(6).text();
                            var empleado = $(this).closest('tr').find('td').eq(2).text();
                            var vacante = $(this).closest('tr').find('td').eq(3).text();
                            //alert(empleado);
                            PageMethods.reactivavacante(fecha, cliente, puesto, sucursal, persona, empleado, vacante, $('#idusuario').val(), function () {
                                alert('La persona ha sido registrada como NO ingreso y se ha reactivado la vacante')
                                cargalista();
                            }, iferror);
                        } else {
                            alert('No se ejecuta ninguna acción!');
                            /*
                            var f = new Date();
                            var mm = f.getMonth() + 1
                            if (mm.toString.length == 1) {
                                mm = "0" + mm
                            }
                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                            var cliente = $(this).closest('tr').find('td').eq(4).text();
                            var puesto = $(this).closest('tr').find('td').eq(8).text();
                            var sucursal = $(this).closest('tr').find('td').eq(5).text();
                            var persona = $(this).closest('tr').find('td').eq(6).text();
                            var empleado = $(this).closest('tr').find('td').eq(2).text();
                            var vacante = $(this).closest('tr').find('td').eq(3).text();
                            //alert(empleado);
                            PageMethods.noreactivavacante(fecha, cliente, puesto, sucursal, persona, empleado, vacante, $('#idusuario').val(), function () {
                                alert('La persona ha sido registrada como NO ingreso')
                                cargalista();
                            }, iferror);*/
                        }
                    });
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
        <asp:HiddenField ID="idusuario" runat="server"/>
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
                  
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Activar Empleado
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Activar empleado</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlinmueble">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlinmueble" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <div class="col-md-18 tbheader" style="overflow-x:scroll;">
                                <table class="table table-condensed h6" id="tbdatos" >
                                    <thead> 
                                        <tr>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"><span>Id</span></th>
                                            <th class="bg-light-blue-gradient"><span>Id</span></th>
                                            <th class="bg-light-blue-gradient"><span>Completo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Pto Atn</span></th>
                                            <th class="bg-light-blue-gradient"><span>Empleado</span></th>
                                            <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                            <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                            <th class="bg-light-blue-gradient"><span>NSS</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Vacante</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Registro</span></th>
                                            <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                            <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Ingreso</span></th>
                                            <th class="bg-light-blue-gradient"><span>Banco</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cuenta</span></th>
                                            <th class="bg-light-blue-gradient"><span>Tarjeta</span></th>
                                            <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <!--<li id="btnuevoinm"  class="puntero"><a ><i class="fa fa-edit"></i> Nuevo</a></li>-->
                                    <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
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
