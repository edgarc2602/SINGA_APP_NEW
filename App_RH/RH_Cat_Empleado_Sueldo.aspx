<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Empleado_Sueldo.aspx.vb" Inherits="App_RH_RH_Cat_Empleado_Sueldo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE EMPLEADOS-SUELDO</title>
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
    <script>
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#txnombre').text($('#nombre').val());
            $('#txfingreso').datepicker({ dateFormat: 'dd/mm/yy'});
            $('#txfinfonavit').datepicker({ dateFormat: 'dd/mm/yy'});
            $('#txfinfonavit').prop("disabled", true);
            $('#dltipo').prop("disabled", true);
            $('#txmonto').prop("disabled", true);
            cargabancos();
            datosempleado();
            $('#cbinfonavit').change(function () {
                if ($('#cbinfonavit').is(':checked')) {
                    $('#txfinfonavit').prop("disabled", false);
                    $('#dltipo').prop("disabled", false);
                    $('#txmonto').prop("disabled", false);
                } else {
                    $('#txfinfonavit').prop("disabled", true);
                    $('#dltipo').prop("disabled", true);
                    $('#txmonto').prop("disabled", true);
                    $('#txfinfonavit').val('');
                    $('#dltipo').val(0);
                    $('#txmonto').val(0);
                }
            })
            $('#btactualiza').click(function () {
                if (valida()) {
                    var fing = $('#txfingreso').val().split('/');
                    var fingreso = fing[2] + fing[1] + fing[0];

                    if ($('#txfinfonavit').val() != '') {
                        finf = $('#txfinfonavit').val().split('/');
                        var finfonavit = finf[2] + finf[1] + finf[0];
                    } else { var finfonavit = ''}
                    var inf = 0;
                    if ($('#cbinfonavit').is(':checked')) {
                        inf = 1;
                    }
                    var xmlgraba = '<sueldo id= "' + $('#idemp').val() + '" sueldo= "' + $('#txsueldo').val() + '" simss = "' + $('#txsueldoimss').val() + '"  sdi= "' + $('#txdiario').val() + '" fingreso="' + fingreso + '" formapago= "' + $('#dlforma').val() + '" banco= "' + $('#dlbanco').val() + '" ';
                    xmlgraba += ' clabe= "' + $('#txclabe').val() + '" cuenta= "' + $('#txcuenta').val() + '" tarjeta = "' + $('#txtarjeta').val() + '" inf= "' + inf + '" fcredito= "' + finfonavit + '"'
                    xmlgraba += ' tipoc= "' + $('#dltipo').val() + '" montoc= "' + $('#txmonto').val() + '"    />'
                    PageMethods.guarda(xmlgraba, function (res) {
                        alert('Registro actualizado.');
                    }, iferror);
                }
            })
            $('#txsueldo').change(function () {
                calculasalarios();  
            })
            /*$("#txsueldo").keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });*/
            $("#txclabe").keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
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
            $("#txtarjeta").keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        });
        function datosempleado() {
            PageMethods.detalle($('#idemp').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfingreso').val(datos.fingreso);
                $('#txsueldo').val(datos.sueldo);
                $('#txsueldoimss').val(datos.sueldoimss);
                $('#txdiario').val(datos.sdi);
                $('#dlforma').val(datos.formapago);
                $('#dlbanco').val(datos.banco);
                $('#txclabe').val(datos.clabe);
                $('#txcuenta').val(datos.cuenta);
                $('#txtarjeta').val(datos.tarjeta);
                if (datos.tienecredito == "True") { $('#cbinfonavit').prop("checked", true); } else { $('#cbinfonavit').prop("checked", false); }
                $('#txfinfonavit').val(datos.fcredito);
                $('#dltipo').val(datos.tipocredito);
                $('#txmonto').val(datos.montocredito);
            }, iferror);
        }
        function calculasalarios() {
            var sd = $('#txsueldo').val() / 30
            var sdi = sd * 1.0452
            $('#txsueldoimss').val(sd.toFixed(2));
            $('#txdiario').val(sdi.toFixed(2));
        }
        function valida() {
            if ($('#txsueldo').val() == '' || $('#txsueldo').val() == 0) {
                alert('Debe capturar el sueldo mensual');
                return false;
            }
            if (isNaN($('#txsueldo').val()) == true || $('#txsueldo').val() == '') {
                alert('Debe capturar la Salario mensual');
                return false;
            }
            if ($('#txfingreso').val() == '') {
                alert('Debe seleccionar la fecha de ingreso');
                return false;
            }
            if ($('#dlforma').val() == 0) {
                alert('Debe seleccionar la forma de pago');
                return false;
            }
            /*if ($('#dlbanco').val() == 0) {
                alert('Debe seleccionar el banco');
                return false;
            }*/
            /*if ($('#txclabe').val() == '' || $('#txclabe').val() == 0) {
                alert('Debe capturar la clabe interbancaria');
                return false;
            }*/
            if ($('#txclabe').val() != '' && $('#txclabe').val().length < 18) {
                alert('Si colocas Clabe interbancaria debe ser de 18 digitos');
                return false;
            }
            if ($('#txtarjeta').val() != '' && $('#txtarjeta').val().length < 16) {
                alert('Si colocas Numero de tarjeta debe ser de 16 digitos');
                return false;
            }
            /*
            if ($('#txcuenta').val() == '' || $('#txcuenta').val() == 0) {
                alert('Debe capturar el No. Cuenta');
                return false;
            }*/
            return true;
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
                if ($('#idbanco').val() != '') {
                    $('#dlbanco').val($('#idbanco').val());
                };
            }, iferror);
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
        <asp:HiddenField ID="idemp" runat="server"/>
        <asp:HiddenField ID="nombre" runat="server"/>
        <asp:HiddenField ID="idbanco" runat="server"/>
        <div class="content-header">
            <h1>Catálogo de Empleados<small>Datos de sueldo</small></h1>
        </div>
        <div class="content">
            <div class="row" id="dvdatos">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header">
                            <h3 id="txnombre"></h3>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txfingreso">Fecha de ingreso:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfingreso" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txsueldo">Salario mensual:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txsueldo" class="form-control text-right" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txsueldoimss">Salario diario:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txsueldoimss" class="form-control text-right" disabled="disabled" />
                            </div>
                            <div class="col-lg-3 text-right">
                                <label for="txdiario">Salario diario integrado:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txdiario" class="form-control text-right" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            
                            <div class="col-lg-2 text-right">
                                <label for="dlforma">Forma de pago:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlforma" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Quincenal</option>
                                    <option value="2">Semanal</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dlbanco">Banco:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlbanco" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txclabe">CLABE:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txclabe" class="form-control" maxlength="20" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txcuenta">No. Cuenta:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcuenta" class="form-control" />
                            </div>
                             <div class="col-lg-1">
                                <label for="txcuenta">No. Tarjeta:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtarjeta" class="form-control" maxlength="16" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <input type="checkbox" id="cbinfonavit"/>
                                <label for="cbinfonavit">Infonavit:</label>
                            </div>
                        </div>
                        <div class="row"> 
                             <div class="col-lg-2 text-right">
                                <label for="txfinfonavit">Fecha de credito:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfinfonavit" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="dltipo">Tipo de credito:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dltipo" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Cuota fija</option>
                                    <option value="2">Porcentaje</option>
                                    <option value="3">Veces Salario mínimo</option>
                                </select>
                            </div>
                            <div class="col-lg-1">
                                <label for="txmonto">Monto:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txmonto" class="form-control" value="0" />
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btactualiza"  class="puntero"><a><i class="fa fa-edit" ></i>Actualizar</a></li>
                            <li id="btsalir"  onclick="self.close()" class="puntero"><a><i class="fa fa-edit" ></i>Salir</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
