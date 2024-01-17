<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Alm_Pro_CargaProducto.aspx.vb" Inherits="App_Almacen_Alm_Pro_CargaProducto" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Carga Datos Producto</title>
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
        #tblistaj tbody td:nth-child(10),#tblistaj tbody td:nth-child(9){
            width: 0px;
            display: none;
        }        
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecha1').datepicker({ dateFormat: 'dd/mm/yy' });
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            var f = new Date();
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            cargalista();
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 350,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            $('#dvdatos').hide();

            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();   
                $('#dvdatos').hide();
            })
            $('#btbusca').click(function () {
                $("#divmodal1").dialog('option', 'title', 'Elegir Producto');
                dialog1.dialog('open');
            })
            $('#btbuscap').click(function () {
                        PageMethods.productol(2,$('#txbusca').val(), function (res) {
                            var ren1 = $.parseHTML(res);
                            $('#tbbusca tbody').remove();
                            $('#tbbusca').append(ren1);
                            $('#tbbusca tbody tr').click(function () {
                                $('#txclave').val($(this).children().eq(0).text());
                                $('#txdesc').val($(this).children().eq(1).text());
                                dialog1.dialog('close');
                            });
                        }, iferror)
                    
            })
            $('#btagrega').click(function () {
                var ace = document.getElementById("txaccesorio").value;
                var mar = document.getElementById("txmarca").value;
                var combo = document.getElementById("txmarca");
                var marca = combo.options[combo.selectedIndex].text;
                var combo = document.getElementById("txaccesorio");
                var accesorio = combo.options[combo.selectedIndex].text;
                var linea = '<tr><td>' + $('#txclave').val() + '</td><td></td><td>' + $('#txdesc').val() + '</td><td>' + $('#txnserie').val() + '</td><td>' + $('#txmodelo').val() + ' </td><td>'
                linea += marca + '</td><td>' + accesorio + '</td><td>' + ' <input type="button" value="Quitar" class="btn btn-danger btquita"/></td><td>' + mar + '</td><td>' + ace + '</td></tr>';
                    $('#tblistaj tbody').append(linea); 
                    $('#tblistaj').delegate("tr .btquita", "click", function () {
                        $(this).parent().eq(0).parent().eq(0).remove(); 
                    });
                    limpiaproducto();
                
            })
            $('#btguarda').click(function () {
                alert(''); {
                    var fecha = $('#txfecha1').val().split('/');
                    var fcompra = fecha[2] + fecha[1] + fecha[0];
                    var xmlgraba = '<movimiento> <fcompra ="' + fcompra + '"';
                    $('#tblistaj tbody tr').each(function () {
                        xmlgraba += '<partida clave="' + $(this).closest('tr').find('td').eq(0).text() + '" nserie="' + $(this).closest('tr').find('td').eq(3).text()+ '"';
                        xmlgraba += ' modelo="' + $(this).closest('tr').find('td').eq(4).text() + '" marca ="' + $(this).closest('tr').find('td').eq(8).text() + '" accesorio="' + $(this).closest('tr').find('td').eq(9).text() + '"/>'
                    })
                    xmlgraba += '</movimiento>';
                    alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txfolio').val(res);
                        alert('Registro completado');

                    }, iferror);
                }
            });


        });

        function valida() {
            if ($('#tblista tbody tr').length == 0) {
                alert('Debe capturar al menos un material');
                return false;
            }
            return true;
        }
        function limpiaproducto() {
            $('#txclave').val('');
            $('#txdesc').val('');
            $('#txnserie').val('');
            $('#txmodelo').val('');
            $('#txmarca').val(0);
            $('#txaccesorio').val(0);
        }
        function cargalista() {
            PageMethods.almacen($('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    $('#dvtabla').hide();
                    $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    $('#txid').val($(this).children().eq(0).text());
                    cargaorden();
                });
            }, iferror);
        };

        function cargaorden() {
            PageMethods.detalleoc($('#txid').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblistad tbody').remove();
                $('#tblistad').append(ren); 
            }, iferror);
        };

        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }
        function closeWaitingDialog() {
            $("#loadingScreen").dialog('close');
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
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
                    <%--<%=listamenu%>--%>
                </div>
                <!-- /.sidebar -->
            </div>
            <div class="content-wrapper"> 

                 <div class="content-header">
                    <h1>Carga Datos<small>producto</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Almacen</a></li>
                        <li class="active">Carga Productos</li>
                    </ol>                 
                    <div class="row" id="dvdatos">
                        <!-- Horizontal Form -->
                        <div class="box box-info">
                            <div class="box-header">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                
                                <div class="col-lg-1 text-right">
                                    <label for="txid">No Orden:</label>
                                </div>  
                                 <div class="col-lg-2">
                                    <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                </div>      
                            </div>    
                            <div class="row">
                                 <div class="col-lg-1 text-right">
                                    <label for="txfecha1">Fecha compra:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfecha1" class="form-control" />
                                </div>                  
                             <div class="row" id="dvdetalle1" style="height:300px;  overflow-y: scroll;">
                            <div class=" col-lg-14  tbheader" id="dvtablad" >
                            <table class="table table-condensed" id="tblistad">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Clave</span></th>
                                        <th class="bg-navy"><span>Producto</span></th>
                                        <th class="bg-navy"><span>Unidad</span></th>
                                        <th class="bg-navy"><span>Cantidad</span></th>
                                        <th class="bg-navy"><span>Total</span></th>                                       
                                    </tr>
                                </thead>
                            </table>                               
                            </div>
                            </div>                          
                        </div>
                      </div> 
                        <div class="row tbheader" style="height:auto; overflow: auto;">
                        <table class=" table table-condensed h6" id="tblistaj">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-active" colspan="2">Clave</th>
                                    <th class="bg-light-blue-active">Descripción</th>
                                    <th class="bg-light-blue-active">No Serie</th>
                                    <th class="bg-light-blue-active">Modelo</th>
                                    <th class="bg-light-blue-active">Marca</th>
                                    <th class="bg-light-blue-active">Accesorio</th>
                                </tr>
                                <tr>
                                    <td class=" col-xs-1">
                                        <input type="text" class=" form-control text-right" id="txclave" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="button" class="btn btn-primary" value="buscar" id="btbusca" />
                                    </td>
                                    <td class="col-xs-2">
                                        <textarea class="form-control" disabled="disabled" id="txdesc"></textarea>
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control text-right" id="txnserie" />
                                    </td>
                                    <td class="col-xs-1">
                                        <input type="text" class=" form-control text-right" id="txmodelo" />
                                    </td>
                                    <td class="col-xs-1">
                                        <select id="txmarca" name="txmarca" onchange="ShowSelected()" class="selectpicker form-control" >
                                        <option value="0">Seleccione </option>
                                        <option value="1">A </option>
                                        <option value="2">B</option>
                                        <option value="3">C</option>
                                        </select>
                                    </td>
                                    <td class="col-xs-1">
                                        <select id="txaccesorio" name="txmarca" onchange="ShowSelected()" class="selectpicker form-control">
                                        <option value="0">Seleccione </option>
                                        <option value="1">N/A </option>
                                        <option value="2">C/Accesorios</option>
                                        <option value="3">S/Accesorios</option>
                                        </select>
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
                            <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir al Listado</a></li>
                        </ol>
                         <div id="divmodal1">
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txbusca">Buscar</label>
                                </div>
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
                <div class="row" id="dvdetalle" style="height:auto; overflow-y:scroll">
                        <div class=" col-lg-18  tbheader" id="dvtabla" >
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>No Orden</span></th>
                                        <th class="bg-navy"><span>No Req</span></th>
                                        <th class="bg-navy"><span>Estatus</span></th>
                                        <th class="bg-navy"><span>Total</span></th>
                                        <th class="bg-navy"><span>Almacen Entrada</span></th>
                                        <th class="bg-navy"><span>Cliente</span></th>
                                     
                                    </tr>
                                </thead>
                            </table>    
                            
                        </div>
                    </div>
                    <div class="content">
                    <ol class="breadcrumb">
                            <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>
                        </ol>
                   </div>   
            </div>
        </div>
   </div> 
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
