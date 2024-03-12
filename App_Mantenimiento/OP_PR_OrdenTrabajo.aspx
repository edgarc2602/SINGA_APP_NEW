
<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OP_PR_OrdenTrabajo.aspx.vb" Inherits="OP_PR_OrdenTrabajo" %>

<%@ OutputCache Location="None" VaryByParam="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ORDEN DE TRABAJO</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
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
        .deshabilita {
            pointer-events: none;
            opacity: 0.4; /* Cambia la opacidad para dar una apariencia de deshabilitado */
        }
        #btCrearOC:hover {
            background-color: #f39c12;
            color: white; /* Cambia el color del texto */
            border: 2px solid #e08e0b;
           }

        /* Estilo para filas pares */
        tr:nth-child(even) {background-color: #f2f2f2;}
        /* Estilo para filas impares */
        tr:nth-child(odd) {background-color: #ffffff;}

    </style>

    <script type="text/javascript" src="//code.jquery.com/jquery-1.11.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script type="text/javascript">

        var dialog, dialog1, dialog2;
        var inicial = '<option value=0>Seleccione...</option>';

        $(function () {

            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');

            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            if (getPar('folio') != '') {
                $('#idorden').val(getPar('folio'));
            } else {
                $('#idorden').val(0);
                $('#dlservicio').val(2);
            }

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
            dialog2 = $('#modalmaterial').dialog({
                autoOpen: false,
                height: 400,
                width: 600,
                modal: true,
                buttons: {
                },
                close: function () {
                }
            });
            dialog1 = $('#modalalmacen').dialog({
                autoOpen: false,
                height: 400,
                width: 600,
                modal: true,
                buttons: {
                },
                close: function () {
                }
            });
            dialog = $('#btbuscaempl').dialog({
                autoOpen: false,
                height: 400,
                width: 600,
                modal: true,
                buttons: {
                },
                close: function () {
                }
            });

            $('#edif').hide();
            $('#txfolio').prop("disabled", true);
            $('#txfecha').prop("disabled", true);
            $('#pronombre').prop("disabled", true);
            $('#txinmnom').prop("disabled", true);
            $('#txingeniero').prop("disabled", true);
            $('#txdireccion').prop("disabled", true);
            $('#txplaza').prop("disabled", true);
            $('#txalmacen').prop("disabled", true);
            $('#txalmnom').prop("disabled", true);
            $('#txcosto').prop("disabled", true);
            $('#txdescmat').prop("disabled", true);
            $('#txtotalemp').prop('disabled', true);
            $('#txcveemp').prop('disabled', true);
            $('#txnomemp').prop('disabled', true);
            $('#txctoemp').prop('disabled', true);

            
            oculta();
            $('#bttrabajosejec').on('click', function () {
                oculta();
                $('#dvtrabajosejec').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btmateriales').on('click', function () {
                oculta();
                //$('#dvmaterialesmenu').toggle('slide', { direction: 'down' }, 700);
                $('#idmat').val(0);
                $('#dvmaterialesmenu').show();
                $('#tbmateriales').show();
                $('#dvmateriales').show();
                $('#tbmaterial thead tr:eq(1)').hide();
                $('#tbmaterial thead tr:eq(2)').hide();
            });
            $('#btpersonal').on('click', function () {
                oculta();
                $('#dvpersonal').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btfotos').on('click', function () {
                oculta();
                $('#dvfotos').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btevidencia').on('click', function () {
                oculta();

                obtieneEvidencias();

                $('#dvevidencia').toggle('slide', { direction: 'down' }, 700);

                if ($('#dlservicio').val() == 2) {
                    $('#dvCargaChk').show();
                }

            });

            $('input[name=optTecnico]').change(function () { cargatecnico();});


            $('#btsuministradocliente').on('click', function () {
                oculta();
                $('#idmat').val(0);
                $('#dvmaterialesmenu').show();
                $('#tbmateriales').show();
                $('#dvmateriales').show();
                $('#tbmaterial thead tr:eq(1)').hide();
                $('#tbmaterial thead tr:eq(2)').show();
            });

            $('#btsuministradobatia').on('click', function () {
                $('#idmat').val(1);
                oculta();
                $('#dvmaterialesmenu').show();
                $('#tbmateriales').show();
                $('#dvmaterialesbatia').show();
                $('#tbmaterial thead tr:eq(1)').show();
                $('#tbmaterial thead tr:eq(2)').hide();
                $('#txalmacen').prop("disabled", false);
                $('#btalmacen').prop("disabled", false);
            });

            $('#btAutosuministrado').on('click', function () {
                oculta();
                $('#idmat').val(0);
                $('#dvmaterialesmenu').show();
                $('#tbmateriales').show();
                $('#dvmateriales').show();
                //$('#tbmaterial thead tr:eq(1)').hide();
                //$('#tbmaterial thead tr:eq(2)').show();
            });

            $('#txbusca3').keypress(function (event) {
                if (event.which === 13) buscam();
            });

            $('#btbuscam').click(function () {buscam();});

            $('#txbusca2').keypress(function (event) {if (event.which === 13) btbusalm();});

            $('#btbusalm').click(function () { btbusalm() });

            
            $('#txbusca').keypress(function (event) {if (event.which === 13) buscap();});
            $('#btbuscap').click(function () {buscap();});

            var fecfac = new Date();
            var yyyy = fecfac.getFullYear().toString();
            var mm = (fecfac.getMonth() + 1).toString();
            var dd = fecfac.getDate().toString();
            if (dd < 10) {
                dd = "0" + dd;
            }
            if (mm < 10) {
                mm = "0" + mm;
            }
            $('#txfecha').val(dd + '/' + mm + '/' + yyyy);
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecejec').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvtrabajos').hide();
            $('#dlpiso').append(inicial);   //INICIALIZAR VALORES PARA LOS SELECT OCULTOS
            $('#dlequipo').append(inicial);
            $('#dlstatus').append(inicial);
            $('#dlsucursal').append(inicial);
            $('#dlcliente').append(inicial);
            $('#idpiso').val(0);
            $('#idstatus').val(0);
            $('#txrepcte').val(0);
            $('#idcliente').val(0)

            cargaservicios();
            cargaunidad();

            if ($('#idorden').val() == 0) {
                cargacliente();
                cargatecnico();
                cargaestatus();
            }
            else cargaregistro();


            $('#dlpiso').change(function () {
                cargaequipo($('#dlpiso').val());
            });
            $('#txidpro').change(function () {
                limpiasuc();
                PageMethods.proyectodes($('#txidpro').val(), $('#idplaza').val(), function (opcion) {
                    if (opcion != '') {
                        var opt = eval('(' + opcion + ')');
                        $('#pronombre').val(opt.desc);
                    } else {
                        alert('El numero de proyecto que capturo no existe, verifique');
                        $('#pronombre').val('');
                        $('#txidpro').val('');
                    }
                });
            });
            $('#BotonImprimir').click(function () {
                if ($('#txfolio').text() == '0') {
                    alert('El numero de la OT es 0.');
                } else {
                    var dir = '../RptForAll.aspx?v_nomRpt=OT.rpt&v_formula={OrdenTrabajo.Id_Plaza} = ' + $('#idplaza').val() + ' and {OrdenTrabajo.Id_Orden}=' + $('#txfolio').text() + ' and {OrdenTrabajo.Id_Empresa} = ' + $('#idempresa').val();
                    window.open(dir, '', 'width=850,height=600,left=80,top=20,resizable=yes,scrollbars=yes');
                }
            });
            $('#txinmueble').change(function () {
                if (validainm()) {
                    var prm = { inm: $('#txinmueble').val(), pro: $('#txidpro').val(), pla: $('#idplaza').val(), tipo: $('#idlinea').val() };
                    PageMethods.inmuebledes(JSON.stringify(prm), function (opcion) {
                        if (opcion != '') {
                            var opt = eval('(' + opcion + ')');
                            $('#idinmueble').val(opt.id);
                            $('#txinmnom').val(opt.nombre);
                            $('#txingeniero').val(opt.empleado);
                            $('#empleado').val(opt.idemp);
                            $('#txdireccion').val(opt.direccion);
                            $('#txplaza').val(opt.plaza);
                            $('#tipoinm').val(opt.tipoinm);
                            $('#idpiso').val(0);
                            cargapisos();
                            cargaequipo(0);
                        } else {
                            alert('El numero de sucursal que capturo no existe, verifique');
                            limpiasuc();
                        }
                    }, iferror);
                } else { limpiasuc(); }
            });
            $('#btalmacen').on('click', function () {
                $("#modalalmacen").dialog('option', 'title', 'Buscar Almacén');
                $('#tbbusca2 tbody tr').remove();
                $('#txbusca2').val('');
                dialog1.dialog('open');
            });
            $('#btmaterial').on('click', function () {
                $("#modalmaterial").dialog('option', 'title', 'Buscar Material');
                $('#tbbusca3 tbody tr').remove();
                $('#txbusca3').val('');
                dialog2.dialog('open');
            });
            $('#btempleado').on('click', function () {
                $("#btbuscaempl").dialog('option', 'title', 'Buscar Empleado');
                $('#tbbusca1 tbody tr').remove();
                $('#txbusca').val('');
                dialog.dialog('open');
            });
            $('#txclavemat').change(function () {
                if ($('#txclavemat').val().trim().toUpperCase() == 'SERVICIO') {
                    $('#txclavemat').val($('#txclavemat').val().trim().toUpperCase());
                    $('#txdescmat').prop("disabled", false);
                    $('#txdescmat').focus();
                    $('#txdescmat').val('SERVICIO SUBCONTRATADO');
                    $('#txctomat').val(0);
                } else {
                    $('#txdescmat').prop("disabled", true);
                    PageMethods.materialdes($('#txclavemat').val(), $('#idalmacen').val(), function (opcion) {
                        if (opcion != '') {
                            var opt = eval('(' + opcion + ')');
                            if (opt.exist > 0) {
                                $('#txclavemat').val(opt.id);
                                $('#txdescmat').val(opt.desc);
                                $('#txctomat').val(opt.prom);
                                $('#txcantdis').val(opt.exist);
                            } else {
                                alert('El Material que ha capturado no tiene existencias suficientes en el Almacén, verifique');
                                limpiapieza();
                            }
                        } else {
                            alert('La Clave que ha capturado no tiene registro de Inventario en el Almacén, verifique');
                            limpiapieza();
                        };
                    })
                }
            });
            $('#txcantmat').change(function () {
                if ($('#txcantmat').val() != '' && $('#txctomat').val() != '') {
                    var costo = parseFloat($('#txctomat').val()) * parseFloat($('#txcantmat').val());

                    $('#txcancob').val($('#txcantmat').val());
                    $('#txcosto').val(costo);

                }
                else {
                    $('#txcancob').val('');
                    $('#txcosto').val('');
                }
            });

            $('#txcancob').change(function () {
                if ($('#txcantmat').val() != '' && $('#txctomat').val() != '' && $('#txcancob').val() != '') {

                    if (parseFloat($('#txcantmat').val()) < parseFloat($('#txcancob').val())) {
                        alert("La cantidad a cobrar no puede ser mayor a la cantidad de material solicitado.");
                        $('#txcancob').val('');
                        $('#txcosto').val('');

                    }
                    else {
                        var costo = parseFloat($('#txctomat').val()) * parseFloat($('#txcancob').val());


                        $('#txcosto').val(costo);
                    }

                }
                else {
                    $('#txcosto').val('');
                }
            });


            $('#txhoraemp').change(function () {
                calculatotalmo();
            });
            $('#btagrega').on('click', function () {
                if (validamaterial()) {
                    var linea = '<tr><td colspan="2">' + $('#txclavemat').val() + '</td><td>' + $('#txdescmat').val() + '</td><td>' + $('#txcantmat').val() + '</td><td>' + $('#txunidad').val() + '</td><td>';
                    linea += $('#txctomat').val() + '</td><td>' + $('#txcancob').val() + '</td><td>' + $('#txcosto').val() + '</td>';
                    //linea += '<td>' + ($('#txcancob').val()) * ($('#txctomat').val()) + '</td>';
                    linea += '<td><td><input type="button" value="Quitar" class="btn btn-danger tbborrar"/></td></a></td></tr>';
                    $('#tbmatutil tbody').append(linea);

                    xmlgrabamat = '<ListaMaterial><material id="0"  Clave="' + $('#txclavemat').val() + '" Descripcion="' + $('#txdescmat').val() + '" ';
                    xmlgrabamat += ' Cantidad = "' + $('#txcantmat').val() + '" cancobro = "' + $('#txcancob').val() + '" ';
                    xmlgrabamat += 'precobro = "' + $('#txctomat').val() + '" total = "' + ($('#txcancob').val()) * ($('#txctomat').val()) + '" ';
                    xmlgrabamat += ' usuario="' + $('#idusuario').val() + '"  idorden="' + $('#idorden').val() + '" idalmacen="' + $('#idalmacen').val() + '" unidad="' + $('#id_Unidad').val() + '"  /></ListaMaterial> ';
                    //alert(xmlgrabamat);
                    xmlgrabasalida = '<Movimiento> <salida documento="8" almacen1="0" factura="0"';
                    xmlgrabasalida += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                    xmlgrabasalida += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                    xmlgrabasalida += '<pieza clave="' + $('#txclavemat').val() + '" cantidad="' + $('#txcancob').val() + '"';
                    xmlgrabasalida += ' precio="' + $('#txctomat').val() + '"/>';
                    xmlgrabasalida += '</Movimiento>';
                    //alert(xmlgrabasalida);
                    PageMethods.guardamat(xmlgrabamat, function (res) {
                        //alert('guardado');                                
                        PageMethods.guardasalida(xmlgrabasalida, function (res) {
                            closeWaitingDialog();
                            //alert('Registro completo');
                        }, iferror);
                    }, iferror);

                    $('#tbmatutil').delegate("tr .tbborrar", "click", function () {
                        xmlgrabamat = '<ListaMaterial><material id="1" idorden="' + $('#idorden').val() + '" Clave="' + $('#txclavemat').val() + '" Descripcion="' + $(this).closest('tr').find('td').eq(1).text() + '"  /></ListaMaterial>';
                        var xmlgraba = '<Movimiento> <salida documento="8" almacen1="0" factura= "0"';
                        xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                        xmlgraba += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                        xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find('td').eq(2).text()) + '"';
                        xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find('td').eq(3).text()) + '"/>';
                        //xmlgraba += ' reqlinea="' + $(this).closest('tr').find('td').eq(8).text() + '"/>'                       
                        xmlgraba += '</Movimiento>';
                        var xmlgrabaentrada = '<Movimiento> <salida documento="8" almacen1="0" factura="0"';
                        xmlgrabaentrada += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                        xmlgrabaentrada += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                        xmlgrabaentrada += '<pieza clave="' + $('#txclavemat').val() + '" cantidad="' + $('#txcancob').val() + '"';
                        xmlgrabaentrada += ' precio="' + $('#txctomat').val() + '"/>';
                        xmlgrabaentrada += '</Movimiento>';
                        //alert(xmlgraba);
                        //alert(xmlgrabaentrada);
                        PageMethods.guardamat(xmlgrabamat, function (res) {
                            PageMethods.guardaentrada(xmlgrabaentrada, function (res) {
                                closeWaitingDialog();
                                //alert('Registro completo');
                            }, iferror);
                            //alert('elimina');
                        }, iferror);
                        $(this).parent().eq(0).parent().eq(0).remove();
                    });
                    limpiapieza();
                }
            });

            $('#txfecejec').change(function () {
               // Acción a realizar cuando el valor del campo de texto cambia
                if ($(this).val().trim() !== '') {
                    $('#idstatus').val(2);
                    $('#dlstatus').val(2);
                  //  alert("Hola asigna estatus 2");
                }
                else if ($(this).val().trim() === '') {
                    $('#idstatus').val(1);
                    $('#dlstatus').val(1);
                  //  alert("Hola asigna estatus 1");
                }

            });

            $('#btagregacliente').on('click', function () {
                
                if (validamaterialcl()) {
                    
                    var linea = '<tr><td colspan="2"></td><td>' + $('#txdescmaterial').val() + '</td> <td>' + $('#txcantidad').val() + '</td><td>' + $('select[name="unidad"] option:selected').text()  + '</td>';
                    linea += '<td></td><td></td><td></td><td></td>';
                    linea += '<td><input type="button" value="Quitar" class="btn btn-danger tbborrar"/></td> ';
                    linea += '</tr > ';
                    //alert(linea);
                    $('#tbmatutil tbody').append(linea);
                    xmlgrabamat = '<ListaMaterial><material id="0"  Clave="" Descripcion="' + $('#txdescmaterial').val() + '" Cantidad = "' + $('#txcantidad').val() + '" ';
                    xmlgrabamat += '  Costo = "" cancobro = "" precobro = "" total = "" usuario="' + $('#idusuario').val() + '"  unidad="' + $('#dlunidad').val() + '"';
                    xmlgrabamat += ' idorden = "' + $('#idorden').val() + '" idalmacen = "" /> </ListaMaterial> ';
                    //alert(xmlgrabamat);
                    PageMethods.guardamat(xmlgrabamat, function (res) {
                        //alert('guardado');

                    }, iferror);

                    $('#tbmatutil').delegate("tr .tbborrar", "click", function () {
                        xmlgrabamat = '<ListaMaterial><material id="1" idorden="' + $('#idorden').val() + '" Clave="' + $('#txclavemat').val() + '" Descripcion="' + $(this).closest('tr').find('td').eq(1).text() + '"  /></ListaMaterial>';
                        //alert(xmlgrabaemp);
                        PageMethods.guardamat(xmlgrabamat, function (res) {
                            //alert('elimina');
                        }, iferror);
                        $(this).parent().eq(0).parent().eq(0).remove();
                    });
                    limpiapieza();
                }
            });
            
            $('#btagregaemp').on('click', function () {
                if (validaempleado()) {
                    var linea = '<tr><td colspan="2">' + $('#txcveemp').val() + '</td><td>' + $('#txnomemp').val() + '</td><td>' + $('#txctoemp').val() + '</td><td>';
                    linea += $('#txhoraemp').val() + '</td><td>' + $('#txtotalemp').val() + '</td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tbempleados tbody').append(linea);

                    xmlgrabaemp = '<ListaPersonal><empleado id="0" idorden="' + $('#idorden').val() + '" idempl="' + $('#txcveemp').val() + '" costo="' + $('#txctoemp').val() + '" ';
                    xmlgrabaemp += 'horas = "' + $('#txhoraemp').val() + '" total = "' + $('#txtotalemp').val() + '" usuario="' + $('#idusuario').val() + '" /></ListaPersonal>';
                    //alert(xmlgrabaemp);
                    PageMethods.guardaemp(xmlgrabaemp, function (res) {
                        //alert('guardado');
                    }, iferror);

                    $('#tbempleados').delegate("tr .btquita", "click", function () {
                        xmlgrabaemp = '<ListaPersonal><empleado id="1" idorden="' + $('#idorden').val() + '" idempl="' + $(this).parent().parent().find('td').eq(0).text() + '" /></ListaPersonal>';
                        //alert(xmlgrabaemp);
                        PageMethods.guardaemp(xmlgrabaemp, function (res) {
                            //alert('elimina');
                        }, iferror);
                        $(this).parent().eq(0).parent().eq(0).remove();
                    });
                    limpiaempleado();
                }

            });
            $('#btnuevo').click(function () { location.href = " OP_PR_OrdenTrabajo.aspx "; })

            $('#btcierra').on('click', function () {
                if ($('#txfolio').val() != '') {
                    var prm = { ord: $('#idorden').val() };
                    PageMethods.cierraorden(JSON.stringify(prm), function (res) {
                        var nw = eval('(' + res + ')');
                        if (nw.cmd) {
                            alert('La Orden de trabajo se ha cerrado correctamente');
                            $('#txestatus').val('Cerrado');
                        } else {
                            alert('La Orden de trabajo se ha cerrado correctamente');
                        }
                    }, iferror);
                }
            })

            $('#BotonEditar').on('click', function () {
                if ($('#txfolio').text() != '') {
                    var prm = { ord: $('#idorden').val(), pla: $('#idplaza').val(), emp: $('#idempresa').val(), usu: $('#usuario').val() };
                    PageMethods.cierraorden(JSON.stringify(prm), function (res) {
                        var nw = eval('(' + res + ')');
                        if (nw.cmd) {
                            alert('La Orden de trabajo se ha cerrado correctamente');
                            $('#txestatus').val('Cerrado');
                        } else {
                            alert('La Orden de trabajo se ha cerrado correctamente');
                        }
                    }, iferror);
                }
            });

            $('#btguarda').on('click', function () {
                if (validar()) {
                    waitingDialog({});
                    var farr = $('#txfecha').val().split('/');
                    var falta = farr[2] + farr[1] + farr[0];
                    
                    var xmlgraba = '<orden id= "' + $('#txfolio').val() + '"  idservicio="' + $('#dltipo').val() + '" ';
                    xmlgraba += ' proyecto="' + $('#dlcliente').val() + '" inmueble="' + ($('#dlsucursal').val() === null ? 0 : $('#dlsucursal').val())+ '"  ';
                    xmlgraba += ' supervisor="' + $('#dltecnico').val() + ' " fecalta="' + falta + '" noreporte="' + $('#txrepcte').val() + '" ';
                    xmlgraba += ' trabajos="' + $('#txtrabajos').val() + '" usuario="' + $('#idusuario').val() + '"  status="' + $('#dlstatus').val() + '" ';
                    xmlgraba += ' edificio="' + $('#txedificio').val() + '" piso="' + $('#txpiso').val() + '" area="' + $('#txarea').val() + '" subarea="' + $('#txsubarea').val() + '" ';
                    xmlgraba += ' tipo="' + $('#dlservicio').val() + '" especialidad="' + $('#dlespecialidad').val() + '"';
                    if ($('#txfecejec').val() == "") {
                        //alert(isNaN($('#txfecejec').val()) == true);
                        xmlgraba += ' fejecucion="" trabejec="' + $('#txtrabejec').val() + '"';
                    } else {
                        var arr = $('#txfecejec').val().split('/');
                        var fejec = arr[2] + arr[1] + arr[0];
                        xmlgraba += ' fejecucion="' + fejec + '" trabejec="' + $('#txtrabejec').val() + '"';
                    }
                    xmlgraba += ' >';
                    $('#tblista tr input[type=checkbox]:checked').each(function () {
                        xmlgraba += ' <alcance idalc="' + $(this).closest('tr').find('td').eq(0).text() + '" />';
                    });
                    xmlgraba += '</orden> ';
                    alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, '', '', function (res) {
                        closeWaitingDialog();
                        var rsl = eval('(' + res + ')');
                        $('#txfolio').val(res);
                        $('#idorden').val(res);
                        alert('La Orden de Trabajo ' + res + ' se ha guardado correctamente.');
                        $('#dvtrabajos').show();
                        $('#trabajosejec').show();
                        $('#menurecursos').show();
                        $('#tbmaterial').show();
                        $('#personal').show();
                    }, iferror);
                }  
            });

            //$('#btCrearOC').on('click', function () {
            //    let AuxfolioOrdenCompra = 0;

            //    if ($('#txfolio').val() > 0) {
            //        PageMethods.Trae_id_Orden_Compra($('#txfolio').val(), function (res) {
            //            AuxfolioOrdenCompra = res;
            //        }, iferror);

            //        window.open('../App_Compras/Com_Pro_ordencompra.aspx?folio=' + AuxfolioOrdenCompra + '&id_orden_trabajo=' + $('#txfolio').val(), '_blank');
            //    }

            //    else alert('Debe de seleccionar una orden de trabajo'); 
            //});

            $('#BotonSalir').on('click', function () {
                self.close();
            });
        });

        function SoloLectura() {
            $('#txedificio').prop("disabled", true);
            $('#dltecnico').prop("disabled", true);
            $('#txtrabajos').prop("disabled", true);
            $('#txpiso').prop("disabled", true);
            $('#txarea').prop("disabled", true);
            $('#txsubarea').prop("disabled", true);
            $('#dlespecialidad').prop("disabled", true);
            $('#txtrabejec').prop("disabled", true);
            $('#txfecejec').prop("disabled", true);
            $('#btsuministradocliente').prop("disabled", true);
            $('#btsuministradobatia').prop("disabled", true);


            $('#btAutosuministrado').prop("disabled", true);

            $('#tbmaterial').prop('disabled', true);
            $('#btempleado').prop('disabled', true);
            $('#btagregaemp').prop('disabled', true);
            $('#tbempleados').prop('disabled', true);

            $('#xmlUpFile').prop("disabled", true);
            $('#txfileload').prop("disabled", true);
            $('#UploadReporte').prop('disabled', true);
            $('#txreporteload').prop('disabled', true);
            $('#txreporteload').prop('disabled', true);

            $('#btcierra').addClass('deshabilita');
            $('#btguarda').addClass('deshabilita');

            $('#btcierra').off('click');
            $('#btguarda').off('click');
            
            if ($('#txfecejec').val() != '') $('#dvtrabajosejec').show();

            $('.tbborrar').prop("disabled", true);
            $('.btquita').prop("disabled", true);
            
        }


        function buscam() {
            if ($('#idalmacen').val() != '') {
                //if ($('#txbusca3').val() != '') { si no hay criterio de busqueda que traiga los primeros 50 registros
                    $('#tbbusca3 tbody tr').remove();
                    PageMethods.material($('#txbusca3').val(), $('#idalmacen').val(), function (res) {
                        var ren = $.parseHTML(res);
                        $('#tbbusca3').append(ren);

                        if ($('#tbbusca3 tbody tr').length > 0) {
                            $('#tbbusca3 tbody tr').click(function () {
                                $('#txclavemat').val($(this).children().eq(0).text());
                                $('#txdescmat').val($(this).children().eq(1).text());
                                $('#txunidad').val($(this).children().eq(2).text());
                                $('#txctomat').val($(this).children().eq(3).text());
                                $('#txcantdis').val($(this).children().eq(4).text());

                                $('#id_Unidad').val($(this).children().eq(5).attr('id_Unidad'));

                                dialog2.dialog('close');
                            });
                        }
                        else alert('No se encontraron registros con ese criterio de busqueda.');

                    }, iferror);
                //} else alert('Debes de colocar un criterio de busqueda.');
            } else alert('Debes elegir un almacen');
        }

        function btbusalm() {

            PageMethods.getalmacen($('#txbusca2').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca2 tbody').remove();
                $('#tbbusca2').append(ren);
                if ($('#tbbusca2 tbody tr').length > 0) {
                    $('#tbbusca2 tbody tr').click(function () {
                        $('#idalmacen').val($(this).children().eq(0).text());
                        $('#txalmacen').val($(this).children().eq(0).text());
                        $('#txalmnom').val($(this).children().eq(1).text());
                        dialog1.dialog('close');
                    });
                } else alert('No se encontraron registros con ese criterio de busqueda.');

            }, iferror);

        }

        function buscap() {
            if ($('#txbusca').val() != '') {
                PageMethods.empleados($('#txbusca').val(), function (res) {
                    var ren = $.parseHTML(res);
                    $('#tbbusca1 tbody tr').remove();
                    $('#tbbusca1').append(ren);
                    if ($('#tbbusca1 tbody tr').length > 0) {
                        $('#tbbusca1 tbody tr').click(function () {
                            $('#txcveemp').val($(this).children().eq(0).text());
                            $('#txnomemp').val($(this).children().eq(1).text());
                            $('#txctoemp').val($(this).children().eq(2).text());
                            dialog.dialog('close');
                        });
                    } else alert('No se encontraron empleados con ese criterio de busqueda.');
                }, iferror);
            } else {
                alert('Debes de colocar un criterio de busqueda.');
            }
        }


        function UploadCheck(res) {
            if ($('#txcheckload').val() != '') {
                waitingDialog({});
                var fileup = $('#txcheckload').get(0);
                var files = fileup.files;
                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                    ndt.append("Id", $("#idorden").val());
                }
                ndt.append('nmr', res);
                $.ajax({
                    url: 'GH_UpCheck.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function (res) {                        
                        PageMethods.guardaevidencia(2, $('#idorden').val(), $('#idusuario').val(), res, function (res2) {
                            closeWaitingDialog();
                            $('#txcheckload').val("");
                            obtieneEvidencias();
                            alert('Se cargó el checklist correctamente');
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            } else {
                alert('Debe elegir un archivo a cargar');
            }
        }
        function UploadReporte(res) {
            if ($('#txreporteload').val() != '') {
                waitingDialog({});
                var fileup = $('#txreporteload').get(0);
                var files = fileup.files;
                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                    ndt.append("Id", $("#idorden").val());
                }
                ndt.append('nmr', res);
                $.ajax({
                    url: 'GH_UpReporte.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function (res) {                       
                        PageMethods.guardaevidencia(1, $('#idorden').val(), $('#idusuario').val(), res, function (res2) {
                            closeWaitingDialog();
                            $('#txreporteload').val("");
                            obtieneEvidencias();
                            alert('Se cargó el reporte correctamente');
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            } else {
                alert('Debe elegir un archivo a cargar');
            }
        }

        function obtieneEvidencias() {
            PageMethods.obtieneevidencias($('#idorden').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                
                $('#tbevidencias tbody').remove();
                $('#tbevidencias').append(ren);
                $('#tbevidencias tbody tr').delegate(".evidencia", "click", function () {

                    var nombre = $(this).attr("archivo");

                    PageMethods.DownloadFile($('#idorden').val(), nombre, function (r) {
                        console.log(nombre);

                        //Convert Base64 string to Byte Array.
                        var bytes = Base64ToBytes(r);

                        //Convert Byte Array to BLOB.
                        var blob = new Blob([bytes], { type: "application/octetstream" });

                        //Check the Browser type and download the File.
                        var isIE = false || !!document.documentMode;
                        if (isIE) {
                            window.navigator.msSaveBlob(blob, nombre);
                        } else {
                            var url = window.URL || window.webkitURL;
                            link = url.createObjectURL(blob);
                            var a = $("<a />");
                            a.attr("download", nombre);
                            a.attr("href", link);
                            $("body").append(a);
                            a[0].click();
                            $("body").remove(a);
                        }


                    }, iferror);
                    
                });            
                    
                
            }, iferror);
        }

        function Base64ToBytes(base64) {
            var s = window.atob(base64);
            var bytes = new Uint8Array(s.length);
            for (var i = 0; i < s.length; i++) {
                bytes[i] = s.charCodeAt(i);
            }
            return bytes;
        };

        function cargaservicios() {
            PageMethods.tipos(function (opcion) {
                //alert(opcion);
                var opt = eval('(' + opcion + ')');
                
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                
                $('#dltipo').append(inicial);
                $('#dltipo').append(lista);
                if ($('#hdtipo').val() != 0) {
                    $('#dltipo').val($('#hdtipo').val());
                }
                $('#dltipo').change( function () {
                    cargaespecialidad($('#dltipo').val());
                });
            }, iferror);
        }
        function cargaserviciosmant() {
            PageMethods.tiposmant(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dltipo').append(inicial);
                $('#dltipo').append(lista);
                if ($('#hdtipo').val() != 0) {
                    $('#dltipo').val($('#hdtipo').val());
                }
                /*$('#dltipo').on('click', function () {
                    cargalinea();
                });*/
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

        function cargainmuebled(inm) {
            PageMethods.inmuebledes(inm, function (opcion) {
                var opt = eval('(' + opcion + ')');
                $('#txdireccion').val(opt.direccion);
                /*$('#txingeniero').val(opt.empleado);
                $('#txdireccion').val(opt.direccion);
                $('#txplaza').val(opt.plaza);
                $('#tipoinm').val(opt.tipoinm);
                $('#idpiso').val(0);
                cargapisos();
                cargaequipo(0);*/
            });
        }
        function cargaestatus() {
            PageMethods.estatus(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlstatus').empty();
                $('#dlstatus').append(inicial);
                $('#dlstatus').append(lista);
                if ($('#idstatus').val() != 0) {
                    $('#dlstatus').val($('#idstatus').val());
                } else {
                    $('#idstatus').val(1);
                    $('#dlstatus').val(1);
                }

                if ($('#idstatus').val() == 3 || $('#idstatus').val() == 4) { //estatus cerrado o cancelado; evitar cambios en la OT
                    SoloLectura();
                }

            }, iferror);
        }
        function cargatecnico() {
            PageMethods.tecnico($('input[name="optTecnico"]:checked').val(),function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dltecnico').empty();
                $('#dltecnico').append(inicial);
                $('#dltecnico').append(lista);

                if ($('#idtecnico').val() != 0) $('#dltecnico').val($('#idtecnico').val());

                if ($('#id_Proveedor').val() != 0) $('#dltecnico').val($('#id_Proveedor').val());

            }, iferror);
        }
        function cargaunidad() {
            PageMethods.unidad(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlunidad').empty();
                $('#dlunidad').append(inicial);
                $('#dlunidad').append(lista);
                $('#dluni').empty();
                $('#dluni').append(inicial);
                $('#dluni').append(lista);
            }, iferror);
        }
      
        function limpiasuc() {
            $('#txinmueble').val('');
            $('#txinmnom').val('');
            $('#txingeniero').val('');
            $('#empleado').val('');
            $('#txdireccion').val('');
            $('#txplaza').val('');
        };
        function cargaregistro() {
            try {

                PageMethods.ordendet($('#idorden').val(), function (opcion) {
                    var opt = eval('(' + opcion + ')');

                    $('#idstatus').val(opt.id_status);
                    cargaestatus();

                    $('#txfolio').val(opt.id_orden);
                    $('#txfecha').val(opt.fregistro);
                    $('#txrepcte').val(opt.id_repcliente);

                    $('#hdtipo').val(opt.id_servicio);
                    $('#hdespecialidad').val(opt.especialidad);
                    cargaserviciosmant();

                    cargaespecialidad(opt.id_servicio);

                    $('#dlstatus').val(opt.id_status);
                    $('#idcliente').val(opt.id_cliente);
                    $('#dlservicio').val(opt.tipo);
                    $('#txtrabajos').val(opt.trabajos);
                    $('#idtecnico').val(opt.id_tecnico);
                    $('#id_Proveedor').val(opt.id_Proveedor);

                    if (($('#idtecnico').val() == "0" || $('#idtecnico').val() == "") && ($('#id_Proveedor').val() != "0" || $('#id_Proveedor').val() != ""))
                        $('#optTecnicoP').prop('checked', true);
                    else
                        $('#optTecnicoI').prop('checked', true);

                    cargatecnico();
                    $('#idinmueble').val(opt.id_inmueble)
                    //cargainmuebled(opt.id_inmueble);
                    $('#txedificio').val(opt.edificio);
                    $('#txpiso').val(opt.piso);
                    $('#txarea').val(opt.area);
                    $('#txsubarea').val(opt.subarea);
                    cargacliente();
                    cargainmueble($('#idcliente').val());
                    $('#txfecejec').val(opt.fejecucion);
                    $('#txtrabejec').val(opt.trabajosejecutados);

                    PageMethods.ordenalm(opt.id_orden, function (opcion) {
                        var opt = eval('(' + opcion + ')');
                        $('#idalmacen').val(opt.id);
                        $('#txalmacen').val(opt.id);
                        $('#txalmnom').val(opt.desc);
                    }, iferror);
                    PageMethods.ordendetmat($('#idorden').val(), function (opcion) {
                        var opt = eval('(' + opcion + ')');
                        var lista = '<tr>';
                        //alert(opcion);
                        for (var list = 0; list < opt.length; list++) {
                            lista += '<tr><td colspan="2">' + opt[list].clave + '</td><td>' + opt[list].desc + '</td><td>' + opt[list].cant + '</td><td>';
                            lista += opt[list].uni + '</td><td> ' + opt[list].costo + '</td><td>' + opt[list].cantcob + '</td><td>' + opt[list].precio + '</td>';
                            lista += '<td>' + opt[list].total + '</td><td><input type="button" value="Quitar" class="btn btn-danger tbborrar"/></td></tr>';
                        }
                        lista += '</tr>';
                        //alert(lista);
                        $('#tbmatutil tbody tr').remove();
                        $('#tbmatutil tbody').append(lista);
                        if ($('#idstatus').val() == 3 || $('#idstatus').val() == 4) $('.tbborrar').prop("disabled", true); //estatus cerrado o cancelado; evitar cambios en la OT
                        cambioalmacen();
                        $('#tbmatutil').delegate("tr .tbborrar", "click", function () {
                            xmlgrabamat = '<ListaMaterial><material id="1" idorden="' + $('#idorden').val() + '" Clave="' + $(this).closest('tr').find('td').eq(0).text() + '" Descripcion="' + $(this).closest('tr').find('td').eq(1).text() + '"  /></ListaMaterial>';
                            var xmlgraba = '<Movimiento> <salida documento="8" almacen1="0" factura= "0"';
                            xmlgraba += ' cliente="' + $('#idcliente').val() + '" almacen="' + $('#idalmacen').val() + '"';
                            xmlgraba += ' orden="' + $('#idorden').val() + '" usuario="' + $('#idusuario').val() + '"/>'
                            xmlgraba += '<pieza clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find('td').eq(2).text()) + '"';
                            xmlgraba += ' precio="' + parseFloat($(this).closest('tr').find('td').eq(4).text()) + '"/>';
                            //xmlgraba += ' reqlinea="' + $(this).closest('tr').find('td').eq(8).text() + '"/>'

                            xmlgraba += '</Movimiento>';

                            console.log(xmlgrabamat);
                            console.log(xmlgraba);

                            PageMethods.guardamat(xmlgrabamat, function (res) {
                                //alert('elimina');
                                PageMethods.guardaentrada(xmlgraba, function (res) {
                                    closeWaitingDialog();
                                    //alert('Registro completo');                                    
                                }, iferror);
                            }, iferror);
                            $(this).parent().eq(0).parent().eq(0).remove();
                        });
                      
                    }, iferror);

                    cargafotos($('#idorden').val());
                    try {
                        PageMethods.ordendetper($('#idorden').val(), function (opcion) {
                            var opt = eval('(' + opcion + ')');
                            var listap = '<tr>';
                            //alert(opcion);
                            for (var list = 0; list < opt.length; list++) {
                                listap += '<tr><td colspan="2">' + opt[list].id + '</td><td>' + opt[list].empleado + '</td><td>' + opt[list].chora + '</td><td>';
                                listap += opt[list].horas + '</td><td>' + opt[list].total + '</td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                            }
                            listap += '</tr>';
                            $('#tbempleados tbody tr').remove();
                            $('#tbempleados tbody').append(listap);

                            if ($('#idstatus').val() == 3 || $('#idstatus').val() == 4) $('.btquita').prop("disabled", true);  //estatus cerrado o cancelado; evitar cambios en la OT
                                
                            $('#tbempleados').delegate("tr .btquita", "click", function () {
                                xmlgrabaemp = '<ListaPersonal><empleado id="1" idorden="' + $('#idorden').val() + '" idempl="' + $(this).parent().parent().find('td').eq(0).text() + '" /></ListaPersonal>';
                                //alert(xmlgrabaemp);
                                PageMethods.guardaemp(xmlgrabaemp, function (res) {
                                    //alert('elimina');
                                }, iferror);
                                $(this).parent().eq(0).parent().eq(0).remove();
                            });
                        }, iferror);
                    }
                    catch (err) {
                        alert(err.message)
                    }
                }, iferror);

                $('#dvtrabajos').show();
                $('#trabajosejec').show();
                $('#menurecursos').show();
                $('#tbmaterial').show();
                $('#personal').show();
                bloqueo();

                
            }
            catch (err) {
                alert(err.message)
            }
        }

        function bloqueo() {
            $('#txfolio').prop("disabled", true);
            $('#txfecha').prop("disabled", true);
            $('#txrepcte').prop("disabled", true);
            $('#hdtipo').prop("disabled", true);
            $('#dlcliente').prop("disabled", true);
            $('#dltipo').prop("disabled", true);
            $('#txalmacen').prop("disabled", true);
            $('#txunidad').prop("disabled", true);
            $('#btalmacen').prop("disabled", true);
            $('#dlstatus').prop("disabled", true);
            $('#dlsucursal').prop("disabled", true);
            $('#txtrabajos').prop("disabled", false);
            $('#dltecnico').prop("disabled", false);
        }
        function cargapisos() {
            $('#dlpiso option').remove();
            if ($('#tipoinm').val() == 2) {
                $('#edif').show();
                PageMethods.pisos($('#idinmueble').val(), function (opcion) {
                    var opt = eval('(' + opcion + ')');
                    var lista = '';
                    $('#dlpiso').append($('<option>', { value: 0, text: 'Seleccione...' }));
                    for (var list = 0; list < opt.length; list++) {
                        $('#dlpiso').append($('<option>', { value: opt[list].id, text: opt[list].desc }));
                    }
                    if ($('#idpiso').val() != 0) {
                        $('#dlpiso').val($('#idpiso').val());
                        cargaequipo($('#idpiso').val());
                    }
                }, iferror);
            } else {
                $('#edif').hide();
            }
        }
        function cambioalmacen() {
            if ($('#tbmatutil tbody').children('tr').length < 1) {
                $('#txalmacen').prop("disabled", false);
                $('#btalmacen').prop("disabled", false);
            } else {
                $('#txalmacen').prop("disabled", true);
                $('#btalmacen').prop("disabled", true);
            }
        }
        function cargaequipo(idpiso) {
            $('#dlequipo option').remove();
            if (idpiso != 0) {
                PageMethods.equipos(idpiso, function (opcion) {
                    var opt = eval('(' + opcion + ')');
                    var lista = '';
                    $('#dlequipo').append($('<option>', { value: 0, text: 'Seleccione...' }));
                    for (var list = 0; list < opt.length; list++) {
                        $('#dlequipo').append($('<option>', { value: opt[list].id, text: opt[list].desc }));
                    }
                    if ($('#idequipo').val() != 0) {
                        $('#dlequipo').val($('#idequipo').val());
                    }
                }, iferror);
            }
        }
        function calculatotalmo() {
            if (isNaN($('#txctoemp').val()) == false && isNaN($('#txhoraemp').val()) == false) {
                $('#txtotalemp').val(($('#txctoemp').val() * $('#txhoraemp').val()).toFixed(2));
            } else {
                $('#txtotalemp').val('');
            }
        }
        function cargaespecialidad(tipo) {
            PageMethods.especialidad(tipo, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dlespecialidad').empty();
                $('#dlespecialidad').append(inicial);
                $('#dlespecialidad').append(lista);
                if ($('#hdespecialidad').val() != 0) {
                    $('#dlespecialidad').val($('#hdespecialidad').val());
                }
                //$('#dlespecialidad').change(function () { //ya no hay alcance FMH
                //    cargaalcance(0, $('#dlespecialidad').val());
                //})
            });
        }
        function cargaalcance(ot, esp) {
            //PageMethods.alcance(ot, esp, function (res) {
            //    var ren = $.parseHTML(res);
            //    $('#tblista tbody').remove();
            //    $('#tblista').append(ren);
            //}, iferror);
        }
        function oculta() {
            $('#dvtrabajosejec').hide();
            $('#dvmateriales').hide();
            $('#dvpersonal').hide();
            $('#dvfotos').hide();
            $('#dvevidencia').hide();
            $('#dvmaterialesmenu').hide();
            $('#dvmaterialesbatia').hide();
            $('#tbmateriales').hide();

        }
        function valida() {
            if ($('#txfileload').val() == '') {
                alert('Debe seleccionar una foto antes de continuar');
                return false;
            }
            return true;
        }
        function validar() {
            /*
            if($('#txfolio').text() == 0){
                alert('No puede generar ordenes de trabajo nuevas, debe elegir para editar, verifique');
                return false;
            }*/
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir al Tipo de Orden de Trabajo');
                return false;
            }
            if ($('#dlproyecto').val() == 0) {
                alert('Debe elegir un Proyecto');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir un cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0 || $('#dlsucursal').val() === null) {
                alert('Debe elegir un punto de atención');
                return false;
            }
            if ($('#txtrabajos').val() == '') {
                alert('Debe capturar los trabajos a Ejecutar');
                return false;
            }
            if ($('#txfecejec').val() != '' && $('#txtrabejec').val() == '') {
                alert('Cuando captura fecha de ejecución también debe capturar descripción de los trabajos ejecutados');
                return false;
            }
            if ($('#txtrabejec').val() != '' && $('#txfecejec').val() == '') {
                alert('Cuando captura la descripción de los trabajos ejecutados también debe capturar fecha de ejecución  ');
                return false;
            }
            if ($('#dltecnico').val() == 0) {
                alert('Debe asignar un tecnico');
                return false;
            }
            return true;
        }
        function validainm() {
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir primero al Tipo de Orden de Trabajo');
                return false;
            };
            if ($('#txidpro').val() == 0) {
                alert('Debe elegir primero un Proyecto');
                return false;
            };
            return true;
        }
        function validamaterial() {
            if ($('#txclavemat').val() == '') {
                alert('Debe elegir un Material');
                return false;
            }
            if (isNaN($('#txcantmat').val()) == true || $('#txcantmat').val() == '') {
                alert('Debe capturar la Cantidad del Material');
                return false;
            }
            if (isNaN($('#txcancob').val()) == true || $('#txcancob').val() == '') {
                alert('Debe capturar la Cantidad a cobrar');
                return false;
            }
            if (isNaN($('#txctomat').val()) == true || $('#txctomat').val() == '') {
                alert('Debe capturar el precio de venta del Material');
                return false;
            }

            if ( parseFloat($('#txcantmat').val(), 2) === 0) {
                alert('La cantidad de material debe ser mayor a 0');
                return false;
            }

            if (parseFloat($('#txcantdis').val(), 2) < parseFloat($('#txcantmat').val(), 2)) {
                alert('La Cantidad capturada supera el disponible de inventario, no puede continuar');
                return false;
            }
            for (var x = 0; x < $('#tbmatutil tbody tr').length; x++) {
                if ($('#tbmatutil tbody tr').eq(x).find('td').eq(0).text() == $('#txclavemat').val()) {
                    alert('El Material que esta seleccionado ya esta registrado no puede duplicar');
                    return false;
                }
            }
            return true;
        };
        function validamaterialcl() {
            if (isNaN($('#txcantidad').val()) == true || $('#txcantidad').val() == '') {
                alert('Debe capturar la Cantidad del Material');
                return false;
            }
            if ($('#txdescmaterial').val() == '') {
                alert('Debe capturar la Descripcion del Material');
                return false;
            }
            return true;
        }
        function validaempleado() {
            if ($('#txcveemp').val() == '') {
                alert('Debe elegir un Empleado');
                return false;
            }
            if (isNaN($('#txhoraemp').val()) == true || $('#txhoraemp').val() == '') {
                alert('Debe capturar las horas de trabajo del Empleado');
                return false;
            }
            for (var x = 0; x < $('#tbempleados tbody tr').length; x++) {
                if ($('#tbempleados tbody tr').eq(x).find('td').eq(0).text() == $('#txcveemp').val()) {
                    alert('El Empleado que esta seleccionado ya esta registrado no puede duplicar');
                    return false;
                }
            }
            return true;
        }
        function xmlUpFile(res) {
            if (valida()) {
                
                var fileup = $('#txfileload').get(0);
                var files = fileup.files;

                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                ndt.append('nmr', res);
                $.ajax({
                    url: '../GH_UpOT.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function (res) {
                        PageMethods.actualiza($('#txfolio').val(), res, function (res) {
                            cargafotos($('#txfolio').val());
                            closeWaitingDialog();
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
                
            }
        }
        function cargafotos(orden) {
            PageMethods.cargafoto(orden, function (opcion) {
                var ren = $.parseHTML(opcion);
                $('#tblistafoto tbody').remove();
                $('#tblistafoto').append(ren);

            }, iferror);
        }
        function limpiapieza() {
            $('#txcantdis').val('');
            $('#id_Unidad').val('');
            $('#txclavemat').val('');
            $('#txdescmat').val('');
            $('#txcantmat').val('');
            $('#txctomat').val('');
            $('#txcancob').val('');
            $('#txcosto').val('');
            $('#txdescmaterial').val('');
            $('#txcantidad').val('');
            $('#txunidad').val('');
        }
        function limpiaempleado() {
            $('#txcveemp').val('');
            $('#txnomemp').val('');
            $('#txctoemp').val('');
            $('#txhoraemp').val('');
            $('#txtotalemp').val('');
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
        function getPar(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Creando registros');
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

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="idplaza" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="empleado" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idlinea" runat="server" />
        <asp:HiddenField ID="idalmacen" runat="server" />
        <asp:HiddenField ID="idmat" runat="server" />
        <asp:HiddenField ID="opc" runat="server" />
        <asp:HiddenField ID="idpiso" runat="server" Value="0" />
        <asp:HiddenField ID="idequipo" runat="server" Value="0" />
        <asp:HiddenField ID="tipoinm" runat="server" Value="0" />
        <asp:HiddenField ID="hdtipo" runat="server" Value="0" />
        <asp:HiddenField ID="hdespecialidad" runat="server" Value="0" />
        <asp:HiddenField ID="idstatus" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idtecnico" runat="server" Value="0" />
        <asp:HiddenField ID="id_Proveedor" runat="server" Value="0" />
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
                    <h1>Orden de Trabajo<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimiento</a></li>
                        <li class="active">Orden de Trabajo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div id="dvdetalle">                            
                            <div class="row">                                
                                <div class="col-lg-9 text-right">
                                    <label>Folio</label>
                                </div>
                                <div class="col-lg-2">
                                    <input id="txfolio" class="form-control" value="0" />
                                </div>
                            </div>
                            <div class="row">                                
                                <div class="col-lg-2 text-right">
                                    <label for="txrepcte">Reporte Cliente</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txrepcte" class="form-control" />
                                </div>                                
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha de Alta</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="status">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlstatus" class="form-control"></select>
                                    <!--<input type="text" id="txestatus" class="form-control"/>-->
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente</label>
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
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txedificio">Edificio</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txedificio" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txpiso">Piso</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txpiso" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txarea">Area</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txarea" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txsubarea">SubArea</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txsubarea" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlservicio">Tipo de Manto</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlservicio" class="form-control" disabled="disabled">
                                        <option value ="1">Correctivo</option>
                                        <option value ="2">Preventivo</option>
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo de Orden</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlespecialidad">Especialidad</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlespecialidad" class="form-control"></select>
                                </div>

                            </div>
                            
                            <div class="row" style="display:none">
                                <div class="col-lg-6 text-right">
                                    <label for="tblista">Alcances</label>
                                </div>
                                <div class="col-md-4 tbheader" style="height:200px; overflow-y:scroll;">
                                    <table class="table table-condensed" id="tblista">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>id</span></th>
                                                <th class="bg-navy"><span>Concepto</span></th>
                                                <th class="bg-navy"><span>Aplica</span></th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txingeniero">Técnico asignado</label>
                                </div>
                                <div class="col-lg-2" >
                                     <table style="width:100%"><tr style="background-color: inherit;"><td style="width:50%;text-align:center;padding:5px">
                                            <label class="form-check-label" style="width:90px">
                                                <input type="radio" class="form-check-input" name="optTecnico" checked="checked" value="I" id="optTecnicoI"/> Interno
                                            </label>
                                        </td><td  style="width:50%;text-align:center;padding:5px">
                                            <label class="form-check-label" style="width:90px">
                                                <input type="radio" class="form-check-input" name="optTecnico" value="P" id="optTecnicoP"/> Proveedor
                                            </label>
                                        </td></tr></table>
                                </div>
                                 <div class="col-lg-2 text-right">
                                    <label for="txpiso">Nombre del Técnico</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dltecnico" class="form-control"></select>
                                </div>
                                
                            </div>
                         
                            <div class="row"> 
                                <div class="col-lg-2 text-right">
                                    <label for="txtrabajos">Trabajos a Ejecutar</label>
                                </div>
                                <div class="col-lg-4">
                                    <textarea id="txtrabajos" class="form-control" rows="2"></textarea>
                                </div>
                            </div>
                        </div>
                        <hr />

                        <div class="row">
                            <div id="dvtrabajos" class="col-md-2">
                                <ul class="list-group">
                                    <!--bg-olive-->
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="bttrabajosejec">Trabajos Ejecutados</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btmateriales">Materiales Utilizados</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btpersonal">Mano de Obra</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btfotos">Fotos</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btevidencia">Evidencia</li>

                                </ul>
                            </div>

                            <div id="dvtrabajosejec" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Trabajos Ejecutados</h1>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2 text-right" style="width: 100px;">
                                        <label for="txfecejec">Fecha de Ejecución</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txfecejec" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txtrabejec">Descripción</label>
                                    </div>
                                    <div class="col-lg-5">
                                        <textarea id="txtrabejec" rows="3" class="form-control"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div id="dvmaterialesbatia" class="tab-content col-md-10">                                
                                <div class="row">
                                    <div class="row">
                                        <div class="col-md-1" style="text-align:right">
                                            <label class="float-right" for="txalmacen">Almacén</label>
                                        </div>
                                        <div class="col-md-1">
                                            <input type="text" id="txalmacen" class="form-control" />
                                        </div>
                                        <div class="col-md-1" style="text-align:center">
                                            <input type="button" class="btn btn-primary" value="Buscar" id="btalmacen" />
                                        </div>
                                        <div class="col-md-2">
                                            <input type="text" id="txalmnom" class="form-control" />
                                        </div>
                                        <div class="col-md-1" style="text-align:center"></div>
                                       <%-- <div class="col-md">
                                            <input type="button" class="btn puntero" value="ir a Orden Compra" id="btCrearOC" />
                                        </div>--%>

                                    </div>
                                </div>
                            </div>
                            <div id="dvmaterialesmenu" class="tab-content col-md-10">
                                <div class="row">
                                    <input type="button" class="btn btn-primary puntero" value="Suministrados por el Cliente" id="btsuministradocliente" />
                                    <input type="button" class="btn btn-primary puntero" value="Suministrados por Almacen" id="btsuministradobatia" />
                                    <%--<input type="button" class="btn btn-primary puntero" value="Suministrados por Compra directa" id="btAutosuministrado" />--%>
                                </div>

                            </div>

                            <div id="dvmateriales" class="tab-content col-md-10">  
                                <div class="row"></div>
                                <div class="row">
                                    
                                </div>
                                <%--<div id="tbmat" class="container">                            
                                <div>                                
                                    <div id="tbmatc" class="tbheader">
                                        <table id="tbmatuti" class="table table-condensed" >
                                            <thead>
                                                <tr>
                                                    <th class="bg-light-blue-gradient"><span>Cantidad</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Descripción</span></th>
                                                    <th class="bg-light-blue-gradient"></th>
                                                </tr>
                                                <tr>                                                                                        
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                        </div>--%>
                            </div>

                            

                            <div id="tbmateriales" class="tab-content col-md-10">
                                <br />
                                <div>
                                    <div id="tbmaterial" class="tbheader">
                                        <table id="tbmatutil" class="table table-condensed">
                                            <thead>
                                                <tr>
                                                    <th class="bg-light-blue-gradient"><span>Clave</span></th>
                                                    <td class="bg-light-blue-gradient"></td>
                                                    <th class="bg-light-blue-gradient"><span>Descripción</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Cantidad</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Unidad</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Costo Unitario</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Cant. a cobrar</span></th>
                                                    <th class="bg-light-blue-gradient"><span>Costo</span></th>
                                                    <th class="bg-light-blue-gradient"></th>
                                                </tr>
                                                <tr>
                                                    <asp:HiddenField ID="txcantdis" runat="server" />
                                                    <asp:HiddenField ID="id_Unidad" runat="server" />
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txclavemat" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="button" class="btn btn-primary" value="Buscar" id="btmaterial" /></td>
                                                    <td class="col-xs-2">
                                                        <input type="text" id="txdescmat" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txcantmat" class="form-control" /></td>
                                                    <td class="col-xs-1"><input type="text" id="txunidad" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txctomat" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txcancob" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txcosto" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" /></td>
                                                </tr>
                                                <tr>
                                                    
                                                    <td class="col-xs-1"></td>
                                                    <td class="col-xs-1"></td>
                                                    <td class="col-xs-2">
                                                        <input type="text" id="txdescmaterial" class="form-control" /></td>
                                                    <td class="col-xs-1">
                                                        <input type="text" id="txcantidad" class="form-control" /></td>
                                                    <td class="col-xs-1"><select name="unidad" id="dlunidad" class="form-control"></select></td>
                                                    <td class="col-xs-1"></td>
                                                    <td class="col-xs-1"></td>
                                                    <td class="col-xs-1"></td>
                                                    <td class="col-xs-1">
                                                        <input type="button" class="btn btn-success" value="Agregar" id="btagregacliente" /></td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div id="dvpersonal" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Mano de Obra</h1>
                                    </div>
                                </div>
                                <hr />
                                <div class="tbheader">
                                    <table id="tbempleados" class="table table-condensed">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-gradient"><span>No. Empleado</span></th>
                                                <th class="bg-light-blue-gradient"></th>
                                                <th class="bg-light-blue-gradient"><span>Empleado</span></th>
                                                <th class="bg-light-blue-gradient"><span>Costo x hora</span></th>
                                                <th class="bg-light-blue-gradient"><span>Horas</span></th>
                                                <th class="bg-light-blue-gradient"><span>Total</span></th>
                                                <th class="bg-light-blue-gradient"></th>

                                            </tr>
                                            <tr>
                                                <td class="col-xs-1">
                                                    <input type="text" id="txcveemp" class="form-control" /></td>
                                                <td class="col-xs-1">
                                                    <input type="button" class="btn btn-primary" value="Buscar" id="btempleado" /></td>
                                                <td class="col-xs-2">
                                                    <input type="text" id="txnomemp" class="form-control" /></td>
                                                <td class="col-xs-1">
                                                    <input type="text" id="txctoemp" class="form-control" /></td>
                                                <td class="col-xs-1">
                                                    <input type="text" id="txhoraemp" class="form-control" /></td>
                                                <td class="col-xs-1">
                                                    <input type="text" id="txtotalemp" class="form-control" /></td>
                                                <td class="col-xs-1">
                                                    <input type="button" class="btn btn-success" value="Agregar" id="btagregaemp" /></td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div id="dvfotos" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Fotos</h1>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-2">
                                        <label for="txfileload">Cargar Fotos</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="file" id="txfileload" class="form-control" />
                                    </div>
                                    <div class="col-lg-2">
                                        <input id="xmlUpFile" type="button" class="form-control btn btn-primary" value="Subir" onclick="xmlUpFile()" />
                                    </div>
                                </div>
                                <div class="row" id="dvtabla">                                    
                                        <div class="col-md-18 tbheader">
                                            <table class="table table-condensed h6" id="tblistafoto">
                                                <thead>
                                                    <tr>                                                        
                                                        <th class="bg-navy"><span>Fotos</span></th>
                                                        <th class="bg-navy"></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div>
                                </div>
                                
                            </div>

                             <div id="dvevidencia" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Evidencia</h1>
                                    </div>
                                </div>
                                <hr />
                                <div class="row d-none" id="dvCargaChk" hidden>
                                    <div class="col-lg-2">
                                        <label for="txfileload">Cargar CheckList</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="file" id="txcheckload" class="form-control" />
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="button" class="form-control btn btn-primary" value="Subir" onclick="UploadCheck()" />
                                    </div>
                                </div>
                                 <br />
                                 <div class="row">
                                    <div class="col-lg-2">
                                        <label for="txfileload">Cargar Reporte</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="file" id="txreporteload" class="form-control" />
                                    </div>
                                    <div class="col-lg-2">
                                        <input id="UploadReporte" type="button" class="form-control btn btn-primary" value="Subir" onclick="UploadReporte()" />
                                    </div>
                                </div>
                                <div class="row" id="dvListaEvidencia">                                    
                                        <div class="col-md-18 tbheader">
                                            <table class="table table-condensed h6" id="tbevidencias">
                                                <thead>
                                                    <tr>                                                        
                                                        <th class="bg-navy"><span>Evidencia</span></th>
                                                         <th class="bg-navy"><span>Fecha carga</span></th>
                                                        <th class="bg-navy"></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div>
                                </div>
                                
                            </div>

                        </div>




                        <div class="row">
                            <div id="btbuscaempl">
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
                                                    <th class="bg-navy"><span>Costo x Hora</span></th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div id="modalalmacen">
                                <div class="row">
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txbusca">Buscar</label>
                                        </div>
                                        <div class="col-lg-5">
                                            <input type="text" class=" form-control" id="txbusca2" placeholder="Ingresa texto de busqueda" />
                                        </div>
                                        <div class="col-lg-1">
                                            <input type="button" class="btn btn-primary" value="Buscar" id="btbusalm" />
                                        </div>
                                    </div>
                                    <div class="tbheader">
                                        <table class="table table-condensed" id="tbbusca2">
                                            <thead>
                                                <tr>
                                                    <th class="bg-navy"><span>No. Almacen</span></th>
                                                    <th class="bg-navy"><span>Nombre</span></th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div id="modalmaterial" style="overflow-x: hidden">
                                <div class="row">
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txbusca">Buscar</label>
                                        </div>
                                        <div class="col-lg-5">
                                            <input type="text" class=" form-control" id="txbusca3" placeholder="Ingresa texto de busqueda" />
                                        </div>
                                        <div class="col-lg-1">
                                            <input type="button" class="btn btn-primary" value="Buscar" id="btbuscam" />
                                        </div>
                                    </div>
                                    <div class="tbheader" >
                                        <table class="table table-condensed" id="tbbusca3" >
                                            <thead>
                                                <tr>
                                                    <th class="bg-navy" style="width:150px"><span>Clave</span></th>
                                                    <th class="bg-navy"><span>Producto</span></th>
                                                    <th class="bg-navy"><span>Unidad</span></th>
                                                    <th class="bg-navy"><span>Precio</span></th>
                                                    <th class="bg-navy"><span>Existencia</span></th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btcierra" class="puntero"><a><i class="fa fa-eraser"></i>Cerrar Orden</a></li>
                        <%--<li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>--%>
                    </ol>
                </div>
            </div>
            <div class="content-wrapper">
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
