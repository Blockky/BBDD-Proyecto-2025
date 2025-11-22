/* 10. Nombre de los pilotos que hayan participado en más de 100 premios ordenados
por aquellos que hayan participado en más grandes premios. */

\pset pager off

\echo 'Pilotos con mas 100gps participadas\n'

SELECT
    (p.nombre || ' ' || p.apellido) AS nombre,
    COUNT(p.pilotoRef) AS gps_participadas
FROM final.corre c
JOIN final.piloto p ON c.pilotoRef = p.pilotoRef
GROUP BY p.nombre,p.apellido
HAVING COUNT(c.pilotoRef) > 100
ORDER BY COUNT(c.pilotoRef);