/* 8. Piloto con la vuelta más rápida en toda la historia (se prohíbe expresamente el uso
de la sentencia LIMIT) */

\pset pager off

\echo 'Piloto con la vuelta más rápida en toda la historia\n'

SELECT
    pilotoRef AS piloto
FROM final.vuelta
WHERE tiempo = (SELECT min(tiempo) FROM final.vuelta)
GROUP BY pilotoRef;