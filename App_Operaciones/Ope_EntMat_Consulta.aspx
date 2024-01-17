<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_EntMat_Consulta.aspx.vb" Inherits="App_Operaciones_Ope_EntMat_Consulta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Consulta Surtido de Materiales</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <script type="text/javascript" src="../Content/js/jquery.min.js"></script>
    <script type = "text/javascript">
        function muestra(val) {
                __doPostBack('opcion', val)
        }

    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
    <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods = "true"></asp:ScriptManager>
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
              Consulta Listado Materiales
            <small>Operaciones</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Operaciones</a></li>
            <li class="active">Consulta Listado Materiales</li>
          </ol>
        </div>  

        <div class="content" >
          <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Filtros</h3>
                </div><!-- /.box-header -->

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
 
                    <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" id="filtros" >
                        <tr>
                            <td align="center">
                                Anio:</td>
                            <td align="center">
                                Mes:</td>
                            <td align="center">
                                Cliente:</td>
                            <td align="center">
                                Supervisor:</td>
                            <td align="center">
                                Sucursal:</td>
                            <td align="center">
                                Folio:</td>
                        </tr>
                        <tr>
                            <td align ="left" >
                                <asp:TextBox ID="txtAnio" class="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td align ="left" >
                                <asp:DropDownList ID="ddlmes" class="form-control" runat="server" 
                                    placeholder="Activo">
                                    <asp:ListItem Value="1">Enero</asp:ListItem>
                                    <asp:ListItem Value="2">Febrero</asp:ListItem>
                                    <asp:ListItem Value="3">Marzo</asp:ListItem>
                                    <asp:ListItem Value="4">Abril</asp:ListItem>
                                    <asp:ListItem Value="5">Mayo</asp:ListItem>
                                    <asp:ListItem Value="6">Junio</asp:ListItem>
                                    <asp:ListItem Value="7">Julio</asp:ListItem>
                                    <asp:ListItem Value="8">Agosto</asp:ListItem>
                                    <asp:ListItem Value="9">Septiembre</asp:ListItem>
                                    <asp:ListItem Value="10">Octubre</asp:ListItem>
                                    <asp:ListItem Value="11">Noviembre</asp:ListItem>
                                    <asp:ListItem Value="12">Diciembre</asp:ListItem>
                                </asp:DropDownList>                            
                            </td>
                            <td align ="left">
                                <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" AutoPostBack="True"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                    CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrs"  >
                                </ajaxToolkit:AutoCompleteExtender>
                                        <asp:Label ID="lblidcliente"  runat="server" style="display:none"></asp:Label>
                            </td>
                            <td align ="left">
                                <asp:DropDownList ID="ddlsupervisor" class="form-control" runat="server" 
                                    placeholder="Activo" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td align ="left">
                                <asp:DropDownList ID="dllsucursal" class="form-control" runat="server" 
                                    placeholder="Activo" AutoPostBack="True">
                                </asp:DropDownList>                            
                            </td>
                            <td align ="left">
                                <asp:TextBox ID="txtfolio" class="form-control" runat="server" 
                                    ForeColor="#006699"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align ="center" colspan="3">
                                    <asp:CheckBox ID="CheckBox1" runat="server"  
                                Text="Selecciona Todos los Listados" AutoPostBack="True" />                            </td>                            
                            <td align ="center" colspan="3">
                                <asp:Button ID="btnmat" runat="server" Text="Mostrar Resultados" class="btn btn-info pull-right" OnClientClick="return agrega(2);"></asp:Button>
                            </td>                            
                        </tr>
                    </table>
                <div id="autoriza">
                  <ol class="breadcrumb">
                    <li onclick="muestra(1);"><a ><i class="fa fa-dashboard"></i> Autorizar </a></li>
                    <li onclick="muestra(2);"><a ><i class="fa fa-dashboard"></i> Liberar </a></li>
                    <li onclick="muestra(3);"><a ><i class="fa fa-dashboard"></i> Cancelar </a></li>
                    <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Exportar </a></li>
                  </ol>
                </div>
                <small>
                    <asp:Panel ID="Panel1" runat="server" Width="100%" ScrollBars="Auto">
                <asp:GridView ID="gwm" runat="server" 
                      DataKeyNames="Id_Sucursal,IdPersonal,IdEstatus,IdSurtido" EmptyDataText="Sin Materiales Cargados" 
                      AutoGenerateColumns="False" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="" HeaderText="Sel..." />
                        <asp:BoundField DataField="estatus" HeaderText="Estatus" SortExpression="estatus" />
                        <asp:BoundField DataField="Cte_Fis_Nombre_Comercial" HeaderText="Cliente " SortExpression="Cte_Fis_Nombre_Comercial" />
                        <asp:BoundField DataField="Cte_Dir_Ciudad" HeaderText="Ciudad" SortExpression="Cte_Dir_Ciudad" />
                        <asp:BoundField DataField="Cte_Dir_Sucursal" HeaderText="Sucursal" SortExpression="Cte_Dir_Sucursal" />
                        <asp:BoundField DataField="mes" HeaderText="Pedido" SortExpression="mes" />
                        <asp:BoundField DataField="IdSurtido" HeaderText="Folio" SortExpression="IdSurtido" />
                        <asp:BoundField DataField="Ent_Mat_Presupuesto" HeaderText="$ Presupuesto" SortExpression="Ent_Mat_Presupuesto" />
                        <asp:BoundField DataField="Ent_Mat_ImporteLib" HeaderText="$ Liberado" SortExpression="Ent_Mat_ImporteLib" />
                        <asp:BoundField DataField="Ent_Mat_Acumulado" HeaderText="$ Utilizado" SortExpression="Ent_Mat_Acumulado" />
                        <asp:CommandField ButtonType="Button" SelectText="Det" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                    </asp:Panel>
                   </small>


                        </ContentTemplate>
                    </asp:UpdatePanel>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>


          <div class="row"  id="Sucursales">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div>
                </div>              







              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->

                        </ContentTemplate>
                        <Triggers>
                        </Triggers>
                    </asp:UpdatePanel>


    </div>



    </div>
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>
      <div class="control-sidebar control-sidebar-dark">
      </div>

    <!-- jQuery 2.1.4 -->
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
        <%--    <script type="text/javascript">
        $.widget.bridge('uibutton', $.ui.button);
    </script>
--%>

    <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>






    </div>
    </form>
</body>
</html>
