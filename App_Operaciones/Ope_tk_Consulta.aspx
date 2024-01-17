<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ope_tk_Consulta.aspx.vb" Inherits="App_Operaciones_Ope_tk_Consulta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Consulta Ticket</title>
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
        	    $(document).ready(function () {
        	        setTimeout(function () {
        	            if (screen.width > 740) {
        	                $("#menu").click();
        	            }
        	        }, 50);
        	    });


        $(function () {
            $('.search_textbox').each(function (i) {
                $(this).quicksearch("[id*=gwm] tr:not(:has(th))", {
                    'testQuery': function (query, txt, row) {
                        return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;
                    }
                });
            });
        });
        function ticket(id) {
            var a = new Array;
            a[0] = 1;
            a[1] = 4;
            var tx = window.showModalDialog('Ope_Ticket.aspx?id=' + id, a, "dialogwidth: 450; dialogheight: 300; resizable: yes");
//            alert(tx);

        }

        function muestra(val) {
            if (val == 0) {
                __doPostBack('opcion', val)
            }
            if (val == 1) {
                __doPostBack('opcion', val)
            }
            if (val == 2) {
                __doPostBack('opcion', val)
            }
            if (val == 3) {
		window.location.href = 'Ope_tk_Dash.aspx';
                //var tx = window.showModalDialog('Ope_tk_Dash.aspx', '', 'dialogwidth:900px; dialogheight:850px');
            }
            if (val == 5) {
                alert('envio de correo')
                //__doPostBack('guarda', val)

            }
        }
    </script>
<script type="text/javascript">
    // fix for deprecated method in Chrome 37
    if (!window.showModalDialog) {
        window.showModalDialog = function (arg1, arg2, arg3) {

            var w;
            var h;
            var resizable = "no";
            var scroll = "no";
            var status = "no";

            // get the modal specs
            var mdattrs = arg3.split(";");
            for (i = 0; i < mdattrs.length; i++) {
                var mdattr = mdattrs[i].split(":");

                var n = mdattr[0];
                var v = mdattr[1];
                if (n) { n = n.trim().toLowerCase(); }
                if (v) { v = v.trim().toLowerCase(); }

                if (n == "dialogheight") {
                    h = v.replace("px", "");
                } else if (n == "dialogwidth") {
                    w = v.replace("px", "");
                } else if (n == "resizable") {
                    resizable = v;
                } else if (n == "scroll") {
                    scroll = v;
                } else if (n == "status") {
                    status = v;
                }
            }
            w = 1200;
            h = 800;
            var left = window.screenX + (window.outerWidth / 2) - (w / 2);
            var top = window.screenY + (window.outerHeight / 2) - (h / 2);
            var targetWin = window.open(arg1, arg1, 'toolbar=no, location=no, directories=no, status=' + status + ', menubar=no, scrollbars=' + scroll + ', resizable=' + resizable + ', copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            targetWin.focus();
        };
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
              Consulta de Ticket 
            <small>Operaciones</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Operaciones</a></li>
            <li class="active">Consulta de Ticket</li>
          </ol>
        </div>  

        <div class="content" >
          <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Filtros para Consultar Ticket</h3>
                </div><!-- /.box-header -->
                    <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                        style="border-collapse: collapse; width:100%; height:80%;" id="filtros" >
                            <tr>
                                <td>
                                <small>Fecha de alta:</small>
                                </td>
                                <td align ="center">
                                    <asp:TextBox ID="txtfecini" class="form-control" placeholder="dd/mm/aaaa" runat="server"></asp:TextBox>
                                </td>
                            <td align ="center">
                                <asp:TextBox ID="txtfecfin" class="form-control" placeholder="dd/mm/aaaa" runat="server"></asp:TextBox>
                            </td>
                            <td align="right">
                                Mes de Servicio:</td>
                            <td align ="left">
                                <asp:DropDownList ID="ddlmes"  runat="server" CssClass="form-control">
                                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
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
                            <td>
                            <small>Numero de Ticket:</small>
                            </td>
                            <td align ="center">
                                <asp:TextBox ID="txtnumtk" class="form-control" placeholder="#" runat="server"></asp:TextBox>
                            </td>
                            <td align="right">
                                Folio Ticket:</td>
                            <td align ="left">
                                <asp:TextBox ID="txtfolio" class="form-control" placeholder="ejem: 001-1" runat="server" MaxLength="50" ></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Cliente:</td>
                            <td align ="left" colspan="4">
                                <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" onblur="completadatos(0)"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                    CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrs"  >
                                </ajaxToolkit:AutoCompleteExtender>
                            </td>
                            <td align="right">
                                Area Resp.:</td>
                            <td align ="left" >
                                <asp:DropDownList ID="ddlarearesp" class="form-control" runat="server" placeholder="Activo">
                                </asp:DropDownList>
                            </td>
                            <td>
                            <small>Estatus:</small>
                            </td>
                            <td align ="center">
                                <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                                    <asp:ListItem Value="0">Alta</asp:ListItem>
                                    <asp:ListItem Value="1">Atendido</asp:ListItem>
                                    <asp:ListItem Value="2">Cerrado</asp:ListItem>
                                    <asp:ListItem Value="3">Cancelado</asp:ListItem>
                                    <asp:ListItem Value="-1">Seleccione</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
           <ol class="breadcrumb">
            <li onclick="muestra(0);"><a ><i class="fa fa-dashboard"></i> Mostrar Resultado</a></li>
            <li onclick="muestra(1);"><a ><i class="fa fa-dashboard"></i> Exportar a Excel</a></li>
            <li onclick="muestra(2);"><a ><i class="fa fa-dashboard"></i> Dash</a></li>
          </ol>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->


          <div class="row"  id="bitacora">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Resultado de Busqueda</h3>
                </div><!-- /.box-header -->
                <small>
                    <asp:Panel ID="Panel1" runat="server" Width="100%" ScrollBars="Auto">
                    <asp:GridView ID="gwm" runat="server" EmptyDataText="No se han encontrado Record" 
                    DataKeyNames="ID" Width="100%" AutoGenerateColumns="False" Font-Names="Arial" 
                            Font-Size="8pt" >
                    <Columns>
                    <asp:BoundField DataField="Ticket" HeaderText="Ticket"/>
                    <asp:BoundField DataField="Folio" HeaderText="Folio"/>
                    <asp:BoundField DataField="Estatus" HeaderText="Estatus"/>
                    <asp:BoundField DataField="FechaAlta" HeaderText="FechaAlta" 
                            DataFormatString="{0:d}"/>
                    <asp:BoundField DataField="HoraAlta" HeaderText="HoraAlta"/>
                    <asp:BoundField DataField="FechaTermino" HeaderText="FechaTermino" DataFormatString="{0:d}"/>
                    <asp:BoundField DataField="HoraTermino" HeaderText="HoraTermino"/>
                        <asp:BoundField DataField="atn" HeaderText="Dias Atn" />
                        <asp:BoundField DataField="sinatn" HeaderText="Dias Pend" />
                    <asp:BoundField DataField="MesServicio" HeaderText="Mes_Servicio"/>
                    <asp:BoundField DataField="Valor" HeaderText="Valor"/>
                    <asp:BoundField DataField="Ambito" HeaderText="Ambito"/>
                    <asp:BoundField DataField="Cliente" HeaderText="Cliente"/>
                    <asp:BoundField DataField="Sucursal" HeaderText="Sucursal"/>
                    <asp:BoundField DataField="Estado" HeaderText="Localidad"/>
                    <asp:BoundField DataField="Incidencia" HeaderText="Incidencia"/>
                    <asp:BoundField DataField="CausaOrigen" HeaderText="CausaOrigen"/>
                    <asp:BoundField DataField="Ar_Nombre" HeaderText="Area Responsable"/>
                    <asp:BoundField DataField="Descripcion" HeaderText="Descripcion"/>
                    <asp:BoundField DataField="AccionCorrectiva" HeaderText="AccionCorrectiva"/>
                    <asp:BoundField DataField="AccionPreventiva" HeaderText="AccionPreventiva"/>
                    
                    <asp:BoundField DataField="Tk_Reporta" HeaderText="Reporta"/>
                    <asp:BoundField DataField="Ejecutivo" HeaderText="Ejecutivo"/>
                        <asp:BoundField DataField="gerente" HeaderText="Gerente" />
                    </Columns>
                    <FooterStyle BackColor="WhiteSmoke" ForeColor="#333333" />
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
                    </asp:Panel>
                   </small>
 



              </div><!-- /.box -->
            </div><!--/.col (right) -->
          </div><!-- /.content -->



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
