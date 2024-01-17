<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Pro_Listadomaterial.aspx.vb" Inherits="App_Operaciones_Ope_Pro_Listadomaterial" %>

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
        .tbborrar{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e801';
        }
        #tblistaj tbody td:nth-child(6),#tblistaj tbody td:nth-child(7){
            text-align:right;
        }
        #tblistaj thead th:nth-child(1), #tblistaj tbody td:nth-child(1){
        
            width:100px;
        }
        .disabledbutton {
            pointer-events: none;
            opacity: 0.4;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                $("#menu").click();
            }, 50);
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
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#dvhigienico').hide();
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            cargacliente();
            cargames();
            $('#btjarceria').click(function () {
                $('#dvhigienico').hide();
                $('#dvjarceria').toggle('slide', { direction: 'down' }, 500);
            })
            $('#bthigienico').click(function () {
                $('#dvjarceria').hide();
                $('#dvhigienico').toggle('slide', { direction: 'down' }, 500);
            })
            $('#btcontinua').click(function () {
                if ($('input[name=listadop]:checked', '#divmodal').val() == undefined) {
                    alert('Antes de continuar debe elegir una opción de listado');
                } else {
                    waitingDialog({});
                    var mesa = $('#dlmes').val()
                    if ($('input[name=listadop]:checked', '#divmodal').val() == 2) {
                        mesa = mesa - 1
                    }
                    var xmlgraba = '<listado id= "0" tipo ="1" cliente= "' + $('#dlcliente').val() + '" inmueble="' + $('#idinmueble').val() + '" mes= "' + $('#dlmes').val() + '" mesa = "' + mesa + '" anio= "' + $('#txanio').val() + '"';
                    xmlgraba += ' usuario= "' + $('#idusuario').val() + '" opcion = "' + $('input[name=listadop]:checked', '#divmodal').val() + '" />';
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();                    
                        $('#txfolio').val(res)
                        cargadetalle()
                        alert('Registro completado.');
                        dialog.dialog('close');
                    }, iferror);
                }
            })
            $('#txclave').change(function () {
                cargaproducto($('#txclave').val());
            })
            $('#txcantidad').change(function () {
                $('#txtotal').val(parseFloat($('#txcantidad').val()) * parseFloat($('#txprecio').val()));
            })
            $('#btagrega').click(function () {
                if (validamat()) {
                    waitingDialog({});
                    PageMethods.guardalinea($('#txfolio').val(), $('#txclave').val(), $('#txcantidad').val(), $('#txprecio').val(), function () {
                        limpiaproducto();
                        cargadetalle($('#txfolio').val());
                        subtotal();
                        closeWaitingDialog();
                    }, iferror);
                }
            })
            $('#btguarda').click(function () {
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
            })
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), $('#idinmueble').val(), $('#dlcliente').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        $('#txprecio').val($(this).children().eq(3).text());
                        dialog1.dialog('close');
                    });
                }, iferror)
            })
            $('#btimprime').click(function () {
                if ($('#dlcliente').val() == 130) {
                    var formula = '{tb_listadomaterial.id_listado}=' + $('#txfolio').val();
                    window.open('../RptForAll.aspx?v_nomRpt=listadoentregaelektra.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                } else {
                    var formula = '{tb_listadomaterial.id_listado}=' + $('#txfolio').val();
                    window.open('../RptForAll.aspx?v_nomRpt=listadoentrega.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            })
        });
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
            
            if (parseFloat($('#txpttou').val()) + parseFloat($('#txtotal').val()) + parseFloat($('#txtotallista').val()) > parseFloat($('#txptto').val())) {
                alert('Al agregar este material supera el presupuesto autorizado, no puede continuar');
                return false;
            }
            return true;
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, $('#idinmueble').val(), $('#dlcliente').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc').val(datos.producto);
                    $('#txunidad').val(datos.unidad);
                    $('#txprecio').val(datos.precio);
                    $('#txcantidad').focus();
                } else {
                    alert('La clave de producto capturada no existe o bien no puede ser utilizada con este Cliente, verifique');
                    limpiaproducto();
                }
            })
        }
        function limpiaproducto () {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txcantidad').val('');
            $('#txprecio').val('');
            $('#txtotal').val('');
            $('#txclave').focus();
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
                    cargalista();
                });
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
        function cargalista() {
            //waitingDialog({});
            PageMethods.inmueble($('#dlcliente').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista table tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').click(function () {
                        limpiaproducto();
                        var inmueble = $(this).closest('tr').find('td').eq(0).text();
                        var ninmueble = $(this).closest('tr').find('td').eq(1).text();
                        if (validames()) {
                            $('#idinmueble').val(inmueble);
                            $('#txinmueble').text(ninmueble);
                            cargadetalle();
                        }
                    });
                }
            }, iferror);
        }
        function cargadetalle() {
            PageMethods.listado($('#idinmueble').val(), $('#dlmes').val(), $('#txanio').val(), $('#dlcliente').val(),  function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.id == 0) {
                    $("#divmodal").dialog('option', 'title', 'Acción');
                    dialog.dialog('open');
                } else {
                    $('#txfolio').val(datos.id);
                    $('#txestatus').val(datos.estatus);
                    $('#txptto').val(datos.ptto);
                    $('#txpttou').val(datos.usado);
                    PageMethods.listadod(datos.id, function (res) {
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
                    }); 
                    if (datos.estatus != 'Abierto') {
                        $("#dvjarceria").addClass("disabledbutton");
                    } else {
                        $("#dvjarceria").removeClass("disabledbutton");
                    }
                }
            }, iferror);
        }
        function subtotal() {
            var total = 0;
            $('#tblistaj tbody tr').each(function () {
                total += parseFloat($(this).closest('tr').find('td').eq(6).text());
            });
            $('#txtotallista').val(total.toFixed(2));
        }
        function validames() {
            if ($('#dlmes').val() == 0) {
                alert('Debe elegir el mes');
                return false;
            }
            return true;
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
                    <h1>Listados de materiales<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Listados</li>
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
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlmes">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                            </div>
                            <br />
                            <div class="row tbheader">
                                <div class="col-md-2" style="overflow-y:scroll; height:400px;" >
                                    <table class="table table-condensed" id="tblista">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-gradient">Id</th>
                                                <th class="bg-light-blue-gradient">Punto de atención</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div id="dvresumen" class=" tab-content col-md-9">
                                    <div class="row">
                                        <div class="col-lg-8 text-center">
                                            <h4 id="txinmueble" class="text-navy">&nbsp</h4>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-1 text-right">
                                            <label for="txfolio">Listado:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" id="txfolio" class="form-control" value="0" disabled="disabled"/>
                                        </div>
                                        <div class="col-xs-1">
                                            <label for="txesatus">estatus:</label>
                                        </div>
                                        <div class="col-lg-2">
                                            <input type="text" id="txestatus" class="form-control" disabled="disabled"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-1 text-right h6">
                                            <label for="txptto">Presupuesto:</label>
                                        </div>
                                        <div class="col-lg-2 h6 "> 
                                            <input type="text" id="txptto" class="form-control text-right" disabled="disabled"/>
                                        </div>
                                        <div class="col-xs-1 h6">
                                            <label for="txpttou">Utilizado:</label>
                                        </div>
                                        <div class="col-lg-2 h6">
                                            <input type="text" id="txpttou" class="form-control text-right" disabled="disabled"/>
                                        </div>
                                        <div class="col-lg-3">
                                            <input type="button" class="btn btn-info" value="Actualizar" id="btguarda" />
                                            <input type="button" class="btn btn-info" value="Imprimir" id="btimprime" />
                                        </div>
                                    </div>
                                    <div  id="dvjarceria" class="row tbheader" style="height:400px; overflow-y:scroll;">
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
                                        <hr />
                                        <div class="row">
                                            <div class="col-xs-8 text-right">
                                                <label for="txfolio">Total del listado:</label>
                                            </div>
                                            <div class="col-lg-2">
                                                <input type="text" id="txtotallista" class="form-control text-right" value="0" disabled="disabled"/>
                                            </div>
                                        </div>
                                    </div>
                                    <!--
                                    <div  id="dvhigienico" class="row tbheader">
                                        <table class=" margin table table-condensed">
                                                <thead>
                                                <tr>
                                                    <th class="bg-red-active">Clave</th>
                                                    <th class="bg-red-active">Descripción</th>
                                                    <th class="bg-red-active">Unidad</th>
                                                    <th class="bg-red-active">Cantidad</th>
                                                </tr>
                                                    <tr>
                                                        <td class="col-lg-1">
                                                            <input  class=" form-control"/>
                                                        </td>
                                                        <td class="col-lg-3">
                                                            <input  class=" form-control" disabled="disabled"/>
                                                        </td>
                                                        <td class="col-lg-1">
                                                            <input  class=" form-control" disabled="disabled"/>
                                                        </td>
                                                        <td class="col-lg-1">
                                                            <input  class=" form-control"/>
                                                        </td>
                                                        <td class="col-lg-1">
                                                            <input type="button" class="btn btn-primary" value="Agregar" id="btagrega1" />
                                                        </td>
                                                    </tr>
                                            </thead>
                                        </table>
                                    </div>-->
                                </div>
                            </div>
                        </div>
                        <div id="divmodal">
                            <div class="row">
                                <div class="col-lg-10 text-center">
                                    <h4>Este Punto de atención no tiene un listado creado en el mes seleccionado, ¿Que desea hacer?</h4>
                                </div>
                            </div>
                            <div class="funkyradio" >
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="listadop" id="radio2" value="1"/>
                                            <label for="radio2">Listados en blanco</label>
                                        </div>
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="listadop" id="radio3" value="2"/>
                                            <label for="radio3">Copiar el mes anterior</label>
                                        </div>
                                        <div class="funkyradio-primary">
                                            <input type="radio" name="listadop" id="radio4" value="3"/>
                                            <label for="radio4">Usar la lista tipo</label>
                                        </div>
                                    </div>
                            <div class="row">
                                <div class="row">
                                    <input type="button" class="btn btn-success" value="Generar" id="btcontinua" style="margin-left:400px;"/>
                                </div>
                            </div>
                        </div>
                        <div id="divmodal1">
                            <div class="row">
                                <div class="row">
                                    <div class="col-lg-2 text-right"><label for="txbusca">Buscar</label></div>
                                    <div class="col-lg-5"><input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />    </div>                                    
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
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
