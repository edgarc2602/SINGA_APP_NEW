<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cot_Factores.aspx.vb" Inherits="Ventas_App_Ven_Cot_Factores" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Factores</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
<script type="text/javascript">
    function muestra(tipo) {
        if (tipo == 0) {
            document.getElementById('lbltipo').innerHTML = "Cliente";
            $('#txtrsp').hide('');
            $('#txtfc').hide('');
            $('#txtrsc').show('');
            document.getElementById('chkprospecto').checked = false
            document.getElementById('chkcotizacion').checked = false
        }
        if (tipo == 1) {
            document.getElementById('lbltipo').innerHTML = "Prospecto";
            $('#txtrsc').hide('');
            $('#txtfc').hide('');
            $('#txtrsp').show('');
            document.getElementById('chkcliente').checked = false
            document.getElementById('chkcotizacion').checked = false
        }
        if (tipo == 2) {
            document.getElementById('lbltipo').innerHTML = 'Cotizacion'
            $('#txtrsc').hide('');
            $('#txtrsp').hide('');
            $('#txtfc').show('');
            document.getElementById('chkcliente').checked = false
            document.getElementById('chkprospecto').checked = false
        }
        if (tipo == 3) {
            $('#dvp1').show('');
            $('#dvp2').hide('');
            $('#dvp3').hide('');
        }
        if (tipo == 4) {
            $('#dvp1').hide('');
            $('#dvp2').show('');
            $('#dvp3').hide('');
        }
        if (tipo == 5) {
            $('#dvp1').hide('');
            $('#dvp2').hide('');
            $('#dvp3').show('');
        }

    }


    function agrega(val) {
        if (val == 0) {
            pind = document.getElementById('txtpind').value
            util = document.getElementById('txtutil').value
            comer = document.getElementById('txtcomer').value
            if (pind == '') {
                alert('El Porcentaje del Indirecto es un dato necesario.');
                return false;
            }
            if (util == '') {
                alert('El Porcentaje de la Utilidad es un dato necesario.');
                return false;
            }
            if (comer == '') {
                alert('El Porcentaje de Comercializacion es un dato necesario.');
                return false;
            }
        }

        if (val == 1) {
            ppind = document.getElementById('txtppind').value
            pputil = document.getElementById('txtpputil').value
            ppcomer = document.getElementById('txtppcomer').value
            if (ppind == '') {
                alert('El Porcentaje del Indirecto es un dato necesario.');
                return false;
            }
            if (pputil == '') {
                alert('El Porcentaje de la Utilidad es un dato necesario.');
                return false;
            }
            if (ppcomer == '') {
                alert('El Porcentaje de Comercializacion es un dato necesario.');
                return false;
            }
            tipo = 0
            if (document.getElementById('chkcliente').checked == true) {
                tipo = 1
            }
            if (document.getElementById('chkprospecto').checked == true) {
                tipo = 2
            }
            if (document.getElementById('chkcotizacion').checked == true) {
                tipo = 3
            }
            __doPostBack('guardapp', tipo)
        }

        if (val == 2) {
            clave = document.getElementById('txtclave').value
            desc = document.getElementById('txtdesc').value
            pv = document.getElementById('txtpv').value
            if (clave == '') {
                alert('Clave es un dato necesario.');
                return false;
            }
            if (desc == '') {
                alert('Concepto es un dato necesario.');
                return false;
            }
            if (pv == '') {
                alert('Precio de Venta es un dato necesario.');
                return false;
            }
        }


    }




function Button3_onclick() {

}

</script>

</head>
  <body class="skin-blue sidebar-mini">
      <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="wrapper">
        <!-- Se cambia header por div -->
      <div class="main-header">
        <a href="../home.aspx" class="logo">
          <span class="logo-mini"><b>S</b>GA</span>
          <span class="logo-lg"><b>SIN</b>GA</span>
        </a>
        <!-- Se cambia nav por div -->
        <div class="navbar navbar-static-top" role="navigation">
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
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
        <!-- Se cambia aside por div -->
      <div class="main-sidebar">
        <!-- Se cambia section por div -->
        <div class="sidebar">
            <%= labelmenu%>
        </div>
      </div>
      
        <div class="content-wrapper">
        <!-- Se cambia section por div -->
        <div class="content-header">
          <h1>Factores
            <small>Cotizador</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li class="active">Factores</li>
          </ol>
        </div>
        <!-- Se cambia section por div -->
        <div class="content" >
                <ol class="breadcrumb">
                    <li onclick="muestra(3);"><a ><i class="fa fa-dashboard"></i> Porcentaje General</a></li>
                    <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Porcentaje Particular</a></li>
                    <li onclick="muestra(5);"><a ><i class="fa fa-cube"></i> Servivios Adicionales</a></li>
                </ol>

        <div class="row" id="captura">
            <div class="col-md-11">
                <div id="dvp1" title="Propuesta" align="center" style="display:none;" >
                <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Porcentaje General</h3>
                </div><!-- /.box-header -->
                <table class="box-body" id="tblpg" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:50%; height:80%;">
                    <tr>
                        <td align="right" Width="25%">
                            Indirecto:                            
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtpind" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" Width="25%">
                            Utilidad:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtutil" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>                      
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" Width="25%">
                            Comercializacion:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtcomer" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>                       
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                </table>
                <div class="box-footer">
                    <asp:Button ID="Button5" runat="server" Text="Guardar" class="btn btn-info pull-right" OnClientClick="return agrega(0);"/>
                </div><!-- /.box-footer -->
                </div>
                </div>
                <div id="dvp2" title="Propuesta" align="center" style="display:none;" >
                <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Porcentaje Particular</h3>
                </div><!-- /.box-header -->
            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                <ContentTemplate>   
                <table class="box-body" id="tblpp" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:50%; height:80%;">
                    <tr>
                        <td align="right" Width="25%">
                            Tipo:                            
                        </td>
                        <td align="right">
                            <asp:CheckBox ID="chkcliente"  runat="server" Text="Cliente" onclick="muestra(0);"></asp:CheckBox>
                        </td>
                        <td align="right">
                            <asp:CheckBox ID="chkprospecto"  runat="server" Text="Prospecto" onclick="muestra(1);"></asp:CheckBox>
                        </td>
                        <td align="right">
                            <asp:CheckBox ID="chkcotizacion"  runat="server" Text="Cotizacion" onclick="muestra(2);"></asp:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                           <asp:Label ID="lbltipo" runat="server" Text="Cliente"></asp:Label>                          
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtrsc" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" AutoPostBack="True" ></asp:TextBox>
                            <asp:TextBox ID="txtrsp" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" style="display:none;" AutoPostBack="True" ></asp:TextBox>
                            <asp:TextBox ID="txtfc" class="form-control" placeholder="COT-00001" runat="server" style="display:none;" AutoPostBack="True" ></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsc"  >
                            </ajaxToolkit:AutoCompleteExtender>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryprospecto" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsp"  >
                            </ajaxToolkit:AutoCompleteExtender>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender2" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qrycotizacion" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtfc"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" Width="25%">
                            Indirecto:                            
                        </td>
                        <td align="right">
                            <asp:TextBox ID="txtppind" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" Width="25%">
                            Utilidad:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtpputil" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>                      
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" Width="25%">
                            Comercializacion:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtppcomer" Width="50%" placeholder="%" runat="server" Text="0" Style="text-align:right"></asp:TextBox>                       
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                </table>
                <div class="box-footer">
                    <asp:Button ID="Button3" runat="server" Text="Guardar" class="btn btn-info pull-right" OnClientClick="return agrega(1);"/>
                </div><!-- /.box-footer -->
                </ContentTemplate>
            </asp:UpdatePanel>

                </div>
                </div>


                <div id="dvp3" title="Propuesta" align="center" style="display:none;" >
                <div class="box box-info">

                <div class="box-header with-border">
                  <h3 class="box-title">Servicios Adicionales</h3>
                </div><!-- /.box-header -->

            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="Personal" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; " >
                    <tr>
                        <td colspan="4">
                            <div class="box-header with-border">
                                <h3 class="box-title">Personal :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Concepto:
                            </small>
                        </td>
                        <td align="center">
                            <small>Precio Venta:</small>
                        </td>
                    </tr>
                    <tr>
                        <td align ="center">
                            <asp:TextBox ID="txtclave" class="form-control"  runat="server" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdesc" class="form-control"  runat="server" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtpv" class="form-control"  runat="server" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="Button4" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(2);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwp" runat="server" 
                      DataKeyNames="IdPieza,SAdi_Status" 
                      AutoGenerateColumns="False" Width="100%" >
                    <Columns>
                        <asp:BoundField DataField="SAdi_Clave" HeaderText="Clave" SortExpression="SAdi_Clave" />
                        <asp:BoundField DataField="SAdi_DescPieza" HeaderText="DescPieza" SortExpression="SAdi_DescPieza" />
                        <asp:BoundField DataField="SAdi_PrecioAutorizado" HeaderText="Precio Venta" SortExpression="SAdi_PrecioAutorizado" />
                        <asp:BoundField DataField="estatus" HeaderText="estatus" SortExpression="estatus" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <div class="box-footer">
                </div>
                </div>
                </div>
            </div><!-- /.box -->
        </div><!--/.col (right) -->
        </div><!-- /.content -->

        </div>   
      </div>
        <!-- Se cambia footer por div -->
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js" type="text/javascript"></script>
    <script src="../Content/form/js/morris.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery.sparkline.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery-jvectormap-1.2.2.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery-jvectormap-world-mill-en.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery.knob.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.2/moment.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/daterangepicker.js" type="text/javascript"></script>
    <script src="../Content/form/js/bootstrap-datepicker.js" type="text/javascript"></script>
    <script src="../Content/form/js/bootstrap3-wysihtml5.all.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>

      </form>

  </body>
</html>
