<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Adm_Perfiles.aspx.vb" Inherits="App_Admin_Adm_Perfiles" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Perfil de usuario</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
    <script type="text/javascript">
        function continuar(val) {
            if (val == 0) {
                window.location.replace("Adm_Perfiles.aspx");
            }
            if (val == 1) {
                if (document.getElementById('txtnombre').value == "") {
                    alert('Tiene que capturar el nombre del Perfil')
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
            <small>Perfil de usuario</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Administracion</a></li>
            <li class="active">Perfil de usuario</li>
          </ol>
        </div>

        <!-- Main content -->
        <div class="content" >
          <div class="row" id="df">
            <div class="col-md-11">
              <div class="box box-info" id="paso1">
                <div class="box-header with-border">
                </div><!-- /.box-header -->
                <asp:UpdatePanel ID="UpdatePanel8" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                        <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:90%; height:80%">
                            <tr>
                                <td align="right">
                                    Nombre del Perfil:
                                </td>
                                <td align="right">
                                    Seleccione el Area:
                                </td>
                                <td align="right">
                                    Areas Agregadas:
                                </td>
                                <td align="right">
                                    Id del Perfil:
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtnombre" class="form-control"  runat="server" ></asp:TextBox>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlarea"  runat="server" CssClass="form-control" 
                                        AutoPostBack="True">
                                        <asp:ListItem Value="0">Seleccione</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlareaagregada"  runat="server" CssClass="form-control" 
                                        AutoPostBack="True">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtid" class="form-control"  runat="server" Enabled="False"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Perfiles Existentes:
                                </td>
                                <td align="right">
                                    Seleccione la opcion para Agregar:
                                </td>
                                <td align="right">
                                   Formularios Agregados:
                                </td>
                                <td align="right">
                                    Estructura del Perfil:
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:ListBox ID="ListBox1" runat="server" 
                                        Style="font-size: 10pt; left: 44px; font-family: tahoma;
                                        top: 136px; font-weight: bold; color: cadetblue; font-style: italic; font-variant: small-caps; text-decoration: underline overline; border-right: navy thin double; border-top: navy thin double; z-index: 1; border-left: navy thin double; border-bottom: navy thin double; " 
                                        AutoPostBack="True" Height="300px" Width="171px"></asp:ListBox>
                                </td>
                                <td>
                                    <asp:Panel ID="Panel1" runat="server" Height="300" Style="border-right: #08407a thin solid;
                                        border-top: #08407a thin solid; z-index: 1; left: 249px; border-left: #08407a thin solid;
                                        border-bottom: #08407a thin solid; top: 130px; background-color: white"
                                       ScrollBars="Vertical">
                                        <asp:GridView ID="gwagrega" runat="server" CellPadding="4" DataKeyNames="Forma,padre,grupo"
                                            ForeColor="#333333" GridLines="None" Height="96px" Style="font-size: 8pt; left: 0px;
                                            font-family: tahoma; top: -6px" Width="224px" AutoGenerateColumns="False" >
                                            <RowStyle BackColor="#E3EAEB" />
                                            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                                            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle BackColor="#1C5E55" CssClass="ms-formlabel DataGridFixedHeader" Font-Bold="True"
                                                ForeColor="White" />
                                            <EditRowStyle BackColor="#7C6F57" />
                                            <AlternatingRowStyle BackColor="White" />
                                            <Columns>
                                                <asp:BoundField DataField="ar_nombre" HeaderText="Area" />
                                                <asp:BoundField DataField="Label" HeaderText="Forma" />
                                                <asp:CommandField ButtonType="Button" HeaderText="Agregar" SelectText="&gt;" ShowSelectButton="True">
                                                    <ControlStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                </asp:CommandField>
                                            </Columns>
                                        </asp:GridView>
                                    </asp:Panel>                            
                                </td>
                                <td>
                                    <asp:Panel ID="Panel4" runat="server" Height="300px" Style="border-right: #08407a thin solid;
                                        border-top: #08407a thin solid; z-index: 1; left: 544px; border-left: #08407a thin solid;
                                        border-bottom: #08407a thin solid; top: 128px; background-color: white"
                                         ScrollBars="Vertical">
                                        <asp:GridView ID="gvagregado" runat="server" CellPadding="4" DataKeyNames="Forma,conse"
                                            ForeColor="#333333" GridLines="None" Height="96px" Style="font-size: 8pt; left: 0px;
                                            font-family: tahoma; top: -6px" Width="224px" AutoGenerateColumns="False" >
                                            <RowStyle BackColor="#E3EAEB" />
                                            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                                            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle BackColor="#1C5E55" CssClass="ms-formlabel DataGridFixedHeader" Font-Bold="True"
                                                ForeColor="White" />
                                            <EditRowStyle BackColor="#7C6F57" />
                                            <AlternatingRowStyle BackColor="White" />
                                            <Columns>
                                                <asp:CommandField ButtonType="Button" HeaderText="Quitar" SelectText="&lt;" ShowSelectButton="True">
                                                    <ControlStyle Font-Names="Tahoma" Font-Size="8pt" />
                                                </asp:CommandField>
                                                <asp:BoundField DataField="ar_nombre" HeaderText="Area" />
                                                <asp:BoundField DataField="Label" HeaderText="Forma" />
                                            </Columns>
                                        </asp:GridView>
                                    </asp:Panel>                        
                                </td>
                                <td>
                                    <asp:TreeView ID="tvestructura" runat="server" ImageSet="Arrows" Style="border-top-width: thin;
                                        border-left-width: thin; border-left-color: whitesmoke; left: 8px; border-bottom-width: thin;
                                        border-bottom-color: whitesmoke; border-top-color: whitesmoke; top: 87px; border-right-width: thin;
                                        border-right-color: whitesmoke">
                                        <ParentNodeStyle BorderColor="#400000" Font-Bold="False" />
                                        <HoverNodeStyle Font-Underline="True" ForeColor="#400000" />
                                        <SelectedNodeStyle BackColor="#400000" BorderColor="#400000" Font-Underline="True"
                                            ForeColor="White" HorizontalPadding="0px" VerticalPadding="0px" />
                                        <NodeStyle Font-Names="Verdana" Font-Size="8pt" ForeColor="#400000" HorizontalPadding="5px"
                                            NodeSpacing="0px" VerticalPadding="0px" />
                                    </asp:TreeView>
                        
                                </td>
                            </tr>

                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <div class="box-header with-border">
                    <ol class="breadcrumb">
                        <li onclick="return continuar(0);"><a ><i class="fa fa-dashboard"></i> Nuevo</a></li>
                        <li onclick="return continuar(1);"><a ><i class="fa fa-dashboard"></i> Guardar</a></li>
                        <li onclick="return continuar(2);"><a ><i class="fa fa-dashboard"></i> Dar de Baja</a></li>
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
