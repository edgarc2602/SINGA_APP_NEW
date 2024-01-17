<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Fin_Pro_PendientePago.aspx.vb" Inherits="App_Finanzas_Fin_Pro_PendientePago" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>FACTURAS PENDIENTES DE PAGO</title>
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
        #tblistaf thead th:nth-child(5), #tblistaf tbody td:nth-child(5){
            width:100px;
        }
        .auto-style1 {
            position: relative;
            min-height: 1px;
            top: -4px;
            left: 6px;
            float: left;
            width: 270px;
            padding-left: 15px;
            padding-right: 15px;
        }
        .auto-style2 {
            color: #fff;
            width: 270px;
            background-color: #357ca5;
        }
    </style>
    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            dialog1 = $('#divmodal1').dialog(
                {
                    autoOpen: false,
                    height: 450,
                    width: 800,
                    modal: true,
                    close: function () {
                    }
                });
            dialog2 = $('#divmodal2').dialog(
                {
                    autoOpen: false,
                    height: 450,
                    width: 800,
                    modal: true,
                    close: function () {
                    }
                });

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
                    open: function () {
                        // scrollbar fix for IE
                        $('body').css('overflow', 'hidden');
                    },
                    close: function () {
                        // reset overflow
                        $('body').css('overflow', 'auto');
                    }
                });
            var f = new Date();
            var dd = f.getDate()
            if (dd.toString().length == 1) {
                dd = "0" + dd
            }
            var mm = f.getMonth() + 1
            if (mm.toString().length == 1) {
                mm = "0" + mm
            }
            $('#txfecha').val(dd + "/" + mm + "/" + f.getFullYear() + ' ' + f.getHours() + ':' + f.getMinutes());
            $('#dvfactura').hide();

            cargacliente();

            /*cargalinea();*/
            if ($('#idsol').val() != 0) {
                cargasolicitud($('#idsol').val());
            }

            //$('#btfacturas').click(function () {
            //    cargaconcepto();
            //})
            var campoTexto = document.getElementById("tximporte");
            campoTexto.addEventListener("input", function () {
                var valor = this.value;
                valor = valor.replace(/[^0-9.]/g, "");
                this.value = valor;
            });

            $('#dlcliente').change(function () {
                cargaconcepto();
            })

            $('#btagrega').click(function ()
            {
                if (validaconcepto())
                {
                    var cadena = $('#dlconcepto option:selected').text()
                    var partes = cadena.split("-");
                    var serie = partes[0];
                    var folio = partes[1];
                    PageMethods.regresadatos(serie, folio, function (res)
                    {
                        var ren = res;
                        var partessal = ren.split("|")
                        var saldo = $('#tximporte').val();//partessal[0];//$('#tximporte').val();
                        var uuid = partessal[1];
                        var id = partessal[2];

                        //alert('saldo: ' + $('#tximporte').val())
                        //var linea = '<tr><td>' + $('#dlconcepto').val() + '</td><td>' + $('#dlconcepto option:selected').text() + '</td><td><input class="form-control text-right tbeditar" value=' + $('#tximporte').val() + ' /></td>'
                        var linea = '<tr><td>' + $('#dlconcepto').val() + '</td> <td>' + uuid + '</td> + <td>' + serie + '-' + folio + '</td><td><input class="form-control text-right tbeditar" disabled="disabled"  value=' + saldo + ' /></td>'
                        linea += '<td><input type="button" value="Quitar" class="btn btn-danger btquita"/></td></tr>';
                        $('#tblistac tbody').append(linea);
                        $('#tblistac').delegate("tr .btquita", "click", function ()
                        {
                            $(this).parent().eq(0).parent().eq(0).remove();
                            total();
                        });

                        $('#tblistac tbody tr').on('input', '.tbeditar', function () {
                            var valor = $(this).val();
                            valor = valor.replace(/[^0-9.]/g, "");
                            var partes = valor.split(".");
                            if (partes.length > 2) {
                                valor = partes[0] + "." + partes[1];
                            }
                            $(this).val(valor);
                        });



                    });

                    $('#tblistac tbody tr').change('.tbeditar', function () {
                        var totren = parseFloat($(this).closest('tr').find("input:eq(0)").val()) * parseFloat($(this).closest('tr').find("input:eq(1)").val());
                        $(this).closest('tr').find("input:eq(2)").val(totren.toFixed(2));
                        total();
                    });
                    total()
                    limpiaconcepto();
                }
            })

            $('#dliva').change(function () {
                total();
            })
            $('#btfacturas').click(function () {
                if ($('#dlcliente').val() != 0) {
                    cargafacturas();
                } else {
                    alert('Debe elegir un Cliente para aplicar facturas');
                }
            });

            $('#dlpago').change(function () {
                switch ($('#dlpago').val()) {
                    case '0':
                        alert('Debe elegir un tipo de gasto')
                    case '1':
                        $('#dvconcepto').show();
                        $('#dvfactura').hide();
                        /*$('#btfacturas').hide();*/
                        $('#btfacturas').show();
                        break;
                    case '2':
                        $('#dvconcepto').hide();
                        $('#dvfactura').show();
                        $('#btfacturas').show();
                        break;
                }
            })

            $('#dlconcepto').change(function () {
                var cadena = $('#dlconcepto option:selected').text()
                var partes = cadena.split("-");
                var serie = partes[0];
                var folio = partes[1];
                //var saldo = cargasaldo(uuid).toString()
                PageMethods.cargasaldo(serie, folio, function (res)
                {
                    var ren = res;
                    var saldo = ren;
                    //alert(saldo)
                    $('#tximporte').val(saldo)
                    $('#tximporver').val(saldo)
                })
            })


            $('#btnuevo').click(function () {
                limpia();
            })

            $('#btguarda').click(function () {
                if (valida())
                {
                    waitingDialog({});
                    var xmlgraba = ''
                    $('#tblistac tbody tr').each(function () {
                        xmlgraba = ''
                        xmlgraba += '<pagos> <pago id="' + $(this).closest('tr').find('td').eq(0).text() + '" iddocumentoapagar="' + $(this).closest('tr').find('td').eq(1).text() + '" total="' + parseFloat($(this).closest('tr').find("input:eq(0)").val()) + '"/>'
                        xmlgraba += '</pagos>';
                        //alert(xmlgraba);
                        PageMethods.guarda(xmlgraba, function (res) {
                        }, iferror);
                    });
                }
                closeWaitingDialog();
                alert('Registro completado');
                limpia()
            })

        })//Fin de function ()

        function cargasaldo(iddocumento) {
            PageMethods.cargasaldo(iddocumento, function (res) {
                var ren = res;
                return ren;
            }, iferror)
        }

        function limpia() {

        }

        function valida() {
            if ($('#dlcliente').val() == 0) {
                alert('Debe elegir el cliente');
                return false;
            }
            if ($('#txdesc').val() == 0) {
                alert('Debe colocar un concepto para el pago');
                return false;
            }
            if ($('#dltipo').val() != 5 && $('#tblistac tbody tr').length == 0) {
                alert('Debe agregar al menos un concepto de pago');
                return false;
            }

            return true;
        }

        function limpiaconcepto() {
            //$('#dlconcepto').val(0);
            $('#tximporver').val(0);
        }
        function total() {
            var subtotal = 0;
            var iva = 0;
            var total = 0;
            $('#tblistac tbody tr').each(function () {
                subtotal += parseFloat($(this).closest('tr').find("input:eq(0)").val());
            });
            iva = subtotal * parseFloat($('#dliva').val())
            total = subtotal + iva
            $('#txsubtotalg').val(subtotal.toFixed(2));
            $('#txivag').val(iva.toFixed(2));
            $('#txtotalg').val(total.toFixed(2));
        }
        //function total1()
        //{
        //    var subtotal = 0;
        //    var iva = 0;
        //    var total = 0;
        //    $('#tblistaf tr input[type=checkbox]:checked').each(function () {
        //        subtotal += parseFloat($(this).closest('tr').find("input:eq(0)").val());
        //    });
        //    subtotal = subtotal / (1 + parseFloat($('#dliva').val()));
        //    iva = subtotal * parseFloat($('#dliva').val());
        //    total = subtotal + iva;
        //    $('#txsubtotalg').val(subtotal.toFixed(2));
        //    $('#txivag').val(iva.toFixed(2));
        //    $('#txtotalg').val(total.toFixed(2));
        //}

        function validaconcepto() {
            for (var x = 0; x <= $('#tblistac tbody tr').length; x++)
            {
                //alert('x: ' + x + ' lista: ' + $('#tblistac tbody tr').eq(x).find('td').eq(0).text() + 'concepto= ' + $('#dlconcepto').val())


                //if ($('#tblistac tbody tr').eq(x-1).find('td').eq(0).text() == $('#dlconcepto').val()) {
                //    alert('Este concepto ya esta registrado, no se puede duplicar');
                //    return false;
                //}

                if ($('#tblistac tbody tr').eq(x).find('td').eq(0).text() == $('#dlconcepto').val())
                {
                    alert('Este concepto ya esta registrado, no puede duplicar');
                    return false;
                }
            }
            if ($('#dlconcepto').val() == 0) {
                alert('Debe elegir el concepto');
                return false;
            }
            if ($('#tximporte').val() == '') {
                alert('Debe colocar el importe');
                return false;
            }
            if ($('#tximporte').val() == '0') {
                alert('Debe colocar un importe mayor de cero');
                return false;
            }
            if (isNaN($('#tximporte').val())) {
                alert('Debe colocar un importe válido');
                return false;
            }
            if ($('#tximporte').val() > $('#tximporver').val()) {
                alert('El importe que ingreso no debe ser mayor que el importe mostrado');
                return false;
            }

            return true;
        }

        function cargafacturas() {
            PageMethods.facturas($('#dlcliente').val(), function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaf tbody').remove();
                $('#tblistaf').append(ren1);
                $('#tblistaf').delegate('tr .tbeditar', "change", function () {
                    total1();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total1();
                });
            }, iferror)
        }

        function cargadeffacturas(sol) {
            PageMethods.detfacturas(sol, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistaf tbody').remove();
                $('#tblistaf').append(ren1);
                $('#tblistaf').delegate('tr.tbeditar', "change", function () {
                    total1();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total1();
                });
            }, iferror)
        }

        function cargadetconcepto(sol) {
            PageMethods.detconcepto(sol, function (res) {
                var ren1 = $.parseHTML(res);
                $('#tblistac tbody').remove();
                $('#tblistac').append(ren1);
                $('#tblistac').delegate('tr .tbeditar', "change", function () {
                    total();
                });
                $('#tblistaf').delegate("tr .tbaplica", "click", function () {
                    total();
                });
            }, iferror)

        }

        function cargaconcepto() {
            PageMethods.concepto($('#dlcliente').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlconcepto').empty();
                $('#dlconcepto').append(inicial);
                $('#dlconcepto').append(lista);
                if ($('#idconcepto').val() != 0) {
                    $('#dlconcepto').val($('#idconcepto').val());
                }
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
                $('#dlcliente').val(0);
                if ($('#idcliente').val() != 0) {
                    $('#dlcliente').val($('#idcliente').val())
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
        }
    </script>
</head>
<body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idsol" runat="server" Value="0"  />
        <asp:HiddenField ID="idcliente" runat="server" Value="0" />
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
                    <h1>Aplicación de pagos sin complemento<small>Finanzas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Finanzas</a></li>
                        <li class="active">Solicitud</li>
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
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-3">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-info" value="Cargar facturas" id="btfacturas" style="display: none;"" />
                                </div>
                            </div>
                            
                            <%--<div class="row">
                                <div class="col-lg-1 text-right">
                                    <label for="txdesc">Concepto</label>
                                </div>
                                <div class="col-lg-7">
                                    <textarea class=" form-control" id="txdesc"></textarea>
                                </div>
                            </div>--%>
                        </div>

                    </div>


                    <div class="row">
                        <div class="col-lg-2">
                            <select id="dlconcepto" class="form-control"></select>
                        </div>
                        <div class="col-lg-1">
                            <input type="text" class=" form-control text-right" id="tximporver" disabled="disabled"/>
                        </div>
                        <div class="col-lg-1">
                            <input type="text" class=" form-control text-right" id="tximporte" />
                        </div>
                        <div class="col-lg-1">
                            <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                        </div>
                    </div>


                    <div class="row tbheader" style="height: 300px; overflow-y: scroll;" id="dvconcepto">
                        <table class=" table table-condensed " id="tblistac">
                            <thead>
                                <%--<tr>
                                    <td class="col-lg-1"></td>
                                    <td class="auto-style1">
                                        <select id="dlconcepto" class="form-control"></select>
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="text" class=" form-control text-right" id="tximporver" disabled="disabled"/>
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="text" class=" form-control text-right" id="tximporte" />
                                    </td>
                                    <td class="col-lg-1">
                                        <input type="button" class="btn btn-success" value="Agregar" id="btagrega" />
                                    </td>
                                </tr>--%>
                                <tr>
                                    <th class="bg-light-blue-active">Id</th>
                                   <%-- <th class="auto-style2">UUID</th>--%>
                                    <th class="bg-light-blue-active">UUID</th>
                                    <th class="bg-light-blue-active">Folio</th>
                                    <th class="bg-light-blue-active">Importe</th>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active"></th>
                                    <th class="bg-light-blue-active"></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    
<%--                <hr/>
                    <div id="totales">
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txsubtotalg">Subtotal:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" class=" form-control text-right" disabled="disabled" id="txsubtotalg" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txivag">IVA:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" class=" form-control text-right" disabled="disabled" id="txivag" />
                            </div>
                            <div class="col-lg-2">
                                <select id="dliva" class="form-control">
                                    <option value="0">0 %</option>
                                    <option value="0.08">8 %</option>
                                    <option value="0.16" selected="selected">16 %</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-8 text-right">
                                <label for="txtotalg">Total:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" class=" form-control text-right" disabled="disabled" id="txtotalg" />
                            </div>
                        </div>
                    </div>--%>
                    <ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <!--<li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir</a></li>-->
                    </ol>
                </div>
                <div id="divmodal1">
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="dlbusca">Busca por:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlbusca" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="id_empleado">No. emp.</option>
                                <option value="rfc">RFC</option>
                                <option value="curp">CURP</option>
                                <option value="paterno+' '+RTRIM(materno)+ ' '+a.nombre">Nombre</option>
                            </select>
                        </div>
                        <div class="col-lg-5">
                            <input type="text" id="txbusca" class="form-control" />
                        </div>
                        <div class="col-lg-1">
                            <button type="button" id="btbuscaemp" value="Buscar" class="btn btn-info pull-right">Buscar</button>
                        </div>
                    </div>
                    <div class="row tbheader">
                        <table class="table table-condensed h6" id="tbllista1">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>Id</span></th>
                                    <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                    <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div id="divmodal2">
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="dlbusca">Busca por:</label>
                        </div>
                        <div class="col-lg-3">
                            <select id="dlbuscaj" class="form-control">
                                <option value="0">Seleccione...</option>
                                <option value="id_jornalero">No. jornal</option>
                                <option value="paterno+' '+ materno + ' '+a.nombre">Nombre</option>
                            </select>
                        </div>
                        <div class="col-lg-5">
                            <input type="text" id="txbuscaj" class="form-control" />
                        </div>
                        <div class="col-lg-1">
                            <button type="button" id="btbuscajor" value="Buscar" class="btn btn-info pull-right">Buscar</button>
                        </div>
                    </div>
                    <div class="row tbheader">
                        <table class="table table-condensed h6" id="tbllistaj">
                            <thead>
                                <tr>
                                    <th class="bg-light-blue-gradient"><span>Id</span></th>
                                    <th class="bg-light-blue-gradient"><span>Nombre</span></th>
                                    <th class="bg-light-blue-gradient"><span>Pagadora</span></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
