<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Solicitudrecurso.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Solicitudrecurso" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>SOLICITUD DE RECURSOS</title>
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
        #tblistaf thead th:nth-child(5), #tblistaf tbody td:nth-child(5){
            width:100px;
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
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog2 = $('#divmodal2').dialog({
                autoOpen: false,
                height: 450,
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
            var f = new Date();
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear() +  ' '+ f.getHours()  + ':'+ f.getMinutes());
            $('#dvempleado').hide();
            $('#dvjornal').hide();
            $('#dvproveedor').hide();
            $('#dvconcepto').hide();
            $('#dvfactura').hide();
            $('#btfacturas').hide();
            cargaempresa();
            cargaproveedor();
            cargaarea(0);
            cargaarea(1);
            cargatipo();
            cargaconcepto();
            cargacliente();
            cargalinea();
            if ($('#idsol').val() != 0) {
                cargasolicitud($('#idsol').val());
            }
            $('#btbuscap').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Buscar empleado');
                dialog1.dialog('open');
            })
            $('#btbuscaj').click(function () {
                $("#divmodal2").dialog('option', 'title', 'Buscar Jornalero');
                dialog2.dialog('open');
            })
            
            $('#btbuscaemp').click(function () {
                cargaempleado();
            })
            $('#btbuscajor').click(function () {
                cargajornal();
            })
            $('#btagrega').click(function () {
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
            })
            $('#txnoemp').change(function (){
                PageMethods.empleado($('#txnoemp').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    if (datos.id == '') {
                        alert('El numero de empleado que ha capturado no es valido, verifique');
                        $('#txnoemp').val('');
                        $('#txnoemp').focus();
                    } else {
                        $('#txclave').val(datos.id);
                        $('#txnombre').val(datos.nombre);
                        //$('#txempresa').val(datos.empresa);
                        //$('#idempresa').val(datos.idemp);
                    }
                })
            })
            $('#dliva').change(function () {
                total();
            })
            $('#btfacturas').click(function () {
                if ($('#dlproveedor').val() != 0) {
                    cargafacturas();
                } else {
                    alert('Debe elegir un Proveedor para aplicar facturas');
                }
            });
            $('#dlpago').change(function () {  
                switch ($('#dlpago').val()) {
                    case '0':
                        alert('Debe elegir un tipo de gasto')
                    case '1':
                        $('#dvconcepto').show();
                        $('#dvfactura').hide();
                        /*$('#btfacturas').hide();*/
                        $('#btfacturas').show();
                        break;
                    case '2':
                        $('#dvconcepto').hide();
                        $('#dvfactura').show();
                        $('#btfacturas').show();                       
                        break;
                }
            })
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    //var tipoop = 0;
                    //if ($('#dltipo').val() == 5 && $('#dlpago').val() == 2) {
                    //    tipoop = 1;
                    //} else {
                    //    tipoop = 2;
                    //}
                    var xmlgraba = '<movimiento> <solicitud id="' + $('#txfolio').val() + '" empleado="' + $('#txnoemp').val() + '"';
                    xmlgraba += ' empresa="' + $('#dlempresa').val() + '" areasolicita="' + $('#txsolicita').val() + '"';
                    xmlgraba += ' proveedor="' + $('#dlproveedor').val() + '" areaautoriza="' + $('#dlarea1').val() + '" concepto="' + $('#txdesc').val() + '"';
                    xmlgraba += ' tipogasto="' + $('#dltipo').val() + '" formapago="' + $('#dlforma').val() + '" tipopago="' + $('#dlpago').val() + '"' ;
                    xmlgraba += ' subtot= "' + $('#txsubtotalg').val() + '" iva = "' + $('#txivag').val() + '" total = "' + $('#txtotalg').val() + '"';
                    xmlgraba += ' usuario ="' + $('#idusuario').val() + '" piva="' + $('#dliva').val() + '" cliente="' + $('#dlcliente').val() + '" cm="0" jornalero="' + $('#txjornal').val() + '" ';
                    xmlgraba += ' inmueble ="' + $('#dlsucursal').val() + '" linea ="' + $('#dllinea').val() + '" iguala ="' + $('#dliguala').val() + '" />'
                    if ($('#dltipo').val() == 5 && $('#dlpago').val() == 2) {
                        $('#tblistaf tr input[type=checkbox]:checked').each(function () {
                            xmlgraba += '<partida provision="' + $(this).closest('tr').find('td').eq(0).text() + '" factura="' + $(this).closest('tr').find('td').eq(1).text() + '"  importe="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"/>'
                        });
                    } else {
                        $('#tblistac tbody tr').each(function () {
                            xmlgraba += '<partida concepto="' + $(this).closest('tr').find('td').eq(0).text() + '" importe="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"/>'
                        });
                    }
                    xmlgraba += '</movimiento>';
                    alert(xmlgraba);
                    
                    PageMethods.guarda(xmlgraba, tipoop, function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado');
                    }, iferror);
                }
            })
        })
        function cargalinea() {
            PageMethods.linea(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dllinea').empty();
                $('#dllinea').append(inicial);
                $('#dllinea').append(lista);
                if ($('#idlinea').val() != 0) {
                    $('#dllinea').val($('#idlinea').val());
                }
            }, iferror);
        }
        function cargasolicitud(idsol) {
            PageMethods.cargasol(idsol, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfecha').val(datos.falta);
                $('#txfolio').val(datos.id);
                $('#idempresa').val(datos.idempresa);
                cargaempresa();
                $('#idcliente').val(datos.cliente);
                cargacliente();
                $('#idinmueble').val(datos.inmueble);
                cargainmueble(datos.cliente)
                $('#idlinea').val(datos.linea);
                cargalinea();
                $('#dliguala').val(datos.iguala);
                $('#txsolicita').val(datos.areas);
                $('#idtipo').val(datos.tipo);
                cargatipo();
                if (datos.tipo == 5) {
                    $('#dvproveedor').show();
                    $('#dvempleado').hide();
                    $('#idproveedor').val(datos.idproveedor);
                    cargaproveedor();
                    $('#dlpago').val(datos.tipopago);
                } if (datos.tipo == 3) {
                    $('#dvproveedor').hide();
                    $('#dvjornal').show();
                    $('#dvconcepto').show();
                    $('#dvfactura').hide();
                    $('#txjornal').val(datos.idjornalero);
                    $('#txnombrej').val(datos.jornalero);
                } else {
                    $('#dvproveedor').hide();
                    $('#dvempleado').show();
                    $('#dvconcepto').show();
                    $('#dvfactura').hide();
                    $('#txnoemp').val(datos.idempleado);
                    $('#txnombre').val(datos.empleado);
                }
            
                if (datos.tipo == 5 && datos.tipopago == 2) {
                    $('#dvconcepto').hide();
                    $('#dvfactura').show();
                    cargadeffacturas(datos.id)
                } else {
                    $('#dvconcepto').show();
                    $('#dvfactura').hide();
                    cargadetconcepto(datos.id)
                }
                $('#idarea1').val(datos.areaa);
                cargaarea(1);
                $('#dlforma').val(datos.formapago);
                $('#txdesc').val(datos.concepto);
                $('#txsubtotalg').val(datos.subtotal);
                $('#txivag').val(datos.iva);
                $('#txtotalg').val(datos.total);
                $('#dliva').val(datos.piva);
            })
        }
        function limpia() {
            var f = new Date();
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear() + ' ' + f.getHours() + ':' + f.getMinutes());
            $('#txstatus').val('Alta');
            $('#txfolio').val(0);
            $('#idempresa').val(0);
            $('#dlempresa').val(0);
            $('#idcliente').val(0);
            $('#dlcliente').val(0);
            $('#txsolicita').val('');
            $('#idtipo').val(0);
            $('#dltipo').val(0);
            $('#txnoemp').val('');
            $('#txnombre').val('');
            $('#dlproveedor').val(0);
            $('#dvempleado').hide();
            $('#dvfactura').hide();
            $('#idarea1').val(0);
            $('#dlarea1').val(0);
            $('#dlforma').val(0);
            $('#txdesc').val('');
            $('#txsubtotalg').val(0);
            $('#txivag').val(0);
            $('#txtotalg').val(0);
            $('#dliva').val(0);
            $('#tbllista1 tbody').remove();
            $('#tblistac tbody').remove();
            var linea = '<tbody></tbody>'
            $('#tbllista1').append(linea);
            $('#tblistac').append(linea);
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
        function cargaempleado() {
            PageMethods.empleadolista($('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllista1 tbody').remove();
                $('#tbllista1').append(ren);
                $('#tbllista1 tbody tr').on('click', function () {
                    $('#txnoemp').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txnombre').val($(this).closest('tr').find('td').eq(1).text());
                    $('#txempresa').val($(this).closest('tr').find('td').eq(2).text());
                    $('#idempresa').val($(this).closest('tr').find('td').eq(3).text());                    
                    dialog1.dialog('close');
                });
            });
        }
        function cargajornal() {
            PageMethods.jornallista($('#dlbuscaj').val(), $('#txbuscaj').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbllistaj tbody').remove();
                $('#tbllistaj').append(ren);
                $('#tbllistaj tbody tr').on('click', function () {
                    $('#txjornal').val($(this).closest('tr').find('td').eq(0).text());
                    $('#txnombrej').val($(this).closest('tr').find('td').eq(1).text());
                    $('#txempresa').val($(this).closest('tr').find('td').eq(2).text());
                    $('#idempresa').val($(this).closest('tr').find('td').eq(3).text());
                    dialog2.dialog('close');
                });
            });
        }
        function valida() {
            if ($('#dlempresa').val() == 0) {
                alert('Debe elegir la empresa que paga la solicitud');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir el cliente');
                return false;
            }
            if ($('#dllinea').val() == 0) {
                alert('Debe elegir la línea de negocio');
                return false;
            }
            if ($('#dliguala').val() == 0) {
                alert('Debe elegir el tipo de iguala');
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
            if ($('#dltipo').val() == 5 && $('#dlpago').val() == 0) {
                alert('Debe elegir un tipo de gasto');
                return false;
            }
            if ($('#dltipo').val() == 3 && $('#txjornal').val() == '') {
                alert('Debe elegir un jornalero');
                return false;
            }
            if ($('#dltipo').val() != 5 && $('#dltipo').val() != 3 && $('#txnoemp').val() == '') {
                alert('Debe elegir un empleado');
                return false;
            }
            if ($('#dlarea1').val() == 0) {
                alert('Debe elegir el área que valida la solicitud');
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
            
            return true;
        }
        function limpiaconcepto() {
            $('#dlconcepto').val(0);
            $('#tximporte').val(0);
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
        function total1() {
            var subtotal = 0;
            var iva = 0;
            var total = 0;
            $('#tblistaf tr input[type=checkbox]:checked').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(0)").val());
            });
            subtotal = subtotal / (1 + parseFloat($('#dliva').val()));
            iva = subtotal * parseFloat($('#dliva').val());
            total = subtotal + iva;
            $('#txsubtotalg').val(subtotal.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
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
            /*
            if (($('#dltipo').val() == 4 || $('#dltipo').val() == 3) && $('#dlconcepto').val() != 8) {
                alert('Para pagos de incidencias o jornales solo puede agregar el concepto de Nomina');
                return false;
            }*/
            if (($('#dltipo').val() != 4 && $('#dltipo').val() != 3) && $('#dlconcepto').val() == 8) {
                alert('Solo puede agregar pago de Nómina, en solicitudes para incidencia de nómina o jornales');
                return false;
            }
            return true;
        }
        function cargafacturas() {
            PageMethods.facturas($('#dlproveedor').val(), function (res) {
               // closeWaitingDialog();
                var ren1 = $.parseHTML(res);
                $('#tblistaf tbody').remove();
                $('#tblistaf').append(ren1);
                $('#tblistaf').delegate('tr .tbeditar',"change", function () {
                    total1();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total1();
                });
            }, iferror)
        }
        function cargadeffacturas(sol) {

            PageMethods.detfacturas(sol, function (res) {
                // closeWaitingDialog();
                var ren1 = $.parseHTML(res);
                $('#tblistaf tbody').remove();
                $('#tblistaf').append(ren1);
                $('#tblistaf').delegate('tr.tbeditar',"change", function () {
                    total1();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total1();
                });
            }, iferror)
        }
        function cargadetconcepto(sol) {
            PageMethods.detconcepto(sol, function (res) {
                // closeWaitingDialog();
                var ren1 = $.parseHTML(res);
                $('#tblistac tbody').remove();
                $('#tblistac').append(ren1);
                $('#tblistac').delegate('tr .tbeditar',"change", function () {
                    total();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total();
                });
            }, iferror)
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
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
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
            }, iferror);
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
        function cargaarea(tipo) {
            PageMethods.area(tipo, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                if (tipo == 0) {
                    $('#dlarea').empty();
                    $('#dlarea').append(inicial);
                    $('#dlarea').append(lista);
                    if ($('#idarea').val() != 0) {
                        $('#dlarea').val($('#idarea').val());
                    }
                } else {
                    $('#dlarea1').empty();
                    $('#dlarea1').append(inicial);
                    $('#dlarea1').append(lista);
                    if ($('#idarea1').val() != 0) {
                        $('#dlarea1').val($('#idarea1').val());
                    }
                }
            }, iferror);
        }
        function cargatipo() {
            PageMethods.tipo(function (opcion) {
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
                    switch ($('#dltipo').val()) {
                        case '5': 
                            $('#dvproveedor').show();
                            $('#dvempleado').hide();
                            $('#dvjornal').hide();
                            break;
                        case '3':
                            $('#dvproveedor').hide();
                            $('#dvempleado').hide();
                            $('#dvconcepto').show();
                            $('#dvjornal').show();
                            break;
                        default:
                            $('#dvproveedor').hide();
                            $('#dvempleado').show();
                            $('#dvjornal').hide();
                            $('#dvconcepto').show();
                            $('#dvfactura').hide();
                            break;
                    }
                    if ($('#dltipo').val() == 4 || $('#dltipo').val() == 3) {
                        $('#dlarea1').val(9);
                    } else {
                        $('#dlarea1').val(0);
                    }
                })
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
                $('#dlcliente').val(0);
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val())
                }
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
            }, iferror);
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
        <asp:HiddenField ID="idsol" runat="server" Value="0"  />
        <asp:HiddenField ID="idarea" runat="server" Value="0" />
        <asp:HiddenField ID="idarea1" runat="server" Value="0" />
        <asp:HiddenField ID="idtipo" runat="server" Value="0" />
        <asp:HiddenField ID="idproveedor" runat="server" Value="0" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idconcepto" runat="server" Value="0" />
        <asp:HiddenField ID="idempresa" runat="server" Value="0" />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
        <asp:HiddenField ID="idlinea" runat="server" Value="0" />
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
                    <h1>Solicitud de Recursos<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Solicitud</li>
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
                                    <label for="txfecha">Fecha</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txfolio">Folio</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txstatus">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txstatus" class="form-control" disabled="disabled" value="Alta" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlempresa">Empresa:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlempresa" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlsucursal">Pto Atn:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dllinea">Línea:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dllinea" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dliguala">Iguala:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dliguala" class="form-control">
                                        <option value="0">Seleccione ...</option>
                                        <option value="1">Dentro de iguala</option>
                                        <option value="2">Fuera de iguala</option>
                                    </select>
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
                                <div class="col-lg-1 text-right">
                                    <label for="dlarea1">Area válida</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlarea1" class="form-control"></select>
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
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" class=" form-control" id="txnombre" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row" id="dvjornal">
                                <div class="col-lg-1 text-right">
                                    <label for="txnojor">Jornalero</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" class=" form-control" id="txjornal" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscaj" />
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" class=" form-control" id="txnombrej" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row" id="dvproveedor">
                                <div class="col-lg-1 text-right">
                                    <label for="dlproveedor">Proveedor</label>
                                </div>
                                <div class="col-lg-3 ">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlpago">Gasto</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlpago" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Por comprobar</option>
                                        <option value="2">Facturas pendientes</option>
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-info" value="Cargar facturas" id="btfacturas" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlforma">Pago por</label>
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
                                    <label for="txdesc">Concepto</label>
                                </div>
                                <div class="col-lg-7">
                                    <textarea class=" form-control" id="txdesc"></textarea>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="row tbheader" style="height: 300px; overflow-y: scroll;" id="dvconcepto">
                        <table class=" table table-condensed h6" id="tblistac">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Id</th>
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
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="row tbheader" style="height: 300px;  overflow-y: scroll;" id="dvfactura">
                        <table class=" table table-condensed h6" id="tblistaf">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Provisión</th>
                                    <th class="bg-light-blue-active">Factura</th>
                                    <th class="bg-light-blue-active">F. Factura</th>
                                    <th class="bg-light-blue-active">Pendiente</th>
                                    <th class="bg-light-blue-active">Importe a pagar</th>
                                    <th class="bg-light-blue-active">Aplicar</th>
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
                                <option value="0">0 %</option>
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
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>-->
                    </ol>
                </div>
                <div id="divmodal1">
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="dlbusca">Busca por:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlbusca" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="id_empleado">No. emp.</option>
                                <option value="rfc">RFC</option>
                                <option value="curp">CURP</option>
                                <option value="paterno+' '+RTRIM(materno)+ ' '+a.nombre">Nombre</option>
                            </select>
                        </div>
                        <div class="col-lg-5">
                            <input type="text" id="txbusca" class="form-control" />
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
                <div id="divmodal2">
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="dlbusca">Busca por:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlbuscaj" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="id_jornalero">No. jornal</option>
                                <option value="paterno+' '+ materno + ' '+a.nombre">Nombre</option>
                            </select>
                        </div>
                        <div class="col-lg-5">
                            <input type="text" id="txbuscaj" class="form-control" />
                        </div>
                        <div class="col-lg-1">
                            <button type="button" id="btbuscajor" value="Buscar" class="btn btn-info pull-right">Buscar</button>
                        </div>
                    </div>
                    <div class="row tbheader">
                        <table class="table table-condensed h6" id="tbllistaj">
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
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
