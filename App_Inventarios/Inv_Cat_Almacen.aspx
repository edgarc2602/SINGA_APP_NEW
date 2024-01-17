<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Inv_Cat_Almacen.aspx.vb" Inherits="Inventarios_App_Inv_Cat_Almacen" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Almacen</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
<script type="text/javascript">
    function muestra() {
        $('#grid').toggle('slide', { direction: 'up' }, 700);
        $('#captura').toggle('slide', { direction: 'down' }, 700);

    }
    function limpia() {
        document.getElementById('txtcve').value = "";
        document.getElementById('txtalmacen').value = "";
        document.getElementById('txtdireccion').value = "";

        var combo = document.getElementById("ddlestado");
        combo[0].selected = true;
        var combo = document.getElementById("ddlstatus");
        combo[0].selected = true;
        var combo = document.getElementById("ddlinv");
        combo[0].selected = true;
        __doPostBack('limpia', '0')

    }
    function valida() {
        var cve = document.getElementById('txtcve').value
        var almacen = document.getElementById('txtalmacen').value
        var dir = document.getElementById('txtdireccion').value
        var e = document.getElementById("ddlestado");
        var stredo = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlinv");
        var strinv = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlstatus");
        var strstatus = e.options[e.selectedIndex].text;
        if (cve == '') {
            alert("Validacion!, Capture la Clave");
                return false;
        }
        if (almacen == '') {
            alert("Validacion!, Capture el Almacen");
            return false;
        }
        if (dir == '') {
            alert("Validacion!, Capture la direccion");
            return false;
        }
        if (stredo == '0') {
            alert("Validacion!, Capture el estado");
            return false;
        }
    }
</script>

    
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
    <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

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
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
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
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <div class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <div class="sidebar">
          <!-- sidebar menu: : style can be found in sidebar.less -->
                     <%= labelmenu%>
         </div>
        <!-- /.sidebar -->
      </div>

    <div class="content-wrapper">
        <div class="content-header">
          <h1>
              Inventarios
            <small>Almacen</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Inventarios</a></li>
            <li class="active">Almacen</li>
          </ol>
        </div>  

        <div class="content" >
          <div id="grid" style=" display:none;" >
          <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="IdAlmacen, IdEstado,Alm_status,Alm_inventario" >
                    <Columns>
                        <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado" />
                        <asp:BoundField DataField="Alm_Clave" HeaderText="Clave" SortExpression="Alm_Clave" />
                        <asp:BoundField DataField="Alm_Nombre" HeaderText="Almacen" 
                            SortExpression="Alm_Nombre" />
                        <asp:BoundField DataField="Alm_direccion" HeaderText="Direccion" 
                            SortExpression="Alm_direccion" />
                        <asp:BoundField DataField="Estatus" HeaderText="Estatus" 
                            SortExpression="Estatus" />
                        <asp:BoundField DataField="Alm_inventario" HeaderText="Inventario" 
                            SortExpression="Alm_inventario" />
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
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Almacen</a></li>
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
                      <label for="inputEmail3" class="col-sm-2 control-label">Clave:</label><asp:Label ID="lblid" runat="server" Text="0" style=" display:none;"></asp:Label>
                      <div class="col-sm-10">
                        <asp:TextBox ID="txtcve" class="form-control" placeholder="###-XXXXXXX" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Almacen:</label>
                      <div class="col-sm-10">
                            <asp:TextBox ID="txtalmacen" class="form-control" placeholder="Almacen General Batia" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Direccion:</label>
                      <div class="col-sm-10">
                            <asp:TextBox ID="txtdireccion" class="form-control" placeholder="Calle No. Int No.Ext Colonia C.P. Del/Municipio Ciudad" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Estado:</label>
                      <div class="col-sm-10">
                            <asp:DropDownList ID="ddlestado" class="form-control" runat="server" placeholder="Seleccione...">
                            </asp:DropDownList>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Inventario</label>
                      <div class="col-sm-10">
                        <asp:DropDownList ID="ddlinv" class="form-control" runat="server" 
                              Enabled="False" >
                            <asp:ListItem Value="0">Libre</asp:ListItem>
                            <asp:ListItem Value="1">En Inventario</asp:ListItem>
                        </asp:DropDownList>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Estatus</label>
                      <div class="col-sm-10">
                        <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                            <asp:ListItem Value="0">Activo</asp:ListItem>
                            <asp:ListItem Value="1">Baja</asp:ListItem>
                        </asp:DropDownList>
                      </div>
                    </div>


                    </div>
                    <div class="form-group">
                    </div>
                  </div><!-- /.box-body -->
                  <div class="box-footer">
                      <asp:Button ID="Button1" runat="server" Text="Guardar" 
                          class="btn btn-info pull-right" onclientclick="return valida();" />
                  </div><!-- /.box-footer -->
          <ol class="breadcrumb">
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Listado de Almacenes</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Almacen</a></li>
          </ol>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->

    </div>
    </div>
      <footer class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </footer>
      <div class="control-sidebar control-sidebar-dark">
      </div>

    <!-- jQuery 2.1.4 -->
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script type="text/javascript">
        $.widget.bridge('uibutton', $.ui.button);
        function test_onclick() 
        }

    </script>


    <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>


    </form>
</body>
</html>
