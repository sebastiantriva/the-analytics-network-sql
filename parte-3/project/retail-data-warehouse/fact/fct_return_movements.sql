DROP TABLE IF EXISTS fct.return_movements;

CREATE TABLE fct.return_movements
(
      id_movimiento   integer                   NOT NULL PRIMARY KEY,
      orden_venta     character varying (10)    NOT NULL,
      envio           character varying (6)     NOT NULL,
      item            character varying (7)     NOT NULL,
      cantidad        smallint                  NOT NULL,
      desde           character varying (255)   NOT NULL,
      hasta           character varying (255)   NOT NULL,
      recibido_por    character varying (255),
      fecha           date                      NOT NULL,
      
      constraint fk_orden_venta_id_return_movements
      foreign key (orden_venta)
      references fct.order_line_sale (orden),
    
      constraint fk_item_id_return_movements
      foreign key (item)
      references dim.product_master (codigo_producto),
      
      -- constraint fk_recibido_por_id_return_movements
      -- foreign key (recibido_por)
      -- references dim.employees (id_employee),
);
