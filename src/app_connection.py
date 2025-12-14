import sys
import psycopg2

class portException(Exception): pass
class userException(Exception):pass
class passwordException(Exception):pass
class querySelectionException(Exception):pass

print("Hola")

def ask_user(msg):
    """
        ask for a valid username
        ask_user :: String -> IO String | Exception
    """
    try:
        user = input (msg).strip()
        if user == "":
            raise ValueError
    except ValueError:
        raise userException
    else:
        return user

def ask_password(msg):
    """
        ask for a valid password for the provided user
        ask_user :: String -> IO String | Exception
    """
    try:
        password = input (msg).strip()
        if password == "":
            raise ValueError
    except ValueError:
        raise passwordException
    else:
        return password

def pedir_credenciales():
    port = 5432
    database = 'formula1'
    host = 'localhost'

    user = ask_user('Nombre de usuario: ')
    password = ask_password('Contraseña: ')

    return (host, port, user, password, database)
    
def main():
    try:
        
        (host, port, user, password, database) = pedir_credenciales()
        parametros_conexion = f'host={host} port={port} user={user} password={password} dbname={database}' 

        conexion_f1 = psycopg2.connect(parametros_conexion)
        cursor_f1 = conexion_f1.cursor()

        print(f'Iniciado sesión como {user} en la base de datos {database}')

        no_salir = True
        while(no_salir):
            print(  '\nMenú del programa:',
                    '\n\t1. Realizar una consulta.',
                    '\n\t2. Insertar datos en una tabla.',
                    '\n\t3. Salir del programa.')
            opcion = input('Elija una opción (1, 2, 3): ')
            match opcion:
                case '1':
                    query = realizar_consulta()
                    if(query):
                        cursor_f1.execute(query)
                        for record in cursor_f1.fetchall():
                            print(record)
                case '2':
                    print('casi')
                case '3':
                    no_salir = False
                case _:
                    print('Opción no válida! (1, 2, 3)')

        cursor_f1.close
        conexion_f1.close

    except KeyboardInterrupt:
        print("Program interrupted by user.")
    except userException:
        print("The user is not valid!")
    except passwordException:
        print("The password is incorrect!")
    finally:
        print("Program finished")

def realizar_consulta():
    print(  '\nElija la consulta a realizar',
            '\n\t1. Numero de GPs albergados por circuito.',
            '\n\t2. GPs corridos y total de puntos de Ayrton Senna.',
            '\n\t3. Pilotos nacidos despues del 31-12-1999 y carreras en las que participaron.',
            '\n\t4. Escuderias españolas e italinas y número de GPs en los que han corrido.',
            '\n\t5. Puntos obtenidos por cada piloto en cada temporada.',
            '\n\t6. Pilotos que han ganado al menos un GP.',
            '\n\t7. Número de Grandes Premios por país.',
            '\n\t8. Piloto con la vuelta más rápida en toda la historia.',
            '\n\t9. Número de boxes por piloto del GP de Mónaco de 2023.',
            '\n\t10. Pilotos con mas 100 GPs participadas.')
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
        case '5':
            return """SELECT * FROM (SELECT c.anno AS "Temporada", (p.nombre || ' ' || p.apellido) AS "Piloto", SUM(c.puntos) AS "Total de puntos" FROM final.corre AS c JOIN final.piloto AS p ON p.pilotoref = c.pilotoref GROUP BY "Temporada", "Piloto") AS vista_temporada WHERE "Temporada" = 2010 ORDER BY "Total de puntos" DESC;"""
        case '6':
            return """SELECT (p.nombre || ' ' || p.apellido) AS "Nombre" FROM final.piloto AS p JOIN final.corre AS c ON p.pilotoRef = c.pilotoRef WHERE c.posicion = 1 GROUP BY "Nombre";"""
        case '7':
            return """SELECT c.pais AS "Pais", COUNT(c.circuitoref) AS "Num GPs" FROM final.granpremio AS gp JOIN final.circuito AS c ON gp.circuitoref = c.circuitoref GROUP BY "Pais";"""
        case '8':
            return """SELECT (p.nombre ||' '|| p.apellido) AS "Nombre", v.tiempo AS "Tiempo" FROM final.vuelta AS v JOIN final.piloto AS p ON v.pilotoref = p.pilotoref WHERE v.tiempo = (SELECT min(tiempo) FROM final.vuelta);"""
        case '9':
            return """SELECT (p.nombre ||' '|| p.apellido) AS "Nombre", COUNT(*) AS "Num paradas en boxes" FROM final.piloto AS p JOIN final.boxes AS b ON p.pilotoref = b.pilotoref JOIN final.circuito AS c ON b.circuitoref = c.circuitoref WHERE b.anno = 2023 AND c.pais = 'Monaco' GROUP BY "Nombre" ORDER BY "Num paradas en boxes" DESC;"""
        case '10':
            return """SELECT (p.nombre || ' ' || p.apellido) AS "Nombre", COUNT(p.pilotoRef) AS "GPs participadas" FROM final.corre AS c JOIN final.piloto AS p ON c.pilotoRef = p.pilotoRef GROUP BY "Nombre" HAVING COUNT(c.pilotoRef) > 100 ORDER BY COUNT(c.pilotoRef);"""
        case _:
            print('Consulta no válida!')
            return False

main()