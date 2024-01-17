/*select Inv_Codigoalm ,COUNT(Inv_Codigoalm)from INVENTARIO 
where inv_status=0
group by Inv_Codigoalm 
having COUNT(Inv_Codigoalm)>1
*/
--select inv_codigoalm from (
select a.Idinventario,inv_codigoalm,No_Catalogo_prove='',Inv_Articulo,color='',Alm_Descripcion ,COSTO.Kd_CostoUnitario,C.uni_descripcion
,r.Idproveedor,r.pro_RazonSocial,Kd_Fecha,A.Inv_existencia
from INVENTARIO A INNER JOIN Almacen B ON A.IdAlmacen=B.IdAlmacen
LEFT OUTER JOIN (SELECT *FROM (
(SELECT ROW_NUMBER() OVER (PARTITION BY IdInventario ORDER BY IdInventario, Kd_Fecha DESC,idkardex DESC) AS rn,
idkardex,IdInventario,Kd_CostoUnitario,Kd_Fecha
FROM KARDEX )) AS RES WHERE RN=1) COSTO ON COSTO.IdInventario=A.Idinventario
INNER JOIN UnidadMedida C ON C.idunidadmedida=A.idUnidadMedida
left outer join (
select *from (
SELECT ROW_NUMBER() OVER (PARTITION BY a.IdInventario ORDER BY a.IdInventario,b.ordcom_fecrecibido desc,ordcom_fecent
--, Kd_Fecha DESC,idkardex DESC
) AS rn, b.Idproveedor,a.Idinventario,c.pro_RazonSocial
--k.IdInventario,k.idordcom,b.ordcom_clave,b.Idproveedor,c.pro_RazonSocial,a.orddet_precio,a.orddet_unidad
FROM --KARDEX k inner join orden_detalle a on k.Idordcomp=a.IdOrden_Detalle
orden_detalle a inner join ORDEN_COM b on b.Idordcom=a.Idordcom inner join Proveedor c on c.Idproveedor=b.Idproveedor
--left outer join KARDEX k on k.Idordcomp=a.IdOrden_Detalle
--where IdDocumento=11 and IdSolicitud is NULL and IdOrden is NULL and k.idordcom like 'M-%' 
) as r where rn=1

) r on r.IdInventario=A.Idinventario
where inv_status=0 --and r.Idproveedor is null
and (Kd_Fecha is null or Kd_Fecha > '2014-01-01')
and Inv_existencia>0
order by Alm_Descripcion,Inv_Codigoalm
--) as rs group by inv_codigoalm having COUNT(inv_codigoalm)>1


