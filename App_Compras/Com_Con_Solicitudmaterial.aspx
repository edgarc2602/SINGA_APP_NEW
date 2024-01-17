<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Con_Solicitudmaterial.aspx.vb" Inherits="App_Compras_Com_Con_Solicitudmaterial" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA SOLICITUD DE MATERIALES</title>
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
        #tblista tbody td:nth-child(11), #tblista tbody td:nth-child(12){
            width:0px;
            display:none;
        }
    </style>
     <script type="text/javascript">
         var checklist = [];
         var inicial = '<option value=0>Seleccione...</option>'
         $(function () {
             $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
             $('#var1').html('<%=listamenu%>');
             $('#nomusr').text('<%=minombre%>');
             $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
             $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
             cargacliente();
             cargaproveedor();
             cargaempresa();
             cargames();
             dialog1 = $('#divmodal1').dialog({
                 autoOpen: false,
                 height: 350,
                 width: 800,
                 modal: true,
                 close: function () {
                 }
             });
             dialog2 = $('#divmodal2').dialog({
                 autoOpen: false,
                 height: 350,
                 width: 900,
                 modal: true,
                 close: function () {
                 }
             });
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
             $('#btconsulta').click(function () {
                 if ($('#txfolio').val() == '') {
                     $('#txfolio').val(0);
                 }
                 $('#hdpagina').val(1);
                 cuentaoc();
                 cargalista();
             })
             $('#btautoriza').click(function () {
                 if ($('#dlestatus1').val() == 0) {
                     alert('Debe seleccionar un estatus correcto');
                 } else {
                     PageMethods.autoriza($('#txsol1').val(), $('#dlestatus1').val(), function () {
                         alert('La requisición ha sido actualizada correctamente')
                         dialog1.dialog('close');
                         cargalista();
                     }, iferror);
                 }
             })
             $('#btguarda').click(function () {
                 waitingDialog({});
                 var xmlgraba = '<Movimiento> <salida documento="2" almacen1="0" factura="0"';
                 xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                 xmlgraba += ' orden="' + $('#txsol2').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                 $('#tbbusca tbody tr').each(function () {
                     xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"';
                     xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find('td').eq(4).text()) + '"/>';
                 });
                 xmlgraba += '</Movimiento>';
                 //alert(xmlgraba);

                 PageMethods.guarda(xmlgraba, function (res) {
                     closeWaitingDialog();
                     cargalista();
                     alert('Registro completo');
                     dialog2.dialog('close');
                 }, iferror);
             })

             $('#tblista').on('click', 'input[type="checkbox"]', function () {
                 if ($("#tblista input:checkbox:checked").length > 0) {
                     $("#btcrearequisicionselec").attr("disabled", false);                               
                 }
                 else {
                     $("#btcrearequisicionselec").attr("disabled", true);
                 }
             });

             $('#btcrearequisicionselec').click(function () {
                 if (validasel()) {
                     checklist = [];

                     $("#tblista tbody tr input:checkbox:checked").each(function () {
                         checklist.push($(this).attr("id_sol"));
                     });

                     crearequisicion();
                 }

             });

             $('#btcrearequisicioncon').click(function () {

                 checklist = [];

                 $("#idtipocarga").val(1);


                 $("#tblistasol tbody tr input:checkbox:checked").each(function () {
                     checklist.push($(this).attr("id_sol"));
                 });

                 crearequisicion();

             });

             $('#btmodalrequisicioncon').click(function () {
                 if (validacon()) {

                     $("#idtipocarga").val(2);

                     $("#divmodal2").dialog('option', 'title', 'Seleccionar datos para concentrado');
                     dialog2.dialog('open');

                     cargaconcentrado();
                 }
             });

             $('#btbuscac').click(function () {
                 if (validac()) {
                     //cargaconcentrado();

                     //$('#cargaconc').val(1);
                 }
             });

             if ($("#idusuario").val() != "131" && $("#idusuario").val() != "1" && $("#idusuario").val() != "20481") {
                 $('#divrequisicion').hide();
             }
         });

         function crearequisicion() {
            if (checklist.length > 0) {
                PageMethods.crearequisicion(checklist.join(','), $("#dlempresa").val(), $("#dltipo").val(), $("#dlproveedor").val(), $("#txanio1").val(), $("#dlmes1").val(),
                $("#dlcliente1").val(), $("#dlforma").val(), $("#dliva").val(), $("#idusuario").val(), $("#idtipocarga").val(), function (res) {
                    alert("Se creó correctamente la requisición " + res);
                    location.reload()
                }, iferror);
            }
            else {
                alert("Debes seleccionar al menos una solicitud para crear la requisición.");
            }
         }

         function validacon() {
             if ($('#dlempresa').val() == 0) {
                 alert('Debes elegir una Empresa');
                 return false;
             }
             if ($('#dltipo').val() == 0) {
                 alert('Debes elegir un Tipo');
                 return false;
             }
             if ($('#dlproveedor').val() == 0) {
                 alert('Debes elegir un Proveedor');
                 return false;
             }
             if ($('#txanio1').val() == "") {
                 alert('Debe ingresar año');
                 return false;
             }
             if ($('#dlmes1').val() == 0) {
                 alert('Debe elegir un mes');
                 return false;
             }
             if ($('#dlpago').val() == 0) {
                 alert('Debe elegir una forma de pago');
                 return false;
             }
             if ($('#dliva').val() == 0) {
                 alert('Debe elegir un valor de IVA');
                 return false;
             }
             return true;
         }

         function validasel() {
             if ($('#dlempresa').val() == 0) {
                 alert('Debes elegir una Empresa');
                 return false;
             }
             if ($('#dltipo').val() == 0) {
                 alert('Debes elegir un Tipo');
                 return false;
             }
             if ($('#dlproveedor').val() == 0) {
                 alert('Debes elegir un Proveedor');
                 return false;
             }
             if ($('#txanio1').val() == "") {
                 alert('Debe ingresar año');
                 return false;
             }
             if ($('#dlmes1').val() == 0) {
                 alert('Debe elegir un mes');
                 return false;
             }
             if ($('#dlpago').val() == 0) {
                 alert('Debe elegir una forma de pago');
                 return false;
             }
             if ($('#dliva').val() == 0) {
                 alert('Debe elegir un valor de IVA');
                 return false;
             }
             return true;
         }

         function cargames() {
             PageMethods.mes(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlmes').append(inicial);
                 $('#dlmes').append(lista);
                 $('#dlmes1').append(inicial);
                 $('#dlmes1').append(lista);

             }, iferror);
         }
         function cargaempresa() {
             PageMethods.empresa(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlempresa').empty();
                 $('#dlempresa').append(inicial);
                 $('#dlempresa').append(lista);
             }, iferror);
         }
         function cargaconcentrado() {
             PageMethods.concentrado($('#dlproveedor').val(), $('#dlcliente').val(), $('#txanio1').val(), $('#dlmes1').val(), $('#hdpagina').val(), function (res) {
                 closeWaitingDialog();

                 var ren1 = $.parseHTML(res);
                 $('#tblistasol tbody').remove();
                 $('#tblistasol').append(ren1);
                 $('#tblistasol tbody tr').change('.tbeditar', function () {
                    
                 });
                 $('#tblistasol').delegate("tr .btquita", "click", function () {
                    
                 });
                 PageMethods.comprador($('#dlcliente').val(), 0, function (detalle) {
                     var datos = eval('(' + detalle + ')');
                     $('#idcomprador').val(datos.id);
                     $('#txcomprador').val(datos.nombre);
                 })

                 $('#dltipo').val(1);
                 dialog2.dialog('close');
             }, iferror)
         }

         function cuentaoc() {
             PageMethods.contarsolicitud($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlestatus').val(), $('#txfolio').val(), function (cont) {
                 $('#paginacion li').remove();
                 var opt = eval('(' + cont + ')');
                 var pag = '';
                 for (var x = 1; x <= opt[0].pag; x++) {
                     pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                 }
                 $('#paginacion').append(pag);
             }, iferror);
         }
         function cargalista() {
             //alert($('#dlarea').val());
             //waitingDialog({});
             PageMethods.solicitudes($('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlestatus').val(), $('#hdpagina').val(), $('#txfolio').val(), $('#idusuario').val(), function (res) {
                 //closeWaitingDialog();
                 var ren = $.parseHTML(res);
                 if (ren == null) {
                     $('#tblista tbody').remove();
                     alert('No se han encontrado registros con los criterios seleccionado');
                 }
                 else {
                     $('#tblista tbody').remove();
                     $('#tblista').append(ren);
                     $('#tblista tbody tr').delegate(".btimprime", "click", function () {
                         window.open('../RptForAll.aspx?v_nomRpt=solicitudmaterial.rpt&v_formula={tb_solicitudmaterial.id_solicitud}= ' + $(this).closest('tr').find('td').eq(0).text() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                     });
                     $('#tblista tbody tr').delegate(".btedita", "click", function () {
                        if ($(this).closest('tr').find('td').eq(4).text() != 'Alta') {
                            window.open('Com_Pro_Solicitudmaterial.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                        } else {
                            alert('El estatus actual de la solicitud no permite realizar cambios, verifique');
                        }
                     });
                     $('#tblista tbody tr').delegate(".btauto", "click", function () {
                         if ($('#idusuario').val() == 59 || $('#idusuario').val() == 81 || $('#idusuario').val() == 1) {
                            if ($(this).closest('tr').find('td').eq(4).text() == 'Alta' || $(this).closest('tr').find('td').eq(4).text() == 'Rechazada') {
                                $('#txsol1').val($(this).closest('tr').find('td').eq(0).text());
                                $("#divmodal1").dialog('option', 'title', 'Autorizar/Rechazar');
                                dialog1.dialog('open');
                            } else {
                                alert('El estatus actual de la solicitud no permite realizar cambios, verifique');
                            }
                         } else {
                             alert('Usted no tiene permisos para autorizar/rechazar solicitudes, verifique');
                         }
                     });
                     $('#tblista tbody tr').delegate(".btdespacha", "click", function () {
                         if ($('#idusuario').val() == 1 || $('#idusuario').val() == 10248 || $('#idusuario').val() == 10249 || $('#idusuario').val() == 10250) {
                             if ($(this).closest('tr').find('td').eq(4).text() == 'Autorizada') {
                                 //alert($(this).closest('tr').find('td').eq(12).text());
                                 $('#txsol2').val($(this).closest('tr').find('td').eq(0).text());
                                 $('#idalmacen').val($(this).closest('tr').find('td').eq(10).text());
                                 $('#idcliente').val($(this).closest('tr').find('td').eq(11).text());
                                 PageMethods.detalles($(this).closest('tr').find('td').eq(0).text(), function (res) {
                                     //closeWaitingDialog();
                                     var ren = $.parseHTML(res);
                                     $('#tbbusca tbody').remove();
                                     $('#tbbusca').append(ren);
                                     $('#tbbusca tbody tr').delegate(".txcant", "focusout", function () {
                                         if (parseFloat($(this).closest('tr').find("input:eq(0)").val()) > parseFloat($(this).closest('tr').find('td').eq(5).text())) {
                                             alert('No puede despachar cantidad mayor superior al disponible');
                                             $(this).closest('tr').find("input:eq(0)").val(parseFloat($(this).closest('tr').find('td').eq(3).text()))
                                             $(this).closest('tr').find("input:eq(0)").focus();
                                         }
                                     });
                                     $("#divmodal2").dialog('option', 'title', 'Despacho de materiales');
                                     dialog2.dialog('open');
                                 });
                             } else {
                                 alert('Solo se puede despachar solicitudes autorizadas');
                             }
                         } else {
                             alert ('Usted no esta autorizado para ejecutar despachos.');
                         }
                         
                     });
                 }
             }, iferror);
         }
         function cargacliente() {
             PageMethods.cliente(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlcliente').empty();
                 $('#dlcliente').append(inicial);
                 $('#dlcliente').append(lista);
                 if ($('#idcliente').val() != 0) {
                     $('#dlcliente').val($('#idcliente').val());
                 }
                 $('#dlcliente').change(function () {
                     PageMethods.comprador($('#dlcliente').val(), 0, function (detalle) {
                         var datos = eval('(' + detalle + ')');
                         $('#idcomprador').val(datos.id);
                         $('#txcomprador').val(datos.nombre);
                     })
                     cargainmueble($('#dlcliente').val());
                 })
                 $('#dlcliente1').empty();
                 $('#dlcliente1').append(inicial);
                 $('#dlcliente1').append(lista);
             }, iferror);
         }

         function cargaproveedor() {
             PageMethods.catproveedor(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlproveedor').empty();
                 $('#dlproveedor').append(inicial);
                 $('#dlproveedor').append(lista);


                 $('#dlproveedor1').empty();
                 $('#dlproveedor1').append(inicial);
                 $('#dlproveedor1').append(lista);
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idtipocarga" runat="server" Value="0" />
        <asp:HiddenField ID="checklist" runat="server" Value="" />
        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home1.aspx" class="logo">
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
                    <h1>Consultar Solicitudes de Material de Mantenimiento<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Solicitud</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txfolio">Solicitud:</label>
                                    <input type="text" id="txfolio" class="form-control" value="0" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txfecini">F. inicial:</label>
                                    <input type="text" id="txfecini" class="form-control" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txfecfin">F. final:</label>
                                    <input type="text" id="txfecfin" class="form-control" />
                                </div>
                                 <div class="col-lg-3">
                                    <label for="dlcliente">Cliente:</label>
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label for="dlestatus">Estatus:</label>
                                    <select id="dlestatus" class="form-control">
                                        <option value="1">Alta</option>
                                        <option value="6">En requisición</option>
                                    </select>
                                </div>
                                 <div class="col-lg-1">
                                    <input style="margin-top:20px;"" type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <hr />

                            <div id="divrequisicion">
                                <div class="row" style="margin-top:20px;">
                                    <div class="col-lg-3">
                                        <label for="dlempresa">Empresa:</label>
                                        <select id="dlempresa" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="dltipo">Tipo:</label>
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Entrega mensual</option>
                                            <option value="2">Solicitado por el cliente</option>
                                        </select>
                                    </div>
                                     <div class="col-lg-3">
                                        <label for="dlproveedor">Proveedor:</label>
                                        <select id="dlproveedor" class="form-control"></select>
                                    </div>
                                     <div class="col-lg-1">
                                        <label for="txanio">Año:</label>
                                        <input type="text" id="txanio1" class="form-control"/>
                                    </div>
                                     <div class="col-lg-1">
                                        <label for="dlmes">Mes:</label>
                                        <select id="dlmes1" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row" style="margin-top:20px;">
                                     <div class="col-lg-3">
                                        <label for="dlproveedor">Cliente:</label>
                                        <select id="dlcliente1" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="dlproveedor">Pago:</label>
                                        <select id="dlforma" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Credito</option>
                                            <option value="2">Contado</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="dlproveedor">Iva:</label>
                                        <select id="dliva" class="form-control">
                                            <option value="0.08">8 %</option>
                                            <option value="0.16" selected="selected">16 %</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-5">

                                        <button id="btcrearequisicionselec" class="btn btn-primary" style="margin-right:20px; margin-top:20px;" disabled type="button">Crear Requisición De Selección</button>
                                    </div>                                
                                </div>
                            </div>
                            
                        </div>
                    </div>

                    <div class="tbheader" style="height: 300px; overflow-y: scroll;">
                        <table class=" table table-condensed h6" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Solicitud</th>
                                    <th class="bg-light-blue-active">F. Alta</th>
                                    <%--<th class="bg-light-blue-active">Almacen</th>--%>
                                    <th class="bg-light-blue-active">Cliente</th>
                                    <th class="bg-light-blue-active">Estatus</th>
                                    <th class="bg-light-blue-active">Requisición</th>
                                    <th class="bg-light-blue-active">Solicitado por</th>
                                    <th class="bg-light-blue-active">Valor</th>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active"></th>
                                    
                                </tr>
                            </thead>
                        </table>
                    </div>
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
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txsol1">No. Solicitud</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class=" form-control" id="txsol1" disabled="disabled" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlestatus1">Estatus</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlestatus1" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="2">Autorizar</option>
                                        <option value="5">Rechazar</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
                                </div>
                            </div>
                        </div>
                    </div>
                   <div id="divmodal2">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-12">
                                    <input type="button" class="btn btn-primary pull-right" value="Crear Requisición" id="btcrearequisicioncon" />
                                </div>
                            </div>

                            <div class="tbheader" style="height: 300px; overflow-y: scroll;">
                                <table class=" table table-condensed h6" id="tblistasol">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-active">Solicitud</th>
                                            <th class="bg-light-blue-active">Solicitante</th>
                                            <th class="bg-light-blue-active">Valor</th>
                                            <th class="bg-light-blue-active"></th>

                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
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
