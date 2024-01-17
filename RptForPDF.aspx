<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RptForPDF.aspx.vb" Inherits="RptForAll" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692FBEA5521E1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <CR:CrystalReportSource ID="rpt" runat="server">
            <Report FileName="REPORTES\tester.rpt"></Report>
        </CR:CrystalReportSource>
        <CR:CrystalReportViewer ID="crw" runat="server" BestFitPage="False"
            AutoDataBind="true" ReportSourceID="rpt" Height="500px" Width="800px" />
    
    </div>
    </form>
</body>
</html>
