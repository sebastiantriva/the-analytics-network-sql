-- Table: de empleados

DROP TABLE IF EXISTS dim.employees;

CREATE TABLE dim.employees
          (
              id_employee           integer NOT NULL PRIMARY KEY,
              nombre                character varying (255) NOT NULL,
              apellido              character varying (255) NOT NULL,
              fecha_entrada         date NOT NULL,
              fecha_salida          date,
              telefono              character varying (255),
              pais                  character varying (100) NOT NULL,
              provincia             character varying (100) NOT NULL,
              codigo_tienda         smallint NOT NULL,
              posicion              character varying (255) NOT NULL
          );
