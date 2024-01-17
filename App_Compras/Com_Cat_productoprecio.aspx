<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Cat_productoprecio.aspx.vb" Inherits="App_Compras_Com_Cat_productoprecio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>PRECIOS DE PRODUCTOS</title>
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
        .tbborrar{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e801';
        }
        #tblista thead th:nth-child(1), #tblista tbody td:nth-child(1){
            width:0px;
            display:none;
        }
        #tblista thead th:nth-child(2), #tblista tbody td:nth-child(2){
            width:400px;
        }
        #tblista thead th:nth-child(3), #tblista tbody td:nth-child(3),
        #tblista thead th:nth-child(4), #tblista tbody td:nth-child(4){
            width:100px;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            proveedor();
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#txclave').change(function () {
                limpia();
                cargaproducto($('#txclave').val());
                cargaproveedor($('#txclave').val());
            })
            $('#btagrega').click(function () {
                if (valida()) {
                    PageMethods.guardaproveedor($('#txclave').val(), $('#dlproveedor').val(), $('#txprecio').val(), function () {
                        cargaproveedor($('#txclave').val());
                        limpia();
                    });
                }
            })
            $('#btguarda').click(function () {
                if ($('#tblista tbody tr').length != 0) {
                    var xmlgraba = ''
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        xmlgraba += '<partida clave="' + $('#txclave').val() + '" proveedor="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" precio="' + parseFloat($('#tblista tbody tr').eq(x).find("input:eq(0)").val()) + '"/>'
                    }
                    PageMethods.guarda(xmlgraba, function () {
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(),  function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        cargaproveedor($('#txclave').val());
                        dialog1.dialog('close');
                    });
                }, iferror)
            })
        });
        function valida() {
            if ($('#txclave').val() == '') {
                alert('Debe elegir la Clave del producto');
                return false;
            }
            if ($('#dlproveedor').val() == 0) {
                alert('Debe elegir un Proveedor');
                return false;
            }
            if ($('#txprecio').val() == '') {
                alert('Debe capturar el precio');
                return false;
            }
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('td').eq(0).text() == $('#dlproveedor').val()) {
                    alert('El Proveedor ya esta registrado con un precio, no puede duplicar');
                    return false;
                }
            }
            return true;
        }
        function limpia(){
            $('#dlproveedor').val(0);
            $('#txprecio').val('');
        }
        function cargaproducto(clave) {
            PageMethods.producto(clave, function (detalle) {
                var datos = eval('(' + detalle + ')');
                if (datos.clave != '0') {
                    $('#txclave').val(datos.clave);
                    $('#txdesc').val(datos.producto);
                    $('#txunidad').val(datos.unidad);
                } else {
                    alert('La clave de producto capturada no existe, verifique');
                    limpiaproducto();
                }
            })
        }
        function cargaproveedor(clave) {
            PageMethods.proveedor(clave, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                $('#tblista').delegate("tr .btquita", "click", function () {
                    PageMethods.elimina($('#txclave').val(), $(this).closest('tr').find('td').eq(0).text(), function (res) {
                        cargaproveedor($('#txclave').val());
                    });
                });
            });
        }
        function proveedor() {
            PageMethods.catproveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
            }, iferror);
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
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
        <asp:HiddenField ID="idunidad" runat="server" Value="0" />
        <asp:HiddenField ID="idfamilia" runat="server" Value="0" />
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
                    <h1>Precios de Productos<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Productos</li>
                    </ol>
                </div>
                <div class="content">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txclave">Clave</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" class=" form-control" id="txclave" />
                            </div>
                            <div class="col-lg-1">
                                <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                            </div>
                            <div class="col-lg-4">
                                <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" class=" form-control" disabled="disabled" id="txunidad" />
                            </div>
                        </div>
                    </div>
                    <div class="row tbheader" style="height: 400px; overflow-y: scroll;">
                        <table class=" table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active">Proveedor</th>
                                    <th class="bg-light-blue-active">Precio</th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                                <tr>
                                    <td>
                                        <select class="form-control" id="dlproveedor"></select>
                                    </td>
                                    <td>
                                        <input type="text" class="form-control" id="txprecio" />
                                    </td>
                                    <td>
                                        <input type="button" class="btn btn-primary" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Productos</a></li> -->
                    </ol>
                    <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label></div>
                                <div class="col-lg-5">
                                    <input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbuscap" />
                                </div>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
