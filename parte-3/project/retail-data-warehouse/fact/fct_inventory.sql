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
      final         SMALLINT
);
