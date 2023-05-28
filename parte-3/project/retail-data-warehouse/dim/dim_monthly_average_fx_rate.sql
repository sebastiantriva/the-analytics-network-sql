/* Crea tabla monthly_average_fx_rate
Promedio de cotizacion mensual de USD a ARS, EUR a ARS y USD a URU
*/
DROP TABLE IF EXISTS dim.monthly_average_fx_rate;
    
CREATE TABLE dim.monthly_average_fx_rate
(
        id_monthly_average_fx_rate    INTEGER PRIMARY KEY,
        anio                          DATE,
        mes                           DATE,
        cotizacion_usd_peso           DECIMAL,
        cotizacion_usd_eur            DECIMAL,
        cotizacion_usd_uru            DECIMAL
);
