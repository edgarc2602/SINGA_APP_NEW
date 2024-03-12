<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Rep_Razonsocial.aspx.vb" Inherits="App_Finanzas_Fin_Rep_Razonsocial" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ANTIGUEDAD DE SALDOS PROVEEDORES</title>
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
    <script>
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            cargacliente();
            cargaestado();
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
            $('#btimprime').click(function () {
                var formula = '{tb_cliente.id_status} = 1';
                window.open('../RptForAll.aspx?v_nomRpt=clienterazonsocial.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btagrega').click(function () {
                if (valida()) {
                    waitingDialog({});
                    var xmlgraba = '<razon cliente="' + $('#dlcliente').val() + '" rfc="' + $('#txrfc').val() + '" razonsocial="' + $('#txrazon').val() + '"';
                    xmlgraba += ' calle="' + $('#txcalle').val() + '" noext="' + $('#txnoext').val() + '" noint="' + $('#txnoint').val() + '"';
                    xmlgraba += ' colonia="' + $('#txcolonia').val() + '" deleg="' + $('#txmunicipio').val() + '" cp="' + $('#txcp').val() + '"';
                    xmlgraba += ' estado= "' + $('#dlestado').val() + '" />'                    
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        limpiadatos();
                        cargarazon();
                    }, iferror);
                }
            })
        })
        function limpiadatos() {
            $('#txrfc').val('')
            $('#txrazon').val('')
            $('#txcalle').val('')
            $('#txnoext').val('')
            $('#txnoint').val('')
            $('#txcolonia').val('')
            $('#txmunicipio').val('')
            $('#txcp').val('')
            $('#dlestado').val(0)
        }
        function valida() {
            if ($('#txrfc').val() == '') {
                alert('Debe capturar el RFC');
                return false;
            }
            if ($('#txrazon').val() == '') {
                alert('Debe capturar la razón social');
                return false;
            }
            if ($('#txcalle').val() == '') {
                alert('Debe capturar la calle');
                return false;
            }
            if ($('#txnoext').val() == '') {
                alert('Debe capturar el numero exterior');
                return false;
            }
            if ($('#txcolonia').val() == '') {
                alert('Debe capturar la colonia');
                return false;
            }
            if ($('#txmunicipio').val() == '') {
                alert('Debe capturar el municipio');
                return false;
            }
            if ($('#txcp').val() == '') {
                alert('Debe capturar el código postal');
                return false;
            }
            if ($('#dlestado').val() == 0) {
                alert('Debe capturar el estado');
                return false;
            }
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('td').eq(0).text() == $('#txrfc').val()) {
                    alert('Este RFC ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            return true;
        }
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
                    cargarazon();
                })
            }, iferror);
        }
        function cargaestado() {
            PageMethods.estado(function (opcion) {
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
        function cargarazon() {
            PageMethods.razon($('#dlcliente').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                $('#tblista').delegate("tr .btquita", "click", function () {
                    PageMethods.elimina($(this).closest('tr').find('td').eq(0).text(), function () {
                        $(this).parent().eq(0).parent().eq(0).remove();
                        cargarazon();
                    }, iferror);                                        
                });
            }, iferror)
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
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
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
                    <h1>Razones sociales de clientes<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Clientes</a></li>
                        <li class="active">Finanzas</li>
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
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txrfc">RFC:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txrfc" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txrazon">Razón social:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txrazon" class="form-control" />
                                </div>                                
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txcalle">Calle:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcalle" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txnoext">No. ext:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoext" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txnoint">No. int:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoint" class="form-control" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txcolonia">Colonia:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txcolonia" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txcp">C.P.:</label>
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
                                <div class="col-lg-2 text-right">
                                    <label for="dlestado">Estado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlestado"></select>
                                </div>                                
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <input type="button" id="btagrega" class="btn btn-primary " value="Agregar" />
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>RFC</span></th>
                                            <th class="bg-navy"><span>Razón social</span></th>
                                            <th class="bg-navy"><span>Domicilio</span></th>                                            
                                            <th class="bg-navy"></th>
                                        </tr>
                                    </thead>
                                </table>                                
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>                                
                                <li id="btimprime" class="puntero"><a><i class="fa fa-navicon"></i>Imprimir listado</a></li>                                
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
