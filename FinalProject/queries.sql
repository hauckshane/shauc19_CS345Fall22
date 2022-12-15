-- Looking for a valuable Central Midfielder that breaks defensive lines in the attacking 3rd of the pitch based on rank
with t as (SELECT *
           FROM "Positions_Played"
           WHERE position = 'CM'),
    s as (SELECT player_name, "Att 3rd_Touches"
          FROM t NATURAL JOIN "Player_Season_Possession"
          WHERE player_name = "Player"),
    x as (SELECT player_name, "Att 3rd_Touches", "TB_Pass_Types"
          FROM "Player_Season_Passing_Types" NATURAL JOIN s
          WHERE player_name = "Player"),
    y as (SELECT player_name,
                 "Att 3rd_Touches",
                 "TB_Pass_Types",
                 RANK() OVER (ORDER BY "Att 3rd_Touches" DESC) as "Att 3rd_Touches Rank",
                 RANK() OVER (ORDER BY "TB_Pass_Types" DESC)   as "TB_Pass_Types Rank"
          FROM x),
    z as (SELECT *, "Att 3rd_Touches Rank" + "TB_Pass_Types Rank" as rank_total
          FROM y
          ORDER by rank_total
          LIMIT 10)
SELECT player_name, cast(player_valuation as REAL), rank_total, "Att 3rd_Touches", "TB_Pass_Types", "Att 3rd_Touches Rank", "TB_Pass_Types Rank"
FROM z NATURAL JOIN "Player_Valuations"
ORDER BY rank_Total;


--  Find the players who have played more than 1000 minutes with the most expected goals and expected assisted goals combined per 90 minutes
with t as (SELECT "Player", "Min", "xG_Expected", "xAG_Expected"
           FROM "Player_Season_Summary"
           WHERE "Min" > 1000),
    s as (SELECT *, "Min" / 90 as "90s"
          FROM t),
    x as (SELECT *, "xG_Expected" / "90s" as "xG per 90", "xAG_Expected" / "90s" as "xAG per 90"
          FROM s)
SELECT "Player", "xG per 90"+"xAG per 90" as "xG + xAG per 90"
FROM x
ORDER BY "xG + xAG per 90" DESC
LIMIT 10;

-- Find the players who have played more than 1000 minutes with the most progressive passes of the ball for every 100 touches they take
with t as (SELECT "Player", "Min", "Prog", "Touches_Touches" as Touches
           FROM "Player_Season_Possession" NATURAL JOIN "Player_Season_Passing"
           WHERE "Min" > 1000),
    s as (SELECT *, touches / 100 as per100Touches
          FROM t)
SELECT "Player", "Prog" / per100touches as "Progressive Passes per100touches"
FROM s
ORDER BY "Progressive Passes per100touches" DESC
LIMIT 10;