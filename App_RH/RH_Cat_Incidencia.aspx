<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Incidencia.aspx.vb" Inherits="App_RH_RH_Cat_Incidencia" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE INCIDENCIAS</title>
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
        #tblista thead th:nth-child(6), #tblista tbody td:nth-child(6),
        #tblista thead th:nth-child(6), #tblista tbody td:nth-child(7){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            //$('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#dvdatos').hide();
            $('#dvformula').hide();
            $('#dvmonto').hide();
            $('#dltipo').change(function () {
                activa();
            })
            cargalista();
            $('#btguarda').click(function () {
                if (valida()) {
                    var formula = $('#dlvar1').val() +  $('#dloper1').val() + $('#txvar2').val()
                    var xmlgraba = '<incidencia id= "' + $('#txid').val() + '" descripcion= "' + $('#txdescripcion').val() + '" tipomov= "' + $('#dltipo1').val() + '" tipo= "' + $('#dltipo').val() + '"  monto= "' + $('#txmonto').val() + '" formula="' + formula + '"/>';
                    alert(xmlgraba)
                    PageMethods.guarda(xmlgraba, function (res) {
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btnuevo').click(function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btnuevo1').click(function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btelimina').on('click', function () {
                if ($('#txid').val() != '0') {
                    PageMethods.elimina($('#txid').val(), function (res) {
                        alert('Registro eliminado');
                        limpia();
                        cargalista();
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir una incidencia'); }
            })
        });
        function cargalista() {
            PageMethods.incidencia( function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    $('#txid').val($(this).children().eq(0).text());
                    $('#txdescripcion').val($(this).children().eq(1).text());
                    $('#dltipo1').val($(this).children().eq(6).text());
                    $('#dltipo').val($(this).children().eq(5).text());
                    if ($(this).children().eq(5).text() == 1) {
                        var var1 = $(this).children().eq(4).text().substring(0, 2);
                        var var2 = $(this).children().eq(4).text().substring(2, 3);
                        var var3 = $(this).children().eq(4).text().substring(3);
                        $('#dlvar1').val(var1);
                        $('#dloper1').val(var2);
                        $('#txvar2').val(var3);
                        //alert(var3);
                    } else {
                        $('#txmonto').val($(this).children().eq(4).text());
                    }
                    activa();
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500)
                    /*limpia();
                    
                    datosempleado();
                    ;*/
                });
            }, iferror);
        };
        function limpia() {
            $('#txid').val(0);
            $('#txdescripcion').val('');
            $('#dltipo1').val(0);
            $('#dltipo').val(0);
            $('#dlvar1').val(0);
            $('#dloper1').val(0);
            $('#txvar2').val('');
            $('#txmonto').val(0);
            $('#dvformula').hide();
            $('#dvmonto').hide();
        }
        function activa() {
            if ($('#dltipo').val() == 1) {
                $('#dvformula').show();
                $('#dvmonto').hide();
            } else {
                $('#dvformula').hide();
                $('#dvmonto').show();
            }
        }
        function valida() {
            if ($('#txdescripcion').val() == '') {
                alert('Debe capturar la descripción');
                return false;
            }
            if ($('#dltipo1').val() == 0) {
                alert('Debe elegir el tipo de incidencia');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe elegir el tipo de operación');
                return false;
            }
            if ($('#dltipo').val() == 2) {
                if ($('#txmonto').val() == 0 || $('#txmonto').val() == '') {
                    alert('Debe capturar un monto');
                    return false;
                } 
            } else {
                if ($('#dlvar1').val() == 0) {
                    alert('La formula debe contener todos los elementos');
                    return false;
                }
                if ($('#dloper1').val() == 0) {
                    alert('La formula debe contener todos los elementos');
                    return false;
                }
                if ($('#txvar2').val() == '') {
                    alert('La formula debe contener todos los elementos');
                    return false;
                }
            }
            return true;
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
                                    <span class="hidden-xs"></span>
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
                    <h1>Catálogo de Incidencias<small>Recursos Humanos</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Recursos Humanos</a></li>
                        <li class="active">Catálogo de Incidencias</li>
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
                                     <div class="col-lg-5 text-right">
                                        <label for="txid">Id:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">Descripción:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <input type="text" id="txdescripcion" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo1">Tipo:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo1" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Deducción </option>
                                            <option value="2">Percepción</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dltipo">Operacion:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Formula</option>
                                            <option value="2">Monto</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row" id="dvmonto">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmonto">Importe:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txmonto" class="form-control" value="1" />
                                    </div>
                                </div>
                                <div class="row" id="dvformula">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlvar1">Formula:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <select id="dlvar1" class="form-control">
                                            <option value="SD">SD</option>
                                            <option value="SM">SH</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <select id="dloper1" class="form-control">
                                            <option value="+">+</option>
                                            <option value="-">-</option>
                                            <option value="*">*</option>
                                            <option value="/">/</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txvar2" class="form-control" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Incidencias</a></li>
                                </ol>
                            </div>
                            
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Descripción</span></th>
                                            <th class="bg-navy"><span>Tipo</span></th>
                                            <th class="bg-navy"><span>Operación</span></th>
                                            <th class="bg-navy"><span>Monto/Formula</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
