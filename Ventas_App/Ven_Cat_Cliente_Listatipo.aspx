<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Listatipo.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Listatipo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LISTAS DE MATERIALES</title>
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
            cargainmueble();
            cargafrecuencia();
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            if ($('#idcte').val() != 0) {
                $('#txctenom').text($('#nombre').val());
            }
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        $('#txprecio').val($(this).children().eq(3).text());
                        //cargaasignados($('#idempleado').val());
                        dialog1.dialog('close');
                    });
                }, iferror)
            })
            $('#btagrega').click(function () {
                PageMethods.guardalinea($('#dlinmueble').val(), $('#txclave').val(), $('#dlfrecuencia').val(), $('#txcantidad').val(),  function () {
                    limpiaproducto();
                    cargalista();
                }, iferror);
            })
        });
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val('');
            $('#txtotal').val('');
            $('#txclave').focus();
        }
        function cargainmueble() {
            PageMethods.inmueble($('#idcte').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);
                $('#dlsucursal').change(function () {
                    cargalista();
                })
            }, iferror);
        }
        function cargafrecuencia() {
            PageMethods.frecuencia( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlfrecuencia').empty();
                $('#dlfrecuencia').append(inicial);
                $('#dlfrecuencia').append(lista);
            }, iferror);
        }
        function cargalista() {
            PageMethods.materiales($('#dlsucursal').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren);
                /*$('#tblista  tbody tr').on('click', function () {
                    if ($(this).children().eq(7).text() != 'Programado para baja') {
                        limpia();
                        $('#txid').val($(this).children().eq(0).text())
                        $('#txcodigo').val($(this).children().eq(2).text())
                        $('#txnombre').val($(this).children().eq(1).text())
                        $('#txfecini').val($(this).children().eq(3).text())
                        $('#txcontacto').val($(this).children().eq(4).text())
                        $('#txpuesto').val($(this).children().eq(5).text())
                        $('#txtelefono').val($(this).children().eq(6).text())
                        datoscliente();
                        $('#dvtabla').hide();
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    } else {
                        alert('No se puede hacer modificaciones a un Cliente programado para baja');
                    }
                });*/
            }, iferror);
        };
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idcte" runat="server" />
        <asp:HiddenField ID="nombre" runat="server" />
        <div class="content">
            <div class="content-header">
                <h1>Listados de material: <span id="txctenom"></span></h1>
            </div>
            <div class="row" id="dvdatos">
                <!-- Horizontal Form -->
                <div class="box box-info">
                    <div class=" box-header">
                        <!-- <h3 class="box-title">Datos de Punto de atención</h3>-->
                    </div>
                    <!-- /.box-header -->
                    <div class="row">
                        <div class="col-lg-2 text-right">
                            <label for="txidinm">Punto de atención:</label>
                        </div>
                        <div class="col-lg-3">
                            <select class="form-control" id="dlsucursal"></select>
                        </div>
                    </div>
                </div>
            </div>
            <div id="dvjarceria" class="row tbheader" style="height: 400px; overflow-y: scroll;">
                <table class=" table table-condensed h6" id="tblistaj">
                    <thead>
                        <tr>
                            <th class="bg-light-blue-active" colspan="2">Clave</th>
                            <th class="bg-light-blue-active">Descripción</th>
                            <th class="bg-light-blue-active">Unidad</th>
                            <th class="bg-light-blue-active">Cantidad</th>
                            <th class="bg-light-blue-active">Frecuencia</th>
                            <th class="bg-light-blue-active">Precio</th>
                            <th class="bg-light-blue-active">total</th>
                            <th class="bg-light-blue-active"></th>
                        </tr>
                        <tr>
                            <td class=" col-xs-1">
                                <input type="text" class=" form-control" id="txclave" />
                            </td>
                            <td class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                            </td>
                            <td class="col-xs-2">
                                <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                            </td>
                            <td class="col-xs-1">
                                <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                            </td>
                            <td class="col-xs-1">
                                <input type="text" class=" form-control" id="txcantidad" />
                            </td>
                            <td class="col-xs-2">
                                <select id="dlfrecuencia" class="form-control"></select>
                            </td>
                            <td class="col-xs-1">
                                <input type="text" class=" form-control" disabled="disabled" id="txprecio" />
                            </td>
                            <td class="col-xs-1">
                                <input type="text" class=" form-control" disabled="disabled" id="txtotal" />
                            </td>
                            <td class="col-lg-1">
                                <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                            </td>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <div id="divmodal1">
                <div class="row">
                    <div class="row">
                        <div class="col-lg-2 text-right">
                            <label for="txbusca">Buscar</label></div>
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
    </form>
</body>
</html>
