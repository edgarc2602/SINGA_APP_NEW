<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Cat_Empleado_Direccion.aspx.vb" Inherits="App_RH_RH_Cat_Empleado_Direccion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title>CATALOGO DE EMPLEADOS-DOMICILIO</title>
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
            $('#txnombre').text($('#nombre').val());
            cargaestado();
            datosempleado() 
            $('#btactualiza').click(function () {
                var xmlgraba = '<direccion id= "' + $('#idemp').val() + '" calle= "' + $('#txcalle').val() + '" noext = "' + $('#txnoext').val() + '"  noint= "' + $('#txnoint').val() + '" colonia="' + $('#txcolonia').val() + '" cp= "' + $('#txcp').val() + '" municipio= "' + $('#txmunicipio').val() + '" ';
                xmlgraba += ' estado= "' + $('#dlestado').val() + '" tel1= "' + $('#txtel1').val() + '" tel2 = "' + $('#txtel2').val() + '" contacto= "' + $('#txcontacto').val() + '" />'
                PageMethods.guarda(xmlgraba, function (res) {
                    alert('Registro actualizado.');
                }, iferror);
            })
        });
        function datosempleado() {
            PageMethods.detalle($('#idemp').val(), function (detalle) {
                var datos = eval('(' + detalle + ')');
                $('#txcalle').val(datos.calle);
                $('#txnoint').val(datos.noint);
                $('#txnoext').val(datos.noext);
                $('#txcolonia').val(datos.colonia);
                $('#txcp').val(datos.cp);
                $('#txmunicipio').val(datos.municipio);
                $('#idestado').val(datos.estado);
                cargaestado();
                $('#txtel1').val(datos.tel1);
                $('#txtel2').val(datos.tel2);
                $('#txcontacto').val(datos.contacto);
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
                //alert(lista);
                $('#dlestado').append(lista);
                $('#dlestado').val(0);
                if ($('#idestado').val() != '') {
                    $('#dlestado').val($('#idestado').val());
                };
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
        <asp:HiddenField ID="idemp" runat="server"/>
        <asp:HiddenField ID="nombre" runat="server"/>
        <asp:HiddenField ID="idestado" runat="server"/>
        <div class="content-header">
            <h1>Catálogo de Empleados<small>Domicilio</small></h1>
            
        </div>
        <div class="content">
            <div class="row" id="dvdatos">
                <div class="col-md-12">
                    <div class="box box-info">
                        <div class="box-header">
                            <h3 id="txnombre"></h3>
                                <!--<h3 class="box-title">Datos de vacante</h3>-->
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txcalle">Calle:</label>
                            </div>
                            <div class="col-lg-3">
                                <input type="text" id="txcalle" class="form-control" />
                            </div>
                            <div class="col-lg-1 text-right">
                                <label for="txnoint">No. int:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txnoint" class="form-control" />
                            </div>
                            <div class="col-lg-1">
                                <label for="txnoext">No. ext:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txnoext" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txcolonia">Colonia:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txcolonia" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txcp">Código postal:</label>
                            </div>
                            <div class="col-lg-1">
                                <input type="text" id="txcp" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txmunicipio">Municipio:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txmunicipio" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="dlestado">Estado:</label>
                            </div>
                            <div class="col-lg-2">
                                <select id="dlestado" class="form-control"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-1 text-right">
                                <label for="txtel1">Telefono:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtel1" class="form-control" />
                            </div>
                            <div class="col-lg-2 text-right">
                                <label for="txtel2">Tel. Emergencia:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txtel2" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-2 text-right">
                                <label for="txcontacto">Contacto emergencia:</label>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" id="txcontacto" class="form-control" />
                            </div>
                        </div>
                        <ol class="breadcrumb">
                            <li id="btactualiza"  class="puntero"><a><i class="fa fa-edit" ></i>Actualizar</a></li>
                            <li id="btsalir"  onclick="self.close()" class="puntero"><a><i class="fa fa-edit" ></i>Salir</a></li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
