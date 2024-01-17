<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ban_Pro_Solicitud.aspx.vb" Inherits="App_Banfuturo_Ban_Pro_Solicitud" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>SOLICITUD DE PRESTAMO</title>
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
            width: 25px; 
            height: 25px; 
            font-family:'MS Gothic';
            font-size:40px;
            color:#585858;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            var f = new Date();
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear());
            $('#txanioamort').val(f.getFullYear());
            $('#txanioamort').focusout(function () {
                cargaperiodo()
            })
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
            dialog2 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 650,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog1 = $('#divmodal').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog3 = $('#divmodal3').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            cargaautoriza();
            $('#btbusca').click(function () {
                //alert($(this).closest('tr').index());
                //$('#tbfila').val($(this).closest('tr').index());
                $("#divmodal").dialog('option', 'title', 'Elegir Empleado');
                dialog1.dialog('open');
            });
            $('#btbuscap').click(function () {
                $('#tbbusca1 tbody').remove();
                if (validaemp()) {
                    cargalistaemp();
                }
            })

            if ($('#idfolio').val() != 0) {
                $('#txid').val($('#idfolio').val());
                cargasolicitud();

            }

            $('#btlibera').click(function () {
                PageMethods.validaliberar($('#txid').val(), function (res) {
                    if (res != "2") {
                        alert("Aún no se ha guardado la amortización.");
                    }
                    else {
                        PageMethods.libera($('#txid').val(), function (res) {
                            alert('La solicitud de prestamo ha sido liberada, se envió un correo al área de Tesorería para que se realice el tramite del deposito');
                        }, iferror);                        
                    }
                }, iferror);
               
            });            

            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var polpar = 0
                    /*
                    if ($('#cbpolpar').prop('checked')) {
                        polpar = 1
                    }*/
                    var poles = 0
                    /*
                    if ($('#cbpoles').prop('checked')) {
                        poles = 1
                    }*/
                    var compdom = 0
                    if ($('#cbcomprobante').prop('checked')) {
                        compdom = 1
                    }
                    var comping = 0
                    /*
                    if ($('#cbingresos').prop('checked')) {
                        comping = 1
                    }*/
                    var compide = 0
                    if ($('#cbidentifica').prop('checked')) {
                        compide = 1
                    }
                    var letrasmonto = NumeroALetras(parseFloat($('#txmonto').val()), 0);

                    var xmlgraba = '<solicitud id= "' + $('#txid').val() + '" noemp= "' + $('#txnoempleado').val() + '"  tel= "' + $('#txtel').val() + '" cel="' + $('#txcel').val() + '" jefe= "' + $('#dlautoriza').val() + '" monto= "' + $('#txmonto').val() + '" ';
                    xmlgraba += ' plazo= "' + $('#dlplazo').val() + '" plan= "' + $('#dlpago').val() + '" ref1nombre = "' + $('#txref1n').val() + '" ref1paren= "' + $('#txref1p').val() + '"';
                    xmlgraba += ' ref1tel= "' + $('#txref1tel').val() + '" ref1cel= "' + $('#txref1cel').val() + '" ref2nombre= "' + $('#txref2n').val() + '" ref2paren= "' + $('#txref2p').val() + '"';
                    xmlgraba += ' ref2tel= "' + $('#txref2tel').val() + '" ref2cel= "' + $('#txref2cel').val() + '" ref3nombre= "' + $('#txref3n').val() + '" ref3paren= "' + $('#txref3p').val() + '"';
                    xmlgraba += ' ref3tel= "' + $('#txref3tel').val() + '" ref3cel= "' + $('#txref3cel').val() + '" tienep = "' + polpar + '" esp= "' + poles + '" doctodom= "' + compdom + '" doctoing= "' + comping + '"';
                    xmlgraba += ' doctoide= "' + compide + '" antiguedad="' + $('#txantiguedad').val() + '" montoletra="' + letrasmonto + '" correo="' + $('#txcorreo').val() + '"/>'
                    //alert(xmlgraba);

                    PageMethods.guarda(xmlgraba, $('#idusuario').val(), $('#dlautoriza').val(), $('#txid').val(), function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                        
                    }, iferror);
                }
            })
            $('#btimprime').click(function () {
                $("#divmodal3").dialog('option', 'title', 'Elegir Formato');
                dialog3.dialog('open');
                //
                // window.open('Ope_Ticket_PDF.aspx?id=' + $('#idticket').val(), '_blank', 'top = 100, left = 300, width = 1000, height = 500')
            })
            $('#btimprimef').click(function () {
                switch ($('#dlformato').val()) {
                    case '1':
                        window.open('../RptForAll.aspx?v_nomRpt=solicitudprestamo1.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                    case '2':
                        window.open('../RptForAll.aspx?v_nomRpt=cartapreautobanfuturo.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                    case '3':
                        window.open('../RptForAll.aspx?v_nomRpt=cartaautobanfuturo.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                    case '4':
                        window.open('../RptForAll.aspx?v_nomRpt=spamortizacion.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                    case '5':
                        window.open('../RptForAll.aspx?v_nomRpt=contratobanfuturo.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                    case '6':
                        window.open('../RptForAll.aspx?v_nomRpt=pagarebanfuturo.rpt&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        break;
                }
            })
            $('#btgdocumento').click(function () {
                //alert("genera documentos");
                //window.open('../RptPdf.aspx?v_id=' + $('#txid').val() + '&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val());
                var xmlgraba = '<movimiento>'
                xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                xmlgraba += ' archivo="preautorizacion' + $('#txid').val() + '.pdf" documento="Pre-Autorizacion" descripcion="Carta para Preautorizar el prestamo" />';
                xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                xmlgraba += ' archivo="prestamo' + $('#txid').val() + '.pdf" documento="Prestamo" descripcion="Carta solicitud de prestamo" />';
                xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                xmlgraba += ' archivo="autorizacion' + $('#txid').val() + '.pdf" documento="Autorizacion" descripcion="Carta autorizacion del prestamo" />';
                xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                xmlgraba += ' archivo="contrato' + $('#txid').val() + '.pdf" documento="Contrato" descripcion="Carta contrato del prestamo" />';
                xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                xmlgraba += ' archivo="amortizacion' + $('#txid').val() + '.pdf" documento="Amortizacion" descripcion="Tabla de amortizacion" />';
                xmlgraba += '</movimiento>'
                //alert(xmlgraba);
                PageMethods.documentos(xmlgraba, function (res) {
                    alert("Archivos generados");
                }, iferror)
            })
            $('#bttabla').click(function () {
                if ($('#dlpago').val() == 0) {
                    alert('Antes de generar la tabla de amortización debe elegir la forma de pago')
                } else {
                    var int = 0
                    var pagos = 0
                    $('#txmonto1').val($('#txmonto').val())
                    switch ($('#dlplazo').val()) {
                        case '3':
                            int = 1.3;
                            $('#txinteres').val(30);
                            break;
                        case '6':
                            int = 1.3;
                            $('#txinteres').val(30);
                            break;
                        case '12':
                            int = 1.4;
                            $('#txinteres').val(40)
                            break;
			case '24':
                            int = 1.4;
                            $('#txinteres').val(40)
                            break;
                    }
                    $('#txpago').val(parseFloat($('#txmonto').val() * int));
                    if ($('#dlpago').val() == 2) {
                        pagos = parseInt($('#dlpago').val()) + (parseInt($('#dlplazo').val()) * 4) - 1;
                    } else {
                        pagos = parseInt($('#dlpago').val()) + (parseInt($('#dlplazo').val()) * 2) - 1;
                    }
                    //alert(pagos);
                    //pagos = parseInt($('#dlpago').val()) * parseInt($('#dlplazo').val())
                    $('#txpagotot').val(pagos);
                    var pagoind = parseFloat($('#txpago').val() / pagos)
                    $('#txpagoind').val(pagoind.toFixed(2))
                    cargaperiodo();
                    cargaamortizacion();
                    $('#txfecfin').val('');
                    $("#divmodal1").dialog('option', 'title', 'Tabla de amortización');
                    dialog2.dialog('open');
                }
            })
            $('#btcalcula').click(function () {
                PageMethods.validaliberar($('#txid').val(), function (res) {
                    if (res == "1") {
                        if (validaamort()) {
                            var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                            var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                            var letrasind = NumeroALetras(parseFloat($('#txpagoind').val()), 0);
                            var letrastot = NumeroALetras(parseFloat($('#txmonto1').val()), 0);
                            var fecha1 = $('#txfecfin').val().split('/');
                            var fini = fecha1[2] + fecha1[1] + fecha1[0];
                            var perf = 0

                            if ($('#dlpago').val() == 2) { // CALCULO DEL PERIODO FINAL PARA LA TABLA DE AMORTIZACION
                                perf = parseInt($('#dlperiodo').val()) + (parseInt($('#dlplazo').val()) * 4) - 1;
                            } else {
                                perf = parseInt($('#dlperiodo').val()) + (parseInt($('#dlplazo').val()) * 2) - 1;
                            }
                            if ($('#dlpago').val() == 2 && perf > 52) {
                                perf = 52
                            } else {
                                if ($('#dlpago').val() == 1 && perf > 24) { // SI EL PERIODO FINAL SE BRINCA DE AÑO SE CIERRA AL ULTIMO
                                    perf = 24
                                }
                            }
                            //alert(perf);
                            var tasai = parseFloat($('#txinteres').val()) / 100;

                            PageMethods.ultimafecha($('#dlperiodo').val(), tipo, anio, $('#txpagotot').val(), function (res) {
                                var datos = eval('(' + res + ')');
                                var ffinal = (datos.ffin);
                                var fecha2 = ffinal.split("/");
                                var ffin = fecha2[2] + fecha2[1] + fecha2[0];

                                var xmlgraba = '<movimiento>'
                                xmlgraba += '<solicitudc id= "' + $('#txid').val() + '" periodo= "' + $('#dlperiodo').val() + '"  tipo= "' + tipo + '" anio="' + anio + '" tasa= "' + $('#txinteres').val() + '" pagotot= "' + $('#txpago').val() + '" ';
                                xmlgraba += ' pagoind= "' + parseFloat($('#txpagotot').val()) + '" pagocant= "' + parseFloat($('#txpagoind').val()) + '" letrasind= "' + letrasind + '" letrastot= "' + letrastot + '"';
                                xmlgraba += ' fpagoini= "' + fini + '" fpagofin= "' + ffin + '" perf="' + perf + '" tasai="' + tasai + '" />'

                                xmlgraba += '</movimiento>'
                                //alert(xmlgraba);
                                PageMethods.guardac(xmlgraba, function () {
                                    var consec = 0 // SE USARA PARA OBTENER EL CONSECUTIVO CUANDO BRINCA DE AÑO
                                    // ESTO SUCEDE SI SE PASA DEL AÑO PARA LA TABLA DE AMORTIZACION
                                    if ($('#dlpago').val() == 2) { // CALCULO DEL PERIODO FINAL PARA LA TABLA DE AMORTIZACION
                                        perf = parseInt($('#dlperiodo').val()) + (parseInt($('#dlplazo').val()) * 4) - 1;
                                    } else {
                                        perf = parseInt($('#dlperiodo').val()) + (parseInt($('#dlplazo').val()) * 2) - 1;
                                    }
                                    if ($('#dlpago').val() == 2 && perf > 52) {
                                        perf = perf - 52
                                    } else {
                                        if ($('#dlpago').val() == 1 && perf > 24) { // SI EL PERIODO FINAL SE BRINCA DE AÑO SE CIERRA AL ULTIMO
                                            perf = perf - 24
                                            anio = parseInt(anio) + 1
                                            consec = 25 - parseInt($('#dlperiodo').val());
                                            //alert(consec);
                                            var tasai = parseFloat($('#txinteres').val()) / 100;

                                            PageMethods.ultimafecha($('#dlperiodo').val(), tipo, anio, $('#txpagotot').val(), function (res) {
                                                var datos = eval('(' + res + ')');
                                                var ffinal = (datos.ffin);
                                                var fecha2 = ffinal.split("/");
                                                var ffin = fecha2[2] + fecha2[1] + fecha2[0];

                                                var xmlgraba = '<movimiento>'
                                                xmlgraba += '<solicitudc id= "' + $('#txid').val() + '" periodo= "1"  tipo= "' + tipo + '" anio="' + anio + '" tasa= "' + $('#txinteres').val() + '" pagotot= "' + $('#txpago').val() + '" ';
                                                xmlgraba += ' pagoind= "' + parseFloat($('#txpagotot').val()) + '" pagocant= "' + parseFloat($('#txpagoind').val()) + '" letrasind= "' + letrasind + '" letrastot= "' + letrastot + '"';
                                                xmlgraba += ' fpagoini= "' + fini + '" fpagofin= "' + ffin + '" perf="' + perf + '" tasai="' + tasai + '" consec="' + consec + '" />'

                                                xmlgraba += '</movimiento>'
                                                //alert(xmlgraba);
                                                PageMethods.guardac1(xmlgraba, function () {
                                                    cargaamortizacion();
                                                }, iferror);
                                            }, iferror);

                                        }
                                    }
                                    cargaamortizacion();
                                }, iferror);
                            }, iferror);
                        }
                    }
                    else {
                        alert("La amortización ya ha sido guardada y no puede ser cambiada.");
                    }
                }, iferror);

                
                /*
                var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                var tipo = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                PageMethods.amortizacion($('#dlperiodo').val(), anio, tipo, $('#txid').val(), $('#dlplazo').val(), $('#dlpago').val(), $('#txinteres').val(), function (res) {
                    //closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren);
                    $('#tblistbbuscata  tbody tr').on('click', function () {
                    });
                }, iferror);*/
            });
            $('#btgenera').click(function () {
                PageMethods.validaliberar($('#txid').val(), function (res) {
                    if (res == "1") {
                        if (validagenera()) {

                            var xmlgraba = '<movimiento>'
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="preautorizacion' + $('#txid').val() + '.pdf" documento="Pre-Autorizacion" descripcion="Carta para Preautorizar el prestamo" />';
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="prestamo' + $('#txid').val() + '.pdf" documento="Prestamo" descripcion="Carta solicitud de prestamo" />';
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="autorizacion' + $('#txid').val() + '.pdf" documento="Autorizacion" descripcion="Carta autorizacion del prestamo" />';
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="contrato' + $('#txid').val() + '.pdf" documento="Contrato" descripcion="Carta contrato del prestamo" />';
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="amortizacion' + $('#txid').val() + '.pdf" documento="Amortizacion" descripcion="Tabla de amortizacion" />';
                            xmlgraba += '<solicitud id= "' + $('#txid').val() + '" status="0" tamano="0"';
                            xmlgraba += ' archivo="pagare' + $('#txid').val() + '.pdf" documento="Pagare" descripcion="Pagare" />';
                            xmlgraba += '</movimiento>'

                            window.open('../RptPdf.aspx?v_id=' + $('#txid').val() + '&v_formula={tb_solicitudprestamo.id_solicitud}  = ' + $('#txid').val());

                            waitingDialog({});

                            PageMethods.enviacodigo($('#txid').val(), xmlgraba, function (res) {
                                closeWaitingDialog();
                                alert('Se guardó correctamente la amortización para la solicitud, se envió un código al solicitante para que descargue sus documentos.');
                            }, iferror);
                        }
                    }
                    else {
                        alert("La amortización ya ha sido guardada y no puede ser cambiada.");
                    }
                }, iferror);

            });
        });
        
        function validagenera(){
            if ($('#tbbusca tbody tr').length == 0) {
                alert('Aun no genera la tabla de amortización')
                return false;
            }
            return true;
        }
        function validaamort() {
            if ($('#dlperiodo').val() == 0) {
                alert('Debe elegir un período para el primer descuento')
                return false;
            }
            return true;
        }
        function cargaautoriza() {
            PageMethods.autoriza( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlautoriza').append(inicial);
                $('#dlautoriza').append(lista);
                $('#dlautoriza').val(0);
                if ($('#idautoriza').val() != 0) {
                    $('#dlautoriza').val($('#idautoriza').val());
                }
                
            }, iferror);
        }
        function cargalistaemp() {
            PageMethods.listaempleado($('#txbusca').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tbbusca1 tbody').remove();
                $('#tbbusca1').append(ren);
                
                $('#tbbusca1 tbody tr').click(function () {
                    $('#txnoempleado').val($(this).children().eq(0).text())
                    cargaempleado($(this).children().eq(0).text(), 2)
                    /*$('#tbbusca1 tbody tr').eq($('#tbfila').val()).find('input').eq(1).val($(this).children().eq(0).text());
                    $('#tbbusca1 tbody tr').eq($('#tbfila').val()).find('input').eq(2).val($(this).children().eq(1).text());
                    var btn = '<input type="button" class="btquita btn btn-danger" value="Borrar" />'
                    $('#tbbusca1 tbody tr').eq($('#tbfila').val()).find('td').eq(8).append(btn);*/
                    dialog1.dialog('close');
                });
                
            }, iferror);
        }
        function validaemp() {
            if ($('#txbusca').val() == '') {
                alert('Debe colocar un numero de empleado o nombre a buscar');
                return false;
            }
            return true;
        }
        function valida() {
            if ($('#txnoempleado').val() == '') {
                alert('Debe elegir un empleado');
                return false;
            }
            if ($('#txtel').val() == '') {
                alert('Debe colocar un telefono de contacto');
                return false;
            }
            if ($('#txcel').val() == '') {
                alert('Debe colocar un celular de contacto');
                return false;
            }
            validateEmail($('#txcorreo').val());
            if ($('#dlautoriza').val() == 0) {
                alert('Debe elegir la persona que autoriza');
                return false;
            }
            if ($('#txmonto').val() == '') {
                alert('Debe colocar el monto del prestamo');
                return false;
            }
            if ($('#dlplazo').val() == 0) {
                alert('Debe seleccionar el plazo del prestamo');
                return false;
            }
            if ($('#dlpago').val() == 0) {
                alert('Debe seleccionar el plan de pagos');
                return false;
            }
            if ($('#txref1n').val() == '') {
                alert('Debe colocar la primera referencia');
                return false;
            }
            if ($('#txref1p').val() == '') {
                alert('Debe colocar el parentesco de la primera referencia');
                return false;
            }
            if ($('#txref1tel').val() == '') {
                alert('Debe colocar el telefono de la primera referencia');
                return false;
            }
            if ($('#txref1cel').val() == '') {
                alert('Debe colocar el celular de la primera referencia');
                return false;
            }
            if ($('#txref2n').val() == '') {
                alert('Debe colocar la segunda referencia');
                return false;
            }
            if ($('#txref2p').val() == '') {
                alert('Debe colocar el parentesco de la segunda referencia');
                return false;
            }
            if ($('#txref2tel').val() == '') {
                alert('Debe colocar el telefono de la segunda referencia');
                return false;
            }
            if ($('#txref2cel').val() == '') {
                alert('Debe colocar el celular de la segunda referencia');
                return false;
            }            
            return true;
        }
        function validateEmail(correo) {
            if (correo == '') {
                alert('Debe colocar el correo');
                return false;
            } else {
                //$(".error").hide();
                var hasError = false;
                var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

                var emailaddressVal = correo;
                if (emailaddressVal == '') {
                    alert('Debe colocar el correo');                    
                    hasError = true;
                }

                else if (!emailReg.test(emailaddressVal)) {
                    alert('Debe colocar un correo valido');                    
                    hasError = true;
                }

                if (hasError == true) { return false; }   
            }
        }
        function cargaperiodo() {
            PageMethods.periodo($('#dlpago').val(), $('#txanioamort').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlperiodo').empty()
                $('#dlperiodo').append(inicial);
                $('#dlperiodo').append(lista);
                $('#dlperiodo').val(0);
                
                $('#dlperiodo').change(function () {
                    var per = $("#dlperiodo option:selected").text().substring(8, $("#dlperiodo option:selected").text().length);
                    var anio = $("#dlperiodo option:selected").text().substring(3, 7);
                    PageMethods.detalleperiodo($('#dlperiodo').val(), per, anio, function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txfecini').val(datos.fini);
                        $('#txfecfin').val(datos.ffin);
                    });
                });
            }, iferror);
        }
        function cargaamortizacion() {
            PageMethods.cargaamort($('#txid').val(), function (res) {
                
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                
            }, iferror);
        }
        function cargasolicitud() {
            PageMethods.solicitud($('#txid').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.emp != '0') {
                    //alert(datos.emp);
                    cargaempleado(datos.emp,2);
                    $('#txfecha').val(datos.fecha);
                    $('#txtel').val(datos.tel);
                    $('#txcel').val(datos.cel);
                    $('#txcorreo').val(datos.correo);
                    $('#idautoriza').val(datos.jefe);
                    cargaautoriza()
                    $('#txmonto').val(datos.monto);
                    $('#dlplazo').val(datos.plazo);
                    $('#dlpago').val(datos.planpago);
                    $('#txref1n').val(datos.ref1nombre);
                    $('#txref1p').val(datos.ref1parentezco);
                    $('#txref1tel').val(datos.ref1telcasa);
                    $('#txref1cel').val(datos.ref1telcel);
                    $('#txref2n').val(datos.ref2nombre);
                    $('#txref2p').val(datos.ref2parentezco);
                    $('#txref2tel').val(datos.ref2telcasa);
                    $('#txref2cel').val(datos.ref2telcel);
                    $('#txref3n').val(datos.ref3nombre);
                    $('#txref3p').val(datos.ref3parentezco);
                    $('#txref3tel').val(datos.ref3telcasa);
                    $('#txref3cel').val(datos.ref3telcel);                    
                    //if (datos.tieneparentezco == "True") { $('#cbpolpar').prop("checked", true); } else { $('#cbpolpar').prop("checked", false); }
                    //if (datos.espolitico == "True") { $('#cbpoles').prop("checked", true); } else { $('#cbpoles').prop("checked", false); }
                    if (datos.doctodom == "True") { $('#cbcomprobante').prop("checked", true); } else { $('#cbcomprobante').prop("checked", false); }
                    //if (datos.doctoing == "True") { $('#cbingresos').prop("checked", true); } else { $('#cbingresos').prop("checked", false); }
                    if (datos.doctoide == "True") { $('#cbidentifica').prop("checked", true); } else { $('#cbidentifica').prop("checked", false); }
                    $('#txestatus').val(datos.estatus);
                    if (datos.estatus != 'Alta') {
                        //alert('hola');
                        bloqueacontrol();
                    }
                }
            })
        }
        function bloqueacontrol() {
            
            $('#btbusca').prop("disabled", true);
            $('#dlgenero').prop("disabled", true);
            $('#dlcivil').prop("disabled", true);
            $('#txtel').prop("disabled", true);
            $('#txcel').prop("disabled", true);
            $('#dlautoriza').prop("disabled", true);
            $('#txmonto').prop("disabled", true);
            $('#dlplazo').prop("disabled", true);
            $('#dlpago').prop("disabled", true);
            $('#txref1n').prop("disabled", true);
            $('#txref1p').prop("disabled", true);
            $('#txref1tel').prop("disabled", true);
            $('#txref1cel').prop("disabled", true);
            $('#txref2n').prop("disabled", true);
            $('#txref2p').prop("disabled", true);
            $('#txref2tel').prop("disabled", true);
            $('#txref2cel').prop("disabled", true);
            $('#txref3n').prop("disabled", true);
            $('#txref3p').prop("disabled", true);
            $('#txref3tel').prop("disabled", true);
            $('#txref3cel').prop("disabled", true);
            $('#cbcomprobante').prop("disabled", true);
            $('#cbidentifica').prop("disabled", true);
        }
        function cargaempleado(emp, org) {
            PageMethods.empleado(emp, org, function (detalle) {
                var datos = eval('(' + detalle + ')');
                //if (datos.clave != '0') {
                    $('#txnoempleado').val(datos.emp);
                    $('#txempleado').val(datos.empleado);
                    $('#txfingreso').val(datos.fingreso);
                    $('#txantiguedad').val(datos.antiguedad);
                    $('#txsueldo').val(datos.sueldo);
                    $('#txrfc').val(datos.rfc);
                    $('#txcurp').val(datos.curp);
                    $('#txfnac').val(datos.fnac);
                    $('#dlgenero').val(datos.genero);
                    $('#dlcivil').val(datos.civil);
                    $('#txdomicilio').val(datos.domicilio);
                    //$('#txtel').val(datos.tel1);
                    //$('#txcel').val(datos.tel2);
                    $('#txpuesto').val(datos.puesto);
                    $('#txempresa').val(datos.empresa);
                    $('#txubicacion').val(datos.ubicacion);
               // } 
            })
        }
        function Unidades(num) {

            switch (num) {
                case 1: return "UN";
                case 2: return "DOS";
                case 3: return "TRES";
                case 4: return "CUATRO";
                case 5: return "CINCO";
                case 6: return "SEIS";
                case 7: return "SIETE";
                case 8: return "OCHO";
                case 9: return "NUEVE";
            }

            return "";
        }

        function Decenas(num) {

            decena = Math.floor(num / 10);
            unidad = num - (decena * 10);

            switch (decena) {
                case 1:
                    switch (unidad) {
                        case 0: return "DIEZ";
                        case 1: return "ONCE";
                        case 2: return "DOCE";
                        case 3: return "TRECE";
                        case 4: return "CATORCE";
                        case 5: return "QUINCE";
                        default: return "DIECI" + Unidades(unidad);
                    }
                case 2:
                    switch (unidad) {
                        case 0: return "VEINTE";
                        default: return "VEINTI" + Unidades(unidad);
                    }
                case 3: return DecenasY("TREINTA", unidad);
                case 4: return DecenasY("CUARENTA", unidad);
                case 5: return DecenasY("CINCUENTA", unidad);
                case 6: return DecenasY("SESENTA", unidad);
                case 7: return DecenasY("SETENTA", unidad);
                case 8: return DecenasY("OCHENTA", unidad);
                case 9: return DecenasY("NOVENTA", unidad);
                case 0: return Unidades(unidad);
            }
        }//Unidades()

        function DecenasY(strSin, numUnidades) {
            if (numUnidades > 0)
                return strSin + " Y " + Unidades(numUnidades)

            return strSin;
        }//DecenasY()

        function Centenas(num) {

            centenas = Math.floor(num / 100);
            decenas = num - (centenas * 100);

            switch (centenas) {
                case 1:
                    if (decenas > 0)
                        return "CIENTO " + Decenas(decenas);
                    return "CIEN";
                case 2: return "DOSCIENTOS " + Decenas(decenas);
                case 3: return "TRESCIENTOS " + Decenas(decenas);
                case 4: return "CUATROCIENTOS " + Decenas(decenas);
                case 5: return "QUINIENTOS " + Decenas(decenas);
                case 6: return "SEISCIENTOS " + Decenas(decenas);
                case 7: return "SETECIENTOS " + Decenas(decenas);
                case 8: return "OCHOCIENTOS " + Decenas(decenas);
                case 9: return "NOVECIENTOS " + Decenas(decenas);
            }

            return Decenas(decenas);
        }//Centenas()

        function Seccion(num, divisor, strSingular, strPlural) {
            cientos = Math.floor(num / divisor)
            resto = num - (cientos * divisor)

            letras = "";

            if (cientos > 0)
                if (cientos > 1)
                    letras = Centenas(cientos) + " " + strPlural;
                else
                    letras = strSingular;

            if (resto > 0)
                letras += "";

            return letras;
        }//Seccion()

        function Miles(num) {
            divisor = 1000;
            cientos = Math.floor(num / divisor)
            resto = num - (cientos * divisor)

            strMiles = Seccion(num, divisor, "MIL", "MIL");
            strCentenas = Centenas(resto);

            if (strMiles == "")
                return strCentenas;

            return strMiles + " " + strCentenas;

            //return Seccion(num, divisor, "UN MIL", "MIL") + " " + Centenas(resto);
        }//Miles()

        function Millones(num) {
            divisor = 1000000;
            cientos = Math.floor(num / divisor)
            resto = num - (cientos * divisor)

            strMillones = Seccion(num, divisor, "UN MILLON", "MILLONES");
            strMiles = Miles(resto);

            if (strMillones == "")
                return strMiles;

            return strMillones + " " + strMiles;

            //return Seccion(num, divisor, "UN MILLON", "MILLONES") + " " + Miles(resto);
        }//Millones()

        function NumeroALetras(num, centavos) {
            var data = {
                numero: num,
                enteros: Math.floor(num),
                centavos: (((Math.round(num * 100)) - (Math.floor(num) * 100))),
                letrasCentavos: "",
            };
            if (centavos == undefined || centavos == false) {
                data.letrasMonedaPlural = "PESOS";
                data.letrasMonedaSingular = "PESO";
            } else {
                data.letrasMonedaPlural = "CENTAVOS";
                data.letrasMonedaSingular = "CENTAVO";
            }
            if (data.centavos > 0)
                data.letrasCentavos = "CON " + NumeroALetras(data.centavos, true);

            if (data.enteros == 0)
                return "CERO " + data.letrasMonedaPlural + " " + data.letrasCentavos;
            if (data.enteros == 1)
                return Millones(data.enteros) + " " + data.letrasMonedaSingular + " " + data.letrasCentavos;
            else
                return Millones(data.enteros) + " " + data.letrasMonedaPlural + " " + data.letrasCentavos;
        }//NumeroALetras()
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
        <asp:HiddenField ID="idfolio" runat="server" value="0"/>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idautoriza" runat="server" value="0"/>
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
                    <h1>Solicitud de prestamo<small>Banfuturo</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Banfuturo</a></li>
                        <li class="active">Solicitud de prestamo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-4 text-right">
                                <label for="txid">Folio:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txfecha">Fecha:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txestatus">Estatus:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txestatus" class="form-control" disabled="disabled" value="Alta"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txnoempleado">Empleado</label>
                            </div>
                            <div class="col-lg-1">
                                <input class="form-control" id="txnoempleado" disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                            </div>
                            <div class="col-lg-4">
                                <input class="form-control" id="txempleado" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txrfc">RFC</label>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txrfc" disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <label for="txcurp">CURP</label>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txcurp" disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <label for="txfnac">F. Nac.</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txfnac" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                           <div class="col-lg-1 text-right">
                                <label for="dlgenero">Genero:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlgenero" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Hombre</option>
                                    <option value="2">Mujer</option>
                                </select>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="dlcivil">Estado civil:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlcivil" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Casado(a)</option>
                                    <option value="2">Divorciado(a)</option>
                                    <option value="3">Soltero(a)</option>
                                    <option value="4">Union libre</option>
                                    <option value="5">Viudo(a)</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1">
                                <label for="txdomicilio">Domicilio</label>
                            </div>
                            <div class="col-lg-7">
                                <input class="form-control" id="txdomicilio" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txtel">Tel.</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txtel"/>
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txcel">Cel.</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txcel"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txcorreo">Correo</label>
                            </div>
                            <div class="col-lg-4">
                                <input class="form-control" id="txcorreo" type="email"/>
                            </div>                            
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txfingres">Fecha de ingreso</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txfingreso" disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <label for="txantiguedad">Antiguedad</label>
                            </div>
                            <div class="col-lg-1">
                                <input class="form-control" id="txantiguedad" disabled="disabled"/>
                            </div>
                            <div class="col-lg-1">
                                <label for="txantiguedad">meses</label>
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txsueldo">Sueldo:</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txsueldo" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txpuesto">Puesto:</label>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txpuesto" disabled="disabled"/>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txjefe">Autoriza:</label>
                            </div>
                            <div class="col-lg-3">
                                <select class="form-control" id="dlautoriza"></select>
                                
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txempresa">Empresa:</label>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txempresa" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txubicacion">Ubicación:</label>
                            </div>
                            <div class="col-lg-5">
                                <input class="form-control" id="txubicacion" disabled="disabled" />
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txmonto">Monto solicitado</label>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txmonto"/>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="dlplazo">Plazo</label>
                            </div>
                            <div class="col-lg-2">
                                <select class="form-control" id="dlplazo">
                                    <option value="0">Seleccione...</option>
                                    <option value="3">3</option>
                                    <option value="6">6</option>
                                    <option value="12">12</option>
				    <option value="24">24</option>
                                </select>
                            </div>
                            <div class="col-lg-1">
                                <label for="txantiguedad">meses</label>
                            </div>
                        </div>
                        <div class="row">
                             <div class="col-lg-2 text-right">
                                <label for="dlpago">Plan de pagos</label>
                            </div>
                            <div class="col-lg-2">
                                <select class="form-control" id="dlpago">
                                    <option value="0">Seleccione...</option>
                                    <option value="1">Quincenal</option>
                                    <option value="2">Semanal</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label for="txantiguedad">Referencias personales</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label for="txref1">Nombre</label>
                            </div>
                            <div class="col-lg-3">
                                <label for="txref1">Parentesco</label>
                            </div>
                            <div class="col-lg-2">
                                <label for="txref1">Tel Casa</label>
                            </div>
                            <div class="col-lg-2">
                                <label for="txref1">Tel Cel</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input class="form-control" id="txref1n"/>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txref1p"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref1tel"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref1cel"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input class="form-control" id="txref2n"/>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txref2p"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref2tel"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref2cel"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <input class="form-control" id="txref3n"/>
                            </div>
                            <div class="col-lg-3">
                                <input class="form-control" id="txref3p"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref3tel"/>
                            </div>
                            <div class="col-lg-2">
                                <input class="form-control" id="txref3cel"/>
                            </div>
                        </div>
                        <!--
                        <div class="row">
                            <div class="col-lg-8">
                                <input type="checkbox" id="cbpolpar" class="cb"/>
                                <label for="cbpolpar">¿Tiene parentezco con alguna persona póliticamente expuesta?</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-8">
                                <input type="checkbox" id="cbpoles" class="cb"/>
                                <label for="cbpoles">¿Es usted una persona póliticamente expuesta?</label>
                            </div>
                        </div>
                        -->
                        <br />
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Documentación anexa:</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2">
                                <input type="checkbox" id="cbcomprobante" class="cb"/>
                                <label for="cbcomprobante">Domicilio</label>
                            </div>
                            <!--
                            <div class="col-lg-2">
                                <input type="checkbox" id="cbingresos" class="cb"/>
                                <label for="cbingresos">Ingresos</label>
                            </div>
                            -->
                            <div class="col-lg-2">
                                <input type="checkbox" id="cbidentifica" class="cb"/>
                                <label for="cbidentifica">Identificación</label>
                            </div>
                        </div>
                    </div>
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txmonto1">Monto</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txmonto1" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txinteres">Tasa de Interes</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txinteres" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txinteres">%</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txpago">Total a pagar</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpago" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txbusca">Período donde aplica el primer descuento</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="text" class="form-control" id="txanioamort"/>
                                </div>
                                <div class="col-lg-4">
                                    <select class="form-control" id="dlperiodo"></select>
                                </div>
                                <div class="col-lg-1 text-right h5">
                                    <label for="txfecfin">Fecha:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txfecfin" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Calcular" id="btcalcula" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="tbheader col-lg-12" style="height:300px; overflow-y:scroll">
                                    <table class="table table-condensed" id="tbbusca">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>Pago No.</span></th>
                                                <th class="bg-navy"><span>Período pago</span></th>
                                                <th class="bg-navy"><span>Fecha de pago</span></th>
                                                <th class="bg-navy"><span>Pago capital</span></th>
                                                <th class="bg-navy"><span>Intereses</span></th>
                                                <th class="bg-navy"><span>Pago total</span></th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txpago">Importe por pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpagoind" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6">
                                    <label for="txpago">Total de pagos:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpagotot" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-info fa fa-m" value="Guardar" id="btgenera" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divmodal3">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Formato</label>
                                </div>
                                <div class="col-lg-5">
                                    <select class="form-control" id="dlformato">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Solicitud de prestamo</option>
                                        <option value="2">Carta de pre-autorización</option>
                                        <option value="3">Carta de autorización</option>
                                        <option value="4">Tabla de amortización</option>
                                        <option value="5">Contrato</option>
                                        <option value="6">Pagaré</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Imprimir" id="btimprimef" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="divmodal">
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
                                <table class="table table-condensed" id="tbbusca1">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>No. Emp</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Cliente</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="bttabla" class="puntero"><a><i class="fa fa-navicon"></i>Tabla de amortización</a></li>                        
                        <li id="btimprime" class="puntero"><a><i class="fa fa-save"></i>Imprimir</a></li>
                        <%--<li id="btgdocumento" class="puntero"><a><i class="fa fa-navicon"></i>Genera documentos</a></li>--%>
                        <li id="btlibera" class="puntero"><a><i class="fa fa-dollar"></i>Liberar</a></li>
                        <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Salir</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
