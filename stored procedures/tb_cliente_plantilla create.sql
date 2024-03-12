USE [SINGA]
GO

/****** Object:  Table [dbo].[tb_cliente_plantilla]    Script Date: 27/08/2019 04:58:16 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tb_cliente_plantilla](
	[id_plantilla] [int] IDENTITY(1,1) NOT NULL,
	[id_inmueble] [smallint] NOT NULL,
	[id_puesto] [smallint] NOT NULL,
	[cantidad] [smallint] NOT NULL,
	[contratado] [smallint] NOT NULL,
	[sobrepob] [smallint] NOT NULL,
	[id_turno] [tinyint] NOT NULL,
	[jornal] [tinyint] NOT NULL,
	[smntope] [float] NOT NULL,
	[bonoasist] [float] NOT NULL,
	[primadominical] [float] NOT NULL,
	[bonopasaje] [float] NOT NULL,
	[otrascomp] [float] NOT NULL,
	[id_status] [tinyint] NOT NULL,
	[generavacante] [bit] NOT NULL,
	[fechaaplica] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tb_cliente_plantilla] ADD  CONSTRAINT [DF_tb_cliente_plantilla_bonoasist]  DEFAULT ((0)) FOR [bonoasist]
GO

ALTER TABLE [dbo].[tb_cliente_plantilla] ADD  CONSTRAINT [DF_tb_cliente_plantilla_primadominical]  DEFAULT ((0)) FOR [primadominical]
GO

ALTER TABLE [dbo].[tb_cliente_plantilla] ADD  CONSTRAINT [DF_tb_cliente_plantilla_Pasaje]  DEFAULT ((0)) FOR [bonopasaje]
GO

ALTER TABLE [dbo].[tb_cliente_plantilla] ADD  CONSTRAINT [DF_tb_cliente_plantilla_otrascomp]  DEFAULT ((0)) FOR [otrascomp]
GO


