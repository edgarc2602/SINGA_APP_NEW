<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OP_Pro_VisitasSupervision.aspx.vb" Inherits="App_Mantenimiento_OP_Pro_VisitasSupervision" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Programa de Visitas de Supervisión</title>
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
        var dialog, dialog1, dialog2;
        var inicial = '<option value=0>Seleccione...</option>';
        var vbusca, vdeta, objots = [];
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

            $('#dlcliente').append(inicial);
            //$('#dltipo').append(inicial);
            $('#dltecnico').append(inicial);
            cargacliente();
            //cargaservicios();
            muestrapreventivos();
            cuentapreventivos();
            cargatecnico();

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
                //cargalista();
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
                var falta = farr[0] +','+ farr[1] +','+ farr[2];
                var ini = falta;
                var farr = $('#hdfin').val().split('-');
                var falta = farr[0] + ',' + farr[1] + ',' + farr[2];
                var fin = falta;
                //alert(ini);
                //alert(fin);
                var formula = '{tb_visitasupervision.id_visitasupervision}  = ' + $('#hdprograma').val() + ' and {tb_ordentrabajo.id_status} in 1 to 3 and {tb_ordentrabajo.fregistro} in Date (' + ini + ') to Date (' + fin + ')  ';
                window.open('../RptForAll.aspx?v_nomRpt=preventivos.rpt&v_formula=' + formula, '', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no');
            });
        });

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
                $('#dlcliente').change( function (){
                    cargaregion($('#dlcliente').val());
                })
                
            }, iferror);
        }
        //function cargaservicios() {
        //    PageMethods.tipos(function (opcion) {
        //        var opt = eval('(' + opcion + ')');
        //        var lista = '';
        //        for (var list = 0; list < opt.length; list++) {
        //            lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
        //        }
        //        $('#dltipo').append(lista);
        //        if ($('#hdtipo').val() != 0) {
        //            $('#dltipo').val($('#hdtipo').val());
        //        }
        //    }, iferror);
        //}
        function cargatecnico() {
            PageMethods.tecnico( function (opcion) {
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
                var prm = '<Param cliente="' + $('#dlcliente').val()  + '"';
                prm += ' id="' + $('#hdprograma').val() + '" user="' + $('#idusuario').val() + '"';
                //prm += ' id="' + $('#hdprograma').val() + '"';
                //prm += ' sup="' + $('#dltecnico').val() + '" region="' + $('#dlregion').val() + '" />';
                prm += ' sup="' + $('#dltecnico').val() + '" />';
                //alert(prm);
                PageMethods.svPrograma(prm, function (res) {                    
                    $('#txid').val(res)
                    if (res == 0)
                    {
                        alert('El programa no fué generado.');
                    }
                    else
                    {
                        alert('Programa ' + res + ' generado.');
                    }

                    bloquea();
                    bots();
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
            //if ($('#dltipo').val() == '0') {
            //    alert('Debe seleccionar el tipo de orden.');
            //    return false;
            //}
            if ($('#dlcliente').val() == '0') {
                alert('Debe seleccionar un cliente.');
                return false;
            }
            if ($('#dltecnico').val() == '0') {
                alert('Debe seleccionar un  coordinador.');
                return false;
            }
            //PageMethods.buscaprograma($('#dlcliente').val(), $('#dltipo').val(), $('#dltecnico').val(), $('#dlregion').val(), function (res) {
            PageMethods.buscaprograma($('#dlcliente').val(), $('#dltecnico').val(), function (res) {
                if (res != 0) {
                    alert('La visita que intenta generar ya existe, no se puede duplicar');
                    return false;
                }
            })
            return true;
        }
        function bloquea() {
            $('#dlcliente').prop("disabled", true);
            //$('#dltipo').prop("disabled", true);
            $('#dltecnico').prop("disabled", true);
            
            $('#btgenera').prop("disabled",true);
        }
        function desbloquea() {
            $('#dlcliente').prop("disabled", false);
            //$('#dltipo').prop("disabled", false);
            $('#dltecnico').prop("disabled", false);
            
            $('#btgenera').prop("disabled", false);
        }
        //bots
        function bots() {
            $('#othead tr').remove();
            $('#otbody tr').remove();            
            $('#divpagot ul').remove();
            //var prm = '<Param prg="' + $('#hdprograma').val() + '"  pro="' + $('#dlcliente').val() + '" ser="' + $('#dltipo').val() + '"';
            var prm = '<Param prg="' + $('#hdprograma').val() + '"  pro="' + $('#dlcliente').val() + '"';
            prm += ' pgn="' + $('#hdpagina').val() + '"  user="' + $('#idusuario').val() + '"';
            prm += ' per="0" fec="' + $('#hdfec').val() + '" sup="' + $('#dltecnico').val() + '" />';
            //alert(prm);
            PageMethods.gtEstructura(prm, function (res) {
                var nw = eval('(' + res + ')');
                if (nw.cmd) {
                    $('#hdproyectop').val(nw.pro);
                    //$('#hdtipop').val(nw.ser);
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
            //$('#dltipo').empty();
            //$('#dltipo').append(inicial);
            $('#dltecnico').empty();
            $('#dltecnico').append(inicial);
            $('#hdprograma').val(0);
            $('#hdproyectop').val(0);
            $('#hdserviciop').val(0);
            $('#hdtipop').val(0);
            $('#hdsupervisorp').val(0);
            $('#txproid').val('');
            $('#txproyectob').val('');
            $('#othead tr').remove();
            $('#otbody tr').remove();
            cargacliente();
            //cargaservicios();
            cargatecnico();

            //Habilitar el combo de tecnico
            var selectElement = document.getElementById('dltecnico');
            selectElement.disabled = false;

        }
        function cambio(ind) {
            if (ind == 1) {
                if (objots.length > 0) {
                    var resp = confirm('Tienes ' + objots.length + ' ordenenes de visitas sin guardar, deseas guardarlas?');
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

        function muestra() {
            $('#othead tr').remove();
            $('#otbody tr').remove();
            $('#divpagot ul').remove();
            //var prm = '<Param prg="' + $('#hdprograma').val() + '" pro="' + $('#dlcliente').val() + '" ser="' + $('#dltipo').val() + '"';
            var prm = '<Param prg="' + $('#hdprograma').val() + '" pro="' + $('#dlcliente').val() + '"';
            prm += ' pgn="' + $('#hdpagina').val() + '" user="' + $('#idusuario').val() + '"';
            prm += ' per="0" fec="' + $('#hdfec').val() + '" sup="' + $('#dltecnico').val() + '" />';
            PageMethods.gtPreventivo(prm, function (res) {
                var nw = eval('(' + res + ')');
                //$('#lbfec').text($('#fecha').val());
                //alert(nw.cmd);                
                if (nw.cmd) {                    
                    var algo = '<tr>';
                    algo += '<th class="bg-light-blue-gradient" rowspan="2"><span>Proyecto</span></th><th class="bg-light-blue-gradient" rowspan="2"><span>Inmueble</span></th>';
                    for (var x = 0; x < nw.dias.length; x++) {
                        algo += '<th class="bg-light-blue-gradient"><span>' + nw.dias[x].dia + '</span></th>';
                    }
                    algo += '</tr><tr>';
                    for (var x = 0; x < nw.dias.length; x++) {
                        algo += '<th class="bg-light-blue-gradient"><span>' + nw.dias[x].nmdia + '</span></th>';
                    }
                    algo += '</tr>';
                    $('#othead').append(algo);
                    algo = '';
                    for (var y = 0; y < nw.sucs.length; y++) {
                        algo += '<tr><td><input type="hidden" value="' + nw.sucs[y].id + '" />' + nw.sucs[y].pro + '</td><td>' + nw.sucs[y].inm + '</td>';
                        for (var x = 0; x < nw.dias.length; x++) {
                            algo += '<td></td>';
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
                    //se ponen las cantidades de preventivos en las celdas
                    for (var x = 0; x < nw.ots.length; x++) {
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).html('<i class="fa fa-flag" onclick="elimina(' + nw.ots[x].numot + ')" ></i>');
                        $('#otbody').children('tr').eq(nw.ots[x].ren - 1).children('td').eq(nw.ots[x].col + 1).attr('title', 'OT ' + nw.ots[x].numot);
                    }
                    $('#otbody td').click(function () {
                        var inm = $(this).parent().children('td').eq(0).children('input').val();
                        var ind = $(this).index();
                        if (ind > 1) {
                            var dia = $('#othead').children('tr').eq(0).children('th').eq(ind).text();
                            var prm = { inmid: inm, fec: dia };
                            //alert(prm);
                            if (dia < 10) {
                                dia = '0' + dia;
                            }
                            dia = String($('#hdfec').val()).substr(0, 6) + dia;                            
                            
                            if ($(this).html() != '') {
                                for (var x = 0; x < objots.length; x++) {
                                    if (objots[x].inm == inm && objots[x].fec == dia) {
                                        objots.splice(x, 1);
                                        $(this).text('');
                                        break;
                                        //alert("Continua1");
                                    }
                                }
                            } else {
                                objots.push({ inm: inm, fec: dia });
                                $(this).html('<i class="fa fa-flag"></i>');
                                //alert("Continua2");
                            }

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
        function elimina(id) {
            //alert(id);
            var resp = confirm('Deseas cancelar la Orden de Supervisión ' + id + ' ');
            if (resp) {
                //alert(resp);
                PageMethods.cancelaot(id, function (res) {    
                    bots();
                }, iferror);
            }             
        }
        function graba() {
            var prm = '<prm  nor="NOR" user="' + $('#idusuario').val() + '"';
            //prm += '  idserv="' + $('#dltipo').val() + '"';
            prm += ' idsuper="' + $('#dltecnico').val() + '" programa="' + $('#hdprograma').val() + '" proyecto="' + $('#dlcliente').val() + '" >';
            for (var x = 0; x < objots.length; x++) {
                prm += '<ot inmueble="' + objots[x].inm + '" piso="0" equipo="0" fecha="' + objots[x].fec + '" />';
            }
            prm += '</prm>';
            //alert(prm);
            PageMethods.svOrdenes(prm, function (res) {
                var nw = eval('(' + res + ')');
                objots = [];
                if (nw.cmd) {
                    //alert('entro a if (nw.cmd)');
                    muestra();
                    alert('Visitas Generadas.');                    
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
                            //$('#hdtipop').val(nw.ser);
                            //$('#dltipo').val(nw.ser);
                            $('#dlcliente').val(nw.pro);
                            cargatecnico();
                            //$('#hdsupervisorp').val(nw.ser);
                            $('#hdsupervisorp').val(nw.sup);                            
                            $('#dltecnico').val(nw.sup);
                            //alert($("#fecha").val());                           
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
                    <h1>Programa de Visitas de Supervisión<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimiento</a></li>
                        <li class="active">Preventivos</li>
                    </ol>
                </div>
                <div class="content">
                    <div id="dvconsulta" class="row">
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
                                        <%--<option value="c.descripcion">Tipo de Orden</option>--%>
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
                        <div class="col-md-18 tbheader">
                            <table class="table table-condensed" id="tblista">
                                <thead>
                                    <tr>
                                        <th class="bg-light-blue-gradient"><span>No. Programa</span></th>
                                        <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                        <%--<th class="bg-light-blue-gradient"><span>Tipo Orden</span></th>--%>
                                        <th class="bg-light-blue-gradient"><span>Coordinadors</span></th>
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
                        <div class="box box-info" style="left: 0px; top: 0px">
                            <div class="box-header">
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="hdprograma">No. Programa</label>
                                </div>
                                <div class="col-lg-1">
                                    <input id="hdprograma" class="form-control" value="0" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlcliente" class="form-control"></select>
                                </div>
                                <%--<div class="col-lg-2 text-right">
                                    <label for="dltipo">Tipo de Orden:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltipo" class="form-control"></select>
                                </div>--%>
                            </div>
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dltecnico">Coordinador:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dltecnico" class="form-control"></select>
                                </div>
                                <%--<div class="col-lg-2 text-right">
                                    <label for="dlregion">Región:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select id="dlregion" class="form-control"></select>
                                </div>--%>
                                <div class="col-lg-2">
                                    <span id="btgenera" class="btn btn-warning">Guardar</span>
                                </div>
                            </div>

                            <div class="row">
                                <div id="dvdetalle" class="col-md-10">
                                    <div class="row">

                                        <input type="hidden" id="hdproyectop" value="0" />
                                        <input type="hidden" id="hdserviciop" value="0" />
                                        <input type="hidden" id="hdtipop" value="0" />
                                        <input type="hidden" id="hdsupervisorp" value="0" />


                                        <div class="navbar-form navbar-center">
                                            <span id="idreg" class="fa fa-arrow-left btn btn-warning"></span>
                                            <label id="lbfec" text=""></label>
                                            <span id="idava" class="fa fa-arrow-right btn btn-warning"></span>
                                        </div>

                                    </div>
                                    <div class="col-md-18 tbheader">
                                        <table id="ottable" class="table table-condensed table-hover table-sm">
                                            <thead id="othead">
                                            </thead>
                                            <tbody id="otbody">
                                            </tbody>
                                        </table>
                                    </div>
                                    <%--<div id="divpagot" class="dvpaginas">
                                </div>--%>
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
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
        <div id="loadingScreen"></div>
    </form>
</body>
</html>

