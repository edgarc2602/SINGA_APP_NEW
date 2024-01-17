<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Empleado_Transfiere.aspx.vb" Inherits="App_RH_RH_Pro_Empleado_Transfiere" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Baja de Empleados</title>
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
        #tblista tbody td:nth-child(9){
            width:0px;
            display:none;
        }
        #tblista1 tbody td:nth-child(11),#tblista1 tbody td:nth-child(12),#tblista1 tbody td:nth-child(13){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvconfirma').hide();
            $('#dvaplicar').hide();
            $('#dvvacante').hide();
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
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 550,
                width: 1020,
                modal: true,
                close: function () {
                }
            });
            cargacliente()
            $('#dlsucursal').append(inicial);
            $('#btmostrar').click(function () {
                if ($('#dlsucursal').val() != 0) {
                    cargalista();
                } else {
                    alert('Debe elegir un punto de atención');
                }
            })
            /*$('#btguarda').click(function () {
                if (valida()) {
                    
                    var ubicacion = '';
                    var horario = '';
                    var pvac = 0;
                    if ($('#cbvacante').is(':checked')) {
                        pvac = 1;
                        PageMethods.datosextra($('#dlsucursal1').val(), $('#idpuesto').val(), $('#idturno').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            ubicacion = datos.ubicacion;
                            horario = datos.horario;
                            var fini = $('#txfecha').val().split('/');
                            var finicio = fini[2] + fini[1] + fini[0];

                            var xmlgraba = '<vacante id="0" tipo ="' + $('#dltipo').val() + '" cliente = "' + $('#dlcliente').val() + '" inmueble= "' + $('#dlsucursal').val() + '" ubicacion ="1" puesto = "' + $('#idpuesto').val() + '" turno = "' + $('#idturno').val() + '" ';
                            xmlgraba += ' experiencia= "' + $('#txexperiencia').val() + '" observacion= "' + $('#txobservacion').val() + '" usuario="' + $('#idusuario').val() + '" ';
                            xmlgraba += ' idemp = "' + $('#txidemp').val() + '" ftrans = "' + finicio + '" coordina = "' + $('#idcoordina').val() + '" inmueblea = "' + $('#dlsucursal1').val() + '"';
                            xmlgraba += ' aplicav = "' + pvac + '" /> ';

                            var f = new Date();
                            var mm = f.getMonth() + 1
                            if (mm.toString.length == 1) {
                                mm = "0" + mm
                            }
                            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                            PageMethods.guarda(xmlgraba, fecha, $('#dlcliente option:selected').text(), $('#txpuesto').val(), $('#dlsucursal option:selected').text(), ubicacion, horario, $('#idusuario').val(), $('#dlsucursal1 option:selected').text(), $('#txnombre').val(), $('#txrfc').val(), $('#txcurp').val(), $('#txss').val(), pvac, $('#idgerente').val(), function () { //$('#txfecha').val(), $('#txidemp').val(),
                                alert('Registro completado.');
                            }, iferror);
                        }, iferror);
                    } else {

                        var fini = $('#txfecha').val().split('/');
                        var finicio = fini[2] + fini[1] + fini[0];

                        var xmlgraba = '<vacante id="0" tipo ="0" cliente = "' + $('#dlcliente').val() + '" inmueble= "' + $('#dlsucursal').val() + '" ubicacion ="0" puesto = "' + $('#idpuesto').val() + '" turno = "' + $('#idturno').val() + '" ';
                        xmlgraba += ' experiencia= "" observacion= "" usuario="' + $('#idusuario').val() + '" ';
                        xmlgraba += ' idemp = "' + $('#txidemp').val() + '" ftrans = "' + finicio + '" coordina = "' + $('#idcoordina').val() + '" inmueblea = "' + $('#dlsucursal1').val() + '"';
                        xmlgraba += ' aplicav = "' + pvac + '" /> ';

                        var f = new Date();
                        var mm = f.getMonth() + 1
                        if (mm.toString.length == 1) {
                            mm = "0" + mm
                        }
                        var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                        alert('PORAQUI');
                        PageMethods.guarda(xmlgraba, fecha, $('#dlcliente option:selected').text(), $('#txpuesto').val(), $('#dlsucursal option:selected').text(), ubicacion, horario, $('#idusuario').val(), $('#dlsucursal1 option:selected').text(), $('#txnombre').val(), $('#txrfc').val(), $('#txcurp').val(), $('#txss').val(), pvac, $('#idgerente').val(), function () { //$('#txfecha').val(), $('#txidemp').val(),
                            alert('Registro completado.');
                        }, iferror);
                    }
                }
            })*/
            $('#btlista').click(function () {
                $('#tblista').show();
                $('#dvdatos').hide();
                cargalista()
                limpia();
            })
            $('#cbvacante').click(function () {
                if ($('#cbvacante').is(':checked')) {
                    $('#dvvacante').show();
                } else {
                    $('#dvvacante').hide();
                }
            })
            $('#btactualiza').click(function () {
                if (valida()) {
                    if ($('#cliente').val() != $('#cliente1').val()) {
                        PageMethods.validacliente($('#dlcliente').val(), $('#dlcliente1').val(), function (detalle) {
                            var datos = eval('(' + detalle + ')');
                            if (datos.paso == 1) {
                                alert('No se puede aplicar transferencia entre los clientes seleccionados ya que manejan empresas pagadoras diferentes, para poder transferir al personal debera aplicar el proceso de baja y alta y firmar contrato nuevo');
                            } else {
                                ejecutatrans()
                            }
                        })
                    } else {
                        ejecutatrans()
                    }
                }
            })
        });
        function ejecutatrans() {
            var xmlgraba = '<transfiere plantilla= "' + $('#idplantilla').val() + '" cliente ="' + $('#cliente1').val() + '" sucursal= "' + $('#idsucursal1').val() + '" puesto= "' + $('#idpuesto').val() + '" turno ="' + $('#idturno').val() + '" jornal = "' + parseInt($('#jornal').val()) + '" pago = "' + $('#pago').val() + '" ';
            xmlgraba += ' sueldo= "' + $('#sueldo').val() + '" idemp = "' + $('#txidemp').val() + '" usuario = "' + $('#idusuario').val() + '" inmuebleo = "' + $('#dlsucursal').val() + '" />';
            //xmlgraba += ' idemp = "' + $('#txidemp').val() + '" ftrans = "' + finicio + '" coordina = "' + $('#idcoordina').val() + '" inmueblea = "' + $('#dlsucursal1').val() + '"';
            //xmlgraba += ' aplicav = "' + pvac + '" /> ';
            var f = new Date();
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();

            //alert(xmlgraba);
            //alert($('#idgerente').val());
            PageMethods.guarda(xmlgraba, fecha, $('#lbemp').val() + ' ' + $('#lbnombre').val(), $('#lbtransfierede').val(), $('#lbtransfierea').val(), $('#idusuario').val(), $('#idgerente').val(), function () { //$('#txfecha').val(), $('#txidemp').val(),
                //closeWaitingDialog();
                //$('#txid').val(res)
                alert('Registro completado.');
                dialog.dialog('close');
                cargalista();
                limpia();
                $('#tblista').show();
                $('#dvdatos').hide();
                
            }, iferror);
            
        }
        function cargaestructura() {
            PageMethods.estructura($('#dlsucursal1').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista1 table tbody').remove();
                $('#tblista1 table').append(ren);
                $('#tblista1 tbody tr').on('click', function () {
                    if (parseInt($(this).children().eq(9).text()) > 0) {
                        $('#idplantilla').val($(this).children().eq(0).text())
                        $('#cliente1').val($('#dlcliente1').val())
                        $('#idsucursal1').val($('#dlsucursal1').val())
                        $('#idpuesto').val($(this).children().eq(10).text())
                        $('#idturno').val($(this).children().eq(11).text())
                        $('#jornal').val($(this).children().eq(3).text())
                        $('#pago').val($(this).children().eq(12).text())
                        $('#sueldo').val($(this).children().eq(6).text())

                        var transde = $('#dlcliente option:selected').text() + ', ' + $('#dlsucursal option:selected').text() + ', ' + $('#txpuesto').val() + ', ' + $('#txturno').val() + ', jornal: ' + $('#txjornal').val() + ', ' + $('#txforma').val() + ', ' + $('#txsueldo').val()
                        var transa = $('#dlcliente1 option:selected').text() + ', ' + $('#dlsucursal1 option:selected').text() + ', ' + $(this).children().eq(1).text() + ', ' + $(this).children().eq(2).text() + ', jornal: ' + $(this).children().eq(3).text() + ', ' + $(this).children().eq(4).text() + ', ' + $(this).children().eq(6).text()
                        $('#lbemp').val($('#txidemp').val());
                        $('#lbnombre').val($('#txnombre').val());
                        $('#lbtransfierede').val(transde);
                        $('#lbtransfierea').text(transa);
                        $("#divmodal").dialog('option', 'title', 'Aplicar transferencia');
                        dialog.dialog('open');

                    } else { alert('Esta plantilla no tiene espacios disponibles para aplicar la transferencia, debe aplicar bajas o bien revisar su plantilla con el área de ventas') }
                    
                });
            }, iferror);
        }
        function limpia() {
            $('#dlcliente1').val(0)
            $('#dlsucursal1').empty();
            $('#tblista1 table tbody').remove();
        } 
        function valida() {
            
            if ($('#dlcliente1').val() == 0) {
                alert('Debe seleccionar el Cliente destino');
                return false;
            }
            if ($('#dlsucursal1').val() == 0) {
                alert('Debe seleccionar el Punto de atención destino');
                return false;
            }
            return true 
        }
        function cargacliente() {
            PageMethods.cliente( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    $('#tblista table tbody').remove();
                    cargainmueble($('#dlcliente').val());
                });
                $('#dlcliente1').append(inicial);
                $('#dlcliente1').append(lista);
                $('#dlcliente1').change(function () {
                    $('#tblista1 table tbody').remove();
                    cargainmueble1($('#dlcliente1').val());
                    cargaempleado($('#dlcliente1').val());
                });
            }, iferror);
        }
        function cargaempleado(cte) {
            PageMethods.empleado(cte, function (detalle) {
                var datos = eval('(' + detalle + ')');
                //$('#txgerente').val(datos.nombre);
                //$('#txcoordina').val(datos.coordina);
                $('#idcoordina').val(datos.idcoordina)
                $('#idgerente').val(datos.idgerente)
            }, iferror);

        };
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
                
            }, iferror);
        }
        function cargainmueble1(idcte) {
            PageMethods.inmueble(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal1').empty();
                $('#dlsucursal1').append(inicial);
                $('#dlsucursal1').append(lista);
                if ($('#idsucursal1').val() != 0) {
                    $('#dlsucursal1').val($('#idsucursal1').val());
                }
                $('#dlsucursal1').change(function () {
                    cargaestructura();
                    //cargadatosinm($('#dlsucursal').val());
                });
            }, iferror);
        }
        function cargalista() {
            PageMethods.empleados($('#dlsucursal').val(), $('#txnombrebusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista tbody tr').on('click', function () {
                    $('#txidemp').val($(this).children().eq(0).text());
                    $('#txnombre').val($(this).children().eq(1).text());
                    $('#txpuesto').val($(this).children().eq(2).text());
                    $('#txturno').val($(this).children().eq(3).text());
                    $('#txjornal').val($(this).children().eq(4).text());
                    $('#txforma').val($(this).children().eq(5).text());
                    $('#txsueldo').val($(this).children().eq(6).text());
                    //$('#txss').val($(this).children().eq(4).text());
                    
                    //$('#idpuesto').val($(this).children().eq(8).text());
                    //$('#idturno').val($(this).children().eq(9).text());
                    //$('#txactual').val($(this).children().eq(8).text());
                    $('#idvacante').val($(this).children().eq(9).text());
                    if ($(this).children().eq(10).text() != 0) {
                        $('#dlcliente1').val($(this).children().eq(10).text());
                        $('#idsucursal1').val($(this).children().eq(11).text());
                        cargainmueble1($('#dlcliente1').val());
                        
                        $('#txfecha').val($(this).children().eq(12).text());
                        bloquea();
                        $('#dvaplicar').show();
                    } else {
                        nobloquea();
                        $('#dvaplicar').hide();
                    }
                    $('#tblista').hide();
                    $('#dvdatos').show();
                });
            }, iferror);
        }
        function bloquea() {
            $('#dlcliente1').prop("disabled", true);
            $('#dlsucursal1').prop("disabled", true);
            $('#txfecha').prop("disabled", true);
            
        }
        function nobloquea() {
            $('#dlcliente1').prop("disabled", false);
            $('#dlsucursal1').prop("disabled", false);
            $('#txfecha').prop("disabled", false);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
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
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idplantilla" runat="server" />
        <asp:HiddenField ID="cliente1" runat="server" />
        <asp:HiddenField ID="idsucursal1" runat="server" />
        <asp:HiddenField ID="idpuesto" runat="server" />
        <asp:HiddenField ID="idturno" runat="server" />
        <asp:HiddenField ID="jornal" runat="server" />
        <asp:HiddenField ID="pago" runat="server" />
        <asp:HiddenField ID="sueldo" runat="server" />
        <asp:HiddenField ID="idgerente" runat="server" />
        <asp:HiddenField ID="idcoordina" runat="server" />

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
                    <h1>Transferencia de Empleado<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos humanos</a></li>
                        <li class="active">Transferencia de Empleado</li>
                    </ol>
                </div>
                <div class="content">

                    <div class="box box-info">
                        <!-- Horizontal Form -->
                        <div class="box-header">
                            <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dlcliente">Cliente:</label>
                            </div>
                            <div class="col-lg-3">
                                <select id="dlcliente" class="form-control"></select>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="dlsucursal">Punto de atención:</label>
                            </div>
                            <div class="col-lg-4">
                                <select id="dlsucursal" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txnombrebusca">Nombre:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txnombrebusca" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="Mostrar" id="btmostrar" />
                            </div>
                        </div>
                        <hr />
                        <div id="dvdatos">
                            <div class="row">
                                <!-- /.box-header -->
                                <div class="col-lg-1 text-right">
                                    <label for="txidemp">No. Empleado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txidemp" class="form-control" disabled="disabled" value="0" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txnombre" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <!--
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrfc">RFC:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txrfc" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txcurp">CURP:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcurp" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txss">No. SS:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txss" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                -->
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txpuesto">Puesto:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txturno">Turno:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txturno" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txjornal">Jornal:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txjornal" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txforma">Pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txforma" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txsueldo">Sueldo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txsueldo" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txid">Transferir a:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente1" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal1">Punto de atención:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsucursal1" class="form-control">
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-18 tbheader" id="tblista1" style="height: 200px; overflow-y: scroll">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Plantilla</span></th>
                                            <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                            <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                            <th class="bg-light-blue-gradient"><span>Pago</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sexo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Pago mensual</span></th>
                                            <th class="bg-light-blue-gradient"><span>Autorizados</span></th>
                                            <th class="bg-light-blue-gradient"><span>Activos</span></th>
                                            <th class="bg-light-blue-gradient"><span>Disponibles</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <!--
                                <div class="row">
                                        <div class="col-lg-2 text-right">
                                            <label for="txgerente">Gerente OP:</label>
                                        </div>
                                        <div class="col-lg-3">
                                            <input type="text" id="txgerente" class="form-control" disabled="disabled" />
                                        </div>
                                        <div class="col-lg-2 text-right">
                                            <label for="txcoordina">Coordinador RH:</label>
                                        </div>
                                        <div class="col-lg-3">
                                            <input type="text" id="txcoordina" class="form-control" disabled="disabled" />
                                        </div>
                                    </div>
                                 <div class="row" >
                                    <div class="col-lg-8">
                                        <input type="checkbox" id="cbvacante" style="margin-left:200px; width:20px; height:20px;"/><label for="cbvacante">La transferencia generea vacante</label>
                                    </div>
                                </div>
                                -->
                            <div class="row" id="dvvacante">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo de movimiento:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Urgente</option>
                                            <option value="2">Programada</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txexperiencia">Experiencia laboral:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <textarea id="txexperiencia" class="form-control"></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txobservacion">Observaciones:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <input type="text" id="txobservacion" class="form-control" />
                                    </div>
                                </div>

                            </div>
                            <!--
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txfecha">Fecha de transferencia:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecha" class="form-control" />
                                    </div>
                                </div>
                                -->
                            <!--<hr />
                                <div class="row" id="dvaplicar">
                                    <div class="col-lg-8">
                                        <input type="checkbox" id="cbconfirma" style="margin-left:200px; width:20px; height:20px;"/><label for="cbconfirma">Confirmar y aplicar transferencia</label>
                                    </div>
                                </div>-->
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                <li id="btsalir1" class="puntero" onclick="history.back();"><a><i class="fa fa-edit"></i>Salir</a></li>
                                <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Clientes</a></li>-->
                            </ol>
                        </div>

                    </div>
                    <div class="col-md-18 tbheader" id="tblista">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>No. Empleado</span></th>
                                    <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                    <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                    <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                    <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                    <th class="bg-light-blue-gradient"><span>Pago</span></th>
                                    <th class="bg-light-blue-gradient"><span>Sueldo</span></th>
                                    <th class="bg-light-blue-gradient"><span>Estatus</span></th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <div id="divmodal">
                        <div class="row">
                            <div class="col-lg-2">
                                <label>No. Emp:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" class="form-control" id="lbemp" disabled="disabled"/>
                                
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2">
                                <label>Nombre:</label>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" class="form-control" id="lbnombre" disabled="disabled"/>
                            </div>
                        </div>
                        <hr/>
                        <div class="row">
                            <div class="col-lg-2">
                                <label>Se transfiere de:</label>
                            </div>
                            <div class="col-lg-6">
                                <textarea id="lbtransfierede" class="form-control" disabled="disabled" rows="5"></textarea>
                            </div>
                        </div>
                        <br/>
                        <div class="row">
                            <div class="col-lg-2">
                                <label>Hacia:</label>
                            </div>
                            <div class="col-lg-6">
                                <textarea id="lbtransfierea" class="form-control" disabled="disabled" rows="5"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <button type="button" id="btactualiza" value="Continuar" class="btn btn-info">Continuar</button>
                            </div>
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
