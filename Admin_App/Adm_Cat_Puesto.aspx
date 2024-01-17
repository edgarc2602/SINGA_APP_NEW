<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Adm_Cat_Puesto.aspx.vb" Inherits="Admin_App_Adm_Cat_Puesto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
    <title></title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <!-- Bootstrap 3.3.4 -->
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- FontAwesome 4.3.0 -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Ionicons 2.0.0 -->
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <!-- Theme style -->
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.js"></script>
<script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

<script type="text/javascript">
    function muestra(tipo) {
        if (tipo == 0) {
            $('#calculo').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);

        }
        if (tipo == 1) {
            $('#calculo').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
        }
        if (tipo == 2) {
            $('#general').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
        }
        if (tipo == 3) {
            $('#general').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
        }
        if (tipo == 4) {
            $('#').hide('slow');
            $('#puesto').hide('slow');
            $('#calculo').hide('slow');
            $('#guarda').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
        }
    }
    function limpia() {
        __doPostBack('limpia', '0')
    }
    function valida() {
        dato = document.getElementById('txtclave').value
        if (dato == "") {
            alert('Validacion!, Debe de Capturar la Clave del Puesto')
            return false;            
        }
        dato = document.getElementById('txtPuesto').value
        if (dato == "") {
            alert('Validacion!, Debe de Capturar el Puesto')
            return false;
        }
        dato = document.getElementById('txtsm').value
        if (dato == "") {
            alert('Validacion!, Debe de Capturar el sueldo Mensual')
            return false;
        }
    }

</script>


</head>
  <body class="skin-blue sidebar-mini">
      <form id="form1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="wrapper">
      <header class="main-header">
        <!-- Logo -->
        <a href="../home.aspx" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>S</b>GA</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>SIN</b>GA</span>
        </a>
        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
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
                  <span class="hidden-xs">Diego Ander</span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </header>
      <!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
          <!-- sidebar menu: : style can be found in sidebar.less -->
          <ul class="sidebar-menu">
            <li class="header">NAVEGACION</li>
            <li class="treeview">
              <a href="#">
                <i class="fa fa-dashboard"></i> <span>Home</span> <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Ayuda</a></li>
                <li><a href="#"><i class="fa fa-circle-o"></i> Salir</a></li>
              </ul>
            </li>
            <li class="treeview">
              <a href="#">
                <i class="fa fa-share"></i> <span>Ventas</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Procesos <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Cotizacion-Alta</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Factores-Configuracion</a></li>
                  </ul>
                </li>
                <li><a href="#"><i class="fa fa-circle-o"></i> Consulta <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Cotizacion-Seguimiento</a></li>
                    <li class="active"><a href="#"><i class="fa fa-circle-o"></i> Cliente</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Directorio</a></li>
                  </ul>
                </li>
              </ul>
            </li>

            <li class="treeview">
              <a href="#">
                <i class="fa fa-share"></i> <span>Almacen</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Catalogos <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Almacen</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Material</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Herramienta</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Equipo</a></li>
                  </ul>
                </li>
              </ul>
            </li>

            <li class="treeview">
              <a href="#">
                <i class="fa fa-share"></i> <span>Operaciones</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Procesos <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Solicitud Materiales</a></li>
                  </ul>
                </li>
                <li><a href="#"><i class="fa fa-circle-o"></i> Help Desk <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Alta-Ticket</a></li>
                    <li class="active"><a href="#"><i class="fa fa-circle-o"></i> Envio-Ticket</a></li>
                    <li><a href="#"><i class="fa fa-circle-o"></i> Solicitud Material</a></li>
                  </ul>
                </li>
              </ul>
            </li>

            <li class="treeview">
              <a href="#">
                <i class="fa fa-share"></i> <span>Recursos Humanos</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Procesos <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Empleados</a></li>
                  </ul>
                </li>
                <li><a href="#"><i class="fa fa-circle-o"></i> Consultas <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> PLantilla</a></li>
                    <li class="active"><a href="#"><i class="fa fa-circle-o"></i> Vacantes</a></li>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </section>
        <!-- /.sidebar -->
      </aside>

      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
              Puesto
            <small>Catalogo</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Administracion</a></li>
            <li class="active">Puesto</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content" >
          <div class="row" id="df">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info" id="puesto">
                <div class="box-header with-border">
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="gral" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        ID:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtidc" class="form-control" runat="server" Enabled="false"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estatus:</td>
                    <td align ="left">
                        <asp:DropDownList ID="ddlstatus"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Activo</asp:ListItem>
                            <asp:ListItem Value="1">Baja</asp:ListItem>
                        </asp:DropDownList>
                    </td>

                    <td align="right">
                        Clave:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtclave" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Puesto:</td>
                    <td align="left">
                        <asp:TextBox ID="txtPuesto" class="form-control" placeholder="Intendente" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" >
                        Sueldo Mensual:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtsm" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                </tr>
            </table>
                <div class="box-header with-border">
                </div><!-- /.box-header -->
    </div><!-- /.box-body -->

          <div id="grid" style=" display:none;">
            <div class="row">
              <!-- general form elements -->
                    <asp:GridView ID="GridView1" 
                          runat="server" AutoGenerateColumns="False" BackColor="White" 
                          BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" CellPadding="4" 
                          DataKeyNames="Id" 
                          Font-Names="tahoma" Font-Size="12px" GridLines="Horizontal" Width="100%">
                      <Columns>
                          <asp:BoundField DataField="Id" HeaderText="Id" 
                              SortExpression="Id" />
                          <asp:BoundField DataField="Clave" HeaderText="Clave" 
                              SortExpression="Clave" />
                          <asp:BoundField DataField="Puesto" HeaderText="Puesto" 
                              SortExpression="Puesto" />
                          <asp:BoundField DataField="Estatus" HeaderText="Estatus" SortExpression="Estatus" />
                          <asp:BoundField DataField="Sueldo Mensual" HeaderText="Sueldo Mensual" SortExpression="Sueldo Mensual" />
                          <asp:BoundField DataField="Carga Social" HeaderText="Carga Social" SortExpression="Carga Social" />
                          <asp:BoundField DataField="S.Total Empleado" HeaderText="S.Total Empleado" SortExpression="S.Total Empleado" />
                      </Columns>
                      <FooterStyle BackColor="White" ForeColor="#333333" />
                      <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                      <HeaderStyle BackColor="#336666" Font-Bold="True" ForeColor="White" />
                      <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                      <RowStyle BackColor="White" ForeColor="#333333" />
                      <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                      <SortedAscendingCellStyle BackColor="#F7F7F7" />
                      <SortedAscendingHeaderStyle BackColor="#487575" />
                      <SortedDescendingCellStyle BackColor="#E5E5E5" />
                      <SortedDescendingHeaderStyle BackColor="#275353" />
                      </asp:GridView>
            <div class="col-md-11">
              <!-- Horizontal Form -->
            </div><!--/.col (right) -->
          </div>   
          </div>   

              <div class="box box-info" id="calculo">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>

                <div class="box-header with-border">
                  <h3 class="box-title"> <small>SALARIO</small></h3>
                </div><!-- /.box-header -->
            <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="center">
                        Premio Puntualidad:</td>
                    <td align="center">
                        Premio Asistecia:</td>
                    <td align="center">
                        Despensa:</td>                      
                    <td align="center">
                        Tiempo Extra:</td>
                    <td align="center">
                        Bono:</td>
                    <td align="center">
                        Prestaciones extras:</td>
                    <td align="center">
                        Total:</td>
                </tr>
                <tr>
                    <td align="left" >
                        <asp:TextBox ID="txtpp" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>

                    <td align="left" >
                        <asp:TextBox ID="txtpa" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtdesp" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                      
                    <td align="left" >
                        <asp:TextBox ID="txtte" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtbono" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtpext" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtptot" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
            </table>

                <div class="box-header with-border">
                  <h3 class="box-title"> <small>CARGA SOCIAL<small>
                      </small></small></h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table2" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="center">
                        Cuotas IMSS SM:</td>
                    <td align="center">
                        Cuotas INFONAVIT SM:</td>
                    <td align="center">
                        Cuotas RCV SM:</td>                      
                    <td align="center">
                        Impuesto Nomina:</td>
                    <td align="center">
                        Total:</td>
                    <td align="center">
                        Costo Total:</td>
                </tr>
                <tr>
                    <td align="left" >
                        <asp:TextBox ID="txtImss" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>

                    <td align="left" >
                        <asp:TextBox ID="txtinfonavit" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtrcv" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                      
                    <td align="left" >
                        <asp:TextBox ID="txtimpnom" class="form-control" runat="server" AutoPostBack="True"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtcstot" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtctot" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
            </table>



               <div class="box-header with-border">
                  <h3 class="box-title"><small>PROVISIONES MENSUALES</small></h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table3" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="center">
                        Aguinaldo Anual:</td>
                    <td align="center">
                        Vacaciones:</td>
                    <td align="center">
                        Prima Vacacional:</td>                      
                    <td align="center">
                        Total Gastos Fijos:</td>
                    <td align="center">
                       Sub Total por Puesto:</td>
                </tr>
                <tr>
                    <td align="left" >
                        <asp:TextBox ID="txtaguinaldo" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>

                    <td align="left" >
                        <asp:TextBox ID="txtvac" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtpvac" class="form-control" runat="server" AutoPostBack="True" Enabled="false"></asp:TextBox>
                    </td>
                      
                    <td align="left" >
                        <asp:TextBox ID="txttgf" class="form-control" runat="server" Enabled="false"></asp:TextBox>
                    </td>
                    <td align="left" >
                        <asp:TextBox ID="txtsubt" class="form-control" runat="server" Enabled="false"></asp:TextBox>
                    </td>
                </tr>
            </table>
               <div class="box-header with-border">
                </div><!-- /.box-header -->

                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="txtsm" EventName="TextChanged" />
                    </Triggers>
                </asp:UpdatePanel>

    </div><!-- /.box-body -->

    <div class="box-footer" id="guarda">
        <asp:Button ID="Button1" runat="server" Text="Guardar" class="btn btn-info pull-right"  onclientclick="return valida();"/>
        </div><!-- /.box-footer -->


        <ol class="breadcrumb">
            <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Puestos</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Puesto</a></li>
        </ol>
    </div><!-- /.box -->

            </div><!--/.col (right) -->

        </div>   
        </section><!-- /.content -->



      </div><!-- /.content-wrapper -->
      <footer class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </footer>

      <!-- Control Sidebar -->
      <aside class="control-sidebar control-sidebar-dark">
        <!-- Create the tabs -->
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
          <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
          <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
        </ul>
        <!-- Tab panes -->
        <div class="tab-content">
          <!-- Home tab content -->
          <div class="tab-pane" id="control-sidebar-home-tab">
            <h3 class="control-sidebar-heading">Recent Activity</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-birthday-cake bg-red"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">Langdon's Birthday</h4>
                    <p>Will be 23 on April 24th</p>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-user bg-yellow"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">Frodo Updated His Profile</h4>
                    <p>New phone +1(800)555-1234</p>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-envelope-o bg-light-blue"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">Nora Joined Mailing List</h4>
                    <p>nora@example.com</p>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-file-code-o bg-green"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">Cron Job 254 Executed</h4>
                    <p>Execution time 5 seconds</p>
                  </div>
                </a>
              </li>
            </ul><!-- /.control-sidebar-menu -->

            <h3 class="control-sidebar-heading">Tasks Progress</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    Custom Template Design
                    <span class="label label-danger pull-right">70%</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    Update Resume
                    <span class="label label-success pull-right">95%</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-success" style="width: 95%"></div>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    Laravel Integration
                    <span class="label label-warning pull-right">50%</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-warning" style="width: 50%"></div>
                  </div>
                </a>
              </li>
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    Back End Framework
                    <span class="label label-primary pull-right">68%</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-primary" style="width: 68%"></div>
                  </div>
                </a>
              </li>
            </ul><!-- /.control-sidebar-menu -->

          </div><!-- /.tab-pane -->
          <!-- Stats tab content -->
          <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div><!-- /.tab-pane -->
          <!-- Settings tab content -->
          <div class="tab-pane" id="control-sidebar-settings-tab">
              <h3 class="control-sidebar-heading">General Settings</h3>
              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Report panel usage
                  <input type="checkbox" class="pull-right" checked />
                </label>
                <p>
                  Some information about this general settings option
                </p>
              </div><!-- /.form-group -->

              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Allow mail redirect
                  <input type="checkbox" class="pull-right" checked />
                </label>
                <p>
                  Other sets of options are available
                </p>
              </div><!-- /.form-group -->

              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Expose author name in posts
                  <input type="checkbox" class="pull-right" checked />
                </label>
                <p>
                  Allow the user to show his name in blog posts
                </p>
              </div><!-- /.form-group -->

              <h3 class="control-sidebar-heading">Chat Settings</h3>

              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Show me as online
                  <input type="checkbox" class="pull-right" checked />
                </label>
              </div><!-- /.form-group -->

              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Turn off notifications
                  <input type="checkbox" class="pull-right" />
                </label>
              </div><!-- /.form-group -->

              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Delete chat history
                  <a href="javascript::;" class="text-red pull-right"><i class="fa fa-trash-o"></i></a>
                </label>
              </div><!-- /.form-group -->
          </div><!-- /.tab-pane -->
        </div>
      </aside><!-- /.control-sidebar -->
      <!-- Add the sidebar's background. This div must be placed
           immediately after the control sidebar -->
      <div class="control-sidebar-bg"></div>
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

      </form>

  </body>
</html>
