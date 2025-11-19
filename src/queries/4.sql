/* 4. Nombre de todas las escuderías españolas o italianas junto con el número de
grandes premios corridos. */
\pset pager off

\echo 'Escuderias españolas e italinas y número de grandes premios en los que han corrido\n'

SELECT
    e.nombre AS escuderia,
    COUNT(c.escuderiaRef) AS gps_corridos
FROM final.escuderia AS e
JOIN final.corre AS c ON e.escuderiaRef = c.escuderiaRef
WHERE e.nacionalidad = 'Spanish' or e.nacionalidad = 'Italian'
GROUP BY e.nombre;