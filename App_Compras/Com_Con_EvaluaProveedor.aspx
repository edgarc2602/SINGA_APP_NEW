<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Com_Con_EvaluaProveedor.aspx.vb" Inherits="App_Compras_Com_Con_EvaluaProveedor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE EVALUACION PROVEEDORES</title>
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
        var inicial1 = '<option value=1>SIN SUPERVISOR</option>'
        $(function () {
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txcontrato').append(inicial);
            cargaproveedor();

            $('#btconsulta').click(function ()
            {
                if ($('#txfolio').val() == '') { $('#txfolio').val() == '0' }
                if (($('#txfecini').val() == '' && $('#txfecfin').val() == '' && $('#txfolio').val() == '0' && $('#dlproveedor').val() == 0) || $('#txfolio').val() == '' )
                {
                    if (($('#txfecini').val() != '' && $('#txfecfin').val() == '') || ($('#txfecini').val() == '' && $('#txfecfin').val() != ''))
                    {
                        alert('Falta de seleccionar una de las fechas')
                    }
                    else
                    {
                        alert('Debe seleccionar un proveedor, capturar al menos un numero de folio o bien un rango de fechas ')
                    }
                }
                else
                {
                    if ($('#txfolio').val() == '') { $('#txfolio').val() == '0'}
                    $('#hdpagina').val(1);
                    cuentaencuesta();
                    cargalista();
                }
            })

            var campoTexto = document.getElementById("txfolio");
            campoTexto.addEventListener("input", function () {
                var valor = this.value;
                valor = valor.replace(/[^0-9]/g, "");
                this.value = valor;
            });


            dialog1 = $('#divmodal1').dialog(
            {
                autoOpen: false,
                height: 250,
                width: 800,
                modal: true,
                close: function () {
                }
            });

            //$('#btcerrado').click(function ()
            //{
            //    //waitingDialog({});
            //    alert('antes cambio status')
            //    PageMethods.cambiaestatus($(this).closest('tr').find('td').eq(0).text(), 3, $('#idusuario').val(), function (res)
            //    {
            //        alert('cambio status')
            //        cuentasolicitud();
            //        cargalista();
            //        //dialog1.dialog('close');
            //        //closeWaitingDialog();
            //    }, iferror);
            //})


            $('#btexporta1').click(function () {
                window.open('CGO_Descarga_encuesta.aspx?fecini='+$('#txfecini').val()+' &fecfin='+$('#txfecfin').val()+' &cliente=' + $('#dlproveedor').val() + '&inmueble=' + $('#txcontrato').val(), '_blank');
            })
            $('#btimprime').click(function () {
                var fini = $('#txfecini').val().split('/');
                var ffin = $('#txfecfin').val().split('/');
                var formula = '{tb_evaluacionproveedor.fecha} in Date (' + fini[2] + ' , ' + fini[1] + ' , ' + fini[0] + ') to Date (' + ffin[2] + ' , ' + ffin[1] + ' , ' + ffin[0] + ')'
                window.open('../RptForAll.aspx?v_nomRpt=encuestaresumen.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            })
        });
        function cuentaencuesta() {
            PageMethods.contarencuesta($('#txfecini').val(), $('#txfecfin').val(), $('#dlproveedor').val(), $('#txfolio').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargaproveedor() {
            PageMethods.proveedor(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlproveedor').empty();
                $('#dlproveedor').append(inicial);
                $('#dlproveedor').append(lista);
                $('#dlproveedor').change(function () {
                   
                })
            }, iferror);
        }

        function cargalista() {
            //waitingDialog({});
            PageMethods.encuestas($('#txfecini').val(), $('#txfecfin').val(), $('#dlproveedor').val(), $('#txfolio').val(), $('#hdpagina').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista tbody').remove();
                    
                    $('#tblista').append(ren);

                    $(document).ready(function () {
                        $("#tblista tr").each(function () {
                            $(this).find("td:eq(1)").hide();
                            $(this).find("td:eq(3)").hide();
                        });
                    });

                    $('#tblista tbody tr').delegate(".btcerrado", "click", function ()
                    {
                        if ($('#idusuario').val() != 139 && $('#idusuario').val() != 138 && $('#idusuario').val() != 1) {
                            alert('Usted no esta autorizado para realizar esta operación');
                        }
                        else
                        {
                            PageMethods.cambiaestatus($(this).closest('tr').find('td').eq(0).text(), 2, $('#idusuario').val(), function (res) {
                                alert('La evaluación del proveedor ha sido cerrada')
                                cuentaencuesta();
                                cargalista();
                            }, iferror);
                            
                        }
                    });

                    $('#tblista tbody tr').delegate(".bteditar", "click", function ()
                    {
                        window.open('Com_Pro_EvaluaProveedor.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text() + ' &idproveedor=' + $(this).closest('tr').find('td').eq(1).text() + ' &idstatus=' + $(this).closest('tr').find('td').eq(3).text(), '_blank')
                    });

                    $('#tblista tbody tr').delegate(".btimprimir", "click", function () {
                        //window.open('Com_Pro_EvaluaProveedor.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text() + ' &idproveedor=' + $(this).closest('tr').find('td').eq(1).text() + ' &idstatus=' + $(this).closest('tr').find('td').eq(3).text(), '_blank')
                        var formula = '{tb_evaluacionproveedor.id_evaluacionproveedor}=' + $(this).closest('tr').find('td').eq(0).text()
                        window.open('../RptForAll.aspx?v_nomRpt=evaluacionproveedores.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
                    });


                    $('#tblista tbody tr').click(function ()
                    {
                        var tabla = document.getElementById("tblista");
                        var botones = tabla.getElementsByTagName("button");

                        for (var i = 0; i < botones.length; i++) {
                            botones[i].addEventListener("click", function () {
                                var fila = this.parentNode.parentNode; // Fila actual
                                var indiceColumna = Array.prototype.indexOf.call(fila.children, this.parentNode);
                                alert('indiceColumna: ' + indiceColumna)
                                alert('indiceColumna: ')
                                console.log("Se hizo clic en el botón de la columna: " + indiceColumna);
                            });
                        }
                        //window.open('Com_Pro_EvaluaProveedor.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text() + ' &idproveedor=' + $(this).closest('tr').find('td').eq(1).text() + ' &idstatus=' + $(this).closest('tr').find('td').eq(3).text(), '_blank')
                    })
                }
            }, iferror);
        }

        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
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
    <style type="text/css">
        .auto-style1 {
            color: #444;
            display: block;
            padding: 10px;
            position: relative;
            left: 0px;
            top: 0px;
        }
    </style>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idfolio" runat="server" />
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
                    <h1>Consulta de Evaluación de Proveedores<small>Compras</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li>Compras</li>
                        <li class="active">Consulta de proveedores</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="box box-info">
                            <div class="auto-style1">
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txfolio">Folio:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfolio" class="form-control text-right"  value="0" />
                                </div>
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
                            </div>
                            <div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="dltipo">Proveedor:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlproveedor" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-10">
                                    <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
<%--                                <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a Excel</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-save"></i>Imprimir detalle</a></li>--%>
                            </ol>
                        </div>
                        <div class="col-md-18 tbheader">
                            <table class="table table-responsive h6" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                        <%--<th class="bg-light-blue-gradient"><span>Id Proveedor</span></th>--%>
                                        <th class="bg-light-blue-gradient"><span>Proveedor</span></th>
                                        <%--<th class="bg-light-blue-gradient"><span>IdStatus</span></th>--%>
                                        <th class="bg-light-blue-gradient"><span>Status</span></th>
                                        <th class="bg-light-blue-gradient"><span>No.Contrato</span></th>
                                        <th class="bg-light-blue-gradient"><span>F.Evaluación</span></th>
                                        <th class="bg-light-blue-gradient"><span>Promedio</span></th>
                                        <th class="bg-light-blue-gradient"><span>Resultado</span></th>
                                        <%--<th class="bg-light-blue-gradient"><span>CGO</span></th>
                                        <th class="bg-light-blue-gradient"><span>Materiales</span></th>
                                        <th class="bg-light-blue-gradient"><span>Miscelaneos</span></th>--%>
                                    </tr>
                                </thead>
                            </table>
                        </div>


                        <nav aria-label="Page navigation example" class="navbar-right">
                            <ul class="pagination justify-content-end collapse navbar-collapse" id="paginacion">
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

