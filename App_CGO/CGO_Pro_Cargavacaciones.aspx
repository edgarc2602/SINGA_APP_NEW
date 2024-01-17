<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CGO_Pro_Cargavacaciones.aspx.vb" Inherits="App_CGO_CGO_Pro_Cargavacaciones" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>REGISTRO DE TICKET</title>
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
            dialog = $('#dvmodal').dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                close: function () {
                }
            });
            //$('#dvabre').hide();
            //$('#dvcarga').hide();
            cargacliente();
            $('#btconsulta').click(function () {
                $('#hdpagina').val(1);
                cuentaempleado();
                cargalista();
            })
            $('#btdescarga').click(function () {
                var archivo = $('#lbarchivo').val();
                window.open('../Doctos/expediente/' + archivo, '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
            })
        })
        function cargacliente() {
            PageMethods.cliente(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                $('#dlcliente').val(0);
                $('#dlcliente').change(function () {
                    cargainmueble($('#dlcliente').val());
                })
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
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentaempleado() {
            PageMethods.contarempleado($('#dlcliente').val(), $('#dlsucursal').val(), $('#txnoemp').val(), $('#txnombre').val(), $('#dltipo').val(), $('#dlforma').val(), $('#dlestatus').val(), function (cont) {
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
            //waitingDialog({});
            PageMethods.empleado($('#hdpagina').val(), $('#dlcliente').val(), $('#dlsucursal').val(), $('#txnoemp').val(), $('#txnombre').val(), $('#dltipo').val(), $('#dlforma').val(), $('#dlestatus').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tbdatos tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tbdatos tbody').remove();
                    $('#tbdatos').append(ren);
                    $('#tbdatos tbody tr').on('click', '.tbeditar', function () {
                        $('#txempleado').val($(this).closest('tr').find('td').eq(1).text());
                        $('#txnombre1').val($(this).closest('tr').find('td').eq(2).text());
                        cargadocumentos();
                        $("#dvmodal").dialog('option', 'title', 'Carga de expediente');
                        dialog.dialog('open');
                        
                    });
                }
            }, iferror);
        }
        function cargadocumentos() {
            PageMethods.documentos($('#txempleado').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tbdatosa tbody').remove();
                    //alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tbdatosa tbody').remove();
                    $('#tbdatosa').append(ren);
                    $('#tbdatosa tbody tr').on('click', '.tbeditar', function () {
                        var archivo = $(this).closest('tr').find('td').eq(1).text();
                        //window.open('../Doctos/IMSS/' + archivo, '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                        window.open('../Doctos/vacacion/' + archivo, '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                    });
                }
            }, iferror);
        }
        function xmlUpFile(res) {
            if (valida()) {
                waitingDialog({});
                var fileup = $('#txarchivo').get(0);
                var files = fileup.files;

                var ndt = new FormData();
                for (var i = 0; i < files.length; i++) {
                    ndt.append(files[i].name, files[i]);
                }
                ndt.append('nmr', res);
                $.ajax({
                    url: '../GH_Upvacacion.ashx',
                    type: 'POST',
                    data: ndt,
                    contentType: false,
                    processData: false,
                    success: function (res) {
                        PageMethods.actualiza($('#txempleado').val(), res, function (res) {
                            alert('El archivo se ha cargado correctamente');
                            //cargalista();
                            cargadocumentos();
                            closeWaitingDialog();
                            //dialog.dialog('close');
                        }, iferror);
                    },
                    error: function (err) {
                        alert(err.statusText);
                    }
                });
            }
        }
        function valida() {
            if ($('#txarchivo').val() == '') {
                alert('Debe seleccionar el archivo del acuse antes de continuar');
                return false;
            }
            return true;
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Consulta...');
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
        <asp:HiddenField ID="idusuario" runat="server" Value="0"/>
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
                    <h1>Archivos de vacaciones
                        <small>CGO</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>CGO</a></li>
                        <li class="active">Vacaciones</li>
                    </ol>
                </div>
                <div id="divinmueble" class="content">
                    <div class="row" id="tblista">
                        <div class="box box-info">
                            <div class=" box-header with-border">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txnoemp">No. empleado:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnoemp" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txnombre" class="form-control" />
                                </div>
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
                                <div class="col-lg-3">
                                    <select id="dlsucursal" class="form-control"></select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="6">Administrativa</option>
                                        <option value="4">Operativa</option>
                                        <option value="11">Mantenimiento</option>
                                    </select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dlforma">Forma de pago:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlforma" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Quicenal</option>
                                        <option value="2">Semanal</option>
                                    </select>
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="dlestatus">Estatus:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlestatus" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Candidato</option>
                                        <option value="2">Activo</option>
                                        <option value="3">Baja</option>
                                        <option value="4">No se presento</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row tbheaders">
                        <table class="table table-condensed h6" id="tbdatos">
                            <thead>
                                <tr>
                                    <th class="bg-navy"></th>
                                    <th class="bg-navy"><span>No. Emp</span></th>
                                    <th class="bg-navy"><span>Nombre</span></th>
                                    <th class="bg-navy"><span>Tipo</span></th>
                                    <th class="bg-navy"><span>Estatus</span></th>
                                    <th class="bg-navy"><span>Cliente</span></th>
                                    <th class="bg-navy"><span>Pto Atn</span></th>
                                </tr>
                            </thead>
                        </table>
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
                    <div class="row" id="dvmodal">
                        <div class="row"> 
                            <div class="col-lg-3">
                                <label for="txempleado">Empleado:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txempleado" class="form-control" disabled="disabled"/>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" id="txnombre1" class="form-control" disabled="disabled"/>
                            </div>
                        </div>
                        <hr />
                        <div class="row" id="dvcarga">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Archivo:</label>
                                </div>
                                <div class="col-lg-8">
                                    <input type="file" id="txarchivo" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btfile" class="btn btn-success" value="Subir" onclick="xmlUpFile()" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-18 tbheaders">
                            <table class="table table-condensed h6" id="tbdatosa">
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>F. Carga</span></th>
                                        <th class="bg-navy"><span>Archivo</span></th>
                                    </tr>
                                </thead>
                            </table>
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
