<%@ WebHandler Language="VB" Class="GH_UpXML" %>

Imports System
Imports System.Web
Imports System.IO

Public Class GH_UpXML : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim nm As String = ""
        Dim fecha As Date = Date.Now()
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

                Dim vmes As String = fecha.Month.ToString
                If Len(vmes) = 1 Then
                    vmes = "0" + vmes
                End If
                Dim vanio As String = fecha.Year.ToString

                'Dim vcarpeta As String = "C:\Users\jrber\Documents\SINGA_APP\Doctos\entrega\F" + vanio + "_" + vmes + "\"
                Dim vcarpeta As String = "C:\inetpub\wwwroot\SINGA_APP\Doctos\supervision\F" + vanio + "_" + vmes + "\"

                If (Not System.IO.Directory.Exists(vcarpeta)) Then
                    System.IO.Directory.CreateDirectory(vcarpeta)
                End If

                'fle.SaveAs("d:\Doctos\Finanzas\" & nm)
                fle.SaveAs(vcarpeta & nm)
            Next
        Else

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