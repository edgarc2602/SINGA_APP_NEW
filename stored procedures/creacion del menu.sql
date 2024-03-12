with grupos 
	as (
		select IdProceso,IdArea,sub,Ar_Path 
		from (
				select IdProceso,IdArea,case when IdProceso=1 then 'Catalogo' when IdProceso=2 then 'Proceso' 
				when IdProceso=3 then 'Consultas' else Ar_Label end sub,
				case when IdProceso in(1,2,3) then '#' else Ar_Path end Ar_Path
				from tbl_UsuarioGrupos a inner join Tbl_Per_Grupos_Formas b on b.IdGrupos=a.IdGrupos
				inner join Tbl_Formularios c on c.IdForma=b.idformulario where a.idpersonal=6) as tabla group by IdProceso,IdArea,sub,Ar_Path
			)
		select 'sidebar-menu' as '@class', (
		select 'treeview' as '@class', e.ar_icon as 'a/i/@class','' as 'a/i/text()', e.ar_nombre as 'a/span','fa fa-angle-left pull-right' as 'a/i/@class'

,
(  
	select 'treeview-menu' as '@class', (
	select Ar_Path as 'a/@href', 'fa fa-circle-o' as 'a/i/@class', secciones.sub as 'a/text()',
	(select 'treeview-menu' as '@class',(
		select  c2.Ar_Path as 'a/@href', 'fa fa-circle-o' as 'a/i/@class', c2.Ar_Label as 'a/text()'
		from tbl_UsuarioGrupos a2 inner join  Tbl_Per_Grupos_Formas b2 on a2.IdGrupos = b2.IdGrupos 
		inner join Tbl_Formularios c2 on b2.idformulario = c2.IdForma
		inner join Tbl_Area_Menu d2 on c2.IdArea = d2.IdArea 
		where a2.idpersonal = 6 and c2.IdProceso <> 0 and  d2.IdArea= e.IdArea and c2.IdProceso = secciones.IdProceso
	 for xml path('li'),type)
	 for xml path('ul'),type)
	from grupos as secciones 
	where  secciones.IdArea = e.idarea 
	for xml path('li'), type)
	for xml path('ul'), type
)
from Tbl_Area_Menu as e 
order by e.Ar_Posicion for xml path('li'), type)
for xml path('ul')


