import psycopg2
from tabulate import tabulate

def connect_ratings():
    """
    Connect to the ratings database and return the connection object
    Function exits the program if there is an error
    :return: connection object
    """
    # read the password file
    try:
        pwd_file = open('.pwd')  # password file should be in a secure location
    except OSError:
        print("Error: No authorization")
        exit()

    # what can go wrong?
    try:
        conn = psycopg2.connect(
            dbname = "ehar_books",
            user = "cslabtes",
            password = pwd_file.readline(),
            host = "ada.hpc.stlawu.edu"
        )
    except psycopg2.Error:
        print("Error: cannot connect to database")
        exit()
    finally:
        pwd_file.close()

    return conn

def menu():
    """
    Present the user with a menu and return selection
    only if valid.
    :return: option selected
    """
    while True:
        print("1) Look up book by title")
        print("2) Look up book by author")
        print("Q) Quit")
        opt = input("> ")
        if opt in  ['1', '2', 'q', 'Q']:
            break

    return opt

# if this file is being run as a program and *not* imported
# as a module
if __name__ == "__main__":

    conn = connect_ratings()

    opt = menu()

    # next class