<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Ticket.aspx.vb" Inherits="App_Operaciones_Ope_Ticket" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Ticket</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>



    <style type="text/css">
.modal-box {
  display: none;
  position: absolute;
  z-index: 1000;
  width: 98%;
  background: white;
  border-bottom: 1px solid #aaa;
  border-radius: 4px;
  box-shadow: 0 3px 9px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(0, 0, 0, 0.1);
  background-clip: padding-box;
}
@media (min-width: 32em) {

.modal-box { width: 70%; }
}

.modal-box header,
.modal-box .modal-header {
  padding: 1.25em 1.5em;
  border-bottom: 1px solid #ddd;
}

.modal-box header h3,
.modal-box header h4,
.modal-box .modal-header h3,
.modal-box .modal-header h4 { margin: 0; }

.modal-box .modal-body { padding: 2em 1.5em; }

.modal-box footer,
.modal-box .modal-footer {
  padding: 1em;
  border-top: 1px solid #ddd;
  background: rgba(0, 0, 0, 0.02);
  text-align: right;
}

.modal-overlay {
  opacity: 0;
  filter: alpha(opacity=0);
  position: absolute;
  top: 0;
  left: 0;
  z-index: 900;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.3) !important;
}

a.close {
  line-height: 1;
  font-size: 1.5em;
  position: absolute;
  top: 5%;
  right: 2%;
  text-decoration: none;
  color: #bbb;
}

a.close:hover {
  color: #222;
  -webkit-transition: color 1s ease;
  -moz-transition: color 1s ease;
  transition: color 1s ease;
}
        .newStyle1
        {
            color: #3C8DD3;
        }
    </style>


    <script type="text/javascript" src="../Content/js/jquery.min.js"></script>
<%--    <script type="text/javascript" src="../Content/js/Quicksearch.js"></script>
    <script type="text/javascript">
        function SetContextKey() {
            $find('<%=AutoCompleteExtender1.ClientID %>').set_contextKey($get("<%=txtrs.ClientID %>").innerHTML);
        }
    </script>--%>
    <script type = "text/javascript">
        $(document).ready(function () {
            setTimeout(function () {
                $("#menu").click();
            }, 50);
        });
        function abremodal(val) {
            if (val == 1) {
                $("#mpopup2").click();
            }
        }
        function muevereloj() {
            momentoactual = new Date()
            hora = momentoactual.getHours()
            minuto = momentoactual.getMinutes()
            segundo = momentoactual.getSeconds()

            horaimprimible = hora + ":" + minuto + ":" + segundo;

            document.getElementById('txthoraactual').innerHTML = horaimprimible;
            setTimeout("muevereloj()", 1000)
            var str = document.getElementById('txthralta').value;
            d1 = document.getElementById('txtfechaalta').value.substring(3, 5) + "/" + document.getElementById('txtfechaalta').value.substring(0, 2) + "/" + document.getElementById('txtfechaalta').value.substring(6, 10) + " " + str.substring(0, 5);
            d2 = (momentoactual.getMonth() + 1) + "/" + momentoactual.getDate() + "/" + momentoactual.getFullYear() + " " + hora + ":" + minuto;

            if (document.getElementById('ddlstatus').value != 0) {
                d2 = document.getElementById('txtfecter').value.substring(3, 5) + "/" + document.getElementById('txtfecter').value.substring(0, 2) + "/" + document.getElementById('txtfecter').value.substring(6, 10) + " " + document.getElementById('txthrter').value.substring(0, 5)
            }
            //d1 = "01/17/2012 11:20"

            document.getElementById('txtdiast').value = calculatiempodosfechas(d1, d2);
            document.getElementById('txtfechaactual').innerHTML = momentoactual.getDate() + "/" + (momentoactual.getMonth() + 1) + "/" + momentoactual.getFullYear();

        }
        function calculatiempodosfechas(d1, d2) {
            start_actual_time = new Date(d1);
            end_actual_time = new Date(d2)
            var diff = end_actual_time - start_actual_time

            var diffseconds = diff / 1000;
            var HH = Math.floor(diffseconds / 3600);
            var MM = Math.floor(diffseconds % 3600) / 60;
            var dias = Math.floor(HH / 24);
            HH = Math.floor(HH % 24);
            var formatted = " Dia(s):" + ((dias < 10) ? ("0" + dias) : dias) + " Hora(s):" + ((HH < 10) ? ("0" + HH) : HH) + " Minuto(s):" + ((MM < 10) ? ("0" + MM) : MM)
            return formatted;
        }
        function SetContextKey() {
            $find('AutoCompleteExtender1').set_contextKey($get("<%=txtrs.ClientID %>").value);
        }
        function SetContextKeymat() {
            $find('AutoCompleteExtender4').set_contextKey($get("<%=ddlestado.ClientID %>").value);
        }
        function completadatos(val) {
            if (val == 4) {
                cve = document.getElementById('txtclavemat').value
                var res = cve.split("|");
                document.getElementById('txtclavemat').value = res[0]
                document.getElementById('txtdescmat').value = res[1]
                document.getElementById('txtcostomat').value = res[2]
            } else {
                __doPostBack('completadatos', val)
            }

        }
        function limpia() {
            window.location.replace("Ope_Ticket.aspx");
        }
        function agregabit() {
            com = document.getElementById('txtcomentario').value

            if (com == '') {
                alert('El Comentario es un dato necesario.');
                return false;
            }
        }
        function imprime() {
            id = document.getElementById('lblidticket').innerHTML
            if (id == "") {
                alert('Validacion!, Debe Guardar el ticket antes de Continuar')
                return false;
            }
            var tx = window.showModalDialog('Ope_Ticket_PDF.aspx?id=' + id, '', 'dialogwidth:900px; dialogheight:850px');
        }

        function agregamat() {
            cve = document.getElementById('txtclavemat').value
            edo = document.getElementById('ddlestado').value
            cant = document.getElementById('txtcantidadmat').value
            costo = document.getElementById('txtcostomat').value

            if (edo == '0') {
                alert('El estado es un dato necesario.');
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
            if (costo == '') {
                alert('El costo es un dato necesario.');
                return false;
            }
        
        }
        function calculacosto(val) {

            dcantidad = 0;
            if ($('#txtcantidadmat').val() == '') {
            } else {
                dcantidad = $('#txtcantidadmat').val()
            }
            dcosto = 0;
            if ($('#txtcostomat').val() == '') {
            } else {
                dcosto = $('#txtcostomat').val()
            }
            document.getElementById('txtimportemat').value = dcantidad * dcosto

        }

        function muestra(val) {
            dato = document.getElementById('txtid').value
            if (dato == "") {
                alert('Validacion!, Debe Guardar el ticket antes de Continuar')
                return false;
            }

            if (val == 0) {
                $('#gwm').hide();
                $('#material').hide();
                $('#generales').show('slow');
                $('#acciones').toggle('slide', { direction: 'up' }, 700);
            }
            if (val == 1) {
                alert('Opcion Deshabilitada');
//                $('#acciones').hide();
//                $('#generales').hide();
//                $('#material').show('slow');
//                $('#gwm').show('slow');
            }

            if (val == 2) {
                $('#captura').hide();
                $('#bitacora').toggle('slide', { direction: 'up' }, 700);
            }
            if (val == 3) {
                $('#secguarda').hide('slow')
            }
            if (val == 4) {
                $('#bitacora').hide()
                $('#captura').toggle('slide', { direction: 'up' }, 700);

            }
        }
        function mail() {
            id = document.getElementById('lblidticket').innerHTML
            if (id == "") {
                alert('Validacion!, Debe Guardar el ticket antes de Continuar')
                return false;
            }

                var tx = window.showModalDialog('Ope_tk_email.aspx?id=' + id, '', 'dialogwidth:500px; dialogheight:650px');
        }
        function catalogo(val) {
            if (val == 10) {
                alert(val)
            }
        }
        function continuar(val) {
            if (val == 4) {
                $('#acciones').hide();
                $('#generales').hide();
                $('#material').show('slow');
                $('#gwm').show('slow');
            }
        }
        function valida(val) {
            if (val == 0) {
                dato = document.getElementById('txtcatcauori').value
                if (dato == "") {
                    alert('Validacion!, Debe de Capturar la Causa/Origen antes de Continuar')
                    return false;
                }
            }
            if (val == 1) {
                dato = document.getElementById('txtcatincidencia').value
                if (dato == "") {
                    alert('Validacion!, Debe Capturar la Incidencia antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlcatarearesp').value

                if (dato == "0") {
                    alert('Validacion!, Debe Seleccionar el area responsable antes de Continuar')
                    return false;
                }
            }
            if (val == 2) {

                dato = document.getElementById('txtfechaalta').value
                if (dato == "") {
                    alert('Validacion!, Debe Capturar la Fecha de alta, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('lblidrs').innerHTML
                if (dato == "") {
                    alert('Validacion!, Debe ingresar un cliente Valido, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlgerente').value
                if (dato == "0") {
                    alert('Validacion!, Debe seleccionar al gerente, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('txtpa').value
                if (dato == "") {
                    alert('Validacion!, Debe ingresar el punto de atencion, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('lblidincidencia').innerHTML
                if (dato == "") {
                    alert('Validacion!, Debe ingresar la incidencia , antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlestadoalta').value
                if (dato == "0") {
                    alert('Validacion!, Debe Seleccionar la Localidad, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlejecutivo').value
                if (dato == "0") {
                    alert('Validacion!, Debe Seleccionar un ejecutivo, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('txtreporta').value
                if (dato == "") {
                    alert('Validacion!, Debe capturar quien genera el reporte, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlmes').value
                if (dato == "0") {
                    alert('Validacion!, Debe Seleccionar el mes de servicio, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlambito').value
                if (dato == "0") {
                    alert('Validacion!, Debe Seleccionar el ambito, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('lblidincidencia').innerHTML
                if (dato == "") {
                    alert('Validacion!, Debe capturar la incidencia, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('lblidco').innerHTML
                if (dato == "") {
                    alert('Validacion!, Debe capturar la causa/origen, antes de Continuar')
                    return false;
                }

                dato = ListBox1.length;
                if (dato == "0") {
                    alert('Validacion!, Debe seleccionar el area responsable de atender, antes de Continuar')
                    return false;
                }

                dato = document.getElementById('txtdescripcion').value
                if (dato == "") {
                    alert('Validacion!, Debe escribir la descripcion del Ticket, antes de Continuar')
                    return false;
                }
                dato = document.getElementById('ddlstatus').value
                if (dato == 2 || dato == 3) {
                    if (!confirm(" ¿Desea Continuar?\n \n Al cambiar el ticket a este estatus solo se podra consultar en un futuro y no podra modificar ningun dato,")) {
                        return false;
                    }
                    else {
                        dato = document.getElementById('txtfecter').value
                        if (dato == "") {
                            alert('Validacion!, Debe Capturar la Fecha de cierre, antes de Continuar')
                            return false;
                        }
                        dato = document.getElementById('txthrter').value
                        if (dato == "") {
                            alert('Validacion!, Debe Capturar la hora de cierre, antes de Continuar')
                            return false;
                        }
                    }
                }
            }
            __doPostBack('guarda', val)
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
            w = 900;
            h = 800;
            var left = window.screenX + (window.outerWidth / 2) - (w / 2);
            var top = window.screenY + (window.outerHeight / 2) - (h / 2);
            var targetWin = window.open(arg1, arg1, 'toolbar=no, location=no, directories=no, status=' + status + ', menubar=no, scrollbars=' + scroll + ', resizable=' + resizable + ', copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            targetWin.focus();
        };
    }
</script>

</head>
<body class="skin-blue sidebar-mini" onload="muevereloj()">
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
        <div class="sidebar" >
          <!-- sidebar menu: : style can be found in sidebar.less -->
            <%= labelmenu%>
        </div>
        <!-- /.sidebar -->
      </div>

    <div class="content-wrapper">
        <div class="content-header">
          <h1>
              Ticket
            <small>Operaciones</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Operaciones</a></li>
            <li class="active">Ticket</li>
          </ol>
        </div>  

        <div class="content" >
          <div class="row" id="captura">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Datos Requeridos</h3>
                </div><!-- /.box-header -->
                <!-- form start -->
<asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

      <table class="box-body" id="generales" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%;">
                <tr>
                    <td style="text-align:right; width:10%;">
                        </td>
                    <td style="text-align:right">
                        </td>
                    <td style="text-align:right">
                        </td>
                    <td style="text-align:right">
                        </td>
                    <td style="text-align:right">
                        No Ticket:</td>
                    <td style="text-align:left">
                        <asp:Label ID="lblidticket"  runat="server" style="display:none"></asp:Label>
                        <asp:TextBox ID="txtid" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Folio Ticket:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtfolio" class="form-control" runat="server" MaxLength="50" Enabled="false" ></asp:TextBox>
                    </td>
                  </tr>
                  <tr>
                    <td style="text-align:right">
                        Tipo de servicio:</td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlservicio"  runat="server" CssClass="form-control">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align:right">
                        Fecha alta:</td>
                    <td style="text-align:left">
                        <asp:Label ID="lblfecha"  runat="server" style="display:none"></asp:Label>
                        <asp:TextBox ID="txtfechaalta" class="form-control" runat="server" placeholder="dd/mm/yyyy"></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Hora:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txthralta" class="form-control" runat="server" placeholder="HH:mm:ss" ></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Año|Mes de servicio:</td>
                    <td style="text-align:left">
                    <table style=" width:100%">
                        <tr>
                        <td>
                            <asp:DropDownList ID="ddlanio"  runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </td>
                        <td>
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
                        </tr>
                    </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Cliente:</td>
                    <td style="text-align:left" >
                        <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" AutoPostBack="true"></asp:TextBox>
                        <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="1000"
                            CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                            ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrs"  >
                        </ajaxToolkit:AutoCompleteExtender>
                    </td>
                    <td style="text-align:right">
                        Gerente:</td>
                    <td style="text-align:left" >
                        <asp:DropDownList ID="ddlgerente" class="form-control" runat="server" placeholder="Activo">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align:right">
                        Punto de Atencion:</td>
                    <td colspan="3" style="text-align:left">
                        <asp:TextBox ID="txtpa"  class="form-control" runat="server" onkeyup = "SetContextKey()" AutoPostBack="true" placeholder="Teclee el nombre de la sucursal" ></asp:TextBox>
                        <cc1:AutoCompleteExtender ServiceMethod="qrypuntoatencion"
                            MinimumPrefixLength="2"
                            CompletionInterval="100" EnableCaching="false" CompletionSetCount="10" 
                            TargetControlID="txtpa" UseContextKey = "true" ServicePath="~/Objet/Cotiza.asmx" 
                            ID="AutoCompleteExtender1" runat="server" FirstRowSelected = "false">
                        </cc1:AutoCompleteExtender>
                    </td>
                  </tr>
                <tr>
                    <td style="text-align:center" colspan="8">
                        <asp:Label ID="lbldespa" runat="server" Text=""></asp:Label>
                        <asp:Label ID="lblidpa" runat="server" style="display:none;"></asp:Label>
                        <asp:Label ID="lblidrs" runat="server" style="display:none;"></asp:Label>
                     </td>
                </tr>
        </table>
</ContentTemplate>
</asp:UpdatePanel>
      <table class="box-body" id="generales1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%;">
                <tr>

                    <td style="text-align:right; width:10%;">
                       Localidad:</td>
                    <td style="text-align:left;width:15%;">
                        <asp:DropDownList ID="ddlestadoalta"  runat="server" CssClass="form-control">
                        </asp:DropDownList>

                    </td>
                    <td style="text-align:right; width:10%;">
                        Ambito:</td>
                    <td style="text-align:left;width:15%;">
                        <asp:DropDownList ID="ddlambito"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                            <asp:ListItem Value="1">Local</asp:ListItem>
                            <asp:ListItem Value="2">Foraneo</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="text-align:right; width:10%;">
                        Reporta:</td>
                    <td style="text-align:left;width:15%;">
                        <asp:TextBox ID="txtreporta"  class="form-control" runat="server" placeholder="Capture el nombre de quien reporta" ></asp:TextBox>
                    </td>
                    <td style="text-align:right; width:10%;">
                       Ejecutivo que atiende:</td>
                    <td style="text-align:left;width:15%;">
                        <asp:DropDownList ID="ddlejecutivo" class="form-control" runat="server" placeholder="Activo">
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td style="text-align:right; width:10%;">
                        <a data-modal-id="popup2" ><i class="fa fa-list"></i> Incidencia</a>
                     </td>
                    <td style="text-align:left" colspan="3">
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
                        <asp:Label ID="lblidincidencia" runat="server"  class="form-control" Text="Label" style="display:none"></asp:Label>
                        <asp:TextBox ID="txtincidencia" class="form-control" runat="server" AutoPostBack="true" placeholder="Teclee la incidencia" ></asp:TextBox>
                        <cc1:AutoCompleteExtender ServiceMethod="qryincidencia"
                            MinimumPrefixLength="2"
                            CompletionInterval="100" EnableCaching="false" CompletionSetCount="10" 
                            TargetControlID="txtincidencia" UseContextKey = "true" ServicePath="~/Objet/Cotiza.asmx" 
                            ID="AutoCompleteExtender2" runat="server" FirstRowSelected = "false">
                        </cc1:AutoCompleteExtender>
</ContentTemplate>
</asp:UpdatePanel>
                    </td>

                    <td style="text-align:right">
                        <a data-modal-id="popup1" ><i class="fa fa-list"></i> Causa/Origen</a>
                     </td>
                    <td style="text-align:left" colspan="3">
<asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
                        <asp:Label ID="lblidco" runat="server"  class="form-control" Text="Label" style="display:none"></asp:Label>
                        <asp:TextBox ID="txtcauori" class="form-control" runat="server" AutoPostBack="true" placeholder="Teclee la Causa/origen " ></asp:TextBox>
                        <cc1:AutoCompleteExtender ServiceMethod="qrycausaori"
                            MinimumPrefixLength="2"
                            CompletionInterval="100" EnableCaching="false" CompletionSetCount="10" 
                            TargetControlID="txtcauori" UseContextKey = "true" ServicePath="~/Objet/Cotiza.asmx" 
                            ID="AutoCompleteExtender3" runat="server" FirstRowSelected = "false">
                        </cc1:AutoCompleteExtender>
</ContentTemplate>
</asp:UpdatePanel>
                    </td>
                </tr>
      </table>
<asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
      <table class="box-body" id="generales2" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%;">
                <tr>
                    <td style="text-align:right; vertical-align:top; width:10%;">
                        Area Resp.:</td>
                    <td style="text-align:left; vertical-align:top; width:20%;" >
                        <asp:DropDownList ID="ddlarearesp" class="form-control" runat="server" placeholder="Activo" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                    <td colspan="2" style="text-align:left; width:20%;" >

                            <asp:ListBox ID="ListBox1" runat="server" class="form-control" AutoPostBack="true"></asp:ListBox>
                    </td>

                    <td style="text-align:right;vertical-align:top; width:10%;">
                        Descripcion del reporte:</td>
                    <td style="text-align:left;vertical-align:top; width:40%">
                        <asp:TextBox ID="txtdescripcion" class="form-control" 
                            placeholder="Capture breve descripcion del reporte" runat="server" 
                            MaxLength="500" TextMode="MultiLine"  style="height:100%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right" colspan="2">
                    </td>
                    <td style="text-align:right">
                    </td>
                    <td style="text-align:center">
                        Fecha Termino:</td>
                    <td style="text-align:center">
                        Hora Termino:</td>
                    <td style="text-align:center">
                        Tiempo Transcurrido:</td>
                </tr>


                <tr>
                    <td style="text-align:right">
                        Estatus:</td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlstatus" class="form-control" runat="server" placeholder="Activo">
                            <asp:ListItem Value="0">Alta</asp:ListItem>
                            <asp:ListItem Value="1">Atendido</asp:ListItem>
                            <asp:ListItem Value="2">Cerrado</asp:ListItem>
                            <asp:ListItem Value="3">Cancelado</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="text-align:right">
                    </td>
                    <td style="text-align:center">
                        <asp:TextBox ID="txtfecter" class="form-control" runat="server" placeholder="dd/mm/yyyy"></asp:TextBox>
                    </td>
                    <td style="text-align:center">
                        <asp:TextBox ID="txthrter" class="form-control" runat="server" placeholder="HH:mm:ss"></asp:TextBox>
                    </td>
                    <td style="text-align:center">
                        <asp:TextBox ID="txtdiast" class="form-control" runat="server" placeholder="Años(s): 0 Mes(es): 0 Dia(s):0 Hr(s):"></asp:TextBox>
                    </td>
                </tr>
            </table>
</ContentTemplate>
</asp:UpdatePanel>

            <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%; display:none; " id="acciones" >
                <tr>
                    <td colspan="4">
                        <div class="box-header with-border" >
                        <h3 class="box-title"><small> Seccion de Acciones</small></h3>
                        </div><!-- /.box-header -->
                   </td>
                </tr>
                <tr>
                    <td style="text-align:left">
                        Accion Correctiva:</td>
                    <td style="text-align:left">
                        Accion Preventiva:</td>
                </tr>
                <tr>
                    <td style="text-align:left" >
                        <asp:TextBox ID="txtac" class="form-control" 
                            runat="server" 
                            MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                    </td>
                    <td style="text-align:left" >
                        <asp:TextBox ID="txtap" class="form-control" runat="server" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   

            <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%; display:none;" id="material" >
                <tr>
                    <td style="text-align:right">
                        Id Ticket:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtmatid" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Folio Ticket:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtmatfolio" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Fecha alta:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtmatfechaalta" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                    <td style="text-align:right">
                        Hora:</td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtmathoraalta" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div class="box-header with-border" >
                        <h3 class="box-title"><small> Capture los materiales usados para atender este ticket(no olvide seleccionar el estado)</small></h3>
                        </div><!-- /.box-header -->
                   </td>
                </tr>
                <tr>
                        <td style="text-align:center">
                            <small>Estado:</small>
                        </td>
                        <td style="text-align:center">
                            <small>Clave:</small>
                        </td>
                        <td style="text-align:center" colspan="3">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td style="text-align:center">
                            <small>Cantidad:</small>
                        </td>
                        <td style="text-align:center">
                            <small>Costo:</small>                            
                        </td>
                        <td style="text-align:center">
                            <small>Importe:</small>                                                        
                        </td>
                </tr>
                <tr>
                        <td>
                            <asp:DropDownList ID="ddlestado" class="form-control" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align:center">
                            <asp:TextBox ID="txtclavemat" class="form-control"  runat="server" onkeyup = "SetContextKeymat()" onblur="completadatos(4);" ></asp:TextBox>
                           <asp:Panel runat="server" ID="myPanel" Height="100px" ScrollBars="Vertical" Style="overflow: hidden;
                                 width: 200px; text-overflow: ellipsis">
                             </asp:Panel> 
                                <cc1:AutoCompleteExtender ServiceMethod="qryMaterialedo"
                                MinimumPrefixLength="2" CompletionListElementID="myPanel" 
                                CompletionInterval="100" EnableCaching="false" CompletionSetCount="10" 
                                TargetControlID="txtclavemat" UseContextKey = "true" ServicePath="~/Objet/Cotiza.asmx" 
                                ID="AutoCompleteExtender4" runat="server" FirstRowSelected = "false">
                            </cc1:AutoCompleteExtender>
                        </td>
                        <td style="text-align:center" colspan="3">
                            <asp:TextBox ID="txtdescmat" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td style="text-align:center">
                            <asp:TextBox ID="txtcantidadmat" class="form-control"  runat="server" onblur="calculacosto();"></asp:TextBox>
                        </td>
                        <td style="text-align:center">
                            <asp:TextBox ID="txtcostomat" class="form-control"  runat="server" onblur="calculacosto();"></asp:TextBox>
                        </td>
                        <td style="text-align:center">
                            <asp:TextBox ID="txtimportemat" class="form-control"  runat="server" onblur="calculacosto();"></asp:TextBox>
                        </td>
                        <td style="text-align:center">
                            <asp:Button ID="btnmat" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agregamat();"></asp:Button>
                        </td>
                </tr>
            </table>
                <small>
                <asp:GridView ID="gwm" runat="server" 
                      DataKeyNames="fila,idestado" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>

                    </ContentTemplate>
                </asp:UpdatePanel>
                  <div class="box-footer" id="secguarda">
                      <asp:Button ID="Button1" runat="server" Text="Guardar" 
                          class="btn btn-info pull-right" onclientclick="return valida(2);" />
                  </div><!-- /.box-footer -->


          <ol class="breadcrumb">
            <li onclick="muestra(0);"><a ><i class="fa fa-dashboard"></i> Acciones</a></li>
            <li onclick="muestra(1);"><a ><i class="fa fa-dashboard"></i> Descarga de Materiales</a></li>
            <li onclick="muestra(2);"><a ><i class="fa fa-dashboard"></i> Bitacora</a></li>
            <li onclick="imprime();"><a ><i class="fa fa-dashboard"></i> Imprimir Ticket</a></li>
            <li onclick="mail();"><a ><i class="fa fa-dashboard"></i> Envia al Cliente Correo</a></li>
            <li onclick="limpia();"><a ><i class="fa fa-dashboard"></i> Nuevo Ticket</a></li>
          </ol>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->


          <div class="row"  id="bitacora" style="display:none;">
              <!-- general form elements -->
            <div class="col-md-11">
              <!-- Horizontal Form -->
              <div class="box box-info">
                <div class="box-header with-border">
                  <h3 class="box-title">Bitacora</h3>
                </div><!-- /.box-header -->




            <table class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                style="border-collapse: collapse; width:100%; height:80%;">
                <tr>
                    <td style="text-align:center">
                        <small>Comentarios:</small>   
                    </td>
                    <td style="text-align:center">
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center">
                        <asp:TextBox ID="txtcomentario" class="form-control"  runat="server" TextMode="MultiLine"></asp:TextBox>
                    </td>
                    <td style="text-align:center">
                        <asp:Button ID="btnbitacora" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agregabit();"></asp:Button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <small>
                        <asp:GridView ID="gvbit" runat="server" 
                                AutoGenerateColumns="False" Width="100%" >
                            <Columns>
                                <asp:BoundField DataField="Id_Ticket" HeaderText="Ticket " SortExpression="Id_Ticket" />
                                <asp:BoundField DataField="tk_bit_fecha" HeaderText="Fecha" SortExpression="tk_bit_fecha" />
                                <asp:BoundField DataField="Empleado" HeaderText="Empleado" SortExpression="Empleado" />
                                <asp:BoundField DataField="Tk_Bit_Observacion" HeaderText="Comentario" SortExpression="Tk_Bit_Observacion" />
                            </Columns>
                            </asp:GridView>
                        </small>

                    </td>
                </tr>
            </table>
          <ol class="breadcrumb">
            <li onclick="muestra(4);"><a ><i class="fa fa-dashboard"></i> Regresa</a></li>
          </ol>

              </div><!-- /.box -->
            </div><!--/.col (right) -->
        </div><!-- /.content -->



    </div>


<div id="popup1" class="modal-box">
  <div> <a class="js-modal-close close">×</a>
    <h3>Agregar Causa/Origen a la lista</h3>
  </div>
  <div class="modal-body" >
    <p>Capture la Causa u Origen que decea agregar.</p>
    <p>
        <asp:TextBox ID="txtcatcauori" class="form-control" runat="server" MaxLength="100" ></asp:TextBox>
    </p>
  </div>
  <div> <a class="btn btn-small js-modal-close" onclick="return valida(0);">Guardar</a> </div>
</div>
<div id="popup2" class="modal-box">
  <div> <a class="js-modal-close close">×</a>
    <h3>Agregar Incidencia a la lista</h3>
  </div>
  <div class="modal-body" >
    <p>Seleccione el area responsable de atender la Incidencia.</p>
    <p>
        <asp:DropDownList ID="ddlcatarearesp" class="form-control" runat="server" placeholder="Activo">
        </asp:DropDownList>
    </p>
    <p>Capture la Incidencia que decea agregar.</p>
    <p>
        <asp:TextBox ID="txtcatincidencia" class="form-control" runat="server" MaxLength="100" ></asp:TextBox>
    </p>
  </div>
  <div> <a class="btn btn-small js-modal-close" onclick="return valida(1);">Guardar</a> </div>
</div>
    <script type = "text/javascript">
        $(function () {

            var appendthis = ("<div class='modal-overlay js-modal-close'></div>");

            $('a[data-modal-id]').click(function (e) {
                e.preventDefault();
                $("body").append(appendthis);
                $(".modal-overlay").fadeTo(500, 0.7);
                //$(".js-modalbox").fadeIn(500);
                var modalBox = $(this).attr('data-modal-id');
                $('#' + modalBox).fadeIn($(this).data());
            });


            $(".js-modal-close, .modal-overlay").click(function () {
                $(".modal-box, .modal-overlay").fadeOut(500, function () {
                    $(".modal-overlay").remove();
                });

            });

            $(window).resize(function () {
                $(".modal-box").css({
                    top: ($(window).height() - $(".modal-box").outerHeight()) / 2,
                    left: ($(window).width() - $(".modal-box").outerWidth()) / 2
                });
            });

            $(window).resize();

        });
</script>


    </div>
      <footer class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01 | 
            
            <b><asp:label ID="txtfechaactual"  runat="server" placeholder="HH:mm:ss"></asp:label> </b>
           <asp:label ID="txthoraactual" runat="server" placeholder="HH:mm:ss"></asp:label>

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
