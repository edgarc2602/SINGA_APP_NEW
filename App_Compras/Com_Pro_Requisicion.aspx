<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_Requisicion.aspx.vb" Inherits="App_Compras_Com_Pro_Requisicion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REQUISICION DE COMPRA</title>
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
            var d = new Date();
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#txanio').val(d.getFullYear());
            $('#txanio1').val(d.getFullYear());
            $('#dlsucursal').append(inicial);
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
                height: 300,
                width: 700,
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
            cargaempresa();
            cargaproveedor();
            cargaalmacen();
            cargacliente();
            cargames();
            PageMethods.area($('#idusuario').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#idarea').val(datos.id);
                if (datos.id == 8) {
                    //$('#txcomprador').val('<%=minombre%>');
                    //$('#idcomprador').val($('#idusuario').val());
                    $('#dltipo').prop('disabled', false)
                } else {
                    $('#dltipo').val(2);
                    $('#dltipo').prop('disabled', true)
                }
            })
            if ($('#idreq').val() != 0) {
                cargrarequisicion($('#idreq').val());
            }
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
                //cargasuperivisiones();
            })
            $('#btcargac').click(function () {
                if (validaconc()) {
                    $("#divmodal2").dialog('option', 'title', 'Seleccionar datos para concentrado');
                    dialog2.dialog('open');
                }
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(),  function (res) {
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
            })
            $('#btbuscac').click(function () {
                if (validac()) {
                    /*waitingDialog({});
                    var xmlgraba = '<requisicion id="' + $('#txfolio').val() + '" empresa="' + $('#dlempresa').val() + '"';
                    xmlgraba += ' proveedor="' + $('#dlproveedor1').val() + '" cliente="0" almacen="' + $('#dlalmacen').val() + '"';
                    xmlgraba += ' forma="' + $('#dlforma').val() + '" usuario="' + $('#idusuario').val() + '" observacion="CONCENTRADO DE MATERIALES PARA EL MES: ' + $('#dlmes option:selected').text() + ' ' + $('#txanio').val() + '"';
                    xmlgraba += ' comprador="' + $('#idcomprador').val() + '" tipo="1" inmueble="0"'
                    xmlgraba += ' mes="' + $('#dlmes').val() + '" anio="' + $('#txanio').val() + '"/>'*/
                    //alert(xmlgraba);
                    //cuentaconcentrado();
                    cargaconcentrado();

                    $('#cargaconc').val(1);
                    /*PageMethods.guardaconcentrado(xmlgraba, $('#txfolio').val(), function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado.');
                        cargrarequisicion(res);
                        dialog2.dialog('close');
                    }, iferror);*/
                }
            })
            $('#txcantidad').change(function () {
                subtotal();
            })
            $('#txprecio').change(function () {
                subtotal();
            })
            $('#btagrega').click(function () {
                if (validamat()) {
                    var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txunidad').val() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#txcantidad').val() + ' /></td><td>'
                    linea += '<input class="form-control text-right tbeditar" value=' + $('#txprecio').val() + ' /></td><td><input disabled="disabled" class="form-control text-right tbeditar" value=' + $('#txtotal').val() + ' /></td><td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                    $('#tblistaj tbody').append(linea);
                    $('#tblistaj').delegate("tr .btquita", "click", function () {
                        //if ($('#cargaconc').val() == 1) {
                          //  alert('No puede eliminar materiales de una requisición que viene de un concentrado')
                        //} else {
                            $(this).parent().eq(0).parent().eq(0).remove();
                            total();
                        //}
                    });
                    $('#tblistaj tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        total();
                    });
                    total()
                    limpiaproducto();
                }
            })
            $('#btguarda').click(function () {
                guardareq();
            })
            $("#txcantidad").keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
            $("#txprecio").keydown(function (e) {
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
            $('#btimprime').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=requisicioncompra.rpt&v_formula={tb_requisicion.id_requisicion}= ' + $('#txfolio').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btimprime1').click(function () {
                window.open('../RptForAll.aspx?v_nomRpt=requisicioncompraintegra.rpt&v_formula={tb_requisicion.id_requisicion}= ' + $('#txfolio').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btnuevo').click(function () {
                limpia();
                
            })
            $('#btordenc').click(function () {
                if (validaoc()) {
                    window.open('Com_Pro_ordencompra.aspx?idreq=' + $('#txfolio').val(), '_blank')
                    //window.open('../RptForAll.aspx?v_nomRpt=requisicioncompra.rpt&v_formula={tb_requisicion.id_requisicion}= ' + $('#txfolio').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            })
            $('#txclave').focusout(function () {
                PageMethods.productoind($('#txclave').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    if (datos.clave == '') {
                        alert('La clave que ha capturado no existe o esta eliminada, verifique');
                        $('#txclave').val('');
                    } else {
                        $('#txclave').val(datos.clave);
                        $('#txdesc').val(datos.descripcion);
                        $('#txunidad').val(datos.unidad);
                        $('#txprecio').val(datos.precio);
                    }
                })
            })
            $('#dliva').change(function () {
                total();
            })
        })
        function limpia() {
           
            $('#idreq').val(0);
            
            $('#cargaconc').val(0);
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
            $('#txfolio').val(0);
            $('#txstatus').val('Alta');
            $('#dlempresa').val(0);
            $('#dlproveedor').val(0);
            $('#dlforma').val(0);
            $('#dltipo').val(0);
            $('#dlalmacen').val(0);
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#dlsucursal').append(inicial);
            $('#tblistaj tbody tr').remove();
            $('#txsubtotalg').val(0);
            $('#txivag').val(0);
            $('#txtotalg').val(0);
            $('#txobservacion').val('');
        }
        /*
        function cargasuperivisiones() {

        }
        */
        function guardareq() {
            if (valida()) {
                waitingDialog({});
                var xmlgraba = '<movimiento><requisicion id="' + $('#txfolio').val() + '" empresa="' + $('#dlempresa').val() + '"';
                xmlgraba += ' proveedor="' + $('#dlproveedor').val() + '" cliente="' + $('#dlcliente').val() + '" almacen="' + $('#dlalmacen').val() + '"';
                xmlgraba += ' forma="' + $('#dlforma').val() + '" usuario="' + $('#idusuario').val() + '" observacion="' + $('#txobservacion').val() + '"';
                xmlgraba += ' subtot= "' + $('#txsubtotalg').val() + '" iva = "' + $('#txivag').val() + '" total = "' + $('#txtotalg').val() + '"';
                xmlgraba += ' comprador="' + $('#idcomprador').val() + '" tipo="' + $('#dltipo').val() + '" inmueble="' + $('#dlsucursal').val() + '"';
                xmlgraba += ' piva = "' + $('#dliva').val() + '" mes="' + $('#dlmes1').val() + '" anio="' + $('#txanio1').val() + '"/>'
                $('#tblistaj tbody tr').each(function () {
                    xmlgraba += '<partida clave="' + $(this).closest('tr').find('td').eq(0).text() + '" cantidad="' + parseFloat($(this).closest('tr').find("input:eq(0)").val());
                    xmlgraba += '" precio="' + parseFloat($(this).closest('tr').find("input:eq(1)").val()) + '" total="' + parseFloat($(this).closest('tr').find("input:eq(2)").val()) + '" />';
                });
                xmlgraba += '</movimiento>';
                //alert(xmlgraba);
                var folion = 0;
                if ($('#txfolio').val() != 0) {
                    folion = $('#txfolio').val();
                }
                
                PageMethods.guarda(xmlgraba, $('#txfolio').val(), $('#dlmes1').val(), $('#txanio').val(), $('#dlproveedor').val(), $('#dlcliente').val(), $('#cargaconc').val(), folion, function (res) {
                    closeWaitingDialog();
                    $('#txfolio').val(res);
                    alert('Registro completado.');

                }, iferror);
            }
        }
        function cargaconcentrado() {
            PageMethods.concentrado($('#dlproveedor1').val(), $('#dlcliente1').val(), $('#txanio').val(), $('#dlmes').val(), $('#hdpagina').val(), function (res) {
                closeWaitingDialog();
                $('#dlmes1').val($('#dlmes').val())
                $('#txanio1').val($('#txanio').val())
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                total();
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                    $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                    total();
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    /*if ($('#cargaconc').val() == 1) {
                        alert('No puede eliminar materiales de una requisición que viene de un concentrado')
                    } else {
                        
                    }*/
                    $(this).parent().eq(0).parent().eq(0).remove();
                    total();
                });
                $('#dlcliente').val($('#dlcliente1').val());
                PageMethods.comprador($('#dlcliente').val(), 0, function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#idcomprador').val(datos.id);
                    $('#txcomprador').val(datos.nombre);
                })
                $('#dlproveedor').val($('#dlproveedor1').val());
                $('#dltipo').val(1);
                dialog2.dialog('close');
            }, iferror)
        }
        function cuentaconcentrado() {
            PageMethods.contarconcentrado($('#dlproveedor1').val(), $('#dlcliente1').val(), $('#txanio').val(), $('#dlmes').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function validaconc() {
            if ($('#idarea').val() != 8) {
                alert('Esta acciòn solo puede ser ejecutada por personal de compras');
                return false;
            }
            if ($('#dlempresa').val() == 0) {
                alert('Debe seleccionar la Empresa que compra el material');
                return false;
            }
            if ($('#txstatus').val() == 'Autorizada') {
                alert('Esta acción no se puede ejecutar en una Requisición ya autorizada');
                return false;
            }
            if ($('#txstatus').val() == 'Completa') {
                alert('Esta acción no se puede ejecutar en una Requisición ya Completa');
                return false;
            }
            return true;
        }
        function validaoc() {
            if ($('#txfolio').val() == 0) {
                alert('No puede generar Orden de compra porque no ha generado la requisición');
                return false;
            }
            if ($('#txstatus').val() == 'Alta') {
                alert('Para generar Orden de compra debe autorizar la Requisición');
                return false;
            }
            if ($('#txstatus').val() == 'Completa') {
                alert('No se pueden generar mas ordenes de compra de una Requisición ya completa');
                return false;
            }
            return true;
        }
        function cargrarequisicion(idreq) {
            PageMethods.cargareq(idreq, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfolio').val(datos.id);
                $('#txfecha').val(datos.falta);
                $('#dltipo').val(datos.tipo);
                if (datos.tipo == 1) {
                    $('#cargaconc').val(1);
                } else {
                    $('#cargaconc').val(0);
                }
                $('#idcomprador').val(datos.idcomprador);
                $('#idempresa').val(datos.id_empresa);
                cargaempresa();
                $('#idproveedor').val(datos.id_proveedor);
                cargaproveedor();
                $('#dlforma').val(datos.formapago);
                $('#idalmacen').val(datos.id_almacen);
                cargaalmacen();
                $('#idcliente').val(datos.id_cliente);
                cargacliente();
                $('#idinmueble').val(datos.idinmueble);
                cargainmueble(datos.id_cliente);
                cargaestado(datos.idinmueble);
                $('#txsubtotalg').val(datos.subtotal);
                $('#txivag').val(datos.iva);
                $('#txtotalg').val(datos.total);
                $('#txobservacion').val(datos.observacion);  
                $('#txstatus').val(datos.estatus);
                $('#dliva').val(datos.piva);
                $('#idmes').val(datos.mes);
                cargames();
                $('#txanio').val(datos.anio);
                PageMethods.comprador(0, datos.idcomprador, function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#idcomprador').val(datos.id);
                    $('#txcomprador').val(datos.nombre);
                })
                cuentareq(datos.id)
                detallereq(datos.id);
            }, iferror);
        }
        function cuentareq(idreq) {
            PageMethods.contardetalle(idreq, function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function detallereq(folio) {  
            PageMethods.cargadetalle(folio, $('#hdpagina').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                    $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                    PageMethods.actualizalinea(parseFloat($(this).closest('tr').find("input:eq(0)").val()), parseFloat($(this).closest('tr').find("input:eq(1)").val()), $(this).closest('tr').find('td').eq(0).text(), $('#txfolio').val(), function (res) {
                        total();
                    }, iferror);
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    /*if ($('#cargaconc').val() == 1) {
                        alert('No puede eliminar materiales de una requisición que viene de un concentrado')
                    } else {
                        
                    }*/
                    $(this).parent().eq(0).parent().eq(0).remove();
                    total();
                });
            }, iferror)
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            guardareq();
            detallereq($('#txfolio').val());
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val(0);
            $('#txtotal').val('');
        }
        function valida() {
            if ($('#dlempresa').val() == 0) {
                alert('Debe elegir una Empresa');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de Requisiciòn');
                return false;
            }
            if ($('#dlcliente').val() == 0 && $('#idarea').val() != 8) {
                alert('Debe elegir un cliente');
                return false;
            }
            if ($('#tblistaj tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            /*
            $('#tblistaj tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(2)").val());
            });
            */
            var noprecio = 0
            $('#tblistaj tbody tr').each(function () {
                if (parseFloat($(this).closest('tr').find("input:eq(1)").val()) == 0) {
                    noprecio = 1 
                    return false;
                }
            });
            if (noprecio == 1) {
                alert('No se puede generar la requisición ya que alguno de los materiales no tiene precio registrado, verifique')
                return false;
            }
            return true;
        }
        function validac() {
            if ($('#dlproveedor1').val() == 0) {
                alert('Debe elegir un Proveedor');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir un mes');
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
                if ($('#idmes').val() != 0) {
                    $('#dlmes1').val($('#idmes').val());
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
                    PageMethods.comprador($('#dlcliente').val(),0, function (detalle) {
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
                if ($('#idinmueble').val() != 0) {
                    $('#dlsucursal').val($('#idinmueble').val());
                }
                $('#dlsucursal').change(function () {
                    cargaestado($('#dlsucursal').val());
                })
            }, iferror);
        }
        function cargaestado(inm) {
            PageMethods.estado(inm, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#lbestado').text(datos.estado);
            })
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
            PageMethods.catproveedor(function (opcion) {
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
                $('#dlproveedor1').empty();
                $('#dlproveedor1').append(inicial);
                $('#dlproveedor1').append(lista);
            }, iferror);
        }
        function cargaalmacen() {
            PageMethods.almacen(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlalmacen').empty();
                $('#dlalmacen').append(inicial);
                $('#dlalmacen').append(lista);
                if ($('#idalmacen').val() != 0) {
                    $('#dlalmacen').val($('#idalmacen').val());
                }
            }, iferror);
        }
        function subtotal() {
            var tot = parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val());
            $('#txtotal').val(tot.toFixed(2));
        }
        function total() {
            var subtotal = 0;
            var iva = 0;
            var total = 0;
           
            
            $('#tblistaj tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(2)").val());
            });
            
            iva = subtotal * parseFloat($('#dliva').val()) 
            total = subtotal + iva

            $('#txsubtotalg').val(subtotal.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
        }
        function validamat() {
            /*
            if ($('#cargaconc').val() == 1) {
                alert('Cuando carga un concentrado de materiales no puede agregar materiales al listado');
                return false;
            }*/
            if ($('#txclave').val() == '') {
                alert('Debe elegir la clave del material');
                return false;
            }
            if ($('#txcantidad').val() == '') {
                alert('Debe capturar la cantidad de material');
                return false;
            }
            if ($('#txprecio').val() == '') {
                $('#txprecio').val(0);
                subtotal();
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
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idreq" runat="server" Value="0" />
        <asp:HiddenField ID="idempresa" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="idalmacen" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idcomprador" runat="server" Value="0" />
        <asp:HiddenField ID="idarea" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="cargaconc" runat="server" Value="0" />
        <asp:HiddenField ID="idmes" runat="server" Value="0" />
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
                    <h1>Requisición de Compra<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Requisición de compra</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-3 text-right">
                                    <label for="txfecha">Fecha:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfolio">No. Req:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txstatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txstatus" class="form-control" disabled="disabled" value="Alta"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlempresa" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlproveedor">Proveedor:</label></div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlforma">Pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlforma" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Credito</option>
                                        <option value="2">Contado</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Entrega mensual</option>
                                        <option value="2">Solicitado por el cliente</option>
                                    </select>
                                </div>
                                
                                <div class="col-lg-1 text-right">
                                    <label for="dlalmacen">Almacén:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlalmacen" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3 ">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label for="dlsucursal">Pto de atención:</label>
                                </div>
                                <div class="col-lg-3 ">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label id="lbestado"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txcomprador">Comprador:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcomprador" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" class="form-control btn btn-primary" value="Cargar concentrado" id="btcargac" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlmes1">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlmes1" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txanio1">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio1" class="form-control"/>
                                </div>
                            </div>
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
                            <div id="divmodal2">
                                <div class="row">
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="dlproveedor1">Proveedor:</label>
                                        </div>
                                        <div class="col-lg-6">
                                            <select id="dlproveedor1" class="form-control"></select>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="dlcliente1">Cliente:</label>
                                        </div>
                                        <div class="col-lg-6">
                                            <select id="dlcliente1" class="form-control"></select>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txanio">Año:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" id="txanio" class="form-control"/>
                                        </div>
                                        <div class="col-lg-1">
                                            <label for="dlmes">Mes:</label>
                                        </div >
                                        <div class="col-lg-3">
                                            <select id="dlmes" class="form-control"></select>
                                        </div>
                                        <div class="col-lg-1">
                                            <input type="button" class="btn btn-primary" value="Cargar concentrado" id="btbuscac" />
                                        </div>
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
                                        <input type="text" class=" form-control text-right" id="txprecio" />
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
                        <div class="col-lg-2">
                            <select id="dliva" class="form-control">
                                <option value="0.08">8 %</option>
                                <option value="0.16" selected="selected">16 %</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-8 text-right">
                            <label for="txtotalg">Total:</label>
                        </div>
                        <div class="col-lg-2">
                            <input type="text" class=" form-control text-right" disabled="disabled" id="txtotalg" />
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
                        <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>-->
                        <!--<li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>-->
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                        <li id="btimprime1" class="puntero"><a><i class="fa fa-print"></i>Imprimir integración</a></li>
                        <li id="btordenc" class="puntero"><a><i class="fa fa-save"></i>Generar Orden de compra</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
