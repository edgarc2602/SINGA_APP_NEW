<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Cat_productoprecio1.aspx.vb" Inherits="App_Compras_Com_Cat_productoprecio1" %>

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
            $('#btbuscap').click(function () {
                PageMethods.productol($('#txbusca').val(), function (res) {
                    var ren1 = $.parseHTML(res);
                    $('#tbbusca tbody').remove();
                    $('#tbbusca').append(ren1);
                    $('#tbbusca tbody tr').click(function () {
                        $('#txclave').val($(this).children().eq(0).text());
                        $('#txdesc').val($(this).children().eq(1).text());
                        $('#txunidad').val($(this).children().eq(2).text());
                        //cargaproveedor($('#txclave').val());
                        dialog1.dialog('close');
                    });
                }, iferror)
            })
            $('#btagrega').click(function () {
                if (valida()) {
                    PageMethods.guardaproveedor($('#txclave').val(), $('#dlproveedor').val(), $('#txprecio').val(), function () {
                        cargalista($('#dlproveedor').val());
                        limpiaproducto();
                    });
                }
            })
            $('#btguarda').click(function () {
                if ($('#tblista tbody tr').length != 0) {
                    var xmlgraba = ''
                    for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                        xmlgraba += '<partida clave="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" proveedor="' + $('#dlproveedor').val() + '" precio="' + parseFloat($('#tblista tbody tr').eq(x).find("input:eq(0)").val()) + '"/>'
                    }
                    PageMethods.guarda(xmlgraba, function () {
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#txclave').change(function () {
                //limpiaproducto();
                cargaproducto($('#txclave').val());
                //cargaproveedor($('#txclave').val());
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
        });
        function valida() {
            if ($('#dlproveedor').val() == 0) {
                alert('Debe elegir un Proveedor');
                return false;
            }
            if ($('#txclave').val() == '') {
                alert('Debe elegir la Clave del producto');
                return false;
            }
            
            if ($('#txprecio').val() == '') {
                alert('Debe capturar el precio');
                return false;
            }
            for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                if ($('#tblista tbody tr').eq(x).find('td').eq(0).text() == $('#txclave').val()) {
                    alert('El Producto ya esta registrado con un precio, no puede duplicar');
                    return false;
                }
            }
            return true;
        }
        function limpia(){
            $('#txclave').val('');
            $('#txdescripcion').val('');
            $('#txunidad').val('');
            
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
        function cargalista(clave) {
            PageMethods.materiales(clave, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren1);
                $('#tblista').delegate("tr .btquita", "click", function () {
                    PageMethods.elimina($(this).closest('tr').find('td').eq(0).text(), $('#dlproveedor').val() , function (res) {
                        cargalista($('#dlproveedor').val());
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
                $('#dlproveedor').change(function () {
                    cargalista($('#dlproveedor').val());
                })
            }, iferror);
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txunidad').val('');
            $('#txprecio').val('');
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
                    <h1>Precios de Productos por Proveedor<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Productos precios</li>
                    </ol>
                </div>
                <div class="content">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class="box-header">
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txclave">Proveedor</label>
                            </div>
                            <div class="col-lg-4">
                                <select class="form-control" id="dlproveedor"></select>
                                
                            </div>
                        </div>
                    </div>
                    <div class="row tbheader" style="height: 400px; overflow-y: scroll;">
                        <table class=" table table-condensed" id="tblista">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active" colspan="2">Clave</th>
                                    <th class="bg-light-blue-active">Descripción</th>
                                    <th class="bg-light-blue-active">Unidad</th>
                                    <th class="bg-light-blue-active">Precio</th>
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
                                        <input type="text" class=" form-control" id="txprecio"/>
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
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
