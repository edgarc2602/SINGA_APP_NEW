<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Iguala.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Iguala" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CATALOGO DE IGUALAS</title>
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
           // $('#var1').html('<%=listamenu%>');
           // $('#nomusr').text('<%=minombre%>');
            if ($('#idcte').val() != 0) {
                $('#txctenom').text($('#nombre').val());
                cargalineas($('#idcte').val());
            }
            $('#btguarda').on('click', function () {
                var xmlgraba = '';
                for (var x = 0; x < $('#tblista tbody tr').length; x++) {
                    xmlgraba += '<partida cliente="' + $('#idcte').val() + '" idinmueble="' + $('#tblista tbody tr').eq(x).find('td').eq(0).text() + '" idlinea="' + $('#dllinea').val() + '"  importe="' + parseFloat($('#tblista tbody tr').eq(x).find("input:eq(0)").val()) + '"/>';
                };
                //xmlgraba += '</Movimiento>';
                //alert(xmlgraba);
                PageMethods.guarda(xmlgraba, function (res) {
                    alert('Iguala actualizada correctamente');
                }, iferror);
                //window.history.back();
            })
        });
        function asignapagina(np) {
            $('#paginacion li').removeClass("active");
            $('#hdpagina').val(np);
            cargalista();
            $('#paginacion li').eq(np - 1).addClass("active");
        };

        function cuentaiguala() {
            PageMethods.contariguala($('#idcte').val(), function (cont) {
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
            PageMethods.igualas($('#idcte').val(), $('#dllinea').val(), $('#hdpagina').val(), function (res) {
                //alert(res);
                var ren = $.parseHTML(res);
                if (ren != null) {
                    $('#tblista tbody').remove();
                    $('#tblista').append(ren);
                }
            });
        }

        function cargalineas(idcte) {
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
                $('#dllinea').change(function () {
                    if ($('#dllinea').val() != 0) {
                        cuentaiguala();
                        cargalista();
                    } else { $('#tblista tbody').remove();}
                })
            }, iferror);
        }
        function iferror(err) {
            alert('ERROR ' + err._message);
        };
    </script>
</head>
<body >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <asp:HiddenField ID="idcte" runat="server" />
        <asp:HiddenField ID="nombre" runat="server" />
        <asp:HiddenField ID="hdpagina" runat="server" />
        <div class="content">
            <div class="content-header">
                <h1>Igualas: <span id="txctenom"></span></h1>
            </div>
            <div class="box box-info">
                <div class=" box-header">
                    <!--<h3 class="box-title">Lista de Puntos de atención</h3>-->
                </div>
                <div class="row">
                    <div class="col-lg-2 text-right">
                        <label for="dltipo">Línea de negocio:</label>
                    </div>
                    <div class="col-lg-2">
                        <select id="dllinea" class="form-control"></select>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-8 tbheader">
                    <table class="table table-condensed" id="tblista">
                        <thead>
                            <tr>
                                <th class="bg-navy">Id</th>
                                <th class="bg-navy"><span>punto de atención</span></th>
                                <th class="bg-navy"><span>Importe</span></th>
                            </tr>
                        </thead>
                    </table>
                    <ol class="breadcrumb">
                        <li id="btguarda" class="puntero"><a><i class="fa fa-edit"></i>Guardar</a></li>
                        <li id="btsalir" class="puntero" onclick="self.close();"><a><i class="fa fa-edit"></i>Salir</a></li>
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
        </div>
    </form>
</body>
</html>
