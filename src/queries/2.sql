/* 2. Número de grandes premios que ha corrido Ayrton Senna, así como el total de
puntos conseguidos en las mismas */

\echo 'Gps corridos y total de puntos de Ayrton Senna'

SELECT
    COUNT(*) AS numeroGPS,
    SUM(puntos) AS totalPuntos
FROM final.corre WHERE pilotoRef = 'senna';
