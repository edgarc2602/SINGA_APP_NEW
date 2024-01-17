<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_Ticket.aspx.vb" Inherits="App_Operaciones_Ope_Pro_Ticket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE TICKET</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="../Content/css/General.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../Content/css/proyectos/Generalftp.css" type="text/css" media="screen" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" /> <!--LINK PARA EL FONDO DE MENU-->
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
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
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var f = new Date();
            var dd = f.getDate()
            //alert(dd.toString().length);
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            cargames(mm);
            if (mm.toString.length == 1) {
                mm = "0" + mm
            }
            $('#txfalta').val(dd + "/" + mm  + "/" + f.getFullYear());
            $('#txfalta').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txftermino').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvcobertura').hide();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            dialog2 = $('#dvmodal3').dialog({
                autoOpen: false,
                height: 150,
                width: 600,
                modal: true,
                close: function () {
                }
            });
            dialog3 = $('#dvmodal4').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            //cargausuario();
            cargacliente();
            bloqueaestatus();
            cargaarea();
            cargatipo();
            cargaejecutivo();
            $('#btnuevo').click(function () {
                limpia();
                desbloqueatodo();
                bloqueaestatus()
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var fini = $('#txfalta').val().split('/');
                    var falta = fini[2] + fini[1] + fini[0];
                    if ($('#txftermino').val() != '') {
                        var ffin = $('#txftermino').val().split('/');
                        var fter = ffin[2] + ffin[1] + ffin[0];
                    }
                    var xmlgraba = '<Movimiento><ticket id="' + $('#txid').val() + '" tipo="' + $('#dltiposervicio').val() + '" falta="' + falta + '" halta="' + $('#txhora').val() + '" mes="' + $('#dlmes').val() + '" cliente="' + $('#dlcliente').val() + '"';
                    xmlgraba += ' gerente="' + $('#idgerente').val() + '" sucursal="' + $('#dlinmueble').val() + '" sucursalnom="' + $('#dlinmueble option:selected').text() + '" localidad="' + $('#txlocalidad').val() + '" ambito="' + $('#dlambito').val() + '"'
                    xmlgraba += ' reporta="' + $('#txreporta').val() + '" atiende="' + $('#dlejecutivo').val() + '" incidencia="' + $('#dlincidencia').val() + '"';
                    xmlgraba += ' causa="' + $('#dlcausa').val() + '" descripcion="' + $('#txdescripcion').val() + '" estatus="' + $('#dlestatus').val() + '"';
                    xmlgraba += ' accionc="' + $('#txaccionc').val() + '" accionp="' + $('#txaccionp').val() + '"';
                    if ($('#txftermino').val() != '') {
                        xmlgraba += ' ftermino="' + fter + '" htermino="' + $('#txhtermino').val() + '"';
                    } else {
                        xmlgraba += ' ftermino="' + '' + '" htermino = "' + '' + '" ';
                    }
                    xmlgraba += ' cobertura="' + $('#dlcobertura').val() + '" cubre="' + $('#txcubre').val() + '" area="' + $('#dlarea').val() + '" correos="' + $('#txcorreos').val() + '" />';
                    /*$("#lsarea option").each(function () {
                        xmlgraba += '<area idarea="' + $(this).val() + '"/>'
                    });*/
                    xmlgraba += '</Movimiento>';
                   // alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, $('#txid').val(), function (res) {
                        $('#idticket').val(res);
                        PageMethods.extras(res, function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            $('#txid').val(datos.idticket);
                            $('#txfolio').val(datos.folio);
                            closeWaitingDialog();
                            alert('Registro completado.');
                            desbloqueaestado()
                        }, iferror);
                        
                    },iferror);
                }
            })
            $('#btaccion').click(function () {
                $("#divmodal").dialog('option', 'title', 'Acciones');
                dialog.dialog('open');
            })
            $('#btbitacora').click(function () {
                cargabitacora();
                $("#divmodal1").dialog('option', 'title', 'Bitacora');
                dialog1.dialog('open');
            })
            $('#btcorreo').click(function () {
                PageMethods.correosadicionales( $('#txid').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#txcorreos1').val(datos.correos);
                    $("#dvmodal4").dialog('option', 'title', 'reenvió de correo');
                    dialog3.dialog('open');
                }, iferror);
               
            })
            if ($('#idticket').val() != 0) {
                cargareporte($('#idticket').val());
            } else {
                startTime();
            }
            $('#btagregabit').click(function () {
                PageMethods.guardabitacora($('#idticket').val(), $('#txbitacora').val(), $('#idusuario').val(), function () {
                    cargabitacora();
                }, iferror);
            })
            $('#btacciones').click(function () {
                PageMethods.guardaacciones($('#idticket').val(), $('#txaccionc').val(), $('#txaccionp').val(), function () {
                    alert('Comentarios actualizados');
                    dialog.dialog('close');
                }, iferror);
                
            })
            $('#btimprime').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=ticket.rpt&v_formula={Tbl_Ticket.No_Ticket} = ' + $('#txid').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
               // window.open('Ope_Ticket_PDF.aspx?id=' + $('#idticket').val(), '_blank', 'top = 100, left = 300, width = 1000, height = 500')
            })
            $('#txftermino').change(function () {
                calculatiempodosfechas();
            })
            $('#txhtermino').change(function () {
                calculatiempodosfechas();
            })
            $('#btincidencia').click(function () {
                $("#dvmodal3").dialog('option', 'title', 'Registro de Incidencia');
                $('#lbincidencia').text('Incidencia');
                dialog2.dialog('open');
            })
            $('#btcausa').click(function () {
                $("#dvmodal3").dialog('option', 'title', 'Registro de causa/origen');
                $('#lbincidencia').text('Causa/Origen');
                dialog2.dialog('open');
            })
            $('#btagregainc').click(function () {
                var tipo = 0;
                if ($('#lbincidencia').text() == 'Incidencia') {
                    tipo = 1;
                } else { tipo = 2;}

                var xmlgraba = '<movimiento tipo="' + tipo + '" desc="' + $('#txincidencia').val() + '"/>';
                PageMethods.guardaincidencia(xmlgraba, function (res) {
                    alert('Registro agregado');
                    if (tipo == 1) {
                        $('#idincidencia').val(res)
                        cargaincidencia();
                    } else {
                        $('#idcausa').val(res)
                        cargacausa();
                    }
                    dialog2.dialog('close');
                }, iferror);
            })
            $('#btenvia').click(function () {
                var correos = $('#txcorreos1').val() + $('#txadicional').val()    
                PageMethods.reenviacorreo($('#txid').val(), correos, function () {
                    alert('Correo reenviado con exito');
                    dialog3.dialog('close');
                }, iferror);
            })
        });
        /*
        function cargausuario() {
            PageMethods.cteuser($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#cteusuario').val(datos.cliente);
                
                //cargatipo(datos.cliente);
                //cargaarea(datos.cliente);
               // cargaejecutivo(datos.cliente);
            });
        }*/
        function bloqueaestatus() {
            $('#txaccionc').prop("disabled", true);
            $('#txaccionp').prop("disabled", true);
            $("#dlestatus").prop("disabled", true);
            $("#txftermino").prop("disabled", true);
            $("#txhtermino").prop("disabled", true);
        }
        function desbloqueaestado() {
            $('#txaccionc').prop("disabled", false);
            $('#txaccionp').prop("disabled", false);
            $("#dlestatus").prop("disabled", false);
            $("#txftermino").prop("disabled", false);
            $("#txhtermino").prop("disabled", false);
        }
        function startTime() {
            today = new Date();
            h = today.getHours();
            m = today.getMinutes();
            s = today.getSeconds();
            m = checkTime(m);
            s = checkTime(s);
            $('#txhora').val(h + ":" + m + ":" + s);
            t = setTimeout('startTime()', 500);
        }
        function endTime() {
            today = new Date();
            h = today.getHours();
            m = today.getMinutes();
            s = today.getSeconds();
            m = checkTime(m);
            s = checkTime(s);
            $('#txhtermino').val(h + ":" + m + ":" + s);
            t = setTimeout('endTime()', 500);
        }
        function checkTime(i) {
            if (i < 10) { i = "0" + i; } return i;
        }
        function cargatipo() {
            PageMethods.tipo($('#cteusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltiposervicio').empty();
                $('#dltiposervicio').append(inicial);
                $('#dltiposervicio').append(lista);
                $('#dltiposervicio').val(0);
                if ($('#idservicio').val() != 0) {
                    $('#dltiposervicio').val($('#idservicio').val());
                } else { $('#dltiposervicio').val(0); }
                $('#dltiposervicio').change(function () {
                    $('#idservicio').val($('#dltiposervicio').val());
                    cargaincidencia();
                    $('#dlcausa').empty();
                })
            }, iferror);
        }
        function valida() {
            if ($('#txfalta').val() == ''){
                alert('Debe capturar la fecha de alta');
                return false;
            }
            if ($('#dlcliente').val() == 0){
                alert('Debe elegir un Cliente');
                return false;
            }
            if ($('#dlgerente').val() == 0){
                alert('Debe elegir un Gerente de Operaciones');
                return false;
            }
            if ($('#txsucursal').val() == ''){
                alert('Debe capturar el Punto de atención');
                return false;
            }
            if ($('#dlestado').val() == 0){
                alert('Debe elegir la Localidad');
                return false;
            }
            if ($('#dlambito').val() == 0){
                alert('Debe elegir el Ambito');
                return false;
            }
            if ($('#txreporta').val() == '') {
                alert('Debe capturar quien Reporta');
                return false;
            }
            if ($('#dlejecutivo').val() == 0) {
                alert('Debe elegir el Ejecutivo que atiende');
                return false;
            }
            if ($('#dlambito').val() == 0) {
                alert('Debe elegir el Ambito');
                return false;
            }
            if ($('#dlorigen').val() == 0) {
                alert('Debe elegir el Origen del ticket');
                return false;
            }
            if ($('#dlincidencia').val() == 0) {
                alert('Debe elegir el tipo de Incidencia');
                return false;
            }
            if ($('#dlcausa').val() == 0) {
                alert('Debe elegir la causa/origen');
                return false;
            }
            if ($('#txdescripcion').val() == '') {
                alert('Debe capturar la descripción del ticket');
                return false;
            }
            if ($('#dlestatus').val() != 0 && $('#txftermino').val() == '') {
                alert('Debe colocar la fecha de termino del ticket');
                return false;
            }
            if ($('#dlestatus').val() != 0 && $('#txhtermino').val() == '') {
                alert('Debe colocar la Hora de termino del ticket');
                return false;
            }
            if ($('#dlestatus').val() != 0 && $('#dlcobertura').val() == 0) {
                if ($('#dlincidencia').val() == 15 || $('#dlincidencia').val() == 34 || $('#dlincidencia').val() == 16) {
                    alert('Debe seleccionar la cobertura');
                    return false;
                }
            }
            if ($('#dlcobertura').val() == 1 && $('#txcubre').val() == '') {
                alert('Debe colocar el Nombre de quien cubrio');
                return false;
            }
            return true;
        }
        function limpia() {
            $('#txid').val(0);
            $('#txfolio').val('');
            var f = new Date();
            if (dd.toString.length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString.length == 1) {
                mm = "0" + mm
            }
            $('#txfalta').val(f.getDate() + "/" + mm + "/" + f.getFullYear());

            $('#dltiposervicio').val(0);
            $('#dlcliente').val(0);
            $('#dlinmueble').empty();
            $('#dlgerente').val(0);
            $('#txsucursal').val('');
            $('#dlestado').val(0);
            $('#dlambito').val(0);
            $('#txreporta').val('');
            $('#dlejecutivo').val(0);
            $('#dlorigen').val(0);
            $('#dlincidencia').val(0);
            $('#idincidencia').val(0);
            $('#dlcausa').val(0);
            $('#idcausa').val(0);
            $('#dlarea').val(0);
            $('#idarea').val(0);
            //$('#lsarea').empty();
            $('#txdescripcion').val('');
            $('#dlestatus').val(0);
            $('#txftermino').val('');
            $('#txhtermino').val('');
            $('#txtiempo').val('');
            startTime();
            $('#dvcobertura').hide();
            $('#txgerente').val('');
            $('#txlocalidad').val('');
            $('#txcorreos').val('');
            $('#txaccionc').val('');
            $('#txaccionp').val('');
        }
        function cargareporte(idticket) {
            PageMethods.cargaticket(idticket, function (detalle) {
                //alert(detalle);
                var datos = eval('(' + detalle + ')');
                
                $('#txid').val(datos.idticket);
                $('#txfolio').val(datos.folio);
                $('#idservicio').val(datos.servicio);  
                cargatipo();
                $('#txfalta').val(datos.falta);    
                $('#txhora').val(datos.hora);    
                $('#dlmes').val(datos.mes);    
                $('#idcliente').val(datos.cliente);    
                cargacliente();
                $('#idinmueble').val(datos.sucursal);  
                cargainmueble($('#idcliente').val());
                $('#idgerente').val(datos.gerente);    
                cargagerente($('#idcliente').val());
                $('#txsucursal').val(datos.sucursal);    
                $('#txlocalidad').val(datos.ubicacion);
                $('#dlambito').val(datos.ambito);    
                $('#txreporta').val(datos.reporta);    
                $('#idejecutivo').val(datos.ejecutivo);  
                cargaejecutivo();
                $('#dlorigen').val(datos.origen);    
                $('#idincidencia').val(datos.incidencia);    
                cargaincidencia();
                $('#idcausa').val(datos.causa);   
                cargacausa();
                $('#idarea').val(datos.area)
                cargaarea();
                $('#txdescripcion').val(datos.desc);   
                $('#dlestatus').val(datos.estatus);   
                $('#txaccionc').val(datos.accionc);   
                $('#txaccionp').val(datos.accionp);   
                $("#txfalta").prop("disabled", true);
                $("#txhora").prop("disabled", true);
                $("#dlestatus").prop("disabled", false);
                $("#txftermino").prop("disabled", false);
                $("#txhtermino").prop("disabled", false);
                $("#txftermino").val(datos.ftermino);   
                $("#txhtermino").val(datos.htermino);   
                if (datos.incidencia == 15 || datos.incidencia == 34 || datos.incidencia == 16) {
                    $('#dvcobertura').show();
                }
                $('#dlcobertura').val(datos.cubre);   
                $('#txcubre').val(datos.ncubre);  
                $('#txcorreos').val(datos.correos);  
                desbloqueaestado(); 
                if (datos.estatus == 2 || datos.estatus == 3) {
                    bloqueatodo();
                }
                //endTime();
            }, iferror);
        }
        function cargames(mes) {
            PageMethods.mes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlmes').append(lista);
                $('#dlmes').val(mes);
            }, iferror);
        }
        function cargaincidencia() {
            PageMethods.incidencia($('#idservicio').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlincidencia').empty();
                $('#dlincidencia').append(inicial);
                $('#dlincidencia').append(lista);
                if ($('#idincidencia').val() != 0) {
                    $('#dlincidencia').val($('#idincidencia').val());
                } else { $('#dlincidencia').val(0); }
                $('#dlincidencia').change(function () {
                    $('#idincidencia').val($('#dlincidencia').val());
                    cargacausa() 
                })
            }, iferror);
        }
        function cargacausa() {
            PageMethods.causa($('#idincidencia').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcausa').empty();
                $('#dlcausa').append(inicial);
                $('#dlcausa').append(lista);
                if ($('#idcausa').val() != 0) {
                    $('#dlcausa').val($('#idcausa').val());
                } else { $('#dlcausa').val(0);}
            }, iferror);
        }
        function cargaarea() {
            PageMethods.area($('#cteusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlarea').empty();
                $('#dlarea').append(inicial);
                $('#dlarea').append(lista);
                $('#dlarea').val(0);
                if ($('#idarea').val() != 0) {
                    $('#dlarea').val($('#idarea').val());
                } else { $('#dlarea').val(0); }
            }, iferror);
        }
        /*
        function cargaareaasignada(folio) {
            PageMethods.areaasignada(folio, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#lsarea').append(lista);
            }, iferror);
        }
        */
        function cargacliente() {
            PageMethods.cliente($('#cteusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val());
                } else { $('#dlcliente').val(0); }
                $('#dlcliente').change(function () {
                    cargagerente($('#dlcliente').val());
                    cargainmueble($('#dlcliente').val());
                })
            }, iferror);
        }
        function cargainmueble(cliente) {
            PageMethods.inmueble(cliente, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlinmueble').empty();
                $('#dlinmueble').append(inicial);
                $('#dlinmueble').append(lista);
                if ($('#idinmueble').val() != 0) {
                    $('#dlinmueble').val($('#idinmueble').val());
                } else { $('#dlinmueble').val(0); }
                $('#dlinmueble').change(function () {
                    PageMethods.localidad($('#dlinmueble').val(), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txlocalidad').val(datos.ubicacion);
                    }, iferror);
                })
            }, iferror);
        }
        function cargagerente(cliente) {
            PageMethods.gerente(cliente, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idgerente').val(datos.id);
                $('#txgerente').val(datos.desc);
            }, iferror);
        }
        function cargaejecutivo() {
            PageMethods.ejecutivo($('#cteusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlejecutivo').empty();
                $('#dlejecutivo').append(inicial);
                $('#dlejecutivo').append(lista);
                if ($('#idejecutivo').val() != 0) {
                    $('#dlejecutivo').val($('#idejecutivo').val());
                } else { $('#dlejecutivo').val(0); }
            }, iferror);
        }
        function cargabitacora() {
            PageMethods.bitacoras($('#idticket').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbitacora tbody').remove();
                $('#tbbitacora').append(ren);
                
            }, iferror);
        }
        function calculatiempodosfechas() {
            var finicio = $('#txfalta').val().split("/");
            var hinicio = $('#txhora').val().split(":");
            var start_actual_time = new Date(finicio[1] + "/" + finicio[0] + "/" + finicio[2] + ' ' + $('#txhora').val());
            //alert(start_actual_time);
            var ffin = $('#txftermino').val().split("/"); 
            //end_actual_time = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);
            if ($('#txhtermino').val() != '') {
                end_actual_time = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2] + ' ' + $('#txhtermino').val());
            } else {
                end_actual_time = new Date(ffin[1] + "/" + ffin[0] + "/" + ffin[2]);
            }
            //alert(end_actual_time);
            var diff = end_actual_time - start_actual_time
            //alert(diff);
            var diffseconds = diff / 1000;
            var HH = Math.floor(diffseconds / 3600);
            var MM = Math.floor(diffseconds % 3600) / 60;
            var dias = Math.floor(HH / 24);
            HH = Math.floor(HH % 24);
            var formatted = " Dia(s):" + ((dias < 10) ? ("0" + dias) : dias) + " Hora(s):" + ((HH < 10) ? ("0" + HH) : HH) + " Minuto(s):" + ((MM < 10) ? ("0" + MM) : MM)
            $('#txtiempo').val(formatted);
            //return formatted;
        }
        function bloqueatodo() {
            $('#dltiposervicio').prop("disabled", true);
            $('#txfalta').prop("disabled", true);
            $('#txhora').prop("disabled", true);
            $('#dlmes').prop("disabled", true);
            $('#dlcliente').prop("disabled", true);
            $('#dlinmueble').prop("disabled", true);
            $('#dlgerente').prop("disabled", true);
            $('#txsucursal').prop("disabled", true);
            $('#dlestado').prop("disabled", true);
            $('#dlambito').prop("disabled", true);
            $('#txreporta').prop("disabled", true);
            $('#dlejecutivo').prop("disabled", true);
            $('#dlorigen').prop("disabled", true);
            $('#dlincidencia').prop("disabled", true);
            $('#dlcausa').prop("disabled", true);
            $('#txdescripcion').prop("disabled", true);
            $('#dlestatus').prop("disabled", true);
            $('#txaccionc').prop("disabled", true);
            $('#txaccionp').prop("disabled", true);
            $("#txftermino").prop("disabled", true);
            $("#txhtermino").prop("disabled", true);
            $('#dlcobertura').prop("disabled", true);
            $('#txcubre').prop("disabled", true);
            $('#dlarea').prop("disabled", true);
            $('#lsarea').prop("disabled", true);
            $('#dlanio').prop("disabled", true);
            $('#btguarda').prop("disabled", true);
            $('#btaccion').prop("disabled", true);
            $('#btbitacora').prop("disabled", true);
            $('#txcorreos').prop("disabled", true);
            
        }
        function desbloqueatodo() {
            $('#dltiposervicio').prop("disabled", false);
            $('#txfalta').prop("disabled", false);
            $('#txhora').prop("disabled", false);
            $('#dlmes').prop("disabled", false);
            $('#dlcliente').prop("disabled", false);
            $('#dlinmueble').prop("disabled", false);
            $('#dlgerente').prop("disabled", false);
            $('#txsucursal').prop("disabled", false);
            $('#dlestado').prop("disabled", false);
            $('#dlambito').prop("disabled", false);
            $('#txreporta').prop("disabled", false);
            $('#dlejecutivo').prop("disabled", false);
            $('#dlorigen').prop("disabled", false);
            $('#dlincidencia').prop("disabled", false);
            $('#dlcausa').prop("disabled", false);
            $('#txdescripcion').prop("disabled", false);
            //$('#dlestatus').prop("disabled", false);
            $('#txaccionc').prop("disabled", false);
            $('#txaccionp').prop("disabled", false);
            //$("#txftermino").prop("disabled", false);
           // $("#txhtermino").prop("disabled", false);
            $('#dlcobertura').prop("disabled", false);
            $('#txcubre').prop("disabled", false);
            $('#dlarea').prop("disabled", false);
            $('#lsarea').prop("disabled", false);
            $('#dlanio').prop("disabled", false);
            $('#btguarda').prop("disabled", false); 
            $('#btaccion').prop("disabled", false);
            $('#btbitacora').prop("disabled", false);
            $('#txcorreos').prop("disabled", false);
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
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="cteusuario" runat="server" />
        <asp:HiddenField ID="idticket" runat="server" />
        <asp:HiddenField ID="idservicio" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" />
        <asp:HiddenField ID="idinmueble" runat="server" />
        <asp:HiddenField ID="idgerente" runat="server" />
        <asp:HiddenField ID="idestado" runat="server" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idincidencia" runat="server" />
        <asp:HiddenField ID="idcausa" runat="server" />
        <asp:HiddenField ID="idarea" runat="server" />
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
                    <h1>Registro de Ticket
                        <small>CGO</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Ticket</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        
                            <div class="box box-info">
                                <!-- Horizontal Form -->
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de Ticket</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 text-right">
                                        <label for="txid">No. Ticket:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control text-right" disabled="disabled" value="0" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txfolio">Folio Ticket:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txfalta">Fecha Alta:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfalta" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txhora">Hora:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txhora" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Tipo de servicio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltiposervicio" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Mes de servicio:</label>
                                    </div>
                                    <div class="col-md-2">
                                        <select id="dlmes" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Cliente:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlcliente" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label class="text-right">Gerente:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txgerente" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Punto de atención:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlinmueble" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label class="text-right">Localidad:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txlocalidad" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Ambito:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlambito" class="form-control">
                                            <option value="0">Seleccione..</option>
                                            <option value="1">Local</option>
                                            <option value="2">Foraneo</option>
                                        </select>
                                    </div>
                                    <!--
                                    <div class="col-lg-2 text-right">
                                         <label>Origen del reporte:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlorigen" class="form-control">
                                            <option value="0">Seleccione..</option>
                                            <option value="1">Interno</option>
                                            <option value="2">Externo</option>
                                        </select>
                                    </div>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label class="text-right">Reporta:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txreporta" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label>Ejecutivo que atiende:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlejecutivo" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <!--<span id="btincidencia" class="fa fa-navicon text-danger" style="cursor:pointer" title="Agregar Incidencia"></span> -->
                                        <label>Incidencia/Especialidad</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlincidencia" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <!--<span id="btcausa" class="fa fa-navicon text-danger" style="cursor:pointer" title="Agregar Causa"></span> -->
                                        <label>Origen/Problema:</label> 
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlcausa" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2  text-right">
                                         <label >Areas resposables:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlarea" class="form-control" ></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2  text-right">
                                        <label>Descripción del reporte:</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <textarea class="form-control" rows="4" id="txdescripcion"></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2  text-right">
                                        <label for="txcorreos">Correos del cliente:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input class="form-control" type="text" id="txcorreos"/>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-5">
                                        <label for="txaccionc">Acciones Correctivas</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <label for="txaccionp">Acciones Preventivas</label>
                                    </div>
                                    <div>
                                        <div class="col-lg-5">
                                            <textarea id="txaccionc" class="form-control" rows="4"></textarea>
                                        </div>
                                        <div class="col-lg-5">
                                            <textarea id="txaccionp" class="form-control" rows="4"></textarea>
                                        </div>
                                    </div>
                                </div> 
                                <div class="row">
                                    <div class="col-lg-2  text-right">
                                        <label>Estatus:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestatus" class="form-control" disabled="disabled">
                                            <option value="0">Alta</option>
                                            <option value="1">Atendido</option>
                                            <option value="2">Cerrado</option>
                                            <option value="4">Cerrado sin cubrir</option>
                                            <option value="3">Cancelado</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label>F. termino:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txftermino" class="form-control" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label class="text-right">H. termino:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txhtermino" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row" id="dvcierre">
                                    
                                    <!--<div class="col-lg-1">
                                        <label class="text-right">Tiempo transcurrido:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txtiempo" class="form-control" disabled="disabled"/>
                                    </div>-->
                                </div>
                                <div class="row" id="dvcobertura">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlcobertura">Cobertura:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlcobertura" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Se cubrio</option>
                                            <option value="2">No se cubrio</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcubre" class="text-right">Se cubrió con:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcubre" class="form-control" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btaccion" class="puntero"><a><i class="fa fa-arrows"></i>Acciones</a></li>
                                    <li id="btbitacora" class="puntero"><a><i class="fa fa-navicon"></i>Ver bitácora</a></li>
                                    <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                                    <li id="btcorreo" class="puntero"><a><i class="fa fa-envelope"></i>Enviar por correo</a></li>
                                    <li id="btsalir1"  class="puntero" onclick="history.back();"><a ><i class="fa fa-sign-out" ></i>Salir</a></li>
                                </ol>
                            </div>
                        </div>
                    
                </div>
            </div>
        </div>
        <div id="divmodal">
            
            <div class="row">
                <div class="col-lg-12">
                    <button type="button" id="btacciones" class="btn btn-info pull-right">Actualizar</button>
                </div>
            </div>
        </div>
        <div id="divmodal1">
            <div class="row">
                <div class="col-lg-6">
                    <label for="txbitacora">Comentarios</label>
                </div>
                <div class="col-lg-8">
                    <textarea id="txbitacora" class="form-control"></textarea>
                </div>
                <div class="col-lg-1">
                    <button type="button" id="btagregabit" class="btn btn-info">+</button>
                </div>
            </div>
            <div class="row">
                <table class=" col-md-12 tbheader table-responsive" id="tbbitacora">
                    <thead>
                        <tr>
                            <th class="bg-navy">Ticket</th>
                            <th class="bg-navy">Fecha</th>
                            <th class="bg-navy">Ejecutivo</th>
                            <th class="bg-navy">Comentario</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div id="dvmodal3">
             <div class="row">
                <div class="col-lg-6">
                    <label for="txincidencia" id="lbincidencia">Incidencia</label>
                </div>
                <div class="col-lg-8">
                    <input type="text" id="txincidencia" class="form-control" />
                </div>
                <div class="col-lg-1">
                    <button type="button" id="btagregainc" class="btn btn-info">+</button>
                </div>
            </div>
        </div>
        <div id="dvmodal4">
            <div class="row">
                <div class="col-lg-4">
                    <label for="txcorreos1">Destinatarios originales:</label>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-8">
                    <textarea id="txcorreos1" class="form-control" rows="3"> </textarea>
                </div>
            </div>
            <div class="row">
                 <div class="col-lg-4">
                    <label for="txadicional">Copiar a:</label>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-8">
                    <textarea id="txadicional" class="form-control" rows="3"> </textarea>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-1">
                    <button type="button" id="btenvia" class="btn btn-warning">Enviar</button>
                </div>   
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
