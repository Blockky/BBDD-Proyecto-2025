/* 6. Nombre de los pilotos que han ganado, al menos, un GP (posición = 1) */
\pset pager off

\echo 'Pilotos que han ganado al menos un GP\n'

SELECT
    (p.nombre || ' ' || p.apellido) AS "Nombre"
FROM final.piloto AS p
JOIN final.corre AS c ON p.pilotoRef = c.pilotoRef
WHERE c.posicion = 1
GROUP BY "Nombre";