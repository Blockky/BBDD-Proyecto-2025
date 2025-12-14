import sys
import psycopg2

class conexionException(Exception): pass

def pedir_credenciales():
    port = 5432
    database = 'formula1'
    host = 'localhost'

    user = input('Nombre de usuario: ')
    password = input('Contraseña: ')

    return (host, port, user, password, database)
    
def main():
    try:
        # Pedir las credenciales del usuario que se conecta
        (host, port, user, password, database) = pedir_credenciales()
        parametros = f'host={host} port={port} user={user} password={password} dbname={database}'

        try:
            conexion_f1 = psycopg2.connect(parametros)
            cursor_f1 = conexion_f1.cursor()
            print(f'Iniciado sesión como {user} en la base de datos {database}')

        except psycopg2.OperationalError:
            raise conexionException("No se pudo conectar a la base de datos. Verifique las credenciales y la conexión.")
        
        # Prompt principal del usuario que se conecta
        no_salir = True
        while(no_salir):
            print(  
                '\nMenú del programa:',
                '\n\t1. Realizar una consulta.',
                '\n\t2. Insertar datos en una tabla.',
                '\n\t3. Salir del programa.'
            )
            opcion = input('Elija una opción (1, 2, 3): ')
            match opcion:
                case '1':
                    query = realizar_consulta()
                    if query:
                        cursor_f1.execute(query)
                        for record in cursor_f1.fetchall():
                            print(record)
                case '2':
                    insercion = insetar_tupla()
                    if insercion:
                        cursor_f1.execute(insercion)
                case '3':
                    no_salir = False
                case _:
                    print('Opción no válida!')

        # Cerrar la conexión y el cursor
        cursor_f1.close()
        conexion_f1.close()

    except Exception as e:
        print(f"Ocurrió un error inesperado: {e}")
    finally:
        print("Programa terminado.")

def realizar_consulta():
    print(  
        '\nElija la consulta a realizar',
        '\n\t1. Numero de GPs albergados por circuito.',
        '\n\t2. GPs corridos y total de puntos de Ayrton Senna.',
        '\n\t3. Pilotos nacidos despues del 31-12-1999 y carreras en las que participaron.',
        '\n\t4. Escuderias españolas e italinas y número de GPs en los que han corrido.',
        '\n\t6. Pilotos que han ganado al menos un GP.',
        '\n\t7. Número de Grandes Premios por país.',
        '\n\t8. Piloto con la vuelta más rápida en toda la historia.',
        '\n\t9. Número de boxes por piloto del GP de Mónaco de 2023.',
        '\n\t10. Pilotos con mas 100 GPs participadas.'
    )
    opcion = input('Consulta a realizar: ')

    match opcion:
        case '1':
            return "SELECT c.nombre, COUNT(gp.circuitoRef) FROM final.circuito AS c JOIN final.granPremio AS gp ON c.circuitoRef = gp.circuitoRef GROUP BY c.circuitoRef ORDER BY COUNT(gp.circuitoRef) DESC;"
        case '2':
            return "SELECT COUNT(c.pilotoRef), SUM(c.puntos) FROM final.corre AS c JOIN final.piloto AS p ON p.pilotoRef = c.pilotoRef WHERE p.nombre = 'Ayrton' and p.apellido = 'Senna';"
        case '3':
            return "SELECT (p.nombre ||' '|| p.apellido), COUNT(c.pilotoRef) FROM final.piloto AS p JOIN final.corre AS c ON c.pilotoRef = p.pilotoRef WHERE p.fechaNacimiento::CHAR > '1999-12-31' GROUP BY (p.nombre ||' '|| p.apellido);"
        case '4':
            return "SELECT e.nombre, COUNT(c.escuderiaRef) FROM final.escuderia AS e JOIN final.corre AS c ON e.escuderiaRef = c.escuderiaRef WHERE e.nacionalidad = 'Spanish' OR e.nacionalidad = 'Italian' GROUP BY e.nombre;"
        case '6':
            return "SELECT (p.nombre || ' ' || p.apellido) FROM final.piloto AS p JOIN final.corre AS c ON p.pilotoRef = c.pilotoRef WHERE c.posicion = 1 GROUP BY (p.nombre || ' ' || p.apellido);"
        case '7':
            return "SELECT c.pais, COUNT(c.circuitoref) FROM final.granpremio AS gp JOIN final.circuito AS c ON gp.circuitoref = c.circuitoref GROUP BY c.pais;"
        case '8':
            return "SELECT (p.nombre ||' '|| p.apellido), v.tiempo FROM final.vuelta AS v JOIN final.piloto AS p ON v.pilotoref = p.pilotoref WHERE v.tiempo = (SELECT min(tiempo) FROM final.vuelta);"
        case '9':
            return "SELECT (p.nombre ||' '|| p.apellido), COUNT(*) FROM final.piloto AS p JOIN final.boxes AS b ON p.pilotoref = b.pilotoref JOIN final.circuito AS c ON b.circuitoref = c.circuitoref WHERE b.anno = 2023 AND c.pais = 'Monaco' GROUP BY (p.nombre ||' '|| p.apellido) ORDER BY COUNT(*) DESC;"
        case '10':
            return "SELECT (p.nombre || ' ' || p.apellido), COUNT(p.pilotoRef) FROM final.corre AS c JOIN final.piloto AS p ON c.pilotoRef = p.pilotoRef GROUP BY (p.nombre || ' ' || p.apellido) HAVING COUNT(c.pilotoRef) > 100 ORDER BY COUNT(c.pilotoRef);"
        case _:
            print('Consulta no válida!')
            return False

def insetar_tupla():
    print(
        '\nElija la tabla en la que desee insertar datos:',
        '\n\t1. Piloto',
        '\n\t2. Escuderia',
        '\n\t3. Circuito',
        '\n\t4. Temporada'
    )
    opcion = input('Tabla a modificar: ')

    match opcion:
        case '1':
            pilotoRef = input("PilotoRef: ")
            nombre = input("Nombre: ")
            apellido = input("Apellido: ")
            nacionalidad = input("Nacionalidad: ")
            fecha = input("Fecha de nacimiento (YYYY-MM-DD): ")
            numero = input("Número: ")
            codigo = input("Código (AAA): ")
            url = input("URL: ")

            return f"""
            INSERT INTO final.piloto
            VALUES ('{pilotoRef}',{numero},'{codigo}','{nombre}','{apellido}','{fecha}','{nacionalidad}','{url}');"""

        case '2':
            escuderiaRef = input("EscuderiaRef: ")
            nombre = input("Nombre: ")
            nacionalidad = input("Nacionalidad: ")
            url = input("URL: ")

            return f"""
            INSERT INTO final.escuderia
            VALUES ('{escuderiaRef}','{nombre}','{nacionalidad}','{url}');"""

        case '3':
            circuitoRef = input("CircuitoRef: ")
            nombre = input("Nombre: ")
            ciudad = input("Ciudad: ")
            pais = input("País: ")
            url = input("URL: ")
            longitud = input("Longitud: ")
            latitud = input("Latitud: ")
            altura = input("Altura: ")

            return f"""
            INSERT INTO final.circuito
            VALUES ('{circuitoRef}','{nombre}','{ciudad}','{pais}','{url}',{latitud},{longitud},{altura});"""

        case '4':
            anno = input("Año: ")
            url = input("URL: ")

            return f"""
            INSERT INTO final.temporada
            VALUES ({anno},'{url}');"""

        case _:
            print("Opción no válida")
            return False

main()