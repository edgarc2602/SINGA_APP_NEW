select * from tb_vacante 

select id_vacante as 'td','', b.nombre as 'td','',  puntoatn as 'td','', d.nombre + ' '+ d.paterno + ' ' + d.materno as 'td','',
convert(varchar(10), fechaalta, 103) as 'td','', CASE WHEN id_tipo = 1 then 'Urgente' else 'Programada' end as 'td','',
e.nombre + ' '+ e.paterno + ' ' + e.materno as 'td','',  convert(varchar(10),fechaobj,103) as 'td','',
case when DATEDIFF(day, getdate() , fechaobj) = 5 and id_tipo = 1 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
	 when DATEDIFF(day, getdate() , fechaobj) = 2 and id_tipo = 1 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
	 when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 1 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
	 when DATEDIFF(day, getdate() , fechaobj) = 10 and id_tipo = 2 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
	 when DATEDIFF(day, getdate() , fechaobj) = 5 and id_tipo = 2 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
	 when DATEDIFF(day, getdate() , fechaobj) <= 0 and id_tipo = 2 then (select 'colorverde' as '@class', 'ALERTA' as 'text()' for xml path('span'), type)
end as 'td','', isnull(g.nombre + ' ' + g.paterno, ' ') as 'td','',
direccion + ' ' + colonia + ' ' + delmun + ' ' + cp + ' ' + c.descripcion as 'td','',
cast(a.sueldo as numeric(12,2)) as 'td','', case when sexo = 1 then 'Masculino' when sexo = 2 then 'Femenino' else 'Indistinto' end as 'td','',
'Turno: ' + f.descripcion + ', Horario:' + horariode + ' a ' + horarioa + ' Dias laborables: ' + diasde + ' a ' + diasa + ' Descanso: ' + diasdes as 'td'
from tb_vacante a inner join tb_cliente b on a.id_cliente = b.id_cliente 
inner join tb_estado c on a.id_estado = c.id_estado 
inner join tb_empleado d on a.id_operativo = d.id_empleado
inner join tb_empleado e on b.id_coordinadorrh = e.id_empleado
left outer join tb_empleado g on a.id_reclutador = g.id_empleado 
inner join tb_turno f on a.id_turno = f.id_turno --for xml path('tr'), root('tbody')