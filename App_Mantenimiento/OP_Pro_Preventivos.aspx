<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OP_Pro_Preventivos.aspx.vb" Inherits="App_Mantenimiento_OP_Pro_Preventivos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Preventivos</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/App.Mantenimiento.css" rel="stylesheet" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>

    <style>
    /* Estilos para el menú contextual */
    #contextMenu {
      display: none;
      position: absolute;
      background-color: #f9f9f9;
      min-width: 120px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
      z-index: 9999;
    }
    #contextMenu a {
      color: black;
      padding: 8px 12px;
      text-decoration: none;
      display: block;
    }
    #contextMenu a:hover {
      background-color: #f1f1f1;
    }
    .deshabilita {
            pointer-events: none;
            opacity: 0.4; /* Cambia la opacidad para dar una apariencia de deshabilitado */
        }
    .IconoGris{color: #888;}
    .IconoAzul{color:Highlight;}
    .IconoVerde{color:green;}
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
        var dialog, dialog1, dialog2;
        var inicial = '<option value=0>Seleccione...</option>';
        var vbusca, vdeta, objots = [];
        var idOt = 0; //variable que guarda el id de la OT, para las opciones del menu

        $(function () {
            $('#hdpagpro').val(1);
            $('#dvgeneral').hide();
            $('#dvdetalle').hide();
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

            $('#dlcliente').append(inicial);
            $('#dltipo').append(inicial);
            $('#dltecnico').append(inicial);
            cargacliente();
            cargaservicios();
            muestrapreventivos();
            cuentapreventivos();
            cargatecnico();
            llenarSelect();
                        
            $('#txbuscaTec').keypress(function (event) { if (event.which === 13) cargatecnicoDialog(); });
            $('#btbuscaTec').click(function () { cargatecnicoDialog(); });


            $('#btguarda').click(function () {
                if ($('#hdprograma').val() == '0') {

                    alert("Debes generar el Programa");
                }
                if ($('#hdprograma').val() != '0') {
                    graba();
                }
            });
            $('#btgenera').click(function () {
                if ($('#hdprograma').val() == '0') {
                    svprograma();
                }
            });
            $('#idreg').click(function () {
                if (objots.length > 0) {
                    var resp = confirm('Tienes ' + objots.length + ' OTs sin guardar, deseas guardarlas?');
                    if (resp) {
                        PageMethods.gnFecha($('#hdfec').val(), -1, function (res) {
                            var nw = String(res).split('|');
                            //alert(nw[0], nw[1]);
                            $('#hdfec').val(nw[0]);
                            $('#lbfec').text(nw[1]);
                            $('#hdini').val(nw[2]);
                            $('#hdfin').val(nw[3]);
                            bots();
                        }, iferror);
                        graba();
                    } else {
                        objots = [];
                        PageMethods.gnFecha($('#hdfec').val(), -1, function (res) {
                            var nw = String(res).split('|');
                            alert(nw[0], nw[1]);
                            $('#hdfec').val(nw[0]);
                            $('#lbfec').text(nw[1]);
                            $('#hdini').val(nw[2]);
                            $('#hdfin').val(nw[3]);
                            bots();
                        }, iferror);
                    }
                }
                PageMethods.gnFecha($('#hdfec').val(), -1, function (res) {
                    var nw = String(res).split('|');
                    //alert(nw[0], nw[1]);
                    $('#hdfec').val(nw[0]);
                    $('#lbfec').text(nw[1]);
                    $('#hdini').val(nw[2]);
                    $('#hdfin').val(nw[3]);
                    bots();
                }, iferror);
                //alert($('#<%=hdfec.ClientID%>').val());

            });
            $('#idava').click(function () {
                if (objots.length > 0) {
                    var resp = confirm('Tienes ' + objots.length + ' OTs sin guardar, deseas guardarlas?');
                    if (resp) {
                        PageMethods.gnFecha($('#hdfec').val(), 1, function (res) {
                            var nw = String(res).split('|');
                            //alert(nw[0], nw[1]);
                            $('#hdfec').val(nw[0]);
                            $('#lbfec').text(nw[1]);
                            $('#hdini').val(nw[2]);
                            $('#hdfin').val(nw[3]);
                            bots();
                        }, iferror);
                        graba();
                    } else {
                        objots = [];
                        PageMethods.gnFecha($('#hdfec').val(), 1, function (res) {
                            var nw = String(res).split('|');
                            //alert(nw[0], nw[1]);
                            $('#hdfec').val(nw[0]);
                            $('#lbfec').text(nw[1]);
                            $('#hdini').val(nw[2]);
                            $('#hdfin').val(nw[3]);
                            bots();
                        }, iferror);
                    }
                }
                PageMethods.gnFecha($('#hdfec').val(), 1, function (res) {
                    var nw = String(res).split('|');
                    //alert(nw[0], nw[1]);
                    $('#hdfec').val(nw[0]);
                    $('#lbfec').text(nw[1]);
                    $('#hdini').val(nw[2]);
                    $('#hdfin').val(nw[3]);
                    bots();
                }, iferror);
                //alert($('#<%=hdfec.ClientID%>').val());

            });
            $('#btbusca').click(function () {
                //alert("busca");
                cuentapreventivos();
                asignapagina(1)
            });
            $('#btnuevo').click(function () {
                limnuevo();
                cambio(1);
                desbloquea();
                $('#dvgeneral').show();
                $('#dvconsulta').hide();
            });
            $('#btnuevo1').click(function () {
                limnuevo();
                cambio(1);
                desbloquea();
                $('#dvgeneral').show();
                $('#dvconsulta').hide();
            });
            $('#btlista').click(function () {
                cuentapreventivos();
                asignapagina(1)
                $('#dvgeneral').hide();
                $('#dvconsulta').show();
            });
            $('#btimprime').click(function () {
                var farr = $('#hdini').val().split('-');
                var falta = farr[0] + ',' + farr[1] + ',' + farr[2];
                var ini = falta;
                var farr = $('#hdfin').val().split('-');
                var falta = farr[0] + ',' + farr[1] + ',' + farr[2];
                var fin = falta;
                //alert(ini);
                //alert(fin);
                var formula = '{tb_programaestructura.id_programa}  = ' + $('#hdprograma').val() + ' and {tb_ordentrabajo.id_status} in 1 to 3 and {tb_ordentrabajo.fregistro} in Date (' + ini + ') to Date (' + fin + ')  ';
                window.open('../RptForAll.aspx?v_nomRpt=preventivos.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
        });

        function cargatecnicoDialog() {
            PageMethods.Buscatecnico($('#txbuscaTec').val(), $('input[name="optTecnico"]:checked').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tbbuscaTec tbody').remove();
                $('#tbbuscaTec').append(ren);
                $('#tbbuscaTec tbody tr').click(function () {
                    PageMethods.asignatecnico($(this).find("td").first().text(), $("#hdordenseleccionada").val(), $('input[name="optTecnico"]:checked').val(), function (res) {
                        dialog.dialog('close');
                        if (res == 'Ok') alert("Se asigno al Técnico correctamente")
                        else console.log(res);
                    }, iferror);
                });
            }, iferror);
        }
                
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
                    cargaregion($('#dlcliente').val());
                })

            }, iferror);
        }
        function cargaservicios() {
            PageMethods.tipos(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                }
                $('#dltipo').append(lista);
                if ($('#hdtipo').val() != 0) {
                    $('#dltipo').val($('#hdtipo').val());
                }
            }, iferror);
        }
        function cargatecnico() {

            try {
                PageMethods.Tecnico2(function (opcion) {
                    var opt = eval('(' + opcion + ')');
                    var lista = '';
                    for (var list = 0; list < opt.length; list++) {
                        lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                    }
                    //alert(lista);
                    $('#dltecnico').empty();
                    $('#dltecnico').append(inicial);
                    $('#dltecnico').append(lista);
                }, iferror);
            }
            catch (error) {
                alert('Se produjo un error:', error.message);
            }

        }
        function cargasupervisor() {
            PageMethods.gtProyecto($('#dlcliente').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].nm + '</option>';
                }
                $('#dlsucursal').empty();
                $('#dlsucursal').append(inicial);
                $('#dlsucursal').append(lista);
            }, iferror);
        }
        function cargaregion(cte) {
            PageMethods.region(cte, function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlregion').empty();
                $('#dlregion').append(inicial);
                $('#dlregion').append(lista);
            }, iferror);
        }
        function svprograma() {
            if (valbusca()) {
                var prm = `<Param cliente="${$('#dlcliente').val()}" ser="${$('#dltipo').val()}"`;
                prm += ` id="${$('#hdprograma').val()}" user="${$('#idusuario').val()}"`;
                prm += ` sup="${$('#dltecnico').val()}" estr="${$('#dlestructura').val()}" />`;
                //alert(prm);
                PageMethods.svPrograma(prm, function (res) {
                    $('#txid').val(res)
                    alert('Programa ' + res + ' generado.');
                    $('#hdprograma').val(res)
                    bloquea();
                    muestra();
                    //bots();
                    /*alert(nw.prg);
                    if (nw.prg == 0) {
                        alert('El programa que deseas generar ya existe');
                    }
                    else {
                        $('#hdprograma').val(nw.prg);
                        $('#lbfec').text($('#fecha').val());
                    }*/
                }, iferror);
            }
        }
        //Validaciones
        function valbusca() {
            if ($('#dltipo').val() == '0') {
                alert('Debe seleccionar el tipo de orden.');
                return false;
            }
            if ($('#dlcliente').val() == '0') {
                alert('Debe seleccionar un cliente.');
                return false;
            }
            if ($('#dltecnico').val() == '0') {
                alert('Debe seleccionar un  coordinador.');
                return false;
            }
            if ($('#dlestructura').val() == "") {
                alert('Debe seleccionar un tipo de estructura');
                return false;
            }
            PageMethods.buscaprograma($('#dlcliente').val(), $('#dltipo').val(), $('#dltecnico').val(), $('#dlregion').val(), function (res) {
                if (res != 0) {
                    alert('El preventivo que intenta generar ya existe, no se puede duplicar');
                    return false;
                }
            })
            return true;
        }
        function bloquea() {
            $('#dlcliente').prop("disabled", true);
            $('#dltipo').prop("disabled", true);
            $('#dltecnico').prop("disabled", true);
            $('#btgenera').prop("disabled", true);
            $('#dlestructura').prop("disabled", true);
        }
        function desbloquea() {
            $('#dlcliente').prop("disabled", false);
            $('#dltipo').prop("disabled", false);
            $('#dltecnico').prop("disabled", false);
            $('#btgenera').prop("disabled", false);
            $('#dlestructura').prop("disabled", false);
        }
        //bots
        function bots() {
            $('#othead tr').remove();
            $('#otbody tr').remove();
            $('#divpagot ul').remove();
            var prm = '<Param prg="' + $('#hdprograma').val() + '"  pro="' + $('#dlcliente').val() + '" ser="' + $('#dltipo').val() + '"';
            prm += ' pgn="' + $('#hdpagina').val() + '"  user="' + $('#idusuario').val() + '"';
            prm += ' per="0" fec="' + $('#hdfec').val() + '" sup="' + $('#dltecnico').val() + '" />';
            //alert(prm);
            PageMethods.gtEstructura(prm, function (res) {
                var nw = eval('(' + res + ')');
                if (nw.cmd) {
                    $('#hdproyectop').val(nw.pro);
                    $('#hdtipop').val(nw.ser);
                    //$('#hdsupervisorp').val(nw.ser);
                    $('#hdsupervisorp').val(nw.sup);
                    muestra();
                }
            }, iferror);
        }
        function pgpro(ind) {
            $('#hdpagpro').val(ind);
            prgs();
        }
        function prgs() {
            // alert($('#dvgeneral').is(':visible'));
            if ($('#dvgeneral').is(':visible')) {
                $('#tbprograma tr').remove();
                $('#divpagpro ul').remove();
                var prm = '<Param prg="0"  ser="' + $('#hdtipop').val() + '"';
                if ($('#txdim').val() == '') {
                    prm += ' pro="0"';
                } else {
                    prm += ' pro="' + $('#hdproyectop').val() + '"';
                }

                prm += ' per="20160101" pgn="' + $('#hdpagpro').val() + '" ';
                if ($('#txsupid').val() == '') {
                    prm += 'sup="0" />';
                } else {
                    prm += 'sup="' + $('#hdsupervisorp').val() + '" />';
                }
                //alert(prm);
                PageMethods.gtPrograma(prm, function (res) {
                    var nw = eval('(' + res + ')');
                    var algo = '<ul>';
                    for (var x = 0; x < nw.pgn.length; x++) {
                        algo += '<li onclick="pgpro(' + nw.pgn[x].pgn + ')">' + (nw.pgn[x].pgn + 1) + '</li>';
                    }
                    algo += '</ul>';
                    $('#divpagpro').append(algo);
                    $('#divpagpro li').eq(parseInt($('#hdpagpro').val())).addClass('selec');
                    algo = '';
                    for (var x = 0; x < nw.pro.length; x++) {
                        algo += '<tr onclick="mdetalle(this)"><td><input type="hidden" value="' + nw.pro[x].inm + '" /> ' + nw.pro[x].prg + '</td><td>' + nw.pro[x].pro + '</td><td>' + nw.pro[x].ser + '</td>';
                        algo += '<td>' + nw.pro[x].sup + '</td></tr>';
                    }
                    $('#tbprograma').append(algo);
                }, iferror);
            }
            else {
                alert("No paso");
            }
        }
        function limnuevo() {
            $('#dlcliente').empty();
            $('#dlcliente').append(inicial);
            $('#dltipo').empty();
            $('#dltipo').append(inicial);
            $('#dltecnico').empty();
            $('#dltecnico').append(inicial);
            $("#btgenera").show();
            $('#dlestructura').val('');
            $('#hdprograma').val(0);
            $('#hdproyectop').val(0);
            $('#hdserviciop').val(0);
            $('#hdtipop').val(0);
            $('#hdsupervisorp').val(0);
            $('#txproid').val('');
            $('#txproyectob').val('');
            $('#othead tr').remove();
            $('#otbody tr').remove();
            $("#btnmeslbl").hide();
            $("#btnmes").hide();
            $("#dvanyo").hide();
            $("#anyolbl").hide();
            cargacliente();
            cargaservicios();
            cargatecnico();
            llenarSelect();
        }
        function cambio(ind) {
            if (ind == 1) {
                if (objots.length > 0) {
                    var resp = confirm('Tienes ' + objots.length + ' OTs sin guardar, deseas guardarlas?');
                    if (resp) {
                        graba();
                    } else {
                        objots = [];
                    }
                }
                $('#dvgeneral').show();
                $('#hdprograma').val(0);
                $('#dvdetalle').hide();
            } else {
                $('#dvgeneral').hide();
                $('#dvdetalle').show();
                $('#hdproyectop').val(0);
                $('#hdserviciop').val(0);
                $('#hdsupervisorp').val(0);
                $('#hdperiodop').val(0);
            }
        }
        function buscalim() {
            $('#txbusca').val('');
            $('#tbbusca tr').remove();
            //alert('Remove');
        }
        function llenarSelect() {
            var select = document.getElementById("dlanyo");
            select.innerHTML = '';
            var anioActual = new Date().getFullYear();
            for (var i = 0; i < 2; i++) {
                var anio = anioActual + i;
                var option = document.createElement("option");
                option.value = anio;
                option.text = anio;
                if (i === 0) {
                    option.setAttribute("selected", "selected");
                }
                select.appendChild(option);
            }
        }
        document.addEventListener("DOMContentLoaded", function () {
            var select = document.getElementById("dlanyo");
            if (select) {
                select.addEventListener("change", function () {
                    if (objots.length > 0) {
                        var resp = confirm('Tienes ' + objots.length + ' OTs sin guardar, deseas guardarlas?');
                        if (resp) {
                            graba();
                        } else {
                            objots = [];
                            muestra();
                        }
                    }
                    else {
                        muestra();
                    }
                });
            }
        });

        function muestra() {
            $('#othead tr').remove();
            $('#otbody tr').remove();
            $('#divpagot ul').remove();
            var prm = '<Param prg="' + $('#hdprograma').val() + '" pro="' + $('#dlcliente').val() + '" ser="' + $('#dltipo').val() + '"';
            prm += ' pgn="' + $('#hdpagina').val() + '" user="' + $('#idusuario').val() + '" estr="' + $('#dlestructura').val() + '" anyo="' + $('#dlanyo').val() + '"';
            prm += ' per="0" fec="' + $('#hdfec').val() + '" sup="' + $('#dltecnico').val() + '" />';
            PageMethods.gtPreventivo(prm, function (res) {
                var nw = eval('(' + res + ')');
                if (nw.cmd) {
                    var algo = '';
                    $("#btgenera").hide();
                    if (nw.estr == false) {
                        $("#btnmeslbl").show();
                        $("#btnmes").show();
                        $("#dvanyo").hide();
                        $("#anyolbl").hide();
                        algo = '<tr>';
                        algo += '<th class="bg-light-blue-gradient" rowspan="2" style="min-width: 150px;"><span>Proyecto</span></th>';
                        algo += '<th class="bg-light-blue-gradient" rowspan="2"><span>Inmueble</span></th>';
                        for (var x = 0; x < nw.dias.length; x++) {
                            algo += '<th class="bg-light-blue-gradient"><span>' + nw.dias[x].dia + '</span></th>';
                        }
                        algo += '</tr>';
                        algo += '<tr>';
                        for (var x = 0; x < nw.dias.length; x++) {
                            algo += '<th class="bg-light-blue"><span>' + nw.dias[x].nmdia + '</span></th>';
                        }
                        algo += '</tr>';
                    }
                    else {
                        $("#btnmeslbl").hide();
                        $("#btnmes").hide();
                        $("#dvanyo").show();
                        $("#anyolbl").show();
                        algo = '<tr> ';
                        algo += '<th class="bg-light-blue-gradient sticky-col" rowspan="2"style="min-width: 150px;"><span>Proyecto</span></th>';
                        algo += '<th class="bg-light-blue-gradient sticky-col" rowspan="2" style=" min-width: 200px;" ><span>Inmueble</span></th>';
                        for (var x = 0; x < nw.dias.length; x++) {
                            algo += '<th class="bg-light-blue-gradient" style="text-align:center; min-width: 60px;" title=" Del ' + nw.dias[x].Fec.slice(0, 10) + ' al ' + nw.dias[x].FecFin.slice(0, 10) + '" ><span>' + nw.dias[x].Mes + '</span></th>';
                        }
                        algo += '</tr>';
                        algo += '<tr>';
                        //algo += '<th class="bg-light-blue sticky-col" colspan="2" style="text-align: right; min-width: 60px;"><span>Semana</span></th>';
                        for (var x = 0; x < nw.dias.length; x++) {
                            algo += '<th class="bg-light-blue" style="text-align:center; min-width: 60px;"><span>' + nw.dias[x].Ordo + '</span></th>';
                        }
                        algo += '</tr>';
                    }

                    $('#othead').append(algo);
                    algo = '';
                    for (var y = 0; y < nw.sucs.length; y++) {
                        if (nw.estr == false) {
                            algo += '<tr><td class="sticky-col td2" estr_Value="' + nw.estr + '" ><input type="hidden" value="' + nw.sucs[y].id + '" />' + nw.sucs[y].pro + '</td><td class="sticky-col td2">' + nw.sucs[y].inm + '</td>';
                        }
                        else {
                            algo += '<tr><td class="sticky-col td2" estr_Value="' + nw.estr + '" ><input type="hidden" value="' + nw.sucs[y].id + '" />' + nw.sucs[y].pro + '</td><td class="sticky-col td2" >' + nw.sucs[y].inm + '</td>';
                        }
                        if (nw.estr == false) {
                            for (var x = 0; x < nw.dias.length; x++) {
                                algo += '<td style="text-align:center" class="seleccion td"></td>';
                            }
                        }
                        else {
                            //For para el listado de semanas
                            for (var x = 0; x < nw.dias.length; x++) {
                                algo += '<td style="text-align:center" class="seleccion td" Ordo_Value="' + nw.dias[x].Ordo + '" fec_Value="' + nw.dias[x].Fec + '" ></td>';
                            }
                        }
                        algo += '</tr>';
                    }
                    $('#otbody').append(algo);
                    algo = '<ul>';
                    for (var x = 0; x < nw.pgn.length; x++) {
                        algo += '<li onclick="pgna(' + nw.pgn[x].pgn + ')" class="page-item"><a class="page-link">' + (nw.pgn[x].pgn + 1) + '</a></li>';
                    }
                    algo += '</ul>';
                    $('#divpagot').append(algo);
                    $('#divpagot li').eq(parseInt($('#hdpagina').val())).addClass('selec');
                    //se ponen las Ordenes de trabajo de preventivos en las celdas
                    for (var x = 0; x < nw.ots.length; x++) {

                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).html('<i class="fa fa-flag ' + (nw.ots[x].id_status == 1 ? 'IconoVerde' : nw.ots[x].id_status == 2 ? 'IconoAzul' : nw.ots[x].id_status == 3 ? 'IconoGris' : '') + '"></i>');

                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).attr('title', 'OT ' + nw.ots[x].numot);
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).attr('id_status', nw.ots[x].id_status);
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).attr('id', nw.ots[x].numot);
                        
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).removeClass('seleccion');//se quita la clase seleccion para poder anclar el menu
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).addClass('SubMenuComand');//se agrega la clase SubMenuComand para mostrar el menu
                        
                    }

                    $('.SubMenuComand').on('click', function (event) {
                        idOt = $(this).attr('id');
                        id_status = $(this).attr('id_status');

                        var celdaAncho = $(this).outerWidth();
                        var celdaAlto = $(this).outerHeight();

                        var x = event.pageX - celdaAncho;
                        var y = event.pageY - celdaAlto - 100;

                        if (id_status == 1) {
                            $('#contextMenu').css({ top: y, left: x }).show();
                        } else if (id_status == 2) {//estatus ejecutado; //Cancelar-->deshabilitado, solo se puede cancelar si esta en estatus de alta
                            $('#MnuCancelar').addClass('deshabilita');
                            $('#MnuCancelar').off('click');
                            $('#contextMenu').css({ top: y, left: x }).show();// Mostrar el menú contextual en la posición del clic
                        }
                        else if (id_status == 3) $('#MnuDetalle').click();//cerrado, por default se va al detalle

                    });

                    $('#MnuDetalle').on('click', function () {
                        window.open('OP_PR_OrdenTrabajo.aspx?folio=' + idOt, '_blank');
                        $('#contextMenu').hide();
                        idOt = 0;
                        $('.SubMenuComand').addClass('seleccion');
                    });

                    $('#MnuCancelar').on('click', function () {
                        var resp = confirm('Deseas cancelar la Orden de Trabajo ' + idOt + ' ');
                        if (resp) {
                            PageMethods.cancelaot(idOt, function (res) {
                                bots();
                            }, iferror);
                        }
                        $('#contextMenu').hide();
                        idOt = 0;
                        $('.SubMenuComand').addClass('seleccion');
                    });

                    $('#MnuAsignaTec').on('click', function () {
                        //alert('Desea asignar tecnico a la Orden de Trabajo : ' + idOt);

                        $("#hdordenseleccionada").val(idOt);

                        $("#divmodal").dialog('option', 'title', 'Buscar Técnico');
                        $('#tbbuscaTec tbody').remove();
                        $('#txbuscaTec').val('');
                        dialog.dialog('open');


                        $('#contextMenu').hide();
                        idOt = 0;
                        $('.SubMenuComand').addClass('seleccion');
                    });

                    $('.seleccion').hover(function () {
                        idOt = 0;

                        if ($('#contextMenu').is(':visible')) $('#contextMenu').hide();
                        //if (!$('#contextMenu').hasClass('seleccion')) $('.SubMenuComand').addClass('seleccion');
                        
                        $('.seleccion').removeClass('highlight-column');
                        var index = $(this).index(); 
                        $('td').filter(':nth-child(' + (index + 1) + ')').addClass('highlight-column');
                    });

                    $('#otbody td').click(function () {
                        try {
                            var inm = $(this).parent().children('td').eq(0).children('input').val();
                            var estr_Value = $(this).parent().children('td').attr('estr_Value');
                            var Ordo_Value = $(this).attr('Ordo_Value');
                            var fec_Value = $(this).attr('fec_Value');
                            var ind = $(this).index();
                            if (ind > 1) {
                                var dia = '';
                                if (nw.estr == false) {//cuando no es semana, se toma el th(encabezado osea el numero de dia)
                                    dia = $('#othead').children('tr').eq(0).children('th').eq(ind).text();// EJEMPLO: 1 ,2 ,3 ,4 ,5
                                }
                                else {//toma la fecha inicial, en realidad lo que importa es el num de semana
                                    dia = fec_Value.substr(0, 10);//EJEMPLO : 2024-05-17
                                }
                                var prm = { inmid: inm, fec: dia };
                                //alert(prm);
                                if (nw.estr == false) {//cuando no es semana, se le da formato al numero de dia para q se convierta en fecha
                                    if (dia < 10) { dia = '0' + dia; }
                                    dia = String($('#hdfec').val()).substr(0, 6) + dia;
                                }
                                //alert($(this).html());
                                if ($(this).html() != '') {
                                    for (var x = 0; x < objots.length; x++) {
                                        if (objots[x].inm == inm && objots[x].fec == dia) {
                                            objots.splice(x, 1);
                                            $(this).text('');
                                            break;
                                            //alert("Continua1");
                                        }
                                    }
                                }
                                else {
                                    if (nw.estr == false) objots.push({ inm: inm, fec: dia, estr: estr_Value });//inserta los parametros por mes-dia
                                    else objots.push({ inm: inm, fec: dia, estr: estr_Value, Ordo_Value: Ordo_Value, fec_Value: fec_Value.substr(0, 10) });//inserta los parametros por semana
                                    //console.log(objots);
                                    $(this).html('<i class="fa fa-flag"></i>');
                                    //alert("Continua2");
                                }
                            }
                        }
                        catch (error) {
                            // Bloque de código que se ejecuta si se produce un error
                            //console.error('Se produjo un error:', error.message);
                            alert('Se produjo un error:', error.message);
                        }
                    });
                    $('#dvdetalle').show();
                    PageMethods.gnFecha($('#hdfec').val(), 0, function (res) {
                        var nw = String(res).split('|');
                        //alert(nw[0], nw[1]);
                        $('#hdfec').val(nw[0]);
                        $('#lbfec').text(nw[1]);
                        $('#hdini').val(nw[2]);
                        $('#hdfin').val(nw[3]);
                    }, iferror);
                }
                else {
                    alert('No paso');
                }
            }, iferror);
        }
               
        function graba() {
            var prm = '<prm  nor="NOR" user="' + $('#idusuario').val() + '"';
            prm += ' idserv="' + $('#dltipo').val() + '"';
            prm += ' idsuper="' + $('#dltecnico').val() + '" programa="' + $('#hdprograma').val() + '" proyecto="' + $('#dlcliente').val() + '" estr="' + $('#dlestructura').val() + '" >';
            var aux = '';
            var aux2 = 0;
            for (var x = 0; x < objots.length; x++) {
                if (objots[x].estr === 'false') {
                    aux = objots[x].fec;
                    aux2 = 0;
                } else {
                    aux = objots[x].fec_Value;
                    aux2 = objots[x].Ordo_Value;
                }
                prm += '<ot inmueble="' + objots[x].inm + '" piso="0" equipo="0" estr="' + objots[x].estr + '"  fecha="' + aux + '" ordo="' + aux2 + '" />';
            }
            prm += '</prm>';
            //alert(prm);
            PageMethods.svOrdenes(prm, function (res) {
                var nw = eval('(' + res + ')');
                objots = [];
                if (nw.cmd) {
                    muestra();
                    alert('Preventivos Generados.');
                }
            }, iferror);
        }
        function muestrapreventivos() {
            PageMethods.muestrapreventivos($('#hdpagpro').val(), $('#dlbusca').val(), $('#txbusca').val(), function (res) {
                var ren = $.parseHTML(res);
                $('#tblista tbody').remove();
                $('#tblista').append(ren);
                $('#tblista  tbody tr').on('click', function () {
                    $('#dvgeneral').show();
                    $('#dvconsulta').hide();
                    PageMethods.consultapreventivo($(this).children().eq(0).text(), function (res) {
                        var nw = eval('(' + res + ')');
                        if (nw.cmd) {
                            $('#hdprograma').val(nw.per);
                            $('#hdproyectop').val(nw.pro);
                            $('#hdtipop').val(nw.ser);
                            $('#dltipo').val(nw.ser);
                            $('#dlcliente').val(nw.pro);
                            //cargatecnico();
                            //$('#hdsupervisorp').val(nw.ser);
                            $('#hdsupervisorp').val(nw.sup);
                            $('#dltecnico').val(nw.sup);
                            //alert($("#fecha").val());  
                            $('#dlestructura').val(nw.estr);
                            muestra();
                            prgs();
                            bloquea();
                        } else {
                            alert("no paso");
                        }
                    }, iferror);
                });
            }, iferror);
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagpro').val(np);
            muestrapreventivos();
            $('#paginacion li').eq(np - 1).addClass("active");
        };
        function cuentapreventivos() {
            PageMethods.contarpreventivos($('#dlbusca').val(), $('#txbusca').val(), function (cont) {
                $('#paginacion li').remove();
                var opt = eval('(' + cont + ')');
                var pag = '';
                for (var x = 1; x <= opt[0].pag; x++) {
                    pag += '<li onclick="asignapagina(' + x + ')" class="page-item"><a class="page-link">' + x + '</a></li>';
                }
                $('#paginacion').append(pag);

            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        }
        function getPar(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
        function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
            $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Porfavor espere...');
            $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Creando registros');
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
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" EnablePartialRendering="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idorden" runat="server" Value="0" />
        <asp:HiddenField ID="hdusuario" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idpiso" runat="server" Value="0" />
        <asp:HiddenField ID="idequipo" runat="server" Value="0" />
        <asp:HiddenField ID="hdtipo" runat="server" Value="0" />
        <asp:HiddenField ID="idtecnico" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagpro" runat="server" Value="0" />
        <asp:HiddenField ID="hdpagina" runat="server" Value="0" />
        <asp:HiddenField ID="hdfec" runat="server" />
        <asp:HiddenField ID="fecha" runat="server" />
        <asp:HiddenField ID="hdini" runat="server" />
        <asp:HiddenField ID="hdfin" runat="server" />

        <div class="wrapper">
            <div class="main-header">
                <!-- Logo -->
                <a href="../Home1.aspx" class="logo">
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
                    <h1>Preventivos<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimiento</a></li>
                        <li class="active">Preventivos</li>
                    </ol>
                </div>
                <div class="content">
                    <div id="dvconsulta" class="row">
                        <%--PI campos para buscar un programa--%>
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Buscar por:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlbusca">
                                        <option value="0">Seleccione...</option>
                                        <option value="b.nombre">Cliente</option>
                                        <option value="c.descripcion">Tipo de Orden</option>
                                    </select>
                                </div>
                                <div class="col-lg-3">
                                    <input type="text" id="txbusca" class="form-control" />
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-primary" value="Buscar" id="btbusca" />
                                </div>
                            </div>
                        </div>
                        <%--PI thead de programas--%>
                        <div class="col-md-18 tbheader">
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>No. Programa</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <th class="bg-light-blue-gradient"><span>Tipo Orden</span></th>
                                        <th class="bg-light-blue-gradient"><span>Coordinador</span></th>
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
                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        </ol>
                    </div>
                    <div class="row" id="dvgeneral">
                        <div class="box box-info">
                            <div class="box-header">
                            </div>
                              <div id="contextMenu">
                                  <a href="#" id="MnuDetalle">Ir al Detalle</a>
                                  <a href="#" id="MnuCancelar">Cancelar OT</a>
                                  <a href="#" id="MnuAsignaTec">Asignar técnico</a>
                                </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="hdprograma">No. Programa</label>
                                </div>
                                <div class="col-lg-2">
                                    <input id="hdprograma" class="form-control" value="0" disabled="disabled" />
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo de Orden:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <div class="col-lg-2 text-right">
                                    <label for="dltecnico">Coordinador:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltecnico" class="form-control"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="txfuente">Estructura:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlestructura">
                                        <option value="">Seleccione...</option>
                                        <option value="0">Día</option>
                                        <option value="1">Semana</option>
                                    </select>
                                </div>
                                <%--<div class="col-lg-2 text-right">
                                    <label for="dlregion">Región:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlregion" class="form-control"></select>
                                </div>--%>
                                <div class="col-lg-2 text-right">
                                    <label for="btgenera"></label>
                                </div>
                                <div class="col-lg-2">
                                    <span id="btgenera" class="btn btn-warning">Guardar</span>
                                </div>
                            </div>
                            <div class="row">
                                <input type="hidden" id="hdproyectop" value="0" />
                                <input type="hidden" id="hdserviciop" value="0" />
                                <input type="hidden" id="hdtipop" value="0" />
                                <input type="hidden" id="hdsupervisorp" value="0" />
                                <div class="col-lg-2 text-right" id="btnmeslbl">
                                    <label for="lbfec">Mes:</label>
                                </div>
                                <div class="col-lg-3 text-left" id="btnmes">
                                    <span id="idreg" class="fa fa-arrow-left btn btn-warning"></span>
                                    <label id="lbfec" text=""></label>
                                    <span id="idava" class="fa fa-arrow-right btn btn-warning"></span>
                                </div>
                                <div class="col-lg-2 text-right" id="anyolbl">
                                    <label for="dlanyo">Año:</label>
                                </div>
                                <div class="col-md-2" id="dvanyo">
                                    <select class="form-control" id="dlanyo"></select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div id="dvdetalle" class="col-md-12">

                                    <div class="tbheader" style="max-height: 400px; overflow-y: auto; width: 98%">
                                        <table id="ottable" class=" table-condensed table-sm">
                                            <thead id="othead" class="sticky-top">
                                            </thead>
                                            <tbody id="otbody">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <ol class="breadcrumb">
                                <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                                <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Preventivos</a></li>
                                <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir preventivo</a></li>
                            </ol>
                        </div>
                        <!--<ol class="breadcrumb">
                        <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                        <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                        <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                        <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Empleados</a></li>
                        <li id="btimprime" class="puntero"><a><i class="fa fa-print"></i>Imprimir catálogo</a></li>
                    </ol>-->
                    </div>
                </div>
            </div>
        </div>
        <!-- Menú contextual -->
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
                    <td><input type="text" class=" form-control" id="txbuscaTec" placeholder="Ingresa texto de busqueda" style="width:98%"/> </td>
                    <td><input type="button" class="btn btn-primary" value="Mostrar" id="btbuscaTec"/></td>
                       </tr></table>

                            <div class="tbheader">
                                <table class="table table-condensed" id="tbbuscaTec">
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

        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>
