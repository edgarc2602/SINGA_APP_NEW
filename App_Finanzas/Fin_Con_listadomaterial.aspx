﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Con_listadomaterial.aspx.vb" Inherits="App_Finanzas_Fin_Con_listadomaterial" %>

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
        #tblistaa tbody td:nth-child(2){
            width:0px;
            display:none;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        var final = '<option value=99>PROVEEDOR</option>'
        var final1 = '<option value=100>ALMACEN</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            $('#txfentrega').datepicker({ dateFormat: 'dd/mm/yy' });
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
            
            dialog1 = $('#divmodal1').dialog({
                autoOpen: false,
                height: 550,
                width: 900,
                modal: true,
                close: function () {
                }
            });
            cargacliente();
            cargames();
            $('#btmostrar').click( function(){
                cargaptto();
                cuentalistados();
                cargalistados();
            })
            /*
            $('#btimprime').click(function () {
                var formula = '{tb_cliente_inmueble.id_cliente}=' + $('#dlcliente').val() + ' and {tb_listadomaterial.mes} =' + $('#dlmes').val() + ' and {tb_listadomaterial.anio}=' + $('#txanio').val()  
                window.open('../RptForAll.aspx?v_nomRpt=listadomatriz.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })*/
            $('#btdescarga').click(function () {
                alert('Proceso en desarrollo');
                /*
                var formula = '{tb_cliente_inmueble.id_cliente}=' + $('#dlcliente').val() + ' and {tb_listadomaterial.mes} =' + $('#dlmes').val() + ' and {tb_listadomaterial.anio}=' + $('#txanio').val()
                window.open('../RptForAll.aspx?v_nomRpt=listadoconcentrado.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                */
            })
            /*
            $('#btexporta').click(function () {
                window.open('Ope_Descarga_listado.aspx?cliente=' + $('#dlcliente').val() + '&mes=' + $('#dlmes').val() + '&anio=' + $('#txanio').val(), '_blank');
            })
            
            $('#btautoriza').click(function () {
                PageMethods.autoriza($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(),2, function (res) {
                    cargalistados();
                    alert('Todos los listados se han autorizado');

                }, iferror);
            })*/
            $('#btlibera').click(function () {
                PageMethods.autoriza($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(),1, function (res) {
                    cargalistados();
                    alert('Todos los listados se han liberado');

                }, iferror);
            })
            $('#btimprime1').click(function () {
                var formula = '{tb_listadomaterial.id_listado}=' + $('#lbfolio').text();
                window.open('../RptForAll.aspx?v_nomRpt=listadoentrega.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btacuse1').click(function () {
                if (validacierre()) {
                    PageMethods.cierra($('#dloperador').val(), $('#txfentrega').val(), $('#lbfolio1').text(), function (res) {
                        alert('El listado se ha marcado como entregado');
                        dialog1.dialog('close');
                        //cargaacuses($('#lbfolio1').text());
                        cargalistados();
                        closeWaitingDialog();
                    }, iferror);
                }
                //var archivo = $(this).closest('tr').find('td').eq(2).text();
                //window.open('../Doctos/entrega/' + $('#acuse').val(), '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
            })
        });
        function cuentalistados() {
            PageMethods.contarlistados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dlsucursal').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargalistados() {
            PageMethods.listados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#hdpagina').val(), $('#dlsucursal').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                /*
                $('#tblista tbody tr').on('click', '.btver', function () {
                    $('#lbfolio').text($(this).closest('tr').find('td').eq(2).text());
                    $('#lbinmueble').text($(this).closest('tr').find('td').eq(1).text());
                    $('#lbtipo').text($(this).closest('tr').find('td').eq(3).text());
                    PageMethods.listadod($(this).closest('tr').find('td').eq(2).text(), function (res) {
                        var ren1 = $.parseHTML(res);
                        $('#tblistaj tbody').remove();
                        $('#tblistaj').append(ren1);
                    }, iferror);
                    $("#divmodal").dialog('option', 'title', 'Detalle de materiales');
                    dialog.dialog('open');
                });*/
                $('#tblista tbody tr').on('click', '.btacuse', function () {
                    $('#lbfolio1').text($(this).closest('tr').find('td').eq(2).text());
                    $('#lbinmueble1').text($(this).closest('tr').find('td').eq(1).text());
                    $('#lbtipo1').text($(this).closest('tr').find('td').eq(3).text());
                    cargaacuses($(this).closest('tr').find('td').eq(2).text());
                    //alert($(this).closest('tr').find('td').eq(10).text());
                    //$('#acuse').val($(this).closest('tr').find('td').eq(10).text());
                    /*if ($(this).closest('tr').find('td').eq(4).text() == 'Entregado') {
                        $('#dvcierre').hide();
                        $('#dvcarga').hide();
                    } else {
                        $('#dvcierre').show();
                        $('#dvcarga').show();
                    }*/
                    $("#divmodal1").dialog('option', 'title', 'Acuses de entrega');
                    dialog1.dialog('open');
                    
                });
                
            }, iferror );
        }
        function cargaacuses(listado) {
            PageMethods.listadoa(listado, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaa tbody').remove();
                $('#tblistaa').append(ren1);
                $('#tblistaa tbody tr').on('click', '.btver', function () {
                    //alert($(this).closest('tr').find('td').eq(1).text());
                    var carpeta = $(this).closest('tr').find('td').eq(1).text();
                    var arc = $(this).closest('tr').find('td').eq(2).text();
                    window.open('../Doctos/entrega/' + carpeta + '/' + arc, '_blank', 'width=650, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                });
            }, iferror);
        }
        function cargaptto() {
            PageMethods.ptto($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txtotinm').val(datos.totinm);
                $('#txtotlis').val(datos.totlis);
                $('#txtotlisc').val(datos.totlisc);
                //$('#txptto').val(datos.totptto);
                //$('#txpttou').val(datos.totuti);
            }, iferror);
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
                    //$('#tblista table tbody').remove();
                    cargainmueble($('#dlcliente').val());
                });
                /*
                $('#dlcliente').change(function () {
                    cargalista();
                });
                */
            }, iferror);
        }
        function cargainmueble(idcte) {
            PageMethods.inmueble(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);

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
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalistados();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        
        function validacierre() {
            if ($('#txfentrega').val() == '') {
                alert('Debe seleccionar la fecha de entrega');
                return false;
            }
            if ($('#dloperador').val() == 0) {
                alert('Debe seleccionar el operador que entrega');
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="acuse" runat="server" />
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
                    <h1>Consulta de Listados de materiales<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Listados de materiales</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlsucursal">Punto de atención:</label>
                                </div>
                                <div class="col-lg-4">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlmes">Mes:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btmostrar" class="btn btn-primary" value="mostrar" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txtotinm">Puntos de atención:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotinm" class="form-control text-right" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txtotlis text-right">Listados creados:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotlisc" class="form-control text-right" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txtotlis text-right">Listados entregados:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotlis" class="form-control text-right" />
                                </div>
                            </div>
                            <!--
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txptto">Presupuesto global:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txptto" class="form-control text-right" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txpttou">Total a utilizar:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpttou" class="form-control text-right" />
                                </div>
                            </div>
                            -->
                        </div>
                        <div class="tbheader" style="height: 300px; overflow-y: scroll;">
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Nombre</span></th>
                                        <th class="bg-navy"><span>Listado</span></th>
                                        <th class="bg-navy"><span>Tipo</span></th>
                                        <th class="bg-navy"><span>Estatus</span></th>
                                        <th class="bg-navy"><span>Presupuesto</span></th>
                                        <th class="bg-navy"><span>Utilizado</span></th>
                                        <th class="bg-navy"><span>Disponible</span></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <ol class="breadcrumb">
                            <!--<li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                            <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir Matriz</a></li>-->
                            <li id="btdescarga" class="puntero"><a><i class="fa fa-print"></i>Descargar acuses comprimidos</a></li>
                            <!--<li id="btautoriza"  class="puntero"><a ><i class="fa fa-edit"></i>Aprobar</a></li>
                            <li id="btlibera"  class="puntero"><a ><i class="fa fa-undo"></i>Liberar</a></li>-->
                        </ol>
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
                    
                    <div id="divmodal1">
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Listado:</label>
                            </div>
                            <div class="col-lg-2">
                                <label id="lbfolio1"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Punto de atención:</label>
                            </div>
                            <div class="col-lg-6">
                                <label id="lbinmueble1"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Tipo:</label>
                            </div>
                            <div class="col-lg-6">
                                <label id="lbtipo1"></label>
                            </div>
                        </div>
                        <hr />
                        <div class="row">
                            <div class="row">
                                <div class="col-lg-3">
                                    <label for="dlbanco">Acuces Cargados:</label>
                                </div>
                                <div id="dvarchivos" class="tbheader col-lg-6" style="height: 200px; overflow-y: scroll;">
                                    <table class=" table table-condensed h6" id="tblistaa">
                                        <thead>
                                            <tr>
                                                <th class="bg-light-blue-active">Listado</th>
                                                <th class="bg-light-blue-active">Acuse</th>
                                                <th class="bg-light-blue-active"></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
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