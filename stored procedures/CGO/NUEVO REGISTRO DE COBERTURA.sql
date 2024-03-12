
select id_inmueble as 'td','', inmueble as 'td','', id_empleado as 'td','', nombre as 'td','',
convert(varchar(12),fecha,103) as 'td','', mov as 'td','',(select 'Buscar' as '@value', 'btbusca btn btn-info' as '@class', 'button' as '@type' for xml path('input'), root('td'),type),'',
(select 'disabled' as '@disabled', 'form-control' as '@class', 'text' as '@type', case when cubre is not null then cubre end  as '@value' for xml path('input'), root('td'),type),'',
(select 'disabled' as '@disabled', 'form-control' as '@class', 'text' as '@type', case when cubre is not null then empleado  end  as '@value' for xml path('input'), root('td'),type),'', 
case when cubre is not null then
(select 'Borrar' as '@value', 'btquita btn btn-danger' as '@class', 'button' as '@type' for xml path('input'),type) 
else '' end as 'td','',
case when cubre is not null then '1' else '0' end as 'td','', case when cubre is not null then tipoemp else '0' end as 'td', '', posicion as 'td' from (
select b.id_inmueble, c.nombre as inmueble, 0 as id_empleado,'POSICION VACANTE' as nombre, '26/03/2021' as fecha,'VACANTE' as mov, isnull(d.cubre,0) cubre,
isnull(e.paterno + ' ' + rtrim(e.materno) + ' ' + e.nombre,'') empleado,
case when d.cubre is not null then '1' else '0' end as cubierto, case when d.cubre is not null then d.tipoemp else '0' end as tipoemp, a.posicion
from tb_cliente_plantillap a inner join tb_cliente_plantilla b on a.id_plantilla = b.id_plantilla
inner join tb_cliente_inmueble c on b.id_inmueble = c.id_inmueble
left outer join tb_empleado_cubre d on  d.id_periodo = 13 and  d.tipo = 'Semanal' and d.anio = 2021 and a.posicion = d.posicion and c.id_inmueble = d.id_inmueble and  d.fecha = '20210326'
left outer join tb_empleado e on d.cubre = e.id_empleado
where a.id_empleado =0
union all 
select a.id_inmueble, b.nombre as inmueble, a.id_empleado, c.paterno + ' ' +  rtrim(c.materno) + ' ' + c.nombre as nombre,
convert(varchar(12),a.fecha,103) as fecha, a.movimiento as mov,isnull(d.cubre,0) cubre, isnull(e.paterno + ' ' + rtrim(e.materno) + ' ' + e.nombre,'') empleado,
case when d.cubre is not null then '1' else '0' end as cubierto, case when d.cubre is not null then d.tipoemp else '0' end as tipoemp, f.posicion
from tb_empleado_asistencia a inner join tb_cliente_inmueble b on a.id_inmueble = b.id_inmueble
inner join tb_empleado c on a.id_empleado = c.id_empleado
left outer join tb_empleado_cubre d on a.id_periodo = d.id_periodo and a.tipo = d.tipo and a.anio = d.anio and a.id_empleado = d.id_empleado and a.id_inmueble = d.id_inmueble and a.fecha = d.fecha
left outer join tb_empleado e on d.cubre = e.id_empleado
left outer join tb_cliente_plantillap f on c.id_empleado = f.id_empleado
where a.id_periodo = 13 and a.anio = 2021 and a.tipo ='Semanal'
and movimiento in('F','FJ','V', 'IEG', 'IRT') and b.id_cliente = 115
and a.id_inmueble = 1418
and a.fecha = '20210326') as result order by posicion, nombre for xml path('tr'), root('tbody')