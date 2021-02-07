-- SQL AGGREGATING DATA

-- Sum the demand_loss_mw column with the alias "MRO_demand_loss"
SELECT 
  SUM(demand_loss_mw) AS MRO_demand_loss
FROM 
  grid 
WHERE
  -- demand_loss_mw should not contain NULL values
  demand_loss_mw IS NOT NULL
  -- and nerc_region should be 'MRO';
  AND nerc_region = 'MRO';

-- Obtain a COUNT of 'grid_id' alias as grid_count
SELECT 
  COUNT(grid_id) AS grid_total
FROM 
  grid;

-- Obtain a count of 'grid_id'
SELECT 
  COUNT(grid_id) AS RFC_count
FROM 
  grid
-- Restrict to rows where the nerc_region is 'RFC'
WHERE
  nerc_region = 'RFC';


-- MIN, MAX, AVERAGE
-- Find the minimum number of affected customers
SELECT 
  MIN(affected_customers) AS min_affected_customers
FROM 
  grid
-- Only retrieve rows where demand_loss_mw has a value
WHERE
  demand_loss_mw IS NOT NULL;

-- Amend the query to return the maximum value
-- from the same column, this time aliasing as max_affected_customers.
SELECT
  MAX(affected_customers) AS max_affected_customers
FROM
  grid
WHERE
  demand_loss_mw IS NOT NULL

-- Return the average value from the affected_customers column,
-- this time aliasing as avg_affected_customers.
SELECT
  AVG(affected_customers) AS avg_affected_customers
FROM
  grid
WHERE
  demand_loss_mw IS NOT NULL;


-- STRINGS
