USE [SINGA]
GO
/****** Object:  StoredProcedure [dbo].[uop_CatalogoPlaza]    Script Date: 22/08/2019 09:40:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Usuario]  @Cabecero xml, @Id int output
AS
BEGIN
	begin tran	
	begin try
		set @Id = (select c.value('@id','int') from @Cabecero.nodes('usuario') as t(c));
		if @Id = 0
			begin 		
				Insert into Personal(Per_Paterno, Per_Materno, Per_Nombre, per_usuario, per_password,per_elabora, per_revisa, per_autoriza,
				IdArea, Per_Interno, Per_Email, Fecha_Alta,Id_Puesto)
				select c.value('@paterno','varchar(40)'), c.value('@materno','varchar(40)'), c.value('@nombre','varchar(100)'),
				c.value('@usuario','nvarchar(100)'), c.value('@cont','varchar(100)'), c.value('@elabora','int'),  
				c.value('@revisa','int'), c.value('@autoriza','int'), c.value('@area','int'),
				c.value('@tipo','int'), c.value('@correo','varchar(100)'), GETDATE(), c.value('@puesto','int')
				from @Cabecero.nodes('usuario') as t(c);
				set @Id = (select isnull(max (idPersonal),1)  from personal)
			end
		else
			begin
				update personal set Per_Paterno = c.value('@paterno','varchar(40)'), Per_Materno = c.value('@materno','varchar(40)'),
				Per_Nombre = c.value('@nombre','varchar(100)'), per_usuario = c.value('@usuario','nvarchar(100)'),
				per_password = c.value('@cont','varchar(100)'), per_elabora = c.value('@elabora','int'),
				per_revisa = c.value('@revisa','int'), per_autoriza = c.value('@autoriza','int'),
				IdArea = c.value('@area','int'), Per_Interno = c.value('@tipo','varchar(20)'),
				Per_Email = c.value('@correo','varchar(100)'), Id_Puesto = c.value('@puesto','int')
				from personal b INNER JOIN 
				@Cabecero.nodes('usuario') as t(c) ON b.IdPersonal= @Id
				
			end 
		delete from tbl_UsuarioGrupos where idpersonal = @Id;
		insert into tbl_UsuarioGrupos (idpersonal,IdGrupos ) select @Id, c.value('@grupo','int')
		from @Cabecero.nodes('usuario') as t(c);
		commit tran
	end try
	Begin catch
		rollback
		set @Id = 0;
		DECLARE @ERR VARCHAR(100)
		SET @ERR = ERROR_MESSAGE()
		raiserror(@ERR, 16, 1);
	end catch
END
