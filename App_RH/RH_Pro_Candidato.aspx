<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Candidato.aspx.vb" Inherits="App_RH_RH_Pro_Candidato" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CURSOS DE INDUCCION</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
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
             $('#txfecing').datepicker({ dateFormat: 'dd/mm/yy' });
             cargacliente();
             cargapuesto();
             cargaturno();
             cargaempleado();
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
             $('#btregistra').click(function () {
                 if (valida()) {
                     waitingDialog({});
                     var fc = $('#txfecing').val().split('/');
                     var fing = fc[2] + fc[1] + fc[0];

                     var xmlgraba = '<candidato vacante= "' + $('#idvacante').val() + '" usuario= "' + $('#idusuario').val() + '"';
                     xmlgraba += ' apellidop= "' + $('#txpaterno').val() + '" apellidom = "' + $('#txmaterno').val() + '" nombre= "' + $('#txnombre').val() + '"';
                     xmlgraba += ' rfc= "' + $('#txrfc').val() + '" curp= "' + $('#txcurp').val() + '" ss = "' + $('#txss').val() + '"';
                     xmlgraba += ' fingreso = "' + fing + '" tel1 = "' + $('#txtel1').val() + '" tel2 = "' + $('#txtel2').val()  + '" />'

                     //alert(xmlgraba);
                     PageMethods.guarda(xmlgraba, function () {
                         closeWaitingDialog();
                         alert('El registro se ha enviado correctamente');
                         window.open('../home1.aspx', '_self');
                     }, iferror);
                 }
             })
             $('#btsalir').click(function () {
                 window.open('../home1.aspx' , '_self');
             })
             $("input[type=text]").keyup(function () {
                 $(this).val($(this).val().toUpperCase());
             });
         });
         function valida() {
             if ($('#txpaterno').val() == '') {
                 alert('Debe capturar el apellido paterno');
                 return false;
             }
             if ($('#txnombre').val() == '') {
                 alert('Debe capturar el nombre');
                 return false;
             }
             if ($('#txrfc').val() == '') {
                 alert('Debe capturar el RFC');
                 return false;
             }
             if ($('#txrfc').val().length < 13) {
                 alert('El RFC debe contener 13 caracteres, verifique');
                 return false;
             }
             if ($('#txcurp').val() == '') {
                 alert('Debe capturar la CURP');
                 return false;
             }
             if ($('#txcurp').val().length < 18) {
                 alert('La CURP debe contener 18 caracteres, verifique');
                 return false;
             }
             if ($('#txss').val() == '') {
                 alert('Debe capturar el Numero de seguro social');
                 return false;
             }
             if ($('#txss').val().length < 11) {
                 alert('El No. de seguro social debe contener 11 dígitos verifique');
                 return false;
             }
             if ($('#txfecing').val() == '') {
                 alert('Debe seleccionar la fecha de ingreso');
                 return false;
             }
             if ($('#txtel1').val() == '') {
                 alert('Debe colocar al menos el telefono de contacto');
                 return false;
             }
             return true;
         }
         function limpia() {
             $('#txpaterno').val('');
             $('#txmaterno').val('');
             $('#txnombre').val('');
             $('#txrfc').val('');
             $('#txcurp').val('');
             $('#txss').val('');
             $('#dlcliente').val(0);
             $('#dlsucursal').empty();
             $('#dlpuesto').val(0);
             $('#dlturno').val(0);
             $('#dlreclutador').val(0);
             $('#txfecha').val(0);
             $('#txhora').val(0);
         }
         function cargacliente() {
             PageMethods.cliente(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlcliente').append(inicial);
                 $('#dlcliente').append(lista);
                 $('#dlcliente').change(function () {
                     cargainmueble($('#dlcliente').val());
                 });
             }, iferror);
         }
         function cargainmueble(idcte) {
             PageMethods.inmueble(idcte, function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlsucursal').empty();
                 $('#dlsucursal').append(inicial);
                 $('#dlsucursal').append(lista);
             }, iferror);
         }
         function cargapuesto() {
             PageMethods.puesto(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlpuesto').append(inicial);
                 $('#dlpuesto').append(lista);
             }, iferror);
         }
         function cargaturno() {
             PageMethods.turno(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlturno').append(inicial);
                 $('#dlturno').append(lista);
             }, iferror);
         }
         function cargaempleado() {
             PageMethods.reclutador( function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 }
                 $('#dlreclutador').append(inicial);
                 $('#dlreclutador').append(lista);
             });
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
         };
     </script>
</head>
<body>
    <form id="form1" runat="server">    
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idvacante" runat="server" />
        <div class="content">
            <div class="row" id="dvdatos">
                
                    <div class="box box-info">
                        <div class="box-header">
                            <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txpaterno" >Apellido Paterno:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txpaterno" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txmaterno">Apellido Materno:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <input type="text" id="txmaterno" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txnombre" >Nombre(s):</label>
                            </div>
                            
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txnombre" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txrfc">RFC:</label>
                            </div>
                            
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txrfc" class="form-control" style="height:100px; font-size:40px;" maxlength="13"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txcurp" >CURP:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txcurp" class="form-control" style="height:100px; font-size:40px;" maxlength="18"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txss">No. SS:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txss" class="form-control" style="height:100px; font-size:40px;" maxlength="11"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txfecing">F. Ingreso:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txfecing" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txtel1">Tel. Contacto:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txtel1" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 h1">
                                <label for="txtel2">Tel. Adicional:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input type="text" id="txtel2" class="form-control" style="height:100px; font-size:40px;"/>
                            </div>
                        </div>
                        <div class="box-footer">
                            <input type="button" class="btn btn-primary" value="Registrar" id="btregistra" style="height:100px; font-size:40px;"/>                            
                            <input type="button" class="btn btn-primary" value="Salir" id="btsalir" style="height:100px; font-size:40px;"/>
                        </div>
                    </div>
                </div>
           
        </div>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
