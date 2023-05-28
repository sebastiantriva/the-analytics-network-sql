-- Table: stg.suppliers

DROP TABLE IF EXISTS dim.suppliers;

CREATE TABLE dim.suppliers
              (
                  id_supplier         integer                   PRIMARY KEY,
                  codigo_producto     character varying (255),
                  nombre              character varying (255),
                  is_primary          boolean
              );
