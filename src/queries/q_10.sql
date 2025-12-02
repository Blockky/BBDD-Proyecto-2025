/* 10. Nombre de los pilotos que hayan participado en más de 100 premios ordenados
por aquellos que hayan participado en más grandes premios. */
\pset pager off

\echo 'Pilotos con mas 100gps participadas\n'

SELECT
    (p.nombre || ' ' || p.apellido) AS "Nombre",
    COUNT(p.pilotoRef) AS "GPs participadas"
FROM final.corre AS c
JOIN final.piloto AS p ON c.pilotoRef = p.pilotoRef
GROUP BY "Nombre"
HAVING COUNT(c.pilotoRef) > 100
ORDER BY COUNT(c.pilotoRef);