SET search_path = final;
CREATE TABLE auditoria(
    auditoriaID SERIAL,
    nombretabla text,
    tipoevento text,
    usuario text,
    fechaHora timestamp,
    CONSTRAINT auditoriaPK PRIMARY KEY (auditoriaID)
);

CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
    DECLARE
    BEGIN
    --Se determina que acción ha activado el trigger y se inserta un nuevo valor en la tabla dependiendo
    --de dicha acción. Junto con la accion se escribe lo que solicita el enunciado
    IF TG_OP='INSERT' THEN
        INSERT INTO auditoria(nombretabla,tipoevento,usuario,fechaHora) VALUES (TG_TABLE_NAME,'alta',CURRENT_USER,current_timestamp);
    ELSIF TG_OP='UPDATE' THEN
        INSERT INTO auditoria(nombretabla,tipoevento,usuario,fechaHora) VALUES (TG_TABLE_NAME,'modificación',CURRENT_USER,current_timestamp);
    ELSIF TG_OP='DELETE' THEN
        INSERT INTO auditoria(nombretabla,tipoevento,usuario,fechaHora) VALUES (TG_TABLE_NAME,'borrado',CURRENT_USER,current_timestamp);
    END IF;
    RETURN NULL;
END
$fn_auditoria$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditoria_piloto after INSERT or UPDATE or DELETE
    ON piloto FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_circuito after INSERT or UPDATE or DELETE
    ON circuito FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_granPremio after INSERT or UPDATE or DELETE
    ON granPremio FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_escuderia after INSERT or UPDATE or DELETE
    ON escuderia FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_temporada after INSERT or UPDATE or DELETE
    ON temporada FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_califica after INSERT or UPDATE or DELETE
    ON califica FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_corre after INSERT or UPDATE or DELETE
    ON corre FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_vuelta after INSERT or UPDATE or DELETE
    ON vuelta FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_boxes after INSERT or UPDATE or DELETE
    ON boxes FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

    
COMMIT;