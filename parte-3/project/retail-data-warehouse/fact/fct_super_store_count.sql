/* Crea tabla super_store_count
*/
DROP TABLE IF EXISTS fct.super_store_count;
    
CREATE TABLE fct.super_store_count
                 (
                              tienda SMALLINT     PRIMARY KEY
                            , fecha  VARCHAR(10)
                            , conteo SMALLINT
                 );
