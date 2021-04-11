-- Intermediate SQL Course on Datacamp

-- 1. Select the team's long name and API id from the teams_germany table.
-- Filter the query for FC Schalke 04 and FC Bayern Munich using IN, giving you the team_api_IDs needed for the next step.

SELECT
	-- Select the team long name and team API id
	team_long_name,
	team_api_id
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');

-- 2. Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
	CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
             WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
             ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;

-- 3. Select the date of the match and create a CASE statement
-- to identify matches as home wins, home losses, or ties.
SELECT date,
	-- Select the date of the match
	-- Identify home wins, losses, or ties
	CASE WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN'Home loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain;

-- 4. In this exercise, you will be creating a list of matches in the 
-- 2011/2012 season where Barcelona was the home team.
-- You will do this using a CASE statement that compares the values
-- of two columns to create a new group -- wins, losses, and ties. 
SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
         WHEN m.home_goal < m.away_goal THEN 'Home loss :('
         ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;