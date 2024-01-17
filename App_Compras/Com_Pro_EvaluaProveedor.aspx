
<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Pro_EvaluaProveedor.aspx.vb" Inherits="App_Compras_Com_Pro_EvaluaProveedor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>EVALUACIÓN PROVEEDOR</title>
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
            const valores = window.location.search;
            const urlParams = new URLSearchParams(valores);
            var idprovee = urlParams.get('idproveedor'); 
            var idstatu = urlParams.get('idstatus');
            $('#idproveedor').val(idprovee)
            $('#idstatu').val(idstatu)
            $("#txpromedio").prop('disabled', true);
            $("#txtextopromedio").prop('disabled', true);
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear());
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            if ($('#idfolio').val() != 0) {
                $('#txfolio').val($('#idfolio').val());
                cargaproveedor();
                cargastatus();
                cargapreguntas($('#idfolio').val());
                if ($('#idusuario').val() == 1 ) {
                    $("#dlstatus").prop('disabled', false);
                }
                else
                {
                    $("#dlstatus").prop('disabled', true);
                }
            }
            else
            {
                limpia();
                $('#dlstatus').val(1);
                $("#dlstatus").prop('disabled', true);
            }
            $('#txfecha').datepicker({ dateFormat: 'dd/mm/yy' });
            
            $('#btguarda').click(function ()
            {
                //if ($('#idusuario').val() == 59 || $('#idusuario').val() == 81 || $('#idusuario').val() == 1)
                if ($('#idusuario').val() != 1 && $('#dlstatus').val() == 2)
                {
                    alert('Usted no esta autorizado para cerrar una evaluacion');
                }
                else
                {
                    if (valida())
                    {
                        //waitingDialog({});
                        var fini = $('#txfecha').val().split('/');
                        var falta = fini[2] + fini[1] + fini[0];
                        var fing = $('#txfecha').val().split('/');
                        if ($('#txfecha').val() == '') {
                            var fingreso = fini[2] + fini[1] + fini[0];
                        } else {
                            var fingreso = fing[2] + fing[1] + fing[0];
                        }
                        //calculamos el promedio
                        var sumaprom = 0.0
                        var calif = 0.0
                        for (var x = 0; x < $('#tblista tbody tr').length; x++)
                        {
                            calif = parseFloat($('#tblista tbody tr').eq(x).find('input').eq(0).val());
                            sumaprom +=  calif;
                        }
                        var contad = parseInt($('#tblista tbody tr').length);
                        var promed = sumaprom / contad;
                        var texprom = '';
                        promed = promed.toFixed(2)
                        $('#txpromedio').val(promed);
                        //alert('valor prom: ' + $('#txpromedio').val())

                        switch (true)
                        {
                            case $('#txpromedio').val() >= 0 && $('#txpromedio').val() <= 2.9:
                                texprom = 'No Confiable - Proveedor NO confiable, Restringido';
                                break;
                            case $('#txpromedio').val() >= 3 && $('#txpromedio').val() <= 3.8:
                                texprom = 'Regular - Proveedor poco confiable, Condicionado y / o Sancionado';
                                break;
                            case $('#txpromedio').val() >= 3.9 && $('#txpromedio').val() <= 4.4:
                                texprom = 'Bueno - Proveedor confiable';
                            break;
                            case $('#txpromedio').val() >= 4.5 && $('#txpromedio').val() <= 5:
                                texprom = 'Excelente - Proveedor confiable y recomendado';
                                break;
                        }
                        //alert('textoprom: ' + texprom)

                        $('#txtextopromedio').val(texprom);

                        var xmlgraba = '';
                        xmlgraba += '<movimiento><evaluacion id_evaluacionproveedor="' + $('#txfolio').val() + '" id_proveedor= "' + $('#dlproveedor').val() + '" id_status="' + $('#dlstatus').val() + '" fecha_evaluacion="' + falta +  '"'
                        xmlgraba += ' numero_contrato="' + $('#txnumcontrato').val() + '" promedio="' + $('#txpromedio').val() + '" texto_promedio="' + $('#txtextopromedio').val() + '" id_usuario="' + $('#idusuario').val() + '" />'
                        for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                            xmlgraba += '<partida grupo ="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" id_provee="' + $('#dlproveedor').val() + '"'
                            xmlgraba += ' id_caracteristica="' + $('#tblista tbody tr').eq(x).find('td').eq(1).text() + '"'
                            xmlgraba += ' clavecalificacion="' + $('#tblista tbody tr').eq(x).find('td').eq(2).text() + '"'
                            xmlgraba += ' calificacion="' + $('#tblista tbody tr').eq(x).find('input').eq(0).val() + '"'
                            xmlgraba += '/> ';
                        };

                        xmlgraba += '</movimiento>'
                        PageMethods.guarda(xmlgraba, function (res) {
                            //closeWaitingDialog();
                            $('#txfolio').val(res);
                            alert('Registro completado.');

                            //Enviamos un correo
                            if ($('#dlstatus').val() == 1) {
                                //waitingDialog({});
                                PageMethods.autoriza($('#txfolio').val(), function () {
                                }, iferror);
                            }
                        }, iferror);
                    }
                }
            })
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btimprime').click(function () {
                if ($('#txfolio').val() != 0) {
                    var formula = '{tb_evaluacionproveedor.id_evaluacionproveedor}=' + $('#txfolio').val()
                    window.open('../RptForAll.aspx?v_nomRpt=evaluacionproveedores.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                } else {
                    alert('Debe elegir primero una valuación de Provedor');
                }
            })
        });

        function valida() {
            var iprov = document.getElementById("dlproveedor").selectedIndex;
            if (iprov == 0 || iprov == '' || iprov == 'Seleccione..') {
                alert('Debe seleccionar un Proveedor');
                return false;
            }
            var status = document.getElementById("dlstatus").selectedIndex;
            if (status == 0 || status == '' || status == 'Seleccione..') {
                alert('Debe seleccionar un Status');
                return false;
            }
            if ($('#txnumcontrato').val() == '') {
                alert('Debe capturar el número de contrato');
                return false;
            }
            
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('input').eq(0).val() == '' || $('#tblista tbody tr').eq(x).find('input').eq(1).val() == '' || $('#tblista tbody tr').eq(x).find('input').eq(2).val() == '' || $('#tblista tbody tr').eq(x).find('input').eq(3).val() == '' || $('#tblista tbody tr').eq(x).find('input').eq(4).val() == '' || $('#tblista tbody tr').eq(x).find('input').eq(5).val() == '') {
                    alert('es necesario asignar todas las calificaciones');
                    return false;
                }
            }

            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('input').eq(0).val() > 5 || $('#tblista tbody tr').eq(x).find('input').eq(1).val() == 5 || $('#tblista tbody tr').eq(x).find('input').eq(2).val() == 5 || $('#tblista tbody tr').eq(x).find('input').eq(3).val() == 5 || $('#tblista tbody tr').eq(x).find('input').eq(4).val() == 5 || $('#tblista tbody tr').eq(x).find('input').eq(5).val() == 5)
                {
                    alert('las calificaciones deben ser menores o igual a 5');
                    return false;
                }
            }
            return true;
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
        function cargaproveedor() {
            PageMethods.proveedor(function (opcion)
            {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++)
                {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').empty();
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
                
            }, iferror);
        }
        function cargastatus()
        {
            PageMethods.cargastatus(function (opcion)
            {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlstatus').empty();
                $('#dlstatus').append(inicial);
                $('#dlstatus').append(lista);

                if ($('#txfolio').val() == 0) {
                    $('#dlstatus').val(1)
                }
                else
                {
                    $('#dlstatus').val($('#idstatu').val())
                }
            }, iferror);
        }

        function cargapreguntas(idevaprov) {
            //PRIMERO CARGAMOS LA cABECERA
            PageMethods.cabecera($('#idfolio').val(), function (resca)
            {
                var datos = eval('(' + resca + ')');
                $('#txfecha').val(datos.fecha_evaluacion);
                $('#txnumcontrato').val(datos.numero_contrato);
                $('#txpromedio').val(datos.promedio);
                $('#txtextopromedio').val(datos.texto_promedio);

                var idpro = '';
                idpro = datos.id_proveedor.toString();
                let selp = document.getElementById("dlproveedor");
                selp.value = idpro;
                
                $('#dlstatus').val($('#idstatu').val())
            });

            PageMethods.preguntas(idevaprov, function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);

                $(document).ready(function () {
                    $("#tblista tr").each(function () {
                        $(this).find("td:eq(1)").hide();
                        $(this).find("td:eq(2)").hide();
                    });
                });

                $('#tblista tbody tr').on('input', '.txcalificacion', function ()
                {
                    var valor = $(this).val();
                    valor = valor.replace(/[^0-9.]/g, "");
                    //valor = valor.replace(/^(?:[0-5](?:\.\d{1,2})?|5(?:\.0{1,2})?)$/, "");
                    var partes = valor.split(".");
                    if (partes.length > 2) {
                        valor = partes[0] + "." + partes[1];
                    }
                    $(this).val(valor);
                });

            }, iferror);
        };
       
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
            //Status = Alta e inhabilitado
            $('#dlstatus').val(1);
            $("#dlstatus").prop('disabled', true);

            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear());
            $('#dlproveedor').val(0);
            $('#txnumcontrato').val('');
            $('#txpromedio').val('');
            $('#txtextopromedio').val('');
            $('#tblista tbody').remove();
            cargapreguntas(0);

            var values = $('#dlproveedor').val();
            if (values == "" || values == null)
            {
                cargaproveedor();
            }

            var valsta = $('#dlstatus').val();
            if (valsta == "" || valsta == null)
            {
                cargastatus();
            }
            $("#txfecha").prop('disabled', false);
            /*document.getElementById(txfecha).disabled = false;*/
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
    <style type="text/css">
        .auto-style1 {
            color: #fff;
            width: 220px;
            background-color: #001f3f;
            height: 29px;
        }
        .auto-style2 {
            color: #fff;
            height: 29px;
            background-color: #001f3f;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idfolio" runat="server" value="0"/>
        <asp:HiddenField ID="idproveedor" runat="server" value="0"/>
        <asp:HiddenField ID="idstatu" runat="server" value="0"/>
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
                    <h1>Evaluación de Proveedores
                        <small></small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Evaluación</li>
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
                                    <input class="form-control text-right" type="text" id="txfolio" value="0" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlencuesta">Proveedor</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlstatu">Estatus</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlstatus" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha</label>
                                </div>
                                <div class="col-lg-2">
                                    <input class="form-control text-right" type="text" id="txfecha" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txnumcontrato">Número Contrato</label>
                                </div>
                                <div class="col-lg-3">
                                    <input class="form-control" type="text" id="txnumcontrato" maxlength="50" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txpromedio">Promedio</label>
                                </div>
                                <div class="col-lg-2">
                                    <input class="form-control" type="text" id="txpromedio" maxlength="50" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txdescpromedio">Resultado</label>
                                </div>
                                <div class="col-lg-4">
                                    <input class="form-control" type="text" id="txtextopromedio" maxlength="50" />
                                </div>

                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-8">
                                    <label for="dlencuesta">Verificado el cumplimiento o no de los factores de evaluación establecidos en la siguiente tabla, se calificará al Proveedor con un Puntaje entre 1 Y 5 puntos, conforme a los siguientes criterios:</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-8">
                                    <label for="dlencuesta">Entre 0.0 y 2.9 = NO CUMPLE,     Entre 3.0 y 3.8 = REGULAR,     Entre 3.9 y 4.4 = BUENO,     Entre 4.5 y 5.0 = EXCELENTE</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="auto-style2">Id</th>
                                            <%--<th class="auto-style1"><span>Id Caracteristica</span></th>--%>
                                            <th class="auto-style2"><span>Caracteristica</span></th>
                                            <th class="auto-style2"><span>Criterios</span></th>
                                            <th class="auto-style2"><span>Calificación</span></th>
                                            <%--                                            <th class="bg-navy"><span>1</span></th>
                                            <th class="bg-navy"><span>2</span></th>
                                            <th class="bg-navy"><span>3</span></th>
                                            <th class="bg-navy"><span>4</span></th>--%>
                                            <%--<th class="bg-navy"><span>5</span></th>--%>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir evaluación</a></li>
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
