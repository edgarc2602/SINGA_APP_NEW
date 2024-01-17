<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Rh_AltaAspirante.aspx.vb" Inherits="App_RH_Rh_AltaAspirante" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registra Aspirante</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>
    <script type="text/javascript">
    $(document).ready(function () {
        EscondeYMuestraCampos();
        $("#DropDownList6").click(function () {
            var selectedValues = [];
            $("#DropDownList6 :selected").each(function () {
                selectedValues.push($(this).val());
            });
            if (selectedValues == 0) {
                $("#ContenedorRFC").hide();
                $("#ContenedorNom1").hide();
                $("#ContenedorNom2").hide();
                $("#ContenedorNom3").hide();
            }
            if (selectedValues == 1) {
                $("#ContenedorRFC").show('slow');
                $("#ContenedorNom1").hide();
                $("#ContenedorNom2").hide();
                $("#ContenedorNom3").hide();
                document.getElementById('Label7').innerHTML = 'RFC'
            }
            if (selectedValues == 2) {
                $("#ContenedorRFC").hide();
                $("#ContenedorNom1").show('slow');
                $("#ContenedorNom2").show('slow');
                $("#ContenedorNom3").show('slow');
            }
            if (selectedValues == 3) {
                $("#ContenedorRFC").show('slow');
                $("#ContenedorNom1").hide();
                $("#ContenedorNom2").hide();
                $("#ContenedorNom3").hide();
                document.getElementById('Label7').innerHTML = 'Numero Empleado'
            }
            if (selectedValues == 4) {
                $("#ContenedorRFC").show('slow');
                $("#ContenedorNom1").hide();
                $("#ContenedorNom2").hide();
                $("#ContenedorNom3").hide();
                document.getElementById('Label7').innerHTML = 'Numero IMSSS'
            }
            if (selectedValues == 5) {
                $("#ContenedorRFC").show('slow');
                $("#ContenedorNom1").hide();
                $("#ContenedorNom2").hide();
                $("#ContenedorNom3").hide();
                document.getElementById('Label7').innerHTML = 'CURP'
            }

        });
    });
    function EscondeYMuestraCampos() {
        $("#seccion1").hide();
        document.getElementById('DropDownList6').value = 0;
        $("#ContenedorRFC").hide();
        $("#ContenedorNom1").hide();
        $("#ContenedorNom2").hide();
        $("#ContenedorNom3").hide();
        $("#Contgrig").hide();
        $("#Consulta").hide();
    }
    function continuar(val) {
        if (val == 0) {
            $("#seccion1").show();
            document.getElementById('DropDownList6').value = 0;
            $("#ContenedorRFC").hide();
            $("#ContenedorNom1").hide();
            $("#ContenedorNom2").hide();
            $("#ContenedorNom3").hide();
            $("#Contgrig").show();
            $("#Consulta").show();
            $("#datos").hide();
        }
        if (val == 1) {
            $("#seccion1").hide();
            document.getElementById('DropDownList6').value = 0;
            $("#ContenedorRFC").hide();
            $("#ContenedorNom1").hide();
            $("#ContenedorNom2").hide();
            $("#ContenedorNom3").hide();
            $("#Contgrig").hide();
            $("#Consulta").hide();
            $("#datos").show();
        }
        if (val == 2) {
            e = "0";
            if (document.getElementById('txtrfc').value.length == 13) {
                e = "1";
            }
            if (document.getElementById('txtrfc').value.length == 12) {
                e = "1";
            }
            if (e == "0") {
                alert('El RFC debe de tener 12 caracteres si es persona fisica o 13 si es persona moral, verifique!')
                return false;
            }
            e = document.getElementById('txtnombre').value
            if (e == "") {
                alert('Debe de capturar el Nombre(s) del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('txtapaterno').value
            if (e == "") {
                alert('Debe de capturar el Apellido Paterno del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('txtamaterno').value
            if (e == "") {
                alert('Debe de capturar el Apellido Materno del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('ddlsexo').value
            if (e == "0") {
                alert('Debe de seleccionar el sexo del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('txttelp').value
            if (e == "") {
                alert('Debe de capturar el Telefono Principal del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('ddlestado').value
            if (e == "0") {
                alert('Debe de seleccionar el Estado del aspirante, verifique!')
                return false;
            }
            e = document.getElementById('ddlPuesto').value
            if (e == "0") {
                alert('Debe de seleccionar el Puesto del aspirante, verifique!')
                return false;
            }
            __doPostBack('guardapros', val);
        }
        if (val == 3) {
            $("#datos").hide();
            $("#seccion1").show();
        }
        if (val == 4) {
            window.location.replace("Rh_AltaAspirante.aspx");
        }

    }
    function validarfc() {
        e = "0";
        if (document.getElementById('txtrfc').value.length == 13) {
            e = "1";
        }
        if (document.getElementById('txtrfc').value.length == 12) {
            e = "1";
        }
        if (e == "0"){
            alert('El RFC debe de tener 12 caracteres si es persona fisica o 13 si es persona moral, verifique')
            return false;
        }
        __doPostBack('validarfc');
    }
    function mensaje(men) {
        alert(men);
    }
    function busca() {
        __doPostBack('busca');
    }
    </script>
</head>
  <body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
    <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <div class="main-header">
        <a href="../Home.aspx" class="logo">
          <span class="logo-mini"><b>S</b>GA</span>
          <span class="logo-lg"><b>SIN</b>GA</span>
        </a>
        <nav class="navbar navbar-static-top" role="navigation">
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>
          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
              <li class="dropdown notifications-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <i class="fa fa-bell-o"></i>
                  <span class="label label-warning">0</span>
                </a>
              </li>
              <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                  <img src="../Content/form/img/incognito.jpg" class="user-image" alt="User Image" />
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </div>
      <div class="main-sidebar">
        <div class="sidebar">
            <%= labelmenu%>
        </div>
      </div>
        <div class="content-wrapper">
        <div class="content-header">
          <h1>
              Prospecto
            <small>Alta</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>RH</a></li>
            <li class="active">Alta Prospecto</li>
          </ol>
        </div>

        <!-- Main content -->
        <div class="content" >
          <div class="row" id="df">
            <div class="col-md-11">
              <div class="box box-info" id="paso1">
                <div class="box-header with-border">
                </div><!-- /.box-header -->
                <asp:UpdatePanel ID="UpdatePanel8" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                        <table class="box-body" id="seccion1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:90%; height:80%">
                        <tr>
                            <th colspan="2" style=" text-align:center;">
                                Capture los datos Solicitados:</th>
                        </tr>
                        <tr>
                           <th style="text-align:right">
                                Buscar por:</th>
                            <th style="text-align: left">
                                <asp:DropDownList ID="DropDownList6" runat="server" Width="50%">
                                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                                    <asp:ListItem Value="1">RFC</asp:ListItem>
                                    <asp:ListItem Value="2">Nombre</asp:ListItem>
                                    <asp:ListItem Value="3">No. Empleado</asp:ListItem>
                                    <asp:ListItem Value="4">No. IMSS</asp:ListItem>
                                    <asp:ListItem Value="5">CURP</asp:ListItem>
                                </asp:DropDownList>
                            </th>     
                        </tr>
                        <tr id="ContenedorRFC">
                            <td style="text-align:right">
                                <asp:Label ID="Label7" runat="server" Text="RFC:" > </asp:Label></td>
                            <th style="text-align: left" >
                                    <asp:TextBox ID="TextBox1" runat="server" Width="70%"></asp:TextBox>
                                    <asp:Label ID="Label15" runat="server" 
                                        style="top: 8px; left: 573px; position: absolute; height: 13px; width: 201px; text-align: right;" 
                                        Text=""> </asp:Label>
                            </th>     
                        </tr>
                        <tr id="ContenedorNom1">
                            <td style="text-align:right">
                                Nombre:</td>
                            <th style="text-align: left">
                                <asp:TextBox ID="TextBox18" runat="server" Width="70%"></asp:TextBox>                  
                            </th>     
                        </tr>
                        <tr id="ContenedorNom2">
                            <td style="text-align:right">
                                Apellido Paterno:</td>
                            <th style="text-align: left" >
                                <asp:TextBox ID="TextBox32" runat="server" Width="70%"></asp:TextBox>                  
                            </th>     
                        </tr>
                        <tr id="ContenedorNom3">
                            <td style="text-align:right">
                                Apellido Materno:</td>
                            <th style="text-align: left">
                                <asp:TextBox ID="TextBox35" runat="server" Width="70%"></asp:TextBox>                  
                            </th>     
                        </tr>
                        <tr id="Tr1">
                            <td style="text-align:right">
                            </td>
                            <th style="text-align: left">
                                <a onclick="busca(0);"><i class="fa fa-archive"></i> buscar</a>
                                <asp:Button ID="Button1" runat="server" Text="Guardar" onclientclick="busca(0);" class="btn btn-info pull-right" />
                            </th>     
                        </tr>
                        </table>
                        <table class="box-body" id="Consulta" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:90%; height:80%">
                            <tr>
                                <td class="style1" >
                                Listado de Empleados:</td>
                            </tr>                     
                        </table>
                        <table id="Contgrig" class="box-body" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:100%; height:80%">
                            <tr>
                                <th>
                                <small>
                                    <asp:GridView ID="GridView2" runat="server" 
                                        AutoGenerateColumns="False" AllowPaging="True" 
                                            AllowSorting="True" DataKeyNames="Id_Empleado,Numero,RFC" 
                                        Height="50%" Width="95%" >
                                        <Columns>
                                            <asp:BoundField HeaderText="#" DataField="Numero"/>
                                            <asp:BoundField HeaderText="Estatus" DataField="Estatus"/>
                                            <asp:BoundField HeaderText="RFC" DataField="RFC" />
                                            <asp:BoundField HeaderText="Empleado" DataField="Empleado" />
                                            <asp:BoundField HeaderText="Direccion" DataField="Direccion" />
                                            <asp:BoundField HeaderText="F. Alta" DataField="Fecha_Alta" DataFormatString="{0:d}" />
                                            <asp:BoundField HeaderText="F. Baja" DataField="Emp_FechaBaja" DataFormatString="{0:d}"/>
                                            <asp:CommandField ShowSelectButton="True" SelectText="&gt;&gt;" />
                                        </Columns>
                                            <PagerStyle CssClass="gridViewPaginacion" />
                                            <HeaderStyle CssClass="gridViewHeader" />
                                    </asp:GridView> 
                                    <asp:Label ID="campo" runat="server" Visible="False"></asp:Label>
                                </small>
                                </th>
                            </tr>
                        </table>
                       <table class="box-body" id="datos" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:100%; height:80%">
                            <tr>
                                <th colspan="8" style=" text-align:center;">
                                Datos Generales:</th>
                            </tr>                     
                            <tr>
                                <td>RFC:</td>
                                <td>
                                    <asp:TextBox ID="txtrfc" class="form-control"  runat="server" onblur="return validarfc();"></asp:TextBox>
                                </td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtfecnac" class="form-control"  runat="server" Enabled="false" ></asp:TextBox>
                                </td>
                                <td >CURP:</td>
                                <td>
                                    <asp:TextBox ID="txtcurp" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td >No. Prospecto:</td>
                                <td>
                                    <asp:Label ID="id" runat="server" ></asp:Label>
                                    <asp:TextBox ID="txtnpros" class="form-control" Enabled="false" runat="server"></asp:TextBox>
                                </td>

                            </tr>                     
                            <tr>
                                <td>Nombre(s):</td>
                                <td>
                                    <asp:TextBox ID="txtnombre" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                               <td>Apellido Paterno:</td>
                                <td >
                                    <asp:TextBox ID="txtapaterno" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Apellido Materno:</td>
                                <td >
                                    <asp:TextBox ID="txtamaterno" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Sexo:</td>
                                <td>
                                    <asp:DropDownList ID="ddlsexo" class="form-control" runat="server" onfocus="calculacostop();">
                                        <asp:ListItem Value="0">Sel. Sexo</asp:ListItem>
                                        <asp:ListItem Value="1">MASCULINO</asp:ListItem>
                                        <asp:ListItem Value="2">FEMENINO</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>                     
                            <tr>
                                <td>Calle:</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtcalle" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>No Interior:</td>
                                <td>
                                    <asp:TextBox ID="txtnint" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>No Exterior:</td>
                                <td>
                                    <asp:TextBox ID="txtnext" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                            </tr>                     
                            <tr>
                                <td>Colonia:</td>
                                <td >
                                    <asp:TextBox ID="txtcol" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Del/Mun:</td>
                                <td >
                                    <asp:TextBox ID="txtdel" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Estado:</td>
                                <td>
                                    <asp:DropDownList ID="ddlestado" class="form-control" runat="server" onfocus="calculacostop();">
                                    </asp:DropDownList>
                                </td>
                                <td >C.P.:</td>
                                <td>
                                    <asp:TextBox ID="txtcp" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Lugar Nacimiento:</td>
                                <td>
                                    <asp:TextBox ID="txtln" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Nacionalidad:</td>
                                <td>
                                    <asp:TextBox ID="txtnac" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Edo. Civil:</td>
                                <td>
                                    <asp:DropDownList ID="ddledocivil" class="form-control" runat="server" onfocus="calculacostop();">
                                        <asp:ListItem Value="0">Seleccione</asp:ListItem>
                                        <asp:ListItem Value="1">SOLTERO</asp:ListItem>
                                        <asp:ListItem Value="2">CASADO</asp:ListItem>
                                        <asp:ListItem Value="3">DIVORCIADO</asp:ListItem>
                                        <asp:ListItem Value="4">VIUDO</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td >Afiliacion IMSS:</td>
                                <td>
                                    <asp:TextBox ID="txtimss" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                            </tr>  
                            <tr>
                                <td>Tel. Principal:</td>
                                <td>
                                    <asp:TextBox ID="txttelp" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Tel. emergencias:</td>
                                <td>
                                    <asp:TextBox ID="txttelemer" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Correo electronico :</td>
                                <td>
                                    <asp:TextBox ID="txtcorreo" class="form-control"  runat="server"></asp:TextBox>
                                </td>
                                <td>Puesto:</td>
                                <td>
                                    <asp:DropDownList ID="ddlPuesto" class="form-control" runat="server" onfocus="calculacostop();">
                                    </asp:DropDownList>
                                </td>
                            </tr>                                                 
                            <tr>
                                <td>Observaciones:</td>
                                <td colspan="5">
                                    <asp:TextBox ID="txtobs" class="form-control"  runat="server" TextMode="MultiLine" ></asp:TextBox>
                                </td>
                            </tr>                                                 
                        </table>
   


                        <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                            style="border-collapse: collapse; width:90%; height:80%">

                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <div class="box-header with-border">
                    <ol class="breadcrumb">
                        <li onclick="return continuar(0);"><a ><i class="fa fa-dashboard"></i> Buscar</a></li>
                        <li onclick="return continuar(4);"><a ><i class="fa fa-dashboard"></i> Nuevo</a></li>
                        <li onclick="return continuar(2);"><a ><i class="fa fa-dashboard"></i> Guardar</a></li>
                        <li onclick="return continuar(3);"><a ><i class="fa fa-dashboard"></i> Dar de Baja</a></li>
                    </ol>
              </div>
              </div>
            </div>
        </div>   
        </div>

     </div>
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>

      <div class="control-sidebar control-sidebar-dark">
      </div>
    <!-- jQuery 2.1.4 -->
    <script src="../Content/form/js/jQuery-2.1.4.min.js" type="text/javascript"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" type="text/javascript"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script type="text/javascript">
        $.widget.bridge('uibutton', $.ui.button);
        function test_onclick() {

        }

    </script>
        <!-- Slimscroll -->
    <script src="../Content/form/js/jquery.slimscroll.min.js" type="text/javascript"></script>
    <!-- AdminLTE App -->
    <script src="../Content/form/js/app.min.js" type="text/javascript"></script>

    
    </div>
    </form>
</body>
</html>
