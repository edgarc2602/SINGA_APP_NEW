    <%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Pro_Vacante.aspx.vb" Inherits="App_RH_RH_Pro_Vacante" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE VACANTES</title>
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
    <style>
        
        #tblista tbody td:nth-child(13),#tblista tbody td:nth-child(14){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
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
            cargaestado();
            if ($('#idvacante').val() != '') {
                $('#txid').val($('#idvacante').val());
                PageMethods.vacante($('#txid').val(), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#dltipo').val(datos.tipo);
                    $('#txnombre').val(datos.puntoatn);
                    $('#dltipo').val(datos.tipo);
                    $('#idcliente').val(datos.cliente);
                    PageMethods.empleadoop(parseInt($('#idusuario').val()), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#idempleado').val(datos.id);
                        cargacliente();
                    });
                    $('#idinmueble').val(datos.inmueble)
                    cargainmueble(datos.cliente);
                    $('#idpuesto').val(datos.puesto);
                    cargapuesto(datos.inmueble);
                    $('#idturno').val(datos.turno);
                    cargaturno(datos.puesto, datos.inmueble);
                    $('#txcalle').val(datos.direccion);
                    $('#txcolonia').val(datos.colonia);
                    $('#txdelmun').val(datos.delmun);
                    $('#idestado').val(datos.estado);
                    cargaestado();
                    $('#txcp').val(datos.cp);
                    $('#dlubicacion').val(datos.ubicacion);
                    $('#txgerente').val(datos.operativo);
                    $('#txcoordina').val(datos.coordina);
                    $('#txpago').val(datos.sueldo);
                    $('#dlpago').val(datos.formapago);
                    $('#dlsexo').val(datos.sexo);
                    $('#txedad1').val(datos.edadde);
                    $('#txedad2').val(datos.edada);
                    $('#txentrada').val(datos.horariode);
                    $('#txsalida').val(datos.horarioa);
                    //$('#txhoras').val(datos.jornal);
                    $('#txdiaslabde').val(datos.diasde);
                    $('#txdiaslaba').val(datos.diasa);
                    $('#txdescanso').val(datos.diasdes);
                    $('#txobservacion').val(datos.observacion);
                    $('#idpuesto').val(datos.puesto);
                    $('#txexperiencia').val(datos.experiencia);
                    
                }, iferror);
            } else {
                PageMethods.empleadoop(parseInt($('#idusuario').val()), function (detalle) {
                    var datos = eval('(' + detalle + ')');
                    $('#idempleado').val(datos.id);
                    cargacliente();
                });
            }
            $('#btnuevo').click(function () {
                location.reload();
                /*limpia();
                limpiainm();
                limpiapuesto();*/
            })
            $('#btguarda').on('click', function () {
                if (valida()) {
                    var cant = $('#txcantidad').val();
                    for (i = 0; i < cant; i++) {
                        waitingDialog({});
                        var ubicacion = 1;
                        if ($('#dlestado').val() != 7) {
                            ubicacion = 2
                        }
                        var xmlgraba = '<vacante id= "' + $('#txid').val() + '" tipo = "1" cliente = "' + $('#dlcliente').val() + '" inmueble= "' + $('#dlsucursal').val() + '" ubicacion ="' + ubicacion + '" puesto = "' + $('#idpuesto').val() + '" turno = "' + $('#idturno').val() + '" ';
                        xmlgraba += ' experiencia= "' + $('#txexperiencia').val() + '" observacion= "' + $('#txobservacion').val() + '" usuario="' + $('#idusuario').val() + '"';
                        xmlgraba += ' idemp="0" coordina=" ' + $('#idcoordina').val() + '" vacantesi="1" plantilla= "' + $('#idplantilla').val() + '" />'
                        var f = new Date();
                        var mm = f.getMonth() + 1
                        if (mm.toString.length == 1) {
                            mm = "0" + mm
                        }
                        var fecha = f.getDate() + "/" + mm + "/" + f.getFullYear();
                        var ubicacion = $('#txcalle').val() + ' ' + $('#txcolonia').val() + ' ' + $('#txdelmun').val() + ' ' + $('#dlestado option:selected').text();
                        var horario = $('#txturno').val() + ', Entrada: ' + $('#txentrada').val() + ' Salida: ' + $('#txsalida').val() + ' Jornal: ' + $('#txhoras').val() + ' De: ' + $('#txdiaslabde').val() + ' A: ' + $('#txdiaslaba').val();
                        //alert(xmlgraba);
                        PageMethods.guarda(xmlgraba, fecha, $('#dlcliente option:selected').text(), $('#txpuesto').val(), $('#dlsucursal option:selected').text(), ubicacion, horario, $('#dlcliente').val(), function (res) {
                            closeWaitingDialog();
                            $('#txid').val(res)
                            alert('Registro completado.');
                        }, iferror);
                        
                    }
                }
            })
            $('#btlista').click(function () {
                $('#dvvacante').hide();
                $('#tblista').show();
            })
        });
        function valida() {
            if ($('#txid').val() != 0) {
                alert('La vacante ya fue creada y enviada, debe hacer clic en Nuevo para generar mas vacantes');
                return false;
            }
            if ($('#txcantidad').val() == '') {
                $('#txcantidad').val(0);
            }
            if ($('#txcantidad').val() == 0) {
                alert('Debe colocar la cantidad de vacantes a generar');
                return false;
            }
            if (isNaN($('#txcantidad').val())) {
                alert('Solo puede colocar numeros en Cantidad de vacantes a generar');
                return false;
            }
            if ($('#idplantilla').val() == 0) {
                alert('Antes de registrar vacante debe seleccionar una Plantilla');
                return false;
            }
            if (parseInt($('#txcantidad').val()) > parseInt($('#disponible').val())) {
                alert('No puede generar mas vacantes de las posiciones disponibles');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe seleccionar el tipo de movimiento');
                return false;
            }
            if ($('#dlcliente').val() == 0) {
                alert('Debe seleccionar el nombre del Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe seleccionar el Punto de Atención');
                return false;
            }
            if ($('#dlubicacion').val() == 0) {
                alert('Debe seleccionar la ubicación');
                return false;
            }
            if ($('#dlpuesto').val() == 0) {
                alert('Debe seleccionar el puesto');
                return false;
            }
            if ($('#dlturno').val() == 0) {
                alert('Debe seleccionar el turno');
                return false;
            }
            return true;
        }
        function cargacliente() {
            PageMethods.cliente($('#idempleado').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
/*                if ($('#idcliente').val() != '') {
                    $('#dlcliente').val($('#idcliente').val());
                };*/
                $('#dlcliente').change(function () {
                    limpiainm();
                    limpiapuesto();
                    if ($('#dlcliente').val() != 136) {
                        cargainmueble($('#dlcliente').val());
                        cargaempleado($('#dlcliente').val());
                    } else {
                        if ($('#idusuario').val() == 189 || $('#idusuario').val() == 1) {
                            cargainmueble($('#dlcliente').val());
                            cargaempleado($('#dlcliente').val());
                        }
                        else { alert('Usted no esta autorizado para registrar vacantes de este cliente');}
                    }
                });
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
                /*if ($('#idinmueble').val() != '') {
                    $('#dlsucursal').val($('#idinmueble').val());
                } else {
                    $('#dlsucursal').val(0);
                };*/
                $('#dlsucursal').change(function () {
                    cargaestructura();
                    cargadatosinm($('#dlsucursal').val());
                });
            }, iferror);
        }
        function cargaestructura() {
            PageMethods.estructura($('#dlsucursal').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista table tbody').remove();
                $('#tblista table').append(ren);
                $('#tblista table tbody tr').on('click', function () {
                    if (parseInt($(this).children().eq(11).text()) > 0) {
                        $('#txpuesto').val($(this).children().eq(1).text());
                        $('#txturno').val($(this).children().eq(2).text());
                        $('#txpago').val($(this).children().eq(7).text());
                        $('#txforma').val($(this).children().eq(4).text());
                        //$('#txtipon').val($(this).children().eq(5).text());
                        $('#txsexo').val($(this).children().eq(6).text());
                        $('#txjornal').val($(this).children().eq(3).text());
                        $('#idplantilla').val($(this).children().eq(0).text());
                        $('#idpuesto').val($(this).children().eq(12).text());
                        $('#idturno').val($(this).children().eq(13).text());
                        $('#disponible').val($(this).children().eq(11).text());
                        cargaplantilla($(this).children().eq(0).text())
                        $('#dvvacante').toggle('slide', { direction: 'down' }, 500);
                        $('#tblista').hide();
                    } else {
                        alert('Esta plantilla no tiene espacios disponibles para generar vacantes, debe aplicar bajas o cancelar vacantes existentes o bien revisar su plantilla con el área de ventas')
                    }
                    
                });
            }, iferror);
        }
        function cargadatosinm(suc) {
            PageMethods.datosinm(suc, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txcalle').val(datos.direccion);
                $('#txcolonia').val(datos.colonia);
                $('#txdelmun').val(datos.delegacion);
                $('#dlestado').val(datos.estado);
                $('#txcp').val(datos.cp);
            });
        }
        function limpia() {
            $('#idpuesto').val('')
            $('#idturno').val('')
            $('#idcliente').val('')
            $('#idsucursal').val('')
            $('#idvacante').val('')
            $('#txid').val(0);
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#dltipo').val(0);
            $('#dlubicacion').val(0);
            $('#txobservacion').val('');
            $('#txexperiencia').val('');
            $('#txcantidad').val(1);
            $('#txgerente').val('');
            $('#txcoordina').val('');
            $('#tblista table tbody').remove();
        }
        function limpiainm() {
            $('#txcalle').val('');
            $('#txcolonia').val('');
            $('#txdelmun').val('');
            $('#dlestado').val('');
            $('#txcp').val('');
        }
        function cargapuesto(suc) {
            PageMethods.puesto(suc, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlpuesto').empty();
                $('#dlpuesto').append(inicial);
                $('#dlpuesto').append(lista);
                if ($('#idpuesto').val() != '') {
                    $('#dlpuesto').val($('#idpuesto').val());
                } else { $('#dlpuesto').val(0) };
                $('#dlpuesto').change(function () {
                    cargaturno($('#dlpuesto').val(), $('#dlsucursal').val());
                });
            }, iferror);
        }
        function limpiapuesto() {
            $('#txpuesto').val('');
            $('#txturno').val('');
            $('#txjornal').val('');
            $('#txpago').val('');
            $('#txforma').val('');
            $('#txsexo').val('');
            $('#txedad1').val('');
            $('#txedad2').val('');
            $('#txentrada').val('');
            $('#txsalida').val('');
            $('#txhoras').val('');
            $('#txdiaslabde').val('');
            $('#txdiaslaba').val('');
            $('#txdescanso').val('');
            $('#txfins').val('');
        }
        function cargaempleado(cte) {
            PageMethods.empleado(cte, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txgerente').val(datos.nombre);
                $('#txcoordina').val(datos.coordina);
                $('#idcoordina').val(datos.idcoordina)
            }, iferror);
        };
        
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
            }, iferror);
        }
        function cargaturno(puesto, suc) {
            PageMethods.turno(puesto, suc, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlturno').empty();
                $('#dlturno').append(inicial);
                $('#dlturno').append(lista);
                if ($('#idturno').val() != '') {
                    $('#dlturno').val($('#idturno').val());
                } 
                $('#dlturno').change(function () {
                    //cargaplantilla($('#dlpuesto').val(), $('#dlsucursal').val(), $('#dlturno').val());
                });
            }, iferror);
        }
        function cargaplantilla(plantilla) {
            PageMethods.datosplantilla(plantilla, function (detalle) {
                var datos = eval('(' + detalle + ')');
                /*$('#txpago').val(datos.sueldo);
                $('#dlpago').val(datos.formap);
                $('#dlsexo').val(datos.sexo);*/
                $('#txedad1').val(datos.edadde);
                $('#txedad2').val(datos.edada);
                $('#txentrada').val(datos.horariode);
                $('#txsalida').val(datos.horarioa);
                //$('#txhoras').val(datos.jornal);
                $('#txdiaslabde').val(datos.diade);
                $('#txdiaslaba').val(datos.diaa);
                $('#txdescanso').val(datos.diadescanso);
                $('#txfins').val(datos.horariofs);
            }, iferror);
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
        <asp:HiddenField ID="idempleado" runat="server" />
        <asp:HiddenField ID="idcoordina" runat="server" />
        <asp:HiddenField ID="idvacante" runat="server" />
        <asp:HiddenField ID="idturno" runat="server" />
        <asp:HiddenField ID="idpuesto" runat="server" />
        <asp:HiddenField ID="idplantilla" runat="server" />
        <asp:HiddenField ID="disponible" runat="server" />
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
                    
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Registro de Vacantes
                        <small>Recursos Humanos</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Registro de vacantes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        
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
                                        <label for="txnombre">Punto de atención:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <select id="dlsucursal" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="col-md-18 tbheader" id="tblista" style="height:200px; overflow-y:scroll">
                                    <table class="table table-condensed">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-gradient"><span>Plantilla</span></th>
                                                <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                                <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                                <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                                <th class="bg-light-blue-gradient"><span>Pago</span></th>
                                                <th class="bg-light-blue-gradient"><span>Tipo Nómina</span></th>
                                                <th class="bg-light-blue-gradient"><span>Sexo</span></th>
                                                <th class="bg-light-blue-gradient"><span>Pago mensual</span></th>
                                                <th class="bg-light-blue-gradient"><span>Autorizados</span></th>
                                                <th class="bg-light-blue-gradient"><span>Activos</span></th>
                                                <th class="bg-light-blue-gradient"><span>Vacantes</span></th>
                                                <th class="bg-light-blue-gradient"><span>Disponibles</span></th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <hr />
                                <div class="row" id="dvvacante">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcalle">Calle y num.:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txcalle" class="form-control" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txcolonia">Colonia:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcolonia" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txdelmun">Delegación/Municipio:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txdelmun" class="form-control" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestado">Estado:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlestado" class="form-control" disabled="disabled"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcp">CP:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcp" class="form-control" maxlength="5" disabled="disabled"/>
                                    </div>
                                    
                                </div>
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

                                <hr />
                                <div class="row">
                                     <div class="col-lg-2 text-right">
                                        <label for="txpuesto">Puesto:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txturno">Turno:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txturno" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txjornal">Jornal:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txjornal" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txpago">Pago Mensual:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txpago" class="form-control" disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-3 text-right">
                                        <label for="txforma">Forma de pago:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txforma" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txtipon">Tipo Nómina:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtipon" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txsexo">Sexo:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txsexo" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-3 text-right">
                                        <label for="txedad1">Edad:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txedad1" class="form-control"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txedad2" class="form-control"  disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txentrada">Horario:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txentrada" class="form-control"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txsalida" class="form-control"  disabled="disabled"/>
                                    </div>
                                    <!--
                                    <div class="col-lg-2">
                                        <input type="text" id="txhoras" class="form-control"  disabled="disabled"/>
                                    </div>-->
                                    <div class="col-lg-1">
                                        <label for="txentrada">Fin Sem:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfins" class="form-control"  disabled="disabled"/>
                                    </div>

                                </div>
                                <div class="row">
                                    
                                    <div class="col-lg-2 text-right">
                                        <label for="txdiaslabde">Dias a laborar:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txdiaslabde" class="form-control"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txdiaslaba" class="form-control"  disabled="disabled"/>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txdescanso">Descanso:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txdescanso" class="form-control"  disabled="disabled"/>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <!-- /.box-header -->
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">Folio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                </div>
                                <!--
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
                                    <div class="col-lg-1 text-right">
                                        <label for="dlubicacion">Ubicación:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlubicacion" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Local</option>
                                            <option value="2">Foraneo</option>
                                        </select>
                                    </div>
                                </div>
                                -->
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcantidad">Cantidad de vacantes a generar:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txcantidad" class="form-control" value="1"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txexperiencia">Experiencia laboral:</label>
                                    </div>
                                    <div class="col-lg-8">
                                        <textarea id="txexperiencia" class="form-control" ></textarea>
                                        
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
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Plantillas</a></li>
                                    <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Clientes</a></li>-->
                                </ol>
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
