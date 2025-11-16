/* Número de Grandes Premios por país */

\pset pager off

\echo 'Número de grandes premios por país\n'

SELECT
    c.pais AS pais,
    COUNT(gp.circuitoRef) AS numero_de_gps
FROM final.granPremio gp
JOIN final.circuito c ON c.circuitoRef = gp.circuitoRef
GROUP BY c.pais;