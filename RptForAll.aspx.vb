

Partial Class RptForAll
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        On Error Resume Next

        Session("vconsulta") = Request("v_formula")

        rpt.Report.FileName = "App_Reportes\" & Request("v_nomRpt")
        rpt.ReportDocument.RecordSelectionFormula = Session("vconsulta")
        crw.ReportSource = rpt
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None

        'crw.AllowedExportFormats = True
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()

        If Err.Number <> 0 Then
            Response.Write("Error Occurred creating Report Object: " & Err.Description)

            Session.Abandon()
            Response.End()
        End If
    End Sub
End Class
