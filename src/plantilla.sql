\pset pager off
SET client_encoding = 'UTF8';

BEGIN;

\echo 'Creando el esquema para la BD de F1'

\echo 'Creando un esquema temporal'

CREATE SCHEMA IF NOT EXISTS temp;
SET search_path = temp;

CREATE TABLE IF NOT EXISTS circuito(
    circuitoId text,
    circuitoRef text,
    nombre text,
    ciudad text,
    pais text,
    latitud text,
    longitud text,
    altura text,
    url text
);
CREATE TABLE IF NOT EXISTS escuderia(
    escuderiaId text,
    escuderiaRef text,
    nombre text,
    nacionalidad text,
    url text
);
CREATE TABLE IF NOT EXISTS piloto(
    pilotoId text,
    pilotoRef text,
    numero text,
    codigo text,
    nombre text,
    apellido text,
    fechaNacimiento text,
    nacionalidad text,
    url text
);
CREATE TABLE IF NOT EXISTS vuelta(
    carreraId text,
    pilotoId text,
    numeroVuelta text,
    posicion text,
    tiempo text,
    milisegundos text
);
CREATE TABLE IF NOT EXISTS boxes(
    carreraId text,
    pilotoId text,
    pitbox text,
    numeroVuelta text,
    hora text,
    duracion text,
    milisegundos text
);
CREATE TABLE IF NOT EXISTS califica(
    calificaId text,
    carreraId text,
    pilotoId text,
    escuderiaId text,
    numero text,
    posicion text,
    q1 text,
    q2 text,
    q3 text
);
CREATE TABLE IF NOT EXISTS granPremio(
    carreraId text,
    anno text,
    ronda text,
    circuitoId text,
    nombreGP text,
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
CREATE TABLE IF NOT EXISTS resultado(
    resultadoId text,
    carreraId text,
    pilotoId text,
    escuderiaId text,
    numero text,
    pos_parrilla text,
    posicion text,
    posicióntexto text,
    posiciónorden text,
    puntos text,
    vueltas text,
    tiempo text,
    milisegundos text,
    vueltarápida text,
    puesto_campeonato text,
    vueltarápida_tiempo text,
    vueltarápida_velocidad text,
    estadoId text
);
CREATE TABLE IF NOT EXISTS temporada(
    anno text,
    url text
);
CREATE TABLE IF NOT EXISTS estado(
    estadoId text,
    estado text
);


\echo 'Cargando datos'

\COPY temp.circuito from '..\data\circuits.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.escuderia from '..\data\constructors.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.piloto from '..\data\drivers.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.vuelta from '..\data\lap_times.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.boxes from '..\data\pit_stops.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.califica from '..\data\qualifying.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.granPremio from '..\data\races.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.resultado from '..\data\results.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.temporada from '..\data\seasons.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY temp.estado from '..\data\status.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');


\echo 'Creando el esquema definitivo'

CREATE SCHEMA IF NOT EXISTS final;
SET search_path = final;

CREATE TABLE IF NOT EXISTS piloto(
    pilotoRef CHAR(40) NOT NULL,
    numero int,
    codigo CHAR(3),
    nombre CHAR(40),
    apellido CHAR(40),
    fechaNacimiento DATE,
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT pilotoPK PRIMARY KEY (pilotoRef)
);
CREATE TABLE IF NOT EXISTS circuito(
    circuitoRef CHAR(40) NOT NULL,
    nombre CHAR(40),
    ciudad CHAR(40),
    pais CHAR(40),
    url CHAR(100),
    latitud FLOAT,
    longitud FLOAT,
    altura FLOAT,
    CONSTRAINT circuitoPK PRIMARY KEY (circuitoRef)
);
CREATE TABLE IF NOT EXISTS escuderia(
    escuderiaRef CHAR(40) NOT NULL,
    nombre CHAR(40),
    nacionalidad CHAR(40),
    url CHAR(100),
    CONSTRAINT escuderiaPK PRIMARY KEY (escuderiaRef)
);
CREATE TABLE IF NOT EXISTS temporada(
    anno int NOT NULL,
    url CHAR(40),
    CONSTRAINT temporadaPK PRIMARY KEY (anno)
);
CREATE TABLE IF NOT EXISTS granPremio(
    nombreGP CHAR(40) NOT NULL,
    anno int,
    circuitoRef CHAR(40),
    ronda int ,
    fechaHora TIMESTAMP,
    url CHAR(40),
    CONSTRAINT granPremioPK PRIMARY KEY (nombreGP, anno, circuitoRef),
    CONSTRAINT granPremioFK1 FOREIGN KEY (anno) REFERENCES temporada(anno)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT granPremioFK2 FOREIGN KEY (circuitoRef) REFERENCES circuito(circuitoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS corre(
    escuderiaRef CHAR(40),
    pilotoRef CHAR(40),
    nombreGP CHAR(40),
    anno int,
    circuitoRef CHAR(40),
    posicion int,
    estado CHAR(40),
    puntos FLOAT,
    CONSTRAINT correPK PRIMARY KEY (escuderiaRef, pilotoRef, nombreGP, anno, circuitoRef),
    CONSTRAINT correFK1 FOREIGN KEY (escuderiaRef) REFERENCES escuderia(escuderiaRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT correFK2 FOREIGN KEY (pilotoRef) REFERENCES piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT correFK3 FOREIGN KEY (nombreGP, anno, circuitoRef) REFERENCES granPremio(nombreGP, anno, circuitoRef) 
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS califica(
    pilotoRef CHAR(40),
    anno int,
    circuitoRef CHAR(40),
    nombreGP CHAR(40),
    posicion int,
    q1 TIME,
    q2 TIME,
    q3 TIME,
    CONSTRAINT calificaPK PRIMARY KEY(pilotoRef, anno, circuitoRef, nombreGP),
    CONSTRAINT calificaFK1 FOREIGN KEY (pilotoRef) REFERENCES piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT calificaFK2 FOREIGN KEY (anno, circuitoRef, nombreGP) REFERENCES granPremio(anno, circuitoRef, nombreGP)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS vuelta(
    pilotoRef CHAR(40),
    anno int,
    circuitoRef CHAR(40),
    nombreGP CHAR(40),
    numeroVuelta int NOT NULL,
    posicion int,
    tiempo TIME,
    CONSTRAINT vueltaPK PRIMARY KEY(pilotoRef, anno, circuitoRef, nombreGP, numeroVuelta),
    CONSTRAINT vueltaFK1 FOREIGN KEY (pilotoRef) REFERENCES piloto(pilotoRef)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT vueltaFK2 FOREIGN KEY (anno, circuitoRef, nombreGP) REFERENCES granPremio(anno, circuitoRef, nombreGP)
    ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS boxes(
    pilotoRef CHAR(40),
    anno int,
    circuitoRef CHAR(40),
    nombreGP CHAR(40),
    numeroVuelta int,
    hora TIME,
    tiempo int,
    CONSTRAINT boxesPK PRIMARY KEY(pilotoRef, anno, circuitoRef, nombreGP, numeroVuelta, hora),
    CONSTRAINT boxesFK FOREIGN KEY (pilotoRef, anno, circuitoRef, nombreGP, numeroVuelta) REFERENCES vuelta(pilotoRef, anno, circuitoRef, nombreGP, numeroVuelta)
    ON DELETE RESTRICT ON UPDATE CASCADE
);


\echo 'Insertando datos en el esquema final'
\echo 'Cargando pilotos'
INSERT INTO final.piloto(pilotoRef,nombre,apellido,nacionalidad,codigo,fechaNacimiento,numero,url)
    SELECT DISTINCT ON (pilotoRef)
    pilotoRef::CHAR(40),
    nombre::CHAR(40),
    apellido::CHAR(40),
    nacionalidad::CHAR(40),
    codigo::CHAR(3),
    fechaNacimiento::DATE,
    numero::int,
    url::CHAR(100)
FROM temp.piloto;

\echo 'Cargando circuitos'
INSERT INTO final.circuito(circuitoRef,nombre,ciudad,pais,url,latitud,longitud,altura)
    SELECT DISTINCT ON (circuitoRef)
    circuitoRef::CHAR(40),
    nombre::CHAR(40),
    ciudad::CHAR(40),
    pais::CHAR(40),
    url::CHAR(100),
    latitud::FLOAT,
    longitud::FLOAT,
    altura::FLOAT
FROM temp.circuito;

\echo 'Cargando escuderias'
INSERT INTO final.escuderia(escuderiaRef,nombre,nacionalidad,url)
    SELECT DISTINCT ON (escuderiaRef)
    escuderiaRef::CHAR(40),
    nombre::CHAR(40),
    nacionalidad::CHAR(40),
    url::CHAR(100)
FROM temp.escuderia;

\echo 'Cargando temporadas'
INSERT INTO final.temporada(anno,url)
    SELECT DISTINCT ON (anno)
    anno::int,
    url::CHAR(40)
FROM temp.temporada;

\echo 'Cargando gps'
INSERT INTO final.granPremio(nombreGP,anno,circuitoRef,ronda,fechaHora,url)
    SELECT DISTINCT ON (nombreGP, anno, circuitoRef)
    gp.nombreGP::CHAR(40),
    gp.anno::int,
    c.circuitoRef::CHAR(40),
    gp.ronda::int,
    (gp.fecha || ' ' || gp.hora)::TIMESTAMP,
    gp.url::CHAR(40)
FROM temp.granPremio gp
JOIN temp.circuito c ON c.circuitoId = gp.circuitoId;

\echo 'Cargando pilotos corren gps'
INSERT INTO final.corre(escuderiaRef,pilotoRef,nombreGP,anno,circuitoRef,posicion,estado,puntos)
    SELECT DISTINCT ON (escuderiaRef,pilotoRef,nombreGP,anno,circuitoRef)
    e.escuderiaRef::CHAR(40),
    p.pilotoRef::CHAR(40),
    gp.nombreGP::CHAR(40),
    gp.anno::int,
    c.circuitoRef::CHAR(40),
    r.posicion::int,
    s.estado::CHAR(40),
    r.puntos::FLOAT
FROM temp.resultado r
JOIN temp.piloto p ON p.pilotoId = r.pilotoId
JOIN temp.escuderia e ON e.escuderiaId = r.escuderiaId
JOIN temp.granPremio gp ON gp.carreraId = r.carreraId
JOIN temp.circuito c ON c.circuitoId = gp.circuitoId
JOIN temp.estado s ON s.estadoId = r.estadoId;

\echo 'Cargando pilotos califica gps'
INSERT INTO final.califica(pilotoRef,anno,circuitoRef,nombreGP,posicion,q1,q2,q3)
    SELECT DISTINCT ON (pilotoRef,anno,circuitoRef,nombreGP)
    p.pilotoRef::CHAR(40),
    gp.anno::int,
    c.circuitoRef::CHAR(40),
    gp.nombreGP::CHAR(40),
    q.posicion::int,
    NULLIF(q.q1,'')::TIME,
    NULLIF(q.q2,'')::TIME,
    NULLIF(q.q3,'')::TIME
FROM temp.califica q
JOIN temp.piloto p ON p.pilotoId = q.pilotoId
JOIN temp.granPremio gp ON gp.carreraId = q.carreraId
JOIN temp.circuito c ON c.circuitoId = gp.circuitoId; 

\echo 'Cargando pilotos corren vueltas de gps'
INSERT INTO final.vuelta(pilotoRef,anno,circuitoRef,nombreGP,numeroVuelta,posicion,tiempo)
    SELECT DISTINCT ON (pilotoRef,anno,circuitoRef,nombreGP,numeroVuelta,tiempo)
    p.pilotoRef::CHAR(40),
    gp.anno::int,
    c.circuitoRef::CHAR(40),
    gp.nombreGP::CHAR(40),
    v.numeroVuelta::int,
    v.posicion::int,
    v.tiempo::TIME
FROM temp.vuelta v
JOIN temp.piloto p ON p.pilotoId = v.pilotoId
JOIN temp.granPremio gp ON gp.carreraId = v.carreraId
JOIN temp.circuito c ON c.circuitoId = gp.circuitoId;

\echo 'Cargando pilotos realizan pit stops en gps'
INSERT INTO final.boxes(pilotoRef,anno,circuitoRef,nombreGP,numeroVuelta,hora,tiempo)
    SELECT DISTINCT ON (pilotoRef,anno,circuitoRef,nombreGP,numeroVuelta,hora)
    p.pilotoRef::CHAR(40),
    gp.anno::int,
    c.circuitoRef::CHAR(40),
    gp.nombreGP::CHAR(40),
    b.numeroVuelta::int,
    b.hora::TIME,
    b.milisegundos::int
FROM temp.boxes b
JOIN temp.piloto p ON p.pilotoId = b.pilotoId
JOIN temp.granPremio gp ON gp.carreraId = b.carreraId
JOIN temp.circuito c ON c.circuitoId = gp.circuitoId;;


ROLLBACK;