﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Subcontrato.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Subcontrato" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>PRESUPUESTO DE SUBCONTRATOS</title>
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
            //$('#var1').html('<%=listamenu%>');
            //$('#nomusr').text('<%=minombre%>');
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            if ($('#idcte').val() != 0) {
                $('#txctenom').text($('#nombre').val());
                cargasubcontrato();
                cargalineas();
                cargaperiodo();
            }
            $('#btagrega').click(function () {
                if (validasubcontrato()) {
                    var fini = $('#txfecha').val().split('/');
                    var finicio = fini[2] + fini[1] + fini[0];

                    var xmlgraba = '<subcontrato cliente= "' + $('#idcte').val() + '" linea= "' + $('#dllinea').val() + '" periodo ="' + $('#dlperiodo').val() + '" concepto = "' + $('#txconcepto').val() + '"';
                    xmlgraba += ' importe= "' + $('#tximporte').val() + '" faplica= "' + finicio + '"/>';

                    alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {

                    }, iferror);
                    cargasubcontrato();
                }
            });
        });
        function validasubcontrato() {
            if ($('#dllinea').val() == 0) {
                alert('Debe seleccionar una línea de negocio');
                return false
            }
            if ($('#dlperiodo').val() == 0) {
                alert('Debe seleccionar un período');
                return false
            }
            if ($('#txconcepto').val() == '') {
                alert('Debe capturar un Concepto');
                return false
            }
            if ($('#importe').val() == '') {
                alert('Debe colocar un Importe');
                return false
            }
            if (parseFloat($('#importe').val()) == '') {
                alert('Debe colocar un Importe');
                return false
            }
            if ($('#txfecha').val() == '') {
                alert('Debe colocar una Fecha');
                return false
            }
            return true
        }
        function cargasubcontrato() {
            PageMethods.subcontratos($('#idcte').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbsubcontrato tbody').remove();
                $('#tbsubcontrato').append(ren);
                $('#tbsubcontrato tbody tr').on('click', '.btborrar', function () {
                    PageMethods.elimina($(this).closest('tr').find('td').eq(0).text(), function () {
                        alert('Registro eliminado');
                        cargasubcontrato();
                    });
                });
            });
        }
        function cargalineas() {
            PageMethods.lineas(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dllinea').append(inicial);
                $('#dllinea').append(lista);
                $('#dllinea').val(0);
            });
        }
        function cargaperiodo() {
            PageMethods.periodos(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlperiodo').append(inicial);
                $('#dlperiodo').append(lista);
                $('#dlperiodo').val(0);
            });
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
        <asp:HiddenField ID="idcte" runat="server" />
        <asp:HiddenField ID="nombre" runat="server" />
        <div class="content">
            <div class="content-header">
                <h1>Presupuesto de Subcontratos: <span id="txctenom"></span></h1>
            </div>
            <div class="content">
                <div class="col-md-11 tbheader">
                    <table class="table table-condensed" id="tbsubcontrato">
                        <thead>
                            <tr>
                                <th class="bg-navy"></th>
                                <th class="bg-navy"><span>Linea de negocio</span></th>
                                <th class="bg-navy"><span>Periodo</span></th>
                                <th class="bg-navy"><span>Concepto</span></th>
                                <th class="bg-navy"><span>Importe</span></th>
                                <th class="bg-navy"><span>F. Aplica</span></th>
                            </tr>
                            <tr>
                                <th></th>
                                <th class="col-lg-3">
                                    <select id="dllinea" class="form-control"></select>
                                </th>
                                <th class="col-lg-2">
                                    <select id="dlperiodo" class="form-control"></select>
                                </th>
                                <th class="col-lg-4">
                                    <input id="txconcepto" class="form-control" />
                                </th>
                                <th class="col-lg-1">
                                    <input id="tximporte" class="form-control" />
                                </th>
                                <th class="col-lg-1">
                                    <input id="txfecha" class="form-control" />
                                </th>
                                <th>
                                    <input type="button" class="btn btn-primary" value="Agregar" id="btagrega" />
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <ol class="breadcrumb">
                        <li id="btsalir" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                    </ol>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
