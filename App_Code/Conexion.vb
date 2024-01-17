Imports System.Data.SqlClient
Imports Microsoft.VisualBasic

Public Class Conexion
#Region " Variables "

    Private mUsuario As String
    Private mPassword As String
    Private mConSSPI As Boolean = False
    Private mServidor As String
    Private mBaseDatos As String
    Private mSqlConn As SqlConnection

#End Region

#Region " Propiedades "

    Public Property Usuario() As String
        Get
            Return mUsuario
        End Get
        Set(ByVal Value As String)
            mUsuario = Value
        End Set
    End Property

    Public Property Password() As String
        Get
            Return mPassword
        End Get
        Set(ByVal Value As String)
            mPassword = Value
        End Set
    End Property

    Public Property ConSSPI() As Boolean
        Get
            Return mConSSPI
        End Get
        Set(ByVal Value As Boolean)
            mConSSPI = Value
        End Set
    End Property

    Public Property Servidor() As String
        Get
            Return mServidor
        End Get
        Set(ByVal Value As String)
            mServidor = Value
        End Set
    End Property

    Public Property BaseDatos() As String
        Get
            Return mBaseDatos
        End Get
        Set(ByVal Value As String)
            mBaseDatos = Value
        End Set
    End Property

    Public Property SQLConn() As SqlConnection
        Get
            Return mSqlConn
        End Get
        Set(ByVal Value As SqlConnection)
            mSqlConn = Value
        End Set
    End Property
#End Region

#Region " Constructor y Variables Conexion **** "

    Public Sub New()
        Try

            'PRUEBAS DE FACTURACION
            Me.Servidor = "192.168.2.4"
            Me.BaseDatos = "TESTING"
            Me.Usuario = "sa"
            Me.Password = "S1ng42019"

            ''PRUEBAS PREVENTIVOS
            'Me.Servidor = "SISTEMAS\SQLEXPRESS2019"
            'Me.BaseDatos = "SINGA"
            'Me.Usuario = "sa"
            'Me.Password = "S1ng42019"

            'Esta seccion de variables de la conexion
            'prefiero hacerlo asi, en lugar de un archivo conexion
            'Me.Servidor = "DESKTOP-4RGV6FC\SQLEXPRESS2019"
            'Me.Servidor = "192.168.2.4"
            'Me.BaseDatos = "SINGAPROD"
            'Me.BaseDatos = "TESTING"
            'Me.Usuario = "sa"
            'Me.Usuario = "JorgeMtz"
            'Me.Usuario = "sa"
            'Me.Password = "S1ng42019"
            'Me.Password = "Proskater45"
            'Me.Password = "sasa"
            SQLConn = New SqlConnection(Me.StrConexion)
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

#Region " Procedimientos y Funciones "

    'Crea el string de conexion a la base de datos.
    Public Function StrConexion() As String
        Try
            Dim ConnectionString As String = "server=" & Servidor & "; database=" & BaseDatos & ";"
            ConnectionString = ConnectionString + "user id=" & Usuario & ";password=" & Password & ";connect timeout =60;"
            Return ConnectionString
        Catch ex As Exception
            Throw ex
        End Try
    End Function
#End Region

End Class