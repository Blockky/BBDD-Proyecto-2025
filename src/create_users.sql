SET search_path = final;

-- Creación del usuario administrador
CREATE USER administrador WITH PASSWORD 'admin';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM administrador;

--Concesión de todos los permisos al usuario administrador
GRANT USAGE ON SCHEMA temp TO administrador; --Acceder al esquema
GRANT USAGE ON SCHEMA final TO administrador;
GRANT CREATE ON SCHEMA temp TO administrador; --Crear objetos en el esquema
GRANT CREATE ON SCHEMA final TO administrador;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA temp TO administrador; --Permisos sobre las tablas
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA final TO administrador;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA temp TO administrador;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA final TO administrador;

GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA temp TO administrador;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA final TO administrador;

--Permisos sobre todos los objetos futuros de la BBDD
ALTER DEFAULT PRIVILEGES IN SCHEMA temp
GRANT ALL PRIVILEGES ON TABLES TO administrador;

ALTER DEFAULT PRIVILEGES IN SCHEMA temp
GRANT ALL PRIVILEGES ON SEQUENCES TO administrador;

ALTER DEFAULT PRIVILEGES IN SCHEMA temp
GRANT ALL PRIVILEGES ON FUNCTIONS TO administrador;


--Creación del usuario gestor de competiciones
CREATE USER gestor_Competiciones WITH PASSWORD 'gestor';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM gestor_Competiciones;

--Acceder a los esquemas
GRANT USAGE ON SCHEMA temp TO gestor_Competiciones;
GRANT USAGE ON SCHEMA final TO gestor_Competiciones;

--Concesión de los permisos de consulta, inserción, actualización y borrado en toda la base de datos
GRANT SELECT ON ALL TABLES IN SCHEMA final TO gestor_Competiciones;
GRANT INSERT ON ALL TABLES IN SCHEMA final TO gestor_Competiciones;
GRANT UPDATE ON ALL TABLES IN SCHEMA final TO gestor_Competiciones;
GRANT DELETE ON ALL TABLES IN SCHEMA final TO gestor_Competiciones;

GRANT SELECT ON ALL TABLES IN SCHEMA temp TO gestor_Competiciones;
GRANT INSERT ON ALL TABLES IN SCHEMA temp TO gestor_Competiciones;
GRANT UPDATE ON ALL TABLES IN SCHEMA temp TO gestor_Competiciones;
GRANT DELETE ON ALL TABLES IN SCHEMA temp TO gestor_Competiciones;

--Creación del usuario analista
CREATE USER analista WITH PASSWORD 'analista';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM analista;

--Acceder al esquema
GRANT USAGE ON SCHEMA final TO analista;

--Concesión del permiso de consulta al usuario analista
GRANT SELECT ON ALL TABLES IN SCHEMA final TO analista;

--Creación del usuario invitado
CREATE USER invitado WITH PASSWORD 'invitado';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM invitado;
--Acceder al esquema
GRANT USAGE ON SCHEMA final TO invitado;

--Concesión de los permisos de consulta en carrera, pilotos,grandes premios,
--escudería, circuitos y temporadas
GRANT SELECT ON TABLE final.piloto TO invitado;
GRANT SELECT ON TABLE final.circuito TO invitado;
GRANT SELECT ON TABLE final.escuderia TO invitado;
GRANT SELECT ON TABLE final.granPremio TO invitado;
GRANT SELECT ON TABLE final.corre TO invitado;
GRANT SELECT ON TABLE final.temporada TO invitado;
GRANT SELECT ON TABLE final.califica TO invitado;

--Eliminamos los privilegios sobre exactamente las tablas sobre las que no 
--queremos acceso, por posibles herencias de privilegios
REVOKE ALL PRIVILEGES ON TABLE final.vuelta FROM gestor_Competiciones;
REVOKE ALL PRIVILEGES ON TABLE final.boxes FROM gestor_Competiciones;
