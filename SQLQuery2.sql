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

CREATE TABLE top