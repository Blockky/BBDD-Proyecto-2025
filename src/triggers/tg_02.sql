SET search_path = final;

CREATE TABLE IF NOT EXISTS total_puntos_piloto(
    pilotoRef CHAR(40),
    totalPuntos FLOAT,
    CONSTRAINT total_puntos_pilotoPK PRIMARY KEY (pilotoRef)
);

CREATE OR REPLACE FUNCTION fn_suma_puntos() RETURNS TRIGGER AS $fn_suma_puntos$
    DECLARE
        suma FLOAT;
        piloto_en_tabla CHAR(40);
    BEGIN
        IF TG_OP='DELETE' THEN
            suma := (SELECT SUM(puntos) FROM corre WHERE pilotoRef = OLD.pilotoRef);
            piloto_en_tabla := (SELECT pilotoRef FROM total_puntos_piloto WHERE pilotoRef = OLD.pilotoRef);
            IF suma IS NULL THEN
                suma := 0;
            END IF;
            IF piloto_en_tabla IS NULL THEN
                INSERT INTO total_puntos_piloto(pilotoRef, totalPuntos)
                    VALUES(OLD.pilotoRef, suma);
            ELSE
                UPDATE total_puntos_piloto
                SET totalPuntos = suma
                WHERE pilotoRef = OLD.pilotoRef;
            END IF;
        ELSE
            suma := (SELECT SUM(puntos) FROM corre WHERE pilotoRef = NEW.pilotoRef);
            piloto_en_tabla := (SELECT pilotoRef FROM total_puntos_piloto WHERE pilotoRef = NEW.pilotoRef);
            IF suma IS NULL THEN
                suma := 0;
            END IF;
            IF piloto_en_tabla IS NULL THEN
                INSERT INTO total_puntos_piloto(pilotoRef, totalPuntos)
                    VALUES(NEW.pilotoRef, suma);
            ELSE
                UPDATE total_puntos_piloto
                SET totalPuntos = suma
                WHERE pilotoRef = NEW.pilotoRef;
            END IF;
        END IF;
        RETURN NULL;
    END
$fn_suma_puntos$ LANGUAGE plpgsql;

CREATE TRIGGER tg_suma_puntos after INSERT or UPDATE or DELETE
    ON corre FOR EACH ROW
    EXECUTE PROCEDURE fn_suma_puntos();