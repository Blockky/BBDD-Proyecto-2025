/*Número de paradas en boxes por piloto en el gran premio de Mónaco de 2023 */

SELECT p.nombre as "Nombre", p.apellido as "Apellido", COUNT(*) AS "Num paradas en boxes"
FROM (
    SELECT pilotoref,nombre,apellido
    FROM final.piloto
)p
JOIN(
    SELECT pilotoref,anno,nombregp
    FROM final.boxes
)b
ON p.pilotoref = b.pilotoref WHERE b.anno = 2023 AND b.nombregp = 'Monaco Grand Prix'
GROUP BY p.nombre,p.apellido
ORDER BY "Num paradas en boxes" DESC;