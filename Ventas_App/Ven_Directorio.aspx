<%@ Page Language="VB"  enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ven_Directorio.aspx.vb" Inherits="Ventas_App1_Ven_Directorio" %>

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
            $('#general').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
            
        }
        if (tipo == 1) {
            $('#general').hide('slow');
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
            $('#general').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
        }
    }
    function limpia() {
        __doPostBack('limpia', '0')
    }
    function valida() {
        var e = document.getElementById("ddlejecutivo");
        var strejec = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlstatus");
        var strstatus = e.options[e.selectedIndex].text;

    }

</script>


</head>
  <body class="skin-blue sidebar-mini">
      <form id="form1" runat="server">
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
            <%= labelmenu%>
        </section>
        <!-- /.sidebar -->
      </aside>

      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
              Directorio
            <small>Catalogo</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li><a>Cliente</a></li>
            <li class="active">Directorio</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content" >
          <div class="row" id="df">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info" id="fiscal">
                <div class="box-header with-border">
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="cliente" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        Clave:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtclave" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        ID:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtidc" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Nombre Comercial:</td>
                    <td align="left" colspan="3">
                        <asp:TextBox ID="txtncomercial" class="form-control" placeholder="Grupo Batia" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>

    </div><!-- /.box-body -->

          <div id="grid" style=" display:none;" >
            <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="ID_Sucursal,Cte_Dir_Contacto,Cte_Dir_Mail,Cte_Dir_Telefono,Cte_Dir_Calle,Cte_Dir_Colonia,Cte_Dir_CP,Cte_Dir_Delegacion,Cte_Dir_Ciudad,cte_dir_Estado" >
                    <Columns>
                        <asp:BoundField DataField="Cte_Dir_No_Surusal" HeaderText="Cve. Surcusal Cte" 
                            SortExpression="Cte_Dir_No_Surusal" />
                        <asp:BoundField DataField="Cte_Dir_Sucursal" HeaderText="Sucursal" 
                            SortExpression="Cte_Dir_Sucursal" />
                        <asp:BoundField DataField="Cte_Dir_Cve_Interna" HeaderText="Cve. Interna" 
                            SortExpression="Cte_Dir_Cve_Interna" />
                        <asp:BoundField DataField="Dir" HeaderText="Direccion"   SortExpression="Dir" />
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
            </div><!--/.col (right) -->
          </div>   
          <ol class="breadcrumb" id="dir">
            <li onclick="muestra(0);"><a ><i class="fa fa-dashboard"></i> Directorio</a></li>
          </ol>
          </div>   

              <div class="box box-info" id="general">
                <div class="box-header with-border">
                  <h3 class="box-title">Directorio</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">

                <tr>
                    <td align="right">
                        Id:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtid" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estatus:</td>
                    <td align="left" >
                        <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                            <asp:ListItem Value="1">Activo</asp:ListItem>
                            <asp:ListItem Value="2">Baja</asp:ListItem>
                        </asp:DropDownList>
                    </td>

                      
                </tr>



                <tr>
                    <td align="right">
                        No Sucursal:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtnsuc" class="form-control" placeholder="Cve Cte" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Sucursal:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtsuc" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Clave Interna:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcvei" class="form-control"  placeholder="Cve Interna" runat="server"></asp:TextBox>
                    </td>

                      
                </tr>
                <tr>
                    <td align="right">
                        Calle y No:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcalle" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Colonia:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcol" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        C.P.:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcp" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Delegacion/Mun:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtdel" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Ciudad:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcd" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estado:</td>
                    <td align="left" >
                        <asp:DropDownList ID="ddlestado"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione…</asp:ListItem>
                            <asp:ListItem Value="1">Aguascalientes</asp:ListItem>
                            <asp:ListItem Value="2">Baja California</asp:ListItem>
                            <asp:ListItem Value="3">Baja California Sur</asp:ListItem>
                            <asp:ListItem Value="4">Campeche</asp:ListItem>
                            <asp:ListItem Value="5">Chiapas</asp:ListItem>
                            <asp:ListItem Value="6">Chihuahua</asp:ListItem>
                            <asp:ListItem Value="7">Coahuila</asp:ListItem>
                            <asp:ListItem Value="8">Colima</asp:ListItem>
                            <asp:ListItem Value="9">Distrito Federal</asp:ListItem>
                            <asp:ListItem Value="10">Durango</asp:ListItem>
                            <asp:ListItem Value="11">Estado de México</asp:ListItem>
                            <asp:ListItem Value="12">Guanajuato</asp:ListItem>
                            <asp:ListItem Value="13">Guerrero</asp:ListItem>
                            <asp:ListItem Value="14">Hidalgo</asp:ListItem>
                            <asp:ListItem Value="15">Jalisco</asp:ListItem>
                            <asp:ListItem Value="16">Michoacán</asp:ListItem>
                            <asp:ListItem Value="17">Morelos</asp:ListItem>
                            <asp:ListItem Value="18">Nayarit</asp:ListItem>
                            <asp:ListItem Value="19">Nuevo León</asp:ListItem>
                            <asp:ListItem Value="20">Oaxaca</asp:ListItem>
                            <asp:ListItem Value="21">Puebla</asp:ListItem>
                            <asp:ListItem Value="22">Querétaro</asp:ListItem>
                            <asp:ListItem Value="23">Quintana Roo</asp:ListItem>
                            <asp:ListItem Value="24">San Luis Potosí</asp:ListItem>
                            <asp:ListItem Value="25">Sinaloa</asp:ListItem>
                            <asp:ListItem Value="26">Sonora</asp:ListItem>
                            <asp:ListItem Value="27">Tabasco</asp:ListItem>
                            <asp:ListItem Value="28">Tamaulipas</asp:ListItem>
                            <asp:ListItem Value="29">Tlaxcala</asp:ListItem>
                            <asp:ListItem Value="30">Veracruz</asp:ListItem>
                            <asp:ListItem Value="31">Yucatán</asp:ListItem>
                            <asp:ListItem Value="32">Zacatecas</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Contacto:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcon" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Mail:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtmail" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align="left" >
                        <asp:TextBox ID="txttel" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align ="left">
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chklim" class="checkbox" runat="server" Text="Limpieza"></asp:CheckBox>
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkmto" class="checkbox" runat="server" Text="Mantenimiento"></asp:CheckBox>
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkjar" class="checkbox" runat="server" Text="Jardineria"></asp:CheckBox>
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkfum" class="checkbox" runat="server" Text="Fumigacion"></asp:CheckBox>
                    </td>
                </tr>
            </table>
    </div><!-- /.box-body -->
    <div class="box-footer">
        <asp:Button ID="Button1" runat="server" Text="Guardar" class="btn btn-info pull-right" />
    </div><!-- /.box-footer -->


        <ol class="breadcrumb">
            <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Directorio</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nueva Sucursal</a></li>
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
