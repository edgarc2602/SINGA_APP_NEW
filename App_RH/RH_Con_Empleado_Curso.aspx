<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_Empleado_Curso.aspx.vb" Inherits="App_RH_RH_Con_Empleado_Curso" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CURSOS DE INDUCCION</title>
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
            $('#dvdatos').hide();
            setTimeout(function () {
                $("#menu").click();
            }, 50);
            $('#btconsulta').click(function () {
                cuentacandidato();
                cargalista();
            })
            $('#btguarda').click(function () {
                PageMethods.actualiza($('#txidemp').val(), $('#dlstatus1').val(), $('#txcomentario').val(), function (res) {
                    alert('Registro actualizado');
                }, iferror);
            })
            $('#btlista').click(function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            })
            $('#btimprime').on('click', function () { 
                var formula = '{tb_empleado_capacitacion.id_candidato}=' + $('#txidemp').val()
                window.open('../RptForAll.aspx?v_nomRpt=dc3.rpt&v_formula='+ formula , '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
        });
        function cuentacandidato() {
            PageMethods.contarcandidato($('#dlestatus').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalista() {
           
            PageMethods.candidato($('#hdpagina').val(), $('#dlestatus').val(),  function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    //limpia();
                    $('#txidemp').val($(this).children().eq(0).text());
                    $('#txregistro').val($(this).children().eq(1).text());
                    $('#txcliente').val($(this).children().eq(2).text());
                    $('#txsucursal').val($(this).children().eq(3).text());
                    $('#txnombre').val($(this).children().eq(4).text());
                    $('#txpuesto').val($(this).children().eq(8).text());
                    $('#txturno').val($(this).children().eq(9).text());
                    $('#txreclutador').val($(this).children().eq(10).text());
                    $('#txfecha').val($(this).children().eq(11).text());
                    $('#txhora').val($(this).children().eq(12).text());
                    $('#dlstatus1').val($('#dlestatus').val());
;                    //datosempleado();
                    $('#dvtabla').hide();
                    //$('#dvcapacita').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                });
            }, iferror);
        };
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
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
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
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
                    <h1>Personal para curso de inducción
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Personal para curso</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" >
                        <div class="box box-info">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txfecini">Fecha Inicial:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfecfin">Fecha Final:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control">
                                        <option value="1">Programado</option>
                                        <option value="2">Confirmado</option>
                                        <option value="3">Cancelado</option>
                                    </select>
                                </div>
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                        </div>
                        
                        <div id="dvdatos">
                            <div class="row">
                                <!-- /.box-header -->
                                <div class="col-lg-2 text-right">
                                    <label for="txidemp">No. Candidato:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txidemp" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txregistro">F. Registro:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txregistro" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txsucursal" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txpuesto">Puesto:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txturno">Turno:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txturno" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txreclutador">Reclutador:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txreclutador" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha programada:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txhora">Horario:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txhora" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlstatus1" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Programado</option>
                                        <option value="2">Confirmado</option>
                                        <option value="3">Cancelado</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcomentario">Comentarios:</label>
                                </div>
                                <div class="col-lg-6">
                                    <input type="text" id="txcomentario" class="form-control" />
                                </div>
                            </div>
                             <ol class="breadcrumb">
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir DC-3</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Candidatos</a></li>
                            </ol>
                        </div>
                        <div class="col-md-18 tbheader" id="dvtabla">
                            <table class="table table-condensed h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Id</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Registro</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Pto Atn</span></th>
                                        <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                        <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                        <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                        <th class="bg-light-blue-gradient"><span>No. SS</span></th>
                                        <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                        <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                        <th class="bg-light-blue-gradient"><span>Reclutador</span></th>
                                        <th class="bg-light-blue-gradient"><span>F. Curso</span></th>
                                        <th class="bg-light-blue-gradient"><span>H. Curso</span></th>
                                        <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                    </tr>
                                </thead>
                            </table>
                           
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
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
