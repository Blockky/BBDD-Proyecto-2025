/*Nombre de los pilotos que han ganado, al menos, un GP (posición = 1)*/

SELECT DISTINCT c.nombregp,c.anno,p.nombre, p.apellido
FROM(
    SELECT pilotoref,nombre,apellido
    FROM final.piloto 
)p
JOIN(
    SELECT nombregp, anno,pilotoref, posicion
    FROM final.corre
    WHERE posicion = 1
)c
    ON p.pilotoref = c.pilotoref
    ORDER BY anno ASC;