USE [SINGA]
GO

/****** Object:  Table [dbo].[Cliente_RazonSocial]    Script Date: 27/08/2019 04:31:44 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente_razonsocial](
	[id_cliente] [int] NOT NULL,
	[rfc] [varchar](13) NOT NULL,
	[razonsocial] [varchar](250) NULL,
	[calle] [varchar](50) NULL,
	[numExt] [varchar](50) NULL,
	[numInt] [varchar](50) NULL,
	[colonia] [varchar](50) NULL,
	[deleg] [varchar](50) NULL,
	[cp] [varchar](5) NULL,
	[ciudad] [varchar](40) NULL,
	[id_estado] [tinyint] NOT NULL,
	[id_status] [tinyint] NOT NULL,
	[metodopago] [nvarchar](10) NOT NULL,
	[rfcbanco] [varchar](13) NULL,
	[nocuenta] [nvarchar](50) NOT NULL,
	[formapago] [varchar](3) NULL,
	[metopago] [varchar](3) NULL,
	[usocfdi] [varchar](3) NULL,
	[formapagocomprobante] [varchar](5) NULL
) ON [PRIMARY]

GO



