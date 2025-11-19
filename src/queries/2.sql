/* 2. Número de grandes premios que ha corrido Ayrton Senna, así como el total de
puntos conseguidos en las mismas */
\pset pager off

\echo 'Grandes premios corridos y total de puntos de Ayrton Senna\n'

SELECT
    COUNT(c.pilotoRef) AS gps_corridos,
    SUM(c.puntos) AS puntos
FROM final.corre AS c
JOIN final.piloto AS p ON p.pilotoRef = c.pilotoRef
WHERE p.nombre = 'Ayrton' and p.apellido = 'Senna';