
<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Man_Pro_CorrectivoMayor.aspx.vb" Inherits="App_Mantenimiento_Man_Pro_Correctivomayor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>CORRECTIVO MAYOR</title>
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
        /* Customize the label (the container) */
        .container {
          display: block;
          position: relative;
          padding-left: 35px;
          margin-bottom: 12px;
          cursor: pointer;
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
    <script type="text/javascript" src="//code.jquery.com/jquery-1.11.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script type="text/javascript">
        var dialog, dialog1, dialog2;
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha1').datepicker({ dateFormat: 'dd/mm/yy' });
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
            dialog5 = $('#divmodal3').dialog({
                autoOpen: false,
                height: 450,
                width: 900,
                modal: true,
                close: function () {
                }
            });
            dialog4 = $('#divmodal2').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog3 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                close: function () {
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
            $('#dvempleado').hide();
            $('#dvproveedor').hide();
            cargacliente();
            cargatrabajo(); 
            cargatipo();
            cargaproveedor();
            cargaempresa();
            cargaconcepto();
            oculta();
            cargaalmacen(1);
            cargaalmacen(2);
            cargatecnico();

            if ($('#idorden').val() != 0) {
                cargacm($('#idorden').val());
            }
            $('#btbusca').click(function () {
                $("#divmodal2").dialog('option', 'title', 'Elegir Producto');
                dialog4.dialog('open');
            })
            $('#btbuscap').click(function () {
                if ($('#dlalmacen').val() != 0)
                    if (($('input:radio[name=dltipos]:checked').val())) {
                        PageMethods.productol(($('input:radio[name=dltipos]:checked').val()), $('#txbusca').val(), function (res) {
                            var ren1 = $.parseHTML(res);
                            $('#tbbusca tbody').remove();
                            $('#tbbusca').append(ren1);
                            $('#tbbusca tbody tr').click(function () {
                                $('#txclave').val($(this).children().eq(0).text());
                                $('#txdesc2').val($(this).children().eq(1).text());
                                $('#txunidad').val($(this).children().eq(2).text());
                                $('#txprecio').val($(this).children().eq(3).text());
                                dialog4.dialog('close');
                            });
                        }, iferror)
                    } else {
                        alert('Debe elegir un tipo');
                    }
            })
            $('#btbuscap1').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Buscar empleado');
                dialog3.dialog('open');
            });
            $('#txpresupuesto').change(function () {
                if (isNaN($('#txpresupuesto').val())) {
                    alert('Debe coloca un valor numerico')
                    $('#txpresupuesto').val(0)
                } else {
                    calculatopegasto();
                    topegastoppto();
                }
            });
            $('#txutilidad').change(function () {
                if (isNaN($('#txutilidad').val())) {
                    alert('Debe coloca un valor numerico')
                    $('#txpresupuesto').val(0)
                } else {
                    calculatopegasto();
                }
            });
            $('#txppto').change(function () {
                if (isNaN($('#txppto').val())) {
                    alert('Debe coloca un valor numerico')
                    $('#txpresupuesto').val(0)
                } else {
                    topegastoppto();
                }
            });
            $('#btfotos').on('click', function () {
                oculta();
                $('#dvfotos').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btsolicitudrecur').on('click', function () {
                if ($('#txstatus').val() != 'Autorizado') {
                    alert('El estatus actual no permite generar solicitud de recursos ');
                    return false;
                }
                if ($('#txutilizado').val() >= $('#txtopegasto').val()) {
                    alert('El tope de gasto fue superado');
                    return false;
                }
             else {
                    limpiasolicitud();
                    oculta();
                    $('#dvsolicitudrecur').toggle('slide', { direction: 'down' }, 700);

                }
            });
            $('#btmateriales').on('click', function () {
                if ($('#txstatus').val() != 'Autorizado') {
                    alert('El estatus actual no permite generar solicitud de recursos ');
                    return false;
                }
                if ($('#txutilizado').val() >= $('#txtopegasto').val()) {
                    alert('El tope de gasto fue superado');
                    return false;
                }
                oculta();
                $('#dvsolicitudmaterial').toggle('slide', { direction: 'down' }, 700);
            });

            $('#btsolicitudrecver').on('click', function () {
                cargasolicitudesreg();
                oculta();
                $('#dvsolicitudrecurocarga').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btsolicitudmver').on('click', function () {
                cargasolicitudmat();
                oculta();
                $('#dvsolicitudmatcarga').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btpersonal').on('click', function () {
                topegastoppto();
                if ($('#txstatus').val() != 'Autorizado') {
                    alert('El estatus actual no permite generar solicitud de recursos ');
                    return false;
                }
                oculta();
                $('#dvpersonal').toggle('slide', { direction: 'down' }, 700);
            });
            $('#btempleado').on('click', function () {
                $("#btbuscaempl").dialog('option', 'title', 'Buscar Empleado');
                $('#tbbusca1 tbody tr').remove();
                $('#txbusca').val('');
                dialog.dialog('open');
            });
            $('#btbuscap5').click(function () {

                if ($('#txbusca5').val() != '') {
                    PageMethods.empleados($('#txbusca5').val(), function (res) {
                        var ren = $.parseHTML(res);
                        $('#tbbusca1 tbody tr').remove();
                        $('#tbbusca1').append(ren);
                        $('#tbbusca1 tbody tr').click(function () {
                            $('#txcveemp').val($(this).children().eq(0).text());
                            $('#txnomemp').val($(this).children().eq(1).text());
                            $('#txctoemp').val($(this).children().eq(2).text());
                            dialog.dialog('close');
                        });
                    }, iferror);
                } else {
                    alert('Debes de colocar un criterio de busqueda.');
                }
            });
            $('#txhoraemp').change(function () {
                calculatotalmo();
            });
            $('#btbuscaemp').click(function () {
                cargaempleado();
            });
            $('#txnoemp').change(function () {
                PageMethods.empleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    if (datos.id == '') {
                        alert('El numero de empleado que ha capturado no es valido, verifique');
                        $('#txnoemp').val('');
                        $('#txnoemp').focus();
                    } else {
                        $('#txclave').val(datos.id);
                        $('#txnombre').val(datos.nombre);
                    }
                })
            });
            $('#btagrega1').click(function () {
                if (validaconcepto()) {
                    var linea = '<tr><td>' + $('#dlconcepto').val() + '</td><td>' + $('#dlconcepto option:selected').text() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#tximporte').val() + ' /></td>'
                    linea += '<td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistac tbody').append(linea);
                    $('#tblistac').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                        total();
                    });
                    $('#tblistac tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        total();
                    });
                    total()
                    limpiaconcepto();
                }
            });
            $('#btguardas1').click(function () {
                if (valida()) {
                    waitingDialog({});
                    alert('');
                    var fecha = $('#txfecha1').val().split('/');
                    var devolucion = fecha[2] + fecha[1] + fecha[0];
                    var xmlgraba = '<movimiento> <solicitud id="' + $('#txfolio2').val() + '" tecnico="' + $('#dltecnico').val() + '" id_servicio="1"';
                    xmlgraba += ' almacen="' + $('#dlalmacen').val() + '" almacen1="' + $('#dlalmacen1').val() + '" cliente="' + $('#dlcliente').val() + '" id_inmueble="' + $('#dlsucursal').val() + '" usuario="' + $('#idusuario').val() + '" observacion="' + $('#txobservacion').val() + '" id_clave_cm="' + $('#txfolio').val() + '"';
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
                    PageMethods.guardam(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txfolio2').val(res);
                        alert('Registro completado');

                    }, iferror);
                }
            });
            $('#btguarda').click(function () {
                if (validar()) {
                    waitingDialog({});
                    var farr = $('#txfecha').val().split('/');
                    var fregistro = farr[2] + farr[1] + farr[0];
                    var xmlgraba = '<orden id= "' + $('#txfolio').val() + '" descripcion = "' + $('#txdesc').val() + '"';
                    xmlgraba += ' fregistro="' + fregistro + '"  ppto="' + $('#txppto').val() + '"  presupuesto="' + $('#txpresupuesto').val() + '"';
                    xmlgraba += ' utilidad="' + $('#txutilidad').val() + '" tope ="' + $('#txtopegasto').val() + '"';
                    xmlgraba += ' trabajo="' + $('#dltrabajo').val() + '" status="1"';
                    xmlgraba += ' usuario="' + $('#idusuario').val() + '"';
                    xmlgraba += ' folioc="' + $('#txfoliocliente').val() + '"';
                    var cexistente = $("input[name='cliente1']:checked").val();
                    if (cexistente == 1) {
                        xmlgraba += ' inmueble="' + $('#dlsucursal').val() + '" proyecto="' + $('#dlcliente').val() + '" clienten="" inmueblen="" tipo="1"' + '>';
                    }
                    else {
                        xmlgraba += ' inmueble="0" proyecto="0" clienten="' + $('#txclienten').val() + '" inmueblen="' + $('#txsucursaln').val() + '" tipo="2"' + '>';
                    }
                    xmlgraba += ' </orden> ';
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        var rsl = eval('(' + res + ')');
                        $('#txfolio').val(res);
                        alert('El Correctivo ' + res + ' se ha guardado correctamente.');
                        $('#dvtrabajos').show();

                    }, iferror);
                }
            });
            $('#btguardas').click(function () {
                if (validasolicitud()) {
                    waitingDialog({});
                    var tipoop = 2;
                    var xmlgraba = '<movimiento> <solicitud id="' + $('#txfolio1').val() + '" empleado="' + $('#txnoemp').val() + '"';
                    xmlgraba += ' empresa="' + $('#dlempresa').val() + '" areasolicita="' + $('#txsolicita').val() + '"';
                    xmlgraba += ' proveedor="' + $('#dlproveedor').val() + '" areaautoriza="8" concepto="' + $('#txdesc').val() + '"';
                    xmlgraba += ' tipogasto="' + $('#dltipo').val() + '" formapago="' + $('#dlforma').val() + '" tipopago="1"' + '"jornalero="0"';
                    xmlgraba += ' subtot= "' + $('#txsubtotalg').val() + '" iva = "' + $('#txivag').val() + '" total = "' + $('#txtotalg').val() + '"';
                    xmlgraba += ' usuario ="' + $('#idusuario').val() + '" piva="' + $('#dliva').val() + '" cliente="' + $('#dlcliente').val() + '" cm="' + $('#txfolio').val() + '"/>';
                    $('#tblistac tbody tr').each(function () {
                        xmlgraba += '<partida concepto="' + $(this).closest('tr').find('td').eq(0).text() + '" importe="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"/>'
                    });
                    xmlgraba += '</movimiento>';
                    PageMethods.guardasolicitud(xmlgraba, tipoop, function (res) {
                        closeWaitingDialog();
                        $('#txfolio1').val(res);
                        alert('Registro completado');
                    }, iferror);
                }
                $('#txutilizado').val(parseFloat($('#txutilizado').val()) + parseFloat($('#txsubtotalg').val()))
            })
            $('#btnuevos').click(function () {
                limpiasolicitud();
            })
            $('#btnuevos1').click(function () {
                limpiasolicitud();
                limpiaproducto();
            })

            $('#txclave').change(function () {
                if ($('#dlalmacen').val() != 0) {
                    cargaproducto($('#txclave').val());
                } else {
                    alert('Primero debe elegir un almacén');
                    $('#txclave').val('');
                    $('#txclave').focus();
                }
            })
            if ($('#idsolm').val() != 0) {
                cargasolicitud();
            }
            $('#btagregaemp').on('click', function () {
                if (validaempleado())
                if (validatopeppto()){
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

            $('#btagrega').click(function () {
                if (validamat()) {
                    var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                    linea += '<input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistaj tbody').append(linea);
                    $('#tblistaj').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                        totalm();
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
                    totalm();
                    limpiaproducto();
                }
            })
            $('#txcantidad').change(function () {
                subtotalm();

            })

            $('#txfecha1').change(function () {
                $('#btherramientas tbody').remove(); {
                    $('#hdpagina').val(1);
                }
            })
            $('#btimprime1').click(function () {
                var idsol = $('#lbfolio').text();
                window.open('../RptForAll.aspx?v_nomRpt=solicitudmaterialesmantto.rpt&v_formula={tb_solicitudmaterialmantto.id_solicitud}= ' + idsol  + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');

            });


        });
        function validatopeppto() {
            if ($('#txtotalemp').val() >= $('#txpptotope').val()) {
                alert('El tope de gasto fue superado');
                return false;
            }
            return true;

        }
        function limpiatipo() {
            $('#txfecha1').val('');
            $('#dlamacen').val(0);
            $('#dlalmacen1').val(0);
            $('#dltecnico').val(0);
            $('#txclave').val('');
            $('#txdesc2').val('');
            $('#txunidad').val('');
            $('#txdisp').val('');
            $('#txprecio').val('');
            $('#txcantidad').val('');
            $('#txtotal').val('');
        }
        function calculatotalmo() {
            if (isNaN($('#txctoemp').val()) == false && isNaN($('#txhoraemp').val()) == false) {
                $('#txtotalemp').val(($('#txctoemp').val() * $('#txhoraemp').val()).toFixed(2));
            } else {
                $('#txtotalemp').val('');
            }
        }
        function limpiaempleado() {
            $('#txcveemp').val('');
            $('#txnomemp').val('');
            $('#txctoemp').val('');
            $('#txhoraemp').val('');
            $('#txtotalemp').val('');
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc2').val('');
            $('#txunidad').val('');
            $('#txdisp').val('');
            $('#txprecio').val('');
            $('#txcantidad').val('');
            $('#txtotal').val('');
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, $('#dlalmacen').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc2').val(datos.producto);
                    $('#txdisp').val(datos.disponible);
                    $('#txunidad').val(datos.unidad);
                    $('#txprecio').val(datos.precio);
                    $('#txcantidad').focus();
                } else {
                    alert('La clave de producto capturada no existe, verifique');
                    limpiaproducto();
                }
            }, iferror)
        }
        function subtotalm() {
            var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val());
            $('#txtotal').val(tot.toFixed(2));
        }
        function totalm() {
            var subtotalm = 0;
            $('#tblistaj tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(2)").val());
            });
            $('#txsubtotalm').val(subtotalm.toFixed(2));
        }
        function total() {
            var subtotal = 0;
            var iva = 0;
            var total = 0;
            $('#tblistac tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(0)").val());
            });
            iva = subtotal * parseFloat($('#dliva').val())
            total = subtotal + iva
            $('#txsubtotalg').val(subtotal.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
        }
        function validappto() {
            if ($('#txtotalemp').val() >= $('#txpptotope').val()) {
                alert('El tope de gasto fue superado');
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
        function validamat() {
            if ($('#txclave').val() == '') {
                alert('Debe elegir la clave del material');
                return false;
            }
            if ($('#txcantidad').val() == '') {
                alert('Debe capturar la cantidad de material');
                return false;
            }
            /*if (parseFloat($('#txcantidad').val()) > parseFloat($('#txdisp').val())) {
                alert('No puede solicitar mas de la cantidad disponible');
                return false;
            }*/
            for (var x = 0; x < $('#tblistaj tbody tr').length; x++) {
                if ($('#tblistaj tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                    alert('Este producto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            return true;
        }

        function cargasolicitud() {
            $('#txfolio2').val($('#idsolm').val());

            PageMethods.solicitud($('#idsolm').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#dlalmacen1').val(datos.almacen1);
                $('#dlalmacen').val(datos.almacen0);
                $('#txsolicita1').val(datos.solicita);
                $('#txestatus').val(datos.status);
                $('#txobservacion').val(datos.observacion);

                detallesol($('#idsolm').val(), $('#idalmacen').val(), $('#idalmacen1').val());
            }, iferror);
        }
        function detallesol(folio, almacen) {
            PageMethods.cargadetalle(folio, almacen, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    alert($(this).closest('tr').find('td').eq(4).text());
                    if (parseFloat($(this).closest('tr').find("input:eq(0)").val()) > parseFloat($(this).closest('tr').find('td').eq(4).text())) {
                        alert('No puede solicitar cantidad mayor a disponible');
                        $(this).closest('tr').find("input:eq(0)").val(0);
                        $(this).closest('tr').find("input:eq(0)").focus();
                    } else {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        totalm();
                    }
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    $(this).parent().eq(0).parent().eq(0).remove();
                    totalm();
                });
            }, iferror)
        }
        function cargaalmacen(tipo) {
            PageMethods.almacen(tipo, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                if (tipo == 1) {
                    $('#dlalmacen').append(inicial);
                    $('#dlalmacen').append(lista);
                }
                else {
                    $('#dlalmacen1').append(inicial);
                    $('#dlalmacen1').append(lista);
                }
            }, iferror);
        }

        function cargacm(idsol) {
            PageMethods.cargacorrectivo(idsol, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfolio').val(datos.id);
                $('#txfecha').val(datos.fregistro);
                $('#txstatus').val(datos.estatus);
                $('#txpresupuesto').val(datos.presupuesto);
                $('#txppto').val(datos.ppto);
                $('#txutilidad').val(datos.utilidad);
                $('#txtopegasto').val(datos.topegasto);
                if (datos.tipocliente == 1) {
                    $("input[name=cliente1][value='1']").prop("checked", true);
                    ShowHideDiv();
                    $('#idcliente').val(datos.cliente);
                    $('#idinmueble').val(datos.inmueble);
                    cargacliente();
                    cargainmueble(datos.cliente);
                } else {
                    $("input[name=cliente1][value='2']").prop("checked", true);
                    ShowHideDiv()
                    $('#txclienten').val(datos.clienten);
                    $('#txsucursaln').val(datos.inmueblen);
                }
                $('#idtrabajo').val(datos.servicio);
                cargatrabajo();
                $('#txdesc').val(datos.trabajos);
                $('#dvtrabajos').show();
                cargacorrectivogasto(datos.id);
            })
            bloqueo();
        }
        function cargacorrectivogasto(folio) {
            PageMethods.cargacorrectivogasto(folio, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txutilizado').val(datos.utilizado);
            })
        }
        function valida() {
            if ($('#txsolicita1').val() == '') {
                alert('Debe capturar persona que solicita');
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
            /*
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir el cliente al que se entrega el material');
                return false;
            }
            /*
            /*
            if ($('#dlalmacen').val() == 0) {
                alert('Debe elegir el almacén');
                return false;
            }*/
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            if ((parseFloat($('#txutilizado').val()) + parseFloat($('#txsubtotalm').val())) > parseFloat($('#txtopegasto').val())) {
                alert('Al ingresar esta solicitud esta superando el tope de gasto, no puede continuar');
                return false;

            }
            return true;
        }
        function validasolicitud() {
            if ($('#dlempresa').val() == 0) {
                alert('Debe elegir la empresa que paga la solicitud');
                return false;
            }
            if ($('#txsolicita').val() == 0) {
                alert('Debe colocar el nombre que solicita el recurso');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de solicitud');
                return false;
            }
            if ($('#dltipo').val() == 5 && $('#dlproveedor').val() == 0) {
                alert('Debe elegir un proveedor');
                return false;
            }
            if ($('#dltipo').val() != 5 && $('#txnoemp').val() == '') {
                alert('Debe elegir un empleado');
                return false;
            }
            if ($('#dlforma').val() == 0) {
                alert('Debe elegir la forma de pago');
                return false;
            }
            if ($('#txdesc').val() == 0) {
                alert('Debe colocar un concepto para el pago');
                return false;
            }
            if ($('#dltipo').val() != 5 && $('#tblistac tbody tr').length == 0) {
                alert('Debe agregar al menos un concepto de pago');
                return false;
            }
            if ((parseFloat($('#txutilizado').val()) + parseFloat($('#txsubtotalg').val())) > parseFloat($('#txtopegasto').val())) {
                alert('Al ingresar esta solicitud esta superando el tope de gasto, no puede continuar');
                return false;

            }

            return true;
        }

        function cargaconcepto() {
            PageMethods.concepto(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlconcepto').empty();
                $('#dlconcepto').append(inicial);
                $('#dlconcepto').append(lista);
                if ($('#idconcepto').val() != 0) {
                    $('#dlconcepto').val($('#idconcepto').val());
                }
            }, iferror);
        }
        function limpiaconcepto() {
            $('#dlconcepto').val(0);
            $('#tximporte').val(0);
        }
        function validaconcepto() {
            if ($('#dlconcepto').val() == 0) {
                alert('Debe elegir el concepto');
                return false;
            }
            if ($('#tximporte').val() == '') {
                alert('Debe colocar el importe');
                return false;
            }
            if (isNaN($('#tximporte').val())) {
                alert('Debe colocar un importe válido');
                return false;
            }
            for (var x = 0; x < $('#tblistac tbody tr').length; x++) {
                if ($('#tblistac tbody tr').eq(x).find('td').eq(0).text() == $('#dlconcepto').val()) {
                    alert('Este concepto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            if (($('#dltipo').val() == 4 || $('#dltipo').val() == 3) && $('#dlconcepto').val() != 8) {
                alert('Para pagos de incidencias o jornales solo puede agregar el concepto de Nomina');
                return false;
            }
            if (($('#dltipo').val() != 4 && $('#dltipo').val() != 3) && $('#dlconcepto').val() == 8) {
                alert('Solo puede agregar pago de Nómina, en solicitudes para incidencia de nómina o jornales');
                return false;
            }
            return true;
        }
        function cargaempleado() {
            PageMethods.empleadolista($('#dlbusca4').val(), $('#txbusca4').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllista1 tbody').remove();
                $('#tbllista1').append(ren);
                $('#tbllista1 tbody tr').on('click', function () {
                    $('#txnoemp').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txnombre').val($(this).closest('tr').find('td').eq(1).text());
                    $('#txempresa').val($(this).closest('tr').find('td').eq(2).text());
                    $('#idempresa').val($(this).closest('tr').find('td').eq(3).text());
                    dialog3.dialog('close');
                });
            });
        }
        function cargasolicitudesreg() {
            PageMethods.cargasolicitudrec($('#txfolio').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbsolreg tbody').remove();
                $('#tbsolreg').append(ren);
            });
        }
        function cargasolicitudmat() {
            PageMethods.cargasolicitudmat($('#txfolio').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbsolreg1 tbody').remove();
                $('#tbsolreg1').append(ren);
                $('#tbsolreg1 tbody tr').on('click', '.btver', function () {
                    $('#lbfolio').text($(this).closest('tr').find('td').eq(0).text());
                    $('#lbalmacenent').text($(this).closest('tr').find('td').eq(2).text());
                    $('#lbestatus').text($(this).closest('tr').find('td').eq(5).text());
                    PageMethods.listadod($(this).closest('tr').find('td').eq(0).text(), function (res) {
                        var ren1 = $.parseHTML(res);
                        $('#tbdetalle tbody').remove();
                        $('#tbdetalle').append(ren1);
                    }, iferror);
                    $("#divmodal3").dialog('option', 'title', 'Detalle de la solicitud');
                    dialog5.dialog('open');
                });
                    

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
                if ($('#idempresa').val() != 0) {
                    $('#dlempresa').val($('#idempresa').val());
                }
            }, iferror);
        }
        function cargaproveedor() {
            PageMethods.proveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').empty();
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
                if ($('#idproveedor').val() != 0) {
                    $('#dlproveedor').val($('#idproveedor').val());
                }
            }, iferror);
        }
        function cargatipo() {
            PageMethods.tipo1(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltipo').empty();
                $('#dltipo').append(inicial);
                $('#dltipo').append(lista); 
                if ($('#idtipo').val() != 0) {
                    $('#dltipo').val($('#idtipo').val());
                }
                $('#dltipo').change(function () {
                    if ($('#dltipo').val() == 5) {
                        $('#dvproveedor').show();
                        $('#dvempleado').hide();
                    } else {
                        $('#dvproveedor').hide();   
                        $('#dvempleado').show();
                    }
                })
            }, iferror);
        }
        function ShowHideDiv1() {
            var herramientas = document.getElementById("btherramientas");
            var materiales = document.getElementById("btmaterial");
            fentrega.style.display = herramientas.checked ? "block" : "none";
            limpiatipo();
            materiales.style.display = materiales.checked ? "block" : "none";
            limpiatipo();
        }
        function ShowHideDiv() {
            var cexistente = document.getElementById("cexistente");
            var cnuevo = document.getElementById("cnuevo");
            cliente0.style.display = cexistente.checked ? "block" : "none";
            limpiacliente();
            cliente1.style.display = cnuevo.checked ? "block" : "none";
            limpiacliente();
        }
        function oculta() {
            $('#dvsolicitudrecur').hide();
            $('#dvsolicitudrecurocarga').hide();
            $('#dvsolicitudmaterial').hide();
            $('#dvpersonal').hide();
            $('#dvsolicitudmatcarga').hide();
            $('#dvfotos').hide();
        }
        function bloqueo() {
                $('#txpresupuesto').prop("disabled", true);
                $('#txutilidad').prop("disabled", true);
                $('#txppto').prop("disabled", true);
        }
        function calculatopegasto() {
            var topegasto = 0;
            var utilidad = 0;
            var presupuesto = 0;
            var ppto = 0;
            if ($('#txpresupuesto').val() != 0) {
                presupuesto = parseFloat($('#txpresupuesto').val());
            }
            if ($('#txutilidad').val() != 0) {
                utilidad = parseFloat($('#txutilidad').val());
            }
            if ($('#txppto').val() != 0) {
                ppto = parseFloat($('#txppto').val());
            }
            topegasto = presupuesto - (((utilidad+ppto) / 100) * presupuesto)
            $('#txtopegasto').val(topegasto.toFixed(2));
           
        }
        function topegastoppto() {
            var ppto = 0;
            var presupuesto = 0;
            if ($('#txpresupuesto').val() != 0) {
                presupuesto = parseFloat($('#txpresupuesto').val());
            }
            if ($('#txppto').val() != 0) {
                ppto = parseFloat($('#txppto').val());
            }
            topegasto =((ppto / 100) * presupuesto)
            $('#txpptotope').val(topegasto.toFixed(2));
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
            }, iferror);
        }
        function cargatrabajo() {
            PageMethods.trabajo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltrabajo').append(inicial);
                $('#dltrabajo').append(lista);
                if ($('#idtrabajo').val() != 0) {
                    $('#dltrabajo').val($('#idtrabajo').val());
                }
            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
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
        function validar() {
            if ($('#txpresupuesto').val() == 0) {
                alert('Debe capturar el Presupuesto');
                return false;
            }
            if ($('#txutilidad').val() == '') {
                alert('Debe capturar la Utilidad');
                return false;
            }
            if ($('#dltrabajo').val() == '') {
                alert('Debe capturar un Trabajo ');
                return false;
            }
            if ($('#txdesc').val() == '') {
                alert('Debe capturar la descripcion del trabajo');
                return false;
            }           
            if ($('#dlproyecto').val() == 0) {
                alert('Debe elegir un Proyecto');
                return false;
            }
             return true;{}
        }

        function limpiacliente(){
            $('#dlcliente').val(0);
            $('#dlsucursal').val(0);
            $('#txclienten').val('');
            $('#txsucursaln').val('');
        }
        function limpiasolicitud(){
            $('#dlempresa').val(0);
            $('#txfolio1').val(0);
            $('#txstatus1').val('Alta');
            $('#txsolicita').val('');
            $('#dltipo').val(0);
            $('#dlproveedor').val(0);
            $('#txnoemp').val('');
            $('#txnombre').val('');
            $('#dlforma').val(0);
            $('#txdesc1').val('');
            $('#tblistac tbody tr').remove();
            $('#txsubtotalg').val(0);
            $('#txivag').val(0);
            $('#txtotalg').val(0);
            $('#dvempleado').hide();
            $('#dvproveedor').hide();
        }
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
        function xmlUpFile(res) {
            if (validaf()) {

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
                        PageMethods.actualiza($('#txfolio').val(), res, $('#txtipo').val(), function (res) {
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
        function validaf() {
            if ($('#txfileload').val() == '') {
                alert('Debe seleccionar una foto antes de continuar');
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen" runat="server" />
        <asp:HiddenField ID="idalmacen1" runat="server" Value="0" />
        <asp:HiddenField ID="idstatus" runat="server" Value="0" />
        <asp:HiddenField ID="idtrabajo" runat="server" />
        <asp:HiddenField ID="idmat" runat="server" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idtipo" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="idconcepto" runat="server" Value="0" />
        <asp:HiddenField ID="idempresa" runat="server" Value="0" />
        <asp:HiddenField ID="idsol" runat="server" Value="0" />
        <asp:HiddenField ID="idsolm" runat="server" Value="0" />
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
                    <h1>Correctivo Mayor<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimineto</a></li>
                        <li class="active">Correctivo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div id="dvdetalle"> 
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control text-right" disabled="disabled" />
                                </div>                             
                                
                                </div>
                            <div class="row"> 
                                 <div class="col-lg-2 text-right">
                                    <label for="status">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txstatus" class="form-control text-right" disabled="disabled" value="Alta" />
                                </div>
                                 <div class="col-lg-5 text-right">
                                    <label for="txmutilidad">Margen Utilidad:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txmutilidad" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txmutilidad">%</label>
                                </div>                    
                            </div>                           
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfolio">Clave CM:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                
                                
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txpresupuesto">Presupuesto:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpresupuesto" class="form-control  text-right" value=""/>
                                </div>                             
                                <div class="col-lg-1 text-right">
                                    <label for="txtopegasto">Tope Gasto:</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txtopegasto" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txtopegasto">Utilizado:</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txutilizado" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                 
                            </div>
                             <div class="row">
                                  <div class="col-lg-2 text-right">
                                    <label for="txutilidad">Costo Pvd:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txutilidad" class="form-control text-right" value="" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txppto">Costo M.O:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txppto" class="form-control text-right" value="" />
                                </div>                                  
                               
                            </div>
                            <div class="row">
                                <div class="col-log-1" style="margin-left: 250px">
                                    <label class="container">
                                        Cliente Nuevo
                                        <input type="radio" id="cnuevo" name="cliente1" onclick="ShowHideDiv()" value="2" />
                                        <span class="checkmark"></span>
                                    </label>
                                    <label class="container">
                                        Cliente Existente
                                        <input type="radio" id="cexistente" name="cliente1" onclick="ShowHideDiv()" value="1" />
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div id="cliente0" style="display: none">
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
                            </div>
                            <div class="row">
                                <div id="cliente1" style="display: none">
                                    <div class="col-lg-2 text-right">
                                        <label for="txclienten">Cliente Nuevo:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input id="txclienten" class="form-control" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txsucursaln">Punto de atención</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input id="txsucursaln" class="form-control" />
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltrabajo">Trabajo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltrabajo" class="form-control"></select>
                                </div>
                                
                                <div class="col-lg-2 text-right">
                                    <label for="txfoliocliente">Folio Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfoliocliente" class="form-control" />
                                </div>
                            </div>
                           
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txdesc">Descripcion Trabajo:</label>
                                </div>
                                <div class="col-lg-5">
                                    <textarea id="txdesc" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div id="dvtrabajos" class="col-md-2">
                                <ul class="list-group">
                                    <!--bg-olive-->
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btsolicitudrecur">Solicitar de Recursos</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btsolicitudrecver">Ver Recursos solicitados</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btmateriales">Solicitud materiales</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btsolicitudmver">Ver Materiales solicitados</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btpersonal">Mano de Obra</li>
                                    <li class="list-group-item bg-light-blue-gradient puntero" id="btfotos">Fotos</li>
                                    <!--li class="list-group-item bg-light-blue-gradient puntero" id="btpersonal">Mano de Obra</!--li>
                                    -->
                                </ul>
                            </div>
                            <div id="dvsolicitudrecur" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Solicitud de Recursos</h1>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="dlempresa">Empresa:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlempresa" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txfolio1">Folio</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfolio1" class="form-control text-right" disabled="disabled" value="0" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txstatus1">Estatus</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txstatus1" class="form-control" disabled="disabled" value="Alta" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txnoemp">Solicita</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" class=" form-control" id="txsolicita" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">Tipo</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row" id="dvempleado">
                                    <div class="col-lg-1 text-right">
                                        <label for="txnoemp">Empleado</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control" id="txnoemp" />
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap1" />
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" class=" form-control" id="txnombre" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row" id="dvproveedor">
                                    <div class="col-lg-1 text-right">
                                        <label for="dlproveedor">Proveedor</label>
                                    </div>
                                    <div class="col-lg-3 ">
                                        <select id="dlproveedor" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="dlforma">Pago</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlforma" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Cheque</option>
                                            <option value="2">Transferencia</option>
                                            <option value="3">Orden empresarial</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="txdesc1">Concepto</label>
                                    </div>
                                    <div class="col-lg-7">
                                        <textarea class=" form-control" id="txdesc1"></textarea>
                                    </div>
                                </div>
                                <div class="row tbheader" style="height: 300px; overflow-y: scroll;" id="dvconcepto">
                                    <table class=" table table-condensed h6" id="tblistac">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-active"></th>
                                                <th class="bg-light-blue-active">Concepto</th>
                                                <th class="bg-light-blue-active">Importe</th>
                                                <th class="bg-light-blue-active"></th>
                                            </tr>
                                            <tr>
                                                <td class="col-lg-1"></td>
                                                <td class="col-lg-1">
                                                    <select id="dlconcepto" class="form-control"></select>
                                                </td>
                                                <td class="col-lg-1">
                                                    <input type="text" class=" form-control text-right" id="tximporte" />
                                                </td>
                                                <td class="col-lg-1">
                                                    <input type="button" class="btn btn-success" value="Agregar" id="btagrega1" />
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-8 text-right">
                                        <label for="txsubtotalg">Subtotal:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalg" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-8 text-right">
                                        <label for="txivag">IVA:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control text-right" disabled="disabled" id="txivag" />
                                    </div>
                                    <div class="col-lg-1">
                                        <select id="dliva" class="form-control">
                                            <option value="0">0 %</option>
                                            <option value="0.08">8 %</option>
                                            <option value="0.16" selected="selected">16 %</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-info" value="Nuevo" id="btnuevos" />
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="button" class="btn btn-info" value="Guardar"  id="btguardas" />
                                    </div>
                                    <div class="col-lg-6 text-right">
                                        <label for="txtotalg">Total:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control text-right" disabled="disabled" id="txtotalg" />
                                    </div>
                                </div>
                            </div>
                            <div id="dvsolicitudrecurocarga" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Solicitudes de Recursos registradas</h1>
                                    </div>
                                    <div class="row tbheader">
                                    <table class="table table-condensed h6" id="tbsolreg">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                                <th class="bg-light-blue-gradient"><span>Tipo</span></th>
                                                <th class="bg-light-blue-gradient"><span>Beneficiario</span></th>
                                                <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                                <th class="bg-light-blue-gradient"><span>F. Alta</span></th>
                                                <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                                <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                            </div>
                                </div>
                            </div>
                             <div id="dvsolicitudmatcarga" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Solicitudes de Material registradas</h1>
                                    </div>
                                    <div class="row tbheader">
                                    <table class="table table-condensed h6" id="tbsolreg1">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-gradient"><span>Solicitud</span></th>
                                                <th class="bg-light-blue-gradient"><span>F.Alta</span></th>
                                                <th class="bg-light-blue-gradient"><span>Almacen Entrada</span></th>
                                                <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                                <th class="bg-light-blue-gradient"><span>P. Atencion</span></th>
                                                <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                                <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                            </div>
                                </div>
                            </div>  
                            <div id="dvsolicitudmaterial" class="tab-content col-md-10">

                                <div class="row">
                                    <div class="content-header">
                                        <h1>Solicitud Materiales Mantenimiento</h1>
                                    </div>
                                    <br />
                                     <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txfolio2">No. Solicitud:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" id="txfolio2" class="form-control text-right" disabled="disabled" value="0" />
                                        </div>
                                      
                                        <div class="col-lg-2 text-right">
                                            <label for="txestatus">Estatus:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" id="txestatus" class="form-control text-right" disabled="disabled" value="Alta" />
                                        </div>
                                    </div>                                  
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="dlalmacen">Almacén Salida:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <select id="dlalmacen" class="form-control"></select>
                                        </div>
                                        <div class="col-lg-2 text-right">
                                            <label for="dlalmacen1">Almacén Entrada:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <select id="dlalmacen1" class="form-control"></select>
                                        </div>
                                    </div>
    
                                     <div class="row">
                                        <div class="col-lg-2 text-right">
                                        <label for="dltecnico">Tecnico:</label>
                                        </div>
                                        <div class="col-lg-3">
                                        <select id="dltecnico" class="form-control"></select>
                                        </div>
                                    </div>
                            <div class="row">
                                <div class="col-log-1" style="margin-left: 250px">
                                    <label class="container">
                                        Materiales
                                        <input type="radio" id="btmaterial" name="dltipos" onclick="ShowHideDiv1()" value="1" />
                                        <span class="checkmark"></span> 
                                    </label>
                                    <label class="container">
                                        Herramientas
                                        <input type="radio" id="btherramientas" name="dltipos" onclick="ShowHideDiv1()" value="2" />
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="row">
                                <div id="fentrega" style="display: none">
                                    <div class="col-lg-2 text-right">
                                    <label for="txfecha1">Fecha entrega herramienta:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha1" class="form-control" />
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
                                        <textarea class="form-control" disabled="disabled" id="txdesc2"></textarea>
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
                                            <label for="txsubtotalm">Subtotal:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalm" />
                                        </div>
                                    </div>
                                    <br />
                                     <div class="row">                                        
                                        <div class="col-lg-1 text-right">
                                            <label for="txobservacion">Observaciones:</label>
                                        </div>
                                        <div class="col-lg-5">
                                            <textarea id="txobservacion" class=" form-control"></textarea>
                                        </div>
                                        <div class="col-lg-1">
                                        <input type="button" class="btn btn-info" value="Nuevo" id="btnuevos1" />
                                        </div>
                                        <div class="col-lg-1">
                                        <input type="button" class="btn btn-info" value="Guardar"  id="btguardas1" />
                                        </div>
                                    </div>
                                 </div>
                                </div>

                             <div id="dvpersonal" class="tab-content col-md-10">
                                <div class="row">
                                    <div class="content-header">
                                        <h1>Mano de Obra</h1>
                                    </div>                               
                                    <div class="col-lg-8 text-right">
                                    <label for="txtopegasto">Tope Mano de Obra:</label>
                                </div>
                                <div class="col-lg-2 ">
                                    <input type="text" id="txpptotope" class="form-control text-right" disabled="disabled" value="0" />
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
                                  <div class="col-lg-1">
                                        <label for="txtipo">Tipo Doct</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="txtipo" class="form-control">
                                            <option value="0">Seleccione</option>
                                            <option value="1">Presupuesto</option>
                                            <option value="2">Reporte</option>
                                            <option value="2">Evidencia Foto</option>
                                            <option value="3">Otro</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="txfileload">Cargar Fotos</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="file" id="txfileload" class="form-control" />
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="button" class="form-control btn btn-primary" value="Subir" onclick="xmlUpFile()" />
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
                            </div>

                        </div>

                   <div id="divmodal3">
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Solicitud:</label>
                                </div>
                                <div class="col-lg-2">
                                    <label id="lbfolio" ></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Almacen de Entrada:</label>
                                </div>
                                <div class="col-lg-6">
                                    <label id="lbalmacenent"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4">
                                    <label>Estatus:</label>
                                </div>
                                <div class="col-lg-8">
                                    <label id="lbestatus"></label>
                                </div>
                            </div>
                        <div class="row">
                             <div class="col-lg-3">
                                <input type="button" class="btn btn-info" value="Imprimir" id="btimprime1" />
                            </div>
                        </div>
                            <div class="row" style="height:200px; overflow:scroll;">
                                <table class="table table-responsive h6" id="tbdetalle">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Clave</span></th>
                                            <th class="bg-light-blue-gradient"><span>Producto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Unidad</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cantidad</span></th>
                                            <th class="bg-light-blue-gradient"><span>Precio</span></th>
                                            <th class="bg-light-blue-gradient"><span>Total </span></th>
                                                                              
                                        </tr>
                                    </thead>
                                </table>
                            </div>

                        </div>
                        

                    <div id="divmodal2">
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
                        <div id="divmodal1">
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="dlbusca4">Busca por:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlbusca4" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="id_empleado">No. emp.</option>
                                        <option value="rfc">RFC</option>
                                        <option value="curp">CURP</option>
                                        <option value="paterno+' '+RTRIM(materno)+ ' '+a.nombre">Nombre</option>
                                    </select>
                                </div>
                                <div class="col-lg-5">
                                    <input type="text" id="txbusca4" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <button type="button" id="btbuscaemp" value="Buscar" class="btn btn-info pull-right">Buscar</button>
                                </div>
                            </div>
                            <div class="row tbheader">
                                <table class="table table-condensed h6" id="tbllista1">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Id</span></th>
                                            <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                            <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    <div id="btbuscaempl">
                                <div class="row">
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txbusca">Buscar</label>
                                        </div>
                                        <div class="col-lg-5">
                                            <input type="text" class=" form-control" id="txbusca5" placeholder="Ingresa texto de busqueda" />
                                        </div>
                                        <div class="col-lg-1">
                                            <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap5" />
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

                    </div>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>-->
                    </ol>
                </div>
            </div>
            <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
            <div id="loadingScreen"></div>
    </form>
</body>
</html>
                        