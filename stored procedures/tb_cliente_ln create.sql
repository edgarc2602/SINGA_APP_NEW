USE [SINGA]
GO

/****** Object:  Table [dbo].[tb_cliente_lineanegocio]    Script Date: 27/08/2019 04:37:48 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente_lineanegocio](
	[id_corporativo] [smallint] NOT NULL,
	[id_lineanegocio] [smallint] NOT NULL,
	[AplicaIguala] [bit] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tb_cliente_lineanegocio] ADD  CONSTRAINT [DF_tb_cliente_lineanegocio_AplicaIguala]  DEFAULT ((0)) FOR [AplicaIguala]
GO


