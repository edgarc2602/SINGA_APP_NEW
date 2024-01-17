<%@ WebHandler Language="VB" Class="GH_UpLayout" %>

Imports System
Imports System.Web
Imports System.IO

Public Class GH_UpLayout : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim nm As String = ""
        If context.Request.Files.Count > 0 Then
            Dim files As HttpFileCollection = context.Request.Files
            For x As Integer = 0 To files.Count - 1
                Dim fle As HttpPostedFile = files(x)
                Dim dts() As String = StrReverse(fle.FileName.ToString()).Split("\")
                nm = StrReverse(dts(0))
                dts = nm.Split(".")
                If context.Request.Form("") = "" Then
                    nm = dts(0) & "." & dts(1)
                Else
                    nm = dts(0) & context.Request.Form("nmr") & "." & dts(1)
                End If
                fle.SaveAs("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\" & nm)
                'fle.SaveAs("c:\Doctos\mantenimiento\" & nm)
            Next
        Else

            File.Delete("c:\inetpub\wwwroot\SINGA_APP\Doctos\mantenimiento\" & context.Request("elimina"))
            'File.Delete("c:\Doctos\mantenimiento\" & context.Request("elimina"))
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