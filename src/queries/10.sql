/*Nombre de los pilotos que hayan participado en más de 100 premios ordenados
por aquellos que hayan participado en más grandes premios.*/

SELECT nombre,apellido, "Num grandes premios"
FROM (
    SELECT p.nombre, p.apellido, COUNT(DISTINCT v.nombregp||v.anno) AS "Num grandes premios"
    FROM final.piloto p
    JOIN final.vuelta v
    ON p.pilotoref = v.pilotoref
    GROUP BY p.nombre,p.apellido
)
WHERE "Num grandes premios" >= 100
ORDER BY "Num grandes premios" DESC;