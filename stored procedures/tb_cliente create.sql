USE [SINGA]
GO

/****** Object:  Table [dbo].[tb_cliente]    Script Date: 27/08/2019 04:24:38 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente](
	[id_cliente] [int] NOT NULL,
	[dimension] [char](6) NOT NULL,
	[nombre] [varchar](60) NOT NULL,
	[porcmat] [float] NOT NULL,
	[porcind] [float] NOT NULL,
	[credito] [int] NOT NULL,
	[id_tipocliente] [int] NOT NULL,
	[fechainicio] [datetime] NOT NULL,
	[vigencia] [int] NOT NULL,
	[fechatermino] [datetime] NULL,
	[id_elaboro] [int] NOT NULL,
	[id_ejecutivo] [int] NOT NULL,
	[id_operativo] [int] NOT NULL,
	[id_director] [int] NOT NULL,
	[contacto] [varchar](50) NOT NULL,
	[puesto] [varchar](50) NULL,
	[departamento] [varchar](50) NULL,
	[telefono1] [varchar](20) NULL,
	[email] [nvarchar](50) NULL,
	[periodofactura] [varchar](30) NOT NULL,
	[tipofactura] [varchar](30) NOT NULL,
	[descmateriales] [bit] NOT NULL,
	[descservicios] [bit] NOT NULL,
	[descplantillas] [bit] NOT NULL,
	[descplazoentrega] [bit] NOT NULL,
	[id_status] [int] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_porcmat]  DEFAULT ((0)) FOR [porcmat]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_porcind]  DEFAULT ((0)) FOR [porcind]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_credito]  DEFAULT ((0)) FOR [credito]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_vigencia]  DEFAULT ((0)) FOR [vigencia]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_id_elaboro]  DEFAULT ((0)) FOR [id_elaboro]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_id_ejecutivo]  DEFAULT ((0)) FOR [id_ejecutivo]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_id_operativo]  DEFAULT ((0)) FOR [id_operativo]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_id_director]  DEFAULT ((0)) FOR [id_director]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_descmateriales]  DEFAULT ((0)) FOR [descmateriales]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_descservicios]  DEFAULT ((0)) FOR [descservicios]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_descplantillas]  DEFAULT ((0)) FOR [descplantillas]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_descplazoentrega]  DEFAULT ((0)) FOR [descplazoentrega]
GO

ALTER TABLE [dbo].[tb_cliente] ADD  CONSTRAINT [DF_tb_cliente_id_status]  DEFAULT ((1)) FOR [id_status]
GO


