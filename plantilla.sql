\pset pager off                 -- Configuración
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
\COPY temp.pilotos_temp from 'data\drivers.csv' WITH (FORMAT csv, HEADER, DELIMITER ',', NULL 'NULL', ENCODING 'UTF-8');
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
    piloto_ref CHAR(40) NOT NULL,
    nombre_piloto CHAR(40),
    apellido CHAR(40),
    nacionalidad CHAR(40),
    codigo CHAR(3),
    fecha_nacimiento DATE,
    num_piloto int,
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
    puntos int,
    CONSTRAINT corre_pk PRIMARY KEY (escuderia_ref, piloto_ref, nombre_gp, anno_temporada, circuito_ref),
    CONSTRAINT corre_fk1 FOREIGN KEY (escuderia_ref) REFERENCES formula1.escuderia(escuderiaRef)
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
    estado CHAR(40),
    puntos int,
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
    tiempo FLOAT,
    CONSTRAINT vuelta_pk PRIMARY KEY(piloto_ref, annoTemporada, circuitoRef, nombreGP, num_vuelta),
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
    CONSTRAINT boxes_pk PRIMARY KEY(piloto_ref, annoTemporada, circuitoRef, nombreGP, num_vuelta),
    CONSTRAINT boxes_fk FOREIGN KEY (piloto_ref, annoTemporada, circuitoRef, nombreGP, num_vuelta) REFERENCES formula1.vuelta(piloto_ref, annoTemporada, circuitoRef, nombreGP, num_vuelta)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO formula1.piloto(piloto_ref, nombre_piloto, apellido, nacionalidad, codigo, fecha_nacimiento, num_piloto, url) 
SELECT DISTINCT ON (TRIM(pt.pilotoRef)) TRIM(pt.pilotoRef)::CHAR(40) AS piloto_ref, NULLIF(TRIM(pt.nombre),'')::CHAR(40) AS nombre_piloto, NULLIF(TRIM(pt.apellido),'')::CHAR(40) AS apellido, NULLIF(TRIM(pt.nacionalidad),'')::CHAR(40) AS nacionalidad, NULLIF(TRIM(pt.codigo),'')::CHAR(3) AS codigo, NULLIF(TRIM(pt.fechaNacimiento),'')::DATE AS fecha_nacimiento, NULLIF(NULLIF(TRIM(pt.numero),''),'NULL')::INT AS num_piloto, NULLIF(TRIM(pt.url),'')::CHAR(100) AS url FROM temp.pilotos_temp pt WHERE COALESCE(NULLIF(TRIM(pt.pilotoRef),''), NULL) IS NOT NULL ORDER BY TRIM(pt.pilotoRef) ON CONFLICT (piloto_ref) DO NOTHING;

INSERT INTO formula1.circuito(circuito_ref, nombre_circuito, ciudad, pais, url, latitud, longitud, altura) SELECT DISTINCT ON (TRIM(ct.circuitoRef)) TRIM(ct.circuitoRef)::CHAR(40) AS circuito_ref, NULLIF(TRIM(ct.nombre),'')::CHAR(40) AS nombre_circuito, NULLIF(TRIM(ct.ciudad),'')::CHAR(40) AS ciudad, NULLIF(TRIM(ct.pais),'')::CHAR(40) AS pais, NULLIF(TRIM(ct.url),'')::CHAR(100) AS url, CASE WHEN NULLIF(TRIM(ct.latitud),'') IS NULL THEN NULL ELSE REPLACE(TRIM(ct.latitud),',','.')::FLOAT END AS latitud, CASE WHEN NULLIF(TRIM(ct.longitud),'') IS NULL THEN NULL ELSE REPLACE(TRIM(ct.longitud),',','.')::FLOAT END AS longitud, CASE WHEN NULLIF(TRIM(ct.altura),'') IS NULL THEN NULL ELSE REPLACE(TRIM(ct.altura),',','.')::FLOAT END AS altura FROM temp.circuitos_temp ct WHERE COALESCE(NULLIF(TRIM(ct.circuitoRef),''), NULL) IS NOT NULL ORDER BY TRIM(ct.circuitoRef) ON CONFLICT (circuito_ref) DO NOTHING;

INTO formula1.escuderia(escuderia_ref, nombre_escuderia, nacionalidad, url) SELECT DISTINCT ON (TRIM(ec.escuderiaRef)) TRIM(ec.escuderiaRef)::CHAR(40) AS escuderia_ref, NULLIF(TRIM(ec.nombre),'')::CHAR(40) AS nombre_escuderia, NULLIF(TRIM(ec.nacionalidad),'')::CHAR(40) AS nacionalidad, NULLIF(TRIM(ec.url),'')::CHAR(100) AS url FROM temp.escuderia_temp ec WHERE COALESCE(NULLIF(TRIM(ec.escuderiaRef),''), NULL) IS NOT NULL ORDER BY TRIM(ec.escuderiaRef) ON CONFLICT (escuderia_ref) DO NOTHING;

INSERT INTO formula1.temporada(anno, url) SELECT DISTINCT NULLIF(TRIM(tt.year),'')::INT AS anno, NULLIF(TRIM(tt.url),'')::CHAR(40) AS url FROM temp.temporadas_temp tt WHERE COALESCE(NULLIF(TRIM(tt.year),''), NULL) IS NOT NULL ON CONFLICT (anno) DO NOTHING;

INSERT INTO formula1.gran_premio(nombre_gp, anno_temporada, circuito_ref, ronda, fecha_hora, url) SELECT DISTINCT ON (TRIM(rp.granPremioId)) NULLIF(TRIM(rp.name),'')::CHAR(40) AS nombre_gp, NULLIF(TRIM(rp.year),'')::INT AS anno_temporada, TRIM(circ.circuitoRef)::CHAR(40) AS circuito_ref, NULLIF(NULLIF(TRIM(rp.round),''),'NULL')::INT AS ronda, -- Combina date + time si existe, si no usa solo date (CASE WHEN COALESCE(NULLIF(TRIM(rp.time),''), '') <> '' THEN (NULLIF(TRIM(rp.date), '') || ' ' || NULLIF(TRIM(rp.time), ''))::TIMESTAMP ELSE NULLIF(TRIM(rp.date),'')::DATE::TIMESTAMP END) AS fecha_hora, NULLIF(TRIM(rp.url),'')::CHAR(40) AS url FROM temp.carreras_temp rp LEFT JOIN temp.circuitos_temp circ ON TRIM(circ.circuitoID) = TRIM(rp.circuitId) WHERE COALESCE(NULLIF(TRIM(rp.granPremioId),''), NULL) IS NOT NULL ORDER BY TRIM(rp.granPremioId) ON CONFLICT (nombre_gp, anno_temporada, circuito_ref) DO NOTHING;

INSERT INTO formula1.corre(escuderia_ref, piloto_ref, nombre_gp, anno_temporada, circuito_ref, posicion, estado, puntos) SELECT TRIM(ec.escuderiaRef)::CHAR(40) AS escuderia_ref, TRIM(pt.pilotoRef)::CHAR(40) AS piloto_ref, NULLIF(TRIM(r.name),'')::CHAR(40) AS nombre_gp, NULLIF(TRIM(r.year),'')::INT AS anno_temporada, TRIM(circ.circuitoRef)::CHAR(40) AS circuito_ref, CASE WHEN COALESCE(NULLIF(TRIM(res.posicion),''), '') = '' THEN NULL ELSE NULLIF(TRIM(res.posicion),'')::INT END AS posicion, NULLIF(TRIM(st.status),'')::CHAR(40) AS estado, CASE WHEN COALESCE(NULLIF(TRIM(res.puntos),''), '') = '' THEN NULL ELSE NULLIF(TRIM(res.puntos),'')::INT END AS puntos FROM temp.resultados_temp res LEFT JOIN temp.carreras_temp r ON TRIM(r.granPremioId) = TRIM(res.gpid) LEFT JOIN temp.circuitos_temp circ ON TRIM(circ.circuitoID) = TRIM(r.circuitId) LEFT JOIN temp.pilotos_temp pt ON TRIM(pt.pilotoID) = TRIM(res.pilotoid) LEFT JOIN temp.escuderia_temp ec ON TRIM(ec.escuderiaID) = TRIM(res.escuderiaid) LEFT JOIN temp.estado_temp st ON TRIM(st.statusId) = TRIM(res.estadoid) WHERE COALESCE(NULLIF(TRIM(res.gpid),''), NULL) IS NOT NULL AND TRIM(pt.pilotoRef) IS NOT NULL ON CONFLICT (escuderia_ref, piloto_ref, nombre_gp, anno_temporada, circuito_ref) DO NOTHING;

INSERT califica (qualifying) -> usamos position; estado y puntos no vienen en qualifying, se dejan NULL/0 INSERT INTO formula1.califica(piloto_ref, anno_temporada, circuito_ref, nombre_gp, posicion, estado, puntos) SELECT TRIM(pt.pilotoRef)::CHAR(40) AS piloto_ref, NULLIF(TRIM(r.year),'')::INT AS anno_temporada, TRIM(circ.circuitoRef)::CHAR(40) AS circuito_ref, NULLIF(TRIM(r.name),'')::CHAR(40) AS nombre_gp, CASE WHEN COALESCE(NULLIF(TRIM(q.position),''),'') = '' THEN NULL ELSE NULLIF(TRIM(q.position),'')::INT END AS posicion, NULL::CHAR(40) AS estado, 0 AS puntos FROM temp.clasificarse_temp q LEFT JOIN temp.carreras_temp r ON TRIM(r.granPremioId) = TRIM(q.raceId) LEFT JOIN temp.circuitos_temp circ ON TRIM(circ.circuitoID) = TRIM(r.circuitId) LEFT JOIN temp.pilotos_temp pt ON TRIM(pt.pilotoID) = TRIM(q.driverId) WHERE COALESCE(NULLIF(TRIM(q.qualifyId),''), NULL) IS NOT NULL AND TRIM(pt.pilotoRef) IS NOT NULL ON CONFLICT (piloto_ref, anno_temporada, circuito_ref, nombre_gp) DO NOTHING;

INSERT vuelta (lap times). Usamos miliseg para calcular tiempo en segundos si está disponible INSERT INTO formula1.vuelta(piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta, posicion, tiempo) SELECT TRIM(pt.pilotoRef)::CHAR(40) AS piloto_ref, NULLIF(TRIM(r.year),'')::INT AS anno_temporada, TRIM(circ.circuitoRef)::CHAR(40) AS circuito_ref, NULLIF(TRIM(r.name),'')::CHAR(40) AS nombre_gp, NULLIF(TRIM(lt.vuelta),'')::INT AS num_vuelta, CASE WHEN COALESCE(NULLIF(TRIM(lt.posicion),''),'') = '' THEN NULL ELSE NULLIF(TRIM(lt.posicion),'')::INT END AS posicion, CASE WHEN COALESCE(NULLIF(TRIM(lt.miliseg),''),'') = '' THEN NULL ELSE NULLIF(TRIM(lt.miliseg),'')::INT / 1000.0 END AS tiempo FROM temp.lap_times_temp lt LEFT JOIN temp.carreras_temp r ON TRIM(r.granPremioId) = TRIM(lt.carreraID) LEFT JOIN temp.circuitos_temp circ ON TRIM(circ.circuitoID) = TRIM(r.circuitId) LEFT JOIN temp.pilotos_temp pt ON TRIM(pt.pilotoID) = TRIM(lt.pilotoID) WHERE COALESCE(NULLIF(TRIM(lt.carreraID),''), NULL) IS NOT NULL AND TRIM(pt.pilotoRef) IS NOT NULL ON CONFLICT (piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta) DO NOTHING;

INSERT boxes (pit stops) -> tiempoBoxes as TIME (si el formato lo permite) INSERT INTO formula1.boxes(piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta, tiempoBoxes) SELECT TRIM(pt.pilotoRef)::CHAR(40) AS piloto_ref, NULLIF(TRIM(r.year),'')::INT AS anno_temporada, TRIM(circ.circuitoRef)::CHAR(40) AS circuito_ref, NULLIF(TRIM(r.name),'')::CHAR(40) AS nombre_gp, NULLIF(NULLIF(TRIM(ps.lap),''),'NULL')::INT AS num_vuelta, -- time in pit_stops may be a wall-clock time (HH:MI:SS) or relative; try cast to TIME, if fails insert NULL (CASE WHEN COALESCE(NULLIF(TRIM(ps.time),''),'') = '' THEN NULL ELSE NULLIF(TRIM(ps.time),'')::TIME END) AS tiempoBoxes FROM temp.pit_stops_temp ps LEFT JOIN temp.carreras_temp r ON TRIM(r.granPremioId) = TRIM(ps.raceId) LEFT JOIN temp.circuitos_temp circ ON TRIM(circ.circuitoID) = TRIM(r.circuitId) LEFT JOIN temp.pilotos_temp pt ON TRIM(pt.pilotoID) = TRIM(ps.driverId) WHERE COALESCE(NULLIF(TRIM(ps.raceId),''), NULL) IS NOT NULL AND TRIM(pt.pilotoRef) IS NOT NULL ON CONFLICT (piloto_ref, anno_temporada, circuito_ref, nombre_gp, num_vuelta) DO NOTHING;

\echo 'Inserciones completadas (no se hace commit por defecto en este script)'

ROLLBACK;                       --importante! permite correr el script multiples veces...
