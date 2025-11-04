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
    fecha_nacimiento text,
    nacionalidad text,
    url text
);
CREATE TABLE IF NOT EXISTS circuitos_temp(
    circuitoID text,
    circuitoRef text,
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
    escuderiaRef text,
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
    raceId text,
    driverId text,
    stop text,
    lap text,
    time text,
    duration text,
    milliseconds text
);
CREATE TABLE IF NOT EXISTS clasificarse_temp(
    qualifyId text,
    raceId text,
    driverId text,
    constructorId text,
    number text,
    position text,
    q1 text,
    q2 text,
    q3 text
);
CREATE TABLE IF NOT EXISTS carreras_temp(
    granPremioId text,
    year text,
    round text,
    circuitId text,
    name text,
    date text,
    time text,
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
    resultados_id text,
    gpid text,
    pilotoid text,
    escuderiaid text,
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
    year text,
    url text
);
CREATE TABLE IF NOT EXISTS estado_temp (
    statusId text,
    status text
);


\echo 'Cargando datos'

\COPY temp.circuitos_temp from 'data\circuits.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.escuderia_temp from 'data\constructors.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.pilotos_temp from 'data\drivers.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.lap_times_temp from 'data\lap_times.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.pit_stops_temp from 'data\pit_stops.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.clasificarse_temp from 'data\qualifying.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.carreras_temp from 'data\races.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.resultados_temp from 'data\results.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.temporadas_temp from 'data\seasons.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
\COPY temp.estado_temp from 'data\status.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');

\echo 'Creando el esquema definitivo'

CREATE SCHEMA IF NOT EXISTS formula1;
SET search_path = formula1;

CREATE TABLE IF NOT EXISTS formula1.piloto(
    pilotoRef CHAR(40) NOT NULL,
    num_piloto int,
    codigo CHAR(3),
    nombre_piloto CHAR(40),
    apellido CHAR(40),
    fecha_nacimiento DATE,
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT piloto_pk PRIMARY KEY (pilotoRef)
);
CREATE TABLE IF NOT EXISTS formula1.circuito(
    circuitoRef CHAR(40) NOT NULL,
    nombre_circuito CHAR(40),
    ciudad CHAR(40),
    pais CHAR(40),
    url CHAR(100),
    latitud FLOAT,
    longitud FLOAT,
    altura FLOAT,
    CONSTRAINT circuito_pk PRIMARY KEY (circuitoRef)
);
CREATE TABLE IF NOT EXISTS formula1.escuderia(
    escuderiaRef CHAR(40) NOT NULL,
    nombre_escuderia CHAR(40),
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT escuderia_pk PRIMARY KEY (escuderiaRef)
);
CREATE TABLE IF NOT EXISTS formula1.temporada(
    anno int NOT NULL,
    url CHAR(40),
    CONSTRAINT temporada_pk PRIMARY KEY (anno)
);
CREATE TABLE IF NOT EXISTS formula1.gran_premio(
    nombre_gp CHAR(40) NOT NULL,
    anno_temporada int,
    circuitoRef CHAR(40),
    ronda int ,
    fecha_hora TIMESTAMP,
    url CHAR(40),
    CONSTRAINT gran_premio_pk PRIMARY KEY (nombre_gp, anno_temporada, circuitoRef),
    CONSTRAINT gran_premio_fk1 FOREIGN KEY (anno_temporada) REFERENCES formula1.temporada(anno)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT gran_premio_fk2 FOREIGN KEY (circuitoRef) REFERENCES circuito(circuitoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.corre(
    escuderiaRef CHAR(40),
    pilotoRef CHAR(40),
    nombre_gp CHAR(40),
    anno_temporada int,
    circuitoRef CHAR(40),
    posicion int,
    estado CHAR(40),
    puntos int,
    CONSTRAINT corre_pk PRIMARY KEY (escuderiaRef, pilotoRef, nombre_gp, anno_temporada, circuitoRef),
    CONSTRAINT corre_fk1 FOREIGN KEY (escuderiaRef) REFERENCES formula1.escuderia(escuderiaRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT corre_fk2 FOREIGN KEY (pilotoRef) REFERENCES formula1.piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT corre_fk3 FOREIGN KEY (nombre_gp, anno_temporada, circuitoRef) REFERENCES formula1.gran_premio(nombre_gp, anno_temporada, circuitoRef) 
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.califica(
    pilotoRef CHAR(40),
    anno_temporada int,
    circuitoRef CHAR(40),
    nombre_gp CHAR(40) NOT NULL,
    posicion int,
    estado CHAR(40),
    puntos int,
    CONSTRAINT califica_pk PRIMARY KEY(pilotoRef, anno_temporada, circuitoRef, nombre_gp),
    CONSTRAINT califica_fk1 FOREIGN KEY (pilotoRef) REFERENCES formula1.piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT califica_fk2 FOREIGN KEY (anno_temporada, circuitoRef, nombre_gp) REFERENCES formula1.gran_premio(anno_temporada, circuitoRef, nombre_gp)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.vuelta(
    pilotoRef CHAR(40),
    anno_temporada int,
    circuitoRef CHAR(40),
    nombre_gp CHAR(40),
    num_vuelta int NOT NULL,
    posicion int,
    tiempo FLOAT,
    CONSTRAINT vuelta_pk PRIMARY KEY(pilotoRef, anno_temporada, circuitoRef, nombre_gp, num_vuelta),
    CONSTRAINT vuelta_fk1 FOREIGN KEY (pilotoRef) REFERENCES formula1.piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT vuelta_fk2 FOREIGN KEY (anno_temporada, circuitoRef, nombre_gp) REFERENCES formula1.gran_premio(anno_temporada, circuitoRef, nombre_gp)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS formula1.boxes(
    pilotoRef CHAR(40),
    anno_temporada int,
    circuitoRef CHAR(40),
    nombre_gp CHAR(40),
    num_vuelta int,
    tiempoBoxes TIME,
    CONSTRAINT boxes_pk PRIMARY KEY(pilotoRef, anno_temporada, circuitoRef, nombre_gp, num_vuelta),
    CONSTRAINT boxes_fk FOREIGN KEY (pilotoRef, anno_temporada, circuitoRef, nombre_gp, num_vuelta) REFERENCES formula1.vuelta(pilotoRef, anno_temporada, circuitoRef, nombre_gp, num_vuelta)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO formula1.piloto(pilotoRef,nombre_piloto,apellido,nacionalidad,codigo,fecha_nacimiento,num_piloto,url)
    SELECT DISTINCT ON (pilotoRef)
    pilotoRef::CHAR(40),
    nombre::CHAR(40),
    apellido::CHAR(40),
    nacionalidad::CHAR(40),
    codigo::CHAR(3),
    fecha_nacimiento::DATE,
    numero::int,
    url::CHAR(100)
FROM temp.pilotos_temp

ROLLBACK;


