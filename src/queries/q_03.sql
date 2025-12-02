/* 3. Listado con el nombre y apellidos de todos los pilotos nacidos después del 31 de
diciembre de 1999, junto con el número de carreras en las que haya participado
cada uno de ellos */
\pset pager off

\echo 'Pilotos nacidos despues del 31-12-1999 y total de carreras en las que participaron\n'

SELECT
    (p.nombre ||' '|| p.apellido) AS "Nombre y apellidos",
    COUNT(c.pilotoRef) AS "Participaciones"
FROM final.piloto AS p 
JOIN final.corre AS c ON c.pilotoRef = p.pilotoRef
WHERE p.fechaNacimiento::CHAR > '1999-12-31'
GROUP BY "Nombre y apellidos"; 