<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_SolicitudmaterialMantto.aspx.vb" Inherits="App_Almacen_Alm_Pro_SolicitudmaterialMantto" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>SOLICITUD DE MATERIALES MANTENIMIENTO</title>
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
    <style type="text/css">
        .container {
            display: block;
            position: relative;
            padding-left: 35px;
            margin-bottom: 12px;
            font-size: 14px;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }
        /* Hide the browser's default checkbox */
        .container input {
          position: absolute;
          opacity: 0;
          cursor: pointer;
          height: 0;
          width: 0;
        }
        /* Create a custom checkbox */
        .checkmark {
          position: absolute;
          top: 0;
          left: 0;
          height: 25px;
          width: 25px;
          background-color: #eee;
        }
        /* On mouse-over, add a grey background color */
        .container:hover input ~ .checkmark {
          background-color: #ccc;
        }

        /* When the checkbox is checked, add a blue background */
        .container input:checked ~ .checkmark {
          background-color: #2196F3;
        }

        /* Create the checkmark/indicator (hidden when not checked) */
        .checkmark:after {
          content: "";
          position: absolute;
          display: none;
        }

        /* Show the checkmark when checked */
        .container input:checked ~ .checkmark:after {
          display: block;
        }

        /* Style the checkmark/indicator */
        .container .checkmark:after {
          left: 9px;
          top: 5px;
          width: 5px;
          height: 10px;
          border: solid white;
          border-width: 0 3px 3px 0;
          -webkit-transform: rotate(45deg);
          -ms-transform: rotate(45deg);
          transform: rotate(45deg);
        }
    </style>
     <script type="text/javascript">
         var inicial = '<option value=0>Seleccione...</option>'
         $(function () {
             $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
             $('#var1').html('<%=listamenu%>');
             $('#nomusr').text('<%=minombre%>');
             $('#txfecha1').datepicker({ dateFormat: 'dd/mm/yy' });
             cargaalmacen(1);
             cargaalmacen(2);
             cargacliente();
             cargatecnico();
             dialog1 = $('#divmodal1').dialog({
                 autoOpen: false,
                 height: 350,
                 width: 800,
                 modal: true,
                 close: function () {
                 }
             });
             var f = new Date();
             var dd = f.getDate()
             if (dd.toString().length == 1) {
                 dd = "0" + dd
             }
             var mm = f.getMonth() + 1
             if (mm.toString().length == 1) {
                 mm = "0" + mm
             }
             $('#dlsucursal').append(inicial);
             $('#idcliente').val(0);
             $('#dlcliente').append(inicial);

             $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear()
             );

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

             $('#btbusca').click(function () {
                 $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                 dialog1.dialog('open');
             })
             $('#btbuscap').click(function () {
                 if ($('#dlalmacen').val() != 0)
                     if ($('#dltipo').val() != 0) {
                         PageMethods.productol(($('input:radio[name=dltipo]:checked').val()), $('#txbusca').val(), function (res) {
                             var ren1 = $.parseHTML(res);
                             $('#tbbusca tbody').remove();
                             $('#tbbusca').append(ren1);
                             $('#tbbusca tbody tr').click(function () {
                                 $('#txclave').val($(this).children().eq(0).text());
                                 $('#txdesc').val($(this).children().eq(1).text());
                                 $('#txunidad').val($(this).children().eq(2).text());
                                 $('#txprecio').val($(this).children().eq(3).text());
                                 dialog1.dialog('close');
                             });
                         }, iferror)
                     } else {
                         alert('Debe elegir un tipo');
                     }
             })

             $('#btagrega').click(function () {
                 if (validamat()) {
                     var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                     linea += '<input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                     $('#tblistaj tbody').append(linea);
                     $('#tblistaj').delegate("tr .btquita", "click", function () {
                         $(this).parent().eq(0).parent().eq(0).remove();
                         total();
                     });
                     $('#tblistaj tbody tr').change('.tbeditar', function () {
                         alert($(this).closest('tr').find('td').eq(4).text());
                         if (parseFloat($(this).closest('tr').find("input:eq(0)").val()) > parseFloat($(this).closest('tr').find('td').eq(4).text())) {
                             alert('No puede solicitar cantidad mayor a disponible');
                             $(this).closest('tr').find("input:eq(0)").val(0);
                             $(this).closest('tr').find("input:eq(0)").focus();
                         } else {
                             var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                             $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                             total();
                         }

                     });
                     total();
                     limpiaproducto();
                 }
             })
             $('#txcantidad').change(function () {
                 subtotal();
             })
             $('#btnuevo').click(function () {
                 location.href = " Alm_Pro_SolicitudmaterialMantto.aspx ";

             })
             $('#txfecha1').change(function () {
                 $('#btherramientas tbody').remove(); {
                     $('#hdpagina').val(1);
                 }
             })

             $('#btguarda').click(function () {
                 if (valida()) {
                     waitingDialog({});
                     alert('');
                     var fecha = $('#txfecha1').val().split('/');
                     var devolucion = fecha[2] + fecha[1] + fecha[0];
                     var xmlgraba = '<movimiento> <solicitud id="' + $('#txfolio').val() + '" tecnico="' + $('#dltecnico').val() + '" id_servicio="1"';
                     xmlgraba += ' almacen="' + $('#dlalmacen').val() + '" almacen1="' + $('#dlalmacen1').val() + '" cliente="' + $('#dlcliente').val() + '" id_inmueble="' + $('#dlsucursal').val() + '" usuario="' + $('#idusuario').val() + '" observacion="' + $('#txobservacion').val() + '" id_clave_cm="' + $('#txclavecm').val() + '"';
                     var herramientas = $("input[name='dltipo']:checked").val();
                     if (herramientas == 2) {
                         xmlgraba += ' devolucion="' + devolucion + '" id_tipo="2"' + '/>';
                     }
                     else {
                         xmlgraba += ' devolucion="' + '" id_tipo="1"' + '/>';
                     }
                     
                     $('#tblistaj tbody tr').each(function () {
                         xmlgraba += '<partida clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"';
                         xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find("input:eq(1)").val()) + '" total="' + parseFloat($(this).closest('tr').find("input:eq(2)").val()) + '"/>'
                     })
                     xmlgraba += '</movimiento>';
                     //alert(xmlgraba);
                     PageMethods.guarda(xmlgraba, function (res) {
                         closeWaitingDialog();
                         $('#txfolio').val(res);
                         alert('Registro completado');

                     }, iferror);
                 }
             });
            
             $('#txclave').change(function () {
                 if ($('#dlalmacen').val() != 0) {
                     cargaproducto($('#txclave').val());
                 } else {
                     alert('Primero debe elegir un almacén');   
                     $('#txclave').val('');
                     $('#txclave').focus();
                 }
             })
             if ($('#idsol').val() != 0) {
                 cargasolicitud();
             }
         })
         function cargatecnico() {
             PageMethods.tecnico(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 }
                 $('#dltecnico').empty();
                 $('#dltecnico').append(inicial);
                 $('#dltecnico').append(lista);
                 if ($('#idtecnico').val() != 0) {
                     $('#dltecnico').val($('#idtecnico').val());
                 }
             }, iferror);
         }

         function cargasolicitud() {
             $('#txfolio').val($('#idsol').val());
             PageMethods.solicitud($('#idsol').val(), function (detalle) {
                 var datos = eval('(' + detalle + ')');
                 $('#idalmacen').val(datos.almacen);
                 cargaalmacen(1);
                 $('#idalmacen1').val(datos.almacen1);
                 cargaalmacen(2);
                 $('#idcliente').val(datos.cliente);
                 cargacliente();
                 $('#txfecha').val(datos.fecha);
                 $('#txclavecm').val(datos.cm);
                 $('#txobservacion').val(datos.observacion);
                 $('#idinmueble').val(datos.inmueble);
                 cargainmueble(datos.cliente);
                 $('#idtecnico').val(datos.tecnico);
                 cargatecnico();
                 $('#txestatus').val(datos.status);
                 if (datos.tipo == "1") {
                     $('#btmateriales').prop("checked", true);
                 } else { $('#btherramientas').prop("checked", true); }
                 ShowHideDiv();
                 $('#txfecha1').val(datos.fdevolucion);
                 detallesol($('#idsol').val());

             }, iferror);
         }
         function detallesol(folio) {
             PageMethods.cargadetalle(folio, function (res) {
                 var ren1 = $.parseHTML(res);
                 $('#tblistaj tbody').remove();
                 $('#tblistaj').append(ren1);
                 $('#tblistaj tbody tr').change('.tbeditar', function () {
                     alert($(this).closest('tr').find('td').eq(4).text());
                     if (parseFloat($(this).closest('tr').find("input:eq(0)").val()) > parseFloat($(this).closest('tr').find('td').eq(4).text())) {
                         alert('No puede solicitar cantidad mayor a disponible');
                         $(this).closest('tr').find("input:eq(0)").val(0);
                         $(this).closest('tr').find("input:eq(0)").focus();
                         total();
                     } else {
                         var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                         $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                         total();
                     }
                 });
                 $('#tblistaj').delegate("tr .btquita", "click", function () {
                     $(this).parent().eq(0).parent().eq(0).remove();
                     total();
                 });
                 total();
             }, iferror)
         }
         function cargaproducto(clave) {
             PageMethods.producto(clave, function (detalle) {
                 var datos = eval('(' + detalle + ')');
                 if (datos.clave != '0') {
                     $('#txclave').val(datos.clave);
                     $('#txdesc').val(datos.producto);
                     $('#txunidad').val(datos.unidad);
                     $('#txprecio').val(datos.precio);
                     $('#txcantidad').focus();
                 } else {
                     alert('La clave de producto capturada no existe, verifique');
                     limpiaproducto();
                 }
             }, iferror)
         }
         function valida() {

             if ($('#dltecnico').val() == 0) {
                 alert('Debe elegir un tecnico');
                 return false;
             }
             if ($('#dlalmacen').val() == 0) {
                 alert('Debe elegir un almacén');
                 return false;
             }
             if ($('#dlalmacen1').val() == 0) {
                 alert('Debe elegir un almacén');
                 return false;
             }
             if ($('#dlcliente').val() == 0) {
                 alert('Debe elegir el cliente al que se entrega el material');
                 return false;
             }
             /*
             if ($('#dlalmacen').val() == 0) {
                 alert('Debe elegir el almacén');
                 return false;
             }*/
             if ($('#tblistaj tbody tr').length == 0) {
                 alert('Debe capturar al menos un material');
                 return false;
             }
             return true;
         }
         function limpiaproducto() {
             $('#txclave').val('');
             $('#txdesc').val('');
             $('#txunidad').val('');
             $('#txdisp').val('');
             $('#txprecio').val('');
             $('#txcantidad').val('');
             $('#txtotal').val('');
         }
         function cargaalmacen(tipo) {
             PageMethods.almacen(tipo, function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 if (tipo == 1) {
                     $('#dlalmacen').empty();
                     $('#dlalmacen').append(inicial);
                     $('#dlalmacen').append(lista);
                     if ($('#idalmacen').val() != 0) {
                         $('#dlalmacen').val($('#idalmacen').val());
                     }
                 }
                 else {
                     $('#dlalmacen1').empty();
                     $('#dlalmacen1').append(inicial);
                     $('#dlalmacen1').append(lista);
                     if ($('#idalmacen1').val() != 0) {
                         $('#dlalmacen1').val($('#idalmacen1').val());
                     }
                 }
             }, iferror);
         }
         function cargacliente() {
             PageMethods.cliente(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 }
                 $('#dlcliente').empty()
                 $('#dlcliente').append(inicial);
                 $('#dlcliente').append(lista);
                 if ($('#idcliente').val() != 0) {
                     $('#dlcliente').val($('#idcliente').val());
                 }
                 $('#dlcliente').change(function () {
                     cargainmueble($('#dlcliente').val());
                 });

             }, iferror);
         }
         function ShowHideDiv() {
             var herramientas = document.getElementById("btherramientas");
             var materiales = document.getElementById("btmateriales");
             dltipo2.style.display = herramientas.checked ? "block" : "none";
             dltipo1.style.display = materiales.checked ? "block" : "none";
         }

         function cargainmueble(cliente) {
             PageMethods.inmueble(cliente, function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlsucursal').empty();
                 $('#dlsucursal').append(inicial);
                 $('#dlsucursal').append(lista);
                 if ($('#idinmueble').val() != 0) {
                     $('#dlsucursal').val($('#idinmueble').val());
                 }
                 /*
                 $('#dlsucursal').change(function () {
                     PageMethods.localidad($('#dlsucursal').val(), function (detalle) {
                         var datos = eval('(' + detalle + ')');
                         $('#txdireccion').val(datos.ubicacion);
                     }, iferror);
                 })*/
             }, iferror);
         }

             function subtotal() {
                var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val());
                $('#txtotal').val(tot.toFixed(2));
             }
             function total() {
                var subtotal = 0;
                $('#tblistaj tbody tr').each(function () {
                 subtotal += parseFloat($(this).closest('tr').find("input:eq(2)").val());
                });
                $('#txsubtotalg').val(subtotal.toFixed(2));
             }
             function validamat() {
                if ($('#txclave').val() == '') {
                 alert('Debe elegir la clave del material');
                 return false;
                }
                if ($('#txcantidad').val() == '') {
                 alert('Debe capturar la cantidad de material');
                 return false;
                }
                if (parseFloat($('#txcantidad').val()) > parseFloat($('#txdisp').val())) {
                 alert('No puede solicitar mas de la cantidad disponible');
                 return false;
                }
                for (var x = 0; x < $('#tblistaj tbody tr').length; x++) {
                    if ($('#tblistaj tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                     alert('Este producto ya esta registrado, no puede duplicar');
                     return false;
                    }
                }
                return true;
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
        <asp:HiddenField ID="idalmacen" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen1" runat="server" Value="0" />
        <asp:HiddenField ID="idsol" runat="server" Value="0" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idtecnico" runat="server" Value="0" />
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
                    <h1>Solicitud de materiales y herramientas mantenimiento<small>Almacén</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacén</a></li>
                        <li class="active">Solicitud</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfolio">No. Solicitud:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control text-right" disabled="disabled"  />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txestatus" class="form-control text-right" disabled="disabled" value="Alta" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltecnico">Tecnico:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dltecnico" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txclavecm">C.M:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txclavecm" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="idalmacen">Almacén Salida:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlalmacen" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="idalmacen1">Almacén Entrada:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlalmacen1" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                                
                            </div>
                            <div id="dltipo1">
                            <div class="row">
                                <div class="col-log-1" style="margin-left: 250px">
                                    <label class="container">
                                        Materiales
                                        <input type="radio" id="btmateriales" name="dltipo" onclick="ShowHideDiv()" value="1" />
                                        <span class="checkmark"></span> 
                                    </label>
                                </div>
                            </div>
                            </div>
                            <div id="dltipo2">
                                <div class="row">
                                <div class="col-log-1" style="margin-left: 250px">
                                    <label class="container">
                                        Herramientas
                                        <input type="radio" id="btherramientas" name="dltipo" onclick="ShowHideDiv()" value="2" />
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                                </div>
                                <br />
                             <div class="row">
                                 <div class="col-lg-2 text-right">
                                    <label for="txfecha1">Fecha entrega herramienta:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha1" class="form-control" />
                                </div>
                             </div>
                            </div>
                        </div>
                    </div>
                    <div class="row tbheader" style="height: 300px; overflow-y: scroll;">
                        <table class=" table table-condensed h6" id="tblistaj">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active" colspan="2">Clave</th>
                                    <th class="bg-light-blue-active">Descripción</th>
                                    <th class="bg-light-blue-active">Unidad</th>
                                    <th class="bg-light-blue-active">Cantidad</th>
                                    <th class="bg-light-blue-active">Precio</th>
                                    <th class="bg-light-blue-active">total</th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                                <tr>
                                    <td class=" col-xs-1">
                                        <input type="text" class=" form-control" id="txclave" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                    </td>
                                    <td class="col-xs-2">
                                        <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control text-right" id="txcantidad" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control text-right" id="txprecio" disabled="disabled"/>
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control text-right" disabled="disabled" id="txtotal" />
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txsubtotalg">Subtotal:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalg" />
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-lg-2 text-right">
                            <label for="txobservacion">Observaciones:</label>
                        </div>
                        <div class="col-lg-5">
                            <textarea id="txobservacion" class=" form-control"></textarea>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                        <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>-->
                    </ol> 
                     <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label>
                                </div>
                                <div class="col-lg-5">
                                    <input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />
                                </div>
                                <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                    </div>
                                </div>
                                <div class="tbheader">
                                    <table class="table table-condensed" id="tbbusca">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>Clave</span></th>
                                                <th class="bg-navy"><span>Producto</span></th>
                                                <th class="bg-navy"><span>Unidad</span></th>
                                                <th class="bg-navy"><span>Precio</span></th>                                               
                                            </tr>
                                        </thead>
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
