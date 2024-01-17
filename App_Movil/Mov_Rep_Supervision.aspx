<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Mov_Rep_Supervision.aspx.vb" Inherits="App_Movil_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REPORTE SUPERVISION</title>
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
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" /> <!--LINK PARA EL FONDO DE MENU-->
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        var inicial1 = '<option value=1>SIN SUPERVISOR</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            if ($('#idfolio').val() != 0) {
                $('#txfolio').val($('#idfolio').val());
                cargasupervision();
            }
            //cargaencuesta();
            //cargacliente();
        });
        function cargasupervision() {
            PageMethods.supervision($('#idfolio').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfecha').val(datos.fechaini);
                $('#txcliente').val(datos.cliente);
                $('#txsucursal').val(datos.inmueble);
                $('#txnombre').val(datos.usuario);
                $('#txfter').val(datos.fechafin);
                $('#txtienelista').val(datos.tienelista);
                $('#txestareg').val(datos.listaregistro);
                $('#txuniforme').val(datos.personaluniforme);
                $('#txcredencial').val(datos.personalcredencial);
                $('#txcomentp').val(datos.personalcomentario);
                $('#txherramienta').val(datos.herramientacompleta);
                $('#txmatord').val(datos.materialordenado);
                $('#txcontrolinv').val(datos.materialinventario);
                $('#txbitacora').val(datos.materialbitacora);
                $('#txrutinas').val(datos.limpiezarutina);
                $('#txvisual').val(datos.materialvisual);
                $('#txcomentm').val(datos.materialcomentario);
                $('#txentrevista').val(datos.clienteentrevista);
                $('#txnomcli').val(datos.clientenombre);
                $('#txevaluagen').val(datos.evalua);
                $('#txcalidad').val(datos.trabrealizados);
                $('#txunieva').val(datos.uniformcompleto);
                $('#txtrato').val(datos.tratopersonal);
                $('#txrecorrido').val(datos.suprecorrido);
                $('#txareasop').val(datos.areaoportunidad);
                $('#txplanes').val(datos.plancorrectivo);
                $('#txcalificas').val(datos.calificasup);
                $('#txcalifcgo').val(datos.ejecutivocgo);
                $('#txrepasis').val(datos.reporteasiscgo);
                $('#txmatent').val(datos.matetiquetados);
                $('#txmatcum').val(datos.matrequerimientos);
                $('#txcomcli').val(datos.clientecomentario);
                
                PageMethods.fotos($('#idfolio').val(), function (res) {
                    //closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);

                })
                
            }, iferror)
        }
        

        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
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
        <asp:HiddenField ID="idfolio" runat="server" value="0"/>
        <asp:HiddenField ID="idcliente" runat="server" value="0"/>
        <asp:HiddenField ID="idinmueble" runat="server" value="0"/>
        <asp:HiddenField ID="idcomprador" runat="server" value="0"/>
        <asp:HiddenField ID="idencuesta" runat="server" value="0"/>
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
                    <h1>Reporte de Supervisiones
                        <small>App Movil</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>App Movil</a></li>
                        <li class="active">Supervision</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <!-- Horizontal Form -->
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de Ticket</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-5 text-right">
                                    <label for="txfolio">No. Supervisión</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control text-right" type="text" id="txfolio" value="0" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control text-right" type="text" id="txfecha" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txcliente">Cliente</label>
                                </div>
                                <div class="col-lg-3">
                                    <input class="form-control" id="txcliente" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txsucursal">Punto de atención</label>
                                </div>
                                <div class="col-lg-3">
                                    <input class="form-control" id="txsucursal" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txnombre">usuario</label>
                                </div>
                                <div class="col-lg-3">
                                    <input  class="form-control" type="text" id="txnombre"  disabled="disabled"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txfter">F. termino</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control" type="text" id="txfter" disabled="disabled"/>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2">
                                    <label class="h3">Personal</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Tiene lista de asistencia</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txtienelista"  disabled="disabled"/>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txnombre">Se registra en la lista</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txestareg"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con uniforme</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txuniforme"  disabled="disabled"/>
                                </div>
                                <div class="col-lg-2">
                                    <label for="txnombre">Cuenta con credencial</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txcredencial"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Comentarios</label>
                                </div>
                                <div class="col-lg-5">
                                    <textarea class="form-control" id="txcomentp"  disabled="disabled"></textarea>   
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-4">
                                    <label class="h3">Equipo y Herramienta</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con el equipo y la herramienta</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txherramienta"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <label class="h3">Jarcería y Químicos</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Material ordenado y almacenado</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txmatord"  disabled="disabled"/>
                                </div>
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con control de inventario</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txcontrolinv"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con bitacora del uso</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txbitacora"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <label class="h3">Documentación</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con rutinas y plan de trabajo</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txrutinas"  disabled="disabled"/>
                                </div>
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Cuenta con material visual</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txvisual"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Comentarios</label>
                                </div>
                                <div class="col-lg-5">
                                    <textarea class="form-control" id="txcomentm"  disabled="disabled"></textarea>   
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-4">
                                    <label class="h3">Evaluación del servicio</label>
                                </div>
                            </div>
                             <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txnombre">Hubo entrevista con el cliente</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txentrevista"  disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row" id="dvevalua">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre del CLiente</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input  class="form-control" type="text" id="txnomcli"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txevaluagen">Evaluación general</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txevaluagen"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <label class="h4">Sobre personal</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcalidad">Calidad de los trabajos</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txcalidad"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txunieva">Tiene Uniforme</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txunieva"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Trato al cliente</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txtrato"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <label class="h4">Sobre el supervisor</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrecorrido">Realiza recorridos</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txrecorrido"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-3 text-right">
                                        <label for="txareasop">Notifico areas de oportunidad</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txareasop"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txplanes">Informo planes y fechas</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txplanes"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="txcalificas">Calificación del supervisor</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txcalificas"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <label class="h4">Sobre CGO</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="txcalifcgo">Como califica a su ejecutivo</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input  class="form-control" type="text" id="txcalifcgo"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-3 text-right">
                                        <label for="txrepasis">Entrega el reporte de asistencia</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txrepasis"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <label class="h4">Sobre Materiales</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="txmatent">Se entregan correctamente etiquetados y envasados</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txmatent"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-3 text-right">
                                        <label for="txmatcum">Comple con los requerimientos del servicio</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input  class="form-control" type="text" id="txmatcum"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="txcomcli">Comentarios del cliente</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <textarea class="form-control" id="txcomcli"  disabled="disabled"></textarea>   
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Sección</span></th>
                                            <th class="bg-navy"><span>Fotos</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir encuesta</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
