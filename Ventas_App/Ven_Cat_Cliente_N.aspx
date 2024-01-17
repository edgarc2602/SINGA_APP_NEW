<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_N.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_N" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CATALOGO DE CLIENTES</title>
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
            $('#dvdatos').hide();
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
            dialog = $('#divmodal').dialog({
                autoOpen: false,
                height: 250,
                width: 700,
                modal: true,
                close: function () {
                }
            });
            $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
            $('#txfbaja').datepicker({ dateFormat: 'dd/mm/yy' });
            if ($('#idcliente1').val() != 0) {
                $('#txid').val($('#idcliente1').val());
                datoscliente();
                $('#dvtabla').hide();
                $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
            }
            
            $('#btoficinas').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Oficinas.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 400, height = 400')
            });
            $('#btlineas').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_Lineas.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val() + '&monto=' + $('#txmonto').val(), '_blank', 'top = 100, left = 300, width = 500, height = 400')
            });
            //08/08/2023
            $('#btimportar').on('click', function () {
                var mywin = window.open('Ven_Descarga_Igualas.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val() + '&monto=' + $('#txmonto').val(), '_blank', 'top = 100, left = 300, width = 400, height = 400')
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
            $('#tblistaauto').on('click', function () {
                var mywin = window.open('Ven_Cat_Cliente_listaauto.aspx?id=' + $('#txid').val() + '&nombre=' + $('#txnombre').val(), '_blank', 'top = 100, left = 300, width = 900, height = 500')
            });
            cuentacliente();
            cargalista();
            cargaejecutivo();
            cargaencargado();
            cargaempresa();
            $('#btlista').on('click', function () {
                cargalista();
                $('#dvtabla').show();
                $('#dvdatos').hide();
            });

            $("#txdialimfact").on('input', function () {
                var valor = $(this).val();
                valor = valor.replace(/\D/g, "");
                if (valor == '') {
                    $(this).val('');
                }
                else
                {
                    var numero = parseInt(valor, 10);
                    if (numero > 31) {
                        alert('El número no puede ser mayor a 31');
                        $(this).val('');
                    } else {
                        $(this).val(numero);
                    }
                }
            });

            //Validar que solo escriban numeros con 1 punto decimal y 2 decimales
            //$("#txtotal").on('input', function ()
            //{
            //    var valor = $(this).val();
            //    valor = valor.replace(/[^0-9.]/g, "");
            //    var partes = valor.split(".");
            //    if (partes.length > 2)
            //    {
            //        valor = partes[0] + "." + partes[1];
            //    }
            //    var desppunto = valor.split(".");
            //    if (desppunto.length > 1)
            //    {
            //        var dosdec = partes[1];
            //        valor = partes[0] + "." + dosdec.substring(0,2);
            //    }
            //    $(this).val(valor);
            //});


            $('#btnuevo1').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btnuevo').on('click', function () {
                limpia();
                $('#dvtabla').hide();
                $('#dvdatos').show();
            })
            $('#btguarda').on('click', function () {
                if (valida()) {
                    waitingDialog({});
                    var fini = $('#txfecini').val().split('/');
                    var finicio = fini[2] + fini[1] + fini[0];

                    if ($('#txfecter').val() != '') {
                        farr = $('#txfecter').val().split('/');
                        var ffin = farr[2] + farr[1] + farr[0];
                    } else {ffin = ''}
                    var pmat = 0;
                    if ($('#cbmaterial').is(':checked')) {
                        pmat = 1;
                    }
                    var pser = 0;
                    if ($('#cbservicio').is(':checked')) {
                        pser = 1;
                    }
                    var ppla = 0;
                    if ($('#cbplantilla').is(':checked')) {
                        ppla = 1;
                    }
                    var ppzo = 0;
                    if ($('#cbtiempo').is(':checked')) {
                        ppzo = 1;
                    }
                    var xmlgraba = '<cliente id= "' + $('#txid').val() + '" tipo ="' + $('#dltipo').val() + '" nombre = "' + $('#txnombre').val() + '" contacto = "' + $('#txcontacto').val() + '" ';
                    xmlgraba += ' depto= "' + $('#txdepto').val() + '" puesto= "' + $('#txpuesto').val() + '" correo = "' + $('#txcorreo').val() + '" telefono = "' + $('#txtelefono').val() + '" ';
                    xmlgraba += ' ejecutivo = "' + $('#dlejecutivo').val() + '" encargado = "' + $('#dlencargado').val() + '" factura = "' + $('#dlperfac').val() + '" tipofac = "' + $('#dltipfac').val() + '" credito = "' + $('#txcred').val() + '" ';
                    xmlgraba += ' fini = "' + finicio + '" vigencia = "' + $('#txvigencia').val() + '" ffin = "' + ffin + '" usuario="' + $('#idusuario').val() + '"';
                    //xmlgraba += ' ptmat= "' + $('#txpmat').val() + '" ptind= "' + $('#txpind').val() + '" dialimfac="' + $('#txdialimfact').val() + '" montotot="' + $('#txtotal').val() + '" ';
                    xmlgraba += ' ptmat= "' + $('#txpmat').val() + '" ptind= "' + $('#txpind').val() + '" dialimfac="' + $('#txdialimfact').val() + '" montotot="0" ';
                    xmlgraba += ' pmat = "' + pmat + '" pser = "' + pser + '" ppla = "' + ppla + '" ppzo = "' + ppzo + '" empresa = "' + $('#dlempresa').val() + '" />';
                    PageMethods.guarda(xmlgraba, function (res) {
                        closeWaitingDialog();
                        $('#txid').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btelimina').click(function () {
                $("#divmodal").dialog('option', 'title', 'Programar baja de Cliente');
                dialog.dialog('open');

               
            })
            $('#btbaja').click(function () {
                if (validabaja()) {
                    //alert('hola');
                    waitingDialog({});
                    PageMethods.elimina($('#txid').val(), $('#txnombre').val(), $('#txfbaja').val(), $('#txcomentario').val(), $('#idejecutivo').val(), $('#idencargado').val(), function () {
                        closeWaitingDialog();
                        alert('El Cliente se ha registrado para baja automática, en la fecha señalada, ya no se podran realizar cambios a su registro.');
                        cargalista();
                        dialog.dialog('close');
                        $('#dvtabla').show();
                        $('#dvdatos').hide();
                    }, iferror);
                }
            })
            $('#txfecini').change(function () {
                if ($('#txfecini').val() != '' && $('#txvigencia').val() != '') {
                    calculatotal();
                }
            });
            $('#txvigencia').change(function () {
                if ($('#txvigencia').val() != '' && $('#txfecini').val() != '') {
                    calculatotal();
                }
            });    
            $('#btbusca').click(function () {
                cuentacliente();
                asignapagina(1)
                //cargalista();
            })
        });
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentacliente() {
            PageMethods.contarcliente($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);
            }, iferror);
        }
        function calculatotal() {
            var vdia = 0;
            var farr = $('#txfecini').val().split('/');
            var finicio = farr[2] + '/' + farr[1] + '/' + farr[0];
            var da = new Date(finicio);
            da.setMonth(da.getMonth() + parseInt($('#txvigencia').val()));
            if (da.getDate() < 10) {
                vdia = '0' + da.getDate();
            } else { vdia = da.getDate() }
            if (da.getMonth() + 1 < 10) {
                vmes = '0' + (da.getMonth() + 1);
            } else { vmes = da.getMonth() + 1 }
            var dfin = vdia + '/' + (vmes) + '/' + da.getFullYear();
            $('#txfecter').val(dfin);
        }
        function validabaja() {
            if ($('#txfbaja').val() == 0) {
                alert('Debe selecionar la fecha de baja');
                return false;
            }
            if ($('#txcomentario').val() == '') {
                alert('Debe capturar el motivo de la baja');
                return false;
            }
            return true;
        }
        function valida() {
            if ($('#dltipo').val() == 0) {
                alert('Debe selecionar si es Cliente o Prospecto');
                return false;
            }
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el Nombre comercial del Cliente');
                return false;
            }
            if ($('#dlejecutivo').val() == 0) {
                alert('Debe seleccionar un ejecutivo de cuenta');
                return false;
            }
            if ($('#dlperfac').val() == 0) {
                alert('Debe seleccionar el periódo de facturación');
                return false;
            }
            if ($('#dltipfac').val() == 0) {
                alert('Debe seleccionar el tipo de facturación');
                return false;
            }
            if ($('#txfecini').val() == '') {
                alert('Debe capturar la fecha de inicio de contrato');
                return false;
            }
            if ($('#txvigencia').val() == '') {
                alert('Debe capturar la vigencia del contrato');
                return false;
            }
            return true;
        };
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        function limpia() {
            $('#txid').val(0)
            $('#txcodigo').val('')
            $('#txnombre').val('')
            $('#txfecini').val('')
            $('#txcontacto').val('')
            $('#txpuesto').val('')
            $('#txtelefono').val('')
            $('#txdepto').val('');
            $('#txcorreo').val('');
            $('#dldirector').val(0);
            $('#dlejecutivo').val(0);
            $('#dlencargado').val(0);
            $('#dlperfac').val(0);
            $('#dltipfac').val(0);
            $('#txcred').val(0);
            $('#txvigencia').val(0);
            $('#txfecter').val('');
            $('#txpmat').val(0);
            $('#txpind').val(0);

            $('#txtotal').val(0);

            $('#txdialimfact').val(0);

            $('#cbmaterial').prop("checked", false)
            $('#cbservicio').prop("checked", false)
            $('#cbplantilla').prop("checked", false)
            $('#cbtiempo').prop("checked", false)
            $('#dltipo').val(0);
            $('#dlempresa').val(0);
        }
        function cargalista() {
            PageMethods.cliente($('#hdpagina').val(), $('#dlbusca').val(), $('#txbusca').val(), $('#idusuario').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    if ($(this).children().eq(7).text() != 'Programado para baja') {
                        limpia();
                        $('#txid').val($(this).children().eq(0).text())
                        $('#txcodigo').val($(this).children().eq(2).text())
                        $('#txnombre').val($(this).children().eq(1).text())
                        $('#txfecini').val($(this).children().eq(3).text())
                        $('#txcontacto').val($(this).children().eq(4).text())
                        $('#txpuesto').val($(this).children().eq(5).text())
                        $('#txtelefono').val($(this).children().eq(6).text())
                        datoscliente();
                        $('#dvtabla').hide();
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                    } else {
                        alert('No se puede hacer modificaciones a un Cliente programado para baja');
                    }
                });
            }, iferror);
        };
        function datoscliente() {
            PageMethods.detalle($('#txid').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txdepto').val(datos.departamento);
                $('#txcorreo').val(datos.email);
                $('#dldirector').val(datos.id_director);
                $('#idejecutivo').val(datos.id_ejecutivo);
                cargaejecutivo();
                $('#idencargado').val(datos.id_operativo);
                cargaencargado();
                $('#dlperfac').val(datos.periodofactura);
                $('#dltipfac').val(datos.tipofactura);
                $('#txcred').val(datos.credito);
                $('#txvigencia').val(datos.vigencia);
                $('#txfecter').val(datos.fechatermino);
                $('#txpmat').val(datos.porcmat);
                $('#txpind').val(datos.porcind);

                $('#txdialimfact').val(datos.limite_facturar);
                /*$('#txtotal').val(datos.monto_total);*/

                if (datos.descmateriales == "True") { $('#cbmaterial').prop("checked", true); } else { $('#cbmaterial').prop("checked", false);}
                if (datos.descservicios == "True") { $('#cbservicio').prop("checked", true); } else { $('#cbservicio').prop("checked", false); }
                if (datos.descplantillas == "True") { $('#cbplantilla').prop("checked", true); } else { $('#cbplantilla').prop("checked", false); }
                if (datos.descplazoentrega == "True") { $('#cbtiempo').prop("checked", true); } else { $('#cbtiempo').prop("checked", false); }
                $('#dltipo').val(datos.id_tipocliente);
                $('#dlempresa').val(datos.empresa);

                PageMethods.galleta($('#txid').val(), function (detalle) {

                });
            }, iferror);
        };
        function cargaejecutivo() {
            PageMethods.empleado(6, 'esejecutivo', $('#idusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlejecutivo').empty();
                $('#dlejecutivo').append(inicial);
                $('#dlejecutivo').append(lista);
                $('#dlejecutivo').val(0);
                if ($('#idejecutivo').val() != '') {
                    $('#dlejecutivo').val($('#idejecutivo').val());
                };
            }, iferror);
        }
        function cargaencargado() {
            PageMethods.empleado(4, 'esencargado', $('#idusuario').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlencargado').empty();
                $('#dlencargado').append(inicial);
                $('#dlencargado').append(lista);
                $('#dlencargado').val(0);
                if ($('#idencargado').val() != '') {
                    $('#dlencargado').val($('#idencargado').val());
                };
            }, iferror);
        }
        function cargaempresa() {
            PageMethods.empresa(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlempresa').empty();
                $('#dlempresa').append(inicial);
                $('#dlempresa').append(lista);
                $('#dlempresa').val(0);
                if ($('#idempresa').val() != '') {
                    $('#dlempresa').val($('#idempresa').val());
                };
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
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <!--<asp:HiddenField ID="idcliente" runat="server" />-->
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" Value="0" />
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
                    <h1>Catálogo de Clientes<small>Ventas</small></h1>
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
                                    <div class="col-lg-1">
                                        <label for="txcodigo">Código:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txcodigo" class="form-control" disabled="disabled" value="0" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">Tipo:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipo" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="1">Cliente</option>
                                            <option value="2">Prospecto</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txnombre">Nombre comercial:</label>
                                    </div>
                                    <div class="col-lg-7">
                                        <input type="text" id="txnombre" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txcontacto">Contacto:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcontacto" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txdepto">Departamento:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txdepto" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txpuesto">Puesto:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txpuesto" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txcorreo">Email:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txcorreo" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txtelefono">Telefonos:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <input type="text" id="txtelefono" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlejecutivo">Ejecutivo de cuenta:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <select id="dlejecutivo" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlencargado">Gerente Limpieza:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <select id="dlencargado" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlempresa">Empresa pagadora:</label>
                                    </div>
                                    <div class="col-lg-4">
                                        <select id="dlempresa" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlperfac">Facturación:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlperfac" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="Mes Corriente">Mes Corriente</option>
                                            <option value="Mes Vencido">Mes Vencido</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="dltipfac">Tipo Factura:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dltipfac" class=" form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="Por Iguala">Por Iguala</option>
                                            <option value="Por Evento">Por Evento</option>
                                            <option value="Por Estimación">Por Estimación</option>
                                        </select>
                                    </div>
                                    <div class="col-lg-1">
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
                                    <div class="col-lg-1">
                                        <label for="txfecter">F. Termino:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecter" class="form-control" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txpmat">% Materiales:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txpmat" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txpind">% Indirectos:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txpind" class="form-control" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="txdialimfac">Día Lim. Facturar:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txdialimfact" class="form-control" />
                                    </div>

                                    <%--<div class="col-lg-1">
                                        <label for="txdialimfac">Monto total:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txtotal" class="form-control" />
                                    </div>--%>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label>Deductivas por:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbmaterial" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbmaterial" class="text-left">Materiales</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbservicio" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbervicio">Servicios</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbplantilla" />
                                    </div>
                                    <div class="col-lg-1">
                                        <label for="cbplantilla">Plantilla</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="checkbox" id="cbtiempo" />
                                    </div>
                                    <div class="col-lg-2">
                                        <label for="cbtiempo">Plazo de entrega</label>
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
                                    <%--<input type="button" class="btn btn-primary" value="Importar Igualas" id="btimportar" style="width: 191px" />--%>
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
                                        <option value="b.nombre+b.paterno+b.materno">Ejecutivo</option>
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
                                            <th class="bg-navy"><span>Ejecutivo</span></th>
                                            <th class="bg-navy"><span>F. Inicio</span></th>
                                            <th class="bg-navy"><span>Contacto</span></th>
                                            <th class="bg-navy"><span>Puesto</span></th>
                                            <th class="bg-navy"><span>Telefono</span></th>
                                            <th class="bg-navy"><span>Estatus</span></th>
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
