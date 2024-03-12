<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ven_Prospecto.aspx.vb" Inherits="Ventas_App_Ven_Prospecto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title></title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

<script type="text/javascript">
    function muestra() {
        $('#grid').toggle('slide', { direction: 'up' }, 700);
        $('#captura').toggle('slide', { direction: 'down' }, 700);
        //__doPostBack('Carga', dato)

    }
    function limpia() {
        document.getElementById('lblid').innerHTML = "0";
        document.getElementById('txtrs').value = "";
        document.getElementById('txtcontacto').value = "";
        document.getElementById('txttel').value = "";
        document.getElementById('txtcel').value = "";
        document.getElementById('txtmail').value = "";

        var combo = document.getElementById("ddlejecutivo");
        combo[0].selected = true;
        var combo = document.getElementById("ddlstatus");
        combo[0].selected = true;
        __doPostBack('limpia', '0')

    }
    function valida() {
        var e = document.getElementById("ddlejecutivo");
        var strejec = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlstatus");
        var strstatus = e.options[e.selectedIndex].text;

        dato = document.getElementById('txtrs').value + '#' + document.getElementById('txtcontacto').value + '#' + document.getElementById('txttel').value + '#' + document.getElementById('txtcel').value + '#' + document.getElementById('txtmail').value + '#' + strejec + '#' + strstatus + '#' + document.getElementById('lblid').innerHTML 
        __doPostBack('guarda', dato)
    }
    function conviertecliente() {
        dato = document.getElementById('lblid').innerHTML
        datoc = document.getElementById('lblidc').innerHTML
        if (datoc != 0) {
            alert('Este Prospecto ya ha sido convertido a Cliente')
            return false;
        }
        if (dato == 0) { 
        alert('Debe de guardar el prospecto antes de convertirlo en cliente')
        }
    if (dato != 0 ) {
        window.location = 'Ven_Cat_Cliente.aspx?idp=' + dato
    }


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
      |
      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
              Prospectos
            <small>Consulta</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li class="active">Prospecto</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content" >
                <div id="grid" style=" display:none;" >
          <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="Id_Prospecto,Pros_Estatus,Pros_Ejecutivo" >
                    <Columns>
                        <asp:BoundField DataField="Contacto" HeaderText="RFC" SortExpression="Contacto" />
                        <asp:BoundField DataField="Razon_Social" HeaderText="Razon Social" 
                            SortExpression="Razon_Social" />
                        <asp:BoundField DataField="EStatus" HeaderText="Estatus" 
                            SortExpression="EStatus" />
                        <asp:BoundField DataField="Ejecutivo" HeaderText="Ejecutivo" 
                            SortExpression="Ejecutivo" />
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
          <ol class="breadcrumb">
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Prospecto</a></li>
          </ol>
          </div>   


          <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Requeridos</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                  <div class="box-body">
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-2 control-label">Razon Social</label>
                      <asp:Label ID="lblid" runat="server" Text="0" style=" display:none;"></asp:Label>
                      <asp:Label ID="lblidc" runat="server" Text="0" style=" display:none;"></asp:Label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txtrs" class="form-control" placeholder="Batia S.A. de C.V." runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Contacto</label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txtcontacto" class="form-control" placeholder="Juan Perez" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Telefono</label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txttel" class="form-control" placeholder="(55)50-00-00-00" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Celular</label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txtcel" class="form-control" placeholder="(044-55) 00-00-00-00" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Email</label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txtmail" class="form-control" placeholder="info@batia.com.mx" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Ejecutivo</label>
                      <div class="col-sm-10">
                        <asp:DropDownList ID="ddlejecutivo" class="form-control" runat="server" placeholder="Barbara Villafan">
                        </asp:DropDownList>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Estatus</label>
                      <div class="col-sm-10">
                        <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                        </asp:DropDownList>
                      </div>
                    </div>


                    </div>
                    <div class="form-group">
                    </div>
                  </div><!-- /.box-body -->
                  <div class="box-footer">
                      <asp:Button ID="Button1" runat="server" Text="Guardar" class="btn btn-info pull-right" />
                  </div><!-- /.box-footer -->
          <ol class="breadcrumb">
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Listado de Prospectos</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Prospecto</a></li>
            <li onclick="conviertecliente();"><a ><i class="fa fa-cube"></i> Convertir Cliente</a></li>
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
          <!-- Stats tab content -->
          <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div><!-- /.tab-pane -->
          <!-- Settings tab content -->
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
    

        <!-- Bootstrap 3.3.2 JS -->
    <script src="../Content/form/js/bootstrap.min.js" type="text/javascript"></script>
    <!-- Morris.js charts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js" type="text/javascript"></script>
    <script src="../Content/form/js/morris.min.js" type="text/javascript"></script>
    <!-- Sparkline -->
    <script src="../Content/form/js/jquery.sparkline.min.js" type="text/javascript"></script>
    <!-- jvectormap -->
    <script src="../Content/form/js/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>
    <!-- jQuery Knob Chart -->
    <script src="../Content/form/js/jquery.knob.js" type="text/javascript"></script>
    <!-- daterangepicker -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.2/moment.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/daterangepicker.js" type="text/javascript"></script>
    <!-- datepicker -->
    <script src="../Content/form/js/bootstrap-datepicker.js" type="text/javascript"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="../Content/form/js/bootstrap3-wysihtml5.all.min.js" type="text/javascript"></script>
    <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>

      </form>

  </body>
</html>
