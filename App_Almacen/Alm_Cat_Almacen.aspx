<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Cat_Almacen.aspx.vb" Inherits="App_Almacen_Alm_Cat_Almacen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ALMACÉN</title>
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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
    <style>
        #tblista thead th:nth-child(6), #tblista tbody td:nth-child(6),
        #tblista thead th:nth-child(7), #tblista tbody td:nth-child(7)
        {
        
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
            $('#dloficina').append(inicial);
            cargaoficina();
           // cuentaproducto();
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
                    // reset overflow
                    $('body').css('overflow', 'auto');
                }
            });
            $('#dvdatos').hide();
            $('#dltipo').change(function () {
                //cargaoficina();
            })
            $('#btnuevo').click(function () {x
                limpia();
            })
            $('#btnuevo1').click(function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
            })
            $('#btguarda').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var letra='A-'
                    if ($('#dltipo').val() == 2) {
                       letra='V-'
                    }
                    var xmlgraba = '<almacen id="' + $('#txid').val() + '" tipo = "' + $('#dltipo').val() + '" id_oficina = "' + $('#dloficina').val() + '" nombre = "' + $('#txnombre').val() + ''
                    xmlgraba += '" ubicacion = "' + $('#txnombree').val() + '" /> '
                    //alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        Swal.fire({
                            position: 'top-center',
                            icon: 'success',    
                            title: 'Registro completado',
                            showConfirmButton: false,
                            timer: 1500
                        })
                    }, iferror);
                }
            })
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        Swal.fire({
                            position: 'top-center',
                            icon: 'success',
                            title: 'Registro Eliminado',
                            showConfirmButton: false,
                            timer: 1800
                        })
                        limpia();
                        cargalista();
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else {
                    Swal.fire({
                        position: 'top-center',
                        icon: 'error',
                        title: 'Antes de eliminar debe elegir el nombre',
                        showConfirmButton: false,
                        timer: 1800
                    }) }
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
        });
        function limpia() {
            $('#txid').val(0);
            $('#dltipo').val(0);
            $('#dloficina').val(0);
            $('#txnombre').val('');
            $('#tnombree').val('');
            $('#txnombree').val('');
        }
        function valida
            () {
            if ($('#dltipo').val() == 0) {
                Swal.fire({
                    position: 'top-center',
                    icon: 'warning',
                    title: 'Debes capturar el tipo de almacen',
                    showConfirmButton: false,
                    timer: 1500
                })
                return false;
            }
            if ($('#dloficina').val() == 0) {
                //alert('Debe capturar el nombre');
                Swal.fire({
                    position: 'top-center',
                    icon: 'warning',
                    title: 'Debes capturar el tipo de oficina',
                    showConfirmButton: false,
                    timer: 1800
                })
                return false;
            }
            if ($('#txnombre').val() == 0) {
                //alert('Debe capturar el nombre');
                Swal.fire({
                    position: 'top-center',
                    icon: 'warning',
                    title: 'Debes capturar el nombre',
                    showConfirmButton: false,
                    timer: 1500
                } )
                return false;
            }
            if ($('#txnombree').val() == 0) {
                Swal.fire({
                    position: 'top-center',
                    icon: 'warning',
                    title: 'Debes capturar la ubicación',
                    showConfirmButton: false,
                    timer: 1500
                })
                return false;
            }
            return true;
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaproducto() {
            PageMethods.contaralmacen($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalista() {
            PageMethods.almacen($('#hdpagina').val(), function (res) { 
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    limpia();
                    $('#txid').val($(this).children().eq(0).text());
                    $('#idoficina').val($(this).children().eq(5).text());
                    cargaoficina();
                    $('#dltipo').val($(this).children().eq(6).text());
                    $('#txnombre').val($(this).children().eq(3).text());
                    $('#txnombree').val($(this).children().eq(4).text());
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                });
            }, iferror);
        };
        function cargaoficina() {
            PageMethods.oficina(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dloficina').empty();
                $('#dloficina').append(inicial);
                $('#dloficina').append(lista);
                $('#dloficina').val(0);
                if ($('#idoficina').val() != '') {
                    $('#dloficina').val($('#idoficina').val());
                };
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
        <asp:HiddenField ID="idoficina" runat="server" Value="0" />
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
                    <h1>Catálogo de Almacenes<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Almacenes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">

                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txid">Clave:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dltipo">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">General</option>
                                        <option value="2">Virtual</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dloficina">Oficina:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dloficina">
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombre" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnombree">Ubicación:</label>
                                </div>
                                <div class="col-lg-5">
                                    <input type="text" id="txnombree" class="form-control" />
                                </div>
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir al Listado</a></li>
                        </ol>
                    </div>
                    <div class="row" id="dvdetalle" style="height:300px; overflow-y:scroll">
                        <div class=" col-lg-18  tbheader" id="dvtabla" >
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Clave</span></th>
                                        <th class="bg-navy"><span>Tipo</span></th>
                                        <th class="bg-navy"><span>Oficina</span></th>
                                        <th class="bg-navy"><span>Nombre</span></th>
                                        <th class="bg-navy"><span>Ubicación</span></th>
                                    </tr>
                                </thead>
                            </table>    
                            
                        </div>
                    </div>
                    <div class=" row">
                        <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                        </ol>
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
                        </nav>-->
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>