SELECT * FROM PortfolioProject.dbo.Data1;
SELECT * FROM PortfolioProject.dbo.Data2; 

-- number of rows into the datasets
 
SELECT count(*) FROM PortfolioProject..Data1; 

SELECT count(*) FROM PortfolioProject..Data2; 

-- Generate data sets for Jharkhand & Bihar 

SELECT * FROM PortfolioProject..Data1 WHERE State in ('Jharkhand' , 'Bihar') 

-- Calculate Total Population of India 

SELECT sum(Population) as Population FROM PortfolioProject..Data2 

-- Average growth of India 

SELECT avg(growth)*100 as AverageGrowth From PortfolioProject..Data1;

-- Average growth percentage by state

SELECT state, avg(growth)*100 as AverageGrowth FROM PortfolioProject..Data1 group by State; 

-- Average Sex Ratio 

SELECT state, round(avg(sex_Ratio),0) as sexRatio FROM PortfolioProject..Data1 GROUP BY State; 

-- Average Sex Ratio in Descending Order 

SELECT state, round(avg(sex_ratio),0) as sexRatio FROM PortfolioProject..Data1 GROUP BY State ORDER BY sexRatio desc; 

-- Average Literacy Rate in ascending Order 

SELECT state, round(avg(Literacy), 0) as LiteracyAverage FROM PortfolioProject..Data1 GROUP BY State ORDER BY LiteracyAverage asc; 

-- Average Literacy Rate with greater that 90%

SELECT state, round(avg(Literacy), 0) as LiteracyAverage FROM PortfolioProject..Data1 GROUP BY State HAVING ROUND(AVG(Literacy),0) > 90;

-- Top 3 State having highest growth ratio
 
SELECT top 3 state, ROUND(avg(growth)*100 ,0) as Growth FROM PortfolioProject..Data1 GROUP BY state ORDER BY Growth DESC; 

-- Bottom 3 state showing the lowest Sex Ratio 

SELECT TOP 3 state, avg(sex_ratio) as sexRatioAvg FROM PortfolioProject..Data1 GROUP BY  State ORDER BY sexRatioAvg ASC; 

-- TOP and Bottom 3 states in Literacy State 

DROP TABLE IF EXISTS #topstates

CREATE TABLE #topStates (
	
	state NVARCHAR(255),
	topstates float

)

CREATE TABLE #bottomStates ( 
	
	state NVARCHAR(255), 
	bottomstates FLOAT
)


INSERT INTO #topstates
SELECT TOP 3 state, round(avg(literacy),0) avg_literacy_ratio FROM PortfolioProject..Data1
GROUP BY State ORDER BY avg_literacy_ratio DESC;

INSERT INTO #bottomStates
SELECT TOP 3 state, round(avg(literacy),0) AS avg_litercay_rate FROM PortfolioProject..Data1
GROUP BY State ORDER BY avg_litercay_rate ASC; 



SELECT * FROM #topStates
SELECT * FROM #bottomStates

-- Union Operator to combine both the results 

SELECT * FROM #topStates UNION SELECT * FROM #bottomStates

-- Using Subqueries 

SELECT * FROM (SELECT TOP 2 state, topstates FROM #topStates ORDER BY topstates DESC) A UNION 
SELECT * FROM (SELECT TOP 2 state, bottomstates FROM #bottomStates ORDER BY bottomstates ASC) B ORDER BY topstates DESC; 

-- Filter out states starting with Letter A or B

SELECT DISTINCT State FROM PortfolioProject..Data1 where lower(State) like 'a%' or lower(state) like 'b%'

-- Filter out states starting with Letter N and ending with letter D

SELECT DISTINCT state FROM PortfolioProject..Data1 WHERE lower(state) like 'n%' and lower(state) like '%d'

-- Joining both table 

SELECT a.District, a.state, a.sex_ratio, b.population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b on a.state=b.state; 

-- Finding total numbers of male and female 

SELECT d.District, d.state, d.population-d.males as Females, d.males FROM 
(SELECT c.District, c.state, C.Population, round(c.population/(c.sex_ratio +1),0) as males FROM
(SELECT a.District, a.state, a.sex_ratio/1000 as Sex_Ratio, b.population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b on a.District=b.District) c) d; 


-- Finding total number of males and females in the state 
SELECT d.state, sum(d.males) as Total_Males, sum(d.females) as Total_Females FROM 
(SELECT c.District, c.state, round(c.population/(c.sex_ratio +1),0) as males, round((c.population *c.sex_ratio)/(c.sex_ratio+1),0) as females  FROM 
(SELECT a.District, a.state, (a.sex_ratio/1000) as sex_ratio, b.population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b on a.district=b.District) c) d GROUP BY d.State;


-- Total Literacy rate 
SELECT c.state, sum(c.LiteratePopulation) TotalLiteratePopulation FROM 
(SELECT a.district, a.state, round((a.literacy*b.population)/100,0) as LiteratePopulation FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b on a.District=b.District) c GROUP BY State;


-- Population in Previous Census 

SELECT a.district, a.state, a.growth, round(b.population/(a.Growth+1),0) as OldPopulation, b.Population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b ON a.District=b.District


-- Average Growth of the state

SELECT c.state, SUM(c.population) as NowPopulation, SUM(C.OldPopulation) as OldPopulation FROM 
(SELECT a.district, a.state, a.growth, round(b.population/(a.Growth+1),0) as OldPopulation, b.Population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b ON a.District=b.District)c GROUP BY State


-- Total Population of India in Previous Census and this census
SELECT SUM(d.NowPopulation) as CurrentCensus, SUM(d.OldPopulation) as OldCensus FROM
(SELECT c.state, SUM(c.population) as NowPopulation, SUM(C.OldPopulation) as OldPopulation FROM 
(SELECT a.district, a.state, a.growth, round(b.population/(a.Growth+1),0) as OldPopulation, b.Population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b ON a.District=b.District)c GROUP BY State) d


-- Area Density


SELECT round((h.currentCensus/h.total_area),0) as current_density, round((h.oldCensus/h.total_area),0) as oldDensity FROM 
(SELECT f.CurrentCensus, f.OldCensus, g.total_area FROM 

(SELECT '1' as keyy, e.* FROM 
(SELECT SUM(d.NowPopulation) as CurrentCensus, SUM(d.OldPopulation) as OldCensus FROM
(SELECT c.state, SUM(c.population) as NowPopulation, SUM(C.OldPopulation) as OldPopulation FROM 
(SELECT a.district, a.state, a.growth, round(b.population/(a.Growth+1),0) as OldPopulation, b.Population FROM PortfolioProject..Data1 a INNER JOIN PortfolioProject..Data2 b ON a.District=b.District)c GROUP BY State) d) e) f

INNER JOIN 

(SELECT '1' as keyy,  SUM(area_km2) as total_area FROM PortfolioProject..Data2) g  ON f.keyy=g.keyy) h


-- Window Function 

-- Maximum Population of District in each state 

SELECT *, max(population) OVER(PARTITION BY state) as Max_Population FROM PortfolioProject..Data2 

-- Defining Row number for every row

SELECT * , ROW_NUMBER() OVER(ORDER BY STATE ASC) as RowNumber FROM PortfolioProject..Data1 

-- Defining row no. for every state 

SELECT *, ROW_NUMBER() OVER(Partition By STATE ORDER BY District ASC) as RowNumber FROM PortfolioProject..Data1

-- Top 2 district with highest literacy in every state 

SELECT e.District, e.State, e.Literacy, e.RowNumber FROM 
(SELECT *, ROW_NUMBER() OVER(PARTITION BY state ORDER BY Literacy DESC) as RowNumber FROM PortfolioProject..Data1) e WHERE e.RowNumber < 3

-- Top 2 District with lowest Growth Rate in each state 

SELECT e.* FROM 
(SELECT *, RANK() OVER(PARTITION BY state ORDER BY Growth ASC) as rnk FROM PortfolioProject..Data1) e WHERE rnk < 3

-- Check if previous state has low population or high population in ascending order 

SELECT a.*, LAG(a.TotalPopulation) OVER(ORDER BY State ASC) as Details, 
CASE WHEN a.TotalPopulation > LAG(a.TotalPopulation) OVER(ORDER BY State ASC) THEN 'Higher than Previous State'
	WHEN a.TotalPopulation < LAG(a.TotalPopulation) OVER(ORDER BY State ASC) THEN 'Lower than Previous State'
	WHEN a.TotalPopulation = LAG(a.TotalPopulation) OVER(ORDER BY State ASC) THEN 'Equal to Previous State'
end as PreviousDetails 
FROM 
(SELECT State, SUM(Population) as TotalPopulation FROM PortfolioProject..Data2 GROUP BY STATE) a

