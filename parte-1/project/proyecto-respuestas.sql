Respuestas Ejercicio Integrador

KPI General
1 – 
with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes, ols.venta as venta_bruta, venta + coalesce(descuento,0) as venta_neta, c.costo_promedio_usd as costo_usd,
case 
when ols.moneda = 'ARS' then ols.venta / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.venta / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.venta / mafr.cotizacion_usd_eur
end as venta_bruta_usd, 
case
when ols.moneda = 'ARS' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur
end as venta_neta_usd,
case
when ols.moneda = 'ARS' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso ) - c.costo_promedio_usd
when ols.moneda = 'URU' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru ) - c.costo_promedio_usd
when ols.moneda = 'EUR' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur ) - c.costo_promedio_usd
end as margen_usd
from stg.order_line_sale as ols
left join stg.cost as c
on ols.producto = c.codigo_producto
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(venta_bruta_usd) as total_ventas_brutas_usd, sum(venta_neta_usd) as total_ventas_netas_usd, sum(margen_usd) as total_margen_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


2 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes, ols.venta as venta_bruta, venta + coalesce(descuento,0) as venta_neta, c.costo_promedio_usd as costo_usd,
case 
when ols.moneda = 'ARS' then ols.venta / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.venta / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.venta / mafr.cotizacion_usd_eur
end as venta_bruta_usd, 
case
when ols.moneda = 'ARS' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur
end as venta_neta_usd,
case
when ols.moneda = 'ARS' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso ) - c.costo_promedio_usd
when ols.moneda = 'URU' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru ) - c.costo_promedio_usd
when ols.moneda = 'EUR' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur ) - c.costo_promedio_usd
end as margen_usd,
pm.categoria as categoria_prod
from stg.order_line_sale as ols
left join stg.cost as c
on ols.producto = c.codigo_producto
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
left join stg.product_master as pm
on ols.producto = pm.codigo_producto
)
select anio, mes, categoria_prod, sum(margen_usd) as total_margen_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes, stg_ventas.categoria_prod
order by stg_ventas.anio asc, stg_ventas.mes asc, stg_ventas.categoria_prod asc


3 – with stg_productos as (
select i.tienda, sm.nombre as nombre_tienda, i.sku as codigo_producto, extract(year from cast(i.fecha as date)) as anio, extract(month from cast(i.fecha as date)) as mes, concat(extract(year from cast(i.fecha as date)),extract(month from cast(i.fecha as date))) as id, (sum(final)-sum(inicial)) / count (distinct fecha) as prom_inventario_mes, c.costo_promedio_usd, ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd as costo_inv_mes_usd,
	case
	when ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd < 0 then 0
	else ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd
	end as ajust_costo_inv_mes_usd
from stg.inventory as i 
left join stg.store_master as sm 
on i.tienda = sm.codigo_tienda
left join stg.cost as c
on i.sku = c.codigo_producto
group by i.tienda, sm.nombre, i.sku, c.costo_promedio_usd, extract(year from cast(i.fecha as date)), extract(month from cast(i.fecha as date)) 
order by i.tienda asc, i.sku asc
),
stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes, ols.venta as venta_bruta, venta + coalesce(descuento,0) as venta_neta, c.costo_promedio_usd as costo_usd,
case 
when ols.moneda = 'ARS' then ols.venta / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.venta / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.venta / mafr.cotizacion_usd_eur
end as venta_bruta_usd, 
case
when ols.moneda = 'ARS' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur
end as venta_neta_usd,
case
when ols.moneda = 'ARS' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso ) - c.costo_promedio_usd
when ols.moneda = 'URU' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru ) - c.costo_promedio_usd
when ols.moneda = 'EUR' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur ) - c.costo_promedio_usd
end as margen_usd,
pm.categoria as categoria_prod
from stg.order_line_sale as ols
left join stg.cost as c
on ols.producto = c.codigo_producto
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
left join stg.product_master as pm
on ols.producto = pm.codigo_producto
),
stg_ventas_varios as (
select anio, mes, concat (anio,mes) as id, sum(venta_neta_usd) as total_ventas_netas_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc
)
select stg_productos.anio, stg_productos.mes, sum(stg_productos.ajust_costo_inv_mes_usd) / sum(stg_ventas_varios.total_ventas_netas_usd) as roi
from stg_productos
left join stg_ventas_varios
on stg_productos.id = stg_ventas_varios.id
group by stg_productos.anio, stg_productos.mes, stg_ventas_varios.total_ventas_netas_usd
order by stg_productos.anio asc, stg_productos.mes asc


4 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes, ols.venta as venta_bruta, venta + coalesce(descuento,0) as venta_neta, c.costo_promedio_usd as costo_usd,
case 
when ols.moneda = 'ARS' then ols.venta / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.venta / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.venta / mafr.cotizacion_usd_eur
end as venta_bruta_usd, 
case
when ols.moneda = 'ARS' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur
end as venta_neta_usd,
case
when ols.moneda = 'ARS' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso ) - c.costo_promedio_usd
when ols.moneda = 'URU' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru ) - c.costo_promedio_usd
when ols.moneda = 'EUR' then ( (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur ) - c.costo_promedio_usd
end as margen_usd
from stg.order_line_sale as ols
left join stg.cost as c
on ols.producto = c.codigo_producto
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(venta_neta_usd)/count(distinct orden) as aov
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


KPI Contabilidad
5 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes,
case 
when ols.moneda = 'ARS' then ols.impuestos / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.impuestos / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.impuestos / mafr.cotizacion_usd_eur
end as impuestos_pagados_usd 
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(impuestos_pagados_usd) as total_impuestos_pagados_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


6 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes,
case
when ols.moneda = 'ARS' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then (ols.venta + coalesce(ols.descuento,0)) / mafr.cotizacion_usd_eur
end as venta_neta_usd,
case 
when ols.moneda = 'ARS' then ols.impuestos / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ols.impuestos / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ols.impuestos / mafr.cotizacion_usd_eur
end as impuestos_pagados_usd 
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(impuestos_pagados_usd)/sum(venta_neta_usd) as tasa_de_impuesto
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


7 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes,
case 
when ols.moneda = 'ARS' then coalesce(ols.creditos,0) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then coalesce(ols.creditos,0) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then coalesce(ols.creditos,0) / mafr.cotizacion_usd_eur
end as creditos_usd 
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(creditos_usd)*(-1) as cantidad_de_creditos_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


8 – with stg_ventas as (
select ols.*, extract(year from ols.fecha) as anio, extract(month from ols.fecha) as mes,
case
when ols.moneda = 'ARS' then ( ols.venta + coalesce(ols.descuento,0) + ols.impuestos + coalesce(ols.creditos,0) ) / mafr.cotizacion_usd_peso
when ols.moneda = 'URU' then ( ols.venta + coalesce(ols.descuento,0) + ols.impuestos + coalesce(ols.creditos,0) ) / mafr.cotizacion_usd_uru
when ols.moneda = 'EUR' then ( ols.venta + coalesce(ols.descuento,0) + ols.impuestos + coalesce(ols.creditos,0) ) / mafr.cotizacion_usd_eur
end as valor_pagado_final_usd
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr
on date_part('month',ols.fecha) = date_part('month',mafr.mes)
)
select anio, mes, sum(valor_pagado_final_usd) as total_valor_pagado_final_usd--, sum(venta_neta_usd) as total_ventas_netas_usd, sum(margen_usd) as total_margen_usd
from stg_ventas
group by stg_ventas.anio, stg_ventas.mes
order by stg_ventas.anio asc, stg_ventas.mes asc


KPI Supply chain
9 – with stg_productos as (
select i.tienda, sm.nombre as nombre_tienda, i.sku as codigo_producto, extract(year from cast(i.fecha as date)) as anio, extract(month from cast(i.fecha as date)) as mes, concat(extract(year from cast(i.fecha as date)),extract(month from cast(i.fecha as date))) as id, (sum(final)-sum(inicial)) / count (distinct fecha) as prom_inventario_mes, c.costo_promedio_usd, ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd as costo_inv_mes_usd,
	case
	when ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd < 0 then 0
	else ((sum(final)-sum(inicial)) / count (distinct fecha) )*c.costo_promedio_usd
	end as ajust_costo_inv_mes_usd
from stg.inventory as i 
left join stg.store_master as sm 
on i.tienda = sm.codigo_tienda
left join stg.cost as c
on i.sku = c.codigo_producto
group by i.tienda, sm.nombre, i.sku, c.costo_promedio_usd, extract(year from cast(i.fecha as date)), extract(month from cast(i.fecha as date)) 
order by i.tienda asc, i.sku asc
)
select anio, mes, tienda, nombre_tienda, sum(ajust_costo_inv_mes_usd)/count(ajust_costo_inv_mes_usd) as costo_inventario_promedio_usd
from stg_productos
group by anio, mes, tienda, nombre_tienda
order by anio asc, mes asc, tienda asc


10 – with stg_productos_inventario as  
-- query para obtener el inventario promedio por día
(
select
	i.tienda as tienda_inv,
	i.sku,
	i.fecha as fecha_inv,
	i.inicial,
	i.final,
	(final+inicial)/2 as inventario_promedio_diario,
	c.costo_promedio_usd as costo_promedio_usd,
	(final+inicial)/2 *	c.costo_promedio_usd as costo_usd_inventario_promedio_diario
from stg.inventory as i
inner join stg.cost as c
on i.sku = c.codigo_producto
order by i.tienda asc, i.sku asc, i.fecha asc
),
stg_inventario_productos_no_vendidos as (
select *
from stg_productos_inventario as i
left join stg.order_line_sale as ols
on ols.tienda = i.tienda_inv and ols.producto = i.sku and ols.fecha = i.fecha_inv
where ols.orden is null
)
select
	extract(year from ipnv.fecha_inv) as anio,
	extract(month from ipnv.fecha_inv) as mes,
	ipnv.tienda_inv,
	ipnv.sku,
	sum(ipnv.costo_usd_inventario_promedio_diario) as sumatoria_costo_usd_inventario
from stg_inventario_productos_no_vendidos as ipnv
group by extract(year from ipnv.fecha_inv), extract(month from ipnv.fecha_inv), ipnv.tienda_inv, ipnv.sku
order by extract(year from ipnv.fecha_inv) asc, extract(month from ipnv.fecha_inv) asc, ipnv.tienda_inv asc, ipnv.sku asc


11 – with stg_return_movements_adjust as
(
select 
	extract(year from fecha) as anio,
	extract(month from fecha) as mes,
	item,
	cantidad
from stg.return_movements
group by extract(year from fecha), extract(month from fecha), item, cantidad
order by extract(year from fecha) asc, extract(month from fecha) asc, item asc
),
stg_return_movements_adjust_with_cost as
(
select 
	rma.*,
	c.costo_promedio_usd, 
	rma.cantidad * c.costo_promedio_usd as devolution_cost_usd
from stg_return_movements_adjust as rma
inner join stg.cost as c
on rma.item = c.codigo_producto
order by anio asc, mes asc, item asc
)
select 
	anio,
	mes,
	sum (cantidad) as cantidad_total_devoluciones,
	sum (devolution_cost_usd) as costo_total_devoluciones_usd
from stg_return_movements_adjust_with_cost
group by anio, mes
order by anio asc, mes asc


KPI Tiendas
12 – with stg_ordenes_generadas as 
(
select 
	tienda,
	extract(year from fecha) as anio,
	extract(month from fecha) as mes,
	count (distinct orden) as cantidad_ordenes_generadas
from stg.order_line_sale
group by extract(year from fecha), extract(month from fecha), tienda
order by extract(year from fecha) asc, extract(month from fecha) asc, tienda asc
),
stg_cantidad_gente_que_entra as
(
select
	tienda,
	extract(year from cast(fecha as date)) as anio,
	extract(month from cast(fecha as date)) as mes,
	sum (conteo) as cantidad_gente_que_entra
from stg.super_store_count
group by extract(year from cast(fecha as date)), extract(month from cast(fecha as date)), tienda
order by extract(year from cast(fecha as date)) asc, extract(month from cast(fecha as date)) asc, tienda asc
)
select
	cgqe.anio,
	cgqe.mes,
	cgqe.tienda,
	cgqe.cantidad_gente_que_entra,
	coalesce(og.cantidad_ordenes_generadas,0) as cantidad_ordenes_generadas,
	coalesce((og.cantidad_ordenes_generadas*1.0),0)/(cgqe.cantidad_gente_que_entra*1.0) as ratio_de_conversion
from stg_cantidad_gente_que_entra as cgqe
left join stg_ordenes_generadas as og
on cgqe.tienda = og.tienda
and cgqe.anio = og.anio
and cgqe.mes = og.mes

Return_movements
13 - DROP TABLE IF EXISTS stg.return_movements ;
    
CREATE TABLE stg.return_movements
                 (
                          	 orden_venta		VARCHAR(10) not null
                            , envio				VARCHAR(6) not null
                            , item				VARCHAR(7) not null
 							              , cantidad			SMALLINT not null
					 		              , id_movimiento		INT not null
					 		              , desde				VARCHAR(255) not null
					 		              , hasta				VARCHAR(255) not null
					 		              , recibido_por		VARCHAR(255)
					 		              , fecha				DATE not null
                 );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.return_movements
-- Se importan los datos y finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.return_movements


 
Preguntas de entrevistas
1 – Para encontrar duplicados puedo correr una query de validación, tal como se muestra a continuación para el ejemplo de las órdenes de venta en la tabla de ventas (order_line_sale)
select line_key, count(1)
from stg.order_line_sale
group by line_key
having count(1)>1
En este caso, se observa 1 line_key que aparecen más de 1 vez: la orden M999000061 para el producto p200087 aparece 3 veces.


2 – Para borrar duplicados (en este caso de la tabla order_line_sale) se puede realizar lo siguiente:
Primero creo una copia de la tabla orde_line_sale y le agrego una columna adicional (fila_numero) que permita identificar repetidos
select *, row_number() over (partition by line_key order by line_key) as fila_numero
into stg.order_line_sale_2
from stg.order_line_sale
Visualizo el contenido de la tabla order_line_sale_2 con la siguiente línea de código:
select * from stg.order_line_sale_2
Finalmente, para borrar el contenido duplicado utilizo la siguiente línea de código
delete from stg.order_line_sale_2 where fila_numero != 1


3 –La diferencia radica en que UNION permite generar una nueva tabla a partir de otras 2 uniéndolas entre sí pero sin generar registros repetidos; mientras que UNION ALL permite generar una nueva tabla a partir de otras 2 uniéndolas entre sí pero generando registros repetidos.
A continuación se muestra un ejemplo descriptivo que clarifica lo expuesto anteriormente.
-- Creamos la Tabla A
DROP TABLE IF EXISTS stg.table_A ;
CREATE TABLE stg.table_A ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_A
-- Se insertan los datos 
INSERT INTO stg.table_A values (1), (2), (3), (4);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_A
-- Procedemos de la misma manera con la Tabla B
-- Creamos la Tabla B
DROP TABLE IF EXISTS stg.table_B ;
CREATE TABLE stg.table_B ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_B
-- Se insertan los datos 
INSERT INTO stg.table_B values (3), (4), (5), (6);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_B
-- Ahora hacemos UNION de Tabla_A con Tabla_B
select * from stg.table_A
UNION select * from stg.table_B
order by id asc
-- Devuelve una tabla con 6 registros (1, 2, 3, 4, 5, 6)
-- Ahora hacemos UNION de Tabla_A con Tabla_B
select * from stg.table_A
UNION ALL select * from stg.table_B
order by id asc
-- Devuelve una tabla con 8 registros (1, 2, 3, 3, 4, 4, 5, 6)
-- De esta manera se puede observar como UNION eliminó los registros duplicados; mientras que UNION ALL mantuvo la totalidad de registros de cada tabla y los incorporó sin hacer distinción en si se encontraban repetidos o no.


4 – Si nos interesa saber sólo aquellos registros de una tabla (por ejemplo, Tabla A) que se encuentran repetidos en otra tabla (Tabla B) se puede utilizar un INNER JOIN.
Por otra parte, si nos interesa saber aquellos registros de una tabla (por ejemplo, Tabla A) si se encuentran repetidos o no en otra tabla (Tabla B) se puede utilizar un LEFT JOIN. En este último caso, donde aparezcan los valores NULL serán aquellos registros no coincidentes; por el contrario, donde no aparezcan valores NULL serán aquellos registros coincidentes.
A continuación se muestra un ejemplo descriptivo que clarifica lo expuesto anteriormente.
-- Creamos la Tabla A
DROP TABLE IF EXISTS stg.table_A ;
CREATE TABLE stg.table_A ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_A
-- Se insertan los datos 
INSERT INTO stg.table_A values (1), (2), (3), (4);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_A
-- Procedemos de la misma manera con la Tabla B
-- Creamos la Tabla B
DROP TABLE IF EXISTS stg.table_B ;
CREATE TABLE stg.table_B ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_B
-- Se insertan los datos 
INSERT INTO stg.table_B values (3), (4), (5), (6);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_B
-- Ahora hacemos INNER JOIN de Tabla_A con Tabla_B
select * from stg.table_A
INNER JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
-- Devuelve 2 coincidencias: el 3 y el 4
-- Ahora hacemos LEFT JOIN de Tabla_A con Tabla_B
select * from stg.table_A
LEFT JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
-- Devuelve 2 coincidencias (el 3 y el 4) y 2 no coincidencias (el 1 y el 2, que son los que se encuentran asociados a los valores NULL)
-- Concretamente, si se deseasen ver sólo las no coincidencias se puede hacer lo siguiente
select * from stg.table_A
LEFT JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
where table_B.id is null
-- Pero si se deseasen ver sólo las coincidencias se puede hacer lo siguiente
select * from stg.table_A
LEFT JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
where table_B.id is not null
-- Este último caso sería lo mismo que haber hecho el INNER JOIN



5 – Los JOIN son formas de unir tablas. La diferencia radica en que INNER JOIN permite generar una nueva tabla a partir de otras 2 mostrando como resultado sólo aquellos registros que cumplan con la condición impuesta en el campo clave. Mientras que LEFT JOIN permite generar una nueva tabla a partir de otras 2 mostrando como resultado tanto los registros de la primer tabla que tienen coincidencia con los registros de la segunda tabla, así como también los registros de la primer tabla que no tengan coincidencia con los registros de la segunda tabla.
En otras palabras, INNER JOIN devuelve sólo los registros que posean una coincidencia entre ambas tablas; mientras que LEFT JOIN devuelve todos los registros de la primera tabla, tanto sean coincidentes como no coincidentes con los registros de la segunda tabla.
A continuación se muestra un ejemplo descriptivo que clarifica lo expuesto anteriormente.
-- Creamos la Tabla A
DROP TABLE IF EXISTS stg.table_A ;
CREATE TABLE stg.table_A ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_A
-- Se insertan los datos 
INSERT INTO stg.table_A values (1), (2), (3), (4);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_A
-- Procedemos de la misma manera con la Tabla B
-- Creamos la Tabla B
DROP TABLE IF EXISTS stg.table_B ;
CREATE TABLE stg.table_B ( id INT primary key not null );
--Luego, para chequear que se ha creado correctamente (aunque su contenido es vacío) ejecuto la siguiente línea de código:
select * from stg.table_B
-- Se insertan los datos 
INSERT INTO stg.table_B values (3), (4), (5), (6);
-- Finalmente se vuelve a correr para chequear que los datos fueron ingresados correctamente
select * from stg.table_B
-- Ahora hacemos INNER JOIN de Tabla_A con Tabla_B
select * from stg.table_A
INNER JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
-- Devuelve una tabla de 2 columnas con 2 registros (3, 3) y (4, 4), es decir, sólo mostró los registros coincidentes.
-- Ahora hacemos LEFT JOIN de Tabla_A con Tabla_B
select * from stg.table_A
LEFT JOIN stg.table_B
on stg.table_A.id = stg.table_B.id
-- Devuelve una tabla de 2 columnas con 4 registros (1, null), (2, null), (3, 3) y (4, 4), es decir, la tabla A original con los registros coincidentes de la tabla B  y en caso de no haber coincidencia asignó NULL.
-- De esta manera, se puede observar como INNER JOIN mostró los registros coincidentes de ambas tablas; mientras que LEFT JOIN mantuvo la totalidad de registros de la primer tabla y le incorporó un campo con los registros coincidentes y en caso de los no coincidentes les asignó el valor NULL.

