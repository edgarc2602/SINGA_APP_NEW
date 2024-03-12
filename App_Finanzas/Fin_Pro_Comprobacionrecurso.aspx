<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_Comprobacionrecurso.aspx.vb" Inherits="App_Finanzas_Fin_Pro_Comprobacionrecurso" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>COMPROBACION DE RECURSOS</title>
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
        #tblistac tbody td:nth-child(5){
            width:200px;            
        }
        #tblistac tbody td:nth-child(8){
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
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            dialog3 = $('#dvcarga').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog2 = $('#dvvalida').dialog({
                autoOpen: false,
                height: 300,
                width: 600,
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
            $('#txfechac').datepicker({ dateFormat: 'dd/mm/yy' });
            if ($('#idsol').val() != 0) {
                cargasolicitud();
                cargacomprobacion();
            }
            $('#btautoriza').click(function () {               
                if (validastatus()) {
                    waitingDialog({});
                    var xmlgraba = '<cambioestatus comp="' + $('#txfoliose2').val() + '" estatus="' + $('#dlestatus1').val() + '"';
                    xmlgraba += ' usuario="' + $('#idusuario').val() + '" motivo="' + $('#txmotivo').val() + '"';
                    xmlgraba += ' solicitud="' + $('#txfolio').val() + '" estatusnombre="' + $('#txstatus').val() + '" />';                    
                    PageMethods.cambiaestatus(xmlgraba, $('#dlestatus1').val(), $('#txfolio').val(), function (res) {
                        cargacomprobacion();
                        cargasolicitud()
                        /*if (res != 0) {
                            enviacorreocierre();
                        }*/
                        dialog2.dialog('close');
                        closeWaitingDialog();
                    }, iferror);
                }
            })
            $('#btcomprueba').click(function () {
                if ($('#txstatus').val() != 'Comprobado') {
                    enviacorreo();
                    $('#txstatus').val('Comprobado');
                    alert('El registro se ha enviado a Contabilidad para su validación');
                } else {
                    alert('la comprobación ya habia sido enviada');
                }
            })
            $('#btverifica').click(function () {
                if ($('#idusuario').val() != 20670 && $('#idusuario').val() != 20684 && $('#idusuario').val() != 30763) {
                    alert('Usted no tiene permisos para verificar solicitudes');
                } else {
                    if ($('#txstatus').val() != 'Verificado') {
                        waitingDialog({});
                        enviacorreocierre();
                        $('#txstatus').val('Verificado');
                        closeWaitingDialog();
                    } else {
                        alert('Ya se habia confirmado la comprobación, verifique')
                    }
                }  
            })
        })
        function validastatus() {
            if ($('#dlestatus1').val() == 0) {
                alert('Debe elegir un estatus correcto.');
                return false;
            }
            if ($('#dlestatus1').val() == 6 && $('#txmotivo').val() == '') {
                alert('Cuando se rechaza un comprobante debe indicar el motivo del rechazo');
                return false;
            }
            return true;
        }
        function cargacomprobacion() {
            PageMethods.comprobacion($('#idsol').val() , function (res) {
                var ren = $.parseHTML(res);
                $('#tblistac tbody').remove();
                $('#tblistac').append(ren);
                $('#tblistac tbody tr').on('click', '.btver', function () {
                    $("#dvcarga").dialog('option', 'title', 'Documentos registrados');
                    $('#txfoliose1').val($(this).closest('tr').find('td').eq(7).text());
                    cargaexistentes();
                    dialog3.dialog('open');
                })
                $('#tblistac tbody tr').on('click', '.btvalida', function () {
                    if ($(this).closest('tr').find('td').eq(5).text() == 'Rechazado') {
                        alert('El comprobante fue rechazado ya no puede cambiar estatus');
                    } else {
                        $("#dvvalida").dialog('option', 'title', 'Confirmar/Rechazar');
                        $('#txfoliose2').val($(this).closest('tr').find('td').eq(7).text());
                        dialog2.dialog('open');
                    }                    
                });
            });
        }
        function cargaexistentes() {
            PageMethods.listadocto($('#txfoliose1').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaa tbody').remove();
                $('#tblistaa').append(ren1);
                $('#tblistaa tbody tr').on('click', '.btver', function () {
                    var carpeta = $('#idsol').val()
                    var arc = $(this).closest('tr').find('td').eq(0).text();
                    window.open('../Doctos/finanzas/' + carpeta + '/' + arc, '_blank', 'width=650, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                });
               
            })
        }
        function cargasolicitud() {
            PageMethods.cargasol($('#idsol').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');               
                $('#txfolio').val(datos.id);
                $('#txdesc').val(datos.concepto);
                $('#txbeneficia').val(datos.beneficiario);
                $('#tximporte').val(datos.total);
                $('#tximportec').val(datos.comprobado);
                $('#tximportep').val(datos.saldo);
                $('#txstatus').val(datos.estatus);
                if (datos.estatus == 'Pagado') {
                    $('#btverifica').hide();
                    $('#btcomprueba').show();
                }
                if (datos.estatus == 'Comprobado') {
                    $('#btverifica').show();
                    $('#btcomprueba').hide();
                }
                if (datos.estatus == 'Verificado') {
                    $('#btverifica').hide();
                    $('#btcomprueba').hide();
                }

            })
        }
        function xmlUpFile() {
            if (valida()) {
                waitingDialog({});
                var fileup = $('#txdocto').get(0);
                var files = fileup.files;
                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                ndt.append('sr', $('#idsol').val());
                $.ajax({
                    url: '../GH_Upcomp.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function () {                        
                        var fini = $('#txfechac').val().split('/');
                        var falta = fini[2] + fini[1] + fini[0];
                        var xmlgraba = '<movimiento> <comprobante solicitud="' + $('#idsol').val() + '" fecha="' + falta + '" documento="' + $('#dlconcepto').val() + '" ';
                        xmlgraba += ' factura= "' + $('#txnofac').val() + '" importe="' + $('#txmonto').val() + '"/>'
                        for (var i = 0; i < files.length; i++) {
                            xmlgraba += '<archivo nombre="' + files[i].name + '"/>';
                        }
                        xmlgraba += '</movimiento>'
                        PageMethods.guarda(xmlgraba, function (res) {
                            cargacomprobacion();
                            cargasolicitud();
                            limpiacomprobacion();
                            /*if (res != 0) {
                                enviacorreo();
                            }*/
                            closeWaitingDialog();
                        });
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
        }
        function enviacorreo() {
            //alert('HOLA');
            PageMethods.enviacorreo($('#idsol').val(), function (res) {                
            });
        }
        function enviacorreocierre() {
            PageMethods.enviacorreocierre($('#idsol').val(), function (res) {
            });
        }
        function limpiacomprobacion() {
            $('#txfechac').val('');
            $('#dlconcepto').val(0);
            $('#txnofac').val('');
            $('#txmonto').val('');
        }
        function valida() {
            if ($('#txstatus').val() == 'Verificado') {
                alert('Ya no se pueden agregar comprobantes a esta solicitud, ya fue verificada.');
                return false;
            }
            if ($('#txfechac').val() == '') {
                alert('Debe colocar la fecha del comprobante');
                return false;
            }
            if ($('#dlconcepto').val() == 0) {
                alert('Debe elegir el tipo de comprobante');
                return false;
            }
            if ($('#txnofac').val() == '') {
                alert('Debe colocar un folio de comprobante');
                return false;
            }
            if ($('#txmonto').val() == '') {
                alert('Debe colocar el importe del comprobante');
                return false;
            }            
            var fileup = $('#txdocto').get(0);
            var files = fileup.files;
            if (files.length == 0) {
                alert('Debe agregar al menos un archivo de comprobante');
                return false;
            }
            var total = 0 
            $('#tblistac tbody tr').each(function () {
                if ($(this).closest('tr').find('td').eq(5).text() != 'Rechazado') {
                    total += parseFloat($(this).closest('tr').find('td').eq(3).text());
                }             
            });
            /*
            var totalc = parseFloat(total) + parseFloat($('#txmonto').val())            
            if (totalc > parseFloat($('#tximporte').val())) {
                alert('No puede comprobar un importe mayor al solicitado, verifique');
                return false;
            }*/
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
        };        
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idsol" runat="server" Value="0" />
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
                    <h1>Comprobación de Recursos<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Comprobación</li>
                    </ol>
                </div>
                <div class="content">
                    <div class=" col-lg-12" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txfolio">Solicitud</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfolio" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txfecha">Fecha</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txstatus">Estatus</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txstatus" class="form-control text-right" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txbeneficia">Concepto</label>
                                </div>
                                <div class="col-lg-7">
                                    <textarea class=" form-control" id="txdesc" disabled="disabled"></textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txbeneficia">Beneficiario</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbeneficia" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="tximporte">Importe a comprobar</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="tximporte" class="form-control text-right" disabled="disabled" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-lg-6 text-right">
                                    <label for="tximportec">Importe comprobado</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="tximportec" class="form-control text-right" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 text-right">
                                    <label for="tximportep">Importe pendiente</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="tximportep" class="form-control text-right" disabled="disabled" />
                                </div>
                                <div class="col-lg-3 text-right">
                                    <input type="button" class="btn btn-primary " value="Enviar comprobación" id="btcomprueba" />
                                </div>
                                <div class="col-lg-3 text-right">
                                    <input type="button" class="btn btn-primary " value="Enviar verificación" id="btverifica" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-12 tbheader" style="height: 300px; overflow-y: scroll;" id="dvconcepto">
                        <table class=" table table-condensed h6" id="tblistac">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active">Fecha comprobante</th>
                                    <th class="bg-light-blue-active">Documento</th>
                                    <th class="bg-light-blue-active">Folio</th>
                                    <th class="bg-light-blue-active">Importe</th>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active">Estatus</th>
                                    <th class="bg-light-blue-active">Motivo</th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                                <tr>
                                    <td class="col-lg-1">
                                        <input type="text" class=" form-control text-right" id="txfechac" />
                                    </td>
                                    <td class="col-lg-2">
                                        <select id="dlconcepto" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Factura</option>
                                            <option value="2">Nota de remisión</option>
                                            <option value="3">Vale azul</option>
                                            <option value="4">Depósito</option>
                                            <option value="5">Convenio</option>
                                            <option value="6">Excel</option>
                                            <option value="7">Complemento de pago</option>
                                        </select>
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="text" class="form-control text-right" id="txnofac" />
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="text" class="form-control text-right" id="txmonto" />
                                    </td>
                                    <td class="col-lg-3">
                                        <input type="file" class="form-control text-right" id="txdocto" multiple="multiple" />
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" onclick="xmlUpFile()" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="row" id="dvcarga">
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="txfoliose1">Folio:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfoliose1" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="dlbanco">Documentos:</label>
                            </div>
                            <div id="dvarchivos" class="tbheader col-lg-8" style="height: 200px; overflow-y: scroll;">
                                <table class=" table table-condensed h6" id="tblistaa">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-active">Documento</th>
                                            <th class="bg-light-blue-active"></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvvalida">
                        <div class="row">
                            <div class="col-lg-3 text-right">
                                <label for="txfoliose2">Folio:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txfoliose2" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dlestatus1">Estatus:</label>
                            </div>
                            <div class="col-lg-3">
                                <select id="dlestatus1" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="2">Confirmar</option>
                                    <option value="6">Rechazar</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txmotivo">Motivo:</label>
                            </div>
                            <div class="col-lg-6" >
                                <textarea class="form-control" id="txmotivo" maxlength="300"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-5">
                                <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
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
