<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_EntregaMat.aspx.vb" Inherits="App_Operaciones_Ope_EntregaMat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Captura Surtido de Materiales</title>
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
        function mensaje(val) {
            if (val == 1) {
                    alert('Ha superado el presupuesto verifique con el gerente de Compras.');
                    return false;
                }
                if (val == 2) {
                    alert('Se ha agregado correctamente el Listado de materiales');                
                }
        }
        function agrega(val) {
            if (val == 2) {
                estatus = document.getElementById('lblestatus').value
                cve = document.getElementById('txtcve').value
                cant = document.getElementById('txtcantidadmat').value
                if (estatus != 'Alta'){
                    alert('Solo se puede hacer modificaciones al listado con estatus de Alta.');
                    return false;
                }
                if (cve == '') {
                    alert('La Clave del articulo es un dato necesario.');
                    return false;
                }
                if (cant == '') {
                    alert('La Cantidad es un dato necesario.');
                    return false;
                }
            }
        }
        function separa(val) {
            if (val == 2) {
                cve = document.getElementById('txtclavemat').value
                var res = cve.split("|");
                document.getElementById('txtcve').value = res[0]
                document.getElementById('txtdescmat').value = res[1]
                document.getElementById('txtcostomat').value = res[2]
                document.getElementById('txtunidad').value = res[3]
                document.getElementById('txtclavemat').value = ""
                document.getElementById('txtidmat').value = res[4]
            }
        }


        function completadatos(val) {
            if (val == 0) {
                __doPostBack('completadatos', val)
            }
        }
        function muestra(val) {
            if (val == 1) {
                __doPostBack('opcion', val)
            }
            if (val == 2) {
                estatus = document.getElementById('lblestatus').value
                if (estatus != 'Alta') {
                    alert('Solo se puede hacer modificaciones al listado con estatus de Alta.');
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
              Entrega de Materiales
            <small>Operaciones</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Operaciones</a></li>
            <li class="active">Entrega de Materiales</li>
          </ol>
        </div>  

        <div class="content" >
          <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Capture los datos solicitados</h3>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="Label1"  runat="server" Text="ESTATUS:"></asp:Label>
                    <asp:TextBox ID="lblestatus" runat="server" Enabled="False"></asp:TextBox>
                </div><!-- /.box-header -->
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
 
                    <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" id="filtros" >
                        <tr>
                            <td align="right">
                                Cliente:</td>
                            <td align ="left" colspan="2">
                                <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" AutoPostBack="True"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                    CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrs"  >
                                </ajaxToolkit:AutoCompleteExtender>
                                        <asp:Label ID="lblidcliente"  runat="server" style="display:none"></asp:Label>
                            </td>
                            <td align="right">
                                Supervisor:</td>
                            <td align ="left" colspan="3">
                                <asp:DropDownList ID="ddlsupervisor" class="form-control" runat="server" 
                                    placeholder="Activo" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Sucursal:</td>
                            <td align ="left" colspan="2">
                                <asp:DropDownList ID="dllsucursal" class="form-control" runat="server" 
                                    placeholder="Activo" AutoPostBack="True">
                                </asp:DropDownList>                            
                            </td>
                            <td align="right">
                                Ciudad:</td>
                            <td align ="left" >
                                <asp:TextBox ID="txtcd" class="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td align="right">
                                Presupuesto:</td>
                            <td align ="left">
                                <asp:TextBox ID="txtpres" class="form-control" runat="server" Enabled="False"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Mes:</td>
                            <td align ="left" colspan="2">
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
                            <td align="right">
                                Anio:</td>
                            <td align ="left" >
                                <asp:TextBox ID="txtAnio" class="form-control" runat="server"></asp:TextBox>
                            </td>
                            <td align="right">
                                Acumulado:</td>
                            <td align ="left">
                                <asp:TextBox ID="txtacumula" class="form-control" runat="server" Enabled="False"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td align="right">
                                Producto:</td>
                            <td align ="left" colspan="4">
                                <asp:TextBox ID="txtclavemat" class="form-control"  runat="server" onblur="separa(2);" ></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender3" runat="server" CompletionInterval="1000"
                                    CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    ServiceMethod="qryMaterialessur" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclavemat"  >
                                </ajaxToolkit:AutoCompleteExtender>
                            </td>
                            <td align="right">
                                Folio:</td>
                            <td align ="left">
                                <asp:TextBox ID="txtfolio" class="form-control" runat="server" 
                                    Enabled="False" ForeColor="#006699"></asp:TextBox>
                            </td>
                        </tr>

                    <tr>
                        <td align="center">
                        </td>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align ="center">
                            <small>
                                Unidad:
                            </small>
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                    </tr>
                    <tr>
                        <td align ="center">
                            <asp:TextBox ID="txtidmat" class="form-control" Enabled="false" runat="server" Width="80%" style="display: none"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcve" class="form-control" Enabled="false" runat="server" Width="80%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdescmat" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center" >
                            <asp:TextBox ID="txtunidad" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostomat" class="form-control" Enabled="false" runat="server" onblur="calculacosto(2);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidadmat" class="form-control"  runat="server" onblur="calculacosto(2);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btnmat" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(2);"></asp:Button>
                        </td>
                    </tr>


                    </table>
                  <ol class="breadcrumb">
                    <li onclick="muestra(1);"><a ><i class="fa fa-dashboard"></i> Nuevo</a></li>
                    <li onclick="muestra(2);"><a ><i class="fa fa-dashboard"></i> Guardar</a></li>
                  </ol>

                <small>
                    <asp:Panel ID="Panel1" runat="server" Width="100%" ScrollBars="Auto">
                <asp:GridView ID="gwm" runat="server" 
                      DataKeyNames="fila,tipo" EmptyDataText="Sin Materiales Cargados" 
                      AutoGenerateColumns="False" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
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
