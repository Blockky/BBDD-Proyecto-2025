CREATE TABLE auditoria(
    nombretabla text,
    tipoevento TG_OP,
    usuario,
    fechaHora timestamp
);

CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
    DECLARE

    BEGIN
    --Se determina que acción ha activado el trigger y se inserta un nuevo valor en la tabla dependiendo
    --de dicha acción. Junto con la accion se escribe lo que solicita el enunciado
    IF TG_OP='INSERT' THEN
        INSERT INTO auditoria VALUES ('alta',...,current_timestamp);
    ELSIF TG_OP='UPDATE' THEN
        INSERT INTO aditoria VALUES ('modificación',...,current_timestamp);
    ELSEIF TG_OP='DELETE' THEN
        INSERT INTO aditoria VALUES ('borrado',...,current_timestamp);
    END IF;
    RETURN NULL;
END
$fin_auditoria$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditoria after INSERT or UPDATE or DELETE
    ON discos FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();
