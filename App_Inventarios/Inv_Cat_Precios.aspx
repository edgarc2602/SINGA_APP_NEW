<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Inv_Cat_Precios.aspx.vb" Inherits="Inventarios_App_Inv_Cat_Precios" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Precios por estado</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
<script type="text/javascript">
    function muestra(val) {
        if (val == 1) {
            var e = document.getElementById("ddlfam");
            var strfam = e.options[e.selectedIndex].value;
            if (strfam == '0') {
                alert("Validacion!, Selecione la Familia");
                return false;
            }
        __doPostBack('opcion', val)
        }
        if (val == 2) {
            var e = document.getElementById("ddlfam");
            var strfam = e.options[e.selectedIndex].value;
            if (strfam == '0') {
                alert("Validacion!, Selecione la Familia");
                return false;
            }
        __doPostBack('opcion', val)
        }
        if (val == 3) {
            var e = document.getElementById("ddlfam");
            var strfam = e.options[e.selectedIndex].value;
            if (strfam == '0') {
                alert("Validacion!, Selecione la Familia");
                return false;
            }
            $('#grid').toggle('slide', { direction: 'up' }, 700);
            $('#importar').toggle('slide', { direction: 'down' }, 700);
        }
        if (val == 4) {
            var e = document.getElementById("ddlfam");
            var strfam = e.options[e.selectedIndex].value;
            if (strfam == '0') {
                alert("Validacion!, Selecione la Familia");
                return false;
            }
            e = document.getElementById('cargaarch').value
            if (e == '') {
                alert("Validacion!, Debe de ingresar la ubicacion del archivo que desea importar");
                return false;
            }
            __doPostBack('opcion', val)
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
            <small>Precio por Estad</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Inventarios</a></li>
            <li class="active">Precio por Estado</li>
          </ol>
        </div>  

        <div class="content" >
          <div class="row" id="df">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info" id="fiscal">
                <div class="box-header with-border">
               <div class="box-header with-border">
                    <h3 class="box-title">
                        <small>Seleccione la familia del Inventario para consultar el precio por Estado...                                                           
                        </small>
                    </h3>
                </div><!-- /.box-header -->
 
                    <table class="box-body" id="cliente" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%">
                        <tr>
                            <td align="right">
                                Familia:</td>
                            <td align ="left" colspan="2">
                                <asp:DropDownList ID="ddlfam" class="form-control" runat="server" placeholder="Seleccione...">
                                </asp:DropDownList>
                            </td>
                            <td align="left" colspan="2">
                            </td>
                            <td align="left" >
                            </td>
                        </tr>
                        <tr>

                        </tr>
                    </table>
                </div>
                  <ol class="breadcrumb">
                    <li onclick="return muestra(1);"><a ><i class="fa fa-dashboard"></i> Consultar</a></li>
                    <li onclick="return muestra(2);"><a ><i class="fa fa-dashboard"></i> Exportar</a></li>
                    <li onclick="return muestra(3);"><a ><i class="fa fa-dashboard"></i> Importar</a></li>
                  </ol>
              </div>
            </div>
         </div>


          <div id="grid">
          <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
                <asp:Panel ID="Panel1" runat="server" Height="50%" Width="100%" ScrollBars="Auto" 
                    style="background-color: #F5F5F5" >
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                        Font-Names="tahoma" Font-Size="8px" OnDataBound="OnDataBounda" Width="100%"  >
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Id" SortExpression="Id" />
                        <asp:BoundField DataField="Clave" HeaderText="Clave" SortExpression="Clave" />
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripcion" SortExpression="Descripcion" />
                        <asp:BoundField DataField="UM" HeaderText="UM" SortExpression="UM" />
                        <asp:BoundField DataField="AGUASC" HeaderText="AGUASC" SortExpression="AGUASC" />
                        <asp:BoundField DataField="BCALIF" HeaderText="BCALIF" SortExpression="BCALIF" />
                        <asp:BoundField DataField="BCALIS" HeaderText="BCALIS" SortExpression="BCALIS" />
                        <asp:BoundField DataField="CAMPEC" HeaderText="CAMPEC" SortExpression="CAMPEC" />
                        <asp:BoundField DataField="CHIAPA" HeaderText="CHIAPA" SortExpression="CHIAPA" />
                        <asp:BoundField DataField="CHIHUS" HeaderText="CHIHUS" SortExpression="CHIHUS" />
                        <asp:BoundField DataField="CUAHUI" HeaderText="CUAHUI" SortExpression="CUAHUI" />
                        <asp:BoundField DataField="COLIMA" HeaderText="COLIMA" SortExpression="COLIMA" />
                        <asp:BoundField DataField="CDMX" HeaderText="CDMX" SortExpression="CDMX" />
                        <asp:BoundField DataField="DURANG" HeaderText="DURANG" SortExpression="DURANG" />
                        <asp:BoundField DataField="EDOMEX" HeaderText="EDOMEX" SortExpression="EDOMEX" />
                        <asp:BoundField DataField="GUANAJ" HeaderText="GUANAJ" SortExpression="GUANAJ" />
                        <asp:BoundField DataField="GUERRE" HeaderText="GUERRE" SortExpression="GUERRE" />
                        <asp:BoundField DataField="HIDALG" HeaderText="HIDALG" SortExpression="HIDALG" />
                        <asp:BoundField DataField="JALISC" HeaderText="JALISC" SortExpression="JALISC" />
                        <asp:BoundField DataField="MICHOA" HeaderText="MICHOA" SortExpression="MICHOA" />
                        <asp:BoundField DataField="MORELO" HeaderText="MORELO" SortExpression="MORELO" />
                        <asp:BoundField DataField="NAYARI" HeaderText="NAYARI" SortExpression="NAYARI" />
                        <asp:BoundField DataField="NUELEO" HeaderText="NUELEO" SortExpression="NUELEO" />
                        <asp:BoundField DataField="OAXACA" HeaderText="OAXACA" SortExpression="OAXACA" />
                        <asp:BoundField DataField="PUEBLA" HeaderText="PUEBLA" SortExpression="PUEBLA" />
                        <asp:BoundField DataField="QUERET" HeaderText="QUERET" SortExpression="QUERET" />
                        <asp:BoundField DataField="QUIROO" HeaderText="QUIROO" SortExpression="QUIROO" />
                        <asp:BoundField DataField="SLUIPO" HeaderText="SLUIPO" SortExpression="SLUIPO" />
                        <asp:BoundField DataField="SINALO" HeaderText="SINALO" SortExpression="SINALO" />
                        <asp:BoundField DataField="SONORA" HeaderText="SONORA" SortExpression="SONORA" />
                        <asp:BoundField DataField="TABASC" HeaderText="TABASC" SortExpression="TABASC" />
                        <asp:BoundField DataField="TAMAUL" HeaderText="TAMAUL" SortExpression="TAMAUL" />
                        <asp:BoundField DataField="TLAXCA" HeaderText="TLAXCA" SortExpression="TLAXCA" />
                        <asp:BoundField DataField="VERACR" HeaderText="VERACR" SortExpression="VERACR" />
                        <asp:BoundField DataField="YUCATA" HeaderText="YUCATA" SortExpression="YUCATA" />
                        <asp:BoundField DataField="ZACATE" HeaderText="ZACATE" SortExpression="ZACATE" />
                    </Columns>
                </asp:GridView>
                </asp:Panel>
            </div><!--/.col (right) -->
          </div>   
          </div>   

          <div class="box box-info" id="importar" style="display:none;" >
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <small>Seleccione la ruta donde se encuentra el archivo que decea Importar.
                        </small>
                    </h3>
                </div>
              <div>
                <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%">
                    <tr>
                        <td align ="center" colspan="2">
                        <asp:FileUpload ID="cargaarch" runat="server" class="form-control" Width="80%" />
                        </td>
                        <td align="left" colspan="2">
                        </td>
                        <td align="left" >
                        </td>
                    </tr>
                    <tr>

                    </tr>
                </table>
                  <ol class="breadcrumb">
                    <li onclick="return muestra(4);"><a ><i class="fa fa-dashboard"></i> Continuar con la importacion</a></li>
                  </ol>
              </div> 
          </div> 
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
