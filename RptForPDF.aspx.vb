Imports System.IO
Imports Microsoft.VisualBasic
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports CrystalDecisions.Web.Report


Partial Class RptForAll
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'reportname = Request("v_nomRpt") '"almacen2.rpt"
        'filename = Request("filename")

        rpt.Report.FileName = "App_Reportes\" & Request("v_nomRpt")

        rpt.ReportDocument.RecordSelectionFormula = Request("v_formula")
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        Dim ruta As String = "C:\inetpub\wwwroot\SINGA_APP\Doctos\banfuturo\primero.pdf"
        'rpt.ReportDocument.ExportToHttpResponse(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, Response, False, ruta)
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        'Session("oRpt").recordselectionformula = consulta
        'Response.Write(Session("oRpt").recordselectionformula)
        'Response.Write(session("v_formula"))
        If Err.Number <> 0 Then
            Response.Write("Error Occurred creating Report Object: " & Err.Description)
            Session("oRpt") = Nothing
            Session("oApp") = Nothing
            Session.Abandon()
            Response.End()
        End If
            If Not Request("cierra") Is Nothing Then
                Response.Write("<script language='javascript'> { window.close(); }</script>")
            End If
    End Sub
End Class
