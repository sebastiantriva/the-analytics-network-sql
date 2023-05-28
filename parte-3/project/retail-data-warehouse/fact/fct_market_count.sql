/* Crea tabla market_count
*/
DROP TABLE IF EXISTS fct.market_count;
    
CREATE TABLE fct.market_count
(
        id_market_count     INTEGER PRIMARY KEY,
        tienda              SMALLINT,
        fecha               INTEGER,
        conteo              SMALLINT,
    
        constraint fk_tienda_id_market_count
        foreign key (tienda)
        references dim.store_master (codigo_tienda),
);
