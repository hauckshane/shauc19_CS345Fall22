
import psycopg2
from tabulate import tabulate
import html

def connect_ratings():

    try:
        conn = psycopg2.connect(
            dbname="finalproject_shauc19",
            user="shauc19",
            password="TheMan05",
            host="ada.hpc.stlawu.edu"
        )
    except psycopg2.Error:
        print("Error: cannot connect to database")
        exit()

    return conn

def menu():
    """
    Present the user with a menu and return selection
    only if valid.
    :return: option selected
    """
    while True:
        print("What would you like to look at?")
        print("1) Players")
        print("2) Clubs")
        print("Q) Quit")
        opt = input("Type Number > ")
        if opt in ['1', '2', 'q', 'Q']:
            break

    return opt

def players(conn):
    player = input("Enter a player: ")
    player = player.lower()
    print("What would you like to focus on?: ")
    print("1) Player Bio")
    print("2) Player Citizenship")
    print("3) Player Positions")
    print("4) Current Club")
    print("5) Fixtures Played In")
    print("6) Fixture Stats")
    print("7) Season Stats")
    print("8) Player Valuations")
    step = input("Type Number > ")
    if step == '1':
        player_bio(player)
    elif step == '2':
        player_citizenship(player)
    elif step == '3':
        player_positions(player)
    elif step == '4':
        player_club(player)
    elif step == '5':
        player_fixtures(player)
    elif step == '6':
        player_fixture_stats(player)
    elif step == '7':
        player_season_stats(player)
    elif step == '8':
        player_valuations(player)

def player_bio(player):
    cmd = """
        SELECT *
        FROM "Players"
        WHERE lower(player_name) = %s;
    """

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    table = [("Player", "Date Of Birth", "Age", "Place of Birth", "Height", "Preferred Foot")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:6]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid team")

def player_citizenship(player):
    cmd = """
        SELECT *
        FROM "Player_Citizenship"
        WHERE lower(player_name) = %s;
    """

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    table = [("Player", "Citizenship")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:2]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid team")

def player_positions(player):
    cmd = """
        SELECT *
        FROM "Positions_Played"
        WHERE lower(player_name) = %s;
    """

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    table = [("Player", "Position")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:2]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def player_club(player):
    cmd = """
        SELECT *
        FROM "Plays_For"
        WHERE lower(player_name) = %s;
    """

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    table = [("Player", "Club", "Joined", "Contract Expires")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:4]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def player_fixtures(player):
    cmd = """
        SELECT *
        FROM "Player_Plays_In"
        WHERE lower(player_name) = %s;
    """

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    table = [("Date", "Club", "Player", "Starting", "Min")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:5]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def player_fixture_stats(player):
    print("What type of stats would you like to look at?")
    print("1) Passing")
    print("2) Pass Types")
    print("3) Possession")
    print("4) Defense")
    print("5) Miscellaneous")
    type = input("Type Number > ")

    if type == '1':
        cmd = """
            SELECT *
            FROM "Player_Game_Passing"
            WHERE lower("Player") = %s;
        """
        table = [(
            "Match Date", "Team", "Player", "Pos", "Min", "Cmp Total", "Att Total", "Cmp Percent", "Total Distance", "Total Progressive Distance", "Cmp Short", "Att Short", "Cmp Percent",
            "Cmp Medium", "Att Medium", "Cmp Percent Medium", "Cmp Long", "Att Long", "Cmp Percent Long", "Ast", "xAG", "xA",
            "Key Passes", "Final Third", "Penalty Area", "Crosses", "Prog")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:27]]
            table.append(newrow)
    elif type == '2':
        cmd = """
                    SELECT *
                    FROM "Player_Game_Passing_Types"
                    WHERE lower("Player") = %s;
                """
        table = [(
            "Match Date", "Team", "Player", "Pos", "Min", "Att", "Live", "Dead", "Free Kicks",
            "Through Balls", "Switches", "Crosses", "Throw Ins",
            "Corners", "In Swing Corners", "Out Swing Corners", "Straight Corners", "Cmp Outcomes", "Offside Outcomes", "Blocked Outcomes")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:20]]
            table.append(newrow)
    elif type == '3':
        cmd = """
            SELECT *
            FROM "Player_Game_Possession"
            WHERE lower(Player) = %s;
        """
        table = [(
            "Match Date", "Team", "Player", "Pos", "Min", "Touches", "Def Pen Touches", "Def 3rd Touches", "Mid 3rd Touches",
            "Att 3rd Touches", "Att Pen Touches", "Live Touches", "Succ Dribbles",
            "Att Dribbles", "Succ Percent Dribbles", "Mistake Dribbles", "Dispossessed Dribbles", "Receptions", "Progressive Receptions")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:19]]
            table.append(newrow)
    elif type == '4':
        cmd = """
            SELECT *
            FROM "Player_Game_Defense"
            WHERE lower("Player") = %s;
        """
        table = [(
            "Match Date", "Team", "Player", "Pos", "Min", "Tkls", "Tkl Won", "Def 3rd Tkls", "Mid 3rd Tkls",
            "Att 3rd Tkls", "Tkls vs Dribbles", "Att vs Dribbles", "Tkl vs Dribbles Percent",
            "Past vs Dribbles", "Blocks", "Shots Blocked", "Pass Blocks", "Interceptions", "Tkl + Int", "Clearances", "Errors")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:21]]
            table.append(newrow)
    elif type == '5':
        cmd = """
                    SELECT *
                    FROM "Player_Game_Misc"
                    WHERE lower("Player") = %s;
                """
        table = [(
            "Match Date", "Team", "Player", "Pos", "Min", "CrdY", "CrdR", "2CrdY", "Fouls",
            "Fouled", "Offsides", "Crosses", "Interceptions",
            "Tackles Won", "PK Won", "PK Conceded", "Own Goals", "Recoveries", "Aerial Duals Won", "Aeriel Duals Lost",
            "Aerial Duals Win Percent")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:21]]
            table.append(newrow)


    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def player_season_stats(player):
    print("What type of stats would you like to look at?")
    print("1) Passing")
    print("2) Pass Types")
    print("3) Possession")
    print("4) Defense")
    print("5) Miscellaneous")
    type = input("Type Number > ")

    if type == '1':
        cmd = """
            SELECT *
            FROM "Player_Season_Passing"
            WHERE lower("Player") = %s;
        """
        table = [(
            "Player", "Min", "Cmp Total", "Att Total", "Cmp Percent", "Total Distance", "Total Progressive Distance", "Cmp Short", "Att Short", "Cmp Percent",
            "Cmp Medium", "Att Medium", "Cmp Percent Medium", "Cmp Long", "Att Long", "Cmp Percent Long", "Ast", "xAG", "xA",
            "Key Passes", "Final Third", "Penalty Area", "Crosses", "Prog")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:24]]
            table.append(newrow)
    elif type == '2':
        cmd = """
                    SELECT *
                    FROM "Player_Season_Passing_Types"
                    WHERE lower("Player") = %s;
                """
        table = [(
            "Player", "Min", "Att", "Live", "Dead", "Free Kicks",
            "Through Balls", "Switches", "Crosses", "Throw Ins",
            "Corners", "In Swing Corners", "Out Swing Corners", "Straight Corners", "Cmp Outcomes", "Offside Outcomes", "Blocked Outcomes")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:17]]
            table.append(newrow)
    elif type == '3':
        cmd = """
            SELECT *
            FROM "Player_Season_Possession"
            WHERE lower("Player") = %s;
        """
        table = [(
            "Player", "Min", "Touches", "Def Pen Touches", "Def 3rd Touches", "Mid 3rd Touches",
            "Att 3rd Touches", "Att Pen Touches", "Live Touches", "Succ Dribbles",
            "Att Dribbles", "Succ Percent Dribbles", "Mistake Dribbles", "Dispossessed Dribbles", "Receptions", "Progressive Receptions")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:16]]
            table.append(newrow)
    elif type == '4':
        cmd = """
            SELECT *
            FROM "Player_Season_Defense"
            WHERE lower("Player") = %s;
        """
        table = [(
            "Player", "Min", "Tkls", "Tkl Won", "Def 3rd Tkls", "Mid 3rd Tkls",
            "Att 3rd Tkls", "Tkls vs Dribbles", "Att vs Dribbles", "Tkl vs Dribbles Percent",
            "Past vs Dribbles", "Blocks", "Shots Blocked", "Pass Blocks", "Interceptions", "Tkl + Int", "Clearances", "Errors")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:18]]
            table.append(newrow)
    elif type == '5':
        cmd = """
                    SELECT *
                    FROM "Player_Season_Misc"
                    WHERE lower("Player") = %s;
                """
        table = [(
            "Player", "Min", "CrdY", "CrdR", "2CrdY", "Fouls",
            "Fouled", "Offsides", "Crosses", "Interceptions",
            "Tackles Won", "PK Won", "PK Conceded", "Own Goals", "Recoveries", "Aerial Duals Won", "Aeriel Duals Lost",
            "Aerial Duals Win Percent")]

        cur = conn.cursor()
        cur.execute(cmd, (player,))
        count = len(cur.fetchall())
        cur.execute(cmd, (player,))

        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:18]]
            table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def player_valuations(player):
    cmd = """
        SELECT *
        FROM "Player_Valuations"
        WHERE lower(player_name) = %s;
    """

    table = [("Player", "Current Valuation", "Max Valuation", "Max Valuation Date")]

    cur = conn.cursor()
    cur.execute(cmd, (player,))
    count = len(cur.fetchall())
    cur.execute(cmd, (player,))

    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:4]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid player")

def clubs(conn):
    club = input("Enter a club: ")
    club = club.lower()
    print("What would you like to focus on?:")
    print("1) Roster")
    print("2) Competitions")
    print("3) Fixtures")
    step = input("> ")
    if step == '1':
        club_roster(club)
    elif step == '2':
        club_competitions(club)
    elif step == '3':
        club_fixtures(club)

def club_roster(club):
    cmd = """
                SELECT player_name
                FROM "Plays_For"
                WHERE lower(current_club) = %s;
            """

    cur = conn.cursor()
    cur.execute(cmd, (club,))
    count = len(cur.fetchall())
    cur.execute(cmd, (club,))

    table = [("Player")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:5]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid team")

def club_competitions(club):
    cmd = """
                SELECT comp
                FROM "Clubs_Play_In"
                WHERE lower(team) = %s;
            """
    cur = conn.cursor()
    cur.execute(cmd, (club,))
    count = len(cur.fetchall())
    cur.execute(cmd, (club,))

    table = ["Competition"]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:1]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid team")

def club_fixtures(club):
    cmd = """
            SELECT *
            FROM "Fixtures"
            WHERE lower(team) = %s;
    """
    cur = conn.cursor()
    cur.execute(cmd, (club,))
    count = len(cur.fetchall())
    cur.execute(cmd, (club,))

    table = [("Date", "Team", "Competition","Round", "Opponent", "Venue")]
    for row in cur:
        newrow = [html.unescape(str(i)) for i in row[0:6]]
        table.append(newrow)

    if count > 0:
        print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
    else:
        print("Not a valid team")

    print("Would you like to see the fixture reports?")
    yesno = input("Y/N > ")
    if yesno == 'Y' or 'y':
        cmd = """
            SELECT *
            FROM "Fixture_Report"
            WHERE lower(team) = %s;
            """
        cur = conn.cursor()
        cur.execute(cmd, (club,))
        count = len(cur.fetchall())
        cur.execute(cmd, (club,))

        table = [("Date", "Team", "Result", "GF", "GA", "xG", "xGA", "Poss")]
        for row in cur:
            newrow = [html.unescape(str(i)) for i in row[0:8]]
            table.append(newrow)

        if count > 0:
            print(tabulate(table, tablefmt='fancy_grid', headers="firstrow"))
        else:
            print("Not a valid team")



if __name__ == "__main__":
    conn = connect_ratings()
    opt_map = {'1': players,
               '2': clubs}

    while True:
        opt = menu()
        if opt == 'q' or opt == 'Q':
            print("Bye Bye")
            break
        # do something for quit
        opt_map[opt](conn)