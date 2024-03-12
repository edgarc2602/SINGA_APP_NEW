<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ope_Con_listadogeneral.aspx.vb" Inherits="App_Operaciones_Ope_Con_listadogeneral" %>

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
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            var d = new Date();
            $('#txanio').val(d.getFullYear());
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 550,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            cargacliente();
            cargames();
            $('#btmostrar').click(function () {
                if (validacarga()) {
                    cargaptto();
                    cuentalistados();
                    cargalistados();
                }                
            })
            $('#btimprime').click(function () {
                var formula = '{tb_cliente_inmueble.id_cliente}=' + $('#dlcliente').val() + ' and {tb_listadomaterial.mes} =' + $('#dlmes').val() + ' and {tb_listadomaterial.anio}=' + $('#txanio').val()  
                window.open('../RptForAll.aspx?v_nomRpt=listadomatriz.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
            $('#btexporta').click(function () {
                window.open('Ope_Descarga_listado.aspx?cliente=' + $('#dlcliente').val() + '&mes=' + $('#dlmes').val() + '&anio=' + $('#txanio').val() + '&tipo=' + $('#dltipo').val(), '_blank');
            })
            $('#btautoriza').click(function () {
                if (validaauto()) {
                    PageMethods.autoriza($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), 2, function () {
                        cargalistados();
                        alert('Todos los listados se han Aprobado');
                    }, iferror);
                }
            })
            $('#btlibera').click(function () {
                if (validaauto()) {
                    PageMethods.autoriza($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), 1, function () {
                        cargalistados();
                        alert('Todos los listados se han Liberado');
                    }, iferror);
                }
            })            
        });
        function validacarga() {
            if ($('#txfolio').val() == '') {
                $('#txfolio').val(0)
                return true;
            }
            if ($('#txfolio').val() == '' || $('#txfolio').val() == 0) {
                if ($('#dlcliente').val() == 0){
                    alert('Debe elegir un cliente')
                    return false;
                }
                if ($('#dlmes').val() == 0) {
                    alert('Debe elegir un mes')
                    return false;
                }
            }
            return true;
        }
        function validaauto() {
            if ($('#idusuario').val() != 1 && $('#idusuario').val() != 59 && $('#idusuario').val() != 81 && $('#idusuario').val() != 85 && $('#idusuario').val() != 20615) {
                alert('Usted no tiene permisos para realizar esta acción');
                return false;
            }            
            return true;
        }
        function cuentalistados() {
            PageMethods.contarlistados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), $('#txfolio').val(), function (cont) {
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
            PageMethods.listados($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#hdpagina').val(), $('#dltipo').val(), $('#txfolio').val(),  function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista tbody tr').on('click', '.btver', function () {
                    $('#lbfolio').text($(this).closest('tr').find('td').eq(2).text());
                    $('#lbinmueble').text($(this).closest('tr').find('td').eq(1).text());
                    PageMethods.listadod($(this).closest('tr').find('td').eq(2).text(), function (res) {
                        var ren1 = $.parseHTML(res);
                        $('#tblistaj tbody').remove();
                        $('#tblistaj').append(ren1);
                    }, iferror);
                    $("#divmodal").dialog('option', 'title', 'Detalle de materiales');
                    dialog.dialog('open');
                });
                $('#tblista tbody tr').on('click', '.btcancela', function () {
                    if (validaauto()) {
                        var resp = confirm('Esta seguro de cancelar el listado: ' + $(this).closest('tr').find('td').eq(2).text().toString())
                        if (resp == true) {
                            PageMethods.cancela($(this).closest('tr').find('td').eq(2).text(), function (res) {
                                cargalistados();
                                alert('Registro actualizado');
                            }, iferror);
                        } else {
                            alert('No se ejecuta ninguna acción');
                        }
                    }
                });
                $('#tblista tbody tr').on('click', '.btauto', function () {
                    var resp = ''
                    var auto = 0
                    if (validaauto()) {
                        if ($(this).closest('tr').find("input:eq(2)").val() == 'Aprobar') {
                            resp = confirm('Esta seguro de Aprobar el listado: ' + $(this).closest('tr').find('td').eq(2).text().toString())
                            auto = 2
                        } else {
                            if ($(this).closest('tr').find("input:eq(2)").val() == 'Liberar') {
                                resp = confirm('Esta seguro de liberar el listado: ' + $(this).closest('tr').find('td').eq(2).text().toString())
                                auto = 1
                            }
                        }              
                        if (resp == true) {
                            PageMethods.auto($(this).closest('tr').find('td').eq(2).text(), auto, function (res) {
                                cargalistados();
                                alert('Registro actualizado');
                            }, iferror);
                        } else {
                            alert('No se ejecuta ninguna acción');
                        }
                    }
                });
            }, iferror );
        }
        function cargaptto() {
            PageMethods.ptto($('#dlcliente').val(), $('#dlmes').val(), $('#txanio').val(), $('#dltipo').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txtotinm').val(datos.totinm);
                $('#txtotlis').val(datos.totlis);
                $('#txptto').val(datos.totptto);
                $('#txpttou').val(datos.totuti);
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
                    cargalista();
                });
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
                    <h1>Autorización de Listados de materiales<small>Operaciones</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Operaciones</a></li>
                        <li class="active">Listados de materiales</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txfolio">Folio:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txfolio" class="form-control" value="0"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div >
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txanio" class="form-control"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label for="dltipo">Tipo de listado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Iguala</option>
                                        <option value="2">Adicionales</option>
                                        <option value="3">Complemento de la iguala</option>
                                        <option value="4">Material para pulido</option>
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btmostrar" class="btn btn-primary" value="mostrar"/>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txtotinm">Puntos de atención:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotinm" class="form-control text-right"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txtotlis text-right">Listados creados:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txtotlis" class="form-control text-right"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txptto">Presupuesto global:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txptto" class="form-control text-right"/>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="txpttou">Total de listados:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txpttou" class="form-control text-right"/>
                                </div>
                            </div>
                        </div>
                        <div class="tbheader" style="height:300px; overflow-y:scroll;">
                            <table class="table table-condensed" id="tblista" >
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Id</span></th>
                                        <th class="bg-navy"><span>Nombre</span></th>
                                        <th class="bg-navy"><span>Listado</span></th>
                                        <th class="bg-navy"><span>Tipo</span></th>
                                        <th class="bg-navy"><span>Estatus</span></th>
                                        <th class="bg-navy"><span>F. Creación</span></th>
                                        <th class="bg-navy"><span>Utilizado</span></th>
                                        <th class="bg-navy"></th>
                                        <th class="bg-navy"></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                            <li id="btimprime"  class="puntero"><a ><i class="fa fa-print"></i>Imprimir Matriz</a></li>
                            <li id="btautoriza"  class="puntero"><a ><i class="fa fa-edit"></i>Aprobar todo</a></li>
                            <li id="btlibera"  class="puntero"><a ><i class="fa fa-undo"></i>Liberar todo</a></li>
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
                    <div id="divmodal">
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Listado:</label>
                            </div>
                            <div class="col-lg-2">
                                <label id="lbfolio" ></label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <label>Punto de atención:</label>
                            </div>
                            <div class="col-lg-6">
                                <label id="lbinmueble"></label>
                            </div>
                        </div>
                        <div class="row">
                            <div  id="dvjarceria" class="tbheader" style="height:400px; overflow-y:scroll;">
                                <table class=" table table-condensed h6" id="tblistaj">
                                        <thead>
                                        <tr>
                                            <th class="bg-light-blue-active">Clave</th>
                                            <th class="bg-light-blue-active">Descripción</th>
                                            <th class="bg-light-blue-active">Unidad</th>
                                            <th class="bg-light-blue-active">Cantidad</th>
                                            <th class="bg-light-blue-active">Precio</th>
                                            <th class="bg-light-blue-active">total</th>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
