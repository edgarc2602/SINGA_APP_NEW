<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Con_listadocreado.aspx.vb" Inherits="App_Operaciones_Ope_Con_listadocreado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DETALLE DE LISTADOS</title>
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
             $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
             $('#var1').html('<%=listamenu%>');
             $('#nomusr').text('<%=minombre%>');
             setTimeout(function () {
                 if (screen.width > 740) {
                     $("#menu").click();
                 }
             }, 50);
             var d = new Date();
             $('#txanio').val(d.getFullYear());
             cargames();
             cargacomprador();
             $('#btexporta').click(function () {                 
                 window.open('Ope_DescargalistadoG.aspx?mes=' + $('#dlmes').val() + '&anio= ' + $('#txanio').val() + '&gerente=' + $('#dlgerente').val() + '', '_blank');
             })
         })
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
         function cargacomprador() {
             PageMethods.catcomprador(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlgerente').append(inicial);
                 $('#dlgerente').append(lista);
                 
             }, iferror);
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
         }
     </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
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
                    <h1>Consulta listados por Gerente
                        <small>Operaciones</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">listados</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info" style="height:100px;">
                            <div class=" box-header with-border">
                                <!--<h3 class="box-title">Lista de vacantes</h3>-->
                            </div>
                            <div class="row">
                                 <div class="col-lg-2 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                            </div>
                            <div  class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlgerente">Gerente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlgerente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="button" value="Exportar a excel" id="btexporta" class="btn btn-info pull-right" />
                                </div>
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
