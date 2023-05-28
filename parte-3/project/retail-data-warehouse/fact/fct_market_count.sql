/* Crea tabla market_count
*/
DROP TABLE IF EXISTS fct.market_count;
    
CREATE TABLE fct.market_count
                 (
                              tienda SMALLINT   PRIMARY KEY
                            , fecha  INTEGER
                            , conteo SMALLINT
                 );
