USE [SINGA]
GO
/****** Object:  StoredProcedure [dbo].[uop_GuardaCab_Iguala2]    Script Date: 16/01/2019 04:31:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_clienteoficina] @Cabecero xml
AS
	declare @cli as int;
BEGIN
		
	begin tran
	begin try

		set @cli = (select c.value('@cliente','smallint') from @Cabecero.nodes('Movimiento') as t(c));

		delete from tb_cliente_oficina where id_cliente = @cli

		insert into tb_cliente_oficina (id_cliente, id_oficina)
		select c.value('@idcliente', 'smallint'), c.value('@idplaza', 'tinyint')
		from @Cabecero.nodes('Movimiento/cte') as t(c);
		
		commit tran
	end try
	Begin catch
		rollback
		--SET @Idpro = 0;
		DECLARE @ERR VARCHAR(100)
		SET @ERR = ERROR_MESSAGE()
		raiserror(@ERR, 16, 1);
	end catch
END
