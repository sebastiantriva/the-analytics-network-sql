-- Table: stg.suppliers

DROP TABLE IF EXISTS dim.suppliers;

CREATE TABLE dim.suppliers
(
      id_supplier         INTEGER PRIMARY KEY,
      codigo_producto     VARCHAR (255),
      nombre              VARCHAR (255),
      is_primary          BOOLEAN
);
