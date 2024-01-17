Imports System
Imports System.Net
Imports System.Net.Http
Imports System.Threading.Tasks

Partial Class Ventas_App_Ven_Webhooks
    Inherits System.Web.UI.Page
    Public listamenu As String = ""
    Public minombre As String = ""

    Private Const BaseUrl As String = "https://localhost:5001/api/DocumentoNuevo" ' Cambia la URL base de acuerdo a tu API
    Private Const Username As String = "usrbatia" ' Cambia a tu usuario
    Private Const Password As String = "pswb4t1a" ' Cambia a tu contraseña

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim usuario As HttpCookie
        Dim userid As Integer

        usuario = Request.Cookies("Usuario")

        If usuario Is Nothing Then
            Response.Redirect("/login.aspx")
        Else
            userid = Request.Cookies("Usuario").Value
            idusuario.Value = Request.Cookies("Usuario").Value
        End If

        Dim menui As New cargamenu()
        listamenu = menui.mimenu(userid)
        minombre = menui.minombre(userid)
    End Sub


    ''<Web.Services.WebMethod()>
    ''Public Shared Async Function factura() As Task(Of String)
    ''    Dim handler As New HttpClientHandler()
    ''    Dim Sql As String = ""
    ''    Dim algo As String = "prueba"
    ''    Dim Num As Int16 = 3
    ''    handler.Credentials = New NetworkCredential(Username, Password)
    ''    Dim httpClient As HttpClient = New HttpClient(handler)
    ''    httpClient.BaseAddress = New Uri(BaseUrl)
    ''    httpClient.DefaultRequestHeaders.Accept.Add(New MediaTypeWithQualityHeaderValue("application/json"))
    ''    Dim Response As HttpResponseMessage = httpClient.GetAsync(BaseUrl).Result

    ''    'Dim request As HttpWebRequest = CType(WebRequest.Create("https://localhost:5001/api/Document"), HttpWebRequest)
    ''    'request.Method = "GET"

    ''    'Dim Response As HttpResponseMessage = Await httpClient.GetAsync(BaseUrl)

    ''    If Response.IsSuccessStatusCode Then
    ''        Dim responseJson As String = Await Response.Content.ReadAsStringAsync()
    ''        Dim serializer As New JavaScriptSerializer()
    ''        Dim documents As List(Of Document) = serializer.Deserialize(Of List(Of Document))(responseJson)

    ''        Sql = "{"
    ''        For Each docum As Document In documents
    ''            Sql += "id'" & docum.DocumentId.ToString & "', rfc:'" & docum.EmitterTaxId & "', razon:'" & docum.Emitter & "' , rfcreceptor: '" & docum.ReceiverTaxId & "'"
    ''    Next
    ''        Sql = "}"
    ''        Return Sql
    ''    Else
    ''        Sql = "{"
    ''        Sql += "id:'" & algo & "', rfc:'" & algo & "', razon:'" & algo & "' , rfcreceptor: '" & Num & "'"
    ''        Sql = "}"
    ''        Return Sql
    ''    End If
    ''End Function
    <Web.Services.WebMethod()>
    Public Shared Async Function factura() As Task(Of String)
        Dim handler As New HttpClientHandler()
        handler.Credentials = New NetworkCredential(Username, Password)
        Dim httpClient As New HttpClient(handler)

        Dim response As HttpResponseMessage = Await httpClient.GetAsync(BaseUrl)

        If response.IsSuccessStatusCode Then
            Dim responseBody As String = Await response.Content.ReadAsStringAsync()
            Return responseBody
        Else
            ' Manejar el error si la respuesta no es exitosa
            Return Nothing
        End If

    End Function
    'Private Shared Function ConsumeApiTok(httpClient As HttpClient, apiUrl As String) As String
    '    Dim response As HttpResponseMessage = httpClient.GetAsync(apiUrl).Result

    '    If response.IsSuccessStatusCode Then
    '        Dim responseBody As String = response.Content.ReadAsStringAsync().Result
    '        Return responseBody
    '    Else
    '        Return "Error: {response.StatusCode} - {response.ReasonPhrase}"
    '    End If
    'End Function
    'Private Shared Function ConsumeApiok(httpClient As HttpClient, apiUrl As String) As String
    '    Dim response As HttpResponseMessage = httpClient.GetAsync(apiUrl).Result

    '    If response.IsSuccessStatusCode Then
    '        Dim responseBody As String = response.Content.ReadAsStringAsync().Result
    '        Return responseBody
    '    Else
    '        Return "Error: {response.StatusCode} - {response.ReasonPhrase}"
    '    End If
    'End Function
    'Private Shared Function ConsumeApi(endpoint As String, username As String, password As String) As String
    '    Dim handler As New HttpClientHandler()
    '    handler.Credentials = New NetworkCredential(username, password)
    '    Dim httpClient As New HttpClient(handler)
    '    httpClient.BaseAddress = New Uri(BaseUrl)
    '    httpClient.DefaultRequestHeaders.Accept.Clear()
    '    httpClient.DefaultRequestHeaders.Accept.Add(New MediaTypeWithQualityHeaderValue("application/json"))
    '    Dim response As HttpResponseMessage = httpClient.GetAsync(endpoint).Result

    '    If response.IsSuccessStatusCode Then
    '        Return response.Content.ReadAsStringAsync().Result
    '    Else
    '        Return "Error en la solicitud: " & response.ReasonPhrase
    '    End If
    'End Function
    '<Web.Services.WebMethod()>
    'Public Shared Async Function GetDocumentsFromDatabase() As Task(Of String)
    '    Try
    '        Dim sql As String = ""
    '        'Dim response As HttpResponseMessage = HttpClient.GetAsync("api/Document").Result
    '        Dim response As HttpResponseMessage = Await HttpClient.GetAsync("https://localhost:5001/api/DocumentoNuevo").Result

    '        If response.IsSuccessStatusCode Then
    '            Dim responseBody As String = Await response.Content.ReadAsStringAsync()
    '            Dim documents As List(Of Document) = JsonConvert.DeserializeObject(Of List(Of Document))(responseBody)
    '            Sql = "{"
    '            For Each docum As Document In documents
    '                Sql += "id:'" & docum.DocumentId.ToString & "', rfc:'" & docum.EmitterTaxId & "', razon:'" & docum.Emitter & "' , rfcreceptor: '" & docum.ReceiverTaxId & "'"
    '            Next
    '            Sql = "}"
    '            Return Sql
    '        Else
    '            Return "fallo"
    '        End If
    '    Catch ex As Exception
    '        Return "Error al realizar la solicitud: " & ex.Message
    '    End Try
    'End Function
    Public Class Document
        Public Property DocumentId As Guid
        Public Property EmitterTaxId As String
        Public Property Emitter As String
        Public Property ReceiverTaxId As String
        Public Property Receiver As String
        Public Property DocumentDate As DateTime
        Public Property Total As Decimal
        Public Property Version As String
        Public Property Folio As String
        Public Property Serie As String
        Public Property CurrencyIsoCode As String
        Public Property ExchangeRate As Decimal
        Public Property IsLoadedByAPI As Boolean
        Public Property InvoiceDocumentTypeId As Integer
        Public Property DocumentTypeId As Integer
        Public Property IsCollaborative As Boolean
        Public Property IsMigrated As Boolean?
        Public Property PaymentReferences As String
        Public Property XML As String
        Public Property PDF As String
    End Class
End Class
