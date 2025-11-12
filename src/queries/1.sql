/* 1. Listado de todos los circuitos, así como el número de grandes premios que ha
albergado cada uno. El listado estará ordenado del circuito que haya acogido más
carreras al que menos */

\echo 'Listado de circuitos y gps que albergó'

SELECT
    c.nombre AS circuito,
    COUNT(gp.circuitoRef) AS numeroGPS
FROM final.circuito c
JOIN final.granPremio gp ON c.circuitoRef = gp.circuitoRef
GROUP BY c.circuitoRef
ORDER BY numeroGPS DESC;
