/* 2. Número de grandes premios que ha corrido Ayrton Senna, así como el total de
puntos conseguidos en las mismas */
\pset pager off

\echo 'Grandes premios corridos y total de puntos de Ayrton Senna\n'

SELECT
    COUNT(*) AS gps_corridos,
    SUM(c.puntos) AS puntos
FROM final.corre c
JOIN final.piloto p ON p.pilotoRef = c.pilotoRef
WHERE p.nombre = 'Ayrton' and p.apellido = 'Senna';