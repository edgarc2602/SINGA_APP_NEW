<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_tk_Dash.aspx.vb" Inherits="App_Operaciones_Ope_tk_Dash" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DashBoard| Ticket</title>
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
   <%-- Grafica--%>
           <script type="text/javascript" src="../Content_hchar/jquery.min.js"></script>
        <script type="text/javascript" src="../Content_hchar/highcharts.js"></script>|
        <script type="text/javascript" src="../Content_hchar/exporting.js"></script>
        <%--barras desglose--%>
        <script type="text/javascript" src="../Content_hchar/data.js"></script>
        <script type="text/javascript" src="../Content_hchar/drilldown.js"></script>
   <%-- Grafica--%>
		<script type="text/javascript">
		    $(document).ready(function () {
		        setTimeout(function () {
		            $("#menu").click();
		        }, 50);
		    });

		    function consulta(val) {
		        if (val == 0) {
		            __doPostBack('opcion', val)
                }
            }
            function muestra(val) {
                var categoria = [];
                var serie1 = [];
                var serie2 = [];
                var serie3 = [];
                var serie4 = [];
                var serie5 = [];
                var titulo = '';
                var strii = '';
                var stri = '';

                if (val == 0) {
                    stri = document.getElementById('grafica_mes').innerHTML;
                }
                if (val == 1) {
                    stri = document.getElementById('grafica_cte').innerHTML;
                }

                if (val == 2) {
                    stri = document.getElementById('grafica_inc').innerHTML;
                }

                if (val == 3) {
                    stri = document.getElementById('grafica_ar').innerHTML;
                }

                var varrayi = stri.split("|");
                for (var j = 0; j < varrayi.length; j++) {
                    if (j == 0) {
                        stri = varrayi[j];
                        categoria = stri.split(",");
                    }
                    if (j == 1) {
                        stri = varrayi[j].replace("[", "");
                        stri = stri.replace("]", "");
                        var strii = stri.split(",");
                        var drilli = [];
                        for (var i = 0; i < strii.length; i++) {
                            x = strii[i];
                            serie1.push(parseFloat(x)); 
                        }
                    }
                    if (j == 2) {
                        stri = varrayi[j].replace("[", "");
                        stri = stri.replace("]", "");                        
                        var strii = stri.split(",");
                        for (var i = 0; i < strii.length; i++) {
                            x = strii[i];
                            serie2.push(parseFloat(x));
                        } 
                    }
                    if (j == 3) {
                        stri = varrayi[j].replace("[", "");
                        stri = stri.replace("]", "");
                        var strii = stri.split(",");
                        var drilli = [];
                        for (var i = 0; i < strii.length; i++) {
                            x = strii[i];
                            serie3.push(parseFloat(x));
                        } 
                    }
                    if (j == 4) {
                        titulo = varrayi[j];
                    }
                    if (j == 5) {
                        stri = varrayi[j].replace("[", "");
                        stri = stri.replace("]", "");
                        var strii = stri.split(",");
                        var drilli = [];
                        for (var i = 0; i < strii.length; i++) {
                            x = strii[i];
                            serie4.push(parseFloat(x));
                        } 
                    }
                    if (j == 6) {
                        stri = varrayi[j].replace("[", "");
                        stri = stri.replace("]", "");
                        var strii = stri.split(",");
                        var drilli = [];
                        for (var i = 0; i < strii.length; i++) {
                            x = strii[i];
                            serie5.push(parseFloat(x));
                        } 
                    }
                }
                grafica1(categoria, serie1, serie2, serie3, titulo, serie4, serie5);                
            }
            function grafica(categoria, serie1, serie2, serie3, titulo, tipo, det) {
                alert('grafica');
                $('#demo').highcharts({
                    chart: {
                        type: 'column'
                    },

                    title: {
                        text: titulo
                    },

                    xAxis: {
                        categories: categoria
                    },

                    yAxis: {
                        allowDecimals: false,
                        min: 0,
                        title: {
                            text: 'Numero de ticket'
                        }
                    },

                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.x + '</b><br/>' +
                this.series.name + ': ' + this.y + '<br/>' +
                'Total: ' + this.point.stackTotal;
                        }
                    },

                    plotOptions: {
                        column: {
                            stacking: 'normal'
                        }
                    },

                    series: [{
                        name: 'Estatus Alta',
                        data: serie1,
                        stack: 'male'
                    }, {
                        name: 'Estatus Atendido',
                        data: serie2,
                        stack: 'male'
                    }, {
                        name: 'Total Ticket',
                        data: serie3,
                        stack: 'female'
                    }]
                });            
            
            }
            function grafica1(categoria, serie1, serie2, serie3, titulo, serie4, serie5) {
                $('#demo').highcharts({
                    chart: {
                        type: 'column'
                    },

                    title: {
                        text: titulo
                    },

                    xAxis: {
                        categories: categoria
                    },

                    yAxis: {
                        allowDecimals: false,
                        min: 0,
                        title: {
                            text: 'Numero de ticket'
                        }
                    },

                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.x + '</b><br/>' +
                this.series.name + ': ' + this.y + '<br/>' +
                'Total: ' + this.point.stackTotal;
                        }
                    },

                    plotOptions: {
                        column: {
                            stacking: 'normal'
                        }
                    },

                    series: [{
                        name: 'Total Ticket',
                        data: serie3,
                        stack: 'female'
                    },{
                        name: 'Estatus Alta',
                        data: serie1,
                        stack: 'male'
                    }, {
                        name: 'Estatus Atendido',
                        data: serie2,
                        stack: 'male'
                    }, {
                        name: 'Estatus Local',
                        data: serie4,
                        stack: 'spline'
                    }, {
                        name: 'Estatus Foraneo',
                        data: serie5,
                        stack: 'spline'
                    }]
                });

            }
		    function detallegrafica(empresa, tipo, det, det1, det1) {
		        alert(empresa);
            }

   
            function demo(categoria, serie1, serie2, serie3, titulo, tipo, det) {
                $('#demo').highcharts({
                chart: {
                    zoomType: 'xy'
                },
                title: {
                    text: titulo
                },
                subtitle: {
                    text: '<button type="button" id="Button2" runat="server" class="button" onclick="anterior(0);">Back to</button>',
                    useHTML: true
                },
                xAxis: [{
                    categories: categoria
                }],
                yAxis: [{ // Primary yAxis
                    labels: {
                        format: ' {value}',
                        style: {
                            color: Highcharts.getOptions().colors[1]
                        }
                    },
                    title: {
                        text: '',
                        style: {
                            color: Highcharts.getOptions().colors[1]
                        }
                    }
                }, { // Secondary yAxis
                    title: {
                        text: '',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    },
                    labels: {
                        format: ' {value}',
                        style: {
                            color: Highcharts.getOptions().colors[0]
                        }
                    },
                    opposite: true
                }],
                tooltip: {
                    shared: true
                },
                legend: {
                    shadow: false
                },
                tooltip: {
                    headerFormat: '<span style="font-size:10px;fontFamily:Verdana, sans-serif"><b>{point.key}</b></span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b> {point.y:,.0f}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },

                plotOptions: {
                    series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function () {
                                    alert('Este es el ultimo nivel para regresar de click en el boton: Back to');
                                    // detallegrafica(this.category, tipo, det);
                                }
                            }
                        }
                    }
                },
                series: [{
                    name: 'Total Ticket',
                    type: 'column',
                    data: serie3

                }, {
                    name: 'Estatus Atendido',
                    type: 'spline',
                    data: serie2


                }, {
                    name: 'Estatus Alta',
                    type: 'spline',
                    data: serie1
                }]
            });
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
              DashBoard
            <small>Operaciones</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Operaciones</a></li>
            <li class="active">DashBoard Ticket</li>
          </ol>
        </div>  
        <div class="content" >
            <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-12">
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
                                <td style="text-align:center;">
                                    <asp:DropDownList ID="ddlanio"  runat="server" CssClass="form-control">
                                    </asp:DropDownList>
                                </td>
                            <td style="text-align:right;">
                                Mes de Servicio:</td>
                            <td style="text-align:left;">
                                <asp:DropDownList ID="ddlmes"  runat="server" CssClass="form-control">
                                    <asp:ListItem Value="0">Todos</asp:ListItem>
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
                            <td style="text-align:center;">
                                <asp:TextBox ID="txtnumtk" class="form-control" placeholder="#" runat="server"></asp:TextBox>
                            </td>
                            <td style="text-align:right;">
                                Folio Ticket:</td>
                            <td style="text-align:left;">
                                <asp:TextBox ID="txtfolio" class="form-control" placeholder="ejem: 001-1" runat="server" MaxLength="50" ></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">
                                Cliente:</td>
                            <td style="text-align:left;" colspan="4">
                                <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" onblur="completadatos(0)"></asp:TextBox>
                                <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                    CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                    ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrs"  >
                                </ajaxToolkit:AutoCompleteExtender>
                            </td>
                            <td style="text-align:right;">
                                Area Resp.:</td>
                            <td style="text-align:left;" >
                                <asp:DropDownList ID="ddlarearesp" class="form-control" runat="server" placeholder="Activo">
                                </asp:DropDownList>
                            </td>
                            <td>
                            <small>Estatus:</small>
                            </td>
                            <td style="text-align:center;">
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
            <li onclick="consulta(0);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Consulta</a></li>
          </ol>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->

          <div class="row"  id="bitacora">
              <!-- general form elements -->
            <div class="col-md-12">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Resultado de Busqueda</h3>
                   <ol class="breadcrumb">
                    <li onclick="muestra(0);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Por Mes</a></li>
                    <li onclick="muestra(1);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Por Cliente</a></li>
                    <li onclick="muestra(2);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Por Valor</a></li>
                    <li onclick="muestra(3);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Por Area</a></li>
                    <%--<li onclick="muestra(4);" style="cursor: pointer;"><a ><i class="fa fa-dashboard"></i> Por Tiempo de respuesta</a></li>--%>
                  </ol>
                </div><!-- /.box-header -->
                 <div id="demo" style="width: 95%; min-width: 70%; height: 70%; margin: 0 auto"></div>
                <small>
                    <asp:Panel ID="Panel1" runat="server" Width="100%" ScrollBars="Auto">
                        <asp:Label ID="grafica_mes" runat="server" Text="" style=" display:none;"></asp:Label><br />
                        <asp:Label ID="grafica_cte" runat="server" Text="" style=" display:none;"></asp:Label><br />
                        <asp:Label ID="grafica_inc" runat="server" Text="" style=" display:none;"></asp:Label><br />
                        <asp:Label ID="grafica_ar" runat="server" Text="" style=" display:none;"></asp:Label>
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
<%--no funciona graficas    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>--%>
    <!-- jQuery UI 1.11.4 -->
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>


    <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>


    </div>
    </form>
</body>
</html>
