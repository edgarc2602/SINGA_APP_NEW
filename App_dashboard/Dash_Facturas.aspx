<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Dash_Facturas.aspx.vb" Inherits="App_dashboard_Dash_Facturas" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>DASHBOARD FACTURAS</title>
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
    <script src="http://code.highcharts.com/highcharts.js" type="text/javascript"></script>
    <script type="text/javascript">
        //var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#dlmes').val(d.getMonth() + 1);
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            if ($('#idcliente1').val() == 0) {
                if ($('#reclutador').val() == 26) {
                    $('#dashrecluta').hide();
                    $('#dashinicial').show();
                    $('#dashinicialcliente').hide();
                    cargavacante();
                } else {
                    $('#dashinicial').show();
                    $('#dashrecluta').hide();
                    $('#dashinicialcliente').hide();
                }
            } else {
                $('#dashinicial').hide();
                $('#dashrecluta').hide();
                $('#dashinicialcliente').show();
            }
            cargadash();
            cargaticket();
            $('#dlmes').change(function () {
                cargaticket();
                cargadash();
            })
            $('#dvsupervision').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Resumen de supervisión');
                dialog1.dialog('open');
                cargasupervisiones(1)
            })
            $('#btsupervisor').click(function () {
                cargasupervisiones(1)
            })
            $('#btcliente').click(function () {
                cargasupervisiones(2)
            })
        });
        function cargavacante() {
            PageMethods.empleado($('#idusuario').val(), function (res) {
                var datos = eval('(' + res + ')');
                PageMethods.vacantes(datos.empleado, function (res) {
                    var ren = $.parseHTML(res);
                    $('#tblistavacante tbody').remove();
                    $('#tblistavacante').append(ren);
                    $('#tblistavacante tbody tr').click(function () {
                        window.open('App_RH/RH_Pro_Candidato.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_self');
                    });
                });
            });
            
        }
        function cargasupervisiones(opc){
            PageMethods.supervisiones($('#txanio').val(), $('#dlmes').val(),opc, function (res) {
                var ren = $.parseHTML(res);
                $('#tbsupervisiones tbody').remove();
                $('#tbsupervisiones').append(ren);
            });
        }
        function cargadash() {
            PageMethods.general($('#txanio').val(), $('#dlmes').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbcliente').text(datos.clientes);
                $('#lbfactura').text(datos.facturas);
                $('#lbempleado').text(datos.empleados);
                $('#lbvacante').text(datos.vacantes);
                $('#lbsupervision').text(datos.supervision);
                $('#lbentregas').text(datos.entregas);
                
;            }, iferror);
        }
        function cargaticket() {
            PageMethods.tickets($('#txanio').val(), $('#dlmes').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista table tbody tr').click(function () {
                    PageMethods.ticketarea($('#txanio').val(), $('#dlmes').val(), $(this).closest('tr').find('td').eq(2).text(), $(this).closest('tr').find('td').eq(0).text(), function (res) {
                        var opt = eval('(' + res + ')');
                        $('#chrsuc').highcharts(opt);
                    });
                });
            });
            PageMethods.ticketschr($('#txanio').val(), $('#dlmes').val(), function (res) {
                var opt = eval('(' + res + ')');
                $('#chrsuc1').highcharts(opt);
            });
            PageMethods.ticketarea($('#txanio').val(), $('#dlmes').val(), 0, 'Alta', function (res) {
                var opt = eval('(' + res + ')');
                $('#chrsuc').highcharts(opt);
            });
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
    <style>
        .sombra{
            background-color:white;
        }
        .valor{
            margin-left:50px;
            font-size:30px;
            color:black;
            font-family:Calibri;
        }
        #tblista table thead th:nth-child(3), #tblista table tbody td:nth-child(3){
            display:none;
            width:0px;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" />
        <asp:HiddenField ID="reclutador" runat="server" />
        <div class="wrapper" >
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
                    <h1>Dashboard</h1>
                    <ol class="breadcrumb">
                        <li><a ><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Clientes</a></li>
                        <li class="active">Dashboard</li>
                    </ol>
                </div>
                <div class="content" style="background-image:url(../Content/img/hero1.jpg); height:800px; background-repeat: no-repeat;" id="dashinicialcliente" >

                </div>
                <div class="content" style="height:800px; background-repeat: no-repeat;" id="dashrecluta" >
                    <h1>LISTA DE VACANTES ASIGNADAS</h1>
                    <div class="tbheader" style=" height: 800px; overflow-y: scroll;">
                        <table class=" table h1" id="tblistavacante">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">id</th>
                                    <th class="bg-light-blue-active">Descripción</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="content" style="background-color:#F2F2F2;" id="dashinicial">
                    <div class="row">
                        <div class="col-lg-1 text-right">
                            <label for="txanio">Año</label>
                        </div>
                        <div class="col-lg-1">
                            <input type="text" id="txanio" class="form-control"/>
                        </div>
                        <div class="col-lg-1 text-right">
                            <label for="dlmes">Mes</label>
                        </div>
                        <div class="col-lg-2">
                            <select id="dlmes" class="form-control">
                                <option value="1">Enero</option>
                                <option value="2">Febrero</option>
                                <option value="3">Marzo</option>
                                <option value="4">Abril</option>
                                <option value="5">Mayo</option>
                                <option value="6">Junio</option>
                                <option value="7">Julio</option>
                                <option value="8">Agosto</option>
                                <option value="9">Septiembre</option>
                                <option value="10">Octubre</option>
                                <option value="11">Noviembre</option>
                                <option value="12">Diciembre</option>
                            </select>
                        </div>
                        
                    </div>
                    <br />
                    <div class="container">
                        <div class="row my-4">
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Clientes</h4>
                                        <h2><i class="fa fa-building text-orange"></i><a class="card card-block text-center valor" id="lbcliente">98%</a></h2>
                                    </div>
                                </div>
                            </div>
                            <!--
                            <div class="col-md-4 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">facturas</h4>
                                        <h2><i class="fa fa-line-chart text-aqua"></i><a class="card card-block text-center valor" id="lbfactura">0</a></h2>
                                    </div>
                                </div>
                            </div>
                            -->
                            <div class="col-md-2 sombra margin">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Proyecto 6000</h4>
                                        <h2><i class="fa fa-users text-purple"><a class="card card-block text-center valor" id="lbempleado">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin" style="margin-left:100px;">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Vacantes</h4>
                                        <h2><i class="fa fa-male text-maroon"><a class="card card-block text-center valor" id="lbvacante">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin"  id="dvsupervision">
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Supervisión</h4>
                                        <h2><i class="fa fa-line-chart text-olive"><a class="card card-block text-center valor" id="lbsupervision">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 sombra margin" >
                                <div class="card text-center">
                                    <div class="card-block">
                                        <h4 class="card-title">Entregas</h4>
                                        <h2><i class="fa fa-bus text-warning"><a class="card card-block text-center valor" id="lbentregas">0</a></i></h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container">
                        <div class="row my-2">
                            <div class="col-md-3 sombra margin">
                                <div class="card text-center">
                                    <h4>Tickets por estatus</h4>
                                    <div id="tblista" class="tbheader" style="height:260px; " >
                                        <table class="table table-condensed">
                                            <thead>
                                                <tr>
                                                    <th class="bg-light-blue-gradient">Estatus</th>
                                                    <th class="bg-light-blue-gradient">Cantidad</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5 sombra margin" >
                                <div class="card text-center">
                                    <div id="chrsuc" style="height:300px;"> 
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 sombra margin" >
                                <div class="card text-center">
                                    <div id="chrsuc1" style="height:300px;"> 
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container">
                        <div class="row my-2">
                            <div class="col-md-3 sombra margin" >
                                <div class="card text-center">
                                    <div id="" style="height:300px;"> 
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                
                                <div class="col-lg-2">
                                    <input type="button" class="btn btn-primary" value="Por supervisor" id="btsupervisor" />
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" class="btn btn-primary" value="Por Cliente" id="btcliente" />
                                </div>
                            </div>
                            <div class="tbheader">
                                <table class="table table-condensed" id="tbsupervisiones">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Cantidad</span></th>
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
        <div id="loadingScreen"></div>
    </form>
</body>
</html>

