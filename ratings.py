# Shane Hauck
# HW 5 - Python book ratings interface

import psycopg2
from tabulate import tabulate
import html


def connect_ratings():
    """
    Connect to the ratings database and return the connection object
    Function exits the program if there is an error
    :return: connection object
    """
    # read the password file
    ## try:
    ##   pwd_file = open('.pwd')  # password file should be in a secure location
    ##except OSError:
    ##   print("Error: No authorization")
    ##  exit()

    # what can go wrong?
    try:
        conn = psycopg2.connect(
            dbname="ehar_books",
            user="cslabtes",
            password="cslabtes",
            host="ada.hpc.stlawu.edu"
        )
    except psycopg2.Error:
        print("Error: cannot connect to database")
        exit()
    ##finally:
    ##   pwd_file.close()

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
        print("3) Which book has the highest average rating in year?")
        print("4) Get the title of the highest rated book for each author that has written greater than 3 books")
        print("5) Find an author's average book rating per year")
        print("6) Given a user defined range of ages (inclusive) return highest average rated book(s) by users in that age group.")
        print("7) Given a list(3) of states, find the highest average rated book of all of the given states")
        print("Q) Quit")
        opt = input("> ")
        if opt in ['1', '2', '3', '4', '5', '6', '7', 'q', 'Q']:
            break

    return opt


def lookup_by_title(conn):
    title = input("Enter a title: ")
    title = title.lower()

    # sanitize the inputs
    cmd = """
        SELECT *
        FROM books
        WHERE lower(title) = %s
        """

    # a cursor is an object for issuing SQL commands to a connection
    cur = conn.cursor()

    # pass in, as a tuple, the arguments to the command string
    cur.execute(cmd, (title,))
    count = len(cur.fetchall())
    cur.execute(cmd, (title,))

    table = [("ISBN", "Title", "Author", "Year", "Publisher")]

    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:5]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No title with the name " + '"' + title + '"')

def lookup_by_author(conn):
    author = input("Enter a author: ")
    author = author.lower()

    cmd = 'SELECT * FROM books where lower(author) = %s'

    cur = conn.cursor()
    cur.execute(cmd, (author,))
    count = len(cur.fetchall())
    cur.execute(cmd, (author,))

    table = [("ISBN", "Title", "Author", "Year", "Publisher")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:5]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No author with the name " + '"' + author + '"')

def avg_rate_year(conn):
    year = input("Enter a year: ")

    cmd = """
    WITH 
        t as (
            SELECT books.isbn, ratings.isbn, title, author, year, publisher, avg(rating) as avg 
            FROM books, ratings 
            WHERE year = %s and books.isbn = ratings.isbn group by books.isbn, ratings.isbn), 
        s as (
            SELECT max(avg) as max 
            FROM t) 
    SELECT year, title, author, publisher, t.avg 
    FROM t, s 
    WHERE t.avg = s.max;
    """

    cur = conn.cursor()
    cur.execute(cmd,(year,))
    count = len(cur.fetchall())
    cur.execute(cmd, (year,))

    table = [("Year", "Title", "Author", "Publisher", "Average Rating")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:5]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No books with the year " + '"' + year + '" (or invalid year)')

def author_high_book_3(conn):

    cmd = """
    WITH t as (SELECT author,
                  count(*)
           FROM books
           GROUP BY author
           HAVING count(*) >= 3),
    s as(SELECT author, isbn, title
          FROM books NATURAL JOIN t),
    x as (SELECT isbn, author, title, rating
          FROM s natural join ratings),
    w as (SELECT author, max(rating) as ratingmax
          FROM x
          group by author)
    SELECT DISTINCT
        x.author as author, title, rating
    FROM
        x, w
    WHERE
        x.rating = w.ratingmax AND
        x.author = w.author;
    """

    cur = conn.cursor()
    cur.execute(cmd)

    table = [("Author", "Title", "Rating")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:3]]
        table.append(newrow)

    print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))

def author_avg_rate_year(conn):
    author = input("Enter a author: ")
    author = author.lower()

    #SQL injection attack
    cmd = """
    WITH 
        t as (
            SELECT isbn, title, author, year 
            FROM books 
            WHERE lower(author) = """ + "'" + author + "'" """), 
        s as (
            SELECT *   
            FROM t NATURAL JOIN ratings) 
    SELECT avg(rating), count(isbn), year 
    FROM s 
    GROUP BY year;
    """

    # To execute this SQL Injection attack, when a user is asked for input the user is to put any letter followed by
    # '; and then an SQL command that does something to the database

    cur = conn.cursor()
    cur.execute(cmd,(author,))
    count = len(cur.fetchall())
    cur.execute(cmd, (author,))

    table = [("Avg Rating", "#books", "Year")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:3]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No author with the name " + '"' + author + '"')

def high_avg_rate_age(conn):
    while True:
        try:
            age1 = int(input("Enter 1st age: "))
        except ValueError:
            print("Please enter a valid age:")
        else:
            break
    while True:
        try:
            age2 = int(input("Enter 2nd age: "))
        except ValueError:
            print("Please enter a valid age")
        else:
            break

    if age1 > age2:
        tempage = age2
        age2 = age1
        age1 = tempage

    cmd = """
    WITH t as (SELECT id, age
           FROM users
           WHERE age >= %s
             AND age <= %s),
    s as (SELECT *
          FROM ratings
                   NATURAL JOIN t),
    x as (SELECT avg(rating) as avg, isbn
          FROM s
          GROUP BY isbn),
    y as (SELECT max(avg) as max
          FROM x),
    z as (SELECT isbn
          FROM x, y
          WHERE max = avg)
    SELECT title
    FROM z NATURAL JOIN books;
    """

    cur = conn.cursor()
    cur.execute(cmd, (age1, age2,))
    count = len(cur.fetchall())
    cur.execute(cmd, (age1, age2,))

    table = [("Title")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:1]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No books in age range")

def state_high_avg_rate(conn):
    state1 = input("Enter 1st state: ")
    state1 = state1.lower()
    state2 = input("Enter 2nd state: ")
    state2 = state2.lower()
    state3 = input("Enter 3rd state: ")
    state3 = state3.lower()

    cmd = """
    WITH t as (SELECT id,
                  unnest(string_to_array(location, ', ')) as location
           FROM users),
    s as (SELECT id
          FROM t
          WHERE location = %s
             or location = %s
             or location = %s),
    x as (SELECT isbn, avg(rating) as avg
          FROM s NATURAL JOIN ratings
          GROUP BY isbn),
    y as (SELECT max(avg) as max
          FROM x),
    z as (SELECT isbn
          FROM x, y
          WHERE avg = max)
    SELECT title
    FROM z NATURAL JOIN books;
    """

    cur = conn.cursor()
    cur.execute(cmd, (state1, state2, state3,))
    count = len(cur.fetchall())
    cur.execute(cmd, (state1, state2, state3,))

    table = [("Title")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:1]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("No books rated in given states (or invalid states entered)")

# if this file is being run as a program and *not* imported
# as a module
if __name__ == "__main__":
    conn = connect_ratings()
    opt_map = {'1': lookup_by_title,
               '2': lookup_by_author,
               '3': avg_rate_year,
               '4': author_high_book_3,
               '5': author_avg_rate_year,
               '6': high_avg_rate_age,
               '7': state_high_avg_rate}

    while True:
        opt = menu()
        if opt == 'q' or opt == 'Q':
            print("Bye Bye")
            break
        # do something for quit
        opt_map[opt](conn)