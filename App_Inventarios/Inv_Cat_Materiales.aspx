<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Inv_Cat_Materiales.aspx.vb" Inherits="Inventarios_App_Inv_Cat_Materiales" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Materiales</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <script type="text/javascript" src="../Content/js/jquery.min.js"></script>
    <script type="text/javascript" src="../Content/js/Quicksearch.js"></script>


    <script type="text/javascript">
        $(function () {
            $('.search_textbox').each(function (i) {
                $(this).quicksearch("[id*=GridView1] tr:not(:has(th))", {
                    'testQuery': function (query, txt, row) {
                        return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;
                    }
                });
            });
        });
    </script>

<script type="text/javascript">
    function muestra() {
        $('#grid').toggle('slide', { direction: 'up' }, 700);
        $('#captura').toggle('slide', { direction: 'down' }, 700);

    }
    function limpia() {
        document.getElementById('txtcve').value = "";
        document.getElementById('txtmat').value = "";
        var combo = document.getElementById("ddlfam");
        combo[0].selected = true;
        var combo = document.getElementById("ddlstatus");
        combo[0].selected = true;
        var combo = document.getElementById("ddlum");
        combo[0].selected = true;
        __doPostBack('limpia', '0')

    }
    function valida() {

        var cve = document.getElementById('txtcve').value
        var mat = document.getElementById('txtmat').value
        var e = document.getElementById("ddlfam");
        var strfam = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlum");
        var strum = e.options[e.selectedIndex].text;
        e = document.getElementById("ddlstatus");
        var strstatus = e.options[e.selectedIndex].text;
        if (cve == '') {
            alert("Validacion!, Capture la Clave");
            return false;
        }
        if (mat== '') {
            alert("Validacion!, Capture el Material");
            return false;
        }
        if (strfam == '0') {
            alert("Validacion!, Selecione la Familia");
            return false;
        }
        if (strum == '0') {
            alert("Validacion!, Selecione la Unidad de Medida");
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
            <small>Materiales</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Inventarios</a></li>
            <li class="active">Materiales</li>
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
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" OnDataBound="OnDataBounda" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="IdPieza,Pza_Status" >
                    <Columns>
                        <asp:BoundField DataField="Pza_IdFamilia" HeaderText="Familia" SortExpression="Pza_IdFamilia" />
                        <asp:BoundField DataField="Pza_Clave" HeaderText="Codigo" SortExpression="Pza_Clave" />
                        <asp:BoundField DataField="Pza_DescPieza" HeaderText="Material" SortExpression="Pza_DescPieza" />
                        <asp:BoundField DataField="Pza_IdUnidad" HeaderText="Unidad de Medida" 
                            SortExpression="Pza_IdUnidad" />
                        <asp:BoundField DataField="Estatus" HeaderText="Estatus" 
                            SortExpression="Estatus" />
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
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Materiales</a></li>
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
                      <label for="inputPassword3" class="col-sm-2 control-label">Estatus:</label>
                      <div class="col-sm-10">
                        <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                            <asp:ListItem Value="0">Activo</asp:ListItem>
                            <asp:ListItem Value="1">Baja</asp:ListItem>
                        </asp:DropDownList>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputEmail3" class="col-sm-2 control-label">Familia:</label><asp:Label ID="lblid" runat="server" Text="0" style=" display:none;"></asp:Label>
                      <div class="col-sm-10">
                            <asp:DropDownList ID="ddlfam" class="form-control" runat="server" placeholder="Seleccione...">
                            </asp:DropDownList>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Clave:</label>
                      <div class="col-sm-10">
                            <asp:TextBox ID="txtcve" class="form-control" placeholder="###-###-###" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Material:</label>
                      <div class="col-sm-10">
                            <asp:TextBox ID="txtmat" class="form-control" placeholder="Ingrese el material" runat="server"></asp:TextBox>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="inputPassword3" class="col-sm-2 control-label">Unidad Medida:</label>
                      <div class="col-sm-10">
                            <asp:DropDownList ID="ddlum" class="form-control" runat="server" placeholder="Seleccione...">
                            </asp:DropDownList>
                      </div>
                    </div>
                </div>
                  <div class="box-footer">
                      <asp:Button ID="Button1" runat="server" Text="Guardar" 
                          class="btn btn-info pull-right" onclientclick="return valida();" />
                  </div><!-- /.box-footer -->
          <ol class="breadcrumb">
            <li onclick="muestra();"><a ><i class="fa fa-dashboard"></i> Listado de Materiales</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Material</a></li>
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

    </div >

    </form>
</body>
</html>
