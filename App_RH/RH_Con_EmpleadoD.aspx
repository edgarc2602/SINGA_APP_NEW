<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_Con_EmpleadoD.aspx.vb" Inherits="App_RH_RH_Con_EmpleadoD" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA DE DOCUMENTOS</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $('#txnoemp').val($('#idempleado').val());
            nombreempleado();
            cargalista();

        });
        function nombreempleado() {
            PageMethods.nombre($('#idempleado').val(), function (opcion) {
                var opt = eval('(' + opcion + ')');
                $('#txnombre').val(opt.empleado);
                
            }, iferror);
        }
        function cargalista() {
            //waitingDialog({});
            PageMethods.documentos($('#idempleado').val(), function (res) {
                //closeWaitingDialog();
                var ren = $.parseHTML(res);
                if (ren == null) {
                    $('#tblista table tbody').remove();
                    alert('No se han encontrado registros con los criterios seleccionado');
                }
                else {
                    $('#tblista table tbody').remove();
                    $('#tblista table').append(ren);
                    $('#tblista table tbody tr').on('click', '.tbeditar', function () {
                        var archivo = $(this).closest('tr').find('td').eq(2).text();
                        window.open('../Doctos/IMSS/' + archivo, '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
                    });
                }
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
        <asp:HiddenField ID="idempleado" runat="server" value="0"/>
        <div id="divinmueble" class="content">
            <div class="row" id="tblista">
                <div class="box box-info">
                    <div class=" box-header with-border">
                        <!--<h3 class="box-title">Lista de vacantes</h3>-->
                    </div>
                    <div class="row">
                        <div class="col-lg-2">
                            <label for="txnoemp">No. empleado:</label>
                        </div>
                        <div class="col-lg-1">
                            <input type="text" id="txnoemp" class="form-control" disabled="disabled" />
                        </div>
                        <div class="col-lg-1">
                            <label for="txnombre">Nombre:</label>
                        </div>
                        <div class="col-lg-3">
                            <input type="text" id="txnombre" class="form-control" disabled="disabled"/>
                        </div>
                    </div>
                </div>
                <div class="col-md-18 tbheader">
                    <table class="table table-condensed h6" id="tbdatos">
                        <thead>
                            <tr>
                                <th class="bg-light-blue-gradient"><span>Id</span></th>
                                <th class="bg-light-blue-gradient"><span>Documento</span></th>
                                <th class="bg-light-blue-gradient"><span>Archivo</span></th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
