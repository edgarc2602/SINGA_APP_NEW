Imports System.IO
Imports Microsoft.VisualBasic
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports CrystalDecisions.Web


Partial Class RptPdf
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        Dim report As Integer
        Dim filename As String
        Dim fecha As Date = Date.Now()
        Dim ruta As String
        Dim consulta As String

        report = Request("v_id")
        filename = Request("filename")

        
        Dim vmes As String = fecha.Month.ToString
        If Len(vmes) = 1 Then
            vmes = "0" + vmes
        End If
        Dim vanio As String = report
        'Dim vcarpeta As String = "C:\Users\LAP_Sistemas2\Documents\SINGA_APP\Doctos\banfuturo\" + vanio + "_" + vmes + "\"
        Dim vcarpeta As String = "c:\inetpub\wwwroot\SINGA_APP\Doctos\banfuturo\Solicitud" + vanio + "\"

        If (Not System.IO.Directory.Exists(vcarpeta)) Then
            System.IO.Directory.CreateDirectory(vcarpeta)
        End If

        consulta = Request("v_formula")
        '''''SOLICITUD PRESTAMO
        rpt.Report.FileName = "App_Reportes\solicitudprestamo1.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "prestamo" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        '''''''PRE-AUTORIZACION
        rpt.Report.FileName = "App_Reportes\cartapreautobanfuturo.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "preautorizacion" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        '''''''''AUTORIZACION
        rpt.Report.FileName = "App_Reportes\cartaautobanfuturo.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "autorizacion" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        ''''''''AMORTIZACION
        rpt.Report.FileName = "App_Reportes\spamortizacion.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "amortizacion" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        ''''''''''CONTRATO
        rpt.Report.FileName = "App_Reportes\contratobanfuturo.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "contrato" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)
        ''''''''''PAGARE
        rpt.Report.FileName = "App_Reportes\pagarebanfuturo.rpt"
        rpt.ReportDocument.RecordSelectionFormula = consulta
        crw.ToolPanelView = CrystalDecisions.Web.ToolPanelViewType.None
        crw.HasToggleGroupTreeButton = False
        crw.RefreshReport()
        ruta = vcarpeta & "pagare" & report & filename & ".pdf"
        rpt.ReportDocument.ExportToDisk(ExportFormatType.PortableDocFormat, ruta)

        Response.Write("<script language='javascript'> { window.close(); }</script>")
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
