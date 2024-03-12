USE [SINGA]
GO
/****** Object:  StoredProcedure [dbo].[sp_cliente]    Script Date: 09/09/2019 05:44:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_vacante]  @Cabecero xml, @Id int output
AS
	declare @tipo as int,  @fobj as date 
BEGIN
	begin tran	
	begin try
		select @id = c.value('@id','int') , @tipo = c.value('@tipo','tinyint') from @Cabecero.nodes('vacante') as t(c);
		if @tipo = 1
			set @fobj = dateadd(day,5, getdate())
		else
			set @fobj = dateadd(day,10, getdate())

		if @Id = 0
			begin
				set @Id = (select isnull(max (id_vacante) + 1,1)  from tb_vacante)
				Insert into tb_vacante (id_tipo, id_cliente, puntoatn, direccion, colonia , delmun,id_estado, cp , ubicacion, id_operativo,
				sueldo, formapago, sexo, edadde, edada, horariode, horarioa, jornal,id_turno, diasde,
				diasa, diasdes, observacion,fechaalta, fechaobj)
				select c.value('@tipo','tinyint'), c.value('@idcte','smallint'),	
				c.value('@puntoatn','varchar(100)'), c.value('@direccion','varchar(100)'), c.value('@colonia','varchar(60)'),  
				c.value('@delmun','varchar(60)'), c.value('@id_estado','tinyint'), c.value('@cp','varchar(5)'), c.value('@ubicacion','tinyint'),
				c.value('@id_operativo','smallint'), c.value('@sueldo','float'), c.value('@formapago','tinyint'),
				c.value('@sexo','tinyint'), c.value('@edadde','int'), c.value('@edada','int'),
				c.value('@horariode','varchar(15)'), c.value('@horarioa','varchar(15)'), c.value('@jornal','varchar(10)'),
				c.value('@id_turno','tinyint'), c.value('@diasde','varchar(15)'), c.value('@diasa','varchar(15)'),c.value('@diasdes','varchar(15)'),c.value('@observacion','varchar(200)'),
				getdate(), @fobj
				from @Cabecero.nodes('vacante') as t(c);
			end
		else
			begin
				update tb_vacante set id_tipo = c.value('@tipo','tinyint'), id_cliente = c.value('@idcte','smallint'), puntoatn = c.value('@puntoatn','varchar(100)'),
				direccion = c.value('@direccion','varchar(100)'), colonia = c.value('@colonia','varchar(60)'),
				delmun = c.value('@delmun','varchar(60)'), id_estado = c.value('@id_estado','tinyint'), cp = c.value('@cp','varchar(5)'),
				ubicacion = c.value('@ubicacion','tinyint'), id_operativo = c.value('@id_operativo','smallint'),
				sueldo = c.value('@sueldo','float'), formapago = c.value('@formapago','tinyint'),
				sexo = c.value('@sexo','tinyint'), edadde = c.value('@edadde','int'),
				edada = c.value('@edada','int'), horariode = c.value('@horariode','varchar(15)'),
				horarioa = c.value('@horarioa','varchar(15)'), jornal = c.value('@jornal','varchar(10)'),
				id_turno = c.value('@id_turno','tinyint'), diasde = c.value('@diasde','varchar(15)'),
				diasa = c.value('@diasa','varchar(15)'), diasdes = c.value('@diasdes','varchar(15)'), observacion = c.value('@observacion','varchar(200)'),
				fechaobj = @fobj
				from tb_vacante b INNER JOIN
				@Cabecero.nodes('vacante') as t(c) ON b.id_vacante =@Id
			end
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
