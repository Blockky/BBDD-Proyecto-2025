import sys
import psycopg2

def pedir_credenciales():
    port = 5432
    database = 'formula1'
    host = 'localhost'

    user = input('Nombre de usuario: ')
    password = input(f'Contraseña de {user}: ')

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
            return ""
        case '6':
            return ''
        case '7':
            return ''
        case '8':
            return ''
        case '9':
            return ''
        case '10':
            return ''
        case _:
            print('Consulta no válida!')
            return False

main()