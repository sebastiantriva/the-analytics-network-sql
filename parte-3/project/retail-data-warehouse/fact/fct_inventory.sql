/* Crea tabla inventory
Conteo de inventario al inicio y final del dia por fecha, tienda y codigo
*/
DROP TABLE IF EXISTS fct.inventory

CREATE TABLE fct.inventory
(
      id_inventory  INTEGER PRIMARY KEY,
      tienda        SMALLINT,
      sku           VARCHAR(10),
      fecha         DATE,
      inicial       SMALLINT,
      final         SMALLINT,
      
      constraint fk_tienda_id_inventory
      foreign key (tienda)
      references dim.store_master (codigo_tienda),
      
      constraint fk_sku_id_inventory
      foreign key (sku)
      references dim.product_master (codigo_producto)
);
