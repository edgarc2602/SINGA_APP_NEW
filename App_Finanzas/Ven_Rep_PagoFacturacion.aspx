﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Rep_PagoFacturacion.aspx.vb" Inherits="Ventas_App_Ven_Rep_PagoFacturacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REPORTE PAGOS FACTURACIÓN POR CLIENTE</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function ()
        {
            setTimeout(function ()
            {
                if (screen.width > 740)
                {
                    $("#menu").click();
                }
            }, 50);

            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txcontrato').append(inicial);
            cargacliente();
                      
            dialog1 = $('#divmodal1').dialog(
            {
                autoOpen: false,
                height: 250,
                width: 800,
                modal: true,
                close: function () {
                }
            });
           
            $('#btimprime').click(function ()
            {
                if (valida())
                {
                    var fini = $('#txfecini').val().split('/');
                    var ffin = $('#txfecfin').val().split('/');
                    var formula = '';
                    formula = '{tb_factura.fecha_emision_docto} in Date (' + fini[2] + ' , ' + fini[1] + ' , ' + fini[0] + ') to Date (' + ffin[2] + ' , ' + ffin[1] + ' , ' + ffin[0] + ')';
                    if ($('#dlcliente').val() != 0) {
                        formula += ' and {tb_cliente.id_cliente} =' + $('#dlcliente').val() 
                    }
                    //console.log(formula);
                    window.open('../RptForAll.aspx?v_nomRpt=facturacionpago.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            })
        });
        function cargacliente()
        {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').val(0);
            }, iferror);
        }

        function valida() {
            if ($('#txfecini').val() == '')
            {
                alert('Debe seleccionar fecha de inicio.');
                return false;
            }
            if ($('#txfecfin').val() == '')
            {
                alert('Debe seleccionar fecha final.');
                return false;
            }            
            return true;
        }

        function waitingDialog(waiting)
        { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog()
        {
            $("#loadingScreen").dialog('close');
        }

        function iferror(err)
        {
            alert('ERROR ' + err._message);
        };
    </script>
    <style type="text/css">
        .auto-style1 {
            color: #444;
            display: block;
            padding: 10px;
            position: relative;
            left: 0px;
            top: 0px;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idfolio" runat="server" />
        <div class="wrapper">
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
                                    <span class="hidden-xs" id="nomusr"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="main-sidebar">
                <!-- sidebar: style can be found in sidebar.less -->
                <div class="sidebar" id="var1">
                    <!-- sidebar menu: : style can be found in sidebar.less -->
                    <%--<%=listamenu%>--%>
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Reporte de pagos por Cliente<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li>Finanzas</li>
                        <li class="active">Pagos</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="auto-style1">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">F. inicial:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">F. final:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-3" >
                                    <input type="button" id="btimprime" class="btn btn-primary" value="Imprimir" />
                                </div>
                            </div>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>