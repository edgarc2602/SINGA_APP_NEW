﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Provisionfactura.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Provisionfactura" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>PROVISION DE FACTURAS</title>
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
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            cargafacturas();
            $('#btguarda').click(function () {
                if (validareg()) {
                    //waitingDialog({});
                    
                    var xmlgraba = '';
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        if ($('#tblista tbody tr').eq(x).find('input').eq(0).is(':checked')) {
                            var fec1 = $('#tblista tbody tr').eq(x).find('td').eq(7).text().split('/');
                            var ffac = fec1[2] + fec1[1] + fec1[0];
                            var fec2 = $('#tblista tbody tr').eq(x).find('td').eq(9).text().split('/');
                            var fven = fec2[2] + fec2[1] + fec2[0];

                            xmlgraba += '<partida proveedor= "' + $('#tblista tbody tr').eq(x).find('td').eq(11).text() + '" docto ="' + $('#tblista tbody tr').eq(x).find('td').eq(1).text() + '" factura= "' + $('#tblista tbody tr').eq(x).find('td').eq(6).text() + '"';
                            xmlgraba += ' sub= "' + $('#tblista tbody tr').eq(x).find('td').eq(3).text() + '"  iva = "' + $('#tblista tbody tr').eq(x).find('td').eq(4).text() + '" total = "' + $('#tblista tbody tr').eq(x).find('td').eq(5).text() + '" ';
                            xmlgraba += ' ffac="' + ffac + '" fvence="' + fven + '" recepcion= "' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" />'
                        }
                    }
                    //alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, function () {
                        //closeWaitingDialog();
                        alert('Registro completado');
                        cargafacturas();
                    }, iferror)
                }
            })
        })
        function validareg() {
            return true;
        }
        function cargafacturas() {
            PageMethods.facturas( function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    //alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').delegate(".btimprime", "click", function () {
                        window.open('../RptForAll.aspx?v_nomRpt=ordencompra.rpt&v_formula={tb_ordencompra.id_orden}= ' + $(this).closest('tr').find('td').eq(0).text() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                    });
                    $('#tblista tbody tr').delegate(".btedita", "click", function () {
                        if ($(this).closest('tr').find('td').eq(5).text() == 'Alta') {
                            window.open('Com_Pro_ordencompra.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                        } else {
                            alert('El estatus actual de la orden de compra no permite realizar cambios, verifique');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btrecibe", "click", function () {
                        if ($(this).closest('tr').find('td').eq(5).text() == 'Alta') {
                            if ($(this).closest('tr').find('td').eq(12).text() == '1') {
                                window.open('Com_Pro_recepcion.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                            } else {
                                window.open('Com_Pro_recepcione.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                            }

                        } else {
                            alert('El estatus actual de la orden de compra no permite realizar cambios, verifique');
                        }
                    });
                }
            }, iferror);
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <h1>Provisión de facturas<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Provisión</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                        </div>
                        <div class="tbheader" style="height: 300px; overflow-y: scroll;">
                            <table class=" table table-condensed h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-active">Recepción</th>
                                        <th class="bg-light-blue-active">Orden de compra</th>
                                        <th class="bg-light-blue-active">Proveedor</th>
                                        <th class="bg-light-blue-active">Subtotal</th>
                                        <th class="bg-light-blue-active">IVA</th>
                                        <th class="bg-light-blue-active">Total</th>
                                        <th class="bg-light-blue-active">Factura</th>
                                        <th class="bg-light-blue-active">F. Factura</th>
                                        <th class="bg-light-blue-active">Credito</th>
                                        <th class="bg-light-blue-active">F. Vencimiento</th>
                                        <th class="bg-light-blue-active">Aplicar</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Volver a cargar</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Aplicar Provisión</a></li>
                            <!--<li id="btexporta"  class="puntero"><a ><i class="fa fa-print"></i>Exportar a excel</a></li>-->
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>