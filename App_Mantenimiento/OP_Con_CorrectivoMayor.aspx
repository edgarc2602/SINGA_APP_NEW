<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OP_Con_CorrectivoMayor.aspx.vb" Inherits="App_Mantenimiento_OP_Con_CorrectivoMayor" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>CONSULTA CORRECTIVO MAYOR</title>
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
             setTimeout(function () {
                 if (screen.width > 740) {
                     $("#menu").click();
                 }
             }, 50);
             $('#hdpagina').val(1); // ASIGNACION DEL INICIO DE PAGINA
             $('#var1').html('<%=listamenu%>');
             $('#nomusr').text('<%=minombre%>');
             $('#txfecini').datepicker({ dateFormat: 'dd/mm/yy' });
             $('#txfecfin').datepicker({ dateFormat: 'dd/mm/yy' });
             cargaestatus();    

             dialog1 = $('#divmodal1').dialog({
                 autoOpen: false,
                 height: 350,
                 width: 800,
                 modal: true,
                 close: function () {
                 }
             });
             dialog = $('#divmodal').dialog({
                 autoOpen: false,
                 height: 350,
                 width: 800,
                 modal: true,
                 close: function () {
                 }
             });
             $('#dvabre').hide();
             $('#dvcarga').hide();

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
             $('#btconsulta').click(function () {
                 if ($('#txfolio').val() == '') {
                     $('#txfolio').val(0);
                 }
                 $('#hdpagina').val(1);
                 cuentacm();
                 cargalista();
             })
             $('#btautoriza').click(function () {
                 if (validastatus()){
                     waitingDialog({});                    
                     PageMethods.cambiaestatus($('#txreq').val(), $('#dlestatus1').val(), $('#idusuario').val(), $('#txmotivo').val(), function (res) {
                         cuentacm();
                         cargalista();
                         dialog1.dialog('close');
                         closeWaitingDialog();
                     }, iferror);
                 }
             })
             $('#btdescarga').click(function () {
                 var archivo = $('#lbarchivo').val();
                 window.open('../Doctos/' + archivo, '_blank', 'width=850, height=600, left=80, top=120, resizable=no, scrollbars=no ');
             })
 
         });
         function validastatus() {
             if ($('#dlestatus1').val() == 6 && $('#txmotivo').val() == '') {
                 alert('Al rechazar una solicitud debe colocar un motivo para informar a la persona que elaboro la solicitud');
                 return false;
             }
             return true;
         }

         function valida() {
             if ($('#txarchivo').val() == '') {
                 alert('Debe seleccionar el archivo del acuse antes de continuar');
                 return false;
             }
             return true;
         }
         function waitingDialog(waiting) { // I choose to allow my loading screen dialog to be customizable, you don't have to
             $("#loadingScreen").html(waiting.message && '' != waiting.message ? waiting.message : 'Por favor espere...');
             $("#loadingScreen").dialog('option', 'title', waiting.title && '' != waiting.title ? waiting.title : 'Ejecutando Consulta...');
             $("#loadingScreen").dialog('open');
             $(".ui-dialog-titlebar-close").css("display", "none");
         }
         function cargaestatus() {
             PageMethods.estatus(function (opcion) {
                 var opt = eval('(' + opcion + ')');
                 var lista = '';
                 for (var list = 0; list < opt.length; list++) {
                     lista += '<option value="' + opt[list].id + '">' + opt[list].desc + '</option>';
                 };
                 $('#dlestatus').empty();
                 $('#dlestatus').append(inicial);
                 $('#dlestatus').append(lista);
                 $('#dlstatus').val(1);
             }, iferror);
         }
         function asignapagina(np) {
             $('#paginacion li').removeClass("active");
             $('#hdpagina').val(np);
             cargalista();
             $('#paginacion li').eq(np - 1).addClass("active");
         };
         function cuentacm() {
             PageMethods.contarcm($('#txfecini').val(), $('#txfecfin').val(), $('#txid').val(), $('#dlestatus').val(), function (cont) {
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
             //waitingDialog({});
             PageMethods.solicitudes($('#txfecini').val(), $('#txfecfin').val(), $('#txid').val(), $('#hdpagina').val(), $('#dlestatus').val(),  function (res) {
                 //closeWaitingDialog();

                 var ren = $.parseHTML(res);
                 if (ren == null) {
                     $('#tblista tbody').remove();
                     alert('No se han encontrado registros con los criterios seleccionado');
                 }
                 else {
                     $('#tblista tbody').remove();
                     $('#tblista').append(ren);
                     $('#tblista tbody tr').on('click', '.btedita', function () {
                         if ($(this).closest('tr').find('td').eq(4).text() == 'Alta','Autorizado') {
                             window.open('Man_Pro_CorrectivoMayor.aspx?folio=' + $(this).closest('tr').find('td').eq(0).text(), '_blank')
                         } else {
                             alert('El estatus actual del correctivo no permite realizar cambios, verifique');
                         }
                     })
                 }

                 $('#tblista tbody tr').on('click', '.btevidencia', function () {
                     $('#txid1').val($(this).closest('tr').find('td').eq(0).text());
                     $("#divmodal").dialog('option', 'title', 'Carga de expediente');
                     dialog.dialog('open');
                     if ($(this).closest('tr').find('td').eq(7).text() == 'Si') {
                         $('#lbarchivo').val($(this).closest('tr').find('td').eq(8).text());
                         $('#dvabre').show();
                         $('#dvcarga').hide();
                     } else {
                         $('#dvabre').hide();
                         $('#dvcarga').show();
                     }

                 });

                 $('#tblista tbody tr').delegate(".btauto", "click", function () {
                     if ($('#idusuario').val() != 163 ) {
                         alert('Usted no esta autorizado para realizar esta operación');
                     } else {
                         $('#dlestatus1').empty();
                         var lista = '<option value="0">Seleccione...</option>';
                         lista += '<option value="4">Autorizar</option>'
                         lista += '<option value="6">Rechazar</option>'
                         $('#dlestatus1').append(lista);
                         $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                         $("#divmodal1").dialog('option', 'title', 'Autorizar/rechazar Correctivo');
                         dialog1.dialog('open');
                     }
                 });
                 /*$('#tblista tbody tr').delegate(".btauto", "click", function () {
                     if ($('#idusuario').val() != 163) {
                         alert('Usted no esta autorizado para realizar esta operación');
                     } else {
                         $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                         $("#divmodal1").dialog('option', 'title', 'Autorizar/Rechazar Correctivo');
                         dialog1.dialog('open');
                     }  
                 });*/

                     /*
                     $('#tblista tbody tr').delegate(".btvalida", "click", function () {
                         if ($('#idusuario').val() != 1 && $('#idusuario').val() != 59 && $('#idusuario').val() != 81 && $('#idusuario').val() != 85 && $('#idusuario').val() != 100 && $('#idusuario').val() != 130 && $('#idusuario').val() != 84) {
                             alert('Usted no esta autorizado para realizar esta operación');
                         } else {
                             $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                             $("#divmodal1").dialog('option', 'title', 'Validar/rechazar Solicitud');
                             dialog1.dialog('open');
                         }
                     });
                     $('#tblista tbody tr').delegate(".btlibera", "click", function () {
                         if ($('#idusuario').val() != 5) {
                             alert('Usted no esta autorizado para realizar esta operación');
                         } else {
                             $('#dlestatus1').empty();
                             var lista = '<option value="0">Seleccione...</option>';
                             lista += '<option value="3">Liberar</option>'
                             lista += '<option value="6">Rechazar</option>'
                             $('#dlestatus1').append(lista);
                             $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                             $("#divmodal1").dialog('option', 'title', 'liberar/rechazar Solicitud');
                             dialog1.dialog('open');
                         }
                     });
                     $('#tblista tbody tr').delegate(".btautoriza", "click", function () {
                         if ($('#idusuario').val() != 27) {
                             alert('Usted no esta autorizado para realizar esta operación');
                         } else {
                             $('#dlestatus1').empty();
                             var lista = '<option value="0">Seleccione...</option>';
                             lista += '<option value="4">Autorizar</option>'
                             lista += '<option value="6">Rechazar</option>'
                             $('#dlestatus1').append(lista);
                             $('#txreq').val($(this).closest('tr').find('td').eq(0).text());
                             $("#divmodal1").dialog('option', 'title', 'Autorizar/rechazar Solicitud');
                             dialog1.dialog('open');
                         }
                     });
                     $('#tblista tbody tr').delegate(".btpagado", "click", function () {
                         if ($('#idusuario').val() != 139 && $('#idusuario').val() != 138) {
                             alert('Usted no esta autorizado para realizar esta operación');
                         } else {
                             waitingDialog({});
                             PageMethods.cambiaestatus($(this).closest('tr').find('td').eq(0).text(), 5, $('#idusuario').val(), $('#txmotivo').val(), function (res) {
                                 cuentasolicitud();
                                 cargalista();
                                 closeWaitingDialog();
                             }, iferror);
                         }

                     });*/
             }, iferror);
         }
         function closeWaitingDialog() {
             $("#loadingScreen").dialog('close');
         }
         function xmlUpFile(res) {
             if (valida()) {
                 waitingDialog({});
                 var fileup = $('#txarchivo').get(0);
                 var files = fileup.files;
                 var ndt = new FormData();
                 for (var i = 0; i < files.length; i++) {
                     ndt.append(files[i].name, files[i]);
                     ndt.append("Id", $("#txid1").val());
                 }
                 ndt.append('nmr', res);
                 $.ajax({
                     url: '../GH_Updoctocorrec.ashx',
                     type: 'POST',
                     data: ndt,
                     contentType: false,
                     processData: false,
                     success: function (res) {
                         PageMethods.actualiza($('#txid1').val(), res, function (res) {
                             alert('La evidencia de ha cargado exitosamente');
                             cargalista();
                             closeWaitingDialog();
                             dialog.dialog('close');
                         }, iferror);
                     },
                     error: function (err) {
                         alert(err.statusText);
                     }
                 });
             }
         }
         function iferror(err) {
             alert('ERROR ' + err._message);
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
        <asp:HiddenField ID="hdpagina" runat="server" />
        <asp:HiddenField ID="idusuario" runat="server" />
        <asp:HiddenField ID="idcliente1" runat="server" />
        <asp:HiddenField ID="hdstatus" runat="server" Value="1" />
        <asp:HiddenField ID="valida" runat="server"  Value="0"/>
        <asp:HiddenField ID="idfolio" runat="server" />
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
                    <h1>Consulta Correctivo mayor<small>Mantenimiento</small></h1>
                    <ol class="breadcrumb">
                        <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                        <li><a>Mantenimiento</a></li>
                        <li class="active">Consulta de Correctivo</li>
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
                                        <label for="dltipo">No. CM:</label>
                                    </div>
                                    <div class="col-lg-1">
                                        <input type="text" id="txid" class="form-control" value ="0"/>
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">F. inicial:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecini" class="form-control" />
                                    </div>
                                    <div class="col-lg-1 text-right">
                                        <label for="dltipo">F. final:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" id="txfecfin" class="form-control" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 text-right">
                                        <label for="dlestatus">Estatus:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <select id="dlestatus" class="form-control"></select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-10">
                                        <input type="button" value="Consultar" id="btconsulta" class="btn btn-info pull-right" />
                                    </div>
                                </div>
                                <ol class="breadcrumb">
                                    <li id="btnuevo1" class="puntero"><a><i class="fa fa-edit"></i>Nuevo</a></li>
                                    <li id="btexporta1" class="puntero"><a><i class="fa fa-save"></i>Exportar a excel</a></li>
                                </ol>
                            </div>
                            <div class="col-md-18 tbheader" style=" height: 300px; overflow-y: scroll;">
                                <table class="table table-responsive h6" id="tblista">
                                    <thead>
                                        <tr>
                                            <th class="bg-light-blue-gradient"><span>CM</span></th>
                                            <th class="bg-light-blue-gradient"><span>Trabajo</span></th>
                                            <th class="bg-light-blue-gradient"><span>Cliente</span></th>
                                            <th class="bg-light-blue-gradient"><span>Sucursal</span></th>    
                                            <th class="bg-light-blue-gradient"><span>Estatus</span></th>                                           
                                            <th class="bg-light-blue-gradient"><span>F. Alta</span></th>                                                                                 
                                            <th class="bg-light-blue-gradient"><span>Descripción</span></th> 
                                            
                                        </tr>
                                    </thead>
                                </table>
                            </div>
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
                        <div id="divmodal1" class="row">
                            <div class="row">
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txreq">No. CM:</label>
                                    </div>
                                    <div class="col-lg-2">
                                        <input type="text" class=" form-control" id="txreq" disabled="disabled" />
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="dlestatus1">Estatus:</label>
                                    </div>
                                    <div class="col-lg-3">
                                        <select id="dlestatus1" class="form-control">
                                            <option value="0">Seleccione...</option>
                                            <option value="4">Autorizar</option>
                                            <option value="6">Rechazar</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-2 text-right">
                                        <label for="txmotivo">Motivo:</label>
                                    </div>
                                    <div class="col-lg-6" >
                                        <textarea class="form-control" id="txmotivo" maxlength="300"></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-5">
                                        <input type="button" class="btn btn-primary" value="Guardar" id="btautoriza" />
                                    </div>
                                </div>
                            </div>
                        </div>

                    <div class="row" id="divmodal">
                        <div class="row"> 
                            <div class="col-lg-3">
                                <label for="txid">Clave CM:</label>
                            </div>
                            <div class="col-lg-2">
                                <input type="text" id="txid1" class="form-control" disabled="disabled"/>
                            </div>
                        </div>
                        <hr />
                        <div class="row" id="dvcarga">
                            <div class="row">
                                <div class="col-lg-2 text-right">
                                    <label for="dlcliente">Archivo:</label>
                                </div>
                                <div class="col-lg-8">
                                    <input type="file" id="txarchivo" class="form-control" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-4 text-right">
                                    <input type="button" id="btfile" class="btn btn-success" value="Subir Archivo" onclick="xmlUpFile()" />
                                </div>
                            </div>
                        </div>
                        <div class="row" id="dvabre">
                            <asp:HiddenField id="lbarchivo" runat="server" />
                            <div class="col-lg-4 text-right">
                                <input type="button" class="btn btn-primary" id="btdescarga" value="Descargar Expediente"/>
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
