<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Rep_PendFacturar.aspx.vb" Inherits="Ventas_App_Ven_Rep_PendFacturar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>PENDIENTES DE FACTURAR</title>
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
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            const fechaHoy = new Date();
            const aniohoy = fechaHoy.getFullYear();
            $('#txanio').val(aniohoy)

            cargames();
            //cuentacliente();
            //cargapendientes();
            $('#btconsultar').click(function () {
                if ($('#txanio').val() == '' || $('#dlmes').val() == 0) {
                    alert('Debe capturar el Año y el mes');
                    return false;
                }
                else {
                    cuentacliente();
                    cargapendientes();
                    cargaglobales();
                }
            });
            $('#btimprime').click(function () {
                var formula = ''
                if ($('#txanio').val() == '' || $('#dlmes').val() == '') {
                    alert('Debe capturar el Año y el mes');
                    return false;
                }
                else {
                    //formula = '{tb_clientependfactdet.anio} ="' + $('#txanio').val() + '" and {tb_clientependfactdet.mes} = "' + padLeft($('#dlmes').val(),2,"0") + '"'
                    //formula = '{tb_clientependfactdet.anio} =' + $('#txanio').val() + ' and {tb_clientependfactdet.mes} = ' + parseInt($('#dlmes').val()) + ''
                    formula = '{sp_reportependfacturarmes.anio} =' + $('#txanio').val() + ' and {sp_reportependfacturarmes.mes} = ' + parseInt($('#dlmes').val()) + ''
                    //formula = '{anio} =' + $('#txanio').val() + ' and {mes} = ' + parseInt($('#dlmes').val()) + ''
                    window.open('../RptForAll.aspx?v_nomRpt=pendientesdefacturarmes.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            });
            $('#btimprimedet').click(function () {
                var formula = ''
                if ($('#txanio').val() == '' || $('#dlmes').val() == '') {
                    alert('Debe capturar el Año y el mes');
                    return false;
                }
                else {
                    formula = '{tb_pendfactdetalle.anio} ="' + $('#txanio').val() + '" and {tb_pendfactdetalle.mes} = "' + $('#dlmes').val() + '"'
                    window.open('../RptForAll.aspx?v_nomRpt=pendfacturardetalle.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                }
            });
        });

        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargapendientes();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentacliente() {
            PageMethods.contarcliente($('#txanio').val(), padLeft($('#dlmes').val(), 2, "0"), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }

        function cargames() {
            PageMethods.mes(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + padLeft(opt[list].id, 2, "0") + '">' + opt[list].desc + '</option>';
                };
                $('#dlmes').append(inicial);
                $('#dlmes').append(lista);
            }, iferror);
        }

        function cargapendientes() {
            PageMethods.pendientes($('#txanio').val(), padLeft($('#dlmes').val(), 2, "0"), $('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
            }, iferror);
        }

        function cargaglobales() {
            PageMethods.pendientesglobales($('#txanio').val(), padLeft($('#dlmes').val(), 2, "0"), $('#hdpagina').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblistaglobal tbody').remove();
                $('#tblistaglobal').append(ren);

                $('#tblistaglobal td').each(function () {
                    var valorNumerico = parseFloat($(this).text());
                    if (!isNaN(valorNumerico)) {
                        var formato = valorNumerico.toLocaleString('en-US', {
                            style: 'decimal',
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        $(this).text(formato);
                    }
                });

            }, iferror);
        }

        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        }

        function padLeft(str, length, char) {
            const diff = length - str.length;
            if (diff <= 0) {
                return str;
            }
            const padding = char.repeat(diff);
            return padding + str;
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <div class="wrapper">
            <div class="main-header">
                <a href="../Home.aspx" class="logo">
                    <span class="logo-mini"><b>S</b>GA</span>
                    <span class="logo-lg"><b>SIN</b>GA</span>
                </a>
                <div class="navbar navbar-static-top" role="navigation">
                    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button" id="menu">
                        <span class="sr-only">Toggle navigation</span>
                    </a>
                    <div class="navbar-custom-menu">
                        <ul class="nav navbar-nav">
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
            <div class="main-sidebar">-
                <div class="sidebar" id="var1">
                </div>
            </div>
            <div class="content-wrapper">
                <div class="content-header">
                    <h1>Consulta Pendientes de Facturar<small>Ventas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Ventas</a></li>
                        <li class="active">Pendientes facturar</li>
                    </ol>
                </div>
                <%--<div class="content">--%>
                    <div class="row">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <br />
                                <div class="col-lg-1 text-right">
                                    <label for="txanio">Año</label>
                                </div>
                                <div class="col-lg-1">
                                    <input class="form-control" type="text" id="txanio" maxlength="4" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlmes">Mes:</label>
                                </div >
                                <div class="col-lg-2">
                                    <select id="dlmes" class="form-control"></select>
                                </div>
                            <div class="row">
                                <div class="col-lg-1" style="margin-left:50px;">
                                    <input type="button" class="btn btn-primary " value="Consultar" id="btconsultar"/>
                                </div>
                                <div class="col-lg-1" style="margin-left:50px;">
                                    <input type="button" class="btn btn-primary " value="Imprimir" id="btimprime"/>
                                </div>
                                <%--<div class="col-lg-1" style="margin-left:50px;">
                                    <input type="button" class="btn btn-primary " value="Imprimir detalle" id="btimprimedet"/>
                                </div>--%>
                            </div>
                        </div>
                    </div>
               <%-- </div>--%>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblistaglobal">
                                    <thead>
                                        <tr>
                                            <th class="auto-style2">  </th>
                                           <%-- <th class="auto-style2"><span>Id</span></th>--%>
                                            <th class="auto-style2"><span>Total monto a facturar</span></th>
                                            <th class="auto-style2"><span>Total monto facturado</span></th>
                                            <th class="auto-style2"><span>Total saldo</span></th>
                                            <%--<th class="auto-style2"><span>Pago</span></th>
                                            <th class="auto-style2"><span>Saldo Pend.Fact</span></th>--%>
                                        </tr>
                                    </thead>
                                </table>
                            </div>

                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="auto-style2">  </th>
                                           <%-- <th class="auto-style2"><span>Id</span></th>--%>
                                            <th class="auto-style2"><span>Nombre</span></th>
                                            <th class="auto-style2"><span>Linéa negocio</span></th>
                                            <th class="auto-style2"><span>Tipo</span></th>
                                            <th class="auto-style2"><span>Mes</span></th>
                                            <th class="auto-style2"><span>Año</span></th>
                                            <th class="auto-style2"><span>Pendiente de facturar</span></th>
                                            <th class="auto-style2"><span>Facturado</span></th>
                                            <th class="auto-style2"><span>Saldo</span></th>
                                            <%--<th class="auto-style2"><span>Pago</span></th>
                                            <th class="auto-style2"><span>Saldo Pend.Fact</span></th>--%>
                                        </tr>
                                    </thead>
                                </table>
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
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
