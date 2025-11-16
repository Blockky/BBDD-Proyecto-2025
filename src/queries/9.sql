/* 9. Número de paradas en boxes por piloto en el gran premio de Mónaco de 2023. */

\pset pager off

\echo 'Parada por piloto en GP monaco 2023\n'

SELECT
    p.nombre AS nombre,
    p.apellido AS apellido,
    COUNT(b.pilotoRef) AS boxes
FROM final.boxes b 
JOIN final.circuito c ON c.circuitoRef = b.circuitoRef
JOIN final.piloto p ON b.pilotoRef = p.pilotoRef
WHERE b.anno = 2023 and c.pais = 'Monaco'
GROUP BY (p.nombre, p.apellido);