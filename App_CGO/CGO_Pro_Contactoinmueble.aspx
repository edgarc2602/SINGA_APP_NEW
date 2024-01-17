<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Contactoinmueble.aspx.vb" Inherits="App_CGO_CGO_Pro_Contactoinmueble" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONTACTO DE INMUEBLES</title>
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
        var inicial = '<option selected="selected" value="0">Seleccione...</option>';
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
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
            $('#dvdatos').hide();
            cargacliente();
            $('#btmostrar').click(function () {
                cargainmueble();
            })
            $('#btlista').on('click', function () {
                cargainmueble()
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btguarda').click(function () {
                waitingDialog({});
                var xmlgraba = '<contactoinm id= "' + $('#txid').val() + '" contacto = "' + $('#txcontacto').val() + '" tel1= "' + $('#txtel1').val() + '" tel2 = "' + $('#txtel2').val() + '" correo = "' + $('#txcorreo').val() + '" /> '
                PageMethods.guarda(xmlgraba, function () {
                    closeWaitingDialog();
                    alert('Registro completado.');
                }, iferror);
            })
            $('#btimprime').click(function () {
                var formula = '{tb_cliente_inmueble.id_status} = 1 and {tb_cliente_inmueble.id_cliente} = ' + $('#dlcliente').val()
                if ($('#dlestado').val() != 0) {
                    formula = formula + ' and {tb_cliente_inmueble.id_estado} = ' + $('#dlestado').val()
                }
                
                window.open('../RptForAll.aspx?v_nomRpt=inmueblecontacto.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btimprime1').click(function () {
                var formula = '{tb_cliente_inmueble.id_status} = 1 and {tb_cliente_inmueble.id_cliente} = ' + $('#dlcliente').val()
                if ($('#dlestado').val() != 0) {
                    formula = formula + ' and {tb_cliente_inmueble.id_estado} = ' + $('#dlestado').val()
                }
               
                window.open('../RptForAll.aspx?v_nomRpt=inmueblecontacto.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        })
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').empty();
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').change(function () {
                    cargaestado();
                })
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
        function cargainmueble() {
            PageMethods.inmueble($('#dlcliente').val(), $('#dlestado').val(), function (res) {
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista  tbody tr').on('click', function () {
                        $('#txid').val($(this).children().eq(0).text());
                        $('#txinmueble').val($(this).children().eq(1).text());
                        $('#txcontacto').val($(this).children().eq(2).text());
                        $('#txtel1').val($(this).children().eq(3).text());
                        $('#txtel2').val($(this).children().eq(4).text());
                        $('#txcorreo').val($(this).children().eq(5).text());
                        $('#dvtabla').hide();
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    });
                }
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
        <asp:HiddenField ID="idusuario" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" />
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
                    <h1>Contactos de puntos de atención
                        <small>CGO</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Contactos</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlestado">Estado:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlestado" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btmostrar" class="btn btn-primary" value="mostrar" />
                                </div>
                            </div>
                        </div>
                        <div class="box box-info" id="dvdatos">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txid">Id:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txid" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Punto de atención:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txinmueble" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcontacto">Contacto:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txcontacto" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txtel1">Telefono1:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtel1" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txtel2">Telefono2:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtel2" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txcorreo">Correo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcorreo" class="form-control" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Puntos de atención</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-save"></i>Imprimir listado</a></li>
                            </ol>
                        </div>
                        <div class="col-md-18 tbheader" style="height: 350px; overflow-y: scroll;" id="dvtabla">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Id</span></th>
                                        <th class="bg-light-blue-gradient"><span>Punto de atención</span></th>
                                        <th class="bg-light-blue-gradient"><span>Contacto</span></th>
                                        <th class="bg-light-blue-gradient"><span>Telefono1</span></th>
                                        <th class="bg-light-blue-gradient"><span>Telefono2</span></th>
                                        <th class="bg-light-blue-gradient"><span>Correo</span></th>
                                    </tr>
                                </thead>
                            </table>
                            <ol class="breadcrumb">
                                <li id="btimprime1" class="puntero"><a><i class="fa fa-save"></i>Imprimir listado</a></li>
                            </ol>
                        </div>
                        <!--
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
                        -->
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
