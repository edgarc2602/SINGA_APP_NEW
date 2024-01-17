<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Prospecto_N.aspx.vb" Inherits="Ventas_App_Ven_Cat_Prospecto_N" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CATALOGO DE PROSPECTOS</title>
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
        $(function ()
        {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            $("#loadingScreen").dialog(
            {
                autoOpen: false,    // set this to false so we can manually open it
                dialogClass: "loadingScreenWindow",
                closeOnEscape: false,
                draggable: false,
                width: 460,
                minHeight: 50,
                modal: true,
                buttons: {},
                resizable: false,
                open: function ()
                {
                    // scrollbar fix for IE
                    $('body').css('overflow', 'hidden');
                },

                close: function ()
                {
                    // reset overflow
                    $('body').css('overflow', 'auto');
                }
            });
            //1 MODAL
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });

            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            /*$('#txfbaja').datepicker({ dateFormat: 'dd/mm/yy' });*/
            if ($('#idprospecto1').val() != 0)
            {
                $('#txid').val($('#idprospecto1').val());
                datosprospecto();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
            }

            $('#btoficinas').on('click', function ()
            {
                var mywin = window.open('Ven_Cat_Cliente_Oficinas.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 400, height = 400')
            });
            $('#btlineas').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Lineas.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 400, height = 400')
            });
            $('#btinmueble').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_inmueble.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 100, width = 1200, height = 500')
            });
            $('#btiguala').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Iguala.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 100, width = 1200, height = 500')
            });
            $('#btplantilla').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Plantilla.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val() + '&usu=' + $('#idusuario').val(), '_blank', '')
            });
            $('#btlistamaterial').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Listatipo.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 1200, height = 500')
            });
            $('#btmaterial').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Material.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            $('#btherr').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Herramienta.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            $('#btotroeq').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Otroeq.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            $('#btviatico').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Viatico.aspx?folio=1 &est=2', '_blank')
            });
            $('#btsubcontrato').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Subcontrato.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            $('#btcostofin').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Gastofin.aspx?folio=1 &est=2', '_self')
            });
            $('#tblistaauto').on('click', function ()
            {
                var mywin = window.open('Ven_Cat_Cliente_listaauto.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            cuentaprospecto();
            cargalista();
            //cargaejecutivo();
            //cargaencargado();
            //cargaempresa();
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });
            $('#btnuevo1').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            });
            $('#btnuevo').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            });
            $('#btguarda').on('click', function () {
                if (valida()) {
                    waitingDialog({});
                    var fini = $('#txfecini').val().split('/');
                    var finicio = fini[2] + fini[1] + fini[0];

                    //if ($('#txfecter').val() != '') {
                    //    farr = $('#txfecter').val().split('/');
                    //    var ffin = farr[2] + farr[1] + farr[0];
                    //} else {ffin = ''}
                    //var pmat = 0;
                    //if ($('#cbmaterial').is(':checked')) {
                    //    pmat = 1;
                    //}
                    //var pser = 0;
                    //if ($('#cbservicio').is(':checked')) {
                    //    pser = 1;
                    //}
                    //var ppla = 0;
                    //if ($('#cbplantilla').is(':checked')) {
                    //    ppla = 1;
                    //}
                    //var ppzo = 0;
                    //if ($('#cbtiempo').is(':checked')) {
                    //    ppzo = 1;
                    //}
                    //var xmlgraba = '<cliente id= "' + $('#txid').val() + '" nombre = "' + $('#txnombre').val() + '" ';
                    var xmlgraba = '<catprospecto id= "' + $('#txid').val() + '" nombre = "' + $('#txnombre').val() + '" ';
                    xmlgraba += ' credito = "' + $('#txcred').val() + '" ';
                    xmlgraba += ' fini = "' + finicio + '" vigencia = "' + $('#txvigencia').val() + '" />';
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            });

            $('#btelimina').click(function () {
                $("#divmodal").dialog('option', 'title', 'Programar baja de Prospecto');
                dialog.dialog('open');
            });
            $('#btbaja').click(function () {
                if (validabaja()) {
                    //alert('hola');
                    waitingDialog({});
                    //PageMethods.elimina($('#txid').val(), $('#txnombre').val(), $('#txfbaja').val(), $('#txcomentario').val(), $('#idejecutivo').val(), $('#idencargado').val(), function () {
                    PageMethods.elimina($('#txid').val(), $('#txfbaja').val(), $('#txcomentario').val(), function () {
                        closeWaitingDialog();
                        alert('El Prospecto se ha registrado para baja automática, en la fecha señalada, ya no se podran realizar cambios a su registro.');
                        cargalista();
                        dialog.dialog('close');
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                }
            });

            $('#btpbamodal').click(function ()
            {
                //waitingDialog({});
                PageMethods.elimina($('#txid').val(), $('#txnombre').val(), $('#txfbaja').val(), $('#txcomentario').val(), $('#idejecutivo').val(), $('#idencargado').val(), function ()
                {
                    //PageMethods.elimina($('#txid').val(), $('#txnombre').val(), $('#txfbaja').val(), $('#txcomentario').val(), function () {
                    //closeWaitingDialog();
                    alert('El Prospecto se ha registrado para baja automática, en la fecha señalada, ya no se podran realizar cambios a su registro.');
                    //cargalista();
                    dialog.dialog('close');
                    //$('#dvtabla').show();
                    //$('#dvdatos').hide();
                }, iferror);
            });


            $('#txfecini').change(function ()
            {
                if ($('#txfecini').val() != '' && $('#txvigencia').val() != '')
                {
                    calculatotal();
                }
            });

            $('#txvigencia').change(function ()
            {
                if ($('#txvigencia').val() != '' && $('#txfecini').val() != '')
                {
                    calculatotal();
                }
            });

            $('#btbusca').click(function ()
            {
                    cuentaprospecto();
                    asignapagina(1)
                    //cargalista();
            });

            function asignapagina(np)
            {
                $('#paginacion li').removeClass("active");
                $('#hdpagina').val(np);
                cargalista();
                $('#paginacion li').eq(np - 1).addClass("active");
            };

            function cuentaprospecto()
            {
                PageMethods.contarprospecto($('#dlbusca').val(), $('#txbusca').val(), function (cont)
                {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                    for (var x = 1; x <= opt[0].pag; x++)
                    {
                        pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                    }
                $('#paginacion').append(pag);
            }, iferror);
        }



        function calculatotal()
        {
            var vdia = 0;
            var farr = $('#txfecini').val().split('/');
            var finicio = farr[2] + '/' + farr[1] + '/' + farr[0];
            var da = new Date(finicio);
            da.setMonth(da.getMonth() + parseInt($('#txvigencia').val()));
            if (da.getDate() < 10)
            {
                vdia = '0' + da.getDate();
            } else
            {
                vdia = da.getDate()
            }
            if (da.getMonth() + 1 < 10)
            {
                vmes = '0' + (da.getMonth() + 1);
            } else { vmes = da.getMonth() + 1 }
            var dfin = vdia + '/' + (vmes) + '/' + da.getFullYear();
            $('#txfecter').val(dfin);
        };

        function validabaja()
        {
            if ($('#txfbaja').val() == 0)
            {
                alert('Debe selecionar la fecha de baja');
                return false;
            }
            if ($('#txcomentario').val() == '')
            {
                alert('Debe capturar el motivo de la baja');
                return false;
            }
            return true;
        };
        function valida()
        {
            if ($('#txnombre').val() == '')
            {
                alert('Debe capturar el Nombre comercial del Cliente');
                return false;
            }
            
            if ($('#txfecini').val() == '')
            {
                alert('Debe capturar la fecha de inicio de contrato');
                return false;
            }
            if ($('#txvigencia').val() == '')
            {
                alert('Debe capturar la vigencia del contrato');
                return false;
            }
            return true;
        };

        function iferror(err)
        {
            alert('ERROR ' + err._message);
        };
        function limpia()
        {
            $('#txid').val(0)
            $('#txnombre').val('')
            $('#txcred').val('')
            $('#txfecini').val('')
            $('#txvigencia').val(0);
        };

        function cargalista()
        {
            PageMethods.cliente($('#hdpagina').val(), $('#dlbusca').val(), $('#txbusca').val(), $('#idusuario').val(), function (res)
            {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function ()
                {
                    if ($(this).children().eq(7).text() != 'Programado para baja')
                    {
                        limpia();
                        $('#txid').val($(this).children().eq(0).text())
                        //$('#txcodigo').val($(this).children().eq(2).text())
                        $('#txnombre').val($(this).children().eq(1).text())
                        $('#txcred').val($(this).children().eq(2).text())
                        $('#txvigenia').val($(this).children().eq(4).text())
                        datosprospecto();
                        $('#dvtabla').hide();
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    } else
                    {
                        alert('No se puede hacer modificaciones a un Prospecto programado para baja');
                    }
                });

                $('#tblista tbody tr').delegate(".btpbamodal", "click", function ()
                {
                    $("#divmodal").dialog('option', 'title', 'PRUEBA');
                    dialog.dialog('open');
                    //}
                }, iferror);
            })
        };

        function datosprospecto()
        {
                PageMethods.detalle($('#txid').val(), function (detalle)
                {
                    var datos = eval('(' + detalle + ')');
                    $('#txnombre').val(datos.nombre);
                    $('#txcred').val(datos.credito);
                    $('#txfecini').val(datos.fechaini);
                    $('#txvigencia').val(datos.vigencia);
                    //if (datos.descplazoentrega == "True") { $('#cbtiempo').prop("checked", true); } else { $('#cbtiempo').prop("checked", false); }
                    PageMethods.galleta($('#txid').val(), function (detalle)
                    {

                    });
                }, iferror);
        };

        function waitingDialog(waiting)
        {
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Proceso...');
            $("#loadingScreen").dialog('open');
            $(".ui-dialog-titlebar-close").css("display", "none");
        };

        function closeWaitingDialog()
        {
            $("#loadingScreen").dialog('close');
        };
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idprospecto1" runat="server" Value="0" />
        <asp:HiddenField ID="idejecutivo" runat="server" />
        <asp:HiddenField ID="idencargado" runat="server" />
        <asp:HiddenField ID="idempresa" runat="server" />
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
                    <h1>Catálogo de Prospectos<small>Ventas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Ventas</a></li>
                        <li class="active">Catálogo de clientes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-10">
                            <!-- Horizontal Form -->
                            <div class="box box-info     ">
                                <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txid">ID:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" disabled="disabled" value="0" />
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre:</label>
                                    </div>
                                    <div class="col-lg-7">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcred">Crédito:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txcred" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txfecini">F. Inicio:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecini" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txvigencia">Vigencia:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txvigencia" class="form-control" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                    <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                                    <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Clientes</a></li>
                                </ol>
                                <div class="box-footer">
                                    <input type="button" class="btn btn-primary" value="Oficinas" id="btoficinas" />
                                    <input type="button" class="btn btn-primary" value="Líneas de negocio" id="btlineas" />
                                    <input type="button" class="btn btn-primary" value="Puntos de atención" id="btinmueble" />
                                    <input type="button" class="btn btn-primary" value="Igualas" id="btiguala" />
                                    <input type="button" class="btn btn-primary" value="Plantilla" id="btplantilla" />
                                    <input type="button" class="btn btn-primary" value="Listados de Material" id="btlistamaterial" />
                                    <input type="button" class="btn btn-primary" value="Materiales autorizados" id="tblistaauto" />
                                    <input type="button" class="btn btn-primary" value="Materiales" id="btmaterial" />
                                    <input type="button" class="btn btn-primary" value="Herr. y eq." id="btherr" />
                                    <input type="button" class="btn btn-primary" value="Otros eq." id="btotroeq" />
                                    <!--<input type="button" class="btn btn-primary" value="Víaticos" id="btviatico" />-->
                                    <input type="button" class="btn btn-primary" value="Subcontratos" id="btsubcontrato" />
                                    <!--<input type="button" class="btn btn-primary" value="Gasto fin" id="btcostofin" />-->
                                    <input type="button" class="btn btn-primary" value="Prueba Modal" id="btpbamodal" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="dvtabla">
                        <div class="box box-info">
                            <div class="box-header">
                                    <!--<h3 class="box-title">Datos de vacante</h3>-->
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="a.nombre">Nombre</option>
                                        <%--<option value="b.nombre+b.paterno+b.materno">Ejecutivo</option>--%>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca"/>
                                </div>
                            </div>
                            <div class="col-md-18 tbheader">
                                <table class="table table-condensed" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-navy"><span>Id</span></th>
                                            <th class="bg-navy"><span>Nombre</span></th>
                                            <th class="bg-navy"><span>Credito</span></th>
                                            <th class="bg-navy"><span>F. Inicio</span></th>
                                            <th class="bg-navy"><span>Vigencia</span></th>
                                        </tr>
                                    </thead>
                                </table>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                </ol>
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
            <div id="divmodal" class="col-md-18">
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Fecha de baja:</label>
                    </div>
                    <div class="col-lg-3">
                        <input type="text" class="form-control" id="txfbaja"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3 text-right">
                        <label>Comentarios:</label>
                    </div>
                    <div class="col-lg-8">
                        <textarea id="txcomentario" class="form-control"></textarea>
                    </div>
                </div>
                <div class="box-footer">
                    <input type="button" class="btn btn-primary pull-right" value="Actualizar" id="btbaja" />
                </div>
            </div>  
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>

    </form>
</body>
</html>
