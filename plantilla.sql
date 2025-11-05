\pset pager off
SET client_encoding = 'UTF8';

BEGIN;

\echo 'Creando el esquema temp'

CREATE SCHEMA IF NOT EXISTS temp;
SET search_path = temp;


CREATE TABLE IF NOT EXISTS pilotos_temp(
    pilotoID text,
    pilotoRef text,
    numero text,
    codigo text,
    nombre text,
    apellido text,
    fechaNacimiento text,
    nacionalidad text,
    url text
);
CREATE TABLE IF NOT EXISTS circuitos_temp(
    circuitoID text,
    circuito_ref text,
    nombre text,
    ciudad text,
    pais text,
    latitud text,
    longitud text,
    altura text,
    url text
);
CREATE TABLE IF NOT EXISTS escuderia_temp(
    escuderiaID text,
    escuderia_ref text,
    nombre text,
    nacionalidad text,
    url text
);
CREATE TABLE IF NOT EXISTS lap_times_temp(
    carreraID text,
    pilotoID text,
    vuelta text,
    posicion text,
    tiempo text,
    miliseg text
);
CREATE TABLE IF NOT EXISTS pit_stops_temp(
    carreraID text,
    pilotoID text,
    parada text,
    lap text,
    hora text,
    duracion text,
    milisegundos text
);
CREATE TABLE IF NOT EXISTS clasificarse_temp(
    clasificacionID text,
    carreraID text,
    pilotoID text,
    escuderiaID  text,
    numero text,
    posicion text,
    q1 text,
    q2 text,
    q3 text
);
CREATE TABLE IF NOT EXISTS carreras_temp(
    granPremioID text,
    anno text,
    ronda text,
    circuitoID text,
    nombre text,
    fecha text,
    hora text,
    url text,
    fp1_date text,
    fp1_time text,
    fp2_date text,
    fp2_time text,
    fp3_date text,
    fp3_time text,
    quali_date text,
    quali_time text,
    sprint_date text,
    sprint_time text
);
CREATE TABLE IF NOT EXISTS resultados_temp (
    resultadosID text,
    gpid text,
    pilotoID text,
    escuderiaID text,
    numero text,
    pos_parrilla text,
    posicion text,
    posiciontexto text,
    posicionorden text,
    puntos text,
    vueltas text,
    tiempo text,
    tiempomilsgs text,
    vueltarapida text,
    puesto_campeonato text,
    vueltarapida_tiempo text,
    vueltarapida_velocidad text,
    estadoid text
);
CREATE TABLE IF NOT EXISTS temporadas_temp (
    anno text,
    url text
);
CREATE TABLE IF NOT EXISTS estado_temp (
    estadoID text,
    estado text
);


\echo 'Cargando datos'

\COPY temp.circuitos_temp from 'data\circuits.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.escuderia_temp from 'data\constructors.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.pilotos_temp from 'data\drivers.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.lap_times_temp from 'data\lap_times.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.pit_stops_temp from 'data\pit_stops.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.clasificarse_temp from 'data\qualifying.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.carreras_temp from 'data\races.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.resultados_temp from 'data\results.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.temporadas_temp from 'data\seasons.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.estado_temp from 'data\status.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');

\echo 'Creando el esquema definitivo'

CREATE SCHEMA IF NOT EXISTS formula1;
SET search_path = formula1;

CREATE TABLE IF NOT EXISTS formula1.piloto(
    piloto_ref CHAR(40) NOT NULL,
    num_piloto int,
    codigo CHAR(3),
    nombre_piloto CHAR(40),
    apellido CHAR(40),
    fecha_nacimiento DATE,
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT piloto_pk PRIMARY KEY (piloto_ref)
);
CREATE TABLE IF NOT EXISTS formula1.circuito(
    circuito_ref CHAR(40) NOT NULL,
    nombre_circuito CHAR(40),
    ciudad CHAR(40),
    pais CHAR(40),
    url CHAR(100),
    latitud FLOAT,
    longitud FLOAT,
    altura FLOAT,
    CONSTRAINT circuito_pk PRIMARY KEY (circuito_ref)
);
CREATE TABLE IF NOT EXISTS formula1.escuderia(
    escuderia_ref CHAR(40) NOT NULL,
    nombre_escuderia CHAR(40),
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT escuderia_pk PRIMARY KEY (escuderia_ref)
);
CREATE TABLE IF NOT EXISTS formula1.temporada(
    anno int NOT NULL,
    url CHAR(40),
    CONSTRAINT temporada_pk PRIMARY KEY (anno)
);
CREATE TABLE IF NOT EXISTS formula1.gran_premio(
    nombre_gp CHAR(40) NOT NULL,
    anno_temporada int,
    circuito_ref CHAR(40),
    ronda int ,
    fecha_hora TIMESTAMP,
    url CHAR(40),
    CONSTRAINT gran_premio_pk PRIMARY KEY (nombre_gp, anno_temporada, circuito_ref),
    CONSTRAINT gran_premio_fk1 FOREIGN KEY (anno_temporada) REFERENCES formula1.temporada(anno)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT gran_premio_fk2 FOREIGN KEY (circuito_ref) REFERENCES circuito(circuito_ref)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.corre(
    escuderia_ref CHAR(40),
    piloto_ref CHAR(40),
    nombre_gp CHAR(40),
    anno_temporada int,
    circuito_ref CHAR(40),
    posicion int,
    estado CHAR(40),
    puntos FLOAT,
    CONSTRAINT corre_pk PRIMARY KEY (escuderia_ref, piloto_ref, nombre_gp, anno_temporada, circuito_ref),
    CONSTRAINT corre_fk1 FOREIGN KEY (escuderia_ref) REFERENCES formula1.escuderia(escuderia_ref)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT corre_fk2 FOREIGN KEY (piloto_ref) REFERENCES formula1.piloto(piloto_ref)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT corre_fk3 FOREIGN KEY (nombre_gp, anno_temporada, circuito_ref) REFERENCES formula1.gran_premio(nombre_gp, anno_temporada, circuito_ref) 
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.califica(
    piloto_ref CHAR(40),
    anno_temporada int,
    circuito_ref CHAR(40),
    nombre_gp CHAR(40) NOT NULL,
    posicion int,
    q1 TIME,
    q2 TIME,
    q3 TIME,
    CONSTRAINT califica_pk PRIMARY KEY(piloto_ref, anno_temporada, circuito_ref, nombre_gp),
    CONSTRAINT califica_fk1 FOREIGN KEY (piloto_ref) REFERENCES formula1.piloto(piloto_ref)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT califica_fk2 FOREIGN KEY (anno_temporada, circuito_ref, nombre_gp) REFERENCES formula1.gran_premio(anno_temporada, circuito_ref, nombre_gp)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.vuelta(
    piloto_ref CHAR(40),
    anno_temporada int,
    circuito_ref CHAR(40),
    nombre_gp CHAR(40),
    num_vuelta int NOT NULL,
    posicion int,
    tiempo TIME,
    CONSTRAINT vuelta_pk PRIMARY KEY(piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta),
    CONSTRAINT vuelta_fk1 FOREIGN KEY (piloto_ref) REFERENCES formula1.piloto(piloto_ref)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT vuelta_fk2 FOREIGN KEY (anno_temporada, circuito_ref, nombre_gp) REFERENCES formula1.gran_premio(anno_temporada, circuito_ref, nombre_gp)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.boxes(
    piloto_ref CHAR(40),
    anno_temporada int,
    circuito_ref CHAR(40),
    nombre_gp CHAR(40),
    num_vuelta int,
    tiempoBoxes TIME,
    CONSTRAINT boxes_pk PRIMARY KEY(piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta),
    CONSTRAINT boxes_fk FOREIGN KEY (piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta) REFERENCES formula1.vuelta(piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO formula1.piloto(piloto_ref,nombre_piloto,apellido,nacionalidad,codigo,fecha_nacimiento,num_piloto,url)
    SELECT DISTINCT ON (pilotoID)
    pilotoID::CHAR(40),
    nombre::CHAR(40),
    apellido::CHAR(40),
    nacionalidad::CHAR(40),
    codigo::CHAR(3),
    fechaNacimiento::DATE,
    numero::int,
    url::CHAR(100)
FROM temp.pilotos_temp;

INSERT INTO formula1.circuito(circuito_ref,nombre_circuito,ciudad,pais,url,latitud,longitud,altura)
    SELECT DISTINCT ON (circuitoID)
    circuitoID::CHAR(40),
    nombre::CHAR(40),
    ciudad::CHAR(40),
    pais::CHAR(40),
    url::CHAR(100),
    latitud::FLOAT,
    longitud::FLOAT,
    altura::FLOAT
FROM temp.circuitos_temp;

INSERT INTO formula1.escuderia(escuderia_ref,nombre_escuderia,nacionalidad,url)
    SELECT DISTINCT ON (escuderiaID)
    escuderiaID::CHAR(40),
    nombre::CHAR(40),
    nacionalidad::CHAR(40),
    url::CHAR(100)
FROM temp.escuderia_temp;

INSERT INTO formula1.temporada(anno,url)
    SELECT DISTINCT ON (anno)
    anno::int,
    url::CHAR(40)
FROM temp.temporadas_temp;

INSERT INTO formula1.gran_premio(nombre_gp,anno_temporada,circuito_ref,ronda,fecha_hora,url)
    SELECT DISTINCT ON (nombre, anno, circuitoID)
    nombre::CHAR(40),
    anno::int,
    circuitoID::CHAR(40),
    ronda::int,
    (fecha || ' ' || hora)::TIMESTAMP,
    url::CHAR(40)
FROM temp.carreras_temp;

INSERT INTO formula1.corre(escuderia_ref,piloto_ref,nombre_gp,anno_temporada,circuito_ref,posicion,estado,puntos)
    SELECT DISTINCT ON (escuderiaID,pilotoID,nombre,anno,circuitoID)
    escuderiaID::CHAR(40),
    pilotoID::CHAR(40),
    (SELECT nombre FROM temp.carreras_temp WHERE granPremioID = r.gpid LIMIT 1)::CHAR(40),
    (SELECT anno FROM temp.carreras_temp WHERE granPremioID = r.gpid LIMIT 1)::int,
    (SELECT circuitoID FROM temp.carreras_temp WHERE granPremioID = r.gpid LIMIT 1)::CHAR(40),
    posicion::int,
    (SELECT estado FROM temp.estado_temp WHERE estadoID = r.estadoid LIMIT 1)::CHAR(40),
    puntos::FLOAT
FROM temp.resultados_temp r;

INSERT INTO formula1.califica(piloto_ref,anno_temporada,circuito_ref,nombre_gp,posicion,q1,q2,q3)
    SELECT DISTINCT ON (pilotoID,nombre,anno,circuitoID)
    pilotoID::CHAR(40),
    (SELECT anno FROM temp.carreras_temp WHERE granPremioID = c.carreraID LIMIT 1)::int,
    (SELECT circuitoID FROM temp.carreras_temp WHERE granPremioID = c.carreraID LIMIT 1)::CHAR(40),
    (SELECT nombre FROM temp.carreras_temp WHERE granPremioID = c.carreraID LIMIT 1)::CHAR(40),
    posicion::int,
    NULLIF(q1, '')::TIME,
    NULLIF(q2, '')::TIME,
    NULLIF(q3, '')::TIME
FROM temp.clasificarse_temp c;

INSERT INTO formula1.vuelta(piloto_ref,anno_temporada,circuito_ref,nombre_gp,num_vuelta,posicion,tiempo)
    SELECT DISTINCT ON (pilotoID,nombre,anno,circuitoID)
    pilotoID::CHAR(40),
    (SELECT anno FROM temp.carreras_temp WHERE granPremioID = l.carreraID LIMIT 1)::int,
    (SELECT circuitoID FROM temp.carreras_temp WHERE granPremioID = l.carreraID LIMIT 1)::CHAR(40),
    (SELECT nombre FROM temp.carreras_temp WHERE granPremioID = l.carreraID LIMIT 1)::CHAR(40),
    vuelta::int,
    posicion::int,
    tiempo::TIME
FROM temp.lap_times_temp l;

INSERT INTO formula1.boxes(piloto_ref,anno_temporada,circuito_ref,nombre_gp,num_vuelta,tiempoBoxes)
    SELECT DISTINCT ON (pilotoID,nombre,anno,circuitoID)
    pilotoID::CHAR(40),
    (SELECT anno FROM temp.carreras_temp WHERE granPremioID = p.carreraID LIMIT 1)::int,
    (SELECT circuitoID FROM temp.carreras_temp WHERE granPremioID = p.carreraID LIMIT 1)::CHAR(40),
    (SELECT nombre FROM temp.carreras_temp WHERE granPremioID = p.carreraID LIMIT 1)::CHAR(40),
    lap::int,
    duracion::TIME
FROM temp.pit_stops_temp p;

ROLLBACK;
