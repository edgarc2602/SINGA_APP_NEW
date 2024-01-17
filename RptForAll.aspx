<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RptForAll.aspx.vb" Inherits="RptForAll" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <CR:CrystalReportViewer ID="crw" runat="server" AutoDataBind="true" BestFitPage="False"/>
            <CR:CrystalReportSource ID="rpt" runat="server">
                <Report FileName="Reportes/ReportePrueba.rpt" />
            </CR:CrystalReportSource>
        </div>
    </form>
</body>
</html>
