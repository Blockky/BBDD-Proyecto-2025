/* 8. Piloto con la vuelta más rápida en toda la historia*/
\pset pager off

\echo 'Piloto con la vuelta más rápida en toda la historia\n'

SELECT 
    (p.nombre ||' '|| p.apellido) AS "Nombre",
    v.tiempo AS "Tiempo"
FROM final.vuelta AS v 
JOIN final.piloto AS p ON v.pilotoref = p.pilotoref
WHERE v.tiempo = (
    SELECT min(tiempo)
    FROM final.vuelta
);