<%@ WebHandler Language="VB" Class="GH_Updoctocorrec" %>

Imports System
Imports System.Web
Imports System.IO

Public Class GH_Updoctocorrec : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim nm As String = ""
        Dim orden As Integer = 0
        If context.Request.Files.Count > 0 Then
            Dim files As HttpFileCollection = context.Request.Files
            For x As Integer = 0 To files.Count - 1
                Dim fle As HttpPostedFile = files(x)
                Dim dts() As String = StrReverse(fle.FileName.ToString()).Split("\")
                nm = StrReverse(dts(0))
                dts = nm.Split(".")
                orden = context.Request.Params("Id")
                If context.Request.Form("") = "" Then
                    nm = "checklist" & orden & "." & dts(1)
                Else
                    nm = "checklist" & orden & context.Request.Form("nmr") & "." & dts(1)
                End If
                If Not Directory.Exists("c:\inetpub\wwwroot\SINGA_APP\Doctos\cm\" & orden & "\evidencias\") Then
                    Directory.CreateDirectory("c:\inetpub\wwwroot\SINGA_APP\Doctos\cm\" & orden & "\evidencias\")
                End If
                'Dim vcarpeta As String = "c:\inetpub\wwwroot\SINGA_APP\Doctos\entrega\F" + vanio + "_" + vmes + "\"
                fle.SaveAs("c:\inetpub\wwwroot\SINGA_APP\Doctos\cm\" & orden & "\evidencias\" & nm)
                'fle.SaveAs(vcarpeta & nm)
            Next
        Else
            File.Delete("c:\inetpub\wwwroot\SINGA_APP\Doctos\cm\" & orden & "\evidencias\" & context.Request("elimina"))
            'File.Delete("c:\Doctos\Finanzas\" & context.Request("elimina"))
            'File.Delete("d:\Doctos\cgo\" & context.Request("elimina"))
        End If
        context.Response.ContentType = "text/plain"
        context.Response.Write(nm)
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class