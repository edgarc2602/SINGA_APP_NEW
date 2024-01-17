<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_listadogeneral.aspx.vb" Inherits="App_Operaciones_Ope_Pro_listadogeneral" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>LISTADOS DE MATERIALES</title>
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
        .funkyradio div {
            clear: both;
            overflow: hidden;
        }
        .funkyradio label {
            width: 100%;
            border-radius: 5px;
            border: 1px solid #D1D3D4;
            font-weight: normal;
        }
        .funkyradio input[type="radio"]:empty{
            display: none;
        }
        .funkyradio input[type="radio"]:empty ~ label{
            position: relative;
            line-height: 1.5em;
            text-indent: 3.25em;
            margin-top: 1em;
            cursor: pointer;
            -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                    user-select: none;
        }
        .funkyradio input[type="radio"]:empty ~ label:before{
            position: absolute;
            display: block;
            top: 0;
            bottom: 0;
            left: 0;
            content: '';
            width: 2.5em;
            background: #D1D3D4;
            border-radius: 5px 0px 5px 0px;
        }
        .funkyradio input[type="radio"]:hover:not(:checked) ~ label{
            color: #888;
        }
        .funkyradio input[type="radio"]:hover:not(:checked) ~ label:before{
            content: '\2714';
            text-indent: .9em;
            color: #C2C2C2;
        }
        .funkyradio input[type="radio"]:checked ~ label{
            color: #777;
        }
        .funkyradio input[type="radio"]:checked ~ label:before{
            content: '\2714';
            text-indent: .9em;
            color: #333;
            background-color: #ccc;
        }
        .funkyradio input[type="radio"]:focus ~ label:before{
            box-shadow: 0 0 0 3px #999;
        }
        .funkyradio-primary input[type="radio"]:checked ~ label:before{
            color: #fff;
            background-color: #337ab7;
        }
        #tblistaj tbody td:nth-child(6),#tblistaj tbody td:nth-child(7){
            text-align:right;
        }
        #tblistaj thead th:nth-child(1), #tblistaj tbody td:nth-child(1){
            width:100px;
        }
        #tblista tbody td:nth-child(7){
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
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            cargacliente();
            cargames();
            $('#dvlistai').hide();
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
                height: 500,
                width: 800,
                modal: true,
                close: function () {
                    cargaptto();
                }
            });
            dialog1 = $('#dvjarceria').dialog({
                autoOpen: false,
                height: 600,
                width: 900,
                modal: true,
                close: function () {
                    cargaptto();
                    cargalistados();
                }
            });
            dialog2 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            $('#radioBtn a').on('click', function () {
                var sel = $(this).data('title');
                var tog = $(this).data('toggle');
                $('#' + tog).prop('value', sel);

                $('a[data-toggle="' + tog + '"]').not('[data-title="' + sel + '"]').removeClass('active').addClass('notActive');
                $('a[data-toggle="' + tog + '"][data-title="' + sel + '"]').removeClass('notActive').addClass('active');
            })
            $('#btgenera').click(function () {
                if (valida()) {
                    waitingDialog({});
                    limpiaproducto();
                    var mes = $('#dlmes').val();
                    var mesa = $('#dlmes').val();
                    var anio = $('#txanio').val();
                    var anioa = $('#txanio').val();
                    if ($('input[name=radio]:checked', '#divmodal').val() == 2) {
                        if (mes == 1) {
                            mesa = 12
                            anioa = anio - 1 
                        } else {
                            mesa = mesa - 1
                        }
                    }
                    var xmlgraba = '<listado cliente= "' + $('#dlcliente').val() + '" mes= "' + $('#dlmes').val() + '" mesa = "' + mesa + '" anio= "' + anio + '"';
                    xmlgraba += ' anioa = "' + anioa + '" usuario= "' + $('#idusuario').val() + '" opcion = "' + $('input[name=radio]:checked', '#divmodal').val() + '" />';
                    //alert(xmlgraba);

                    PageMethods.guarda(xmlgraba, function () {
                        closeWaitingDialog();
                        dialog.dialog('close');
                        cargalistados();       
                    }, iferror)   
                }
            })
            $('#btcrear').click(function () {
                if (valida1()) {
                    if ($('#dltipo').val() == 1) {
                        if ($('#tblista tbody tr').length == 0) {
                            $("#divmodal").dialog('option', 'title', 'Crear listados con la siguiente opción');
                            dialog.dialog('open');
                        } else {
                            alert('Los listados para el período seleccionado ya estan creados');
                        }
                    } else {
                        alert('Debe seleccionar el tipo de listados de iguala para poder generar los listados de forma masiva');
                    }   
                }
            })
            $('#btmuestra').click(function () {
                if (valida1()) {
                    cargaptto();
                    limpiaproducto(); 
                    cuentalistados();
                    cargalistados();
                }
            })
            $('#txclave').change(function () {
                cargaproducto($('#txclave').val());
            })
            $('#txcantidad').change(function () {
                $('#txtotal').val(parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val()));
            })
            $('#btagrega').click(function () {
                if ($('#txestatus').val() == 'Aprobado') {
                    alert('Un listado aprobado ya no se puede modificar, solicite liberar el listado para poder editarlo');
                } else {
                    if (validamat()) {
                        waitingDialog({});
                        PageMethods.guardalinea($('#txfolio').val(), $('#txclave').val(), $('#txcantidad').val(), $('#txprecio').val(), function () {
                            closeWaitingDialog();
                            limpiaproducto();
                            cargadetalle($('#txfolio').val());
                            subtotal();
                        }, iferror);
                    }
                }
            })
            $('#btactualiza').click(function () {
                if ($('#txestatus').val() == 'Aprobado') {
                    alert('Un listado aprobado ya no se puede modificar, solicite liberar el listado para poder editarlo');
                } else {
                    if ($('#tblistaj tbody tr').length != 0) {
                        var xmlgraba = ''
                        for (var x = 0; x < $('#tblistaj tbody tr').length; x++) {
                            xmlgraba += '<partida listado="' + $('#txfolio').val() + '" clave="' + $('#tblistaj tbody tr').eq(x).find('td').eq(0).text() + '" cantidad="' + parseFloat($('#tblistaj tbody tr').eq(x).find("input:eq(0)").val()) + '" '
                            xmlgraba += 'precio="' + $('#tblistaj tbody tr').eq(x).find('td').eq(5).text() + '"/>'
                        }
                        PageMethods.guardadetalle(xmlgraba, function () {
                            alert('Registro completado.');
                        }, iferror);
                    }
                }
            })
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog2.dialog('open');
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(),$('#idinmueble').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        $('#txprecio').val($(this).children().eq(3).text());
                        dialog2.dialog('close');
                    });
                }, iferror)
            })
            $('#btimprime').click(function () {
                var formula = '{tb_listadomaterial.id_listado}=' + $('#txfolio').val()
                window.open('../RptForAll.aspx?v_nomRpt=listadoentrega.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
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
            $('#btenvia').click(function () {
                PageMethods.enviacorreo($("#dlcliente option:selected").text(), $('#dlcliente').val(), $("#dlmes option:selected").text(), $('#idusuario').val(), function () {
                    alert('Correo reenviado con exito');
                }, iferror);
            })
        });
        function cargaptto() {
            PageMethods.presupuesto($('#dlcliente').val(), $('#dltipo').val(), $('#dlmes').val(), $('#txanio').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txptto').val(datos.ptto);
                $('#txpttou').val(datos.usado);
                
            }, iferror)
        }
        function validamat() {
            if ($('#txclave').val() == '') {
                alert('Debe elegir la clave del material');
                return false;
            }
            if ($('#txcantidad').val() == '') {
                alert('Debe capturar la cantidad de material');
                return false;
            }
            for (var x = 0; x < $('#tblistaj tbody tr').length; x++) {
                if ($('#tblistaj tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                    alert('Este producto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            if ($('#idtipo').val() == 3) {
                if (parseFloat($('#txpttou').val()) + parseFloat($('#txtotal').val()) > parseFloat($('#txptto').val())) {
                    alert('Al agregar este material supera el importe disponible, en un listado complementario no puede superar el disponible');
                    return false;
                }
            }
            if ($('#idtipo').val() == 1) {
                if (parseFloat($('#txpttou').val()) + parseFloat($('#txtotal').val()) > parseFloat($('#txptto').val())) {
                    alert('Al agregar este material supera el presupuesto autorizado, no puede continuar');
                    return false;
                }
            } 
            return true;
        }
        function subtotal() {
            var total = 0;
            $('#tblistaj tbody tr').each(function () {
                total += parseFloat($(this).closest('tr').find('td').eq(6).text());
            });
            $('#txtotallista').val(total.toFixed(2));
            /*if ($('#idtipo').val() == 3) {
                usado = parseFloat($('#txptto').val()) - (parseFloat($('#txpttou').val()) + parseFloat($('#txusadoi').val()))
                $('#txdisptot').val(usado.toFixed(2))
            }*/
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val('');
            $('#txtotal').val('');
            $('#txclave').focus();
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, $('#idinmueble').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc').val(datos.producto);
                    $('#txunidad').val(datos.unidad);
                    $('#txprecio').val(datos.precio);
                    $('#txcantidad').focus();
                } else {
                    alert('La clave de producto capturada no existe, verifique');
                    limpiaproducto();
                }
            }, iferror)
        }
        function valida1() {
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir un cliente');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir un mes');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de listado');
                return false;
            }
            return true 
        }
        function valida() {
            if ($('input[name=radio]:checked', '#divmodal').val() == undefined) {
                alert('Antes de continuar debe elegir una opción de listado');
                return false;
            } 
            return true;
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalistados();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentalistados() {
            PageMethods.contarlistados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dlestado').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalistados() {
            PageMethods.listados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), $('#hdpagina').val(), $('#dlestado').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btver', function () {
                    if ($(this).closest('tr').find('td').eq(2).text() == 0) {
                        alert('Aun no ha creado un listado para este punto de atención, primero debe generar el listado para poder editar');
                    } else {
                        $('#idinmueble').val($(this).closest('tr').find('td').eq(0).text());
                        $('#txfolio').val($(this).closest('tr').find('td').eq(2).text());
                        $('#txtipo').val($(this).closest('tr').find('td').eq(3).text());
                        $('#txestatus').val($(this).closest('tr').find('td').eq(4).text());
                        //$('#txptto').val($(this).closest('tr').find('td').eq(5).text());
                        $('#txtotallista').val($(this).closest('tr').find('td').eq(5).text());
                        $('#idtipo').val($(this).closest('tr').find('td').eq(6).text());
                        cargadetalle($(this).closest('tr').find('td').eq(2).text());
                        if ($(this).closest('tr').find('td').eq(8).text() == 3) {
                            cargalistaa($(this).closest('tr').find('td').eq(0).text(), $('#dlmes').val(), $('#txanio').val());
                            $('#dvlistai').show();
                        } else {
                            $('#dvlistai').hide();
                        }
                        $("#dvjarceria").dialog('option', 'title', 'Detalle de materiales');
                        dialog1.dialog('open');
                    }
                    
                });
            }, iferror);
        }
        function cargalistaa(suc, mes, anio) {
            PageMethods.listadomes(suc, mes, anio, function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txlistadoi').val(datos.id);
                $('#txusadoi').val(datos.usado);
                disptot = parseFloat(datos.disp) - parseFloat($('#txpttou').val());
                $('#txdisptot').val(disptot.toFixed(2));
            }, iferror);
        }
        function cargadetalle(listado) {
            PageMethods.listadod(listado, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaj tbody').remove();
                $('#tblistaj').append(ren1);
                $('#tblistaj tbody tr').change('.tbeditar', function () {
                    $(this).closest('tr').find('td').eq(6).text($(this).closest('tr').find("input:eq(0)").val() * $(this).closest('tr').find('td').eq(5).text());
                    subtotal();
                });
                $('#tblistaj').delegate("tr .btquita", "click", function () {
                    PageMethods.eliminalinea($('#txfolio').val(), $(this).closest('tr').find('td').eq(0).text(), function () {

                    }, iferror);
                    $(this).parent().eq(0).parent().eq(0).remove();
                    subtotal();
                });
                subtotal();
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
                $('#dlcliente').change(function () {
                    cargaestado();
                });
            }, iferror);
        }
        function cargaestado() {
            PageMethods.estado($('#dlcliente').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').empty();
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
            }, iferror);
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
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idinmueble" runat="server" Value="0" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idtipo" runat="server" Value="0"/>
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
                    <h1>Creación masiva de Listados de materiales<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Listados de materiales</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div >
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlestado">Estado:</label>
                                </div >
                                <div class="col-lg-3">
                                    <select id="dlestado" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dltipo">Tipo de listado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Iguala</option>
                                        <option value="2">Adicionales</option>
                                        <option value="3">Complemento de la iguala</option>
                                        <option value="4">Material para pulido</option>
                                    </select>
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" id="btmuestra" class="btn btn-primary" value="mostrar"/>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txptto">Presupuesto:</label>
                                </div>
                                <div class="col-lg-2"> 
                                    <input type="text" id="txptto" class="form-control text-right" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txpttou">Utilizado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpttou" class="form-control text-right" disabled="disabled"/>
                                </div>
                            </div>
                            <hr />
                            <div class="row"    >
                                <div class="col-lg-3">
                                    <input type="button" id="btcrear" class="btn btn-primary" value="Generar Listados de iguala"/>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btenvia" class="btn btn-primary" value="Enviar confirmación"/>
                                </div>
                            </div>
                            <div class="row" id="divmodal">
                                <div class="col-md-12">
                                    <div class="funkyradio" >
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="radio" id="radio2" value="1"/>
                                            <label for="radio2">Listados en blanco</label>
                                        </div>
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="radio" id="radio3" value="2"/>
                                            <label for="radio3">Copiar el mes anterior</label>
                                        </div>
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="radio" id="radio4" value="3"/>
                                            <label for="radio4">Usar la lista tipo</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <input type="button" class="btn btn-success" value="Generar" id="btgenera" style="margin-left:400px;"/>
                                </div>
                            </div>
                            <div id="dvjarceria">
                                <div class="row">
                                    <div class="col-xs-1 text-right">
                                        <label for="txfolio">Listado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfolio" class="form-control" value="0" disabled="disabled"/>
                                    </div>
                                    <div class="col-xs-1 text-right">
                                        <label for="txtipo">Tipo:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txtipo" class="form-control" value="0" disabled="disabled"/>
                                    </div>
                                    <div class="col-xs-1">
                                        <label for="txesatus">Estatus:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txestatus" class="form-control" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row">
                                    
                                </div>
                                <div class="row" id="dvlistai">
                                    <div class="col-xs-2 text-right h6">
                                        <label for="txlistadoi">L. Iguala:</label>
                                    </div>
                                    <div class="col-lg-2 h6">
                                        <input type="text" id="txlistadoi" class="form-control text-right" disabled="disabled"/>
                                    </div>
                                    <div class="col-xs-1 h6">
                                        <label for="txusadoi">Utilizado iguala:</label>
                                    </div>
                                    <div class="col-lg-2 h6">
                                        <input type="text" id="txusadoi" class="form-control text-right" disabled="disabled"/>
                                    </div>
                                    <div class="col-xs-1 h6">
                                        <label for="txdisptot">Disponible:</label>
                                    </div>
                                    <div class="col-lg-2 h6">
                                        <input type="text" id="txdisptot" class="form-control text-right" disabled="disabled"/>
                                    </div>
                                </div>
                                <div class="row tbheader" style="height:300px; overflow-y:scroll;">
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
                                                    <input type="text" class=" form-control" id="txclave"/>
                                                </td>
                                                <td class="col-lg-1">
                                                    <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                                </td>
                                                <td class="col-xs-2">
                                                    <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                                                </td>
                                                <td class="col-xs-1">
                                                    <input type="text" class=" form-control" disabled="disabled" id="txunidad"/>
                                                </td>
                                                <td class="col-xs-1">
                                                    <input type="text" class=" form-control" id="txcantidad"/>
                                                </td>
                                                <td class="col-xs-1">
                                                    <input type="text" class=" form-control" disabled="disabled" id="txprecio"/>
                                                </td>
                                                    <td class="col-xs-1">
                                                    <input type="text" class=" form-control" disabled="disabled" id="txtotal"/>
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
                                    <div class="col-xs-8 text-right">
                                        <label for="txfolio">Total del listado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtotallista" class="form-control text-right" value="0" disabled="disabled"/>
                                    </div>
                                </div>
                                <hr />
                                <div class="row">
                                    <div class="col-lg-4">
                                        <input type="button" class="btn btn-info" value="Actualizar" id="btactualiza" />
                                        <input type="button" class="btn btn-info" value="Imprimir" id="btimprime" />
                                    </div>
                                </div>
                            </div>
                            <div id="divmodal1">
                                <div class="row">
                                    <div class="row">
                                        <div class="col-lg-2 text-right"><label for="txbusca">Buscar</label></div>
                                        <div class="col-lg-5"><input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" /></div>                                    
                                        <div class="col-lg-1"><input type="button" class="btn btn-primary" value="Buscar" id="btbuscap"/>  </div>
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
                    </div>
                    
                    <div class="tbheader" style="height:600px; overflow-y:scroll;">
                        <table class="table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id</span></th>
                                    <th class="bg-navy"><span>Nombre</span></th>
                                    <th class="bg-navy"><span>Listado</span></th>
                                    <th class="bg-navy"><span>Tipo</span></th>
                                    <th class="bg-navy"><span>Estatus</span></th>
                                    <th class="bg-navy"><span>Utilizado</span></th>
                                </tr>
                            </thead>
                        </table>
                        
                    </div>
                    <nav aria-label="Page navigation example" class="navbar-right">
                            <ul class="pagination justify-content-end" id="paginacion">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
