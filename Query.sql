use [Home Office]
select * from April

-- merge all the values of the table
--union all help to remove the duplicates

SELECT * FROM april
UNION ALL
SELECT * FROM may
UNION ALL
SELECT * FROM june
UNION ALL
SELECT * FROM july
UNION ALL
SELECT * FROM august
UNION ALL
SELECT * FROM september
UNION ALL
SELECT * FROM october
UNION ALL
SELECT * FROM november
UNION ALL
SELECT * FROM december
UNION ALL
SELECT * FROM january
UNION ALL
SELECT * FROM february
UNION ALL
SELECT * FROM march;

-- Step 1: Create the new table named home with data from the first month
SELECT DISTINCT *
INTO home
FROM april;

-- Step 2: Insert data from the other monthly tables, avoiding duplicates
INSERT INTO home
SELECT DISTINCT * FROM may
UNION
SELECT DISTINCT * FROM june
UNION
SELECT DISTINCT * FROM july
UNION
SELECT DISTINCT * FROM august
UNION
SELECT DISTINCT * FROM september
UNION
SELECT DISTINCT * FROM october
UNION
SELECT DISTINCT * FROM november
UNION
SELECT DISTINCT * FROM december
UNION
SELECT DISTINCT * FROM january
UNION
SELECT DISTINCT * FROM february
UNION
SELECT DISTINCT * FROM march;

select * from home

-- remove values that are negative in spend and which are null
delete from home
where spend <0 or spend is null;

select* from home

-- checking the data type of home
EXEC sp_help 'home';



-- Query 1
--Calculate the top three payment types and the total amount spent 
--on these payment types and in each of the four quarters April
--June, July-September, October-December, and January-March. 
SELECT Top 3
    Expense_Type, 
    SUM(CASE WHEN date BETWEEN '2018-01-01' AND '2018-03-31' THEN Spend ELSE 0 END) AS q1,
    SUM(CASE WHEN date BETWEEN '2017-04-01' AND '2017-06-30' THEN Spend ELSE 0 END) AS q2,
    SUM(CASE WHEN date BETWEEN '2017-07-01' AND '2017-09-30' THEN Spend ELSE 0 END) AS q3,
    SUM(CASE WHEN date BETWEEN '2017-10-01' AND '2017-12-31' THEN Spend ELSE 0 END) AS q4,
    SUM(Spend) AS total
FROM 
    home
WHERE 
    date BETWEEN '2018-01-01' AND '2018-03-31'
    OR date BETWEEN '2017-04-01' AND '2017-06-30'
    OR date BETWEEN '2017-07-01' AND '2017-09-30'
    OR date BETWEEN '2017-10-01' AND '2017-12-31'
GROUP BY 
    Expense_Type
ORDER BY 
    total DESC;


-- I calculated the expense type individually as well with the top three Expense type for each quarter 

-- Quarter 1: January to March
SELECT TOP 3 Expense_Type, SUM(Spend) AS total
FROM home
WHERE date BETWEEN '2018-01-01' AND '2018-03-31'
GROUP BY Expense_Type
ORDER BY total DESC;

-- Quarter 2: April to June
SELECT TOP 3 Expense_Type, SUM(Spend) AS total
FROM home
WHERE date BETWEEN '2017-04-01' AND '2017-06-30'
GROUP BY Expense_Type
ORDER BY total DESC;

-- Quarter 3: July to September
SELECT TOP 3 Expense_Type, SUM(Spend) AS total
FROM home
WHERE date BETWEEN '2017-07-01' AND '2017-09-30'
GROUP BY Expense_Type
ORDER BY total DESC;

-- Quarter 4: October to December
SELECT TOP 3 Expense_Type, SUM(Spend) AS total
FROM home
WHERE date BETWEEN '2017-10-01' AND '2017-12-31'
GROUP BY Expense_Type
ORDER BY total DESC;



-- Query 2
--Calculate the top four expense areas and the totals amount spent 
--on these areas for the year and for each of the two half-years April
--September and October-March 

select top 4 expense_area, sum(spend) as total
from home
group by expense_area
order by total Desc;


select top 4 Expense_area, 
	SUM(CASE WHEN date BETWEEN '2017-10-01' AND '2018-03-30' THEN Spend ELSE 0 END) AS FirstHalf,
    SUM(CASE WHEN date BETWEEN '2017-04-01' AND '2017-09-30' THEN Spend ELSE 0 END) AS SecondHalf,
	sum(spend) as Total
From home
WHERE 
    date BETWEEN '2017-10-01' AND '2018-03-30'
    OR date BETWEEN '2017-04-01' AND '2017-09-30'
group by Expense_area
order by Total Desc;



-- query 3
--For each quarter of the year rank the top 10 Suppliers by total net 
--spend made to them by the home office. Clearly indicate the 
--change in rank for each quarter The rankings must be in ascending 
--order. 

select * from home

WITH QuarterTotals AS (
    SELECT 
        supplier_name,
        SUM(CASE WHEN date BETWEEN '2018-01-01' AND '2018-03-31' THEN Spend ELSE 0 END) AS q1_total,
        SUM(CASE WHEN date BETWEEN '2017-04-01' AND '2017-06-30' THEN Spend ELSE 0 END) AS q2_total,
        SUM(CASE WHEN date BETWEEN '2017-07-01' AND '2017-09-30' THEN Spend ELSE 0 END) AS q3_total,
        SUM(CASE WHEN date BETWEEN '2017-10-01' AND '2017-12-31' THEN Spend ELSE 0 END) AS q4_total
    FROM 
        home
    WHERE 
        date BETWEEN '2018-01-01' AND '2018-03-31'
        OR date BETWEEN '2017-04-01' AND '2017-06-30'
        OR date BETWEEN '2017-07-01' AND '2017-09-30'
        OR date BETWEEN '2017-10-01' AND '2017-12-31'
    GROUP BY 
        supplier_name
)
SELECT 
    supplier_name,
    q1_total,
    q2_total,
    q3_total,
    q4_total,
    q1_rank,
    q2_rank,
    q3_rank,
    q4_rank
FROM (
    SELECT TOP 10
        supplier_name,
        q1_total,
        q2_total,
        q3_total,
        q4_total,
        RANK() OVER (ORDER BY q1_total DESC) AS q1_rank,
        RANK() OVER (ORDER BY q2_total DESC) AS q2_rank,
        RANK() OVER (ORDER BY q3_total DESC) AS q3_rank,
        RANK() OVER (ORDER BY q4_total DESC) AS q4_rank
    FROM 
        QuarterTotals
) AS RankedTotals;



--query 4
--calculate the spend for each quarter and the total spend for each entity
select entity, 
 SUM(CASE WHEN date BETWEEN '2018-01-01' AND '2018-03-31' THEN Spend ELSE 0 END) AS qarter1,
    SUM(CASE WHEN date BETWEEN '2017-04-01' AND '2017-06-30' THEN Spend ELSE 0 END) AS quarter2,
    SUM(CASE WHEN date BETWEEN '2017-07-01' AND '2017-09-30' THEN Spend ELSE 0 END) AS quarter3,
    SUM(CASE WHEN date BETWEEN '2017-10-01' AND '2017-12-31' THEN Spend ELSE 0 END) AS quarter4,
    SUM(Spend) AS total
FROM 
    home
WHERE 
    date BETWEEN '2018-01-01' AND '2018-03-31'
    OR date BETWEEN '2017-04-01' AND '2017-06-30'
    OR date BETWEEN '2017-07-01' AND '2017-09-30'
    OR date BETWEEN '2017-10-01' AND '2017-12-31'
GROUP BY 
    entity
ORDER BY 
    total DESC;







