<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ven_Con_Cotizacion.aspx.vb" Inherits="Ventas_App_Ven_Con_Cotizacion" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<base target="_self" />
    <title>Consulta Cotizacion</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <script type="text/javascript" src="../Content/js/gridbusca/jquery.min.js"></script>
    <script type="text/javascript" src="../Content/js/gridbusca/QuickSearch.js"></script>
        <script type="text/javascript">
            $(function () {
                $('.search_textbox').each(function (i) {
                    $(this).quicksearch("[id*=gvData] tr:not(:has(th))", {
                        'testQuery': function (query, txt, row) {
                            return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;
                        }
                    });
                });
            });
    </script>
    <style type="text/css">
        *{
	/* A universal CSS reset */
	padding:0;
    margin-left: 0;
    margin-right: 0;
    margin-top: 0;
}

        </style>

<script type="text/javascript">
    function muestra(tipo) {

        if (tipo == 0) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            $('#lts').hide('');
            $('#lddlts').hide('');
            $('#lrs').hide('');
            $('#tdfi').hide('');
            $('#tdfit').hide('');
            $('#tdff').hide('');
            $('#tdfft').hide('');
            $('#tdfop').hide('');
            document.getElementById('chkprospecto').checked = false
            document.getElementById('chkfecha').checked = false
            document.getElementById('chkts').checked = false
            $('#txtrsp').hide('');
            $('#lrs').show('');
            $('#txtrsc').show('');
        }
        if (tipo == 1) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            $('#lts').hide('');
            $('#lddlts').hide('');
            $('#lrs').hide('');
            $('#tdfi').hide('');
            $('#tdfit').hide('');
            $('#tdff').hide('');
            $('#tdfft').hide('');
            $('#tdfop').hide('');
            document.getElementById('chkcliente').checked = false
            document.getElementById('chkfecha').checked = false
            document.getElementById('chkts').checked = false
            $('#txtrsc').hide('');
            $('#lrs').show('');
            $('#txtrsp').show('');
        }
        if (tipo == 2) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            document.getElementById('chkcliente').checked = false
            document.getElementById('chkfecha').checked = false
            document.getElementById('chkprospecto').checked = false
            $('#tdfop').hide('');
            $('#tdfi').hide('');
            $('#tdfit').hide('');
            $('#tdff').hide('');
            $('#tdfft').hide('');
            $('#txtrsc').hide('');
            $('#lrs').hide('');
            $('#txtrsp').hide('');
            $('#lts').show('');
            $('#lddlts').show('');
        }
        if (tipo == 3) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            document.getElementById('chkcliente').checked = false
            document.getElementById('chkts').checked = false
            document.getElementById('chkprospecto').checked = false
            $('#txtrsc').hide('');
            $('#lrs').hide('');
            $('#txtrsp').hide('');
            $('#lts').hide('');
            $('#lddlts').hide('');
            $('#tdfi').show('');
            $('#tdfit').show('');
            $('#tdff').show('');
            $('#tdfft').show('');
            $('#tdfop').show('');
            
        }
        if (tipo == 4) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            if (document.getElementById('CheckBox1').checked == true) {
                document.getElementById('CheckBox2').checked=false
                document.getElementById('CheckBox3').checked = false
                document.getElementById('CheckBox4').checked = false
                document.getElementById('CheckBox5').checked = false
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtfi').value = today
                document.getElementById('txtff').value = today
            } else {
                document.getElementById('txtfi').value = ''
                document.getElementById('txtff').value = ''
            }
        }
        if (tipo == 5) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            if (document.getElementById('CheckBox2').checked == true) {
                document.getElementById('CheckBox1').checked = false
                document.getElementById('CheckBox3').checked = false
                document.getElementById('CheckBox4').checked = false
                document.getElementById('CheckBox5').checked = false
                var diasemana = new Date().getDay()-1;
                var today = new Date();
                var today = new Date(today.getTime() - (diasemana * 24 * 3600 * 1000))
                var dd = today.getDate();
                var mm = today.getMonth() + 1; 
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtfi').value = today

                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1;
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtff').value = today
            } else {
                document.getElementById('txtfi').value = ''
                document.getElementById('txtff').value = ''
            }
        }
        if (tipo == 6) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            if (document.getElementById('CheckBox3').checked == true) {
                document.getElementById('CheckBox2').checked = false
                document.getElementById('CheckBox1').checked = false
                document.getElementById('CheckBox4').checked = false
                document.getElementById('CheckBox5').checked = false
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtfi').value = '01/' + mm + '/' + yyyy
                document.getElementById('txtff').value = today
            } else {
                document.getElementById('txtfi').value = ''
                document.getElementById('txtff').value = ''
            }
        }
        if (tipo == 7) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            if (document.getElementById('CheckBox4').checked == true) {
                document.getElementById('CheckBox2').checked = false
                document.getElementById('CheckBox3').checked = false
                document.getElementById('CheckBox1').checked = false
                document.getElementById('CheckBox5').checked = false
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtff').value = today

                if (mm > 6) {
                    mm = mm - 6
                } else {
                    mm = 12 + (mm - 6)
                    yyyy=yyyy-1
                                }

                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtfi').value = today
            } else {
                document.getElementById('txtfi').value = ''
                document.getElementById('txtff').value = ''
            }

        }
        if (tipo == 8) {
            $('#busqueda').show('');
            $('#Table1').show('');
            $('#estatus').hide('');

            if (document.getElementById('CheckBox5').checked == true) {
                document.getElementById('CheckBox2').checked = false
                document.getElementById('CheckBox3').checked = false
                document.getElementById('CheckBox4').checked = false
                document.getElementById('CheckBox1').checked = false
                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd
                }
                if (mm < 10) {
                    mm = '0' + mm
                }
                today = dd + '/' + mm + '/' + yyyy;
                document.getElementById('txtfi').value = '01/01/' + yyyy
                document.getElementById('txtff').value = today
            } else {
                document.getElementById('txtfi').value = ''
                document.getElementById('txtff').value = ''
            }
        }
        if (tipo == 9) {

            $('#busqueda').hide('');
            $('#Table1').hide('');
            $('#estatus').show('');
                document.getElementById('CheckBox1').checked = false
                document.getElementById('CheckBox2').checked = false
                document.getElementById('CheckBox3').checked = false
                document.getElementById('CheckBox4').checked = false
                document.getElementById('CheckBox5').checked = false

        }
            if (tipo == 10) {
                $('#busqueda').hide('');
                $('#Table1').hide('');
                $('#estatus').show('');
                document.getElementById('chkalta').checked = true
                document.getElementById('chkautoriza').checked = false
                document.getElementById('chkcancela').checked = false
            }

            if (tipo == 11) {
                $('#busqueda').hide('');
                $('#Table1').hide('');
                $('#estatus').show('');
                document.getElementById('chkalta').checked = false
                document.getElementById('chkautoriza').checked = true
                document.getElementById('chkcancela').checked = false
            }
            if (tipo == 12) {
                $('#busqueda').hide('');
                $('#Table1').hide('');
                $('#estatus').show('');
                document.getElementById('chkalta').checked = false
                document.getElementById('chkautoriza').checked = false
                document.getElementById('chkcancela').checked = true
            }
        }
    function continuar(val) {
        dato = document.getElementById('lblid').innerHTML
        if (dato == "0" || dato == "") {
            alert('Debe seleccionar una cotizacion antes de continuar.')
            return false;
        }
        estatus = document.getElementById('lblestatus').innerHTML
        if (val == 1) {
            $('#docadj').hide('');
            $('#correo').hide('');
            if (estatus != "0") {
                alert('Solo las Cotizaciones con estatus de ALTA son modificables, verifique.')
                return false;
            }
            window.location.replace("Ven_Cotizador.aspx?idcot=" + dato);
        }
        if (val == 2) {
            $('#correo').hide('');
            $('#docadj').hide('');
            __doPostBack('continua', '1')
        }
        if (val == 3) {
            $('#correo').hide('');
            $('#docadj').hide('');
            __doPostBack('exporta', '1')
        }
        if (val == 4) {
            $('#docadj').show('');
            $('#correo').hide('');
        }
        if (val == 5) {
            $('#docadj').hide('');
            $('#correo').show('');
        }

        if (val == 6) {
            window.location.replace("Ven_Con_Cotizacion.aspx");
        }
    }
</script>


</head>
  <body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
    <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <header class="main-header">
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
      </header>
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
        <section class="content-header">
          <h1>
              Ventas
            <small>Consulta Cotizador</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li><a href="Ven_Cotizador.aspx"><i class="fa fa-dashboard"></i> Cotizador</a></li>
            <li class="active">Consulta</li>
          </ol>
        </section>

        <!-- Main content -->
        <section class="content" >
          <div class="row" id="df">
            <div class="col-md-11">
              <div class="box box-info" id="paso1">
                <div class="box-header with-border" id ="busqueda">
                    <h3 class="box-title">
                        <small>Seleccione la Opcion de busqueda...                                                           
                        </small>
                    </h3>
                    <h3 class="box-title">
                        <small>
                            <asp:CheckBox ID="chkcliente" runat="server" Text=" - Cliente" onclick="muestra(0);"></asp:CheckBox>
                            <asp:CheckBox ID="chkprospecto" runat="server" Text=" - Prospecto" onclick="muestra(1);"></asp:CheckBox>
                            <asp:CheckBox ID="chkts" runat="server" Text=" - Tipo Servicio" onclick="muestra(2);"></asp:CheckBox>
                            <asp:CheckBox ID="chkfecha" runat="server" Text=" - Fecha" onclick="muestra(3);"></asp:CheckBox>
                           <asp:Label ID="lblid" runat="server" Text="0" style="display:none;"></asp:Label>
                           <asp:Label ID="lblestatus" runat="server" Text="0" style="display:none;"></asp:Label>
                        </small>
                    </h3>
                </div><!-- /.box-header -->
                <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:90%; height:80%">
                    <tr>
                        <td align="right" id="lrs">
                            Razon Social:</td>
                        <td align ="left">
                            <asp:TextBox ID="txtrsc" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server"></asp:TextBox>
                            <asp:TextBox ID="txtrsp" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" style="display:none;"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsc"  >
                            </ajaxToolkit:AutoCompleteExtender>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryprospecto" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsp"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                    <td align="right" id="lts" style="display:none;">
                        Tipos de Servicios:</td>
                    <td id="lddlts" style="display:none;">
                        <asp:DropDownList ID="ddltservicio"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                            <asp:ListItem Value="1">Mantenimiento</asp:ListItem>
                            <asp:ListItem Value="2">Limpieza</asp:ListItem>
                            <asp:ListItem Value="3">Jardineria</asp:ListItem>
                            <asp:ListItem Value="4">Fumigacion</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td align="right" id="tdfi" style="display:none;">
                        Fecha Inicial:</td>
                    <td align="right" id="tdfit" style="display:none;">
                        <asp:TextBox ID="txtfi" class="form-control" placeholder="Ejemplo... dd/mm/yyyy" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" id="tdff" style="display:none;">
                        Fecha Final:</td>
                    <td align="right" id="tdfft" style="display:none;">
                        <asp:TextBox ID="txtff" class="form-control" placeholder="Ejemplo... dd/mm/yyyy" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" id="tdfop" style="display:none;">
                            <small>
                                <asp:CheckBox ID="CheckBox1" runat="server" Text=" Hoy" onclick="muestra(4);"></asp:CheckBox>
                                <asp:CheckBox ID="CheckBox2" runat="server" Text=" Esta Semana" onclick="muestra(5);"></asp:CheckBox>
                                <asp:CheckBox ID="CheckBox3" runat="server" Text=" Este Mes" onclick="muestra(6);"></asp:CheckBox>
                                <asp:CheckBox ID="CheckBox4" runat="server" Text=" Este Semestre" onclick="muestra(7);"></asp:CheckBox>
                                <asp:CheckBox ID="CheckBox5" runat="server" Text=" Este Año" onclick="muestra(8);"></asp:CheckBox>
                            </small>
                    </td>
                    <td>
                        <div class="box-footer">
                                <asp:Button ID="Button3" runat="server" Text="Buscar" class="btn btn-info pull-right" />
                        </div><!-- /.box-footer -->
                    </td>
                    </tr>
                </table>
                <table class="box-body" id="consulta" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; " >
                    <tr>
                        <td align="center">
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
                                        <asp:BoundField DataField="C/Indirecto" HeaderText="C/Indirecto" 
                                            DataFormatString="{0:c}" >
                                        <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="C/Utilidad" HeaderText="C/Utilidad"
                                            DataFormatString="{0:c}" >
                                        <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="C/Comer" HeaderText="C/Comer" 
                                            DataFormatString="{0:c}" >
                                        <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
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
                    <tr>
                        <td>
                        </td>
                    </tr>
                </table>
                <div class="box-header with-border" id="estatus" style="display:none;">
                    <h3 class="box-title">
                        <small>Seleccione el estatus de la Cotizacion
                        </small>
                    </h3>
                    <h3 class="box-title" >
                            <asp:CheckBox ID="chkalta" runat="server" Text=" - Alta" onclick="muestra(10);"></asp:CheckBox>
                            <asp:CheckBox ID="chkautoriza" runat="server" Text=" - Autorizada" onclick="muestra(11);"></asp:CheckBox>
                            <asp:CheckBox ID="chkcancela" runat="server" Text=" - Cancelada" onclick="muestra(12);"></asp:CheckBox>
                    </h3>
                        <div class="box-footer">
                                <asp:Button ID="btnEstatus" runat="server" Text="Cambiar estatus" class="btn btn-info pull-right" />
                        </div><!-- /.box-footer -->

                </div><!-- /.box-header -->

                <div class="box-header with-border" id="docadj" style="display:none;" >
                    <h3 class="box-title">
                        <small>Localice el documento en su equipo y adjuntelo al sistema...
                        </small>
                    </h3>
                        <div class="box-footer">
                            <asp:FileUpload ID="cargaarch" runat="server" ForeColor="#400000" Height="20px" onpaste="return false" 
                                Style="font-size: 8pt;left: 56px; font-family: tahoma; width: 100%;" />
                        </div><!-- /.box-footer -->
                        <div class="box-footer">
                    <h3 class="box-title">
                        <small>Docuamento Adjuntado a la Cotizacion:
                        </small>
                    </h3>
                                <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
                                <asp:Button ID="ctnadjunta" runat="server" Text="Subir archivo" class="btn btn-info pull-right" />
                        </div><!-- /.box-footer -->
                </div><!-- /.box-header -->

                <table class="box-body" id="correo" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none;" >
                    <tr>
                    <td colspan="2" align="center">
                    <h3 class="box-title">
                        <small>Ingrese los datos para enviar correo:
                        </small>
                    </h3>
                    </td>
                    </tr>
                    <tr>
                        <td align="right">Para:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtpara" class="form-control" placeholder="destinatario@batia.com.mx" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Asunto:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtasunto" class="form-control" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Archivo Adjunto:
                        </td>
                        <td align="left">
                                <asp:LinkButton ID="LinkButton2" runat="server"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Mensaje:
                        </td>
                        <td align="left">
                            <asp:TextBox ID="txtmensaje" class="form-control" runat="server" TextMode="MultiLine"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align ="center" colspan="2"> 
                            <asp:ImageButton ID="ImageButton2" runat="server" Height="64px" ImageUrl="~/Content/img/email.jpg"
                                Style="left: 152px; top: 128px" 
                                ToolTip="Enviar Correo" Width="96px" />
                        </td>
                    </tr>
                </table>


                <div class="box-header with-border">
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa fa-dashboard"></i> Modificar</a></li>
                        <li onclick="return continuar(2);"><a ><i class="fa fa-dashboard"></i> Cambiar de estatus</a></li>
                        <li onclick="return continuar(3);"><a ><i class="fa fa-dashboard"></i> Extrae Datos</a></li>
                        <li onclick="return continuar(4);"><a ><i class="fa fa-dashboard"></i> Adjunta Documento</a></li>
                        <li onclick="return continuar(5);"><a ><i class="fa fa-dashboard"></i> Envia Cotizacion por Correo</a></li>
                        <li onclick="return continuar(6);"><a ><i class="fa fa-dashboard"></i> Nueva Consulta</a></li>
                    </ol>
              </div><!-- /.box-header -->
              </div><!-- /.box-body -->

            </div><!--/.col (right) -->
        </div>   
        </section><!-- /.content -->



      </div><!-- /.content-wrapper -->
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>

      <!-- Control Sidebar -->
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
