USE [SINGA]
GO

/****** Object:  Table [dbo].[tb_cliente_inmueble]    Script Date: 27/08/2019 04:52:33 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente_inmueble](
	[id_inmueble] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [tinyint] NOT NULL,
	[nombre] [varchar](60) NOT NULL,
	[nosuc] [varchar](15) NULL,
	[direccion] [varchar](80) NULL,
	[entrecalles] [varchar](100) NULL,
	[cp] [char](5) NULL,
	[colonia] [varchar](80) NULL,
	[delegacionmunicipio] [char](40) NULL,
	[ciudad] [char](40) NULL,
	[id_estado] [smallint] NOT NULL,
	[tel1] [varchar](50) NULL,
	[tel2] [varchar](50) NULL,
	[ext1] [varchar](50) NULL,
	[ext2] [varchar](50) NULL,
	[nombrecontacto] [varchar](60) NULL,
	[emailcontacto] [varchar](50) NULL,
	[cargocontacto] [varchar](60) NULL,
	[id_tipoinmueble] [smallint] NOT NULL,
	[id_status] [smallint] NOT NULL,
	[id_plaza] [smallint] NOT NULL,
	[id_supmanto] [smallint] NOT NULL,
	[id_suplimp] [smallint] NOT NULL,
	[presupuestom] [float] NOT NULL,
	[presupuestol] [float] NOT NULL,
	[presupuestoh] [float] NOT NULL,
	[CentroCosto] [varchar](6) NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_id_estado]  DEFAULT ((0)) FOR [id_estado]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_id_status]  DEFAULT ((1)) FOR [id_status]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_id_supmanto]  DEFAULT ((0)) FOR [id_supmanto]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_id_suplimp]  DEFAULT ((0)) FOR [id_suplimp]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_presupuestom]  DEFAULT ((0)) FOR [presupuestom]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_presupuestol]  DEFAULT ((0)) FOR [presupuestol]
GO

ALTER TABLE [dbo].[tb_cliente_inmueble] ADD  CONSTRAINT [DF_tb_cliente_inmueble_presupuestoh]  DEFAULT ((0)) FOR [presupuestoh]
GO


