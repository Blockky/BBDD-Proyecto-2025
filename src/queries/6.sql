/* Nombre de los pilotos que han ganado, al menos, un GP (posición = 1) */
\pset pager off

\echo 'Pilotos que han ganado al menos un GP\n'

SELECT
    p.nombre AS nombre
FROM final.piloto p
JOIN final.corre c ON p.pilotoRef = c.pilotoRef
WHERE c.posicion = 1
GROUP BY p.pilotoRef;