/* 1. Listado de todos los circuitos, así como el número de grandes premios que ha
albergado cada uno. El listado estará ordenado del circuito que haya acogido más
carreras al que menos */
\pset pager off

\echo 'Numero de grandes premios albergados por circuito\n'

SELECT
    c.nombre AS nombre_circuito,
    COUNT(gp.circuitoRef) AS numero_de_gps
FROM final.circuito AS c
JOIN final.granPremio AS gp ON c.circuitoRef = gp.circuitoRef
GROUP BY c.circuitoRef
ORDER BY numero_de_gps DESC;