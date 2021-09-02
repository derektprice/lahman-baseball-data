-- Q1. What range of years for baseball games played does the provided database cover?
-- A1: 1871 to 2016
SELECT
	MIN(year) AS first_year,
	MAX(YEAR) AS last_year
FROM homegames;

-- SELECT
-- 	MIN(yearid) AS first_year,
-- 	MAX(yearid) AS last_year
-- FROM teams
-- this gets same years


-- Q2: Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
-- A2:"Eddie"	"Gaedel"	Height: 43in	Games: 1	Team: "SLA"

SELECT
	nameFirst AS First_name,
	nameLast AS Last_name,
	height AS height_in_inches,
	a.g_all,
	a.teamID
FROM people as p
LEFT JOIN appearances as a
ON p.playerid = a.playerid
WHERE height IN
	(SELECT MIN(height)
	 FROM people
	);

-- Q3: Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
-- A: David Price - no relation to me, as far as I know!

SELECT
	s.playerid,
	p.namefirst,
	p.namelast,
	SUM(s.salary) AS total_salary
FROM salaries as s
LEFT JOIN people as p
ON s.playerid = p.playerid
WHERE s.playerid IN (
	SELECT 
		DISTINCT playerid
	FROM collegeplaying as c
	WHERE schoolid = 'vandy')
GROUP BY s.playerid, p.namefirst, p.namelast
ORDER BY total_salary DESC;
	

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
-- A: "Battery"	41424
-- "Infield"	58934
-- "Outfield"	29560

WITH positions AS (
	SELECT
	po,
	yearid,
	CASE WHEN pos IN ('OF') THEN 'Outfield'
		WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	 	WHEN pos IN ('P', 'C') THEN 'Battery'
	 	END AS position_group
FROM fielding)

SELECT
	p.position_group,
	SUM(po) AS total_putouts
FROM positions as p
WHERE yearid = 2016
GROUP BY position_group;


-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
-- A: run query. 

WITH data_stuff AS (SELECT
	so AS strikeouts_by_batters,
	hr as homeruns_by_batters,
	FLOOR(yearid/10) * 10 AS decade
FROM teams)

SELECT
	ROUND(AVG(strikeouts_by_batters),2) AS avg_strikeouts,
	ROUND(AVG(homeruns_by_batters),2) AS avg_homeruns,
	decade,
	
FROM data_stuff
WHERE decade >=1920
GROUP BY decade
ORDER BY decade;


-- 6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.
-- A: owingch01, or Chris Owings,
WITH steals_2016 AS (SELECT playerid,
	SUM(sb+cs) AS steal_attempts,
	SUM(sb) AS sum_steal_success 
FROM batting
WHERE yearid = 2016
GROUP BY playerid)

SELECT p.namefirst,
	p.namelast,
	p.playerid,
	s.steal_attempts,
	s.sum_steal_success,
	ROUND(CAST(sum_steal_success AS dec) / steal_attempts, 2) AS success_rate
FROM steals_2016 as s
LEFT JOIN people as p
ON s.playerid = p.playerid
WHERE sum_steal_success >20
ORDER BY success_rate DESC;

-- 7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
-- A:



-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
-- A:



-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
-- A:


