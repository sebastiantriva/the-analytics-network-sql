-- Table: stg.return_movements

DROP TABLE IF EXISTS fct.return_movements;

CREATE TABLE fct.return_movements
              (
                  orden_venta     character varying (10)    NOT NULL,
                  envio           character varying (6)     NOT NULL,
                  item            character varying (7)     NOT NULL,
                  cantidad        smallint                  NOT NULL,
                  id_movimiento   integer                   NOT NULL PRIMARY KEY,
                  desde           character varying (255)   NOT NULL,
                  hasta           character varying (255)   NOT NULL,
                  recibido_por    character varying (255),
                  fecha           date                      NOT NULL
              );
