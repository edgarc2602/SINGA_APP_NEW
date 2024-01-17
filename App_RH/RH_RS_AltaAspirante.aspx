<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RH_RS_AltaAspirante.aspx.vb" Inherits="RH_RS_AltaAspirante" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
    <base target="_self"/>
    <script type="text/javascript">
        function Modal()
        {
            window.showModalDialog('CT_AspirantesVia.aspx','','dialogHeight:330px; dialogWidth:700px');
        }
        function Sueldo(arg) {
            window.showModalDialog('RH_RS_AltaEmpleado1.aspx?IdEmp=' + arg, '', 'dialogHeight:490px; dialogWidth:570px');
        }
    </script>
    <style type="text/css">
        #form1
        {
            height: 465px;
            width: 667px;
        }
        .style1
        {
            font-family: tahoma;
        }
    </style>
</head>
<body style="width: 660px; height: 457px">
    <form id="form1" runat="server">
        <asp:Label ID="Label1" runat="server" Style="font-weight: 400; font-size: 10pt;
            left: 16px; font-family: tahoma; position: absolute; top: 96px" Text="Compañia"
            Width="75px"></asp:Label>
        <asp:Label ID="Label2" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 102px; font-family: tahoma; position: absolute; top: 72px; text-align: right; font-weight: 700;" 
            Width="56px"></asp:Label>
        <asp:Label ID="Label55" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 256px; font-family: tahoma; position: absolute; top: 72px; text-align: right; font-weight: 700;" 
            Width="56px">0</asp:Label>
        <asp:Label ID="Label64" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 408px; font-family: tahoma; position: absolute; top: 72px; text-align: right; font-weight: 700;" 
            Width="64px">0</asp:Label>
        <asp:Label ID="Label65" runat="server" Style="font-weight: 400; font-size: 10pt;
            left: 320px; font-family: tahoma; position: absolute; top: 72px" Text="No. Empleado"
            Width="88px"></asp:Label>
        <asp:Label ID="Label10" runat="server" 
            
            
            Style="border-style: none; font-size: 10pt; left: 284px; font-family: tahoma; position: absolute; top: 96px; text-align: left; font-weight: 700; width: 235px; height: 15px;"></asp:Label>
        <asp:Label ID="Label4" runat="server" 
            
            
            Style="border-style: none; font-size: 10pt; left: 85px; font-family: Tahoma; position: absolute; top: 96px; text-align: left; font-weight: 700; width: 127px; height: 15px; right: 869px;"></asp:Label>
        <asp:Label ID="Label12" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 580px; font-family: tahoma; position: absolute; top: 96px; text-align: left; font-weight: 700;" 
            Width="112px"></asp:Label>
        <asp:Label ID="Label3" runat="server" 
            Style="font-weight: 400; font-size: 10pt;
            left: 16px; font-family: tahoma; position: absolute; top: 72px; height: 16px; width: 70px;">No. Plantilla</asp:Label>
        <asp:Label ID="Label66" runat="server" 
            Style="font-weight: bold; font-size: 10pt;
            left: 660px; font-family: TAHOMA; position: absolute; top: 28px; height: 12px; width: 63px;" 
            Visible="False"></asp:Label>
        <asp:Label ID="Label11" runat="server" Style="font-weight: 400; font-size: 10pt;
            left: 530px; font-family: tahoma; position: absolute; top: 96px" 
            Width="40px">Turno</asp:Label>
        <asp:Label ID="Label6" runat="server" 
            
            
            Style="border-style: none; font-size: 10pt; left: 534px; font-family: tahoma; position: absolute; top: 72px; text-align: left; width: 185px; font-weight: 700; height: 17px;"></asp:Label>
        <asp:Label ID="Label7" runat="server" Style="font-weight: 400; font-size: 10pt;
            left: 490px; font-family: tahoma; position: absolute; top: 72px" 
            Width="48px">Plaza</asp:Label>
        <asp:Label ID="Label9" runat="server" 
            
            Style="font-weight: 400; font-size: 10pt;
            left: 234px; font-family: tahoma; position: absolute; top: 96px; right: 807px;" Text="Puesto"
            Width="40px"></asp:Label>
        &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
        <asp:Label ID="Label63" runat="server" Style="font-weight: 400; font-size: 10pt;
            left: 176px; font-family: tahoma; position: absolute; top: 72px" Text="No. Aspirante"
            Width="80px"></asp:Label>
        <asp:Panel ID="Panel6" runat="server"             
            Style="border-style: none; border-color: #000666; background-color: ghostwhite; z-index: 1; left: 10px; top: 0px; position: absolute; height: 58px; width: 652px; margin-bottom: 0px;">
            <asp:Label ID="Cabecera" runat="server" BackColor="#000066" Font-Bold = "True" 
                        Text="Vacantes" ForeColor="White" 
                        Style = "text-align:center; font-family:Tahoma; font-size:11pt; top: 5px; left: 5px; height: 20px" 
                        Width="653px" Height="31px" ></asp:Label>
        <asp:ImageButton ID="ImageButton12" runat="server" Height="32px" 
            ImageUrl="~/Content/img/Comun/Buscar.png" 
            Style="left: 265px; position: absolute; top: 23px; z-index: 2;" ToolTip=" Buscar Plantilla" 
            Width="32px" TabIndex="42" />
        <asp:ImageButton ID="ImageButton13" runat="server" Height="32px" 
            ImageUrl="~/Content/img/Comun/Guardar.png" 
            Style="left: 335px; position: absolute; top: 23px; z-index: 2;" ToolTip="Guardar" 
            Width="32px" TabIndex="43" />

        <asp:ImageButton ID="ImageButton14" runat="server" Height="32px" 
            ImageUrl="~/Content/img/Comun/Salir.png" 
            Style="left: 565px; position: absolute; top: 23px; z-index: 2;" ToolTip="Salir " 
            Width="32px" TabIndex="46" />
            <asp:ImageButton ID="ImageButton6" runat="server" Height="32px" 
                ImageUrl="~/Content/img/Plantilla/persona1.png" Style="background-attachment: scroll; left: 490px; background-repeat: no-repeat;
            position: absolute; top: 23px" TabIndex="45" ToolTip="Genera Empleado" 
                Visible="False" Width="32px" />
            <asp:ImageButton ID="ImageButton7" runat="server" Height="32px" 
                ImageUrl="~/Content/img/Comun/printer-icon.png" 
                Style="background-attachment: scroll; left: 414px; background-image: url('images/Inicio.png'); background-repeat: no-repeat; position: absolute; top: 23px" 
                TabIndex="44" ToolTip="Imprimir contrato" Width="32px" />
        </asp:Panel>
        <asp:Label ID="Label70" runat="server"                                     
            
            
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 86px; text-align: left; font-weight: 700; width: 65px; height: 15px;" 
            Visible="False">Turno</asp:Label>
        <asp:Label ID="Label69" runat="server" 
            
            
            
            
            
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 126px; text-align: left; font-weight: 700; width: 65px; height: 15px;" 
            Visible="False">Puesto</asp:Label>
        <asp:ImageButton ID="ImageButton1" runat="server" Height="23px" ImageUrl="~/Content/img/Botones/Generales1A.png"
            
            Style="background-attachment: scroll; left: 10px; background-image: url('images/Inicio.png');
            background-repeat: no-repeat; position: absolute; top: 123px; right: 573px;" ToolTip="Datos"
            ValidationGroup="Aspirante" Width="104px" TabIndex="0" />
        <asp:Panel ID="Panel1" runat="server" Height="332px"
            Style="border: 1px solid cornflowerblue; left: 9px; position: absolute; top: 146px; background-color: white; z-index: 6; width: 655px;">
            <asp:Label ID="Label15" runat="server" 
                Style="font-size: 10pt;
                left: 8px; font-family: TAHOMA; position: absolute; top: 9px; height: 16px; width: 121px; font-weight: 700;" 
                Text="Apellido Paterno" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label16" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 33px; height: 17px; width: 124px;" 
                Text="Apellido Materno" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label17" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 57px" Text="Nombre(s)"
                Width="110px" ForeColor="#990000"></asp:Label>
            &nbsp;
            <asp:Label ID="Label19" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; position: absolute; top: 88px" Text="Calle"
                Width="48px" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label20" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 502px; font-family: tahoma; position: absolute; height: 20px; width: 83px; top: 88px;" 
                Text="No. Interior"></asp:Label>
            <asp:Label ID="Label21" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 356px; font-family: tahoma; position: absolute; top: 88px; height: 15px; width: 88px;" 
                Text="No. Exterior"></asp:Label>
            <asp:Label ID="Label22" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; position: absolute; top: 111px" Text="Colonia"
                Width="50px" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label23" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 356px; font-family: tahoma; position: absolute; top: 111px; width: 79px;" 
                Text="Delegación" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label24" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 356px; font-family: tahoma; position: absolute; top: 135px" Text="C.P."
                Width="48px" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label25" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; position: absolute; top: 135px; height: 14px; width: 92px;" 
                Text="Municipio" ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label26" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; position: absolute; top: 195px; height: 16px; width: 98px; color: #800000;" 
                Text="Tel. Particular"></asp:Label>
            <asp:Label ID="Label27" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 276px; font-family: tahoma; position: absolute; top: 195px; height: 12px; width: 96px;" 
                Text="Tel. Recado"></asp:Label>
            <asp:Label ID="Label28" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; position: absolute; top: 159px; width: 61px; color: #800000;" 
                Text="Estado"></asp:Label>
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <div style="z-index: 1; left: 83px; top: 159px; position: absolute; height: 19px; width: 174px">
                <asp:DropDownList ID="OboutDropDownList1" runat="server" Height="150px" TabIndex="10">
                </asp:DropDownList>
            </div>
            <asp:Label ID="Label74" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 48px; font-family: tahoma; position: absolute; top: 249px; width: 173px;" 
                Text="Fuente de Reclutamiento"></asp:Label>
            <div style="z-index: 1; left: 132px; top: 9px; position: absolute; height: 19px; width: 278px">
                <asp:TextBox ID="TextBox1" runat="server" Width="200px" 
                    style="top: 0px; left: 0px" TabIndex="1"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 450px; top: 9px; position: absolute; height: 19px; width: 180px">
                <asp:Label ID="lbnoempleado" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 16px; font-family: tahoma; color: #800000;" Text="No Empleado"></asp:Label>
                <asp:TextBox ID="txnoempleado" runat="server" Width="100px"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 132px; top: 33px; position: absolute; height: 19px; width: 278px">
                <asp:TextBox ID="TextBox2" runat="server" Width="200px" TabIndex="1"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 132px; top: 57px; position: absolute; height: 19px; width: 278px">
                <asp:TextBox ID="TextBox3" runat="server" Width="200px" TabIndex="2"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 83px; top: 87px; position: absolute; height: 19px; width: 262px">
                <asp:TextBox ID="TextBox4" runat="server" Width="250px" TabIndex="3"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 407px; top: 135px; position: absolute; height: 19px; width: 74px">
                <asp:TextBox ID="TextBox11" runat="server" Width="60px" MaxLength="5" TabIndex="9"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 587px; top: 87px; position: absolute; height: 19px; width: 74px">
                <asp:TextBox ID="TextBox6" runat="server" Width="60px" 
                    style="top: 0px; left: 0px" TabIndex="5"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 83px; top: 111px; position: absolute; height: 19px; width: 262px">
                <asp:TextBox ID="TextBox7" runat="server" Width="200px" TabIndex="6"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 432px; top: 111px; position: absolute; height: 19px; width: 207px">
                <asp:TextBox ID="TextBox9" runat="server" Width="200px" 
                    style="top: 0px; left: 0px" TabIndex="7"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 83px; top: 135px; position: absolute; height: 19px; width: 262px">
                <asp:TextBox ID="TextBox10" runat="server" Width="200px" TabIndex="8"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 437px; top: 87px; position: absolute; height: 19px; width: 74px">
                <asp:TextBox ID="TextBox35" runat="server" Width="60px" TabIndex="4"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 113px; top: 195px; position: absolute; height: 19px; width: 167px">
                <asp:TextBox ID="TextBox12" runat="server" Width="150px" TabIndex="11"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 363px; top: 195px; position: absolute; height: 19px; width: 167px">
                <asp:TextBox ID="TextBox8" runat="server" Width="150px" 
                    style="top: 0px; left: 0px" TabIndex="12"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 147px; top: 219px; position: absolute; height: 19px; width: 358px">
                <asp:TextBox ID="TextBox13" runat="server" Width="250px" TabIndex="13"></asp:TextBox>
            </div>
            <asp:Label ID="Label95" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 18px; font-family: tahoma; position: absolute; top: 219px; width: 133px;" 
                Text="Correo Electronico"></asp:Label>
            <asp:Label ID="Label96" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 48px; font-family: tahoma; position: absolute; top: 273px; width: 133px;" 
                Text="Entrevistador"></asp:Label>
            <div style="z-index: 1; left: 217px; top: 249px; position: absolute; height: 19px; width: 166px">
                <asp:TextBox ID="TextBox45" runat="server" Width="150px" TabIndex="14"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 217px; top: 273px; position: absolute; height: 19px; width: 269px">
                <asp:TextBox ID="TextBox46" runat="server" Width="250px" TabIndex="15"></asp:TextBox>
            </div>
        </asp:Panel>
        &nbsp;<asp:Label ID="Label71" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 66px; text-align: left; font-weight: 700; width: 65px; height: 15px; bottom: 426px;" 
            Visible="False">Inmueble</asp:Label>
        <asp:Label ID="Label5" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 734px; font-family: tahoma; position: absolute; top: 109px; text-align: left; font-weight: 700; width: 65px; height: 15px; bottom: 278px;" 
            Visible="False">Centrocosto</asp:Label>
        <asp:Label ID="Label8" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 185px; text-align: left; font-weight: 700; width: 65px; height: 15px; bottom: 69px;" 
            Visible="False">IdEmpMigin</asp:Label>
        <asp:ImageButton ID="ImageButton2" runat="server" Height="23px" ImageUrl="~/Content/img/Botones/Generales2.png"
            Style="background-attachment: scroll; left: 112px; background-image: url('images/Inicio.png');
            background-repeat: no-repeat; position: absolute; top: 123px; right: 941px;" ToolTip="Datos"
            Width="104px" TabIndex="16" />
        <asp:Panel ID="Panel2" runat="server" Height="332px" Style="border: 1px solid #000666; z-index: 9; left: 10px; position: absolute; top: 446px; background-color: white; width: 655px;"
            Visible="False">
            <asp:Label ID="Label18" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 35px; color: #800000;" Text="R.F.C."
                Width="46px"></asp:Label>
            <asp:Label ID="Label30" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 59px; right: 564px; color: #800000;" Text="Curp"
                Width="44px" ForeColor="#990000"></asp:Label>
            &nbsp;
            <asp:Label ID="Label31" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 9px; height: 16px; width: 95px;" 
                Text="Fecha de Nac." ForeColor="#990000"></asp:Label>
            <asp:Label ID="Label32" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 290px; font-family: tahoma; position: absolute; top: 9px" Text="Edad"
                Width="38px"></asp:Label>
            <asp:Label ID="Label43" runat="server" Style="font-weight: bold; font-size: 10pt;
                left: 390px; font-family: tahoma; position: absolute; top: 9px" Text="Años"
                Width="38px"></asp:Label>
            <asp:Label ID="Label33" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 107px; color: #800000;" Text="Genero"
                Width="48px"></asp:Label>
            <asp:Label ID="Label34" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 83px; width: 94px; color: #800000;" 
                Text="Lugar de Nac."></asp:Label>
            <asp:Label ID="Label35" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 290px; font-family: tahoma; position: absolute; top: 107px; color: #800000;" Text="Edo. Civil"
                Width="66px"></asp:Label>
            &nbsp;
            <asp:Label ID="Label37" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 290px; font-family: tahoma; position: absolute; top: 83px; height: 14px; width: 79px; color: #800000;" 
                Text="Nacionalidad"></asp:Label>
            <asp:Label ID="Label38" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 8px; font-family: tahoma; position: absolute; top: 130px; width: 105px; height: 17px;" 
                Text="Afiliacón IMSS" ForeColor="#990000"></asp:Label>
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <asp:Label ID="Label42" runat="server" Height="16px" Style="border-style: none; font-size: 10pt; left: 329px; font-family: tahoma; position: absolute; top: 9px;
                text-align: right; right: 280px;" Width="40px"></asp:Label>
            <div style="z-index: 1; left: 107px; top: 9px; position: absolute; height: 19px; width: 128px">
                <asp:TextBox ID="TextBox16" runat="server" Width="100px" 
                    AutoPostBack="True" TabIndex="16" style="top: 0px; left: 0px"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 107px; top: 35px; position: absolute; height: 19px; width: 173px">
                <asp:TextBox ID="TextBox14" runat="server" Width="150px" TabIndex="17" 
                    style="top: 0px; left: 0px"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 107px; top: 59px; position: absolute; height: 19px; width: 173px">
                <asp:TextBox ID="TextBox15" runat="server" Width="150px" TabIndex="20"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 107px; top: 83px; position: absolute; height: 19px; width: 173px">
                <asp:TextBox ID="TextBox17" runat="server" Width="150px" TabIndex="21"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 387px; top: 83px; position: absolute; height: 19px; width: 173px">
                <asp:TextBox ID="TextBox18" runat="server" Width="150px" TabIndex="22"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 107px; top: 131px; position: absolute; height: 19px; width: 173px">
                <asp:TextBox ID="TextBox19" runat="server" MaxLength="11" Width="150px" 
                    TabIndex="25"></asp:TextBox>
            </div>
            <div style="z-index: 1; left: 107px; top: 107px; position: absolute; height: 19px; width: 163px">
                <asp:DropDownList ID="DlGenero" runat="server" style="top: 0px; left: 0px" 
                    TabIndex="23"><asp:ListItem Value="1">Femenino</asp:ListItem><asp:ListItem Value="2">Masculino</asp:ListItem><asp:ListItem Selected="True" Value="0">Seleccione...</asp:ListItem></asp:DropDownList>
            </div>
            <div style="z-index: 1; left: 387px; top: 107px; position: absolute; height: 19px; width: 163px">
                <asp:DropDownList ID="DlCivil" runat="server" TabIndex="23"><asp:ListItem Selected="True" Value="0">Seleccione...</asp:ListItem><asp:ListItem Value="1">Soltero(a)</asp:ListItem><asp:ListItem Value="2">Casado(a)</asp:ListItem><asp:ListItem Value="3">Divorciado(a)</asp:ListItem><asp:ListItem Value="4">Viudo(a)</asp:ListItem><asp:ListItem Value="5">Union libre</asp:ListItem></asp:DropDownList>
            </div>
            <asp:Label ID="Label91" runat="server" 
                Style="font-weight: bold; font-size: 10pt;
                left: 290px; font-family: tahoma; position: absolute; top: 35px; width: 113px; color: #800000; margin-bottom: 0px;" 
                Text="R.F.C. Generado"></asp:Label>
            <div style="z-index: 1; left: 397px; top: 35px; position: absolute; height: 19px; width: 161px">
                <asp:TextBox ID="TextBox44" runat="server" Width="150px" TabIndex="18" 
                    style="top: 0px; left: 1px"></asp:TextBox>
            </div>
            <asp:Label ID="Label92" runat="server" CssClass="style1" Style="font-weight: bold; font-size: 10pt;
                left: 42px; position: absolute; top: 172px; height: 16px; width: 105px;" 
                Text="Observaciones"></asp:Label>
            <div style="z-index: 1; left: 149px; top: 169px; position: absolute; height: 61px; width: 317px">
                <asp:TextBox ID="TextBox34" runat="server" TextMode="MultiLine" 
                    Width="300px" TabIndex="26"></asp:TextBox>
            </div>

            <asp:ImageButton ID="ImageButton15" runat="server" 
                ImageUrl="~/Content/img/rfc.png" 
                Style="z-index: 2; background-attachment: scroll; left: 555px; background-image: url('images/Inicio.png'); background-repeat: no-repeat; position: absolute; top: 36px; height: 29px; width: 27px;" 
                TabIndex="4" ToolTip="Genera RFC automáticamente" />
            </asp:Panel>
        <asp:ImageButton ID="ImageButton3" runat="server" Height="23px" ImageUrl="~/Content/img/Botones/Salarios.png"
            Style="background-attachment: scroll; left: 213px; background-image: url('images/Inicio.png');
            background-repeat: no-repeat; position: absolute; top: 123px; right: 370px;" ToolTip="Datos"
            Width="104px" TabIndex="27" />
        <asp:Label ID="Label73" runat="server" 
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 106px; text-align: left; font-weight: 700; width: 65px; height: 15px;" 
            Visible="False">Plaza</asp:Label>
                        <asp:Panel ID="Panel7" runat="server" 
                            
                            
                        
                        
            
            style="border: 1px solid #000666; z-index: 10; left: 660px; top: 146px; position: absolute; height: 332px; width: 655px; right: -3px; background-color: #FFFFFF;" 
            Visible="False">
                            <asp:Label ID="Label75" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700;
                        font-size: 10pt; left: 230px; font-family: Tahoma; position: absolute; top: 63px; width: 89px; color: #800000; height: 15px;">Salario IMSS</asp:Label>
                            <asp:Label ID="Label76" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700;
                        font-size: 10pt; left: 20px; font-family: Tahoma; position: absolute; top: 39px; color: #800000; height: 17px; width: 124px;">Registro Patronal</asp:Label>
                            <asp:Label ID="Label77" runat="server" ForeColor="Red" 
                                
                                
                                
                                
                                
                                Style="font-weight: 700; font-size: 10pt;
                        left: 20px; font-family: Tahoma; position: absolute; top: 111px; color: #800000; width: 121px; height: 17px;">Fec. Ini. Contrato</asp:Label>
                            <asp:Label ID="Label78" runat="server" 
                                
                                
                                
                                
                                Style="font-weight: 400; font-size: 10pt;
                        left: 250px; font-family: Tahoma; position: absolute; top: 111px; height: 17px; width: 108px; color: #000000;">Fec. Ter. Contrato</asp:Label>
                            <asp:Label ID="Label80" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700; font-size: 10pt; left: 20px; font-family: Tahoma; position: absolute; top: 63px; width: 109px; color: #800000; height: 16px;">Salario Mensual</asp:Label>
                            <asp:Label ID="Label81" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700; font-size: 10pt; left: 410px; font-family: Tahoma; position: absolute; top: 63px; width: 28px; color: #800000; height: 17px;">SDI</asp:Label>
                            <asp:Label ID="Label82" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700; font-size: 10pt; left: 20px; font-family: Tahoma; position: absolute; top: 14px; color: #800000; height: 15px; width: 110px;">Tipo de Nomina</asp:Label>
                            <asp:Label ID="Label83" runat="server" ForeColor="Red" 
                                
                                
                                
                                Style="font-weight: 700; font-size: 10pt; left: 20px; font-family: Tahoma; position: absolute; top: 87px; width: 109px; color: #800000; height: 16px;">Forma de Pago</asp:Label>
                            <div style="z-index: 1; left: 140px; top: 87px; position: absolute; height: 19px; width: 159px">
                                <asp:DropDownList ID="DlFormaPago0" runat="server" 
                                    style="top: 0px; left: 0px" TabIndex="33"></asp:DropDownList>
                            </div>
                            <div style="z-index: 1; left: 140px; top: 14px; position: absolute; height: 19px; width: 116px">
                                <asp:DropDownList ID="DropDownList5" runat="server" Width="100px" TabIndex="28"></asp:DropDownList>
                            </div>
                            <div style="z-index: 1; left: 140px; top: 39px; position: absolute; height: 19px; width: 207px">
                                <asp:DropDownList ID="DropDownList6" runat="server" Width="200px" 
                                    Height="200px" style="top: 0px; left: 0px" TabIndex="29"></asp:DropDownList>
                            </div>
                            <div style="z-index: 1; left: 140px; top: 63px; position: absolute; height: 19px; width: 87px">
                                <asp:TextBox ID="TextBox36" runat="server" Width="80px" 
                                    style="top: 0px; left: 0px" TabIndex="30"></asp:TextBox>
                            </div>
                            <div style="z-index: 1; left: 320px; top: 63px; position: absolute; height: 19px; width: 87px">
                                <asp:TextBox ID="TextBox37" runat="server" Width="80px" 
                                    style="top: 0px; left: 0px" TabIndex="31"></asp:TextBox>
                            </div>
                            <div style="z-index: 1; left: 440px; top: 63px; position: absolute; height: 19px; width: 87px">
                                <asp:TextBox ID="TextBox38" runat="server" Width="80px" TabIndex="32"></asp:TextBox>
                            </div>
                            <div style="z-index: 1; left: 370px; top: 110px; position: absolute; height: 19px; width: 111px">
                                <asp:TextBox ID="TextBox39" runat="server" Width="100px" TabIndex="35" 
                                    style="top: 0px; left: 0px"></asp:TextBox>
                            </div>
                            <div style="z-index: 1; left: 140px; top: 110px; position: absolute; height: 19px; width: 87px">
                                <asp:TextBox ID="TextBox40" runat="server" Width="100px" TabIndex="34"></asp:TextBox>
                            </div>
                            <asp:Panel ID="Panel8" runat="server" 
                                
                                
                                Style="border: 1px solid #000080; left: 0px;
                        position: absolute; top: 134px; background-color: white; height: 80px; width: 603px; z-index: 5;">
                                <asp:Label ID="Label84" runat="server" Style="font-weight: 700; font-size: 10pt;
                            left: 20px; font-family: Tahoma; position: absolute; top: 24px; color: #800000;" 
                                    Width="48px">Banco</asp:Label>
                                <asp:Label ID="Label85" runat="server" Style="font-weight: normal; font-size: 10pt;
                            left: 20px; font-family: Tahoma; position: absolute; top: 48px" Width="48px">Cuenta</asp:Label>
                                <asp:Label ID="Label86" runat="server" 
                                    
                                    Style="font-weight: bold; left: 0px; color: white;
                            font-family: tahoma; position: absolute; top: 0px; text-align: center; background-color: #000066; height: 21px; width: 604px;">Cuenta para Pago</asp:Label>
                                <div style="z-index: 1; left: 70px; top: 24px; position: absolute; height: 19px; width: 198px">
                                    <asp:DropDownList ID="DropDownList7" runat="server" Width="180px" 
                                        TabIndex="36"></asp:DropDownList>
                                </div>
                                <div style="z-index: 1; left: 70px; top: 49px; position: absolute; height: 19px; width: 273px">
                                    <asp:TextBox ID="TextBox5" runat="server" Width="250px" 
                                        style="top: 0px; left: 0px" TabIndex="37"></asp:TextBox>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="Panel4" runat="server" Style="border: 1px solid #000066; left: 0px;
                        position: absolute; top: 220px; z-index: 2; width: 602px; height: 102px;">
                                <asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="True"                                      
                                    RepeatDirection="Horizontal" Style="font-size: 10pt; left: 8px; font-family: tahoma;
                                    position: absolute; top: 54px; height: 2px; width: 420px;" TabIndex="40">
                                    <asp:ListItem Value="0">Cuota</asp:ListItem>
                                    <asp:ListItem Value="1">Factor VSM</asp:ListItem>
                                    <asp:ListItem Value="2">Porcentaje</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:Label ID="Label87" runat="server" ForeColor="Black" 
                                    Style="font-weight: normal;
                                    font-size: 10pt; left: 231px; font-family: Tahoma; position: absolute; top: 32px; bottom: 68px; width: 91px;" 
                                    Width="91px">No. Credito</asp:Label>
                                <asp:Label ID="Label88" runat="server" 
                                    
                                    Style="font-weight: bold; left: 0px; color: white;
                            font-family: tahoma; position: absolute; top: 0px; text-align: center; background-color: #000066; height: 19px; width: 600px;">Datos Infonavit</asp:Label>
                                <div style="z-index: 1; left: 300px; top: 30px; position: absolute; height: 19px; width: 140px">
                                    <asp:TextBox ID="TextBox41" runat="server" Width="130px" 
                                        style="top: 0px; left: 0px" TabIndex="39"></asp:TextBox>
                                </div>
                                <div style="z-index: 1; left: 120px; top: 30px; position: absolute; height: 19px; width: 108px; right: 303px;">
                                    <asp:TextBox ID="TextBox42" runat="server" Width="100px" TabIndex="38"></asp:TextBox>
                                </div>
                                <asp:Label ID="Label89" runat="server" ForeColor="Black" 
                                    Style="font-weight: normal;
                                    font-size: 10pt; left: 11px; font-family: Tahoma; position: absolute; top: 82px; width: 59px; height: 16px;">Factor</asp:Label>
                                <asp:Label ID="Label90" runat="server" ForeColor="Black" 
                                    Style="font-weight: normal;
                                    font-size: 10pt; left: 11px; font-family: Tahoma; position: absolute; top: 32px; width: 111px;">Fecha 
                                de Crédito</asp:Label>
                                <div style="z-index: 1; left: 100px; top: 80px; position: absolute; height: 19px; width: 132px">
                                    <asp:TextBox ID="TextBox43" runat="server" Width="100px" TabIndex="41" 
                                        style="top: 0px; left: 0px"></asp:TextBox>
                                </div>
                            </asp:Panel>
                        </asp:Panel>
        <asp:Label ID="Label93" runat="server" 
            
            
            
            
            
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 146px; text-align: left; font-weight: 700; width: 65px; height: 15px;" 
            Visible="False">STope</asp:Label>
        <asp:Label ID="Label94" runat="server" 
            
            
            
            
            
            Style="border-style: none; font-size: 10pt; left: 664px; font-family: tahoma; position: absolute; top: 46px; text-align: left; font-weight: 700; width: 65px; height: 15px; bottom: 457px;" 
            Visible="False">Proyecto</asp:Label>
    </form>
</body>
</html>
