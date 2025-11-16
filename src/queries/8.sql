/*Piloto con la vuelta más rápida en toda la historia*/

SELECT p.nombre AS "Nombre",p.apellido AS "Apellido",v.nombregp AS "Gran Premio", v.anno AS "ANNO",v.numerovuelta AS "Num Vuelta", v.tiempo AS "TIEMPO"
FROM(
    SELECT pilotoref,nombregp,anno,numerovuelta,tiempo 
    FROM final.vuelta
    WHERE tiempo =(
        SELECT MIN(tiempo)
        FROM final.vuelta
    )
)v
JOIN(
    SELECT pilotoref,nombre,apellido
    FROM final.piloto
)p
ON v.pilotoref = p.pilotoref