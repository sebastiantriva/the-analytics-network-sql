/* Crea tabla order_line_sales
Ventas a nivel numero de orden, item.
*/
DROP TABLE IF EXISTS fct.order_line_sale;
    
CREATE TABLE fct.order_line_sale
(
        id_orden   INTEGER PRIMARY KEY,
        orden      VARCHAR(10),
        producto   VARCHAR(10),
        tienda     SMALLINT,
        fecha      DATE,
        cantidad   INTEGER,
        venta      DECIMAL(18,5),
        descuento  DECIMAL(18,5),
        impuestos  DECIMAL(18,5),
        creditos   DECIMAL(18,5),
        moneda     VARCHAR(3),
        pos        SMALLINT,
        is_walkout BOOLEAN
    
        constraint fk_product_id_order_line_sale
        foreign key (producto)
        references dim.product_master (codigo_producto),
    
        constraint fk_tienda_id_order_line_sale
        foreign key (tienda)
        references dim.store_master (codigo_tienda)
);
