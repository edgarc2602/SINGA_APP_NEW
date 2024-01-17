<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Con_compptto.aspx.vb" Inherits="App_Compras_Com_Con_compptto" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>COMPARATIVO DE MATERIALES SOLICITADOS</title>
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
        .tbborrar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e801';
        }
        .tbeditar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\e802';
        }
        .tbaprobar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\F064';
        }
        .tbliberar:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\F032';
        }
        .tbreingresa:after{
            font-family: 'myfontx'; 
            font-size :20px;
            content:'\E803';
        }
        #tblista tbody td:nth-child(23){
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
            cargacomprador();
            cargames();
            cargagerente();
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
            $('#btmostrar').click(function () {
                cargacomparativo();
            })
            $('#btexporta').click(function () {
                var tipo = $('#dltipo').val()
                if ($('#dltipo').val() == 1) {
                    tipo ='1,3'
                }
                window.open('Com_Descarga_comparativo.aspx?comprador=' + $('#dlcomprador').val() + '&gerente=' + $('#dlgerente').val() + '&mes=' + $('#dlmes').val() + '&anio=' + $('#txanio').val() + '&tipo=' + tipo, '_blank');
            })
        })
        function cargacomparativo() {
            if (valida()) {
                waitingDialog({});
                PageMethods.comparativo($('#dlcomprador').val(), $('#dlgerente').val(), $('#txanio').val(), $('#dlmes').val(), $('#dltipo').val(), function (res) {
                    closeWaitingDialog();
                    var ren = $.parseHTML(res);
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                    /*$('#tblista tbody tr').on('click', '.btver', function () {
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
                    });
                    $('#tblista tbody tr').on('click', '.btacuse', function () {
                        $('#lbfolio1').text($(this).closest('tr').find('td').eq(2).text());
                        $('#lbinmueble1').text($(this).closest('tr').find('td').eq(1).text());
                        $('#lbtipo1').text($(this).closest('tr').find('td').eq(3).text());
                        cargaacuses($(this).closest('tr').find('td').eq(2).text());
                        //alert($(this).closest('tr').find('td').eq(10).text());
                        //$('#acuse').val($(this).closest('tr').find('td').eq(10).text());
                        if ($(this).closest('tr').find('td').eq(4).text() == 'Entregado') {
                            $('#dvcierre').hide();
                            $('#dvcarga').hide();
                        } else {
                            $('#dvcierre').show();
                            $('#dvcarga').show();
                        }
                        $("#divmodal1").dialog('option', 'title', 'Cargar Acuse de entrega');
                        dialog1.dialog('open');
    
                    });*/
                }, iferror);
            }
        }
        function valida() {
            if ($('#txanio').val() == '') {
                alert('Debe capturar el año');
                return false;
            }
            if ($('#dlmes').val() == 0) {
                alert('Debe seleccionar un mes');
                return false;
            }
            return true;
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
        function cargacomprador() {
            PageMethods.comprador(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcomprador').append(inicial);
                $('#dlcomprador').append(lista);
            }, iferror);
        }
        function cargagerente() {
            PageMethods.gerente(30, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlgerente').append(inicial);
                $('#dlgerente').append(lista);
                
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
                    <h1>Comparativo de materiales solicitados vs Presupuesto<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Compras</a></li>
                        <li class="active">Comparativo</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcomprador">Comprador:</label>
                                </div >
                                <div class="col-lg-3">
                                    <select id="dlcomprador" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlgerente">Gerente:</label>
                                </div >
                                <div class="col-lg-3">
                                    <select id="dlgerente" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                               <div class="col-lg-2 text-right">
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
                                <div class="col-lg-1">
                                    <label for="dltipo">Tipo de listado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control">
                                        <option value="0">Seleccione...</option>
                                        <option value="1">Iguala</option>
                                        <option value="2">Adicionales</option>
                                        <option value="4">Material para pulido</option>
                                    </select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" id="btmostrar" class="btn btn-primary" value="mostrar"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tbheader" style="height:300px; overflow-y:scroll;">
                            <table class="table table-condensed" id="tblista" >
                                <thead>
                                    <tr>
                                        <th class="bg-navy"><span>Cliente</span></th>
                                        <th class="bg-navy"><span>Presupuesto</span></th>
                                        <th class="bg-navy"><span>Utilizado</span></th>
                                        <th class="bg-navy"><span>Variación</span></th>
                                        <th class="bg-navy"></th>
                                        <th class="bg-navy"><span>Gerente</span></th>
                                        <th class="bg-navy"><span>Comprador</span></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    <ol class="breadcrumb">
                        <li id="btexporta" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                        <!--<li id="btautoriza"  class="puntero"><a ><i class="fa fa-edit"></i>Aprobar</a></li>
                        <li id="btlibera"  class="puntero"><a ><i class="fa fa-undo"></i>Liberar</a></li>-->
                    </ol>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
