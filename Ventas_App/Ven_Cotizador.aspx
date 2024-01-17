<%@ Page Language="VB" enableEventValidation="false" ValidateRequest="true" AutoEventWireup="false" CodeFile="Ven_Cotizador.aspx.vb" Inherits="Ventas_App_Ven_Cotizador" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cotizador</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />

    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/_all-skins.min.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="../Content/form/js/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../Content/form/js/jquery-ui.js"></script>

    <style type="text/css">
        .boton {
    float:left;
    margin-right:10px;
    margin-top:200px;
    width:130px;
    height:40px;
    background:#222;
    color:#fff;
    padding:16px 6px 0 6px;
    cursor:pointer;
    text-align:center;
}
 
.boton:hover{color:#01DF01}
 
.ventana{
 
    display:none;     
    font-family:Arial, Helvetica, sans-serif;
    color:#808080;
    line-height:28px;
    font-size:15px;
    text-align:justify;
 
}
    </style>

<script type="text/javascript">
    function cargadat(val) {
        if (val == 1) {
            $('#cargadir').hide('');
            $('#detdir1').hide('');
            $('#detdir2').hide('');
            $('#detdir3').hide('');
            $('#detdir4').hide('');
            __doPostBack('dir', val);
        }
        if (val == 2) {
            $('#cargadir').show('');
            $('#detdir1').hide('');
            $('#detdir2').hide('');
            $('#detdir3').hide('');
            $('#detdir4').hide('');
        }
        if (val == 3) {
            $('#cargadir').hide('');
            $('#detdir1').show('');
            $('#detdir2').show('');
            $('#detdir3').show('');
            $('#detdir4').show('');
        }
        if (val == 4) {

            e = document.getElementById('cargaarch').value;
            if (e == '') {
                alert("Validacion!, Debe de ingresar la ubicacion del archivo que desea importar");
                return false;
            }
            __doPostBack('dir', val);
        }
    }
</script>
<script type="text/javascript">
    function cargaper(val) {
        if (val == 1) {
            $('#cargaper').hide('');
            $('#detper1').hide('');
            $('#detper2').hide('');
            __doPostBack('per', val);
        }
        if (val == 2) {
            $('#cargaper').show('');
            $('#detper1').hide('');
            $('#detper2').hide('');
        }
        if (val == 3) {
            $('#cargaper').hide('');
            $('#detper1').show('');
            $('#detper2').show('');
        }
        if (val == 4) {

            e = document.getElementById('FileUpload1').value;
            if (e == '') {
                alert("Validacion!, Debe de ingresar la ubicacion del archivo que desea importar");
                return false;
            }
            __doPostBack('per', val);
        }
        if (val == 5) {
            $('#cargaunif').hide('');
            $('#detuni1').hide('');
            $('#detuni2').hide('');
            __doPostBack('per', val);
        }
        if (val == 6) {
            $('#cargaunif').show('');
            $('#detuni1').hide('');
            $('#detuni2').hide('');
        }
        if (val == 7) {
            $('#cargaunif').hide('');
            $('#detuni1').show('');
            $('#detuni2').show('');
        }


        if (val == 8) {

            e = document.getElementById('FileUpload2').value;
            if (e == '') {
                alert("Validacion!, Debe de ingresar la ubicacion del archivo que desea importar");
                return false;
            }
            __doPostBack('per', val);
        }
        if (val == 9) {
            $('#cargamat').hide('');
            $('#detmat1').hide('');
            $('#detmat2').hide('');
            __doPostBack('per', val);
        }
        if (val == 10) {
            $('#cargamat').show('');
            $('#detmat1').hide('');
            $('#detmat2').hide('');
        }
        if (val == 11) {
            $('#cargamat').hide('');
            $('#detmat1').show('');
            $('#detmat2').show('');
        }


        if (val == 12) {

            e = document.getElementById('FileUpload3').value;
            if (e == '') {
                alert("Validacion!, Debe de ingresar la ubicacion del archivo que desea importar");
                return false;
            }
            __doPostBack('per', val);
        } 
    }
</script>
<script type="text/javascript">

    function mensaje(men,tipo) {
        alert(men);
        muestra(tipo);
    }
    function llenacot(d) {
        dato = d
        __doPostBack('consultadesglose', dato);
    }
    function muestradetalle() {
        $("#dialogo3").dialog({
            width: 590,
            height: 350,
            show: "blind",
            hide: "shake",
            resizable: "false",
            position: "center"
        });
    }

    function limpia() {
        $('#txtrsc').text('');
        $('#txtrsp').text('');
        $('#txtrs').text('');
        $('#txtcontacto').text('');
        $('#txtcontacto').text('');
        $('#txttel').text('');
        $('#txtmail').text('');
    }
</script>
<script type="text/javascript">
    function muestra(tipo) {
//        limpia();
        if (tipo == 0) {
            $('#lrs').show('');
            $('#lts').hide('');
            $('#lddlts').hide('');
            $('#txtrsc').show('');
            document.getElementById('chkprospecto').checked = false
            document.getElementById('chknuevo').checked = false
            //$('#lrs').toggle('slide', { direction: 'down' }, 700);
            //$('#txtrsc').toggle('slide', { direction: 'down' }, 700);
            $('#txtrsp').hide('');
            $('#txtrs').hide('');
            $('#nuevop').hide('slow');
        }
        if (tipo == 1) {
            $('#lrs').show('');
            $('#lts').show('');
            $('#lddlts').show('');
            $('#txtrsp').show('');
            document.getElementById('chkcliente').checked = false
            document.getElementById('chknuevo').checked = false
            //$('#lrs').toggle('slide', { direction: 'down' }, 700);
            //$('#txtrsp').toggle('slide', { direction: 'down' }, 700);
            $('#txtrsc').hide('');
            $('#txtrs').hide('');
            $('#nuevop').hide('slow');
        }
        if (tipo == 2) {
            $('#lrs').show('');
            $('#lts').show('');
            $('#lddlts').show('');
            $('#txtrs').show('');
            document.getElementById('chkcliente').checked = false
            document.getElementById('chkprospecto').checked = false
            //$('#lrs').toggle('slide', { direction: 'down' }, 700);
            //$('#txtrs').toggle('slide', { direction: 'down' }, 700);
            $('#txtrsc').hide('');
            $('#txtrsp').hide('');
            $('#nuevop').toggle('slide', { direction: 'down' }, 700);
        }

    }
</script>
<script type="text/javascript">
    function continuar(val) {
        if (val == 0) {
            paso(0,'')
        }
        if (val == 1) {
            rsc = document.getElementById('txtrsc').value
            rsp = document.getElementById('txtrsp').value
            rs = document.getElementById('txtrs').value

            if (document.getElementById('chkcliente').checked == true) {
                if (rsc == '') {
                    alert('La Razon Social es un dato necesario.');
                    return false;
                }
            }
            if (document.getElementById('chkprospecto').checked == true) {
                ddlts = document.getElementById('ddltservicio').value
                if (rsp == '') {
                    alert('La Razon Social es un dato necesario.');
                    return false;
                }
                if (ddlts == '0') {
                    alert('El tipo de Servicio es un dato necesario.');
                    return false;
                }
            }

            if (document.getElementById('chknuevo').checked == true) {

                ddlts = document.getElementById('ddltservicio').value
                contacto = document.getElementById('txtcontacto').value
                tel = document.getElementById('txttel').value
                mail = document.getElementById('txtmail').value
                ddlejec = document.getElementById('ddlejecutivo').value

                if (rs == '') {
                    alert('La Razon Social es un dato necesario.');
                    return false;
                }
                if (ddlts == '0') {
                    alert('El tipo de Servicio es un dato necesario.');
                    return false;
                }
                if (contacto == '') {
                    alert('El contacto es un dato necesario.');
                    return false;
                }
                if (tel == '') {
                    alert('El Telefono es un dato necesario.');
                    return false;
                }
                if (ddlejec == '0') {
                    alert('El Ejecutivo es un dato necesario.');
                    return false;
                }

            }
            $('#divp2').show('')
            $('#gwm').hide('')
            $('#gvuhem').hide('')
            $('#gwp').hide('')
            $('#gwsa').hide('')
            __doPostBack('continua', '1')
        }
        if (val == 2) {
            $('#divp2').hide('')
            $('#uni').hide('')
            $('#Material').hide('')
            $('#Herramienta').hide('')
            $('#Equipo').hide('')
            $('#seradi').hide('')
            $('#qwsa').hide('')
            $('#gwm').hide('')
            $('#gvuhem').hide('')
            $('#gwh').hide('')
            $('#gwsa').hide('')
            $('#gwe').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
            $('#Personal').toggle('slide', { direction: 'down' }, 700);
            $('#gwp').show('')
        }
        if (val == 3) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Material').hide('')
            $('#Herramienta').hide('')
            $('#Equipo').hide('')
            $('#seradi').hide('')
            $('#qwsa').hide('')
            $('#gwm').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwsa').hide('')
            $('#gwe').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#Table2').toggle('slide', { direction: 'down' }, 700);
            $('#uni').toggle('slide', { direction: 'down' }, 700);
            $('#gvuhem').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }
        if (val == 4) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Herramienta').hide('')
            $('#Equipo').hide('')
            $('#seradi').hide('')
            $('#qwsa').hide('')
            $('#uni').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwe').hide('')
            $('#gwsa').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#gvuhem').hide('')
            $('#Material').toggle('slide', { direction: 'down' }, 700);
            $('#gwm').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }
        if (val == 5) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Material').hide('')
            $('#seradi').hide('')
            $('#qwsa').hide('')
            $('#Equipo').hide('')
            $('#uni').hide('')
            $('#gwp').hide('')
            $('#gwm').hide('')
            $('#gwe').hide('')
            $('#gvuhem').hide('')
            $('#gwsa').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#Herramienta').toggle('slide', { direction: 'down' }, 700);
            $('#gwh').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }
        if (val == 6) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Herramienta').hide('')
            $('#Material').hide('')
            $('#uni').hide('')
            $('#seradi').hide('')
            $('#qwsa').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwm').hide('')
            $('#gvuhem').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#gwsa').hide('')
            $('#Equipo').toggle('slide', { direction: 'down' }, 700);
            $('#gwe').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }
        if (val == 7) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Herramienta').hide('')
            $('#Material').hide('')
            $('#uni').hide('')
            $('#Equipo').hide('')
            $('#gwe').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwm').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#gvuhem').hide('')
            $('#seradi').toggle('slide', { direction: 'down' }, 700);
            $('#gwsa').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }
        if (val == 8) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Herramienta').hide('')
            $('#Material').hide('')
            $('#uni').hide('')
            $('#Equipo').hide('')
            $('#gwe').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwm').hide('')
            $('#gvuhem').hide('')
            $('#seradi').hide('')
            $('#gwsa').hide('')
            $('#dvp1').show('')
            $('#dvp2').show('')
            $('#dirdat').hide('')
            $('#gwdirdat').hide('')
        }


        if (val == 9) {
            $('#divp2').hide('')
            $('#Personal').hide('')
            $('#Herramienta').hide('')
            $('#Material').hide('')
            $('#uni').hide('')
            $('#Equipo').hide('')
            $('#gwe').hide('')
            $('#gwp').hide('')
            $('#gwh').hide('')
            $('#gwm').hide('')
            $('#gvuhem').hide('')
            $('#seradi').hide('')
            $('#gwsa').hide('')
            $('#dvp1').hide('')
            $('#dvp2').hide('')
            $('#dirdat').show('')
            $('#gwdirdat').show('')
        }
    }
</script>
<script type="text/javascript">
    function paso(val, msg) {
        if (msg != "") {
            alert(msg)
        }
        if (val == 0) {
            $('#paso1').toggle('slide', { direction: 'down' }, 700);
            $('#paso2').hide('')
        }
        if (val == 1) {
            $('#paso1').toggle('slide', { direction: 'down' }, 700);
            $('#paso2').toggle('slide', { direction: 'down' }, 700);
        }
        if (val == 2) {
            $('#paso1').hide('')
            $('#paso2').show('')
        }
    }

    function calculacostop() {
        dsueldo = $('#ddlpuesto').val();
        var arregloDeCadenas = dsueldo.split('|');
        dcantidad = 0;
        if ($('#txtcantidad').val() == '') {
        } else {
            dcantidad = $('#txtcantidad').val()
        }
    document.getElementById('txtsueldo').value = arregloDeCadenas[2]
    document.getElementById('txtcosto').value = arregloDeCadenas[3]
    dcosto = arregloDeCadenas[3] 
    document.getElementById('txtcostot').value = dcosto * dcantidad
}
</script>
<script type="text/javascript">
function agrega(val) {
    if (val == 0) {
        cantidad = document.getElementById('txtcantidad').value
        sueldo = document.getElementById('txtsueldo').value
        if (cantidad == '') {
            alert('Cantidad es un dato necesario.');
            return false;
        }
        if (sueldo == '') {
            alert('Sueldo es un dato necesario.');
            return false;
        }
        // __doPostBack('agregap', '1')
    }

    if (val == 1) {
        pue = document.getElementById('ddlpue').value
        cve = document.getElementById('txtclaveuni').value
        fre = document.getElementById('ddlfrecuencia').value
        cant = document.getElementById('txtcantidaduni').value
        costo = document.getElementById('txtcostouni').value

        if (pue == '0') {
            alert('El puesto es un dato necesario.');
            return false;
        }
        if (cve == '') {
            alert('La Clave del articulo es un dato necesario.');
            return false;
        }
        if (fre == '0') {
            alert('La frecuencia es un dato necesario.');
            return false;
        }
        if (cant == '') {
            alert('La Cantidad es un dato necesario.');
            return false;
        }
        if (costo == '') {
            alert('El costo es un dato necesario.');
            return false;
        }

    }

    if (val == 2) {
        cve = document.getElementById('txtclavemat').value
        fre = document.getElementById('ddlfrecuenciamat').value
        cant = document.getElementById('txtcantidadmat').value
        costo = document.getElementById('txtcostomat').value

        if (cve == '') {
            alert('La Clave del articulo es un dato necesario.');
            return false;
        }
        if (fre == '0') {
            alert('La frecuencia es un dato necesario.');
            return false;
        }
        if (cant == '') {
            alert('La Cantidad es un dato necesario.');
            return false;
        }
        if (costo == '') {
            alert('El costo es un dato necesario.');
            return false;
        }
    }

    if (val == 3) {
        cve = document.getElementById('txtclaveher').value
        cant = document.getElementById('txtcantidadher').value
        costo = document.getElementById('txtcostoher').value

        if (cve == '') {
            alert('La Clave del articulo es un dato necesario.');
            return false;
        }
        if (cant == '') {
            alert('La Cantidad es un dato necesario.');
            return false;
        }
        if (costo == '') {
            alert('El costo es un dato necesario.');
            return false;
        }
    }
    if (val == 4) {
        cve = document.getElementById('txtclaveeqp').value
        cant = document.getElementById('txtcantidadeqp').value
        costo = document.getElementById('txtcostoeqp').value

        if (cve == '') {
            alert('La Clave del articulo es un dato necesario.');
            return false;
        }
        if (cant == '') {
            alert('La Cantidad es un dato necesario.');
            return false;
        }
        if (costo == '') {
            alert('El costo es un dato necesario.');
            return false;
        }
    }
    if (val == 5) {
        cve = document.getElementById('txtclavesa').value
        cant = document.getElementById('txtcantidadsa').value
        costo = document.getElementById('txtcostosa').value

        if (cve == '') {
            alert('La Clave del articulo es un dato necesario.');
            return false;
        }
        if (cant == '') {
            alert('La Cantidad es un dato necesario.');
            return false;
        }
        if (costo == '') {
            alert('El costo es un dato necesario.');
            return false;
        }
    }
    if (val == 6) {
        txtnsuc = document.getElementById('txtnsuc').value
        txtsuc = document.getElementById('txtsuc').value
        txtcvei = document.getElementById('txtcvei').value
        txtcalle = document.getElementById('txtcalle').value
        txtcol = document.getElementById('txtcol').value
        txtcp = document.getElementById('txtcp').value
        txtdel = document.getElementById('txtdel').value
        txtcd = document.getElementById('txtcd').value
        txtcon = document.getElementById('txtcon').value
        TextBox1 = document.getElementById('TextBox1').value
        TextBox2 = document.getElementById('TextBox2').value


        if (txtnsuc == '') {
            alert('El Dato No de Sucursal es obligatorio.');
            return false; 
         }
        if (txtsuc == '') { alert('El Dato Sucursal es obligatorio.'); return false; }
        if (txtcvei == '') { alert('El Dato Cve Interna es obligatorio.'); return false; }
        if (txtcalle == '') { alert('El Dato Calle es obligatorio.'); return false; }
        if (txtcol == '') { alert('El Dato Colonia es obligatorio.'); return false; }
        if (txtcp == '') { alert('El Dato CP es obligatorio.'); return false; }
        if (txtdel == '') { alert('El Dato Delegacion es obligatorio.'); return false; }
        if (txtcd == '') { alert('El Dato Ciudad es obligatorio.'); return false; }
        if (txtcon == '') { alert('El Dato Contacto es obligatorio.'); return false; }
        if (TextBox1 == '') { alert('El Dato Mail es obligatorio.'); return false; }
        if (TextBox2 == '') { alert('El Dato Telefono es obligatorio.'); return false; }

    }
}
</script>
<script type="text/javascript">
    function separa(val) {
    if (val == 1) {
        cve= document.getElementById('txtclaveuni').value
        var res = cve.split("|");
        document.getElementById('txtclaveuni').value = res[0]
        document.getElementById('txtdescuni').value = res[1]
        document.getElementById('txtcostouni').value = res[2]        
    }
    if (val == 2) {
        cve = document.getElementById('txtclavemat').value
        var res = cve.split("|");
        document.getElementById('txtclavemat').value = res[0]
        document.getElementById('txtdescmat').value = res[1]
        document.getElementById('txtcostomat').value = res[2]
    }
    if (val == 3) {
        cve = document.getElementById('txtclaveher').value
        var res = cve.split("|");
        document.getElementById('txtclaveher').value = res[0]
        document.getElementById('txtdescher').value = res[1]
        document.getElementById('txtcostoher').value = res[2]
    }
    if (val == 4) {
        cve = document.getElementById('txtclaveeqp').value
        var res = cve.split("|");
        document.getElementById('txtclaveeqp').value = res[0]
        document.getElementById('txtdesceqp').value = res[1]
        document.getElementById('txtcostoeqp').value = res[2]
    }
    if (val == 5) {
        cve = document.getElementById('txtclavesa').value
        var res = cve.split("|");
        document.getElementById('txtclavesa').value = res[0]
        document.getElementById('txtdescsa').value = res[1]
        document.getElementById('txtcostosa').value = res[2]
    }
}
</script>
<script type="text/javascript">
    function calculacosto(val) {
    if (val == 1) {
        dcantidad = 0;
        if ($('#txtcantidaduni').val() == '') {
        } else {
            dcantidad = $('#txtcantidaduni').val()
        }
        dcosto = 0;
        if ($('#txtcostouni').val() == '') {
        } else {
            dcosto = $('#txtcostouni').val()
        }
        document.getElementById('txtimporteuni').value = dcantidad * dcosto
    }

    if (val ==2 ) {
        dcantidad = 0;
        if ($('#txtcantidadmat').val() == '') {
        } else {
            dcantidad = $('#txtcantidadmat').val()
        }
        dcosto = 0;
        if ($('#txtcostomat').val() == '') {
        } else {
            dcosto = $('#txtcostomat').val()
        }
        document.getElementById('txtimportemat').value = dcantidad * dcosto
    }
    if (val == 3) {
        dcantidad = 0;
        if ($('#txtcantidadher').val() == '') {
        } else {
            dcantidad = $('#txtcantidadher').val()
        }
        dcosto = 0;
        if ($('#txtcostoher').val() == '') {
        } else {
            dcosto = $('#txtcostoher').val()
        }
        document.getElementById('txtimporteher').value = dcantidad * dcosto
    }
    if (val == 4) {
        dcantidad = 0;
        if ($('#txtcantidadeqp').val() == '') {
        } else {
            dcantidad = $('#txtcantidadeqp').val()
        }
        dcosto = 0;
        if ($('#txtcostoeqp').val() == '') {
        } else {
            dcosto = $('#txtcostoeqp').val()
        }
        document.getElementById('txtimporteeqp').value = dcantidad * dcosto
    }
    if (val == 5) {
        dcantidad = 0;
        if ($('#txtcantidadsa').val() == '') {
        } else {
            dcantidad = $('#txtcantidadsa').val()
        }
        dcosto = 0;
        if ($('#txtcostosa').val() == '') {
        } else {
            dcosto = $('#txtcostosa').val()
        }
        document.getElementById('txtimportesa').value = dcantidad * dcosto
    }
}
 </script>



</head>

  <body class="skin-blue sidebar-mini">
    <form id="form1" runat="server">
    <div class="wrapper">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <div class="main-header">
        <!-- Logo -->
        <a href="../Home.aspx" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>S</b>GA</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>SIN</b>GA</span>
        </a>
        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
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
                  <span class="hidden-xs"><%= labeluser%></span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </div>
      <!-- Left side column. contains the logo and sidebar -->
      <div class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <div class="sidebar">
          <!-- sidebar menu: : style can be found in sidebar.less -->
            <%= labelmenu%>
        </div>
        <!-- /.sidebar -->
      </div>

      <!-- Content Wrapper. Contains page content -->
      <!--<div class="content-wrapper">-->
        <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
          <h1>
              Ventas
            <small>Cotizador</small>
          </h1>
          <ol class="breadcrumb">
            <li><a href="../Home.aspx"><i class="fa fa-dashboard"></i> Home</a></li>
            <li><a>Ventas</a></li>
            <li class="active">Cotizador</li>
          </ol>
        </div>

        <!-- Main content -->
        <div class="content" >
          <div class="row" id="df">
            <div class="col-md-11">
              <div class="box box-info" id="paso1">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <small>PASO 1: Seleccione al tipo de cotizacion a realizar, despues capture la razon social para buscar los datos.(Si esta cotizando a un prospecto capture los datos solicitados)...                                                           
                        </small>
                    </h3>
                </div><!-- /.box-header -->
                <table class="box-body" id="Table1" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:90%; height:80%">
                    <tr>
                        <td align="right">
                            <asp:CheckBox ID="chkcliente" runat="server" Text="Cliente" onclick="muestra(0);"></asp:CheckBox>
                        </td>
                        <td align="right">
                            <asp:CheckBox ID="chkprospecto" runat="server" Text="Prospecto" onclick="muestra(1);"></asp:CheckBox>
                        </td>
                        <td align="right">
                            <asp:CheckBox ID="chknuevo" runat="server" Text="Nuevo Prospecto" onclick="muestra(2);"></asp:CheckBox>
                        </td>
                        <td align="right" id="lrs" style="display:none;">
                            Razon Social:</td>
                        <td align ="left">
                            <asp:TextBox ID="txtrsc" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" style="display:none;"></asp:TextBox>
                            <asp:TextBox ID="txtrsp" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" style="display:none;"></asp:TextBox>
                            <asp:TextBox ID="txtrs" class="form-control" placeholder="Ejemplo... Batia S.A. de C.V." runat="server" style="display:none;"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoComplete1" runat="server" CompletionInterval="100"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qrycliente" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsc"  >
                            </ajaxToolkit:AutoCompleteExtender>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" CompletionInterval="100"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryprospecto" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtrsp"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                    <td align="right" id="lts" style="display:none;">
                        Tipos de Servicios:</td>
                    <td id="lddlts" style="display:none;">
                        <asp:DropDownList ID="ddltservicio"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione</asp:ListItem>
                            <asp:ListItem Value="1">Mantenimiento</asp:ListItem>
                            <asp:ListItem Value="2">Limpieza</asp:ListItem>
                            <asp:ListItem Value="3">Jardineria</asp:ListItem>
                            <asp:ListItem Value="4">Fumigacion</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    </tr>
                </table>
                <table class="box-body" id="nuevop" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none;" >
                    <tr>
                        <td align="right">
                            Contacto:</td>
                        <td align ="left">
                            <asp:TextBox ID="txtcontacto" class="form-control" placeholder="Juan Romero" runat="server"></asp:TextBox>
                        </td>
                        <td align="right">
                            Telefono:</td>
                        <td align ="left">
                            <asp:TextBox ID="txttel" class="form-control" placeholder="(55)50-00-00-00" runat="server"></asp:TextBox>
                        </td>
                        <td align="right">
                            EMail:</td>
                        <td align ="left">
                            <asp:TextBox ID="txtmail" class="form-control" placeholder="info@batia.com.mx" runat="server"></asp:TextBox>
                        </td>
                        <td align="right">
                            Ejecutivo:</td>
                        <td align ="left">
                            <asp:DropDownList ID="ddlejecutivo" class="form-control" runat="server" placeholder="Barbara Villafan">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div class="box-header with-border">
                    <ol class="breadcrumb">
                        <li onclick="return continuar(1);"><a ><i class="fa fa-dashboard"></i> Continuar</a></li>
                    </ol>
              </div><!-- /.box-header -->
              </div><!-- /.box-body -->

              <div class="box box-info" id="paso2" style="display:none;">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        <%= lblcteinfo%>
                    </h3>
                </div>
                <div id="divp2" class="box-header with-border">
                    <h3 class="box-title">
                        <small>PASO 2 : Seleccione los opcion a capturar.
                        </small>
                    </h3>
                </div><!-- /.box-header -->

                <!--inmuebles-->

            <asp:UpdatePanel ID="UpdatePanel8" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="dirdat" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; " >
                    <tr>
                        <td colspan="2">
                            <div class="box-header with-border">
                                <h3 class="box-title">Inmuebles :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                        <td colspan="4">
                            <div>
                            <ol class="breadcrumb">
                            <li onclick="return cargadat(1);"><a ><i class="fa fa-dashboard"></i> Exportar</a></li>
                            <li onclick="return cargadat(2);"><a ><i class="fa fa-dashboard"></i> Importar</a></li>
                            <li onclick="return cargadat(3);"><a ><i class="fa fa-dashboard"></i> Manual</a></li>
                            </ol>
                            </div>
                        </td>
                    </tr>
                <tr id="cargadir" style="display:none;">
                    <td>
                        <asp:FileUpload ID="cargaarch" runat="server" class="form-control" Width="80%" />
                    </td>
                    <td align ="center">
                        <asp:Button ID="Button4" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return cargadat(4);"></asp:Button>
                    </td>
                </tr>
                <tr id="detdir1" style="display:none;">
                    <td align="right">
                        No Sucursal:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtnsuc" class="form-control" placeholder="Cve Cte" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Sucursal:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtsuc" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Clave Interna:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcvei" class="form-control"  placeholder="Cve Interna" runat="server"></asp:TextBox>
                    </td>
                    <td align="left" >
                    </td>                      
                </tr>
                <tr id="detdir2" style="display:none;">
                    <td align="right">
                        Calle y No:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcalle" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Colonia:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcol" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        C.P.:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcp" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="left" >
                    </td>
                </tr>
                <tr id="detdir3" style="display:none;">
                    <td align="right">
                        Delegacion/Mun:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtdel" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Ciudad:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcd" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Estado:</td>
                    <td align="left" >
                        <asp:DropDownList ID="ddlestado"  runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">Seleccione…</asp:ListItem>
                            <asp:ListItem Value="1">Aguascalientes</asp:ListItem>
                            <asp:ListItem Value="2">Baja California</asp:ListItem>
                            <asp:ListItem Value="3">Baja California Sur</asp:ListItem>
                            <asp:ListItem Value="4">Campeche</asp:ListItem>
                            <asp:ListItem Value="5">Chiapas</asp:ListItem>
                            <asp:ListItem Value="6">Chihuahua</asp:ListItem>
                            <asp:ListItem Value="7">Coahuila</asp:ListItem>
                            <asp:ListItem Value="8">Colima</asp:ListItem>
                            <asp:ListItem Value="9">Distrito Federal</asp:ListItem>
                            <asp:ListItem Value="10">Durango</asp:ListItem>
                            <asp:ListItem Value="11">Estado de México</asp:ListItem>
                            <asp:ListItem Value="12">Guanajuato</asp:ListItem>
                            <asp:ListItem Value="13">Guerrero</asp:ListItem>
                            <asp:ListItem Value="14">Hidalgo</asp:ListItem>
                            <asp:ListItem Value="15">Jalisco</asp:ListItem>
                            <asp:ListItem Value="16">Michoacán</asp:ListItem>
                            <asp:ListItem Value="17">Morelos</asp:ListItem>
                            <asp:ListItem Value="18">Nayarit</asp:ListItem>
                            <asp:ListItem Value="19">Nuevo León</asp:ListItem>
                            <asp:ListItem Value="20">Oaxaca</asp:ListItem>
                            <asp:ListItem Value="21">Puebla</asp:ListItem>
                            <asp:ListItem Value="22">Querétaro</asp:ListItem>
                            <asp:ListItem Value="23">Quintana Roo</asp:ListItem>
                            <asp:ListItem Value="24">San Luis Potosí</asp:ListItem>
                            <asp:ListItem Value="25">Sinaloa</asp:ListItem>
                            <asp:ListItem Value="26">Sonora</asp:ListItem>
                            <asp:ListItem Value="27">Tabasco</asp:ListItem>
                            <asp:ListItem Value="28">Tamaulipas</asp:ListItem>
                            <asp:ListItem Value="29">Tlaxcala</asp:ListItem>
                            <asp:ListItem Value="30">Veracruz</asp:ListItem>
                            <asp:ListItem Value="31">Yucatán</asp:ListItem>
                            <asp:ListItem Value="32">Zacatecas</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr id="detdir4" style="display:none;">
                    <td align="right">
                        Contacto:</td>
                    <td align="left" >
                        <asp:TextBox ID="txtcon" class="form-control" runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Mail:</td>
                    <td align="left" >
                        <asp:TextBox ID="TextBox1" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align="right">
                        Telefono:</td>
                    <td align="left" >
                        <asp:TextBox ID="TextBox2" class="form-control"  runat="server"></asp:TextBox>
                    </td>
                    <td align ="center">
                        <asp:Button ID="Button3" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(6);"></asp:Button>
                    </td>
                </tr>
                </table>
                <small>
                <asp:GridView ID="gwdirdat" runat="server" 
                      DataKeyNames="fila" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; " >
                    <Columns>
                        <asp:BoundField DataField="Estado" HeaderText="Estado" SortExpression="Estado" />
                        <asp:BoundField DataField="No_Sucursal" HeaderText="No Suc" SortExpression="No_Sucursal" />
                        <asp:BoundField DataField="Sucursal" HeaderText="Sucursal" SortExpression="Sucursal" />
                        <asp:BoundField DataField="Cve_Interna" HeaderText="CveInt" SortExpression="Cve_Interna" />
                        <asp:BoundField DataField="Calle" HeaderText="Calle" SortExpression="Calle" />
                        <asp:BoundField DataField="Colonia" HeaderText="Colonia" SortExpression="Colonia" />
                        <asp:BoundField DataField="CP" HeaderText="CP" SortExpression="CP" />
                        <asp:BoundField DataField="Delegacion" HeaderText="Delegacion" SortExpression="Delegacion" />
                        <asp:BoundField DataField="Ciudad" HeaderText="Ciudad" SortExpression="Ciudad" />
                        <asp:BoundField DataField="Contacto" HeaderText="Contacto" SortExpression="Contacto" />
                        <asp:BoundField DataField="Mail" HeaderText="Mail" SortExpression="Mail" />
                        <asp:BoundField DataField="Telefono" HeaderText="Telefono" SortExpression="Telefono" />

                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>


<!--termina inmuebles-->


            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="Personal" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; " >
                    <tr>
                        <td colspan="3">
                            <div class="box-header with-border">
                                <h3 class="box-title">Personal :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>

                        <td colspan="4">
                            <div>
                            <ol class="breadcrumb">
                            <li onclick="return cargaper(1);"><a ><i class="fa fa-dashboard"></i> Exportar</a></li>
                            <li onclick="return cargaper(2);"><a ><i class="fa fa-dashboard"></i> Importar</a></li>
                            <li onclick="return cargaper(3);"><a ><i class="fa fa-dashboard"></i> Manual</a></li>
                            </ol>
                            </div>
                        </td>

                    </tr>
                <tr id="cargaper" style="display:none;">
                    <td>
                        <asp:FileUpload ID="FileUpload1" runat="server" class="form-control" Width="80%" />
                    </td>
                    <td align ="center">
                        <asp:Button ID="Button5" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return cargaper(4);"></asp:Button>
                    </td>
                </tr>
                    <tr id="detper1" style="display:none;">
                        <td align="center">
                            <small>Sucursal:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Puesto:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align ="center">
                            <small>Turno:</small>                            
                        </td>
                        <td align="center">
                            <small>Jornal:</small>                            
                        </td>
                        <td align ="center">
                            <small>Sueldo:</small>                                                        
                        </td>
                        <td align="center">
                            <small>Costo:</small>                                                        
                        </td>
                    </tr>
                    <tr id="detper2" style="display:none;">
                        <td align ="center">
                            <asp:DropDownList ID="ddlinm" class="form-control" runat="server" >
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:DropDownList ID="ddlpuesto" class="form-control" runat="server" onfocus="calculacostop();">
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidad" class="form-control"  runat="server" onfocus="calculacostop();"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:DropDownList ID="ddlturno" class="form-control" runat="server" onfocus="calculacostop();">
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:DropDownList ID="ddljornal" class="form-control" runat="server" onfocus="calculacostop();">
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtsueldo" Enabled="false" class="form-control"  runat="server" onfocus="calculacostop();"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcosto" Enabled="false" runat="server" class="form-control" onfocus="calculacostop();"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostot" Enabled="false" class="form-control"  runat="server"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="Button1" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(0);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwp" runat="server" 
                      DataKeyNames="fila,Id_edo,idpuesto,idpuestodet,idturno,idjornal" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; " >
                    <Columns>
                        <asp:BoundField DataField="Estado" HeaderText="Sucursal" SortExpression="Estado" />
                        <asp:BoundField DataField="Puesto" HeaderText="Puesto" SortExpression="Puesto" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="Turno" HeaderText="Turno" SortExpression="Turno" />
                        <asp:BoundField DataField="Jornal" HeaderText="Jornal" SortExpression="Jornal" />
                        <asp:BoundField DataField="Sueldo" HeaderText="Sueldo" SortExpression="Sueldo" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Costot" HeaderText="Costo Total" SortExpression="Costot" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>

            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="uni" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; " >
                    <tr>
                        <td colspan="3">
                            <div class="box-header with-border">
                                <h3 class="box-title">Uniformes :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>

                        <td colspan="4">
                            <div>
                            <ol class="breadcrumb">
                            <li onclick="return cargaper(5);"><a ><i class="fa fa-dashboard"></i> Exportar</a></li>
                            <li onclick="return cargaper(6);"><a ><i class="fa fa-dashboard"></i> Importar</a></li>
                            <li onclick="return cargaper(7);"><a ><i class="fa fa-dashboard"></i> Manual</a></li>
                            </ol>
                            </div>
                        </td>

                    </tr>
                    <tr id="cargaunif" style="display:none;">
                        <td>
                            <asp:FileUpload ID="FileUpload2" runat="server" class="form-control" Width="80%" />
                        </td>
                        <td align ="center">
                           <asp:Button ID="Button6" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return cargaper(8);"></asp:Button>
                        </td>
                    </tr>
                    <tr id="detuni1" style="display:none;">
                        <td align="center">
                            <small>Puesto:</small>
                        </td>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align ="center">
                            <small>Frecuencia:</small>                            
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align ="center">
                            <small>Importe:</small>                                                        
                        </td>

                    </tr>
                    <tr id="detuni2" style="display:none;">
                        <td align ="center">
                            <asp:DropDownList ID="ddlpue" class="form-control" runat="server" >
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtclaveuni" class="form-control"  runat="server" onblur="separa(1);"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender2" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryuniforme" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclaveuni"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdescuni" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidaduni" class="form-control"  runat="server" onblur="calculacosto(1);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:DropDownList ID="ddlfrecuencia" class="form-control" runat="server" onblur="calculacosto(1);">
                                <asp:ListItem Value="0">Seleccione</asp:ListItem>
                                <asp:ListItem Value="1">Mensual</asp:ListItem>
                                <asp:ListItem Value="3">Trimestral</asp:ListItem>
                                <asp:ListItem Value="6">Semestral</asp:ListItem>
                                <asp:ListItem Value="12">Anual</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostouni" class="form-control"  runat="server" onblur="calculacosto(1);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtimporteuni" class="form-control"  runat="server" onblur="calculacosto(1);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btnuni" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(1);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gvuhem" runat="server" 
                      DataKeyNames="fila,idfrecuencia,tipo" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="iddesc" HeaderText="Puesto" SortExpression="iddesc" />
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Descripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="frecuencia" HeaderText="frecuencia" SortExpression="frecuencia" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>

            <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="Material" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; ">
                    <tr>
                        <td colspan="3">
                            <div class="box-header with-border">
                                <h3 class="box-title">Materiales :
                                    <small> Capture los datos solicitados.</small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                        <td colspan="4">
                            <div>
                            <ol class="breadcrumb">
                            <li onclick="return cargaper(9);"><a ><i class="fa fa-dashboard"></i> Exportar</a></li>
                            <li onclick="return cargaper(10);"><a ><i class="fa fa-dashboard"></i> Importar</a></li>
                            <li onclick="return cargaper(11);"><a ><i class="fa fa-dashboard"></i> Manual</a></li>
                            </ol>
                            </div>
                        </td>
                    </tr>
                    <tr id="cargamat" style="display:none;">
                        <td>
                            <asp:FileUpload ID="FileUpload3" runat="server" class="form-control" Width="80%" />
                        </td>
                        <td align ="center">
                           <asp:Button ID="Button7" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return cargaper(12);"></asp:Button>
                        </td>
                    </tr>
                    <tr id="detmat1" style="display:none;">
                        <td align="center">
                            <small>Sucursal:</small>
                        </td>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align ="center">
                            <small>Frecuencia:</small>                            
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align ="center">
                            <small>Importe:</small>                                                        
                        </td>
                    </tr>
                    <tr id="detmat2" style="display:none;">
                        <td align ="center">
                            <asp:DropDownList ID="ddlregion" class="form-control" runat="server">
                            </asp:DropDownList>
                        </td>

                        <td align ="center">
                            <asp:TextBox ID="txtclavemat" class="form-control"  runat="server" onblur="separa(2);" ></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender3" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryMateriales" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclavemat"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdescmat" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidadmat" class="form-control"  runat="server" onblur="calculacosto(2);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:DropDownList ID="ddlfrecuenciamat" class="form-control" runat="server" onblur="calculacosto(2);">
                                <asp:ListItem Value="0">Seleccione</asp:ListItem>
                                <asp:ListItem Value="1">Mensual</asp:ListItem>
                                <asp:ListItem Value="3">Trimestral</asp:ListItem>
                                <asp:ListItem Value="6">Semestral</asp:ListItem>
                                <asp:ListItem Value="12">Anual</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostomat" class="form-control"  runat="server" onblur="calculacosto(2);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtimportemat" class="form-control"  runat="server" onblur="calculacosto(2);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btnmat" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(2);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwm" runat="server" 
                      DataKeyNames="fila,idfrecuencia,tipo" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="frecuencia" HeaderText="frecuencia" SortExpression="frecuencia" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>

                    </ContentTemplate>
                </asp:UpdatePanel>

            <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="Herramienta" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; ">
                    <tr>
                        <td colspan="6">
                            <div class="box-header with-border">
                                <h3 class="box-title">Herramienta :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align="center">
                            <small>Amortizacion(Meses):</small>
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align ="center">
                            <small>Importe:</small>                                                        
                        </td>
                    </tr>
                    <tr>
                        <td align ="center">
                            <asp:TextBox ID="txtclaveher" class="form-control"  runat="server" onblur="separa(3);"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender4" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryHerramienta" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclaveher"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdescher" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidadher" class="form-control"  runat="server" onblur="calculacosto(3);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtamorher" class="form-control"  runat="server" onblur="calculacosto(3);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostoher" class="form-control"  runat="server" onblur="calculacosto(3);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtimporteher" class="form-control"  runat="server" onblur="calculacosto(3);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btnher" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(3);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwh" runat="server" 
                      DataKeyNames="fila,tipo" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="frecuencia" HeaderText="Amortizacion" SortExpression="frecuencia" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>

            <asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="Equipo" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; ">
                    <tr>
                        <td colspan="6">
                            <div class="box-header with-border">
                                <h3 class="box-title">Equipo :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align="center">
                            <small>Amortizacion(Meses):</small>                            
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align ="center">
                            <small>Importe:</small>                                                        
                        </td>
                    </tr>
                    <tr>
                        <td align ="center">
                            <asp:TextBox ID="txtclaveeqp" class="form-control"  runat="server" onblur="separa(4);"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender5" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qryequipo" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclaveeqp"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdesceqp" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidadeqp" class="form-control"  runat="server" onblur="calculacosto(4);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtamorteqp" class="form-control"  runat="server" onblur="calculacosto(4);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostoeqp" class="form-control"  runat="server" onblur="calculacosto(4);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtimporteeqp" class="form-control"  runat="server" onblur="calculacosto(4);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btneqp" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(4);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwe" runat="server" 
                      DataKeyNames="fila,tipo" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="frecuencia" HeaderText="Amortizacion" SortExpression="frecuencia" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>

            <asp:UpdatePanel ID="UpdatePanel6" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <table class="box-body" id="seradi" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:100%; height:80%; display:none; ">
                    <tr>
                        <td colspan="6">
                            <div class="box-header with-border">
                                <h3 class="box-title">Servicios Adicionales :
                                    <small> Capture los datos solicitados.
                                    </small>
                                </h3>
                            </div><!-- /.box-header -->
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <small>Clave:</small>
                        </td>
                        <td align ="center">
                            <small>
                                Descripcion:
                            </small>
                        </td>
                        <td align="center">
                            <small>Cantidad:</small>
                        </td>
                        <td align="center">
                            <small>Costo:</small>                            
                        </td>
                        <td align ="center">
                            <small>Importe:</small>                                                        
                        </td>
                    </tr>
                    <tr>
                        <td align ="center">
                            <asp:TextBox ID="txtclavesa" class="form-control"  runat="server" onblur="separa(5);"></asp:TextBox>
                            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender6" runat="server" CompletionInterval="1000"
                                CompletionSetCount="12" EnableCaching="true" Enabled="True" MinimumPrefixLength="1"
                                ServiceMethod="qrySAdi" ServicePath="~/Objet/Cotiza.asmx" TargetControlID="txtclavesa"  >
                            </ajaxToolkit:AutoCompleteExtender>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtdescsa" class="form-control" Enabled="false" runat="server" Width="100%" ></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcantidadsa" class="form-control"  runat="server" onblur="calculacosto(5);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtcostosa" class="form-control"  runat="server" onblur="calculacosto(5);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:TextBox ID="txtimportesa" class="form-control"  runat="server" onblur="calculacosto(5);"></asp:TextBox>
                        </td>
                        <td align ="center">
                            <asp:Button ID="btnsa" runat="server" Text="+" class="btn btn-info pull-right" OnClientClick="return agrega(5);"></asp:Button>
                        </td>
                    </tr>
                </table>
                <small>
                <asp:GridView ID="gwsa" runat="server" 
                      DataKeyNames="fila,tipo" 
                      AutoGenerateColumns="False" Width="100%" style="display:none; ">
                    <Columns>
                        <asp:BoundField DataField="cve" HeaderText="Clave " SortExpression="cve" />
                        <asp:BoundField DataField="cvedesp" HeaderText="Desccripcion" SortExpression="cvedesp" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="Costo" HeaderText="Costo" SortExpression="Costo" />
                        <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" />
                        <asp:CommandField ButtonType="Button" SelectText="-" ShowSelectButton="True" >
                        </asp:CommandField>
                    </Columns>
                  </asp:GridView>
                </small>
                    </ContentTemplate>
                </asp:UpdatePanel>


                <div class="box-header with-border" >
                    <ol class="breadcrumb">
                        <li onclick="continuar(0);"><a ><i class="fa fa-dashboard"></i> Atras</a></li>
                        <li onclick="continuar(9);"><a ><i class="fa fa-dashboard"></i> Inmuebles</a></li>
                        <li onclick="continuar(2);"><a ><i class="fa fa-dashboard"></i> Personal</a></li>
                        <li onclick="continuar(3);"><a ><i class="fa fa-dashboard"></i> Uniformes</a></li>
                        <li onclick="continuar(4);"><a ><i class="fa fa-dashboard"></i> Materiales</a></li>
                        <li onclick="continuar(5);"><a ><i class="fa fa-dashboard"></i> Herramienta</a></li>
                        <li onclick="continuar(6);"><a ><i class="fa fa-dashboard"></i> Equipo</a></li>
                        <li onclick="continuar(7);"><a ><i class="fa fa-dashboard"></i> Servicios Adicionales</a></li>                     
                        <!-- /<li onclick="llenacot(1);"><a ><i class="fa fa-dashboard"></i> Ver Propuesta</a></li>   -->
                        <li onclick="continuar(8);"><a ><i class="fa fa-dashboard"></i>Ver Propuesta</a></li> 
                    </ol>
              </div><!-- /.box-header -->


            <asp:UpdatePanel ID="UpdatePanel7" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>   
                <small>
                <div id="dvp1" title="Propuesta" align="center" style="display: none">
                    <div class="box-header with-border">
                        <h3 class="box-title">Propuesta Economica:COT-
                           <asp:Label ID="lblfolio" runat="server" Text=""></asp:Label>
                           <asp:Label ID="lblversion" runat="server" Text="-V-"></asp:Label>
                           <asp:Label ID="lblver" runat="server" Text=""></asp:Label>
                           <asp:Label ID="lblid" runat="server" Text="" style="display: none"></asp:Label>
                           <asp:Label ID="lbltipo" runat="server" Text="" style="display: none"></asp:Label>
                           <asp:Label ID="lblidcot" runat="server" Text="" style="display: none"></asp:Label>
                        </h3>
                    </div><!-- /.box-header -->

                    <asp:GridView ID="gwpropuesta"  AutoGenerateColumns="False" DataKeyNames="fila,tipo" runat="server" Width="50%" 
                    EmptyDataText="No hay parametros cargados para configurar la propuesta" 
                    BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" 
                    CellPadding="4" GridLines="Horizontal" >
                    <Columns>
                        <asp:BoundField DataField="Concepto" HeaderText="Concepto " SortExpression="Concepto" />
                        <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" SortExpression="Cantidad" />
                        <asp:BoundField DataField="PrecioMensual" HeaderText="PrecioMensual" SortExpression="PrecioMensual" DataFormatString="{0:C3}" >
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="PrecioAnual" HeaderText="PrecioAnual" SortExpression="PrecioAnual" DataFormatString="{0:C}" >
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                    </Columns>
                        <FooterStyle BackColor="White" ForeColor="#333333" />
                        <HeaderStyle BackColor="#C4D79B" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="White" ForeColor="#333333" />
                        <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#F7F7F7" />
                        <SortedAscendingHeaderStyle BackColor="#487575" />
                        <SortedDescendingCellStyle BackColor="#E5E5E5" />
                        <SortedDescendingHeaderStyle BackColor="#275353" />
                    </asp:GridView>

                </div>           
                </small>
                <small>
                <div id="dvp2" title="Propuesta" align="center" style="display: none">

                <table class="box-body" id="tblpg" runat="server" border="0" cellpadding="0" cellspacing="0" 
                    style="border-collapse: collapse; width:50%; height:80%;">
                    <tr>
                        <td>
                        .
                        </td>
                    </tr>
                    <tr style="border: 3px double #336633; font-weight: bold; background-color: #C4D79B">
                        <td align="right" Width="25%">
                            ...                            
                        </td>
                        <td align="right" Width="25%">
                            Subtotal
                        </td>
                        <td align="right">
                           <asp:Label ID="lblsubtotal" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                           <asp:Label ID="lblsubtotalanual" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>   
                    </tr>

                    <tr>
                        <td align="right" Width="25%">
                            Indirecto:                            
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtpind" Width="50%" placeholder="%" runat="server" Text="0" 
                                Style="text-align:right" BackColor="#C4D79B" Enabled="False"></asp:TextBox>
                        </td>
                        <td align="right">
                           <asp:Label ID="lblpind" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                           <asp:Label ID="lblpindanual" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>   
                    </tr>

                    <tr>
                        <td align="right" Width="25%">
                        </td>
                        <td align="right" style="font-weight: bold" >
                            Subtotal
                        </td>
                        <td align="right" 
                            style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;">
                           <asp:Label ID="lblsubtotalind" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right" style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;" >
                           <asp:Label ID="lblsubtotalinda" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>   
                    </tr>

                    <tr>
                        <td align="right" Width="25%">
                            Utilidad:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtutil" Width="50%" placeholder="%" runat="server" Text="0" 
                                Style="text-align:right" AutoPostBack="True" BackColor="#C4D79B" Enabled="False"></asp:TextBox>                      
                        </td>
                        <td align="right">
                           <asp:Label ID="lblutil" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                           <asp:Label ID="lblutila" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>
                    </tr>

                    <tr>
                        <td align="right" Width="25%">                         
                        </td>
                        <td align="right" Width="25%" style="font-weight: bold" >
                            Subtotal
                        </td>
                        <td align="right" style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;">
                           <asp:Label ID="lblsubutil" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right" style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;">
                           <asp:Label ID="lblsubutila" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>   
                    </tr>

                    <tr>
                        <td align="right" Width="25%">
                            Comercializacion:
                        </td>
                        <td align="right" Width="25%">
                            <asp:TextBox ID="txtcomer" Width="50%" placeholder="%" runat="server" Text="0" 
                                Style="text-align:right" AutoPostBack="True"  BackColor="#C4D79B" Enabled="False"></asp:TextBox>                       
                        </td>
                        <td align="right">
                           <asp:Label ID="lblcomer" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                           <asp:Label ID="lblcomera" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>
                    </tr>


                   <tr>
                        <td align="right" Width="25%">                          
                        </td>
                        <td align="right" Width="25%" style="font-weight: bold" >
                            Subtotal
                        </td>
                        <td align="right" style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;">
                           <asp:Label ID="lblsubcomer" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right" style="border-width: 3px; border-color: #336633; background-color: #C4D79B; font-weight: bold; border-top-style: double;">
                           <asp:Label ID="lblsubcomera" runat="server" Text=""></asp:Label>
                        </td>
                        <td align="right">
                        </td>   
                    </tr>

                </table>
                  <div class="box-footer">
                      <asp:Button ID="Button2" runat="server" Text="Guardar" class="btn btn-info pull-right" />
                  </div><!-- /.box-footer -->
                </div>
                </small>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btneqp" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnher" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnmat" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnsa" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnuni" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="Button1" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="Button4" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="gvuhem" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gwe" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gwh" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gwm" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gwp" EventName="SelectedIndexChanged" />
                        <asp:AsyncPostBackTrigger ControlID="gwsa" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
              </div><!-- /.box-body -->




            </div><!--/.col (right) -->
        </div>   
        </div><!-- /.content -->



      </div><!-- /.content-wrapper -->
      <div class="main-footer">
        <div class="pull-right hidden-xs">
          <b>Version</b> 2015-01
        </div>
        <strong>Copyright &copy; 2015.</strong> All rights reserved.
      </div>

      <!-- Control Sidebar -->
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
