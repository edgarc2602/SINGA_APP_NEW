<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ven_Cat_Cliente_Gastofin.aspx.vb" Inherits="Ventas_App_Ven_Cat_Cliente_Gastofin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>GASTOS FINANCIEROS</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta charset="utf-8" />
    <link href="../Content/form/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../Content/form/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <link rel="stylesheet" href="../Content/css/General.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../Content/css/proyectos/Generalftp.css" type="text/css" media="screen" />
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="content">
            <div class="row" id="tbdatosinm">
                <div class="col-md-14">
                    <!-- Horizontal Form -->
                    <div class="box box-info">
                        <div class=" box-header with-border">
                            <h3 class="box-title">Presupuesto para Gastos financieros</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 tbheader">
                    <table class="table table-condensed">
                        <thead>
                            <tr>
                                <th class="bg-navy"><span>Importe</span></th>
                            </tr>
                            <tr>
                                <th class="col-lg-2">
                                    <input id="tximporte" class="form-control"/>
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <ol class="breadcrumb">
                        <li id="btsalir"  class="puntero" onclick="history.back();"><a ><i class="fa fa-edit" ></i>Actualizar y salir</a></li>
                    </ol>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
