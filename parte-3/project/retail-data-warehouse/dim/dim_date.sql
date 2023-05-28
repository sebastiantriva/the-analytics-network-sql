-- Table calendario

DROP TABLE IF EXISTS dim.date;

CREATE TABLE dim.date
              (
                  fecha                 date,
                  anio                  integer,
                  mes                   integer,
                  dia_de_semana         character varying (10),
                  is_weekend            boolean,
                  mes_text              character varying (10),
                  anio_fiscal           integer,
                  anio_fiscal_text      character varying (6),
                  fiscal_qarter         character varying (2),
                  fecha_anio_anterior   date
              );
