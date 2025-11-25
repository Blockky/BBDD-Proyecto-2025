/* 5. Vista donde, para cada temporada, se muestren los pilotos que han corrido en la
misma, así como los puntos totales que han obtenido cada uno en esa temporada. */
\pset pager off

\echo 'Puntos obtenidos por cada piloto en cada temporada\n'

CREATE VIEW vista_temporada AS
    SELECT
        c.anno AS "Temporada",
        (p.nombre ||' '|| p.apellido) AS "Piloto",
        SUM(c.puntos) AS "Total de puntos"
    FROM final.corre AS c
    JOIN final.piloto AS p ON p.pilotoref = c.pilotoref
    GROUP BY "Temporada", "Piloto";

SELECT * FROM vista_temporada
ORDER BY "Temporada" ASC;