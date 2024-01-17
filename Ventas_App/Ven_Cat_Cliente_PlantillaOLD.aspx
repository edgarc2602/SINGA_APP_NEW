<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Plantilla.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Plantilla" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE PLANTILLAS</title>
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
        #tbplantilla tbody td:nth-child(1){
            width:0px;
            display:none;
        }
        
        #tbplantilla tbody td:nth-child(5),#tbplantilla tbody td:nth-child(6),
        #tbplantilla tbody td:nth-child(7),#tbplantilla tbody td:nth-child(8),#tbplantilla tbody td:nth-child(9){
            text-align:right;
        }
    </style>
    <script>
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#var1').html('<%=listamenu%>');
            //$('#nomusr').text('<%=minombre%>');
            $('#txctenom').text($('#nombre').val());
            cargainmueble();
            cargapuesto();
            cargaturno();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#btagrega').on('click', function () {
                if ($('#dlinmueble').val() == 0) {
                    alert('Primero debe seleccionar un Punto de atención')
                } else {
                    if (validaplantilla()) {
                        var xmlgraba = '<plantilla id="' + $('#idpla').val()  + '" idinm= "' + $('#dlinmueble').val() + '" puesto ="' + $('#dlpuesto').val() + '" cantidad = "' + $('#txcant').val() + '" turno = "' + $('#dlturno').val() + '" ';
                        xmlgraba += ' jornal= "' + $('#txjornal').val() + '" smntope= "' + $('#txsalario').val() + '" cargas= "' + $('#txcarga').val() + '" ';
                        xmlgraba += 'uniforme="' + $('#txuniforme').val() + '" formapago="' + $('#dlforma').val() + '" sexo="' + $('#dlsexo').val() + '"/>';
                        //alert(xmlgraba);
                        PageMethods.guarda(xmlgraba, function (res) {   
                            plantillas()
                        }, iferror);
                        limpia();
                    }
                }
            })
            $('#btactualiza').click(function () {
                //if (validaplantilla()) {
                var xmlgraba1 = '<horario id= "' + $('#idplantilla').val()  +'" edadde= "' + $('#txedadde').val() + '" edada ="' + $('#txedada').val() + '" horariode = "' + $('#txhorariode').val() + '" horarioa = "' + $('#txhorarioa').val() + '" ';
                xmlgraba1 += ' diasde= "' + $('#txdiaslabde').val() + '" diasa= "' + $('#txdiaslaba').val() + '" horariofs = "' + $('#txfinsemana').val() + '"'
                xmlgraba1 += ' descanso = "' + $('#txdescanso').val() + '"/>';
                PageMethods.guardahorario(xmlgraba1, function () {
                    alert('Los horarios se han actualizado correctamente');
                    dialog.dialog('close');
                }, iferror);
                //}
            })
        });
        function plantillas() {
            PageMethods.plantillas($('#dlinmueble').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbplantilla tbody').remove();
                $('#tbplantilla').append(ren);
                $('#tbplantilla tbody tr').on('click', '.bthorario', function () {
                    $('#idplantilla').val($(this).closest('tr').find('td').eq(0).text());
                    PageMethods.horarios(parseInt($(this).closest('tr').find('td').eq(0).text()), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txedadde').val(datos.edadde);
                        $('#txedada').val(datos.edada);
                        $('#txhorariode').val(datos.horariode);
                        $('#txhorarioa').val(datos.horarioa);
                        $('#txdiaslabde').val(datos.diade);
                        $('#txdiaslaba').val(datos.diaa);
                        $('#txdescanso').val(datos.diadescanso);
                        $('#txfinsemana').val(datos.horariofs);
                    }, iferror);
                    $("#divmodal").dialog('option', 'title', 'Definir horarios de servicio');
                    dialog.dialog('open');
                });
                $('#tbplantilla tbody tr').on('click', '.btborra', function () {
                    //alert($(this).closest('tr').find('td').eq(0).text());
                    PageMethods.elimina(parseInt($(this).closest('tr').find('td').eq(0).text()), function () {
                        plantillas();
                    }, iferror);
                });
                $('#tbplantilla tbody tr').on('click', '.btmodifica', function () {
                    //alert($(this).closest('tr').find('td').eq(0).text());
                    $('#idpla').val($(this).closest('tr').find('td').eq(0).text())
                    $('#txcant').val($(this).closest('tr').find('td').eq(2).text())
                    $('#txjornal').val($(this).closest('tr').find('td').eq(4).text())
                    $('#txsalario').val($(this).closest('tr').find('td').eq(5).text())
                    $('#txcarga').val($(this).closest('tr').find('td').eq(6).text())
                    $('#txuniforme').val($(this).closest('tr').find('td').eq(7).text())
                    PageMethods.detalleplantilla(parseInt($(this).closest('tr').find('td').eq(0).text()), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#dlpuesto').val(datos.id_puesto);
                        $('#dlturno').val(datos.id_turno);
                        $('#dlforma').val(datos.formapago);
                        $('#dlsexo').val(datos.sexo);
                    }, iferror);
                });
            });
        };
        function limpia() {
            $('#idpla').val(0);
            $('#txcant').val('');
            $('#txjornal').val('');
            $('#txsalario').val('');
            $('#txcarga').val('');
            $('#txuniforme').val('');
            $('#dlpuesto').val(0);
            $('#dlturno').val(0);
            $('#dlforma').val(0);
            $('#dlsexo').val(0);
        }
        function validaplantilla() {
            if ($('#dlpuesto').val() == 0) {
                alert('Debe seleccionar un puesto');
                return false
            }
            if ($('#txcant').val() == '') {
                alert('Debe capturar la cantidad de personas');
                return false
            }
            if ($('#dlturno').val() == 0) {
                alert('Debe seleccionar un turno');
                return false
            }
            if ($('#txjornal').val() == '') {
                alert('Debe colocar un Jornal');
                return false
            }
            if ($('#txsalario').val() == '') {
                alert('Debe colocar el Salario tope Mensual');
                return false
            }
            return true 
        }
        function cargainmueble() {
            PageMethods.inmueble($('#idcte').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlinmueble').append(inicial);
                $('#dlinmueble').append(lista);
                $('#dlinmueble').val(0);
                $('#dlinmueble').on('click', function () {
                    plantillas();
                })
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
                $('#dlpuesto').val(0);
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
        <asp:HiddenField ID="idcte" runat="server" Value="0" />
        <asp:HiddenField ID="nombre" runat="server" />
        <asp:HiddenField ID="idpla" runat="server" />
        <div class="content">
            <div class="content-header">
                <h1>Plantillas: <span id="txctenom"></span></h1>
            </div>
            <div class="row" id="tbdatosinm">
                <div class="col-md-14">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class=" box-header">
                        </div>
                        <!-- /.box-header -->
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dlinmueble">Punto de Atención:</label>
                            </div>
                            <div class="col-lg-3">
                                <select id="dlinmueble" class="form-control"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class=" col-md-12 tbheader table-responsive">
                    <table id="tbplantilla" class="table">
                        <thead>
                            <tr>
                                <th class="bg-navy h6"><span>Puesto</span></th>
                                <th class="bg-navy h6"><span>Cantidad</span></th>
                                <th class="bg-navy h6"><span>Turno</span></th>
                                <th class="bg-navy h6"><span>Jornal</span></th>
                                <th class="bg-navy h6"><span>Salario</span></th>
                                <th class="bg-navy h6"><span>Carga S</span></th>
                                <th class="bg-navy h6"><span>Uniforme</span></th>
                                <th class="bg-navy h6"><span>Forma Pago</span></th>
                                <th class="bg-navy h6"><span>Sexo</span></th>
                            </tr>
                            <tr>
                                <th class="col-lg-2">
                                    <select id="dlpuesto" class="form-control h6"></select>
                                </th>
                                <th class="col-lg-1">
                                    <input id="txcant" class="form-control h6" />
                                </th>
                                <th class="col-lg-1">
                                    <select id="dlturno" class="form-control h6"></select>
                                </th>
                                <th class="col-lg-1">
                                    <input id="txjornal" class="form-control text-right h6" />
                                </th>
                                <th class="col-lg-1">
                                    <input id="txsalario" class="form-control text-right h6" />
                                </th>
                                <th class="col-lg-1">
                                    <input id="txcarga" class="form-control text-right h6" />
                                </th>
                                <th class="col-lg-1">
                                    <input id="txuniforme" class="form-control text-right h6" />
                                </th>
                                <th class="col-lg-1">
                                    <select id="dlforma" class="form-control h6">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Quincenal</option>
                                        <option value="2">Semanal</option>
                                    </select>
                                </th>
                                <th class="col-lg-2">
                                    <select id="dlsexo" class="form-control h6">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Masculino</option>
                                        <option value="2">Femenino</option>
                                        <option value="3">Indistinto</option>
                                    </select>
                                </th>
                                <th class="col-lg-1">
                                    <input id="btagrega" type="button" class="btn btn-primary " value="Agregar" />
                                </th>
                            </tr>
                        </thead>
                        <tbody class="box"></tbody>
                    </table>
                    <ol class="breadcrumb">
                        <li id="btsalir" class="puntero" onclick="self.close();"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                    </ol>
                </div>
            </div>
        </div>
        <div id="divmodal" class="col-md-12">
            <asp:HiddenField ID="idplantilla" runat="server" Value="0" />
            <div class="row">
                <div class="col-lg-3">
                    <label for="txedadde">Edad:</label>
                </div>
                <div class="col-lg-2">
                    <input type="text" id="txedadde" class="form-control" placeholder="De" title="Edad desde" />
                </div>
                <div class="col-lg-2">
                    <input type="text" id="txedada" class="form-control" placeholder="a" title="Edad hasta" />
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3">
                    <label for="txhorariode">Horario:</label>
                </div>
                <div class="col-lg-2">
                    <input type="text" id="txhorariode" class="form-control" placeholder="inicia" title="Hora de entrada" />
                </div>
                <div class="col-lg-2">
                    <input type="text" id="txhorarioa" class="form-control" placeholder="termina" title="Hora de salida" />
                </div>
                <div class="col-lg-3">
                    <input type="text" id="txfinsemana" class="form-control" placeholder="fin de semana" title="Horario fin de semana" />
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3">
                    <label for="txentrada">Dias a laborar:</label>
                </div>
                <div class="col-lg-3">
                    <input type="text" id="txdiaslabde" class="form-control" placeholder="De" title="dia laboral de" />
                </div>
                <div class="col-lg-3">
                    <input type="text" id="txdiaslaba" class="form-control" placeholder="A" title="dia laboral a" />
                </div>
                <div class="col-lg-3">
                    <input type="text" id="txdescanso" class="form-control" placeholder="Descansa" title="dias de descanso" />
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <button type="button" id="btactualiza" value="Actualizar" class="btn btn-info pull-right">Actualizar</button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
