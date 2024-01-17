<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Evaluacion.aspx.vb" Inherits="App_CGO_CGO_Pro_Evaluacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>REGISTRO DE TICKET</title>
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
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        var inicial1 = '<option value=1>SIN SUPERVISOR</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
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
            if ($('#idfolio').val() != 0) {
                $('#txfolio').val($('#idfolio').val());
                cargacampania();
            }
            cargaencuesta();
            cargacliente();
            cargagerente();
            cargasup();
            cargacgo();
            cargacomprador();
            $('#txfingreso').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dvpersonal').hide();
            $('#dvgerente').hide();
            $('#dvcgo').hide();
            $('#btguarda').click(function () {
                if (valida()) {
                    //waitingDialog({});
                    var fini = $('#txfecha').val().split('/');
                    var falta = fini[2] + fini[1] + fini[0];
                    var fing = $('#txfingreso').val().split('/');
                    //alert($('#txfingreso').val());
                    
                    if ($('#txfingreso').val() == '') {
                        var fingreso = fini[2] + fini[1] + fini[0];
                    } else {
                        var fingreso = fing[2] + fing[1] + fing[0];
                    }
                    
                    var xmlgraba = '';
                    xmlgraba += '<movimiento><encuesta id="' + $('#txfolio').val() + '" fecha="' + falta + '" cliente="' + $('#dlcliente').val() + '"'
                    xmlgraba += ' inmueble="' + $('#dlsucursal').val() + '" gerente="' + $('#dlgerente').val() + '" supervisor="' + $('#dlsupervisor').val() + '"'
                    xmlgraba += ' cgo="' + $('#dlcgo').val() + '" comprador="' + $('#dlcomprador').val() + '" persona="' + $('#txnombre').val() + '"'
                    xmlgraba += ' campania="' + $('#dlencuesta').val() + '" observacion="' + $('#txobservacion').val() + '"'
                    xmlgraba += ' correoe="' + $('#txcorreo').val() + '" tele="' + $('#txtel').val() + '" usuario="' + $('#idusuario').val() + '"'
                    xmlgraba += ' edad="' + $('#txedad').val() + '" sexo = "' + $('#dlsexo').val() + '" fingreso = "' + fingreso + '" />'
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        xmlgraba += '<partida grupo ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" pregunta="' + $('#tblista tbody tr').eq(x).find('td').eq(1).text() + '"'
                        if ($('#tblista tbody tr').eq(x).find('input').eq(0).val() == '1') {
                            xmlgraba += ' mov = "1"';
                        } else {
                            if ($('#tblista tbody tr').eq(x).find('input').eq(1).val() == '2') {
                                xmlgraba += ' mov = "2"';
                            } else {
                                if ($('#tblista tbody tr').eq(x).find('input').eq(2).val() == '3') {
                                    xmlgraba += ' mov = "3"';
                                } else {
                                    if ($('#tblista tbody tr').eq(x).find('input').eq(3).val() == '4') {
                                        xmlgraba += ' mov = "4"';
                                    } else {
                                        if ($('#tblista tbody tr').eq(x).find('input').eq(4).val() == '5') {
                                            xmlgraba += ' mov = "5"';
                                        } else {
                                            if ($('#tblista tbody tr').eq(x).find('input').eq(5).val() == '0') {
                                                xmlgraba += ' mov = "0"';
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        xmlgraba += '/> ';
                    };
                    xmlgraba += '</movimiento>'
                   // alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {
                        //closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btimprime').click(function () {
                if ($('#dlencuesta').val() == 1) {
                    window.open('../RptForAll.aspx?v_nomRpt=encuestacalidad.rpt&v_formula={tb_encuesta_registro.id_campania} = ' + $('#txfolio').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                } else {
                    window.open('../RptForAll.aspx?v_nomRpt=encuestacalidad2.rpt&v_formula={tb_encuesta_registro.id_campania} = ' + $('#txfolio').val() + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            })
        });
        function cargacampania() {
            PageMethods.campania($('#idfolio').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txfecha').val(datos.fecha);
                $('#idcliente').val(datos.cliente);
                cargacliente()
                $('#idinmueble').val(datos.inmueble);
                cargainmueble(datos.cliente);
                $('#idgerente').val(datos.gerente);
                cargagerente();
                $('#idsupervisor').val(datos.supervisor);
                cargasup();
                $('#idcgo').val(datos.cgo);
                cargacgo();
                $('#idcomprador').val(datos.comprador);
                cargacomprador();
                $('#txedad').val(datos.edad);
                $('#dlsexo').val(datos.sexo);
                $('#txfingreso').val(datos.fing);
                $('#txnombre').val(datos.encuestado);
                $('#txcorreo').val(datos.correoenc);
                $('#txtel').val(datos.telenc);
                $('#idencuesta').val(datos.encuesta);
                cargaencuesta();
                $('#txobservacion').val(datos.observacion);
                cargapreguntas(datos.encuesta, $('#idfolio').val());
                oculta(datos.encuesta);
            }, iferror)
        }
        function valida() {
            if ($('#dlcliente').val() == 0) {
                alert('Debe selecionar un Cliente');
                return false;
            }
            if ($('#dlsucursal').val() == 0) {
                alert('Debe selecionar un Punto de atención');
                return false;
            }
            if ($('#dlencuesta').val() != 7) {
                if ($('#dlgerente').val() == 0) {
                    alert('Debe selecionar un Gerente');
                    return false;
                }
                if ($('#dlsupervisor').val() == 0) {
                    alert('Debe selecionar un Supervisor');
                    return false;
                }
                if ($('#dlcgo').val() == 0) {
                    alert('Debe selecionar un ejecutivo de CGO');
                    return false;
                }
                if ($('#dlcomprador').val() == 0) {
                    alert('Debe selecionar un comprador');
                    return false;
                }
            } else {
                if ($('#txedad').val() == '') {
                    alert('Debe colocar la edad del colaborador');
                    return false;
                }
                if ($('#dlsexo').val() == 0) {
                    alert('Debe elegir el sexo del colaborador');
                    return false;
                }
                if ($('#txfingreso').val() == '') {
                    alert('Debe selecionar la fecha de ingreso del colaborador');
                    return false;
                }
            }            
            if ($('#txnombre').val() == '') {
                alert('Debe capturar la persona encuestada');
                return false;
            }
            if ($('#dlencuesta').val() == 0) {
                alert('Debe elegir una encuesta');
                return false;
            }
            /*
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                //xmlgraba += '<partida grupo ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" pregunta="' + $('#tblista tbody tr').eq(x).find('td').eq(1).text() + '"'
                if ($('#tblista tbody tr').eq(x).find('input').eq(0).val() == '0' && $('#tblista tbody tr').eq(x).find('input').eq(1).val() == '0' && $('#tblista tbody tr').eq(x).find('input').eq(2).val() == '0' && $('#tblista tbody tr').eq(x).find('input').eq(3).val() == '0' && $('#tblista tbody tr').eq(x).find('input').eq(4).val() == '0' && $('#tblista tbody tr').eq(x).find('input').eq(5).val() == '0') {
                    alert('No debe quedar ninguna pregunta sin respuesta');
                    return false;
                }
            }*/
            return true;
        }
        function cargaencuesta() {
            PageMethods.encuesta( function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlencuesta').append(inicial);
                $('#dlencuesta').append(lista);
                $('#dlencuesta').val(0);
                if ($('#idencuesta').val() != 0) {
                    $('#dlencuesta').val($('#idencuesta').val())
                }
                $('#dlencuesta').change(function () {
                    cargapreguntas($('#dlencuesta').val(), 0);
                    oculta($('#dlencuesta').val());
                })
            }, iferror);
        }
        function oculta(enc) {
            if (enc == 7) {
                $('#dvpersonal').show();
                $('#dvgerente').hide();
                $('#dvcgo').hide();
            } else {
                $('#dvpersonal').hide();
                $('#dvgerente').show();
                $('#dvcgo').show();
            }
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
                $('#dlcliente').val(0);
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val())
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
                $('#dlsucursal').val(0);
                if ($('#idinmueble').val() != 0) {
                    $('#dlsucursal').val($('#idinmueble').val())
                }
            }, iferror);
        }
        function cargagerente() {
            PageMethods.gerente("30,107", function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
                $('#dlgerente').val(0);
                if ($('#idgerente').val() != 0) {
                    $('#dlgerente').val($('#idgerente').val())
                }
            }, iferror);
        }
        function cargasup() {
            PageMethods.gerente("1000", function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsupervisor').append(inicial);
                $('#dlsupervisor').append(inicial1);
                $('#dlsupervisor').append(lista);
                $('#dlsupervisor').val(0);
                if ($('#idsupervisor').val() != 0) {
                    $('#dlsupervisor').val($('#idsupervisor').val());
                }
            }, iferror);
        }
        function cargacgo() {
            PageMethods.atiende(9, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcgo').empty();
                $('#dlcgo').append(inicial);
                $('#dlcgo').append(lista);
                $('#dlcgo').val(0);
                if ($('#idcgo').val() != 0) {
                    $('#dlcgo').val($('#idcgo').val());
                }
            });
        }
        function cargacomprador() {
            PageMethods.atiende(8, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcomprador').empty();
                $('#dlcomprador').append(inicial);
                $('#dlcomprador').append(lista);
                $('#dlcomprador').val(0);
                if ($('#idcomprador').val() != 0) {
                    $('#dlcomprador').val($('#idcomprador').val());
                }
            });
        }
        function cargapreguntas(enc, cam) {
            //waitingDialog({});
            
            PageMethods.preguntas(enc, cam, function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.tbstatus1', function () {
                    if ($(this).closest('tr').find('input').eq(0).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(0).val('1');
                        $(this).closest('tr').find('input').eq(0).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus2', function () {
                    if ($(this).closest('tr').find('input').eq(1).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(1).val('2');
                        $(this).closest('tr').find('input').eq(1).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus3', function () {
                    if ($(this).closest('tr').find('input').eq(2).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(2).val('3');
                        $(this).closest('tr').find('input').eq(2).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus4', function () {
                    if ($(this).closest('tr').find('input').eq(3).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(3).val('4');
                        $(this).closest('tr').find('input').eq(3).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus5', function () {
                    if ($(this).closest('tr').find('input').eq(4).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(4).val('5');
                        $(this).closest('tr').find('input').eq(4).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
                $('#tblista tbody tr').on('click', '.tbstatus6', function () {
                    if ($(this).closest('tr').find('input').eq(5).val() == '0') {
                        limpiaboton($(this).closest('tr').index())
                        $(this).closest('tr').find('input').eq(5).val('0');
                        $(this).closest('tr').find('input').eq(5).addClass("btn-success").removeClass("btn-secundary")
                    }
                });
            }, iferror);
        };
        function limpiaboton(tr) {
            $('#tblista tbody tr').eq(tr).find('input').eq(0).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(1).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(2).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(3).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(4).addClass("btn-secundary").removeClass("btn-success")
            $('#tblista tbody tr').eq(tr).find('input').eq(5).addClass("btn-secundary").removeClass("btn-success")
            
            $('#tblista tbody tr').eq(tr).find('input').eq(0).val('0');
            $('#tblista tbody tr').eq(tr).find('input').eq(1).val('0');
            $('#tblista tbody tr').eq(tr).find('input').eq(2).val('0');
            $('#tblista tbody tr').eq(tr).find('input').eq(3).val('0');
            $('#tblista tbody tr').eq(tr).find('input').eq(4).val('0');
            $('#tblista tbody tr').eq(tr).find('input').eq(5).val('0');

        }
        function limpia() {
            $('#txfolio').val(0);
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
            $('#dlcliente').val(0);
            $('#dlsucursal').empty();
            $('#dlgerente').val(0);
            $('#dlsupervisor').val(0);
            $('#dlcgo').val(0);
            $('#dlcomprador').val(0);
            $('#txnombre').val('');
            $('#dlencuesta').val(0);
            $('#txobservacion').val('');
            $('#tblista tbody').remove();
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
        <asp:HiddenField ID="idfolio" runat="server" value="0"/>
        <asp:HiddenField ID="idcliente" runat="server" value="0"/>
        <asp:HiddenField ID="idinmueble" runat="server" value="0"/>
        <asp:HiddenField ID="idgerente" runat="server" value="0"/>
        <asp:HiddenField ID="idsupervisor" runat="server" value="0"/>
        <asp:HiddenField ID="idcgo" runat="server" value="0"/>
        <asp:HiddenField ID="idcomprador" runat="server" value="0"/>
        <asp:HiddenField ID="idencuesta" runat="server" value="0"/>
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
                    <h1>Encuesta de calidad
                        <small>CGO</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Encuesta</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <!-- Horizontal Form -->
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de Ticket</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-6 text-right">
                                    <label for="txfolio">Folio</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control text-right" type="text" id="txfolio" value="0" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control text-right" type="text" id="txfecha" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlencuesta">Encuesta</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlencuesta" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención</label>
                                </div>
                                <div class="col-lg-4">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row" id="dvpersonal">
                                <div class="col-lg-1 text-right">
                                    <label for="txedad">Edad</label>
                                </div>
                                <div class="col-lg-1">
                                    <input  class="form-control" type="text" id="txedad" value ="0"/>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlsexo">Sexo</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlsexo" class="form-control">
                                        <option value ="0">Seleccione...</option>
                                        <option value ="1">Hombre</option>
                                        <option value ="2">Mujer</option>
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txfingreso">F. Ingreso</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control" type="text" id="txfingreso" />
                                </div>
                            </div>
                            <div class="row" id="dvgerente">
                                <div class="col-lg-1 text-right">
                                    <label for="dlgerente">Gerente</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlgerente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsupervisor">Supervisor</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlsupervisor" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row" id="dvcgo">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcgo">CGO</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcgo" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlcomprador">Comprador</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcomprador" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txnombre">Persona encuestada</label>
                                </div>
                                <div class="col-lg-3">
                                    <input  class="form-control" type="text" id="txnombre" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcorreo">Correo encuestado</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control" type="text" id="txcorreo" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txtel">Telefono encuestado</label>
                                </div>
                                <div class="col-lg-2">
                                    <input  class="form-control" type="text" id="txtel" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-8">
                                    <label for="dlencuesta">Clasifique su nivel de satisfacción de acuerdo con la siguiente escala de clasificación:</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-8">
                                    <label for="dlencuesta">1 = PÉSIMO     2 = REGULAR     3 = ACEPTABLE     4 = BUENO     5 = EXCELENTE     NE = (NO EVIDENCIADO) si no fue posible observar los aspectos asociados con la pregunta</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblista">
                                    <thead>
                                        <tr><th class="bg-navy"></th>
                                            <th class="bg-navy"><span>Ind</span></th>
                                            <th class="bg-navy"><span>Grupo</span></th>
                                            <th class="bg-navy"><span>Pregunta</span></th>
                                            <th class="bg-navy"><span>1</span></th>
                                            <th class="bg-navy"><span>2</span></th>
                                            <th class="bg-navy"><span>3</span></th>
                                            <th class="bg-navy"><span>4</span></th>
                                            <th class="bg-navy"><span>5</span></th>
                                            <th class="bg-navy"><span>NE</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txobservacion">Comentarios adicionales</label>
                            </div>
                            <div class="col-lg-6">
                                <textarea  class="form-control" id="txobservacion"></textarea>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir encuesta</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
