<%@ Page Language="VB" AutoEventWireup="false" CodeFile="sitemap.aspx.vb" Inherits="Sitemap_sitemap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SiteMap</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <style type="text/css">
        .boton {
    float:left;
    margin-right:10px;
    margin-top:200px;
    width:130px;
    height:40px;
    background:#222;
    color:#fff;
    padding:16px 6px 0 6px;
    cursor:pointer;
    text-align:center;
}
 
.boton:hover{color:#01DF01}
 
.ventana{
 
    display:none;     
    font-family:Arial, Helvetica, sans-serif;
    color:#808080;
    line-height:28px;
    font-size:15px;
    text-align:justify;
 
}
        .style1
        {
            width: 110px;
        }
        .style2
        {
            width: 109px;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
   <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <div class="main-header">
        <!-- Logo -->
        <a href="../login.aspx" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>S</b>MAP</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>SITE</b>MAP</span>
        </a>

        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>

          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
              <!-- Notifications: style can be found in dropdown.less -->
               <li class="dropdown notifications-menu">
                <a href="#" >
                  <span class="label label-warning">Pendientes de Desarrollo</span>
                </a>
              </li>
              <!-- User Account: style can be found in dropdown.less -->
              <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <img src="../Content/form/img/incognito.jpg" class="user-image" alt="User Image" />
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </div>
 
      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->


        <!-- Main content -->
        <div class="content" >
          <div class="row" id="df">
            <div class="col-md-11">
              <div class="box box-info" id="paso1">
                <div class="box-header with-border">
                </div><!-- /.box-header -->
                <div class="box-header with-border">
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> HOME</a></li>
                    </ol>
                    <table class="box-body" id="Personal" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td class="style1">
                                <div class="box-header with-border">
                                <a><i class="fa-dashboard"></i> ...</a>
                                </div><!-- /.box-header -->
                            </td>
                            <td>
                                <div>
                                <li><a > Login</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Ayuda</span></a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Salir</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>

                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> VENTAS</a></li>
                    </ol>
                    <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td class="style1">
                                <a><i class="fa-dashboard"></i> P<small>ROCESOS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a> Cotizacion-Alta</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a>Factores-Configuracion</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                <a><i class="fa-dashboard"></i> C<small>ONSULTAS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > Cotizacion-Seguimiento</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a >Prospectos</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a ></i> Clientes</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <td>...
                        </td>
                        </tr>
                    </table>
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> INVENTARIOS</a></li>
                    </ol>

                    <table class="box-body" id="Table2" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td rowspan="2" class="style1">
                                <a><i class="fa-dashboard"></i> C<small>ATALOGOS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > Almacen</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Material</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Herramientas</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                <li><a > Equipo</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Uniforme</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Precios</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <td>...
                        </td>
                        </tr>
                    </table>
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> OPERACIONES</a></li>
                    </ol>
                    <table class="box-body" id="Table3" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td class="style1">
                                <a><i class="fa-dashboard"></i> M<small>ATERIALES</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > Asigna Supervisor</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Solicitud de Materiales</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Libera Montos</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Consulta listado</a></li>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="style1">
                                <a><i class="fa-dashboard"></i> H<small>ELP-DESK</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > Alta-Ticket</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > Envio-Ticket</a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <td>...
                        </td>
                        </tr>
                    </table>
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> RECURSOS HUMANOS</a></li>
                    </ol>
                    <table class="box-body" id="Table4" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td class="style2">
                                <a><i class="fa-dashboard"></i> E<small>MPLEADOS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Altas</span></a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a ><span class="label label-warning">Bajas</span> </a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Control de Faltas</span></a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td class="style2">
                                <a><i class="fa-dashboard"></i> P<small>LANTILLAS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a ><span class="label label-warning">Plantillas</span> </a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Vacantes</span></a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <td>...
                        </td>
                        </tr>
                    </table>
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa-dashboard"></i> ADMINISTRACION</a></li>
                    </ol>
                    <table class="box-body" id="Table5" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" >
                        <tr>
                            <td class="style1">
                                <a><i class="fa-dashboard"></i> C<small>ATALOGOS</small></a>
                            </td>
                            <td>
                                <div>
                                <li><a > Puestos</a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Usuarios</span></a></li>
                                </div>
                            </td>
                            <td>
                                <div>
                                <li><a > <span class="label label-warning">Usuarios Externos</span></a></li>
                                </div>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <td>...
                        </td>
                        </tr>
                    </table>
                </div><!-- /.box-header -->
              </div><!-- /.box-body -->

              <div class="box box-info" id="paso2" style="display:none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <%= lblcteinfo%>
                    </h3>
                </div>
                <div id="divp2" class="box-header with-border">
                    <h3 class="box-title">
                        <small>PASO 2 : Seleccione los opcion a capturar.
                        </small>
                    </h3>
                </div><!-- /.box-header -->

                <!--inmuebles-->
<!--termina inmuebles-->


                <div class="box-header with-border" >
                    <ol class="breadcrumb">
                        <li onclick="continuar(0);"><a ><i class="fa fa-dashboard"></i> Atras</a></li>
                        <li onclick="continuar(9);"><a ><i class="fa fa-dashboard"></i> Inmuebles</a></li>
                        <li onclick="continuar(2);"><a ><i class="fa fa-dashboard"></i> Personal</a></li>
                        <li onclick="continuar(3);"><a ><i class="fa fa-dashboard"></i> Uniformes</a></li>
                        <li onclick="continuar(4);"><a ><i class="fa fa-dashboard"></i> Materiales</a></li>
                        <li onclick="continuar(5);"><a ><i class="fa fa-dashboard"></i> Herramienta</a></li>
                        <li onclick="continuar(6);"><a ><i class="fa fa-dashboard"></i> Equipo</a></li>
                        <li onclick="continuar(7);"><a ><i class="fa fa-dashboard"></i> Servicios Adicionales</a></li>                     
                        <!-- /<li onclick="llenacot(1);"><a ><i class="fa fa-dashboard"></i> Ver Propuesta</a></li>   -->
                        <li onclick="continuar(8);"><a ><i class="fa fa-dashboard"></i>Ver Propuesta</a></li> 
                    </ol>
              </div><!-- /.box-header -->


              </div><!-- /.box-body -->




            </div><!--/.col (right) -->
        </div>   
        </div><!-- /.content -->



      </div><!-- /.content-wrapper -->
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>

      <!-- Control Sidebar -->
      <div class="control-sidebar control-sidebar-dark">
      </div>
    <!-- jQuery 2.1.4 -->
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script type="text/javascript">
        $.widget.bridge('uibutton', $.ui.button);
        function test_onclick() {

        }

    </script>


    <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </div>
     </form>
</body>
</html>
