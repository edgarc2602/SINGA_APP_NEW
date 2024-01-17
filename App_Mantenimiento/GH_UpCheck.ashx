<%@ WebHandler Language="VB" Class="GH_UpCheck" %>

Imports System
Imports System.Web
Imports System.IO

Public Class GH_UpCheck : Implements IHttpHandler

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

                If Not Directory.Exists("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\") Then
                    Directory.CreateDirectory("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\")
                End If

                fle.SaveAs("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\" & nm)
                'fle.SaveAs("c:\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\" & nm)
            Next
        Else

            File.Delete("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\" & context.Request("elimina"))
            'File.Delete("c:\Doctos\mantenimiento\ordenes\" & orden & "\evidencias\" & context.Request("elimina"))
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