<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Empleado.aspx.vb" Inherits="App_RH_RH_Cat_Empleado" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE EMPLEADOS</title>
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
            $('#dvcliente').hide();
            $('#dvdatos').hide();
            $('#dvcapacita').hide();
            $('#txfnac').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfeccapa').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfinfonavit').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfingreso').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfinfonavit').prop("disabled", true);
            $('#dltipo1').prop("disabled", true);
            $('#txmonto').prop("disabled", true);
            dialog = $('#dvcarga').dialog({
                autoOpen: false,
                height: 400,
                width: 800,
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
            cargabancos();
            cargaestado();
            cargalugar();
            cargacliente();
            cargapuesto();
            cargaturno();
            cargaarea();
            cuentaempleado();
            cargalista();
            cargadocumento();
            if ($('#idvacante').val() != 0) {
                waitingDialog({});
                $('#dvtabla').hide();
                $('#dvdatos').show();
                $('#dvcliente').show();
                PageMethods.cargavacante($('#idvacante').val(), function (detalle) {
                    closeWaitingDialog();
                    var datos = eval('(' + detalle + ')');
                    $('#idempresa').val(datos.empresa);
                    $('#idcliente').val(datos.cliente);
                    cargaempresa()
                    cargacliente();
                    $('#idsucursal').val(datos.inmueble);
                    cargainmueble(datos.cliente);
                    $('#idpuesto').val(datos.puesto);
                    cargapuesto();
                    $('#idturno').val(datos.turno);
                    cargaturno();
                    $('#idplantilla').val(datos.plantilla);
                    $('#posicion').val(datos.posicion);
                    $('#txsueldo').val(datos.salario);
                    $('#sueldo').val(datos.salario);
                    $('#txjornal').val(datos.jornal);
                    $('#dlforma').val(datos.formapago);
                    if (datos.cliente == 136) {
                        $('#dltipo').val(1);
                        $('#dltipo').val(1);
                    } else {
                        $('#dltipo').val(2);
                    }
                    calculasalarios();
                    avacante();
                }, iferror);
            }
            if ($('#idreingreso').val() != 0) {
                cargareingreso();
            }
            $('#btdomicilio').click(function () {
                window.open('RH_Cat_empleado_Direccion.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txpaterno').val() + ' ' + $('#txmaterno').val() + ' ' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 1200, height = 400')
            });
            $('#btsueldo').click(function () {
                window.open('RH_Cat_empleado_Sueldo.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txpaterno').val() + ' ' + $('#txmaterno').val() + ' ' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 1200, height = 450')
            });
            $('#dltipo').change(function () {
                if ($('#dltipo').val() == 3) {
                    $('#dvcliente').hide();
                } else {
                    if ($('#dltipo').val() == 1) {
                        if ($('#idusuario').val() == 1 || $('#idusuario').val() == 84) {
                            $('#dvcliente').show();
                        } else {
                            alert('Usted no tiene permisos para modificar o registrar personal administrativo');
                            $('#dltipo').val(0);
                        }
                    } else {
                        $('#dvcliente').show();
                    }
                }
            })
            $('#txcurp').focusout(function () {
                $('#txcurp').val($.trim($('#txcurp').val()));
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btnuevo1').on('click', function () {
                alert('Para registrar personal nuevo, es necesario seleccionar primero una vacante de personal');
                /*limpia();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);*/
            })
            $('#btnuevo2').on('click', function () {
                alert('Para registrar personal nuevo, es necesario seleccionar primero una vacante de personal');
                /*limpia();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);*/
            })
            $('#btnuevo').on('click', function () {
                alert('Para registrar personal nuevo, es necesario seleccionar primero una vacante de personal');
                //limpia();
            })
            $('#btelimina').on('click', function () {
                if ($('#idusuario').val() == 1) {
                    if ($('#txid').val() != '0') {
                        PageMethods.elimina($('#txid').val(), function (res) {
                            alert('Registro eliminado');
                            limpia();
                            cargalista();
                            $('#dvtabla').show();
                            $('#dvdatos').hide();
                        }, iferror);
                    } else { alert('Antes de eliminar debe elegir un Empleado'); }
                } else { alert('Ustede no tiene permiso de ejecutar esta acción');}
            })
            $('#btguarda').click(function () {
                calculaRFC();
                var pensionado = 0
                if ($('#cbss').prop('checked')) {
                    pensionado = 1
                }
                if (valida()) {
                    PageMethods.buscacurp($('#txcurp').val(), $('#txid').val(), function (res) {
                        if (res != 0) {
                            alert('El CURP que esta capturando corresponde con un Empleado activo, debe verificar los datos, confirme que no este duplicando el registro del empleado');
                        } else {
                            PageMethods.buscarfc($('#txrfc').val(), $('#txid').val(), function (res) {
                                if (res != 0) {
                                    alert('El RFC que esta capturando corresponde con un Empleado activo, debe verificar los datos, confirme que no este duplicando el registro del empleado');
                                } else {
                                    PageMethods.buscarss($('#txss').val(), $('#txid').val(), pensionado, function (res) {
                                        if (res != 0) {
                                            alert('El Número de Seguro social que esta capturando corresponde con un Empleado activo, debe verificar los datos, confirme que no este duplicando el registro del empleado');
                                        } else {
                                            PageMethods.buscarclabe($('#txclabe').val(), $('#txid').val(),  function (res) {
                                                if (res != 0) {
                                                    alert('La clabe interbancaria que esta capturando corresponde con un Empleado activo, debe verificar los datos, confirme que no este duplicando el registro del empleado');
                                                } else {
                                                    PageMethods.buscarcuenta($('#txcuenta').val(), $('#txid').val(), function (res) {
                                                        if (res != 0) {
                                                            alert('La cuenta bancaria que esta capturando corresponde con un Empleado activo, debe verificar los datos, confirme que no este duplicando el registro del empleado');
                                                        } else {
                                                            waitingDialog({});
                                                            var inm = 0
                                                            if ($('#txfnac').val() != '') {
                                                                var fini = $('#txfnac').val().split('/');
                                                                var fnac = fini[2] + fini[1] + fini[0];
                                                            } else {
                                                                fnac = '';
                                                            }
                                                            if ($('#dlsucursal').val() != null) {
                                                                inm = $('#dlsucursal').val();
                                                            }
                                                            var f = new Date();
                                                            var mm = f.getMonth() + 1
                                                            if (mm.toString.length == 1) {
                                                                mm = "0" + mm
                                                            }
                                                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                                                            var nombre = $('#txpaterno').val() + ' ' + $('#txmaterno').val() + ' ' + $('#txnombre').val();
                                                            var resumen = 'Turno: ' + $('#dlturno option:selected').text() + ' jornal: ' + $('#txjornal').val();
                                                            var estatus = 1
                                                            if ($('#idvacante').val() == 0) {
                                                                estatus = 2
                                                            }
                                                            var ejecutivo = 0
                                                            if ($('#dlpuesto').val() == 28) {
                                                                ejecutivo = 1
                                                            }
                                                            var encargado = 0
                                                            if ($('#dlpuesto').val() == 30) {
                                                                encargado = 1
                                                            }
                                                            var coordina = 0
                                                            if ($('#dlpuesto').val() == 39 || $('#dlpuesto').val() == 40) {
                                                                coordina = 1
                                                            }
                                                            var fing = $('#txfingreso').val().split('/');
                                                            var fingreso = fing[2] + fing[1] + fing[0];
                                                            if ($('#txfinfonavit').val() != '') {
                                                                finf = $('#txfinfonavit').val().split('/');
                                                                var finfonavit = finf[2] + finf[1] + finf[0];
                                                            } else { var finfonavit = '' }
                                                            var inf = 0;
                                                            if ($('#cbinfonavit').is(':checked')) {
                                                                inf = 1;
                                                            }
                                                            var xmlgraba = '<empleado id= "' + $('#txid').val() + '" tipo = "' + $('#dltipo').val() + '" empresa = "' + $('#dlempresa').val() + '"  cliente= "' + $('#dlcliente').val() + '" inmueble="' + inm + '" puesto= "' + $('#dlpuesto').val() + '" turno= "' + $('#dlturno').val() + '" ';
                                                            xmlgraba += ' jornal= "' + $('#txjornal').val() + '" apellidop= "' + $('#txpaterno').val() + '" apellidom = "' + $.trim($('#txmaterno').val()) + '" nombre= "' + $('#txnombre').val() + '"';
                                                            xmlgraba += ' rfc= "' + $('#txrfc').val() + '" curp= "' + $('#txcurp').val() + '" ss = "' + $('#txss').val() + '" fnac= "' + fnac + '"';
                                                            xmlgraba += ' lugar= "' + $('#dllugar').val() + '" nacion = "' + $('#txnacion').val() + '" genero= "' + $('#dlgenero').val() + '"';
                                                            xmlgraba += ' ecivil= "' + $('#dlcivil').val() + '" talla= "' + $('#txtalla').val() + '" correo = "' + $('#txcorreo').val() + '" fuente= "' + $('#txfuente').val() + '" vacante= "' + $('#idvacante').val() + '" estatus= "' + estatus + '"';
                                                            xmlgraba += ' encargado= "' + encargado + '" coordina= "' + coordina + '" ejecutivo="' + ejecutivo + '" tallac="' + $('#txtallac').val() + '" area="' + $('#dlarea').val() + '" pensionado = "' + pensionado + '"'
                                                            xmlgraba += ' sueldo= "' + $('#txsueldo').val() + '" simss = "' + $('#txsueldoimss').val() + '"  sdi= "' + $('#txdiario').val() + '" fingreso="' + fingreso + '" formapago= "' + $('#dlforma').val() + '" banco= "' + $('#dlbanco').val() + '"';
                                                            xmlgraba += ' clabe= "' + $('#txclabe').val() + '" cuenta= "' + $('#txcuenta').val() + '" tarjeta = "' + $('#txtarjeta').val() + '" inf= "' + inf + '" fcredito= "' + finfonavit + '"'
                                                            xmlgraba += ' tipoc= "' + $('#dltipo1').val() + '" montoc= "' + $('#txmonto').val() + '"'
                                                            xmlgraba += ' calle= "' + $('#txcalle').val() + '" noext = "' + $('#txnoext').val() + '"  noint= "' + $('#txnoint').val() + '" colonia="' + $('#txcolonia').val() + '" cp= "' + $('#txcp').val() + '" municipio= "' + $('#txmunicipio').val() + '"';
                                                            xmlgraba += ' estado= "' + $('#dlestado').val() + '" tel1= "' + $('#txtel1').val() + '" tel2 = "' + $('#txtel2').val() + '" contacto= "' + $('#txcontacto').val() + '" plantilla= "' + $('#idplantilla').val() + '" usuario= "' + $('#idusuario').val() + '"';
                                                            xmlgraba += ' posicion="' + $('#posicion').val() + '" '
                                                            xmlgraba += ' callef= "' + $('#txcallef').val() + '" coloniaf= "' + $('#txcoloniaf').val() + '" cpf = "' + $('#txcpf').val() + '" municipiof= "' + $('#txmunicipiof').val() + '" estadof= "' + $('#dlestadof').val() + '"/>';
                                                            //alert(xmlgraba);
                                                            PageMethods.guarda(xmlgraba, fecha, $('#dlcliente option:selected').text(), $('#dlpuesto option:selected').text(), $('#dlsucursal option:selected').text(), nombre, resumen, $('#idvacante').val(), $('#idusuario').val(), function (res) {
                                                                closeWaitingDialog();
                                                                if ($('#txid').val() != 0) {
                                                                    if ($('#idbanco').val() != $('#dlbanco').val()) {
                                                                        PageMethods.cambiobanco($('#txid').val(), $('#idbanco').val(), $('#dlbanco').val(), 'Cambio de banco', $('#idusuario').val(), function () {
                                                                            $('#idbanco').val($('#dlbanco').val())
                                                                        }, iferror)
                                                                    }
                                                                    if ($('#idclabe').val() != $('#txclabe').val()) {
                                                                        PageMethods.cambiobanco($('#txid').val(), $('#idclabe').val(), $('#txclabe').val(), 'Cambio de clabe', $('#idusuario').val(), function () {
                                                                            $('#idclabe').val($('#txclabe').val())
                                                                        }, iferror)
                                                                    }
                                                                    if ($('#idcuenta').val() != $('#txcuenta').val()) {
                                                                        PageMethods.cambiobanco($('#txid').val(), $('#idcuenta').val(), $('#txcuenta').val(), 'Cambio de cuenta', $('#idusuario').val(), function () {
                                                                            $('#idcuenta').val($('#txcuenta').val())
                                                                        }, iferror)
                                                                    }
                                                                    if ($('#idtarjeta').val() != $('#txtarjeta').val()) {
                                                                        PageMethods.cambiobanco($('#txid').val(), $('#idtarjeta').val(), $('#txtarjeta').val(), 'Cambio de tarjeta', $('#idusuario').val(), function () {

                                                                        }, iferror)
                                                                    }
                                                                }
                                                                $('#txid').val(res)
                                                                if ($('#idvacante').val() != 0) {
                                                                    PageMethods.actualizavacante($('#idvacante').val(), function () {
                                                                    })
                                                                }
                                                                alert('Registro completado.');
                                                            }, iferror);
                                                        }
                                                    })
                                                }
                                            })  
                                        }
                                    });
                                }
                            });
                        } 
                    }, iferror);
                }
            })
            $('#btimprime').on('click', function () {
                window.open('../RptForAll.aspx?v_nomRpt=listaempleado.rpt', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
            $('#btbusca').click(function () {
                $('#hdpagina').val(1);
                cuentaempleado();
                cargalista();
            })
            $('#cbss').click(function () {
                if ($('#cbss').prop('checked')) {
                    $('#txss').prop("disabled", true);
                    $('#txss').val('');
                } else {
                    $('#txss').prop("disabled", false);
                }
            })
            $('#txpaterno').focusout(function () {
                $('#txpaterno').val($.trim($('#txpaterno').val().toUpperCase()));
            })
            $('#txmaterno').focusout(function () {
                $('#txmaterno').val($.trim($('#txmaterno').val().toUpperCase()));
            })
            $('#txnombre').focusout(function () {
                $('#txnombre').val($.trim($('#txnombre').val().toUpperCase()));
            })
            $('#txsueldo').change(function () {
                calculasalarios();
            })
            $('#btdocumento').click(function () {
                $("#dvcarga").dialog('option', 'title', 'Documentos de empleado');
                $('#dltipodocto').val(0);
                $('#txarchivo').val('');
                cargadoctos($('#txid').val());
                dialog.dialog('open');
            })
            /*
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
            */
            $('#cbinfonavit').change(function () {
                if ($('#cbinfonavit').is(':checked')) {
                    $('#txfinfonavit').prop("disabled", false);
                    $('#dltipo1').prop("disabled", false);
                    $('#txmonto').prop("disabled", false);
                } else {
                    $('#txfinfonavit').prop("disabled", true);
                    $('#dltipo1').prop("disabled", true);
                    $('#txmonto').prop("disabled", true);
                    $('#txfinfonavit').val('');
                    $('#dltipo1').val(0);
                    $('#txmonto').val(0);
                }
            })
        });
        function bloqueavacante() {
            //$('#dlempresa').prop("disabled", true);
            $('#dlcliente').prop("disabled", true);
            $('#dlsucursal').prop("disabled", true);
            $('#dlpuesto').prop("disabled", true);
            $('#dlturno').prop("disabled", true);
            $('#txjornal').prop("disabled", true);
            //$('#txsueldo').prop("disabled", true);
            $('#dlforma').prop("disabled", true);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaempleado() {
            PageMethods.contarempleado($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
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
            PageMethods.empleado($('#hdpagina').val(), $('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    if ($(this).children().eq(1).text() == 'Administrativo') {
                        if ($('#idusuario').val() == 1 || $('#idusuario').val() == 84) {
                            bloqueavacante();
                            limpia();
                            $('#txid').val($(this).children().eq(0).text());
                            $('#txrfc').val($(this).children().eq(5).text());
                            $('#txcurp').val($(this).children().eq(6).text());
                            datosempleado();
                            $('#dvtabla').hide();
                            $('#dvcapacita').hide();
                            $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                        } else {
                            alert('Usted no tiene permisos para modificar empleados administrativos');
                        }
                    } else {
                        bloqueavacante();
                        limpia();
                        $('#txid').val($(this).children().eq(0).text());
                        $('#txrfc').val($(this).children().eq(5).text());
                        $('#txcurp').val($(this).children().eq(6).text());
                        datosempleado();
                        $('#dvtabla').hide();
                        $('#dvcapacita').hide();
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    }
                });
            }, iferror);
        };
        function cargareingreso() {
            PageMethods.reingreso($('#idreingreso').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#dltipo').val(datos.tipo);
                $('#txpaterno').val(datos.paterno);
                $('#txmaterno').val(datos.materno);
                $('#txnombre').val(datos.nombre);
                $('#txrfc').val(datos.rfc);
                $('#txcurp').val(datos.curp);
                $('#txss').val(datos.ss);
                $('#txfnac').val(datos.fnac);
                $('#txedad').val(datos.edad);
                $('#dllugar').val(datos.lugar);
                $('#txnacion').val(datos.nacion);
                $('#dlgenero').val(datos.genero);
                $('#dlcivil').val(datos.civil);
                $('#txtalla').val(datos.talla);
                $('#txtallac').val(datos.tallac);
                $('#txcorreo').val(datos.correo);
                $('#txfuente').val(datos.fuente);
                if (datos.pensionado == 1) {
                    $('#cbss').prop("checked", true)
                    $('#txss').prop("disabled", true);
                } else {
                    $('#cbss').prop("checked", false)
                    $('#txss').prop("disabled", false);
                }
                $('#txcalle').val(datos.calle);
                $('#txnoext').val(datos.noext);
                $('#txnoint').val(datos.noint);
                $('#txcolonia').val(datos.colonia);
                $('#txcp').val(datos.cp);
                $('#txmunicipio').val(datos.municipio);
                $('#idestado').val(datos.estado);
                cargaestado();
                $('#idlugar').val(datos.lugar);
                cargalugar();
                $('#txtel1').val(datos.tel1);
                $('#txtel2').val(datos.tel2);
                $('#txcontacto').val(datos.contacto);
                $('#idbanco').val(datos.banco);
                cargabancos();
                $('#txclabe').val(datos.clabe);
                $('#txcuenta').val(datos.cuenta);
                $('#txtarjeta').val(datos.tarjeta);
            });
        }
        function datosempleado() {
            PageMethods.detalle($('#txid').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#dltipo').val(datos.tipo);
                if (datos.tipo == 1 || datos.tipo == 2 ) {
                    $('#dvcliente').show();
                }
                $('#dlcliente').val(datos.cliente);
                $('#idcliente').val(datos.cliente);
                $('#idempresa').val(datos.empresa);
                cargaempresa();
                //$('#dlempresa').val(datos.empresa);
                $('#idsucursal').val(datos.inmueble);
                cargainmueble($('#idcliente').val());
                $('#dlpuesto').val(datos.puesto);
                $('#dlturno').val(datos.turno);
                $('#txjornal').val(datos.jornal);
                $('#txpaterno').val(datos.paterno);
                $('#txmaterno').val(datos.materno);
                $('#txnombre').val(datos.nombre);
                $('#txss').val(datos.ss);
                $('#txfnac').val(datos.fnac);
                $('#txedad').val(datos.edad);
                $('#dllugar').val(datos.lugar);
                $('#txnacion').val(datos.nacion);
                $('#dlgenero').val(datos.genero);
                $('#dlcivil').val(datos.civil);
                $('#txtalla').val(datos.talla);
                $('#txtallac').val(datos.tallac);
                $('#txcorreo').val(datos.correo);
                $('#txfuente').val(datos.fuente);
                $('#idarea').val(datos.area);
                cargaarea();
                if (datos.pensionado == 1) {
                    $('#cbss').prop("checked", true)
                    $('#txss').prop("disabled", true);
                } else {
                    $('#cbss').prop("checked", false) 
                    $('#txss').prop("disabled", false);
                }
                $('#txcalle').val(datos.calle);
                $('#txnoext').val(datos.noext);
                $('#txnoint').val(datos.noint);
                $('#txcolonia').val(datos.colonia);
                $('#txcp').val(datos.cp);
                $('#txmunicipio').val(datos.municipio);
                $('#idestado').val(datos.estado);
                cargaestado();
                $('#idlugar').val(datos.lugar);
                cargalugar();
                $('#txtel1').val(datos.tel1);
                $('#txtel2').val(datos.tel2);
                $('#txcontacto').val(datos.contacto);
                $('#txsueldo').val(datos.sueldo);
                $('#txsueldoimss').val(datos.sueldoimss);
                $('#txdiario').val(datos.sdi);
                $('#txfingreso').val(datos.fingreso);
                $('#dlforma').val(datos.formapago);
                $('#idbanco').val(datos.banco);
                cargabancos();
                $('#txclabe').val(datos.clabe);
                $('#idclabe').val(datos.clabe);
                $('#txcuenta').val(datos.cuenta);
                $('#idcuenta').val(datos.cuenta);
                $('#txtarjeta').val(datos.tarjeta);
                $('#idtarjeta').val(datos.tarjeta);
                if (datos.tienecredito == 1) {
                    $('#cbinfonavit').prop("checked", true)
                    $('#txfinfonavit').prop("disabled", false);
                    $('#dltipo1').prop("disabled", false);
                    $('#txmonto').prop("disabled", false);
                } else {
                    $('#cbinfonavit').prop("checked", false)
                    //$('#txss').prop("disabled", false);
                }

                $('#txfinfonavit').val(datos.fcredito);
                $('#dltipo1').val(datos.tipocredito);
                $('#txmonto').val(datos.montocredito);
                $('#confirmado').val(datos.confirma);
                if (datos.confirma == 1) {
                    if ($('#idusuario').val() == 1 || $('#idusuario').val() == 84 || $('#idusuario').val() == 183) {
                        $('#dlbanco').prop("disabled", false);
                        $('#txclabe').prop("disabled", false);
                        $('#txcuenta').prop("disabled", false);
                        $('#txtarjeta').prop("disabled", false);
                    } else {
                        $('#dlbanco').prop("disabled", true);
                        $('#txclabe').prop("disabled", true);
                        $('#txcuenta').prop("disabled", true);
                        $('#txtarjeta').prop("disabled", true);
                    }
                } else {
                    $('#dlbanco').prop("disabled", false);
                    $('#txclabe').prop("disabled", false);
                    $('#txcuenta').prop("disabled", false);
                    $('#txtarjeta').prop("disabled", false);
                }
                $('#sueldo').val(datos.sueldoplantilla);
                $('#txcallef').val(datos.callef);
                $('#txcoloniaf').val(datos.coloniaf);
                $('#txcpf').val(datos.cpf);
                $('#txmunicipiof').val(datos.municipiof);
                $('#idestadof').val(datos.estadof);
                cargaestado();

            }, iferror);
        }
        function limpia() {
            $('#txid').val(0);
            $('#dltipo').val(0);
            $('#dlempresa').val(0);
            $('#dlcliente').val(0);
            $('#dlsucursal').val(0);
            $('#dlpuesto').val(0);
            $('#dlturno').val(0);
            $('#txjornal').val('');
            $('#txpaterno').val('');
            $('#txmaterno').val('');
            $('#txnombre').val('');
            $('#txrfc').val('');
            $('#txcurp').val('');
            $('#txss').val('');
            $('#txfnac').val('');
            $('#txedad').val(0);
            $('#dllugar').val(0);
            $('#txnacion').val('');
            $('#dlgenero').val(0);
            $('#dlcivil').val(0);
            $('#txtalla').val('');
            $('#txcorreo').val('');
            $('#txfuente').val('');
            $('#dvcliente').hide();
            //$('#dvcapacita').show();
            $('#txcalle').val('');
            $('#txnoext').val('');
            $('#txnoint').val('');
            $('#txcolonia').val('');
            $('#txcp').val('');
            $('#txmunicipio').val('');
            $('#idestado').val(0);
            $('#txtel1').val('');
            $('#txtel2').val('');
            $('#txcontacto').val('');
            $('#txsueldo').val(0);
            $('#txsueldoimss').val(0);
            $('#txdiario').val(0);
            $('#txfingreso').val('');
            $('#dlforma').val(0);
            $('#idbanco').val(0);
            $('#txclabe').val('');
            $('#txcuenta').val('');
            $('#txtarjeta').val('');
            $('#cbinfonavit').prop("checked", false)
            $('#txfinfonavit').prop("disabled", true);
            $('#dltipo1').prop("disabled", true);
            $('#txmonto').prop("disabled", true);
            //$('#txfcredito').val('');
            $('#dltipo1').val(0);
            $('#txmonto').val('');
            $('#dlarea').val(0);
            $('#txtallac').val('');
            $('#dlbanco').val(0);
            $('#txfinfonavit').val('');
            $('#dlestado').val(0);
        }
        function valida() {
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de empleado');
                return false;
            }
            if ($('#dlempresa').val() == 0) {
                alert('Debe seleccionar la Empresa pagadora');
                return false;
            }
            if ($('#dlarea').val() == 0) {
                alert('Debe seleccionar la Área');
                return false;
            }
            if ($('#dlpuesto').val() == 0) {
                alert('Debe seleccionar el puesto');
                return false;
            }
            if ($('#dlturno').val() == 0) {
                alert('Debe seleccionar un turno');
                return false;
            }
            if ($('#txpaterno').val() == '') {
                alert('Debe capturar el Apellido Paterno');
                return false;
            }
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el Nombre(s)');
                return false;
            }
            if ($('#dlgenero').val() == 0) {
                alert('Debe seleciconar el Genero');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir un cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe elegir un Punto de atención');
                return false;
            }
            if ($('#txrfc').val() == '') {
                alert('Debe capturar el RFC');
                return false;
            }
            
            var compararfc = $('#txrfc').val().substring(0, 10); 
            //alert(compararfc);
            if (compararfc != $('#rfccalculado').val()) {
                alert('El RFC capturado no parece estar correcto con respecto al nombre del empleado');
                return false;
            }
            if ($('#txrfc').val().length < 13) {
                alert('El RFC capturado esta incorrecto, verifique');
                return false;
            }

            if ($('#txcurp').val() == '') {
                alert('Debe capturar la CURP');
                return false;
            }
            if ($('#txcurp').val().length < 18) {
                alert('La CURP capturada esta incorrecta, verifique');
                return false;
            }
            if ($('#cbss').prop('checked') == false) {
                if ($('#txss').val() == '') {
                    alert('Debe capturar el No. de Seguro Social');
                    return false;
                }
                if ($('#txss').val().length < 11) {
                    alert('El No. de seguro social esta incorrecto, verifique');
                    return false;
                }
            }
            if ($('#txfnac').val() == '') {
                alert('Debe capturar la fecha de nacimiento');
                return false;
            }
            var fnac = $('#txfnac').val().split('/');
            var anac = fnac[2];
                
            var d = new Date();
            var aval = d.getFullYear() - 100
                if (anac < aval) {
                    alert('El año de la fecha de nacimiento esta incorrecto');
                    return false;
            }
            /*
            if ($('#txsueldo').val() == '' || $('#txsueldo').val() == 0) {
                alert('Debe capturar el sueldo mensual');
                return false;
            }
            */
            if (isNaN($('#txsueldo').val()) == true || $('#txsueldo').val() == '') {
                alert('Debe capturar la Salario mensual');
                return false;
            }
            //alert($('#txsueldo').val());
            //alert($('#sueldo').val());
            if (parseFloat($('#txsueldo').val()) > parseFloat($('#sueldo').val())){
                alert('El salario capturado es mas alto que el salario autorizado en plantilla, no puede continuar');
                return false;
            }
            if ($('#txclabe').val() != '' && $('#txclabe').val().length < 18) {
                alert('Si colocas Clabe interbancaria debe ser de 18 digitos');
                return false;
            }
            if ($('#txtarjeta').val() != '' && $('#txtarjeta').val().length < 16) {
                alert('Si colocas Numero de tarjeta debe ser de 16 digitos');
                return false;
            }
            if ($('#txfingreso').val() == '') {
                alert('Debe seleccionar la fecha de ingreso');
                return false;
            }
            var fing = $('#txfingreso').val().split('/');
            var aing = fing[2];

            var d = new Date();
            //alert(d.getFullYear());
            var aval1 = d.getFullYear() - 20
            //alert(aval1);
            if (aing < aval1) {
                alert('El año de la fecha de ingrreso esta incorrecto');
                return false;
            }
            if ($('#dlforma').val() == 0) {
                alert('Debe seleccionar la forma de pago');
                return false;
            }
            /*
            if ($('#txid').val() == 0) {
                if ($('#txfeccapa').val() == '') {
                    alert('Debe seleccionar fecha para capacitación');
                    return false;
                }
                if ($('#dlhcurso').val() == 0) {
                    alert('Debe seleccionar horario para capacitación');
                    return false;
                }
            }
            */
            $('#txcpf').val($.trim($('#txcpf').val()));
            
            if (isNaN($('#txcpf').val()) == true || $('#txcpf').val() == '' || $('#txcpf').val() == '0') {
                alert('Debe capturar el código postal de la dirección fiscal');
                return false;
            }
            if ($('#txcpf').val().length < 5) {
                alert('El código postal de la dirección fiscal no tiene la longitud correcta');
                return false;
            }
            return true;
        }
        function cargaempresa() {
            PageMethods.empresa($('#idcliente').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempresa').empty();
                $('#dlempresa').append(inicial);
                $('#dlempresa').append(lista);
                $('#dlempresa').val(0);
                if ($('#idempresa').val() != '') {
                    $('#dlempresa').val($('#idempresa').val());
                };
            }, iferror);
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
                //$('#dlcliente').val(0);
                if ($('#idcliente').val() != '') {
                    $('#dlcliente').val($('#idcliente').val());
                };
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                });
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
                //$('#dlpuesto').val(0);
                if ($('#idpuesto').val() != '') {
                    $('#dlpuesto').val($('#idpuesto').val());
                };
                /*$('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                });*/
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
                $('#dlturno').val(0);
                if ($('#idturno').val() != '') {
                    $('#dlturno').val($('#idturno').val());
                };
                /*$('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                });*/
            }, iferror);
        }
        function cargaarea() {
            PageMethods.area(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlarea').empty();
                $('#dlarea').append(inicial);
                $('#dlarea').append(lista);
                $('#dlarea').val(0);
                if ($('#idarea').val() != '') {
                    $('#dlarea').val($('#idarea').val());
                };
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
                $('#dlsucursal').val(0);
                if ($('#idsucursal').val() != '') {
                    $('#dlsucursal').val($('#idsucursal').val());
                };
            }, iferror);
        }
        function cargabancos() {
            PageMethods.banco(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlbanco').empty();
                $('#dlbanco').append(inicial);
                $('#dlbanco').append(lista);
                $('#dlbanco').val(0);
                if ($('#idbanco').val() != '') {
                    $('#dlbanco').val($('#idbanco').val());
                };
            }, iferror);
        }
        function cargaestado() {
            PageMethods.estado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);
                if ($('#idestado').val() != '') {
                    $('#dlestado').val($('#idestado').val());
                };
                $('#dlestadof').append(inicial);
                $('#dlestadof').append(lista);
                $('#dlestadof').val(0);
                if ($('#idestadof').val() != '') {
                    $('#dlestadof').val($('#idestadof').val());
                };
            }, iferror);
        }
        
        function cargalugar() {
            PageMethods.lugar(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dllugar').append(inicial);
                $('#dllugar').append(lista);
                $('#dllugar').val(0);
                if ($('#idlugar').val() != '') {
                    $('#dllugar').val($('#idlugar').val());
                };
            }, iferror);
        }
        function cargadocumento() {
            PageMethods.documento( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltipodocto').empty();
                $('#dltipodocto').append(inicial);
                $('#dltipodocto').append(lista);
                
            }, iferror);
        }
        function calculasalarios() {
            var sd = $('#txsueldo').val() / 30.4167
            var sdi = sd * 1.0452
            $('#txsueldoimss').val(sd.toFixed(2));
            $('#txdiario').val(sdi.toFixed(2));
        }
        function calculaRFC() {
            function quitaArticulos(palabra) {
                return palabra.replace("DEL ", "").replace("LAS ", "").replace("DE ",
                    "").replace("LA ", "").replace("Y ", "").replace("A ", "").replace("LOS ", "");
            }
            function esVocal(letra) {
                if (letra == 'A' || letra == 'E' || letra == 'I' || letra == 'O'
                    || letra == 'U' || letra == 'a' || letra == 'e' || letra == 'i'
                    || letra == 'o' || letra == 'u')
                    return true;
                else
                    return false;
            }
            nombre = $("#txnombre").val().toUpperCase();
            apellidoPaterno = $("#txpaterno").val().toUpperCase();
            apellidoMaterno = $("#txmaterno").val().toUpperCase();
            fecha = $("#txfnac").val();
            var rfc = "";
            apellidoPaterno = quitaArticulos(apellidoPaterno);
            apellidoMaterno = quitaArticulos(apellidoMaterno);
            rfc += apellidoPaterno.substr(0, 1);
            var l = apellidoPaterno.length;
            var c;
            for (i = 1; i < l; i++) {
                c = apellidoPaterno.charAt(i);
                if (esVocal(c)) {
                    rfc += c;
                    break;
                }
            }
            rfc += apellidoMaterno.substr(0, 1);
            var n1 = nombre.substr(0, nombre.indexOf(" "));
            if ((n1 == 'JOSE' || n1 == 'MARIA' || n1 == 'MA' || n1 == 'MA.') && n1.length != 0) {
                n1 = nombre.substr(nombre.indexOf(" ") + 1, nombre.length);
            } else {n1= nombre}
            n1 = quitaArticulos(n1);
            rfc += n1.substr(0, 1);
            if (rfc == 'BUEI' || rfc == 'CACA' || rfc == 'CAGA' || rfc == 'CAKA' || rfc == 'COGE' || rfc == 'COJE' || rfc == 'COJO'
                || rfc == 'FETO' || rfc == 'JOTO' || rfc == 'KACO' || rfc == 'KAGO' || rfc == 'KOJO' || rfc == 'KULO' || rfc == 'MAMO'
                || rfc == 'MEAS' || rfc == 'MION' || rfc == 'MULA' || rfc == 'PEDO' || rfc == 'PUTA' || rfc == 'QULO' || rfc == 'RUIN'
                || rfc == 'BUEY' || rfc == 'CACO' || rfc == 'CAGO' || rfc == 'CAKO' || rfc == 'COJA' || rfc == 'COJI' || rfc == 'CULO'
                || rfc == 'GUEY' || rfc == 'KACA' || rfc == 'KAGA' || rfc == 'KOGE' || rfc == 'KAKA' || rfc == 'MAME' || rfc == 'MEAR'
                || rfc == 'MEON' || rfc == 'MOCO' || rfc == 'PEDA' || rfc == 'PENE' || rfc == 'PUTO' || rfc == 'RATA' ) {
                rfc = rfc.substr(0, 3) + "X";
            }
            //alert(rfc);
            rfc += fecha.substr(8, 10);
            rfc += fecha.substr(3, 5).substr(0, 2);
            rfc += fecha.substr(0, 2);
            $('#rfccalculado').val(rfc);
            //alert($('#rfccalculado').val())
        }
        function xmlUpFile(res) {
            if (validadocto()) {
                waitingDialog({});
                var fileup = $('#txarchivo').get(0);
                var files = fileup.files;

                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                var id = $('#txid').val();
                ndt.append("idemp",id);
                $.ajax({
                    url: '../GH_Updoctoemp.ashx',
                    type: 'POST',
                    data: ndt, 
                    contentType: false,
                    processData: false,
                    success: function (res) {
                        closeWaitingDialog();
                        PageMethods.actualizadocto($('#txid').val(), $('#dltipodocto').val(), res, function (res) {
                            $('#dltipodocto').val(0);
                            $('#txarchivo').val('');
                            //alert('El listado se ha marcado como entregado');
                            //dialog1.dialog('close');
                            cargadoctos($('#txid').val());
                            //cargalistados();
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
        }
        function cargadoctos(emp) {
            PageMethods.listadocto(emp, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaa tbody').remove();
                $('#tblistaa').append(ren1);
                $('#tblistaa tbody tr').on('click', '.btver', function () {
                    //alert($(this).closest('tr').find('td').eq(1).text());
                    var carpeta = emp;
                    var arc = $(this).closest('tr').find('td').eq(2).text();
                    window.open('../Doctos/RH/Candidatos/' + carpeta + '/' + arc, '_blank', 'width=650, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                });
                $('#tblistaa tbody tr').on('click', '.btquita', function () {
                    PageMethods.eliminaa($('#txid').val(), $(this).closest('tr').find('td').eq(0).text(), function () {
                        //alert('El listado se ha marcado como entregado');
                        //dialog1.dialog('close');
                        cargadoctos($('#txid').val());
                        //cargalistados();
                        //closeWaitingDialog();
                    })
                });
            }, iferror);
        }
        function validadocto() {
            if ($('#dltipodocto').val() == 0) {
                alert('Debe seleccionar el tipo de documento');
                return false;
            }
            if ($('#txarchivo').val() == '') {
                alert('Debe seleccionar el archivo del acuse antes de continuar');
                return false;
            }
            for (var x = 0; x < $('#tblistaa tbody tr').length; x++) {
                if ($('#tblistaa tbody tr').eq(x).find('td').eq(0).text() == $('#dltipodocto').val()) {
                    alert('Este tipo de documento ya esta agregado, no puede duplicar');
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
        };
    </script>

</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idempresa" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" />
        <asp:HiddenField ID="idsucursal" runat="server" />
        <asp:HiddenField ID="idpuesto" runat="server" />
        <asp:HiddenField ID="idturno" runat="server" />
        <asp:HiddenField ID="idarea" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idvacante" runat="server" Value="0" />
        <asp:HiddenField ID="idbanco" runat="server" Value="0" />
        <asp:HiddenField ID="idclabe" runat="server" Value="0" />
        <asp:HiddenField ID="idcuenta" runat="server" Value="0" />
        <asp:HiddenField ID="idtarjeta" runat="server" Value="0" />
        <asp:HiddenField ID="idestado" runat="server" Value="0" />
        <asp:HiddenField ID="idlugar" runat="server" Value="0" />
        <asp:HiddenField ID="confirmado" runat="server" />
        <asp:HiddenField ID="idreingreso" runat="server" />
        <asp:HiddenField ID="idplantilla" runat="server" />
        <asp:HiddenField ID="sueldo" runat="server" />
        <asp:HiddenField ID="rfccalculado" runat="server" />
        <asp:HiddenField ID="posicion" runat="server" />
        <asp:HiddenField ID="idestadof" runat="server" value="0"/>
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
                    <h1>Catálogo de Empleados<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Catálogo de empleados</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-12">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <h4>DATOS GENERALES</h4>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo de Empleado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Administrativo</option>
                                            <option value="2">Operativo</option>
                                            <!--<option value="3">Jornalero</option>-->
                                        </select>
                                    </div>
                                    <div class="col-lg-5 text-right">
                                        <label for="txid">No. Empleado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlempresa">Empresa:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlempresa" class="form-control">
                                        </select>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dlarea">Area:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlarea" class="form-control"></select>
                                    </div>
                                </div>
                                <div id="dvcliente">
                                    <div class="row">
                                        <div class="col-lg-1 text-right">
                                            <label for="dlcliente">Cliente:</label>
                                        </div>
                                        <div class="col-lg-3">
                                            <select id="dlcliente" class="form-control"></select>
                                        </div>
                                        <div class="col-lg-2">
                                            <label for="dlsucursal">Punto de atención:</label>
                                        </div>
                                        <div class="col-lg-4">
                                            <select id="dlsucursal" class="form-control"></select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="dlpuesto">Puesto:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlpuesto" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="dlturno">Turno:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlturno" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txjornal">Jornal:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txjornal" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txpaterno">Apellido Paterno:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txpaterno" class="form-control" />
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="txmaterno">Apellido Materno:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txmaterno" class="form-control" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txnombre">Nombre(s):</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                    <div class="col-lg-6 text-right">
                                        <input type="checkbox" id="cbss" style="width: 20px; height: 20px;" /><label for="cbss" style="margin-left: 10px">Es Pensionado</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txrfc">RFC:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txrfc" class="form-control" maxlength="13" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcurp">CURP:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcurp" class="form-control" maxlength="18" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txss">No. SS:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txss" class="form-control" maxlength="11" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txfnac">Fecha Nacimiento:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfnac" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txedad">Edad:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txedad" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dllugar">Lugar de nacimiento:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <!--<input type="text" id="txlugar" class="form-control" />-->
                                        <select id="dllugar" class="form-control">
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txnacion">Nacionalidad:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txnacion" class="form-control" />
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
                                    <div class="col-lg-1">
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
                                    <div class="col-lg-1">
                                        <label for="txtalla">Talla uniforme:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txtalla" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txtallac">Talla calzado:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txtallac" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2">
                                        <label for="txcorreo">correo electrónico:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcorreo" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="txfuente">Fuente de reclutamiento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txfuente" class="form-control" />
                                    </div>
                                </div>
                                <h4>DATOS DE SUELDO</h4>
                                <hr />
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
                                        <input type="text" id="txclabe" class="form-control" />
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
                                        <input type="checkbox" id="cbinfonavit" />
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
                                        <label for="dltipo1">Tipo de credito:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo1" class="form-control">
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
                                <h4>DIRECCIÓN</h4>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcalle">Calle:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcalle" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txnoext">No. ext:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txnoext" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txnoint">No. int:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txnoint" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcolonia">Colonia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcolonia" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txcp">Código postal:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcp" class="form-control" maxlength="5"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmunicipio">Municipio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txmunicipio" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestado">Estado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestado" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtel1">Telefono:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtel1" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txtel2">Tel. Emergencia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtel2" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcontacto">Contacto emergencia:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txcontacto" class="form-control" />
                                    </div>
                                </div>
                                <h4>DIRECCIÓN FISCAL</h4>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcallef">Calle y número:</label>
                                    </div>
                                    <div class="col-lg-6">
                                        <input type="text" id="txcallef" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcoloniaf">Colonia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcoloniaf" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txcpf">Código postal:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcpf" class="form-control" maxlength="5"  />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmunicipiof">Municipio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txmunicipiof" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestadof">Estado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestadof" class="form-control"></select>
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btdocumento" class="puntero"><a><i class="fa fa-save"></i>Subir documentos</a></li>
                                    <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                    <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                                </ol>
                                <!--<div class="box-footer">
                                    <input type="button" class="btn btn-primary" value="Domicilio" id="btdomicilio" />
                                    <input type="button" class="btn btn-primary" value="Datos de sueldo" id="btsueldo" />
                                    <input type="button" class="btn btn-primary" value="Perfil" id="btperfil" />
                                </div>-->
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvcarga">
                        <div class="row">
                            <div class="col-lg-3">
                                <label for="dlbanco">Tipo de archivo:</label>
                            </div>
                            <div class="col-lg-6">
                                <select id="dltipodocto" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label for="txarchivo">Cargar Archivo:</label>
                            </div>
                            <div class="col-lg-6">
                                <input type="file" class="form-control" id="txarchivo" />
                            </div>
                            <div class="col-lg-3">
                                <input type="button" class="btn btn-info" onclick="xmlUpFile()" value="Agregar" id="btacuse" />
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="col-lg-3">
                                <label for="dlbanco">Archivos Cargados:</label>
                            </div>
                            <div id="dvarchivos" class="tbheader col-lg-6" style="height: 200px; overflow-y: scroll;">
                                <table class=" table table-condensed h6" id="tblistaa">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-active"></th>
                                            <th class="bg-light-blue-active">Tipo</th>
                                            <th class="bg-light-blue-active">Documento</th>
                                            <th class="bg-light-blue-active"></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="a.id_empleado">No. Empleado</option>
                                        <option value="a.paterno">Apellidos Paterno</option>
                                        <option value="a.materno">Apellidos Materno</option>
                                        <option value="a.nombre">Nombre</option>
                                        <option value="a.rfc">RFC</option>
                                        <option value="a.curp">CURP</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo2" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            </ol>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Tipo</span></th>
                                            <th class="bg-navy"><span>Estatus</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Empresa</span></th>
                                            <th class="bg-navy"><span>RFC</span></th>
                                            <th class="bg-navy"><span>CURP</span></th>
                                            <th class="bg-navy"><span>Cliente</span></th>
                                            <th class="bg-navy"><span>Punto de atención</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                </ol>
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
