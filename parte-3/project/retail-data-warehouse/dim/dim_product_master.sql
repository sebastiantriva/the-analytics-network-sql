/* Crear tabla products
Maestro de productos que posee la empresa. 
is_active indica que productos estan actualmente a la venta
*/

DROP TABLE IF EXISTS dim.product_master ;
    
CREATE TABLE dim.product_master
(
	codigo_producto VARCHAR(255) PRIMARY KEY,
	nombre          VARCHAR(255),
	categoria       VARCHAR(255),
	subcategoria    VARCHAR(255),
	subsubcategoria VARCHAR(255),
	material        VARCHAR(255),
	color           VARCHAR(255),
	origen          VARCHAR(255),
	ean             bigint,
	is_active       boolean,
	has_bluetooth   boolean,
	talle           VARCHAR(255),
                     
	constraint fk_codigo_producto_product_master
	foreign key (product_id)
	references dim.order_line_sale(producto)
);
