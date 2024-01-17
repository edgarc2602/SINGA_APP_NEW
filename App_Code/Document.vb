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
    Public Property IsMigrated As Boolean?
    Public Property IsCollaborative As Boolean
    'Public Property PaymentReferences As PaymentReferences
    Public Property XML As Byte()
    Public Property PDF As Byte()
End Class
