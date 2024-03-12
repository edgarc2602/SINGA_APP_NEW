<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
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

    function importa(dato) {
        if (document.getElementById('txtid').value == ") {
            alert('Tiene que Guardar los datos fiscales antes de continuar')
            return false;
        }
        if (document.getElementById('ddltservicio').value == "0") {
            alert('Tiene que seleccionar el Tipo de Servicio antes de continuar')
            return false;
        }
        
        __doPostBack('importa', dato)
    }

    function importadatos(dato) {
        var mensa = confirm('Este proceso importara los puntos de atencion y plantilla cargados en la cotizacion. ¿Desea Continuar?')
        if (mensa) { 
            __doPostBack('importadatos', dato)
            } else{
                return false;
            }
    }

    function validarfc() {
        dato = document.getElementById('txtrfc').value;
        if (dato == '') {
            alert("Validacion!, Catupture el RFC");
            return false;
        }
        datoc=length(dato)
        if (datoc == 12 || datoc == 13) {
        } else {
            alert("Validacion!, La longitud del RFC es incorrecta");
            return false;        
        }
    }
    function muestra(tipo) {
        if (tipo == 0) {
            $('#comercial').hide('slow');
            $('#facturacion').hide('slow');
            $('#servicio').hide('slow');
            $('#grid').hide();
            $('#fiscal').toggle('slide', { direction: 'down' }, 700);
            $('#guarda').hide();
            $('#cte').hide();
            $('#cotizacion').hide();
        }
        if (tipo == 1) {
            if (document.getElementById('txtid').value == ") {
                alert('Tiene que Guardar los datos fiscales antes de continuar')
                return false;
            }
            $('#fiscal').show();
            $('#facturacion').hide();
            $('#servicio').hide();
            $('#comercial').toggle('slide', { direction: 'down' }, 700);
            $('#grid').hide();
            $('#guarda').show();
            $('#cte').hide();
            $('#cotizacion').hide();
        }
        if (tipo == 2) {
            if (document.getElementById('txtid').value == ") {
                alert('Tiene que Guardar los datos fiscales antes de continuar')
                return false;
            }
            $('#fiscal').show();
            $('#comercial').hide();
            $('#servicio').hide();
            $('#facturacion').toggle('slide', { direction: 'down' }, 700);
            $('#grid').hide();
            $('#guarda').show();
            $('#cte').hide();
            $('#cotizacion').hide();
        }
        if (tipo == 3) {
            if (document.getElementById('txtid').value == ") {
                alert('Tiene que Guardar los datos fiscales antes de continuar')
                return false;
            }
            $('#fiscal').show();
            $('#comercial').hide();
            $('#facturacion').hide();
            $('#servicio').toggle('slide', { direction: 'down' }, 700);
            $('#grid').hide();
            $('#guarda').show();
            $('#cte').hide();
            $('#cotizacion').hide();
        }
        if (tipo == 4) {
            $('#fiscal').hide('slow');
            $('#comercial').hide('slow');
            $('#facturacion').hide('slow');
            $('#servicio').hide('slow');
            $('#grid').toggle('slide', { direction: 'down' }, 700);
            $('#guarda').hide();
            $('#cte').show();
            $('#cotizacion').hide();
        }
        if (tipo == 5) {
            $('#comercial').hide('slow');
            $('#facturacion').hide('slow');
            $('#servicio').hide('slow');
            $('#grid').hide();
            $('#fiscal').toggle('slide', { direction: 'down' }, 700);
            $('#guarda').hide();
            $('#cte').hide();
            $('#cotizacion').show();
        }

    }
    function limpia() {
        window.location.replace("Ven_Cat_Cliente.aspx");
    }
    function valida() {
    }
    function directorio() {
        dato = document.getElementById('txtid').value
        if (dato == ") {
            alert('Debe de guardar el cliente antes de cargar el directorio')
        }
        if (dato != 0) {
            window.location = 'Ven_Directorio.aspx?idc=' + dato
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
</div>
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
              Clientes
            <small>Catalogo</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li class="active">Prospecto</li>
          </ol>
        </section>

        <!-- Main content -->
        <div class="content" >
          <div id="grid" style=" display:none;" >
            <div class="row">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" Font-Names="tahoma" Font-Size="12px" 
                    GridLines="Horizontal" Width="100%" DataKeyNames="Id" >
                    <Columns>
                        <asp:BoundField DataField="Cte_Fis_Clave_Cliente" HeaderText="Razon Social" 
                            SortExpression="Cte_Fis_Clave_Cliente" />
                        <asp:BoundField DataField="Cte_Fis_Razon_Social" HeaderText="Razon Social" 
                            SortExpression="Cte_Fis_Razon_Social" />
                        <asp:BoundField DataField="Cte_Fis_RFC" HeaderText="RFC" 
                            SortExpression="Cte_Fis_RFC" />
                        <asp:BoundField DataField="Cte_Con_Ejecutivo" HeaderText="Ejecutivo"   SortExpression="Cte_Con_Ejecutivo" />
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
            </div>
            <!--/.col (right) -->
          </div>   
          <ol class="breadcrumb" id="cte">
            <li onclick="muestra(0);"><a ><i class="fa fa-dashboard"></i> Clientes</a></li>
          </ol>
          </div>   
          <div class="row" id="df">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info" id="fiscal">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Fiscales</h3>
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
                        Clave:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtclave" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estatus:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtestatus" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Id Prospecto:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtidp" class="form-control" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Razon Social:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtrs" class="form-control" placeholder="Batia S.A. de C.V." runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Nombre Comercial:</td>
                    <td align="left" colspan="3">
                        <asp:TextBox ID="txtncomercial" class="form-control" placeholder="Grupo Batia" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Tipo:</td>
                    <td align ="left">
                        <asp:DropDownList ID="ddltipo"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Persona Fisica</asp:ListItem>
                            <asp:ListItem Value="1">Persona Moral</asp:ListItem>
                        </asp:DropDownList>
                                        </td>
                    <td align="right">
                        RFC:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtrfc" class="form-control" placeholder="XXXX-XXXXXX-XXX" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align="left">
                        <asp:TextBox ID="txttel" class="form-control" placeholder="(55)58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Celular:</td>
                    <td align="left">
                        <asp:TextBox ID="txtcel" class="form-control" placeholder="(044-55)58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Domicilio Fiscal:</td>
                    <td align ="left" colspan="7">
                        <asp:TextBox ID="TextBox1" class="form-control" placeholder="Calle No. Interior No. Exterior C.P. Colonia Delegacion/Municipio Estado " runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Representante Legal:</td>
                    <td align ="left" colspan="7">
                        <asp:TextBox ID="TextBox2" class="form-control" placeholder="Apellido Paterno Materno Nombres" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>

    </div><!-- /.box-body -->
              <div class="box box-info" id="comercial" style="display: none">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Comerciales</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        Contacto Cliente:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txt" class="form-control" placeholder="Nombre(s) Apellido Paterno Materno" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Ejecutivo:</td>
                    <td align="left" colspan="3">
                        <asp:DropDownList ID="ddlejecutivo" class="form-control" runat="server" placeholder="Seleccione...">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Mail:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtmail" class="form-control" placeholder="info@batia.com.mx" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align ="left">
                        <asp:TextBox ID="txttelc" class="form-control" placeholder="(55) 58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Celular:</td>
                    <td align="left">
                        <asp:TextBox ID="txtcelc" class="form-control" placeholder="(044-55)58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        -
                    </td>
                    <td align="left">
                        -
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Domicilio:</td>
                    <td align ="left" colspan="7">
                        <asp:TextBox ID="txtdomc" class="form-control" placeholder="Calle No. Interior No. Exterior C.P. Colonia Delegacion/Municipio Estado " runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div class="box-header with-border">
                <h3 class="box-title">Contrato</h3>
            </div><!-- /.box-header -->
            <table class="box-body" id="Table2" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        Fecha de Firma:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtfecfirma" class="form-control" placeholder="DD/MM/YYYY" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Vigencia:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtvig" class="form-control" placeholder="1 años" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>

    </div><!-- /.box-body -->
            <div class="box box-info" id="facturacion" style="display: none">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Facturacion</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table3" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        Contacto Cliente:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txtconfac" class="form-control" placeholder="Nombre(s) Apellido Paterno Materno" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" >
                        Importe de Facturacion</td>
                    <td align ="left">
                        <asp:TextBox ID="txtMonto" class="form-control" placeholder="Monto S/IVA" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Mail:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtmailfac" class="form-control" placeholder="info@batia.com.mx" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align ="left">
                        <asp:TextBox ID="txttelfac" class="form-control" placeholder="(55) 58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Celular:</td>
                    <td align="left">
                        <asp:TextBox ID="txtcelfac" class="form-control" placeholder="(044-55)58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Dias de pago:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtdpago" class="form-control" placeholder=" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Dias de Credito:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtdcred" class="form-control" placeholder=" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align ="left">
                    </td>
                    <td align ="left">
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkmcor" class="checkbox" runat="server" Text="Mes Corriente"></asp:CheckBox>
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkmant" class="checkbox" runat="server" Text="Mes Anticipado"></asp:CheckBox>
                    </td>
                    <td align ="left">
                        <asp:CheckBox ID="chkven" class="checkbox" runat="server" Text="Mes Vencido"></asp:CheckBox>
                    </td>
                    <th colspan="2">
                    </th>
                </tr>
            </table>
    </div>
    <!-- /.box-body -->
            <div class="box box-info" id="servicio" style="display: none">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Servicio</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="Table4" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td align="right">
                        Encargado Servicio:</td>
                    <td align ="left" colspan="3">
                        <asp:TextBox ID="txteser" class="form-control" placeholder="Nombre(s) Apellido Paterno Materno" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" >
                        Fecha Inicio</td>
                    <td align ="left">
                        <asp:TextBox ID="txtfecini" class="form-control" placeholder="DD/MM/YYYY" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Mail:</td>
                    <td align ="left">
                        <asp:TextBox ID="txtmailser" class="form-control" placeholder="info@batia.com.mx" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align ="left">
                        <asp:TextBox ID="txttelser" class="form-control" placeholder="(55) 58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Celular:</td>
                    <td align="left">
                        <asp:TextBox ID="txtcelser" class="form-control" placeholder="(044-55)58-38-90-00" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Tipos de Servicios:</td>
                    <td>
                        <asp:DropDownList ID="ddltservicio"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                            <asp:ListItem Value="1">Mantenimiento</asp:ListItem>
                            <asp:ListItem Value="2">Limpieza</asp:ListItem>
                            <asp:ListItem Value="3">Jardineria</asp:ListItem>
                            <asp:ListItem Value="2">Fumigacion</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Observaciones:</td>
                    <td align ="left" colspan="5">
                        <asp:TextBox ID="txtobs"  class="form-control" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
            </table>
    </div><!-- /.box-body -->

            <div class="box box-info" id="cotizacion" style="display: none;">
                <div class="box-header with-border">
                  <h3 class="box-title">Cotizaciones Generadas</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
            <table class="box-body" id="tblotizacion" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%">
                <tr>
                    <td>
                            <asp:GridView ID="gvData" runat="server" BackColor="White" BorderColor="#336666"
                                AutoGenerateColumns="False" BorderStyle="Double" BorderWidth="3px" CellPadding="4"
                                Font-Names="tahoma" Font-Size="11px" Width="100%" 
                                GridLines="Horizontal" DataKeyNames="ID_Cotizacion,Cot_Estatus,Cot_Documento" >
                                <Columns>
                                    <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                                    <asp:BoundField DataField="razonsocial" HeaderText="Razon Social" />
                                    <asp:BoundField DataField="folio" HeaderText="Folio" />
                                    <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                                    <asp:BoundField DataField="TS_Descripcion" HeaderText="Tipo Servicio" />
                                    <asp:CommandField ButtonType="Button" SelectText="Importa Datos Cot" 
                                        ShowSelectButton="True" />
                                </Columns>
                                <FooterStyle BackColor="White" ForeColor="#333333" />
                                <HeaderStyle BackColor="#336666" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="White" ForeColor="#333333" />
                                <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                            </asp:GridView>     
                        <asp:Panel ID="Panel1" runat="server" Width="100%" 
                        ScrollBars="Auto" Height="90%" BorderColor="#003366" BorderStyle="Double">
                        </asp:Panel>

                    </td>
                </tr>
            </table>
    </div><!-- /.box-body -->


    <div class="box-footer">
            <asp:Button ID="Button1" runat="server" Text="Guardar" onclientclick="return validarfc();" class="btn btn-info pull-right" />
    </div><!-- /.box-footer -->    
        <ol class="breadcrumb">
            <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Listado Clientes</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Cliente</a></li>
            <li onclick="muestra(1);"><a ><i class="fa fa-dashboard"></i> Datos Comerciales</a></li>
            <li onclick="muestra(2);"><a ><i class="fa fa-dashboard"></i> Datos Facturacion</a></li>
            <li onclick="muestra(3);"><a ><i class="fa fa-dashboard"></i> Datos Servicios</a></li>
            <li onclick="importa(0);"><a ><i class="fa fa-dashboard"></i> Cotizaciones Generadas</a></li>
            <li onclick="directorio();"><a ><i class="fa fa-dashboard"></i> Cargar Directorio</a></li>
        </ol>
    </div><!-- /.box -->

            </div><!--/.col (right) -->

        </div>   



      </div><!-- /.content-wrapper -->
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>


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
