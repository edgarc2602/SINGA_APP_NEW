USE [SINGA]
GO
/****** Object:  StoredProcedure [dbo].[sp_Usuario]    Script Date: 05/09/2019 09:59:08 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_puntoatencion]  @Cabecero xml, @Id int output
AS
	declare @cc as varchar(6);
BEGIN
	begin tran	
	begin try
		set @Id = (select c.value('@id','int') from @Cabecero.nodes('inmueble') as t(c));
		if @Id = 0
			begin
				set @Id = (select isnull(max (id_inmueble) + 1,1)  from tb_cliente_inmueble)
				set @cc = RIGHT('000000' + Ltrim(Rtrim(@Id)),6)
				Insert into tb_cliente_inmueble (id_cliente, nombre, nosuc, direccion, entrecalles,cp, colonia, delegacionmunicipio,
				ciudad, id_estado, tel1, tel2,nombrecontacto, emailcontacto,cargocontacto, id_tipoinmueble,id_oficina, presupuestol,
				presupuestoh, presupuestom, CentroCosto)
				select c.value('@idcte','smallint'), c.value('@nombre','varchar(60)'), c.value('@nosuc','varchar(15)'),
				c.value('@calle','varchar(80)'), c.value('@entrecalle','varchar(100)'), c.value('@cp','varchar(5)'),  
				c.value('@colonia','varchar(80)'), c.value('@del','varchar(40)'), c.value('@ciudad','varchar(40)'),
				c.value('@estado','tinyint'), c.value('@tel1','varchar(15)'), c.value('@tel2','varchar(15)'),
				c.value('@contacto','varchar(60)'), c.value('@correo','varchar(80)'), c.value('@cargo','varchar(60)'),
				c.value('@tipo','smallint'), c.value('@oficina','smallint'), c.value('@ptto1','float'),
				c.value('@ptto2','float'), c.value('@ptto3','float'), @cc
				from @Cabecero.nodes('inmueble') as t(c);
				
			end
		else
			begin
				update tb_cliente_inmueble set nombre = c.value('@nombre','varchar(60)'), nosuc = c.value('@nosuc','varchar(15)'),
				direccion = c.value('@calle','varchar(80)'), entrecalles = c.value('@entrecalle','varchar(100)'),
				cp = c.value('@cp','varchar(5)'), colonia = c.value('@colonia','varchar(80)'),
				delegacionmunicipio = c.value('@del','varchar(40)'), ciudad = c.value('@ciudad','varchar(40)'),
				id_estado = c.value('@estado','tinyint'), tel1 = c.value('@tel1','varchar(15)'),
				tel2 = c.value('@tel2','varchar(15)'), nombrecontacto = c.value('@contacto','varchar(60)'),
				emailcontacto = c.value('@correo','varchar(80)'), cargocontacto = c.value('@cargo','varchar(60)'),
				id_tipoinmueble = c.value('@tipo','smallint'), id_oficina = c.value('@oficina','smallint'),
				presupuestol = c.value('@ptto1','float'), presupuestoh = c.value('@ptto2','float'),
				presupuestom = c.value('@ptto3','float')
				from tb_cliente_inmueble b INNER JOIN 
				@Cabecero.nodes('inmueble') as t(c) ON b.id_inmueble= @Id
				
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
