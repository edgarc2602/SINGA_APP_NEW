<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Con_Cliente_ubicacion.aspx.vb" Inherits="Ventas_App_Ven_Con_Cliente_ubicacion" %>

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
            height: 700px;
            width:100%;
        }
    </style>

    <script type="text/javascript">
        var inicial = '<option value=0>Seleccione...</option>'
        $(function () {
            $('#var1').html('<%=listamenu%>');
            $('#nomusr').text('<%=minombre%>');
            cargacliente();
            cargaestado();
            setTimeout(function () {
                if (screen.width > 740) {
                    $("#menu").click();
                }
            }, 50);
            $('#btmuestra').click(function () {
                if ($('#dlcliente').val() != 0) {
                    cargainmueble();
                } else {
                    alert('Debe elegir un cliente, verifique')
                }
            })
            $('#btnuevo').click(function () {
                location.reload();
            })
        });
        function cargainmueble() {
            PageMethods.inmueble($('#dlcliente').val(), $('#dlestado1').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                initMap(opt);
                /*var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlcliente').append(inicial);
                $('#dlcliente').append(lista);
                */
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
                
            }, iferror);
        }
        function cargaestado() {
            PageMethods.estado(function (opcion) {
                var opt = eval('(' + opcion + ')');
                var lista = '';
                for (var list = 0; list < opt.length; list++) {
                    lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                };
                $('#dlestado1').append(inicial);
                $('#dlestado1').append(lista);
            }, iferror);
        }
        function initMap(matriz) {
            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 10,
                center: new google.maps.LatLng(19.465751245545604, -99.18682062589164),
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
            for (var list = 0; list < matriz.length; list++) {
                //lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                //alert(matriz[list].latitud);
                marker = new google.maps.Marker({
                    position: new google.maps.LatLng(matriz[list].latitud, matriz[list].longitud),
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
                    title: matriz[list].nombre,
                    zIndex: 0,
                   // marker.addListener("click", toggleBounce);
                });
                
            };
            /*
            for (let i = 0; i < beaches.length; i++) {
                const beach = beaches[i];

                new google.maps.Marker({
                    position: { lat: beach[1], lng: beach[2] },
                    map,
                    icon: image,
                    shape: shape,
                    title: beach[0],
                    zIndex: beach[3],
                });
            }

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
            marker.addListener("click", toggleBounce);*/
        }
        function toggleBounce() {
            if (marker.getAnimation() !== null) {
                marker.setAnimation(null);
            } else {
                marker.setAnimation(google.maps.Animation.BOUNCE);
            }
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
        <asp:HiddenField ID="idcte" runat="server" />
        <asp:HiddenField ID="nombre" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
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
                    <h1>Ubicaciones de Cliente<small>Ventas</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Ventas</a></li>
                        <li class="active">Ubicaciones</li>
                    </ol>
                </div>
                <div class="content">
                    <div class="row" id="dvdatos">
                        <div class="col-md-10">
                            <!-- Horizontal Form -->
                            <div class="box box-info">
                                <div class=" box-header">
                                    <!-- <h3 class="box-title">Datos de Punto de atención</h3>-->
                                </div>
                                <!-- /.box-header -->
                                <div class="col-lg-1">
                                    <label for="dlcliente">Cliente:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlcliente"></select>
                                </div>
                                <div class="col-lg-1">
                                    <label for="dlestado1">Estado:</label>
                                </div>
                                <div class="col-lg-2">
                                    <select class="form-control" id="dlestado1"></select>
                                </div>
                                <div class="col-lg-1">
                                    <input type="button" class="btn btn-success" value="Mostrar ubicaciones" id="btmuestra" />
                                </div>
                                <br />
                                <div id="map">
                                </div>
                                <br />
                                <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCVCv-kzwcRcY1978_yM21WrdRxYtjBZ6M&&v=weekly" defer></script>

                                <ol class="breadcrumb">
                                    <li id="btnuevo" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>                                   
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../Content/form/js/app.min.js" type="text/javascript"></script>
    </form>
</body>
</html>
