/* 7. Número de Grandes Premios por país*/
\pset pager off

\echo 'Número de Grandes Premios por país\n'

SELECT
    c.pais as "Pais", 
    COUNT(c.circuitoref) AS "Num GPs"
FROM final.granpremio AS gp 
JOIN final.circuito AS c ON gp.circuitoref = c.circuitoref
GROUP BY "Pais";