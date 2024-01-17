<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Webhooks.aspx.vb" Inherits="Ventas_App_Ven_Webhooks" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CATALOGO DE CLIENTES</title>
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
            $('#dvdatos').hide();
            $('#txtotdocto').val('50000');
            //const apiUrl = 'http://singa.com.mx:8089/api/DocumentoNuevo';
            const apiUrl = 'https://localhost:5001/api/DocumentoNuevo';
            const username = 'usrbatia';
            const password = 'pswb4t1a';
            const credentials = btoa(username + ':' + password);
            alert("apiUrl: " + apiUrl)
            $.ajax({
                url: apiUrl,
                type: 'GET',
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('Authorization', 'Basic ' + credentials);
                },
                success: function (data) {
                    const userList = $('#user-list');

                    $.each(data, function (index, datos) {
                        //alert("RFC: " + datos.rfc)
                        //alert("Datos: " + datos)

                        $('#txid').val(datos.id);
                        $('#txrfc').val(datos.rfc);
                        $('#txrazon').val(datos.razon);
                        $('#txrfcreceptor').val(datos.rfcreceptor);
                        //const listItem = $('<li>').text(`${user.firstName} ${user.lastName}`);
                        const listItem = $('<li>').text('${user.emitterTaxId} ${user.emitter}');
                        userList.append(listItem);
                    });
                },
                error: function (error) {
                    console.error('Error al obtener los datos:', error);
                }
            });
            //datosfactura();
            $('#txtipodocto').val('pruebatipo');
            $('#dvtabla').hide();
            $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
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
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfbaja').datepicker({ dateFormat: 'dd/mm/yy' });

            /*$('#txid').val($('#idcliente1').val());*/
                
            
            $('#btbusca').click(function () {
                cuentacliente();
                asignapagina(1)
                //cargalista();
            })

        });
        //FIN FUNCION PRINCIPAL

        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };


        function datosfactura()
        {
            PageMethods.factura(function (detalle)
            {
                var datos = eval('(' + detalle + ')');
                alert("RFC: " + datos.rfc)
                alert("Datos: " + datos)

                $('#txid').val(datos.id);
                $('#txrfc').val(datos.rfc);
                $('#txrazon').val(datos.razon);
                $('#txrfcreceptor').val(datos.rfcreceptor);

                //PageMethods.galleta($('#txid').val(), function (detalle) {
                //});
            }, iferror);

        };
        //$.get(apiUrl, function (data) {
        //    const userList = $('#user-list');

        //    $.each(data, function (index, user) {
        //        const listItem = $('<li>').text(`${user.emitterTaxId} ${user.emitter}`);
        //        userList.append(listItem);
        //    });
        //}).fail(function (error) {
        //    console.error('Error al obtener los usuarios:', error);
        //});

       
        
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

    <ul id="user-list"></ul>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <!--<asp:HiddenField ID="idcliente" runat="server" />-->
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" Value="0" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idencargado" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
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
                    <h1>Prueba consumo de API<small>Ventas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Ventas</a></li>
                        <li class="active">Prueba consumo de API</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-10">
                            <!-- Horizontal Form -->
                            <div class="box box-info     ">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">ID:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txrfc">RFC del Emisor:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txrfc" class="form-control" disabled="disabled" value="0" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txrazon">Razon Social:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txrazon" class="form-control" disabled="disabled" value="0" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrfcreceptor">RFC Receptor:</label>
                                    </div>
                                    <div class="col-lg-7">
                                        <input type="text" id="txrfcreceptor" class="form-control" />
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txrazonreceptor">Razón social del receptor:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txrazonreceptor" class="form-control" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txfeemision">Fecha y hora de emisión del documento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txfeemision" class="form-control" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtotdocto">Total del documento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txtotdocto" class="form-control" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txvercfdi">Versión del CFDI:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txvercfdi" class="form-control" />
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txfoliodocto">Folio del Documento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txfoliodocto" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txseriedocto">Serie del Documento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txseriedocto" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmoneda">Código de la moneda del catálogo ISO:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txmoneda" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtipocambio">Tipo de Cambio:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txtipocambio" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                   <div class="col-lg-2 text-right">
                                        <label for="txcargadoapi">Documento cargado por API:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcargadoapi" class="form-control" />
                                    </div>

                                    <div class="col-lg-2 text-right">
                                        <label for="txtipodocto">Tipo de documento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txtipodocto" class="form-control" />
                                    </div>

                                    <div class="col-lg-1">
                                        <label for="txrefpago">referencia del pago:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txrefpago" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txfecini">F. Inicio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecini" class="form-control" />
                                    </div>
                                </div>
                                
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Clientes</a></li>
                                </ol>
                                <div class="box-footer">
                                    <input type="button" class="btn btn-primary" value="Oficinas" id="btoficinas" />
                                    <input type="button" class="btn btn-primary" value="Líneas de negocio" id="btlineas" />
                                    <input type="button" class="btn btn-primary" value="Puntos de atención" id="btinmueble" />
                                    <input type="button" class="btn btn-primary" value="Igualas" id="btiguala" />
                                    <input type="button" class="btn btn-primary" value="Plantilla" id="btplantilla" />
                                    <input type="button" class="btn btn-primary" value="Listados de Material" id="btlistamaterial" />
                                    <input type="button" class="btn btn-primary" value="Materiales autorizados" id="tblistaauto" />
                                    <input type="button" class="btn btn-primary" value="Materiales" id="btmaterial" />
                                    <input type="button" class="btn btn-primary" value="Herr. y eq." id="btherr" />
                                    <input type="button" class="btn btn-primary" value="Otros eq." id="btotroeq" />
                                    <input type="button" class="btn btn-primary" value="Subcontratos" id="btsubcontrato" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="01">Enero</option>
                                        <option value="02">Febrero</option>
                                        <option value="03">Marzo</option>
                                        <option value="04">Abril</option>
                                        <option value="05">Mayo</option>
                                        <option value="06">Junio</option>
                                        <option value="07">Julio</option>
                                        <option value="08">Agosto</option>
                                        <option value="09">Septiembre</option>
                                        <option value="10">Octubre</option>
                                        <option value="11">Noviembre</option>
                                        <option value="12">Diciembre</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca"/>
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Ejecutivo</span></th>
                                            <th class="bg-navy"><span>F. Inicio</span></th>
                                            <th class="bg-navy"><span>Contacto</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Telefono</span></th>
                                            <th class="bg-navy"><span>Estatus</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                </ol>
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
            </div>
            <div id="divmodal" class="col-md-18">
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Fecha de baja:</label>
                    </div>
                    <div class="col-lg-3">
                        <input type="text" class="form-control" id="txfbaja"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Comentarios:</label>
                    </div>
                    <div class="col-lg-8">
                        <textarea id="txcomentario" class="form-control"></textarea>
                    </div>
                </div>
                <div class="box-footer">
                    <input type="button" class="btn btn-primary pull-right" value="Actualizar" id="btbaja" />
                </div>
            </div>  
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>

