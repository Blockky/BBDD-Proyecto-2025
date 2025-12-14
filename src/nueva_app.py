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
                    print('consulta')
                case '2':
                    print('casi')
                case '3':
                    no_salir = False
                case _:
                    print('Opción no válida! (1, 2, 3)')
                    
    except KeyboardInterrupt:
        print("Program interrupted by user.")
    finally:
        print("Program finished")

def realizar_consulta():
    
main()