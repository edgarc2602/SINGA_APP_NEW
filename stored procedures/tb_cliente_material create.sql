USE [SINGA]
GO

/****** Object:  Table [dbo].[tb_cliente_material]    Script Date: 27/08/2019 05:03:24 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente_material](
	[id_material] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [smallint] NOT NULL,
	[id_lineanegocio] [smallint] NOT NULL,
	[id_periodo] [tinyint] NOT NULL,
	[concepto] [varchar](150) NOT NULL,
	[importe] [float] NOT NULL,
	[fechaaplica] [datetime] NOT NULL,
	[id_usuario] [smallint] NOT NULL,
	[id_status] [bit] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tb_cliente_material] ADD  CONSTRAINT [DF_tb_cliente_material_id_status]  DEFAULT ((1)) FOR [id_status]
GO


