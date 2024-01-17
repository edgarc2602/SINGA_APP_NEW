<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Cat_Proveedor.aspx.vb" Inherits="App_Compras_Com_Cat_Proveedor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE PROVEEDORES</title>
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
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            cargabancos();
            cargaestado();
            cargalinea();
            cuentaproveedor()
            cargalista();
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
                   
                    $('body').css('overflow', 'auto');
                }
            });
            dialog2 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 600,
                modal: true,
                close: function () {
                    actualizaestado();
                }
            });
            $('#dvdatos').hide();
            $('#btnuevo').click(function () {
                limpia();
            })
            $('#btnuevo1').click(function () {
                limpia();
                $('#dvdatos').show();
                $('#dvdetalle').hide();
            })
            $('#btbusca').click(function () {
                $('#hdpagina').val(1);
                cuentaproveedor();
                cargalista();
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    
                    var xmlgraba = '<proveedor id= "' + $('#txid').val() + '" nombre = "' + $('#txnombre').val() + '" clave = "' + $('#txclave').val() + '"  razon= "' + $('#txrazon').val() + '" rfc="' + $('#txrfc').val() + '" calle= "' + $('#txcalle').val() + '" colonia= "' + $('#txcolonia').val() + '" ';
                    xmlgraba += ' cp= "' + $('#txcp').val() + '" municipio= "' + $('#txmunicipio').val() + '" estado = "' + $('#dlestado').val() + '" tipo= "' + $('#dltipo').val() + '"';
                    xmlgraba += ' credito= "' + $('#dlcredito').val() + '" banco= "' + $('#dlbanco').val() + '" clabe= "' + $('#txclabe').val() + '" cuenta= "' + $('#txcuenta').val() + '" limite= "' + $('#txlimite').val() + '" linea= "' + $('#dllinea').val() + '"';
                    xmlgraba += '/>'
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        alert('Registro eliminado');
                        limpia();
                        cargalista();
                        $('#dvdetalle').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir un Empleado'); }
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvdetalle').show();
                $('#dvdatos').hide();
            });
            $('#btestados').click(function () {
                PageMethods.estados($('#txid').val(), function (res) {
                    var ren = $.parseHTML(res);
                    $('#tblistaestado tbody').remove();
                    $('#tblistaestado').append(ren);
                    $("#divmodal1").dialog('option', 'title', 'Elegir Estados');
                    dialog2.dialog('open');
                }, iferror);
            })
            $('#btactualiza1').on('click', function () {
                actualizaestado();  
            })
            $('#btimprime').click(function () {
                var formula = '{tb_proveedor.id_status} = 1'
                window.open('../RptForAll.aspx?v_nomRpt=catalogoproveedor.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        });
         function actualizaestado() {
             var xmlgraba = '<Movimiento idpro="' + $('#txid').val() + '">';
             $('#tblistaestado tr input[type=checkbox]:checked').each(function () {
                 xmlgraba += '<pro idpro="' + $('#txid').val() + '" idestado="' + $(this).closest('tr').find('td').eq(0).text() + '"/>"';
             });
             xmlgraba += '</Movimiento>';
             PageMethods.guardaestado(xmlgraba, function (res) {
                 dialog2.dialog('close');
             }, iferror);
         }
         function limpia() {
             $('#txid').val(0);
             $('#txclave').val('');
             $('#txnombre').val('');
             $('#txrazon').val('');
             $('#txrfc').val('');
             $('#txcuenta').val('');
             $('#txcalle').val('');
             $('#txcolonia').val('');
             $('#txcp').val('');
             $('#txmunicipio').val('');
             $('#dlestado').val(0);
             $('#dltipo').val(0);
             $('#dlcredito').val(0);
             $('#dlbanco').val(0);
             $('#txclabe').val('');
         }
         function valida() {
             if ($('#txnombre').val() == '') {
                 alert('Debe capturar el Nombre');
                 return false;
             }
             if ($('#dltipo').val() == 0) {
                 alert('Debe seleccionar el tipo de compra');
                 return false;
             }
             if ($('#dlcredito').val() == 0) {
                 alert('Debe seleccionar el tipo de crédito');
                 return false;
             }
             return true;
         }
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
         function cargalinea() {
             PageMethods.linea(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dllinea').empty();
                 $('#dllinea').append(inicial);
                 $('#dllinea').append(lista);
                 $('#dllinea').val(0);
                 if ($('#idlinea').val() != 0) {
                     $('#dllinea').val($('#idlinea').val());
                 };
             }, iferror);
         }
         function cargabancos() {
             PageMethods.banco(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlbanco').empty();
                 $('#dlbanco').append(inicial);
                 $('#dlbanco').append(lista);
                 $('#dlbanco').val(0);
                 if ($('#idbanco').val() != '') {
                     $('#dlbanco').val($('#idbanco').val());
                 };
             }, iferror);
         }
         function cargalista() {
             PageMethods.proveedor($('#hdpagina').val(), $('#dlbusca').val(), $('#txbusca').val(), function (res) { //
                 var ren = $.parseHTML(res);
                 $('#tblista tbody').remove();
                 $('#tblista').append(ren);
                 $('#tblista  tbody tr').on('click', function () {
                     limpia();
                     $('#txid').val($(this).children().eq(0).text());
                     $('#txclave').val($(this).children().eq(1).text());
                     $('#txnombre').val($(this).children().eq(2).text());
                     $('#txrazon').val($(this).children().eq(3).text());
                     $('#txrfc').val($(this).children().eq(4).text());
                     $('#txclabe').val($(this).children().eq(8).text());
                     datosproveedor();
                     $('#dvdetalle').hide();
                     $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                 });
             }, iferror);
         };
         function datosproveedor() {
             PageMethods.detalle($('#txid').val(), function (detalle) {
                 var datos = eval('(' + detalle + ')');
                 $('#txcalle').val(datos.direccion);
                 $('#txcolonia').val(datos.colonia);
                 $('#txcp').val(datos.cp);
                 $('#txmunicipio').val(datos.municipio);
                 $('#idestado').val(datos.id_estado);
                 cargaestado($('#idestado').val());
                 $('#dltipo').val(datos.tipo);
                 $('#dlcredito').val(datos.credito);
                 $('#idbanco').val(datos.id_banco);
                 cargabancos();
                 $('#idlinea').val(datos.linea);
                 cargalinea();
                 $('#txcuenta').val(datos.cuenta);
             }, iferror);
         }
         function asignapagina(np) {
             $('#paginacion li').removeClass("active");
             $('#hdpagina').val(np);
             cargalista();
             $('#paginacion li').eq(np - 1).addClass("active");
         };
         function cuentaproveedor() {
             PageMethods.contarproveedor($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
                 $('#paginacion li').remove();
                 var opt = eval('(' + cont + ')');
                 var pag = '';
                 for (var x = 1; x <= opt[0].pag; x++) {
                     pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                 }
                 $('#paginacion').append(pag);
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idbanco" runat="server" Value="0" />
        <asp:HiddenField ID="idestado" runat="server" Value="0" />
        <asp:HiddenField ID="idlinea" runat="server" Value="0" />
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
                    <h1>Catálogo de Proveedores<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Proveedores</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-12">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre comercial:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txclave">Clave:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txclave" class="form-control" disabled="disabled" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txid">Id:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrazon">Razón social:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txrazon" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrfc">RFC:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txrfc" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcalle">Calle y numero:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcalle" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txcolonia">Colonia:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcolonia" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcp">CP:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcp" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txmunicipio">Municipio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txmunicipio" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dlestado">Estado:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestado" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Tipo de compra:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="3">Herramienta y equipo</option>
                                            <option value="1">Materiales</option>
                                            <option value="2">Servicios</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="dllinea">Tipo de servicio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dllinea" class="form-control">
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlcredito">Credito:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlcredito" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Contado</option>
                                            <option value="2">7 días</option>
                                            <option value="3">15 días</option>
                                            <option value="4">30 días</option>
                                            <option value="5">45 días</option>
                                            <option value="6">60 días</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-2 text-right">
                                        <label for="txlimite">Límite de credito:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txlimite" class="form-control" value="0"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlbanco">Banco:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlbanco" class="form-control">
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txclabe">CLABE:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txclabe" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="txcuenta">No. Cuenta:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcuenta" class="form-control" />
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-lg-2">

                                    </div>
                                    <div class="col-lg-3">
                                        <input type="button" value="Estados donde entrega" id="btestados" class="btn btn-info " />
                                    </div>
                                </div>
                            </div>
                            <div id="divmodal1">
                                <div class="row" style="height:250px;  overflow-y:scroll;">
                                    <table class="table table-condensed" id="tblistaestado">
                                        <thead>
                                            <tr>
                                                <th class="bg-navy"><span>Id</span></th>
                                                <th class="bg-navy"><span>Estados</span></th>
                                                <th class="bg-navy"><span>Aplica</span></th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                                <div class="row">
                                    <ol class="breadcrumb">
                                        <li id="btactualiza1" class="puntero"><a><i class="fa fa-save"></i>Actualizar y cerrar</a></li>
                                    </ol>
                                </div>
                            </div>
                             <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                                
                            </ol>
                        </div>
                    </div>
                    <div class="row" id="dvdetalle">
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txfuente">Buscar por:</label>
                            </div>
                            <div class="col-lg-2">
                                <select class="form-control" id="dlbusca">
                                    <option value="0">Seleccione...</option>
                                    <option value="id_proveedor">No. Proveedor</option>
                                    <option value="nombre">Nombre</option>
                                    <option value="rfc">RFC</option>
                                </select>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txbusca" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                            </div>
                        </div>
                        <div class="col-md-18 tbheader" id="dvtabla" style=" height:400px; overflow-y:scroll;">
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Clave</span></th>
                                        <th class="bg-navy"><span>Nombre</span></th>
                                        <th class="bg-navy"><span>Razón Social</span></th>
                                        <th class="bg-navy"><span>RFC</span></th>
                                        <th class="bg-navy"><span>Tipo de compra</span></th>
                                        <th class="bg-navy"><span>Tipo servicio</span></th>
                                        <th class="bg-navy"><span>Banco</span></th>
                                        <th class="bg-navy"><span>No. cuenta</span></th>
                                    </tr>
                                </thead>
                            </table>
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
                        <div class="row">
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                            </ol>
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
