USE [SINGA]
GO
/****** Object:  StoredProcedure [dbo].[sp_Usuario]    Script Date: 05/09/2019 05:58:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_plantilla]  @Cabecero xml
AS
BEGIN
	begin tran	
	begin try
		begin 		
			Insert into tb_cliente_plantilla(id_inmueble, id_puesto, cantidad, id_turno, jornal, smntope, bonoasist,
			primadominical, bonopasaje, otrascomp)
			select c.value('@idinm','varchar(40)'), c.value('@puesto','varchar(40)'), c.value('@cantidad','varchar(100)'),
			c.value('@turno','nvarchar(100)'), c.value('@jornal','varchar(100)'), c.value('@smntope','int'),  
			c.value('@bonoasist','int'), c.value('@bonodom','int'), c.value('@bonopasaje','int'),
			c.value('@otrascomp','int')
			from @Cabecero.nodes('plantilla') as t(c);
		end

		commit tran
	end try
	Begin catch
		rollback
		DECLARE @ERR VARCHAR(100)
		SET @ERR = ERROR_MESSAGE()
		raiserror(@ERR, 16, 1);
	end catch
END
