create table "Clubs"
(
    country TEXT,
    squad   TEXT,
    primary key (squad)
);

create table "Competitions"
(
    "Competitions" TEXT
);

create table "Clubs_Play_In"
(
    Team text,
    Comp text,
    primary key (Team, Comp),
    constraint "Team"
        foreign key (Team) references "Clubs" (Squad)
);

create table "Matchday_Table"
(
    league text,
    matchday int,
    rk int,
    squad text,
    p int,
    w int,
    d int,
    l int,
    gf int,
    ga int,
    g_diff int,
    pts int,
    primary key (league, matchday, squad),
    foreign key (league, squad) references "Clubs_Play_In" (Comp, Team)
);

create table "Players"
(
    player_name text,
    date_of_birth text,
    age int,
    place_of_birth text,
    citizenship text,
    height numeric(3,2),
    foot text,
    primary key (player_name)
);

create table "Positions_Played"
(
    player_name text,
    position text,
    foreign key (player_name) references "Players" (player_name)
);

create table "Fixtures"
(
    Date text,
    Team text,
    Competition text,
    Round text,
    Venue text,
    Opponent text,
    primary key (Date, Team),
    foreign key (Team, Competition) references "Clubs_Play_In" (Team, Comp)
);

create table "Fixture_Report"
(
    Date text,
    Team text,
    Result text,
    GF int,
    GA int,
    xG numeric(5,1),
    xGA numeric(5,1),
    Poss int,
    primary key (Date, Team),
    foreign key (Date, Team) references "Fixtures" (Date, Team)
);


create table "Player_Plays_In"
(
    Date text,
    Team text,
    Player_Name text,
    Starting text,
    Min int,
    primary key (Player_Name, Date, Team),
    foreign key (Player_Name) references "Players" (player_name),
    foreign key (Date, Team) references "Fixtures" (Date, Team)
);

create table "Player_Game_Summary"
(
    Match_Date text,
    Team text,
    Player text,
    Pos text,
    Min int,
    Gls int,
    Ast int,
    PK int,
    PKatt int,
    Sh int,
    SoT int,
    CrdY int,
    CrdR int,
    Touches int,
    Tkl int,
    Int int,
    Blocks int,
    SCA_SCA int,
    GCA_SCA int,
    Cmp_Passes int,
    Att_Passes int,
    Cmp_percent_Passes int,
    Prog_Passes int,
    Succ_Dribbles int,
    Att_Dribbles int,
    primary key (Player, Match_Date, Team),
    foreign key (Player, Match_Date, Team) references "Player_Plays_In" (Player_Name, Date, Team)
);

create table "Player_Game_Possession"
(
    Match_Date text,
    Team text,
    Player text,
    Pos text,
    Min int,
    Touches int,
    "Def Pen_Touches" int,
    "Def 3rd_Touches" int,
    "Mid 3rd_Touches" int,
    "Att 3rd_Touches" int,
    "Att Pen_Touches" int,
    Live_Touches int,
    Succ_Dribbles int,
    Att_Dribbles int,
    Succ_percent_Dribbles int,
    Mis_Dribbles int,
    Dis_Dribbles int,
    Rec_Receiving int,
    Prog_Receiving int,
    primary key (Player, Match_Date, Team),
    foreign key (Player, Match_Date, Team) references "Player_Plays_In" (Player_Name, Date, Team)
);



create table "Player_Game_Passing"
(
    "Match_Date"         TEXT,
    "Team"               TEXT,
    "Player"             TEXT,
    "Pos"                TEXT,
    "Min"                INT,
    "Cmp_Total"          INT,
    "Att_Total"          INT,
    "Cmp_percent_Total"  TEXT,
    "TotDist_Total"      INT,
    "PrgDist_Total"      INT,
    "Cmp_Short"          INT,
    "Att_Short"          INT,
    "Cmp_percent_Short"  INT,
    "Cmp_Medium"         INT,
    "Att_Medium"         INT,
    "Cmp_percent_Medium" INT,
    "Cmp_Long"           INT,
    "Att_Long"           INT,
    "Cmp_percent_Long"   INT,
    "Ast"                INT,
    "xAG"                NUMERIC,
    "xA"                 NUMERIC,
    KP                   INT,
    "Final_Third"        INT,
    PPA                  INT,
    "CrsPA"              INT,
    "Prog"               INT,
    primary key ("Player", "Match_Date", "Team"),
    foreign key ("Player", "Match_Date", "Team") references "Player_Plays_In" (Player_Name, Date, Team)
);


create table "Player_Game_Misc"
(
    "Match_Date"               TEXT,
    "Team"                     TEXT,
    "Player"                   TEXT,
    "Pos"                      TEXT,
    "Min"                      INT,
    "CrdY"                     INT,
    "CrdR"                     INT,
    "2CrdY"                    INT,
    "Fls"                      INT,
    "Fld"                      INT,
    "Off"                      INT,
    "Crs"                      INT,
    "Int"                      INT,
    "TklW"                     INT,
    "PKwon"                    INT,
    "PKcon"                    INT,
    OG                         INT,
    "Recov"                    INT,
    "Won_Aerial_Duels"         INT,
    "Lost_Aerial_Duels"        INT,
    "Won_percent_Aerial_Duels" INT,
    primary key ("Player", "Match_Date", "Team"),
    foreign key ("Player", "Match_Date", "Team") references "Player_Plays_In" (Player_Name, Date, Team)
);

create table "Player_Game_Keeper"
(
    "Match_Date"                 TEXT,
    "Team"                       TEXT,
    "Player"                     TEXT,
    "Min"                        INT,
    "SoTA_Shot_Stopping"         INT,
    "GA_Shot_Stopping"           INT,
    "Saves_Shot_Stopping"        INT,
    "Save_percent_Shot_Stopping" INT,
    "PSxG_Shot_Stopping"         NUMERIC,
    "Cmp_Launched"               INT,
    "Att_Launched"               INT,
    "Cmp_percent_Launched"       INT,
    "Att_Passes"                 INT,
    "Thr_Passes"                 INT,
    "Launch_percent_Passes"      INT,
    "AvgLen_Passes"              NUMERIC,
    "Att_Goal_Kicks"             INT,
    "Launch_percent_Goal_Kicks"  INT,
    "AvgLen_Goal_Kicks"          NUMERIC,
    "Opp_Crosses"                INT,
    "Stp_Crosses"                INT,
    "Stp_percent_Crosses"        NUMERIC,
    "Player_NumOPA_Sweeper"      INT,
    "AvgDist_Sweeper"            NUMERIC,
    primary key ("Player", "Match_Date", "Team"),
    foreign key ("Player", "Match_Date", "Team") references "Player_Plays_In" (Player_Name, Date, Team)
);

create table "Player_Game_Passing_Types"
(
    "Match_Date"       TEXT,
    "Team"             TEXT,
    "Player"           TEXT,
    "Pos"              TEXT,
    "Min"              INT,
    "Att"              INT,
    "Live_Pass_Types"  INT,
    "Dead_Pass_Types"  INT,
    "FK_Pass_Types"    INT,
    "TB_Pass_Types"    INT,
    "Sw_Pass_Types"    INT,
    "Crs_Pass_Types"   INT,
    "TI_Pass_Types"    INT,
    "CK_Pass_Types"    INT,
    "In_Corner_Kicks"  INT,
    "Out_Corner_Kicks" INT,
    "Str_Corner_Kicks" INT,
    "Cmp_Outcomes"     INT,
    "Off_Outcomes"     INT,
    "Blocks_Outcomes"  INT,
    primary key ("Player", "Match_Date", "Team"),
    foreign key ("Player", "Match_Date", "Team") references "Player_Plays_In" (Player_Name, Date, Team)
);

create table "Player_Game_Defense"
(
    "Match_Date"              TEXT,
    "Team"                    TEXT,
    "Player"                  TEXT,
    "Pos"                     TEXT,
    "Min"                     INT,
    "Tkl_Tackles"             INT,
    "TklW_Tackles"            INT,
    "Def 3rd_Tackles"         INT,
    "Mid 3rd_Tackles"         INT,
    "Att 3rd_Tackles"         INT,
    "Tkl_Vs_Dribbles"         INT,
    "Att_Vs_Dribbles"         INT,
    "Tkl_percent_Vs_Dribbles" TEXT,
    "Past_Vs_Dribbles"        INT,
    "Blocks_Blocks"           INT,
    "Sh_Blocks"               INT,
    "Pass_Blocks"             INT,
    "Int"                     INT,
    "Tkl+Int"                 INT,
    "Clr"                     INT,
    "Err"                     INT,
    primary key ("Player", "Match_Date", "Team"),
    foreign key ("Player", "Match_Date", "Team") references "Player_Plays_In" (Player_Name, Date, Team)
);

create table "Plays_For"
(
    player_name      TEXT,
    current_club     TEXT,
    joined           TEXT,
    contract_expires TEXT,
    primary key (player_name, current_club),
    foreign key (player_name) references "Players" (player_name),
    foreign key (current_club) references "Clubs" (squad)
);

create table "Player_Citizenship"
(
    player_name TEXT,
    citizenship text,
    foreign key (player_name) references "Players" (player_name)
);