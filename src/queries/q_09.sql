/* 9. Número de paradas en boxes por piloto en el gran premio de Mónaco de 2023 */
\pset pager off

\echo 'Número de boxes por piloto del GP de Mónaco de 2023\n'

SELECT
    (p.nombre ||' '|| p.apellido) AS "Nombre", 
    COUNT(*) AS "Num paradas en boxes"
FROM final.piloto AS p
JOIN final.boxes AS b ON p.pilotoref = b.pilotoref
JOIN final.circuito AS c ON b.circuitoref = c.circuitoref
WHERE b.anno = 2023 AND c.pais = 'Monaco'
GROUP BY "Nombre"
ORDER BY "Num paradas en boxes" DESC;