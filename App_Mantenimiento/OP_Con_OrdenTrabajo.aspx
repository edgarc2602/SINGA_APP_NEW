<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OP_Con_OrdenTrabajo.aspx.vb" Inherits="App_Mantenimiento_OP_CON_OrdenTrabajo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA ORDEN DE TRABAJO</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
       <link href="App.Mantenimiento.css" rel="stylesheet" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>

     <style type="text/css">
        .deshabilita {
            pointer-events: none;
            opacity: 0.4; /* Cambia la opacidad para dar una apariencia de deshabilitado */
        }
                  /* Estilo para filas pares */
        tr:nth-child(even) {
          background-color: #f2f2f2;
        }

        /* Estilo para filas impares */
        tr:nth-child(odd) {
          background-color: #ffffff;
        }
    </style>

    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);

            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 400,
                width: 700,
                modal: true,
                close: function () {
                }
            });

            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#dlsucursal').append(inicial);
            $('#dlcliente').append(inicial);
            $('#dlestatus').append(inicial);
            var f = new Date();
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecini').val('01' + "/" + mm + "/" + f.getFullYear());
            $('#txfecfin').val(f.getDate() + "/" + mm + "/" + f.getFullYear());
            //cargames();
            cargacliente();
            //cargaarea();
            cargaestatus();

            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentaticket();
                cargalista();
            })
            $('#btexporta1').click(function () {
                //window.open('CGO_Descarga_ticket.aspx?fecini= ' + $('#txfecini').val() + '&fecfin= ' + $('#txfecfin').val() + ' &mes= ' + $('#dlmes').val() + ' &folio= ' + $('#txid').val() + ' &cliente=' + $('#dlcliente').val() + '&area=' + $('#dlarea').val() + '&estatus=' + $('#dlestatus').val(), '_blank');
            })
            $('#dlestatus').change(function () {
                $('#hdstatus').val($('#dlestatus').val());
            });

            //$('#btbusca').click(function () {
            //    if ($('#txbusca').val() != '') {
            //        cargatecnico();
            //    } else {
            //        alert('Debe capturar un valor de búsqueda');
            //    }
            //});

            $('#txbusca').keypress(function (event) { if (event.which === 13) cargatecnico(); });
            $('#btbusca').click(function () { cargatecnico(); });

        });


        function asignapagina(np) {
            //alert(np);
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
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
                    cargainmueble($('#dlcliente').val());
                });
                cuentaticket();
                cargalista();
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
                $('#dlsucursal').val(0);                               
            }, iferror);
        }
        function cargaestatus() {
            PageMethods.estatus(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestatus').empty();
                $('#dlestatus').append(inicial);
                $('#dlestatus').append(lista);
                $('#dlestatus').val(0);
            }, iferror);
        }
        
        function cuentaticket() {
            //alert("cuentaticket");
            PageMethods.contartickets($('#txid').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#hdstatus').val(),$('#txfecini').val(), $('#txfecfin').val(), function (cont) {
                //alert("paso contar");
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
            //alert($('#dlarea').val());
            //waitingDialog({});
            PageMethods.ordenes($('#txid').val(), $('#txfecini').val(), $('#txfecfin').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#hdstatus').val(), $('#hdpagina').val(), function (res) {
                //closeWaitingDialog();

                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    $('#tblista tbody tr').delegate(".btedita", "click", function () {
                        //alert($(this).closest('tr').find('td').eq(3).text());
                        //alert($(this).closest('tr').find('td').eq(2).text());
                        //if ($(this).closest('tr').find('td').eq(2).text() != 'Cancelado' && $(this).closest('tr').find('td').eq(2).text() != 'Cerrado') { // && $(this).closest('tr').find('td').eq(9).text() != 'Pagado'
                            window.open('OP_PR_OrdenTrabajo.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank');
                        //} else {
                        //    alert('El estatus actual de la Orden de Trabajo no permite realizar cambios');
                        //}
                    });
                    $('#tblista tbody tr').delegate(".btcancela", "click", function () {
                        var folio = $(this).closest('tr').find('td').eq(0).text();
                        if ($(this).closest('tr').find('td').eq(2).text() == 'Cancelado' || $(this).closest('tr').find('td').eq(2).text() == 'Cerrado') {
                            alert('No se puede modificar el estatus de la Orden de Trabajo');
                        } else {
                            PageMethods.cerrarorden(folio, function (res) {
                                alert('La Orden de Trabajo ' + folio + ' ha sido cancelada');
                            });
                        }                        
                    });
                    $('#tblista tbody tr').delegate(".btimprime", "click", function () {
                        var folio = $(this).closest('tr').find('td').eq(0).text();
                        if ($(this).closest('tr').find('td').eq(2).text() == 'Cancelado' || $(this).closest('tr').find('td').eq(2).text() == 'Cerrado') {
                            alert('No se pueden imprimir los formatos de una orden cancelada');
                        } else {
                             window.open('../RptForAll.aspx?v_nomRpt=reportemantenimiento.rpt&v_formula={tb_ordentrabajo.id_orden}  = ' + folio + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btcheck", "click", function () {
                        var folio = $(this).closest('tr').find('td').eq(0).text();
                        if ($(this).closest('tr').find('td').eq(2).text() == 'Cancelado' || $(this).closest('tr').find('td').eq(2).text() == 'Cerrado') {
                            alert('No se pueden imprimir los formatos de una orden cancelada');
                        } else {
                            window.open('../RptForAll.aspx?v_nomRpt=checklistpreventivo.rpt&v_formula={tb_ordentrabajo.id_orden}  = ' + folio + '', '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                        }
                    });
                    $('#tblista tbody tr').delegate(".btasigna", "click", function () {
                        $("#hdordenseleccionada").val($(this).closest('tr').find('td').eq(0).text());
                        
                        $("#divmodal").dialog('option', 'title', 'Buscar Técnico');
                        $('#tbbusca tbody').remove();
                        $('#txbusca').val('');
                        dialog.dialog('open');
                            
                    });
                }
            }, iferror);
        }        

        function cargatecnico() {
            PageMethods.tecnico($('#txbusca').val(), $('input[name="optTecnico"]:checked').val(),function (res) {
                var ren = $.parseHTML(res);
                $('#tbbusca tbody').remove();
                $('#tbbusca').append(ren);
                $('#tbbusca tbody tr').click(function () {
                    PageMethods.asignatecnico($(this).find("td").first().text(), $("#hdordenseleccionada").val(), $('input[name="optTecnico"]:checked').val(), function (res) {
                        dialog.dialog('close');
                        if (res == 'Ok') {
                            cargalista();
                        }
                        else {
                            console.log(res);
                        }
                        
                    }, iferror);
                });
            }, iferror);
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" />
        <asp:HiddenField ID="hdstatus" runat="server" Value="0" />
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
                    <h1>Consulta Orden de Trabajo<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Consulta de Oden de Trabajo</li>
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
                                        <label for="dltipo">F. inicial:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecini" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">F. final:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecfin" class="form-control" />
                                    </div>
                                    
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">No. Orden:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" value ="0"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">Cliente:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlcliente" class="form-control"></select>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dlsucur">Sucursal:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlsucursal" class="form-control"></select>
                                    </div>                                   
                                    <div class="col-lg-1 text-right">
                                        <label for="dlestatus">Estatus:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestatus" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-10">
                                        <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                                </ol>
                            </div>
                            
                     <%--<div class="row col-md-11"> --Fide Paginación
                     <nav aria-label="Page navigation " class="navbar-right">
                        <div style="width:auto; float:left;">
                                <table><tr>
                                <td style="cursor: pointer" title="Filtrar"><span class="ui-icon ui-icon-refresh" id="cmdRefresh" style="cursor: pointer" title="Refresh"></span></td>
                                <td style="cursor: pointer"><span class="ui-icon ui-icon-seek-first" id="cmdInicio" style="cursor: pointer" title="Ir a inicio"></span></td>
                                <td style="cursor: pointer"><span class="ui-icon ui-icon-seek-prev" id="cmdAtras" style="cursor: pointer" title="Regresar"></span></td>
                            </tr></table>
                        </div>

                        <div style="width:auto; float:left;  ">
                                <table style="font-size: 11px;"><tr>
                                    <td><input id="txtPagina" type="text" style="font-size: xx-small; width: 20px" /></td>
                                    <td>&nbsp;<strong> de </strong>&nbsp; </td>
                                    <td><input id="txtTotPag" type="text" class="disabled" style="font-size: xx-small; width: 20px"/></td>
                                </tr>
                            </table >
                        </div>
                        <div style="width:auto; float:left;  ">
                            <table><tr>
                                <td style="cursor: pointer"><span class="ui-icon ui-icon-seek-next" id="cmdSiguiente" style="cursor: pointer" title="Avanzar"></span></td> 
                                <td style="cursor: pointer"><span class="ui-icon ui-icon-seek-end" id="cmdUltimo" style="cursor: pointer" title="Ir al Último"></span></td>
                            </tr></table>
                        </div>
                    </nav>
                    </div>--%>

                            <div class="col-md-12 tbheader" style="max-height: 400px; overflow-y: auto; width: 99%">
                                <table class="table table-responsive h6" id="tblista" >
                                    <thead class="sticky-top">
                                        <tr>
                                            <!--<th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>-->
                                            <th class="bg-light-blue-gradient"><span>Orden</span></th>
                                            <th class="bg-light-blue-gradient"><span>Tipo Mantenimiento</span></th>
                                            <th class="bg-light-blue-gradient"><span>Estatus</span></th>                                           
                                            <th class="bg-light-blue-gradient"><span>F. Alta</span></th>                                            
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sucursal</span></th>                                            
                                            <th class="bg-light-blue-gradient"><span>Descripción</span></th>                                           
                                            <th class="bg-light-blue-gradient"><span>Tecnico</span></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                            <th class="bg-light-blue-gradient"></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>

    <div id="divmodal">
        <input type="hidden" id="hdordenseleccionada" />
        <table><tr style="height:40px;">
            <td>
                <table style="width:100%"><tr ><td>
                    <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="optTecnico" checked="checked" value="I"/> Interno
                    </label>
                </td><td>
                    <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="optTecnico" value="P"/> Proveedor
                    </label>
                </td></tr></table>
            </td>
            <td><input type="text" class=" form-control" id="txbusca" placeholder="Ingresa texto de busqueda" style="width:98%"/> </td>
            <td><input type="button" class="btn btn-primary" value="Mostrar" id="btbusca"/></td>
               </tr></table>

                    <div class="tbheader">
                        <table class="table table-condensed" id="tbbusca">
                            <thead>
                                <tr>
                                    <th class="bg-navy"><span>Id</span></th>
                                    <th class="bg-navy"><span>Nombre</span></th>                            
                                    <th class="bg-navy"><span>Puesto</span></th>                           

                                </tr>
                            </thead>
                        </table>
                    </div>
                

    </div>
</body>
</html>
