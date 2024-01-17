<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Adm_Usuario.aspx.vb" Inherits="App_Admin_Adm_Usuario" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Control de usuario</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                setTimeout(function () {
                    $("#menu").click();
                }, 50);
            }); function continuar(val) {
                if (val == 0) {
                    window.location.replace("Adm_Usuario.aspx");
                }
                if (val == 1) {
                    if (document.getElementById('txtap').value == "") {
                        alert('Debe capturar el Apellido Paterno del Usuario')
                        return false;
                    }
                    //if (document.getElementById('txtam').value == "") {
                    //    alert('Debe capturar el Apellido Materno del Usuario')
                    //    return false;
                    //}
                    if (document.getElementById('txtnom').value == "") {
                        alert('Debe capturar el Nombre del Usuario')
                        return false;
                    }
                    if (document.getElementById('ddlarea').value == "0") {
                        alert('Debe seleccionar el area')
                        return false;
                    }
                    if (document.getElementById('ddlpuesto').value == "0") {
                        alert('Debe seleccionar el puesto')
                        return false;
                    }
                    if (document.getElementById('txtusuario').value == "") {
                        alert('Debe de capturar el usuario, verifique')
                        return false;
                    }
                    if (document.getElementById('txtpass').value == "") {
                        alert('Debe de capturar la contraseña, verifique')
                        return false;
                    }
                    if (document.getElementById('txtpass').value != document.getElementById('txtpasscon').value) {
                        alert('La contraseña no coincide, verifique')
                        return false;
                    }
                    __doPostBack('guarda', val);
                }
                if (val == 2) {
                    if (document.getElementById('txtid').value == "") {
                        alert('No hay ningun perfil a eliminar')
                        return false;
                        __doPostBack('elimina', val);
                    }
                }
                if (val == 3) {
                    $('#datos').hide();
                    $('#grid').toggle('slide', { direction: 'down' }, 700);
                }
                if (val == 4) {
                    $('#grid').hide();
                    $('#datos').show();
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
        <nav class="navbar navbar-static-top" role="navigation">
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
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </div>
      <!-- Left side column. contains the logo and sidebar -->
      <div class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <div class="sidebar">
          <!-- sidebar menu: : style can be found in sidebar.less -->
            <%= labelmenu%>
        </div>
        <!-- /.sidebar -->
      </div>

      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
          <h1>
              Accesos
            <small>Ctrl Usuario</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Administracion</a></li>
            <li class="active">Ctrl Usuario</li>
          </ol>
        </div>

        <!-- Main content -->
        <div class="content" >
          <div id="datos">
          <div class="row" >
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info" id="fiscal">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Usuario</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
                <table class="box-body" id="generales" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        ID:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtid" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estatus:</td>
                    <td align ="left" >
                        <asp:DropDownList ID="ddlestatus"  runat="server" CssClass="form-control" >
                            <asp:ListItem Value="0">Activo</asp:ListItem>
                            <asp:ListItem Value="1">Suspendido</asp:ListItem>
                            <asp:ListItem Value="2">Baja</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Apellido Paterno:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtap" class="form-control" placeholder="Apellido Paterno" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Apellido Materno:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtam" class="form-control" placeholder="Apellido Materno" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Nombre(s):</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtnom" class="form-control" placeholder="Nombre(s)" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Email:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtemail" class="form-control" placeholder="correousuario@dominio.mx" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="center" >
                       Tipo Usuario </td>
                    <td align="center" >
                        Usuarios:</td>
                    <td align="center" >
                        Contraseña:</td>
                    <td align="center" >
                        Confirma Contraseña:</td>
                </tr>
                <tr>
                    <td align ="left" >
                        <asp:DropDownList ID="ddltipo"  runat="server" CssClass="form-control" >
                            <asp:ListItem Value="0">Interno</asp:ListItem>
                            <asp:ListItem Value="1">Externo</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td align ="left" >
                        <asp:TextBox ID="txtusuario" class="form-control" placeholder="" runat="server"></asp:TextBox>
                    </td>
                    <td align ="left">
                        <asp:TextBox ID="txtpass" class="form-control" placeholder="" runat="server" 
                            TextMode="Password"></asp:TextBox>
                    </td>
                    <td align ="left">
                        <asp:TextBox ID="txtpasscon" class="form-control" placeholder="" runat="server" 
                            TextMode="Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Area:</td>
                    <td align ="left" colspan="3">
                        <asp:DropDownList ID="ddlarea"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Puesto:</td>
                    <td align ="left" colspan="3">
                        <asp:DropDownList ID="ddlpuesto"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right" >
                        Grupo de Acceso:</td>
                    <td align ="left" colspan="3">
                        <asp:DropDownList ID="ddlgrupo"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Privilegios:</td>
                    <td>
                    </td>
                    <td colspan="2">
                        <asp:CheckBox ID="chkelabora" class="checkbox" runat="server" Text="Elaborar"></asp:CheckBox>
                        <asp:CheckBox ID="chkrevisa" class="checkbox" runat="server" Text="Revisar"></asp:CheckBox>
                        <asp:CheckBox ID="chkautoriza" class="checkbox" runat="server" Text="Autorizar"></asp:CheckBox>
                    </td>
                </tr>
              </table>
                <ol class="breadcrumb">
                    <li onclick="return continuar(0);"><a ><i class="fa fa-dashboard"></i> Nuevo</a></li>
                    <li onclick="return continuar(1);"><a ><i class="fa fa-dashboard"></i> Guardar</a></li>
                    <li onclick="return continuar(2);"><a ><i class="fa fa-dashboard"></i> Dar de Baja</a></li>
                    <li onclick="return continuar(3);"><a ><i class="fa fa-dashboard"></i> ir a Lista de Usuarios</a></li>
                </ol>

    </div><!-- /.box-body -->

            </div><!-- /.box -->
          </div>
          </div>
          <div id="grid" style=" display:none;" >
            <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="IdPersonal" >
                    <Columns>
                        <asp:BoundField DataField="Personal" HeaderText="Personal" 
                            SortExpression="Personal" />
                        <asp:BoundField DataField="Per_Puesto" HeaderText="Puesto" 
                            SortExpression="Per_Puesto" />
                        <asp:BoundField DataField="per_usuario" HeaderText="Usuario" 
                            SortExpression="per_usuario" />
                        <asp:BoundField DataField="Fecha_Alta" HeaderText="Fecha_Alta"   SortExpression="Fecha_Alta" />
                        <asp:BoundField DataField="estatus" HeaderText="Estatus"   SortExpression="estatus" />
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
          <ol class="breadcrumb" id="cte">
            <li onclick="continuar(0);"><a ><i class="fa fa-dashboard"></i> Nuevo</a></li>
          </ol>
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
