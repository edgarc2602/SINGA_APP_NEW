<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_inmueble.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_inmueble" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE PUNTOS DE ATENCION</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1.0"/>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons" rel="stylesheet" />
    <style>
        #map {
            height: 300px;
            width:800px;
        }

       
    </style>

    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
            //$('#var1').html('<%=listamenu%>');
            //$('#nomusr').text('<%=minombre%>');
            $('#dvdatos').hide();
            
            cargatipo();
            cargaestado();
            cargaoficina();
            if ($('#idcte').val() != 0) {
                //alert($('#idcte').val());
                $('#txctenom').text($('#nombre').val());
                cuentainmueble($('#idcte').val());
                cargalista();
            }
            if ($('#idcte').val() == 130) {
                $('#dlprefijo').show();
                $('#lbprefijo').show();
            } else {
                $('#dlprefijo').hide();
                $('#lbprefijo').hide();
            }
            $('#btnuevo').on('click', function () {
                $('#tblistainm').hide();
                $('#dvdatos').show();
                limpia();
                $('#txnombre').focus();
            })
            $('#btnuevoinm').on('click', function () {
                $('#tblistainm').hide();
                $('#dvdatos').show();
                limpia();
                $('#txnombre').focus();
            })
            $('#btlista').on('click', function () {
                limpia();
                cargalista();
                $('#tblistainm').show();
                $('#dvdatos').hide();
            })
            $('#btguarda').on('click', function () {
                if (valida()) {
                    var pmat = 0;
                    if ($('#cbmateriales').is(':checked')) {
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
                    if ($('#cbplazo').is(':checked')) {
                        ppzo = 1;
                    }
                    var xmlgraba = '<inmueble id= "' + $('#txidinm').val() + '" idcte= "' + $('#idcte').val() + '" nombre ="' + $('#txnombre').val() + '" ceco = "' + $('#txnosuc').val() + '" oficina = "' + $('#dloficina').val() + '" ';
                    xmlgraba += 'tipo= "' + $('#dltipo').val() + '" calle= "' + $('#txcalle').val() + '" entrecalle = "' + $('#txecalles').val() + '" colonia = "' + $('#txcolonia').val() + '" '
                    xmlgraba += ' del = "' + $('#txdelmun').val() + '" cp = "' + $('#txcp').val() + '" ciudad = "' + $('#txciudad').val() + '" estado = "' + $('#dlestado').val() + '" tel1 = "' + $('#txtel1').val() + '" ';
                    xmlgraba += ' tel2 = "' + $('#txtel2').val() + '" contacto = "' + $('#txcontacto').val() + '" correo = "' + $('#txcorreo').val() + '" cargo = "' + $('#txcargo').val() + '" ptto1 = "' + $('#txpttolim').val() + '" ';
                    xmlgraba += ' ptto2 = "' + $('#txpttohig').val() + '" ptto3 = "' + $('#txpttoman').val() + '" prefijo = "' + $('#dlprefijo').val() + '"  ';
                    xmlgraba += ' lat = "' + $('#txlatitud').val() + '" lon = "' + $('#txlongitud').val() + '" banio = "' + $('#txbanio').val() + '"/>'
                    //alert(xmlgraba);
                    PageMethods.guarda(xmlgraba, function (res) {
                        $('#txidinm').val(res)
                        alert('Registro completado.');
                    }, iferror);
                }
            })
            $('#btelimina').on('click', function () {
                if ($('#txidinm').val() != '0') {
                    PageMethods.elimina($('#txidinm').val(), function (res) {
                        alert('El Punto de atención fue eliminado');
                        limpia();
                        cargalista();
                        $('#tblistainm').show();
                        $('#dvdatos').hide();
                    }, iferror);
                } else { alert('Antes de eliminar debe elegir un Punto de atención'); }
            })
        });
        
        function initMap(latitud, longitud, nombre) {            
            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 18,
                center: new google.maps.LatLng(latitud, longitud),
            });
            const image = {
                url: "https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png",
                // This marker is 20 pixels wide by 32 pixels high.
                size: new google.maps.Size(20, 32),
                // The origin for this image is (0, 0).
                origin: new google.maps.Point(0, 0),
                // The anchor for this image is the base of the flagpole at (0, 32).
                anchor: new google.maps.Point(0, 32),
            };
            const shape = {
                coords: [1, 1, 1, 20, 18, 20, 18, 1],
                type: "poly",
            };
            marker = new google.maps.Marker({
                position: new google.maps.LatLng(latitud, longitud),
                map,
                //icon: image,
                label: {
                    text: "\ue0af",
                    fontFamily: "Material Icons",
                    color: "#ffffff",
                    fontSize: "18px",
                },
                animation: google.maps.Animation.DROP,  
                shape: shape,
                title: nombre,
                zIndex: 0,                
            });
            marker.addListener("click", toggleBounce);
        }
        
        function toggleBounce() {
            if (marker.getAnimation() !== null) {
                marker.setAnimation(null);
            } else {
                marker.setAnimation(google.maps.Animation.BOUNCE);
            }
        }
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);            
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentainmueble(idcte) {
            PageMethods.contarinmueble(idcte, function (cont) {
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
            //alert($('#hdpagina').val());
            PageMethods.cargainmueble($('#idcte').val(), $('#hdpagina').val(), function (res) {
                //alert(res);
                var ren = $.parseHTML(res);
                if (ren != null) {
                    $('#tblistainm table tbody').remove();
                    $('#tblistainm table').append(ren);
                    $('#tblistainm table tbody tr').on('click', function () {
                        limpia();
                        $('#txidinm').val($(this).children().eq(0).text());
                        $('#txnombre').val($(this).children().eq(1).text());
                        $('#txnosuc').val($(this).children().eq(2).text());
                        $('#txcontacto').val($(this).children().eq(5).text());
                        $('#txtel1').val($(this).children().eq(6).text());
                        PageMethods.datosinmueble($(this).children().eq(0).text(), function (opcion) {
                            var opt = eval('(' + opcion + ')');
                            $('#txcalle').val(opt.calle);
                            $('#txecalles').val(opt.entrecalle);
                            $('#txcp').val(opt.cp);
                            $('#txcolonia').val(opt.colonia);
                            $('#txdelmun').val(opt.del);
                            $('#txciudad').val(opt.ciudad);
                            $('#dlestado').val(opt.estado);
                            $('#txtel2').val(opt.tel2);
                            $('#txcorreo').val(opt.correo);
                            $('#txcargo').val(opt.cargo);
                            $('#dltipo').val(opt.tipo);
                            $('#dloficina').val(opt.oficina);
                            $('#txpttolim').val(opt.ptto1);
                            $('#txpttohig').val(opt.ptto2);
                            $('#txpttoman').val(opt.ptto3);
                            $('#txcc').val(opt.cc);
                            $('#dlprefijo').val(opt.prefijo);
                            $('#txlatitud').val(opt.latitud);
                            $('#txlongitud').val(opt.longitud);
                            initMap($('#txlatitud').val(), $('#txlongitud').val(), $('#txnombre').val());
                        }, iferror);
                        $('#dvdatos').toggle('slide', { direction: 'down' }, 500);
                        $('#tblistainm').hide();
                    });
                };
            });
        }
        function limpia() {
            $('#txidinm').val(0);
            $('#txnombre').val('');
            $('#txnosuc').val('');
            $('#txcontacto').val('');
            $('#txtel1').val('');
            $('#txcalle').val('');
            $('#txecalles').val('');
            $('#txcp').val('');
            $('#txcolonia').val('');
            $('#txdelmun').val('');
            $('#txciudad').val('');
            $('#dlestado').val(0);
            $('#txtel2').val('');
            $('#txcorreo').val('');
            $('#txcargo').val('');
            $('#dltipo').val(0);
            $('#dloficina').val('');
            $('#txpttolim').val('');
            $('#txpttohig').val('');
            $('#txpttoman').val('');
            $('#txcc').val('');
        }
        function valida() {
            if ($('#txnombre').val() == '') {
                alert('Debe capturar el nombre del punto de atención');
                return false;
            }
            /*
            if ($('#txnosuc').val() == '') {
                alert('Debe capturar el Centro de costo');
                return false;
            }*/
            if ($('#dloficina').val() == 0) {
                alert('Debe seleccionar la oficina que atiende este punto de atención');
                return false;
            }
            if ($('#dltipo').val() == 0) {
                alert('Debe seleccionar tipo de punto de atención');
                return false;
            }
            if ($('#dlestado').val() == 0) {
                alert('Debe seleccionar al menos el Estado donde se ubica el punto de atención');
                return false;
            }
            if ($('#idcte').val() == 130 && $('#dlprefijo').val() == 0) {
                alert('Debe elegir un prefijo');
                return false;
            }
            return true;
        }
        function cargatipo() {
            PageMethods.tipo(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dltipo').append(inicial);
                $('#dltipo').append(lista);
                $('#dltipo').val(0);
                /*if ($('#idtipo').val() != '') {
                    $('#dltipo').val($('#idtipo').val());
                };*/
            }, iferror);
        }
        function cargaestado() {
            PageMethods.estado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado').append(inicial);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);
                /*if ($('#idestado').val() != '') {
                    $('#dlestado').val($('#idestado').val());
                };*/
            }, iferror);
        }
        function cargaoficina() {
            PageMethods.oficina($('#idcte').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dloficina').append(inicial);
                $('#dloficina').append(lista);
                $('#dloficina').val(0);
               /* if ($('#idoficina').val() != '') {
                    $('#dloficina').val($('#idoficina').val());
                };*/
            }, iferror);
        }
        
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
        
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idcte" runat="server" />
        <asp:HiddenField ID="nombre" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <div class="content">
            <div class="content-header">
                <h1>Puntos de atención: <span id="txctenom"></span></h1>
            </div>
            <div class="row" id="dvdatos">
                <div class="col-md-10">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class=" box-header">
                            <!-- <h3 class="box-title">Datos de Punto de atención</h3>-->
                        </div>
                        <!-- /.box-header -->
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txidinm">ID:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txidinm" class="form-control" disabled="disabled" value="0" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txcc">Contabilidad:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcc" class="form-control" disabled="disabled" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txnombre">Nombre:</label>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txnombre" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txnosuc">Centro Costo:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txnosuc" class="form-control" />
                            </div>
                            
                        </div>
                        <div class="row">
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="dloficina">Oficina:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dloficina" class="form-control"></select>
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="dltipo">Tipo Inmueble:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dltipo" class="form-control"></select>
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="dlprefijo" id="lbprefijo">Prefijo:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlprefijo" class="form-control">
                                    <option value="0">Seleccione...</option>
                                    <option value="EKT">EKT</option>
                                    <option value="DAZ">DAZ</option>
                                    <option value="PP">PP</option>
                                    <option value="OFI">OFI</option>
                                    <option value="MOT">MOT</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcalle">Calle y num:</label>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txcalle" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txecalles">Entre calles:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txecalles" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcolonia">Colonia:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcolonia" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txdelmun">Del/Mun:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txdelmun" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txcp">CP:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcp" class="form-control" maxlength="10" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txciudad">Ciudad:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txciudad" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="dlestado">Estado:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlestado" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txtel1">Telefono1:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtel1" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txtel2">Telefono2:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtel2" class="form-control" />
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
                                <label for="txcorreo">Correo:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcorreo" class="form-control" />
                            </div>
                             <div class="col-lg-1 text-right">
                                <label for="txcargo">Cargo:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcargo" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txbanio">Cantidad de baños:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txbanio" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txpttolim">Ptto Limp:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txpttolim" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txpttohig">Ptto Hig:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txpttohig" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txpttoman">Ptto Manto:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txpttoman" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txlatitud">Latitud:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txlatitud" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txlongitud">Longitud:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txlongitud" class="form-control" />
                            </div>
                        </div>
                        <br />
                        <div class="row right-side" id="map">
                        </div>
                        <br />
                        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCVCv-kzwcRcY1978_yM21WrdRxYtjBZ6M&&v=weekly" defer></script>

                        <ol class="breadcrumb">
                            <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                            <li id="btguarda" class="puntero"><a><i class="fa fa-save"></i>Guardar</a></li>
                            <li id="btelimina" class="puntero"><a><i class="fa fa-eraser"></i>Dar de Baja</a></li>
                            <li id="btlista" class="puntero"><a><i class="fa fa-navicon"></i>Ir a Lista de Puntos de atención</a></li>
                            <li id="btsalir" class="puntero" onclick="self.close();"><a><i class="fa fa-edit"></i>Salir</a></li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="row" id="tblistainm" >                
                <div class="col-md-18 tbheader" style="height:400px; overflow:scroll;">
                    <table class="table table-condensed" >
                        <thead>
                            <tr>
                                <th class="bg-navy"><span>Id</span></th>
                                <th class="bg-navy"><span>Nombre</span></th>
                                <th class="bg-navy"><span>Centro Costo</span></th>
                                <th class="bg-navy"><span>Tipo</span></th>
                                <th class="bg-navy"><span>Oficina</span></th>
                                <th class="bg-navy"><span>Contacto</span></th>
                                <th class="bg-navy"><span>Telefono</span></th>
                            </tr>
                        </thead>
                    </table>
                </div>
                <ol class="breadcrumb">
                    <li id="btnuevoinm" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                    <li id="btsalir1" class="puntero" onclick="self.close();"><a><i class="fa fa-edit"></i>Actualizar y salir</a></li>
                </ol>
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
    </form>
</body>
</html>
