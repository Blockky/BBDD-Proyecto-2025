/*Número de Grandes Premios por país*/

SELECT cir.pais as "Pais", COUNT(*) AS "Num Grandes Premios"
FROM (
    SELECT anno,circuitoref,nombregp
    FROM final.granpremio
)gp 
JOIN(
    SELECT circuitoref,pais
    FROM final.circuito
)cir

ON gp.circuitoref = cir.circuitoref
GROUP BY "Pais"
ORDER BY "Num Grandes Premios" DESC;