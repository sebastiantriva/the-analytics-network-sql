/* Crea tabla market_count
*/
DROP TABLE IF EXISTS fct.market_count;
    
CREATE TABLE fct.market_count
(
        id_market_count     INTEGER PRIMARY KEY,
        tienda              SMALLINT,
        fecha               INTEGER,
        conteo              SMALLINT,
);
