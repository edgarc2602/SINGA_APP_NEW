<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Con_Cliente_Cedula.aspx.vb" Inherits="Ventas_App_Ven_Con_Cliente_Cedula" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE PROYECTOS</title>
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
   

    <style type="text/css">
        #totaliguala {
            margin-left:50%;
            color:#071D49;
        }
        .border-buttom-red{
            border-bottom: 2px solid #ff6c6c;
        }
        .border-top-red{
            border-top: 2px solid #ff6c6c;
        }
        li:hover{
            cursor:pointer;
        }
        .grey {
            background: #5D7B9D;
            -moz-border-radius: 100%;
            -webkit-border-radius: 100%;
            border-radius: 100%;
            color: #fff;
            display: inline-block;
            font-weight: bold;
            line-height: 1.6em;
            margin-right: 10px;
            text-align: center;
            width:2em;
            padding:5px;            
            cursor:pointer;
        }   
    </style>
    <script type="text/javascript">
        var dialog;
        var inicial = '<option value=0>Seleccione...</option>'
        
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#hdpagina1').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#hdpagina2').val(1); // ASIGNACION DEL INICIO DE PAGINA
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
            oculta();
            cargacliente();
            $('#btresumen').click(function () {
                cargaresumen($('#dlcliente').val());
                oculta();
                $('#dvresumen').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btgenerales').click(function () {
                if ($('#dlcliente').val() == 0) {
                    alert('Debe elegir un Cliente');
                } else {
                    cargagenerales($('#dlcliente').val());
                    cargarfc($('#dlcliente').val());
                    oculta();
                    $('#dvgenerales').toggle('slide', { direction: 'down' }, 700);
                }
            })
            $('#btlineas').click(function () {
                cargalineas($('#dlcliente').val());
                oculta();
                $('#dvlineas').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btdocumentos').click(function () {
                oculta();
                $('#dvdocumentos').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btoficinas').click(function () {
                oculta();
                $('#dvoficinas').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btsucursal').click(function () {
                if ($('#dlcliente').val() == 0) {
                    alert('Debe elegir un Cliente');
                } else {
                    cuentapuntos($('#dlcliente').val(),'','');
                    cargapuntos($('#dlcliente').val(),'','');
                    oculta();
                    $('#dvsucursall').toggle('slide', { direction: 'down' }, 700);
                }
            })
            $('#btiguala').click(function () {
                oculta();
                $('#dviguala').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btplantilla').click(function () {
                if ($('#dlcliente').val() != 0) {
                    cuentaplantilla($('#dlcliente').val());
                    cargaplantilla($('#dlcliente').val())
                    oculta();
                    $('#dvplantilla').toggle('slide', { direction: 'down' }, 700);
                } else { alert('Debe elegir un Cliente');}
            })
            $('#btmaterial').click(function () {
                cargamaterial($('#dlcliente').val())
                oculta();
                $('#dvmaterial').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btherramienta').click(function () {
                cargaherramienta($('#dlcliente').val())
                oculta();
                $('#dvherramienta').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btotroequipo').click(function () {
                cargaotroequipo($('#dlcliente').val())
                oculta();
                $('#dvotros').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btviatico').click(function () {
                cargaviatico($('#dlcliente').val())
                oculta();
                $('#dvviatico').toggle('slide', { direction: 'down' }, 700);
            })
            $('#btsubcontrato').click(function () {
                cargasubcontrato($('#dlcliente').val());
                oculta();
                $('#dvsubcontrato').toggle('slide', { direction: 'down' }, 700);
            })
            $('#dllinea').change(function () {
                if ($('#dllinea').val() != 0) {
                    cuentaiguala($('#dlcliente').val(), $('#dllinea').val())
                    cargaiguala($('#dlcliente').val(), $('#dllinea').val())
                } else { alert('Debe elegir una línea de negocio');}
            })
            $('#btregresa').click(function () {
                $('#dvsucursall').toggle('slide', { direction: 'down' }, 700);
                $('#dvsucursald').hide();
            })
            $('#btbuscainm').click(function () {
                if ($('#dlbuscainm').val() == 0) {
                    cuentapuntos($('#dlcliente').val(), '', '');
                    cargapuntos($('#dlcliente').val(), '', '');
                } else {
                    if ($('#txbuscainm').val() != '') {
                        cuentapuntos($('#dlcliente').val(), $('#txbuscainm').val(), $('#dlbuscainm').val());
                        cargapuntos($('#dlcliente').val(), $('#txbuscainm').val(), $('#dlbuscainm').val());
                    } else { alert('Debe colocar un dato a buscar');}
                }
            })
            $('#btexportasuc').click(function () {
                window.open('Ven_Descargainmueble.aspx?cliente=' + $('#dlcliente').val(), '_blank');
            })
        });
        function asignapagina(np) { 
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargapuntos($('#dlcliente').val(), $('#txbuscainm').val(), $('#dlbuscainm').val());
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function asignapagina1(np) {
            $('#paginacion1 li').removeClass("active");
            $('#hdpagina1').val(np);
            cargaiguala($('#dlcliente').val(), $('#dllinea').val());
            $('#paginacion1 li').eq(np - 1).addClass("active");
        }
        function asignapagina2(np) {
            $('#paginacion2 li').removeClass("active");
            $('#hdpagina2').val(np);
            cargaplantilla($('#dlcliente').val());
            $('#paginacion2 li').eq(np - 1).addClass("active");
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
                    if ($('#dlcliente').val() == 136) {
                        if ($('#idusuario').val() == 1 || $('#idusuario').val() == 27 || $('#idusuario').val() == 43 || $('#idusuario').val() == 5 || $('#idusuario').val() == 59) {
                            lineascliente($('#dlcliente').val());
                            cargaresumen($('#dlcliente').val());
                            oculta();
                            $('#dvresumen').toggle('slide', { direction: 'down' }, 700);
                        } else {
                            alert('Usted no tiene permisos para ver la información de este cliente')
                            $('#dlcliente').val(0)
                        }
                    } else {
                        lineascliente($('#dlcliente').val());
                        cargaresumen($('#dlcliente').val());
                        oculta();
                        $('#dvresumen').toggle('slide', { direction: 'down' }, 700);
                    }
                })
            });
        }
        function cargaresumen(idcte) {
            waitingDialog({});
            $('#riguala').text('');
            $('#rmanoobra').text('');
            $('#rcargasoc').text('');
            $('#rprovision').text('');
            $('#runiforme').text('');
            $('#rmaterial').text('');
            $('#rherramienta').text('');
            $('#rotroequipo').text('');
            $('#rsubcontrato').text('');
            $('#rviaticos').text('');
            $('#tcosto').text('');
            $('#rrenta').text('');
            $('#prenta').text('');
            PageMethods.resumen(idcte, function (detalle) {
                closeWaitingDialog();
                var datos = eval('(' + detalle + ')');
                $('#riguala').text(datos.iguala);
                $('#rmanoobra').text(datos.salario);
                $('#rcargasoc').text(datos.cargasocial);
                $('#rprovision').text(datos.provision);
                $('#runiforme').text(datos.uniforme);
                $('#rmaterial').text(datos.material);
                $('#rherramienta').text(datos.herramienta);
                $('#rotroequipo').text(datos.otroequipo);
                $('#rsubcontrato').text(datos.subcontrato);
                $('#rviaticos').text(datos.viatico);
                $('#tcosto').text(datos.tcosto);
                $('#rrenta').text(datos.margen);
                $('#prenta').text(datos.pmargen);
            }, iferror);
        }
        function cargagenerales(idcte) {
            PageMethods.generales(parseInt(idcte), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txid').val(idcte);
                $('#txcliente').val(datos.nombre);
                $('#txcodigo').val(datos.codigo);
                $('#txencargado').val(datos.operativo);
                $('#txcontacto').val(datos.contacto);
                $('#txpuesto').val(datos.puesto);
                $('#txdepto').val(datos.departamento);
                $('#txemail').val(datos.email);
                $('#txtel1').val(datos.telefono);
                $('#txfini').val(datos.fechainicio);
                $('#txffin').val(datos.fechatermino);
                $('#txfactura').val(datos.periodofactura);
                $('#txtipof').val(datos.tipofactura);
                $('#txcredito').val(datos.credito);
                if (datos.descmateriales == 'True') { $('#cbmateriales').prop("checked", true); } else { $('#cbmateriales').prop("checked", false); }
                if (datos.descservicios == 'True') { $('#cbservicio').prop("checked", true); } else { $('#cbservicio').prop("checked", false); }
                if (datos.descplantillas == 'True') { $('#cbplantilla').prop("checked", true); } else { $('#cbplantilla').prop("checked", false); }
                if (datos.descplazoentrega == 'True') { $('#cbplazo').prop("checked", true); } else { $('#cbplazo').prop("checked", false); }
                $('#txsucursal').val(datos.totinm);
                $('#txplantilla').val(datos.totpers);
                $('#txventas').val(datos.ventas);
            }, iferror);
        }

        function cargarfc(idcte) {
            PageMethods.generalesrfc(idcte, function (res) {
                var ren = $.parseHTML(res);
                $('#tbdomicilio tbody').remove();
                $('#tbdomicilio').append(ren);
            }, iferror);
        }
        function lineascliente(idcte) {
            PageMethods.lineacliente(idcte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dllinea').empty();
                $('#dllinea').append(inicial);
                $('#dllinea').append(lista);
                $('#dllinea').val(0);
            }, iferror);
        }
        function cargalineas(idcte) {
            PageMethods.lineas(idcte, function (res1) {
                var ren1 = $.parseHTML(res1);
                $('#tblineas tbody').remove();
                $('#tblineas').append(ren1);
            }, iferror);
        }
        function cuentapuntos(idcte, dato, campo) {
            PageMethods.contarpuntos(idcte, dato, campo, function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function cargapuntos(idcte, dato, campo) {
            PageMethods.puntos(idcte, $('#hdpagina').val(), dato, campo, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbsucursal tbody').remove();
                $('#tbsucursal').append(ren2);
                $('#tbsucursal tbody tr').click(function () {
                    $('#txidinm').val($(this).closest('tr').find('td').eq(0).text());
                    PageMethods.puntosdetalle(parseInt($(this).closest('tr').find('td').eq(0).text()), function (detalle) {
                        var datos = eval('(' + detalle + ')');
                        $('#txnombre').val(datos.nombre);
                        $('#txnosuc').val(datos.nosuc);
                        $('#txcc').val(datos.CentroCosto);
                        $('#txoficina').val(datos.oficina);
                        $('#txtipo').val(datos.tipo);
                        $('#txcalle').val(datos.direccion);
                        $('#txecalles').val(datos.entrecalles)
                        $('#txcolonia').val(datos.colonia);
                        $('#txdelmun').val(datos.delmun);
                        $('#txcp').val(datos.cp);
                        $('#txciudad').val(datos.ciudad);
                        $('#txestado').val(datos.estado);
                        $('#txtel2').val(datos.tel1);
                        $('#txtel3').val(datos.tel2);
                        $('#txcontacto1').val(datos.contacto);
                        $('#txcorreo').val(datos.correo);
                        $('#txcargo').val(datos.cargo);
                        $('#txpttolim').val(datos.ptto1);
                        $('#txpttohig').val(datos.ptto2);
                        $('#txpttoman').val(datos.ptto3);
                        $('#txpttobas').val(datos.ptto4);
                    });
                    $('#dvsucursall').hide();
                    $('#dvsucursald').toggle('slide', { direction: 'down' }, 700);
                });
            }, iferror);
        }
        function cuentaplantilla(idcte) {
            PageMethods.contarplantilla(idcte, function (cont) {
                $('#paginacion2 li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina2(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion2').append(pag);
            }, iferror);
        }
        function cuentaiguala(idcte, idlinea) {
            PageMethods.contariguala(idcte, idlinea, function (cont) {
                $('#paginacion1 li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina1(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion1').append(pag);
            }, iferror);
        }
        function cargaiguala(idcte, idlinea) {
            PageMethods.igualas(idcte, idlinea, $('#hdpagina1').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbiguala tbody').remove();
                $('#tbiguala').append(ren);
            }, iferror);
        }
        function cargaplantilla(idcte) {
            PageMethods.plantilla(idcte, $('#hdpagina2').val(), function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbplantilla tbody').remove();
                $('#tbplantilla').append(ren2);
            }, iferror);
        }
        function cargamaterial(idcte) {
            PageMethods.materiales(idcte, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbmaterial tbody').remove();
                $('#tbmaterial').append(ren2);
            }, iferror);
        }
        function cargaherramienta(idcte) {
            PageMethods.herramientas(idcte, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbherramienta tbody').remove();
                $('#tbherramienta').append(ren2);
            }, iferror);
        }
        function cargaotroequipo(idcte) {
            PageMethods.otroequipo(idcte, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbotroequipo tbody').remove();
                $('#tbotroequipo').append(ren2);
            }, iferror);
        }
        function cargaviatico(idcte) {
            PageMethods.viaticos(idcte, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbviatico tbody').remove();
                $('#tbviatico').append(ren2);
            }, iferror);
        }
        function cargasubcontrato(idcte) {
            PageMethods.subcontratos(idcte, function (res2) {
                var ren2 = $.parseHTML(res2);
                $('#tbsubcontrato tbody').remove();
                $('#tbsubcontrato').append(ren2);
            }, iferror);
        }
        function oculta() {
            $('#dvresumen').hide();
            $('#dvgenerales').hide();
            $('#dvlineas').hide();
            $('#dvdocumentos').hide();
            $('#dvoficinas').hide();
            $('#dvsucursall').hide();
            $('#dviguala').hide();
            $('#dvplantilla').hide();
            $('#dvmaterial').hide();
            $('#dvherramienta').hide();
            $('#dvotros').hide();
            $('#dvviatico').hide();
            $('#dvsubcontrato').hide();
            $('#dvsucursald').hide();
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
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idproyecto" runat="server" />
        <asp:HiddenField ID="idcliente" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="hdpagina1" runat="server" />
        <asp:HiddenField ID="hdpagina2" runat="server" />
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
                    <h1>Cédula de clientes
                        <small>Ventas</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Ventas</a></li>
                        <li class="active">Cédula de clientes</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row fa-border">
                        <div class="col-lg-4 text-right">
                            <label for="dlcliente">Elegir Cliente</label>
                        </div>
                        <div class="col-lg-4">
                            <select id="dlcliente" class="form-control"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <ul class="list-group"> <!--bg-olive-->
                                <li class="list-group-item bg-light-blue-gradient" id="btresumen">Resumen</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btgenerales">Datos Generales</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btlineas">Líneas de negocio</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btdocumentos">Documentos</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btoficinas">Oficinas</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btsucursal">Puntos de atención</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btiguala">Igualas</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btplantilla">Personal</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btmaterial">Materiales</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btherramienta">Herramienta y equipo</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btotroequipo">Equipo adicional</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btviatico">Viáticos</li>
                                <li class="list-group-item bg-light-blue-gradient" id="btsubcontrato">Subcontratos</li>
                            </ul>
                        </div>
                        <div id="dvresumen" class=" tab-content col-md-10">
                            <div class="content-header">
                                <h1>Resumen</h1>
                            </div>
                            <!--<input type="button" id="btgeneral" value="Concentrado" class="ph-button ph-btn-blue" />
                            <input type="button" id="btporlinea" value="Por línea de negocio" class="ph-button ph-btn-green" />-->
                            <div  id="dvconsolidado">
                                <table class=" margin table table-condensed">
                                    <tr>
                                        <td class="col-lg-2 text-bold text-navy border-buttom-red h4">Iguala</td>
                                        <td class="col-lg-2 text-bold text-navy text-right border-buttom-red h4" id="riguala"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Mano de Obra</td>
                                        <td id="rmanoobra" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Carga Social</td>
                                        <td id="rcargasoc" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Provisiones</td>
                                        <td id="rprovision" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Uniformes</td>
                                        <td id="runiforme" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Materiales</td>
                                        <td id="rmaterial" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Herr. y equipo</td>
                                        <td id="rherramienta" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Equipo adicional</td>
                                        <td id="rotroequipo" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy h4">Subcontratos</td>
                                        <td id="rsubcontrato" class="col-lg-2 text-navy text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy border-buttom-red h4">Viáticos</td>
                                        <td id="rviaticos" class="col-lg-2 text-navy border-buttom-red text-right h4"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy text-bold border-buttom-red h4">Total de Costo</td>
                                        <td id="tcosto" class="col-lg-2 text-navy border-buttom-red text-right h4 text-bold"></td>
                                    </tr>
                                    <tr>
                                        <td class="col-lg-2 text-navy text-bold h4">Margen operativo</td>
                                        <td id="rrenta" class="col-lg-2 text-navy text-right h4 text-bold"></td>
                                        <td id="prenta" style="width: 100px;" class="col-lg-2 h4 text-navy text-bold"></td>
                                    </tr>
                                </table>
                            </div>
                            
                        </div>
                        <div id="dvgenerales" class=" tab-content col-md-10">
                            <!--class="detalles"-->
                            <div class="row">
                                <div class="content-header">
                                    <h1>Datos generales</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txcliente">Nombre</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcliente" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcodigo">Código</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txcodigo" class="form-control" disabled="disabled" />

                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txid" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txencargado">Enc. Ventas</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txventas" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txencargado">Enc. Operativo</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txencargado" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txcontacto">Contacto</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txcontacto" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txpuesto">Puesto</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txpuesto" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txdepto">Depto.</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txdepto" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txemail">Correo</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txemail" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txtel1">Telefono</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtel1" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txfini">F. Inicio</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfini" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txffin">F. termino</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txffin" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txfactura">Facturación</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txfactura" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txtipof">Tipo Factura</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtipof" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcredito">Crédito</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcredito" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label>Días</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <label>Penalizaciones</label>
                                </div>
                                <div class="col-lg-6">
                                    <input type="checkbox" id="cbmateriales" disabled="disabled" /><label for="cbmateriales">Materiales</label>
                                    <input type="checkbox" id="cbservicio" disabled="disabled" /><label for="cbservicio">Servicio</label>
                                    <input type="checkbox" id="cbplantilla" disabled="disabled" /><label for="cbplantilla">Plantilla</label>
                                    <input type="checkbox" id="cbplazo" disabled="disabled" /><label for="cbplazo">Plazo de entrega</label>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                
                                <div class="col-lg-2">
                                    <label for="txsucursal">No. Sucursales</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txsucursal" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-2">
                                    <label for="txplantilla">No. Empleados</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txplantilla" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <hr />
                            <div class="tbheader">
                                <table id="tbdomicilio" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>RFC</span></th>
                                            <th class="bg-light-blue-gradient"><span>Razón Social</span></th>
                                            <th class="bg-light-blue-gradient"><span>Domicilio</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvlineas" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Lneas de negocio</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="tbheader">
                                <table id="tblineas" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Aplica Iguala</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvdocumentos" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Documentos del cliente</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-2">
                                    <label for="txfileload">Cargar Archivo</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="file" id="txfileload" class="form-control" />
                                </div>
                                <div class="col-lg-2">
                                     <input type="button" class="form-control btn btn-primary" value="Subir"/>
                                </div>
                            </div>
                            <div class="tbheader">
                                <table id="´tbdocumentos" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Nombre del Archivo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Acción</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvoficinas" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Oficinas</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="tbheader">
                                <table id="´tboficinas" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Oficina</span></th>
                                            <th class="bg-light-blue-gradient"><span>Dirección</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvsucursall" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Puntos de atención</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="row"> 
                                <div class="col-lg-2 text-right">
                                    <label for="dlbuscainm">Buscar por</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlbuscainm" class="form-control">
                                        <option value="0">Todos..</option>
                                        <option value="c.nombre">Oficina</option>
                                        <option value="a.nombre">Nombre</option>
                                        <option value="a.nosuc">No. suc.</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbuscainm" class="form-control" />
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" id="btbuscainm" class="form-control btn btn-primary" value="Mostrar"/>
                                </div>
                                <div class="col-lg-2">
                                    <input type="button" id="btexportasuc" class="form-control btn btn-primary" value="Exportar a excel"/>
                                </div>
                            </div>                           
                            <div class="tbheader" style="height:400px; overflow-y:scroll;">
                                <table id="tbsucursal" class="table" >
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Id</span></th>
                                            <th class="bg-light-blue-gradient"><span>Oficina</span></th>
                                            <th class="bg-light-blue-gradient"><span>Punto de Atención</span></th>
                                            <th class="bg-light-blue-gradient"><span>No. Suc.</span></th>
                                            <th class="bg-light-blue-gradient"><span>Plantilla</span></th>
                                            <th class="bg-light-blue-gradient"><span>Dirección</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ptto lim</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ptto Manto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ptto Hig</span></th>
                                            <th class="bg-light-blue-gradient"><span>Ptto Bas</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <nav aria-label="Page navigation example" class="navbar-right">
                                <ul class="pagination justify-content-end" id="paginacion">
                                    <!--<li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Next</a>
                                    </li>-->
                                </ul>
                            </nav>
                        </div>
                        <div id="dvsucursald" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Puntos de atención</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txidinm">ID:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txidinm" class="form-control" disabled="disabled" value="0"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txnombre">Nombre:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txnombre" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txnosuc">No. Suc:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txnosuc" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcc">CentroCosto:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcc" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txoficina">Oficina:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txoficina" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1">
                                    <label for="txtipo">Tipo Inm:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtipo" class="form-control" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txcalle">Calle y num:</label>
                                </div>
                                <div class="col-lg-4">
                                    <input type="text" id="txcalle" class="form-control" disabled="disabled" />
                                </div>
                                <div class="col-lg-1 text-right">
                                    <label for="txecalles">Entre calles:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txecalles" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txcolonia">Colonia:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txcolonia" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txdelmun">Del/Mun:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txdelmun" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcp">CP:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txcp" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txciudad">Ciudad:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txciudad" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txestado">Estado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txestado" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txtel2">Telefono1:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtel2" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txtel3">Telefono2:</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="text" id="txtel3" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txcontacto1">Contacto:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcontacto1" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txcorreo">Correo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcorreo" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txcargo">Cargo:</label>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txcargo" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-1">
                                    <label for="txpttolim">Ptto Limp:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txpttolim" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txpttohig">Ptto Hig:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txpttohig" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txpttoman">Ptto Manto:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txpttoman" class="form-control" disabled="disabled"/>
                                </div>
                                <div class="col-lg-1">
                                    <label for="txpttobas">Ptto Basura:</label>
                                </div>
                                <div class="col-lg-1">
                                    <input type="text" id="txpttobas" class="form-control" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2">
                                    <input type="button" id="btregresa" class="form-control btn btn-primary" value="Regresar"/>
                                </div>
                            </div>
                        </div>
                        <div id="dviguala" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Igualas</h1>
                                </div>
                            </div>
                            <hr />
                            <div class="row"> 
                                <div class="col-lg-2 text-right">
                                    <label for="dlbuscainm">Línea de Negocio</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dllinea" class="form-control"></select>
                                </div>
                                <div class="col-lg-2">
                                    <label id="lbtotaliguala"></label>
                                </div>
                            </div>                           
                            <div class="tbheader">
                                <table id="tbiguala" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Oficina</span></th>
                                            <th class="bg-light-blue-gradient"><span>Punto de Atención</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea de negocio</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <nav aria-label="Page navigation example" class="navbar-right">
                                <ul class="pagination justify-content-end" id="paginacion1">
                                    <!--<li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Next</a>
                                    </li>-->
                                </ul>
                            </nav>
                        </div>
                        <div id="dvplantilla" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Plantilla de personal</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbplantilla" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Folio</span></th>
                                            <th class="bg-light-blue-gradient"><span>Punto de Atención</span></th>
                                            <th class="bg-light-blue-gradient"><span>Puesto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cantidad</span></th>
                                            <th class="bg-light-blue-gradient"><span>Turno</span></th>
                                            <th class="bg-light-blue-gradient"><span>Jornal</span></th>
                                            <th class="bg-light-blue-gradient"><span>Salario</span></th>
                                            <th class="bg-light-blue-gradient"><span>Carga Social</span></th>
                                            <th class="bg-light-blue-gradient"><span>Uniforme</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <nav aria-label="Page navigation example" class="navbar-right">
                                <ul class="pagination justify-content-end" id="paginacion2">
                                    <!--<li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Previous</a>
                                    </li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Next</a>
                                    </li>-->
                                </ul>
                            </nav>
                        </div>
                        <div id="dvmaterial" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Presupuesto Materiales</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbmaterial" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Frecuencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvherramienta" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Presupuesto Herramienta y equipo</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbherramienta" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Frecuencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvotros" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Presupuesto Equipo adicional</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbotroequipo" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Frecuencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cantidad</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvviatico" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Presupuesto Viáticos</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbviatico" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Frecuencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <div id="dvsubcontrato" class="tab-content col-md-10">
                            <div class="row">
                                <div class="content-header">
                                    <h1>Presupuesto Subcontratos</h1>
                                </div>
                            </div>
                            <hr />              
                            <div class="tbheader">
                                <table id="tbsubcontrato" class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>Concepto</span></th>
                                            <th class="bg-light-blue-gradient"><span>Línea</span></th>
                                            <th class="bg-light-blue-gradient"><span>Frecuencia</span></th>
                                            <th class="bg-light-blue-gradient"><span>Importe</span></th>
                                            <th class="bg-light-blue-gradient"><span>F. Aplica</span></th>
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
