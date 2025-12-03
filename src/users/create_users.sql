SET search_path = final;

-- Creación del usuario administrador
CREATE USER administrador2 WITH PASSWORD 'admin';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM administrador;

--Concesión de todos los permisos al usuario administrador
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA temp TO administrador;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA final TO administrador;

--Creación del usuario gestor de competiciones
CREATE USER gestor_Competiciones WITH PASSWORD 'gestor';
REVOKE ALL PRIVILEGES ON DATABASE formula1 FROM gestor_Competiciones;


ROLLBACK;