<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Empleado_act.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Empleado_act" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Confirmación de Empleados</title>
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
    <style>
        .cb{
            width: 30px; 
            height: 30px; 
        }
        
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
         $(function () {
             $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
             $('#var1').html('<%=listamenu%>');
             $('#nomusr').text('<%=minombre%>');
             $('#txarchivo').prop('disabled', true);
             $('#dlbanco').prop('disabled', true);
             $('#txcuenta').prop('disabled', true);
             setTimeout(function () {
                 $("#menu").click();
             }, 50);
             $('#dvdatos').hide();
             cargabancos();
             cuentaempleado();
             cargalista();
             $("#loadingScreen").dialog({
                 autoOpen: false,    // set this to false so we can manually open it
                 dialogClass: "loadingScreenWindow",
                 closeOnEscape: false,
                 draggable: false,
                 width: 460,
                 minHeight: 50,
                 modal: true,
                 buttons: {},
                 resizable: false,
                 open: function () {
                     // scrollbar fix for IE
                     $('body').css('overflow', 'hidden');
                 },
                 close: function () {
                     // reset overflow
                     $('body').css('overflow', 'auto');
                 }
             });
             $('#btlista').click(function () {
                 cargalista();
                 $('#tblista').show();
                 $('#dvdatos').hide();
             })
             $("#txcuenta").keydown(function (e) {
                 if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                     (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                     (e.keyCode >= 35 && e.keyCode <= 40)) {
                     return;
                 }
                 if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                     e.preventDefault();
                 }
             });
             $('#cbconfirma').click(function () {
                 if ($("#cbconfirma").is(':checked')) {
                     $('#txarchivo').prop('disabled', false);
                     $('#dlbanco').prop('disabled', false);
                     $('#txcuenta').prop('disabled', false);
                 } else {
                     $('#txarchivo').prop('disabled', true);
                     $('#dlbanco').prop('disabled', true);
                     $('#txcuenta').prop('disabled', true);
                 }  
             })
         });
        function cuentaempleado() {
            PageMethods.contarempleado( function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }

        function cargabancos() {
            PageMethods.banco(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlbanco').append(inicial);
                $('#dlbanco').append(lista);
                $('#dlbanco').val(0);
            }, iferror);
        }
        function cargalista() {
            PageMethods.empleados($('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista tbody tr').on('click', function () {
                    $('#txcliente').val($(this).children().eq(0).text());
                    $('#txsucursal').val($(this).children().eq(1).text());
                    $('#txidemp').val($(this).children().eq(3).text());
                    $('#txnombre').val($(this).children().eq(4).text());
                    $('#txrfc').val($(this).children().eq(5).text());
                    $('#txcurp').val($(this).children().eq(6).text());
                    $('#txss').val($(this).children().eq(7).text());
                    $('#txfecha').val($(this).children().eq(11).text());
                    $('#txbanco').val($(this).children().eq(8).text());
                    $('#txcuentar').val($(this).children().eq(9).text());
                    $('#txtarjeta').val($(this).children().eq(10).text());
                    limpia();
                    $('#txcuenta').val($(this).children().eq(9).text());
                    $('#tblista').hide();
                    $('#dvdatos').show();
                });
            }, iferror);
        }
        function limpia() {
            $("#cbconfirma").prop('checked', false) ;
            $('#txarchivo').val('');
            $('#txcuenta').val('');
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function xmlUpFile(res) {
            if (valida()) {
                waitingDialog({});
                var fileup = $('#txarchivo').get(0);
                var files = fileup.files;
                
                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                ndt.append('nmr', res);
                $.ajax({
                    url: '../GH_UpXLS.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function (res) {
                        PageMethods.actualiza($('#txidemp').val(), $('#txcuenta').val(), res, function (res) {
                            alert('Registro actualizado correctamente');
                            cuentaempleado();
                            cargalista();
                            $('#tblista').show();
                            $('#dvdatos').hide();
                            closeWaitingDialog();
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
        }
        function valida() {
            if ($("#cbconfirma").prop('checked') == false) {
                alert('Debe activar confirmar alta ante IMSS');
                return false;
            }
            if ($('#txarchivo').val() == '') {
                alert('Debe seleccionar el archivo del alta ante el IMSS');
                return false;
            }
            if ($('#txcuenta').val() == '') {
                alert('Debe capturar el numero de cuenta');
                return false;
            }
            /*if ($('#dlbanco').val() == 0) {
                alert('Debe seleccionar el Banco correcto');
                return false;
            }
            */
            return true;
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="tipomov" runat="server" />
        <asp:HiddenField ID="idsucursal" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
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
                    <h1>Confirmación de Empleado<small>Confirmación</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Confirmación</a></li>
                        <li class="active">Confirmar de Empleado</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="col-md-12">
                        <div class="box box-info">
                            <!-- Horizontal Form -->
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="col-md-18 tbheader" id="tblista">
                                <table class="table table-condensed h6">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                            <th class="bg-light-blue-gradient"><span>Tipo</span></th>
                                            <th class="bg-light-blue-gradient"><span>No. Empleado</span></th>
                                            <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                            <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                            <th class="bg-light-blue-gradient"><span>CURP</span></th>
                                            <th class="bg-light-blue-gradient"><span>No. SS</span></th>
                                            <th class="bg-light-blue-gradient"><span>banco</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cuenta</span></th>
                                            <th class="bg-light-blue-gradient"><span>tarjeta</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Ingreso</span></th>                                         
                                        </tr>
                                    </thead>
                                </table>
                                <nav aria-label="Page navigation example" class="navbar-right">
                                    <ul class="pagination justify-content-end" id="paginacion">
                                        <li class="page-item disabled">
                                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                                        </li>
                                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                                        <li class="page-item">
                                            <a class="page-link" href="#">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                            <div id="dvdatos">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcliente">Cliente:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txsucursal">Punto de atención:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txsucursal" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txidemp">No. Empleado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txidemp" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrfc">RFC:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txrfc" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txcurp">CURP:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcurp" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txss">No. SS:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txss" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txfecha">Fecha Ingreso:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txbanco">Banco:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txbanco" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcuentar">Cuenta registrada:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcuentar" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txtarjeta">Tarjeta registrada:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txtarjeta" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <hr />
                                <div class="row" id="dvconfirma">
                                    <div class="row">
                                        <div class="col-lg-6 text-center">
                                            <input type="checkbox" id="cbconfirma" class="cb"/><label for="cbconfirma" style="font-size:20px;">Confirmar alta ante el IMSS</label>
                                        </div>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dlbanco">Cargar alta del IMSS:</label>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-6">
                                            <input type="file" class="form-control" id="txarchivo"/>
                                        </div>
                                    </div>
                                    
                                    <!--<div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="dlbanco">Banco correcto:</label>
                                        </div>
                                        <div class="col-lg-3">
                                            <select id="dlbanco" class="form-control"></select>
                                        </div>
                                    </div>  
                                    -->
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcuenta">Confirmar cuenta para pago:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcuenta" class="form-control" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btguarda" class="puntero" onclick="xmlUpFile()"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                    <!--<li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Salir</a></li>-->
                                </ol>
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
