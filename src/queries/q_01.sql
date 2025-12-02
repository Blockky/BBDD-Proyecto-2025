/* 1. Listado de todos los circuitos, así como el número de grandes premios que ha
albergado cada uno. El listado estará ordenado del circuito que haya acogido más
carreras al que menos */
\pset pager off

\echo 'Numero de grandes premios albergados por circuito\n'

SELECT
    c.nombre AS "Nombre del circuito",
    COUNT(gp.circuitoRef) AS "Num de GPs"
FROM final.circuito AS c
JOIN final.granPremio AS gp ON c.circuitoRef = gp.circuitoRef
GROUP BY c.circuitoRef
ORDER BY "Num de GPs" DESC;