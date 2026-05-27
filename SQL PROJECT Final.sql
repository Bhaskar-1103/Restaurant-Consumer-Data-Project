CREATE DATABASE PROJECTDB;
USE PROJECTDB;
-- 
CREATE TABLE RESTAURANT(Restaurant_ID int PRIMARY KEY,Name varchar(50) NOT NULL,City varchar(50) NOT NULL,State varchar(50) NOT NULL,
Country varchar(50) not null,Zip_Code varchar(10) ,Latitude decimal(9,6) ,Longitude decimal(9,6),
Alcohol_Service varchar(30) not null,Smoking_Allowed varchar(20) not null,
Price ENUM('Low','Medium','High'),Franchise ENUM('Yes','No'),Area varchar(20),Parking varchar(20));
SELECT *FROM RESTAURANT LIMIT 10;
DESC RESTAURANT ;
-- 
CREATE TABLE RESTAURANT_CUISINES(Restaurant_ID INT,Cuisine VARCHAR(20),FOREIGN KEY(Restaurant_ID) REFERENCES RESTAURANT(Restaurant_ID));
SELECT *FROM RESTAURANT_CUISINES LIMIT 10;
DESC RESTAURANT_CUISINES;
--
CREATE TABLE CONSUMERS(Consumer_ID VARCHAR(20) PRIMARY KEY,City VARCHAR(30),State VARCHAR(30),Country VARCHAR(30),Latitude DECIMAL(10,6),Longitude DECIMAL(10,6),Smoker VARCHAR(30),
Drink_Level VARCHAR(20),Transportation_Method VARCHAR(30),Marital_Status VARCHAR(30),Children VARCHAR(30),Age INT NULL,Occupation
 VARCHAR(30),Budget VARCHAR(20));
 SELECT *FROM CONSUMERS LIMIT 10;
 DESC CONSUMERS;
 
 --
 CREATE TABLE CONSUMER_PREFERENCES(Consumer_ID VARCHAR(30),Preferred_Cuisine VARCHAR(30) NOT NULL,FOREIGN KEY(Consumer_ID) REFERENCES CONSUMERS(Consumer_ID));
 SELECT *FROM CONSUMER_PREFERENCES LIMIT 10;
 DESC CONSUMER_PREFERENCES;
 --
 
 CREATE TABLE RATINGS(Consumer_ID VARCHAR(30),Restaurant_ID INT,Overall_Rating INT,Food_Rating INT,Service_Rating INT,FOREIGN KEY(Consumer_ID) REFERENCES CONSUMERS(Consumer_ID),
 FOREIGN KEY(Restaurant_ID) REFERENCES RESTAURANT(Restaurant_ID));
 SELECT *FROM RATINGS LIMIT 10;
 DESC RATINGS;
 
 -- Using the WHERE clause to filter data based on specific criteria.
 -- 1.	List all details of consumers who live in the city of 'Cuernavaca'.
 SELECT *FROM CONSUMERS WHERE City='Cuernavaca';
 
 -- 2.Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
 SELECT Consumer_ID, Age,Occupation FROM CONSUMERS WHERE Occupation='Student' AND Smoker='Yes';
 
 -- 3.	List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
 SELECT Name, City, Alcohol_Service,Price FROM RESTAURANT WHERE Alcohol_Service='Wine & Beer' AND Price='Medium';
 
 -- 4.  Find the names and cities of all restaurants that are part of a 'Franchise'.
SELECT Name, City FROM RESTAURANT WHERE Franchise="Yes";

-- 5.	Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory'
--  (which corresponds to a value of 2, according to the data dictionary).
SELECT Consumer_ID, Restaurant_ID,Overall_Rating FROM RATINGS WHERE Overall_Rating=2;

-- Questions JOINs with Subqueries
-- 1.	List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT RESTAURANT.Name,RESTAURANT.City,COUNT(RATINGS.Consumer_ID) from  RESTAURANT join RATINGS ON RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID WHERE RATINGS.Overall_Rating=2 GROUP BY RESTAURANT.Name,RESTAURANT.City
HAVING COUNT(RATINGS.Consumer_ID)>=1;

-- 2.	Find the Consumer_ID and Age of consumers 
-- who have rated restaurants located in 'San Luis Potosi'
select DISTINCT CONSUMERS.Consumer_ID,CONSUMERS.age from CONSUMERS JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID
JOIN RESTAURANT ON RATINGS.Restaurant_ID=RESTAURANT.Restaurant_ID WHERE RESTAURANT.City='San Luis Potosi' ;

-- 3.	List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT RESTAURANT.Name from RESTAURANT 
JOIN RESTAURANT_CUISINES 
ON RESTAURANT.Restaurant_ID=RESTAURANT_CUISINES.Restaurant_ID
JOIN RATINGS ON 
RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID
 WHERE RESTAURANT_CUISINES.Cuisine='Mexican' 
 AND RATINGS.Consumer_ID='U1001';

-- 4.	Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT CONSUMERS.* FROM CONSUMERS
 JOIN CONSUMER_PREFERENCES 
 ON CONSUMERS.Consumer_ID=CONSUMER_PREFERENCES.Consumer_ID
WHERE CONSUMER_PREFERENCES.Preferred_Cuisine='American' 
AND CONSUMERS.Budget='Medium';
SELECT *FROM RESTAURANT_CUISINES WHERE Cuisine='Italian';
-- 5.	List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.
SELECT RESTAURANT.Name,
RESTAURANT.City FROM RESTAURANT 
JOIN RATINGS ON 
RESTAURANT.Restaurant_ID =RATINGS.Restaurant_ID
WHERE RATINGS.Food_Rating<(SELECT AVG(RATINGS.Food_Rating) FROM RATINGS);

-- 6.	Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT CONSUMERS.Consumer_ID,CONSUMERS.Age,CONSUMERS.Occupation FROM CONSUMERS JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID
JOIN RESTAURANT ON RATINGS.Restaurant_ID=RESTAURANT.Restaurant_ID JOIN RESTAURANT_CUISINES ON RESTAURANT.Restaurant_ID=RESTAURANT_CUISINES.Restaurant_ID
GROUP BY CONSUMERS.Consumer_ID,CONSUMERS.Age,CONSUMERS.Occupation HAVING COUNT(RATINGS.Restaurant_ID) >= 1
AND GROUP_CONCAT(RESTAURANT_CUISINES.Cuisine) NOT LIKE '%Italian%';

-- 7.	List restaurants (Name) that have received ratings from consumers older than 30.
SELECT DISTINCT RESTAURANT.Name 
from RESTAURANT JOIN RATINGS 
ON RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID 
JOIN CONSUMERS ON 
RATINGS.Consumer_ID=CONSUMERS.Consumer_ID WHERE CONSUMERS.Age>30;

-- 8.	Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' 
-- and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
SELECT CONSUMERS.Consumer_ID,CONSUMERS.Occupation from CONSUMERS JOIN CONSUMER_PREFERENCES ON CONSUMERS.Consumer_ID=CONSUMER_PREFERENCES.Consumer_ID
JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID WHERE CONSUMER_PREFERENCES.Preferred_Cuisine='Mexican' AND Overall_Rating=0 GROUP BY
CONSUMERS.Consumer_ID,CONSUMERS.Occupation;

-- 9.	List the names and cities of restaurants that serve 'Pizzeria' cuisine 
-- and are located in a city where at least one 'Student' consumer lives.
SELECT RESTAURANT.Name,RESTAURANT.City FROM RESTAURANT JOIN  RESTAURANT_CUISINES ON RESTAURANT.Restaurant_ID=RESTAURANT_CUISINES.Restaurant_ID
JOIN CONSUMERS ON RESTAURANT.City=CONSUMERS.City WHERE RESTAURANT_CUISINES.Cuisine='Pizzeria' AND CONSUMERS.Occupation='Student';

-- 10.	Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
SELECT  CONSUMERS.Consumer_ID,CONSUMERS.Age FROM CONSUMERS
 JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID JOIN RESTAURANT 
ON RATINGS.Restaurant_ID=RESTAURANT.Restaurant_ID WHERE 
CONSUMERS.Drink_Level='Social Drinkers' AND RESTAURANT.Parking='No';

-- Questions Emphasizing WHERE Clause and Order of Execution
-- 1.	List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. 
-- Show only students who have rated more than 2 restaurants.
SELECT CONSUMERS.Consumer_ID,COUNT(RATINGS.Restaurant_ID) FROM CONSUMERS JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID
WHERE CONSUMERS.Occupation='Student' GROUP BY CONSUMERS.Consumer_ID HAVING COUNT(RATINGS.Restaurant_ID)>2;

-- 2.	We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). 
-- List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 
-- and who use 'Public' transportation.
SELECT CONSUMERS.Consumer_ID,CONSUMERS.Age,(CONSUMERS.Age/10) AS Engagement_Score FROM CONSUMERS
WHERE (CONSUMERS.Age/10)=2 AND Transportation_Method='Public';

-- 3.	For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, 
-- and its calculated average Overall_Rating, 
-- but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.
SELECT RESTAURANT.Name,RESTAURANT.City,AVG(RATINGS.Overall_Rating) FROM RESTAURANT JOIN RATINGS ON RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID
WHERE RESTAURANT.City='Cuernavaca' GROUP BY RESTAURANT.Name,RESTAURANT.City HAVING AVG(RATINGS.Overall_Rating)>1.0;

-- 4.	Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any 
-- restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.
SELECT DISTINCT CONSUMERS.Consumer_ID,CONSUMERS.Age FROM CONSUMERS JOIN RATINGS ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID WHERE 
CONSUMERS.Marital_Status='Married' AND RATINGS.Food_Rating=RATINGS.Service_Rating AND RATINGS.Overall_Rating=2;

-- 5.	List Consumer_ID, Age, and the Name of any restaurant they rated, 
-- but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
SELECT DISTINCT c.Consumer_ID, c.Age, r.Name
FROM CONSUMERS c
JOIN RATINGS rt
    ON c.Consumer_ID = rt.Consumer_ID
JOIN RESTAURANT r
    ON rt.Restaurant_ID = r.Restaurant_ID
WHERE c.Occupation = 'Employed'
  AND c.Consumer_ID IN (
        SELECT rt2.Consumer_ID
        FROM RATINGS rt2
        JOIN RESTAURANT r2
            ON rt2.Restaurant_ID = r2.Restaurant_ID
        WHERE rt2.Food_Rating = 0
          AND r2.City = 'Ciudad Victoria'
     );
     
-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures

-- 1.Using a CTE, find all consumers who live in 'San Luis Potosi'.
-- Then, list their Consumer_ID, Age, and 
-- the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.

WITH CTE_CONSUMERS AS (
SELECT CONSUMERS.Consumer_ID,CONSUMERS.Age,
RESTAURANT.Name
FROM CONSUMERS JOIN RATINGS 
ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID
JOIN RESTAURANT ON
RATINGS.Restaurant_ID=RESTAURANT.Restaurant_ID
JOIN RESTAURANT_CUISINES ON
RATINGS.Restaurant_ID=RESTAURANT_CUISINES.Restaurant_ID
WHERE CONSUMERS.City='San Luis Potosi'
AND RESTAURANT_CUISINES.Cuisine='Mexican' AND
Overall_Rating=2)
SELECT *FROM CTE_CONSUMERS;

-- 2.For each Occupation, find the average age of consumers. 
-- Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated).

SELECT DERIVED_TABLE.Occupation,AVG(DERIVED_TABLE.Age) FROM
(SELECT DISTINCT CONSUMERS.Consumer_ID, 
CONSUMERS.Occupation, CONSUMERS.Age
FROM CONSUMERS
JOIN RATINGS
ON CONSUMERS.Consumer_ID=RATINGS.Consumer_ID)
AS DERIVED_TABLE
GROUP BY DERIVED_TABLE.Occupation;

-- 3.	Using a CTE to get all ratings for restaurants in 'Cuernavaca', 
-- rank these ratings within each restaurant based on Overall_Rating (highest first). 
-- Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.
WITH CTE_RATINGS AS(
SELECT 
RATINGS.Restaurant_ID,
CONSUMERS.Consumer_ID,
RATINGS.Overall_Rating,
RANK() OVER(PARTITION BY RATINGS.Restaurant_ID ORDER BY
RATINGS.Overall_Rating DESC) AS RatingRank
FROM RATINGS
JOIN CONSUMERS
ON RATINGS.Consumer_ID=CONSUMERS.Consumer_ID
JOIN RESTAURANT
ON RATINGS.Restaurant_ID=RESTAURANT.Restaurant_ID
WHERE RESTAURANT.City='Cuernavaca')
SELECT *FROM CTE_RATINGS;


-- 4.	For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating,
--  and also display the average Overall_Rating given by that specific consumer across all their ratings.
SELECT CONSUMERS.Consumer_ID,
 RATINGS.Restaurant_ID,
 RATINGS.Overall_Rating,
 AVG(RATINGS.Overall_Rating) OVER(PARTITION BY CONSUMERS.Consumer_ID) AS OVERALL_RATINGBYCONSUMER 
 FROM RATINGS
 JOIN CONSUMERS ON 
 CONSUMERS.Consumer_ID=RATINGS.Consumer_ID;
 
 -- 5.	Using a CTE, identify students who have a 'Low' budget. 
 -- Then, for each of these students, list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table
 -- (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).
 WITH LowBudgetStudents AS (
SELECT Consumer_ID
FROM consumers WHERE Occupation = 'Student'
AND Budget = 'Low'
),RankedCuisines AS (
SELECT 
cp.Consumer_ID,cp.Preferred_Cuisine,
ROW_NUMBER() OVER (PARTITION BY cp.Consumer_ID 
ORDER BY cp.Preferred_Cuisine) AS rn
FROM consumer_preferences cp
JOIN LowBudgetStudents s 
ON cp.Consumer_ID = s.Consumer_ID
)
SELECT Consumer_ID, Preferred_Cuisine
FROM RankedCuisines WHERE rn <= 3
ORDER BY Consumer_ID, rn;
 
 -- 6.	Consider all ratings made by 'Consumer_ID' = 'U1008'. 
 -- For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if any),
 -- ordered by Restaurant_ID (as a proxy for time if rating time isn't available). 
 -- Use a derived table to filter for the consumer's ratings first.

SELECT DERIVED_TABLE.Restaurant_ID,
DERIVED_TABLE.Overall_Rating ,
DERIVED_TABLE.NEXT_RATED_RESTAURANT
FROM(SELECT RATINGS.Restaurant_ID,RATINGS.Overall_Rating,
 LEAD(Overall_Rating) OVER(ORDER BY RATINGS.Restaurant_ID)
AS NEXT_RATED_RESTAURANT FROM RATINGS JOIN 
CONSUMERS ON RATINGS.Consumer_ID=CONSUMERS.Consumer_ID
WHERE CONSUMERS.Consumer_ID='U1008')AS DERIVED_TABLE;

-- 7.	Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, 
-- and City of all Mexican restaurants 
-- that have an average Overall_Rating greater than 1.5.
CREATE VIEW HighlyRatedMexicanRestaurants 
AS SELECT 
RESTAURANT.Restaurant_ID,
RESTAURANT.Name,RESTAURANT.City
FROM RESTAURANT JOIN RATINGS ON 
RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID
JOIN  RESTAURANT_CUISINES ON 
RESTAURANT.Restaurant_ID=RESTAURANT_CUISINES.Restaurant_ID
WHERE RESTAURANT_CUISINES.Cuisine='Mexican'
GROUP BY RESTAURANT.Restaurant_ID,RESTAURANT.Name,
RESTAURANT.City
HAVING AVG(RATINGS.Overall_Rating)>1.5;
SELECT *FROM HighlyRatedMexicanRestaurants;

-- 8.	First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. 
-- Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) 
-- who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.
WITH CTE_CONSUMERS1 AS
(SELECT DISTINCT CONSUMER_PREFERENCES.Consumer_ID 
FROM CONSUMER_PREFERENCES WHERE
CONSUMER_PREFERENCES.Preferred_Cuisine='Mexican')
SELECT CTE_CONSUMERS1.Consumer_ID FROM CTE_CONSUMERS1 
WHERE CTE_CONSUMERS1.Consumer_ID NOT IN (
SELECT DISTINCT RATINGS.Consumer_ID
    FROM RATINGS
    JOIN HighlyRatedMexicanRestaurants HR
      ON RATINGS.Restaurant_ID = HR.Restaurant_ID
);

-- 9.Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and
-- a minimum Overall_Rating as input. It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating 
-- for that restaurant where the Overall_Rating meets or exceeds the threshold.
DELIMITER $$
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (
IN p_Restaurant_ID INT,
IN p_MinOverallRating INT
)BEGIN
SELECT RATINGS.Consumer_ID, 
RATINGS.Overall_Rating, RATINGS.Food_Rating, 
RATINGS.Service_Rating FROM RATINGS
WHERE RATINGS.Restaurant_ID = p_Restaurant_ID
AND RATINGS.Overall_Rating >= p_MinOverallRating;
END $$
DELIMITER ;
CALL GetRestaurantRatingsAboveThreshold(135085,1);

-- 10.	Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. 
-- If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.
WITH RankedRestaurants AS(
	SELECT RESTAURANT_CUISINES.Cuisine,
	RESTAURANT.Name AS Restaurant_Name,RESTAURANT.City,
	AVG(RATINGS.Overall_Rating) AS Overall_Rating,
	ROW_NUMBER() OVER(PARTITION BY RESTAURANT_CUISINES.Cuisine
	ORDER BY AVG(RATINGS.Overall_Rating) DESC) AS ROW_NUM
	FROM RESTAURANT_CUISINES  
	JOIN RESTAURANT ON
	RESTAURANT_CUISINES.Restaurant_ID=RESTAURANT.Restaurant_ID
	JOIN RATINGS ON 
	RESTAURANT.Restaurant_ID=RATINGS.Restaurant_ID
    GROUP BY
    RESTAURANT_CUISINES.Cuisine,
	RESTAURANT.Name,RESTAURANT.City
 )
 SELECT Cuisine,Restaurant_Name,City,Overall_Rating
FROM RankedRestaurants WHERE ROW_NUM <= 2;

-- 11.	First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and
-- their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their average overall rating. 
-- For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.
CREATE VIEW ConsumerAverageRatings AS 
SELECT Consumer_ID,AVG(Overall_Rating) AS AVG_RATING FROM
RATINGS GROUP BY Consumer_ID;
WITH TOPCONSUMERS AS(SELECT Consumer_ID,AVG_RATING,
ROW_NUMBER() OVER(ORDER BY AVG_RATING DESC) AS RANKNUM
FROM ConsumerAverageRatings)
SELECT TC.Consumer_ID,TC.AVG_RATING,COUNT(DISTINCT R.Restaurant_ID)
 AS MEXICANRATEDRESTAURANT FROM TOPCONSUMERS TC
 JOIN RATINGS RAT ON TC.Consumer_ID=RAT.Consumer_ID
 JOIN RESTAURANT R ON RAT.Restaurant_ID = R.Restaurant_ID
 JOIN RESTAURANT_CUISINES RC 
 ON R.Restaurant_ID = RC.Restaurant_ID
 WHERE TC.RANKNUM<=5 AND 
 RC.Cuisine = 'Mexican'
 GROUP BY TC.Consumer_ID, TC.AVG_RATING;

SELECT *FROM CONSUMERS;

-- 12.	Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.
-- The procedure should:
/*1.	Determine the consumer's "Spending Segment" based on their Budget:
○	'Low' -> 'Budget Conscious'
○	'Medium' -> 'Moderate Spender'
○	'High' -> 'Premium Spender'
○	NULL or other -> 'Unknown Budget'*/
DELIMITER $$
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(IN NEW_Consumer_ID VARCHAR(20))
 BEGIN
 DECLARE V_BUDGET VARCHAR(20);
 DECLARE V_SEGMENT VARCHAR(20);
 SELECT Budget INTO V_BUDGET FROM CONSUMERS
 WHERE Consumer_ID=NEW_Consumer_ID;
 SET V_SEGMENT= CASE
 WHEN V_BUDGET = 'Low' THEN 'Budget Conscious'
 WHEN V_BUDGET = 'Medium' THEN 'Moderate Spender'
 WHEN V_BUDGET = 'High' THEN 'Premium Spender'
 ELSE 'Unknown Budget'
 END;
 SELECT NEW_Consumer_ID AS Consumer_ID,V_BUDGET AS BUDGET,V_SEGMENT AS SPENDING_SEGMENT;
 END $$;
 DELIMITER ;
  CALL GetConsumerSegmentAndRestaurantPerformance('U1002');
 
 /*2.	For all restaurants rated by this consumer:
○	List the Restaurant_Name.
○	The Overall_Rating given by this consumer.
○	The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
○	A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average',
 or 'Below Average' compared to the restaurant's overall average rating.
○	Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).*/
DELIMITER $$
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance1(IN NEW_Consumer_ID VARCHAR(20))
BEGIN
DECLARE V_BUDGET VARCHAR(20);
DECLARE V_SEGMENT VARCHAR(50);
SELECT Budget INTO V_BUDGET FROM CONSUMERS WHERE Consumer_ID = NEW_Consumer_ID;
SET V_SEGMENT = CASE
WHEN V_BUDGET = 'Low' THEN 'Budget Conscious'
WHEN V_BUDGET = 'Medium' THEN 'Moderate Spender'
WHEN V_BUDGET = 'High' THEN 'Premium Spender'
ELSE 'Unknown Budget'
END;
SELECT NEW_Consumer_ID AS Consumer_ID,V_BUDGET AS Budget,
V_SEGMENT AS Spending_Segment;
WITH ConsumerRatings AS (SELECT R.Restaurant_ID,Res.Name AS Restaurant_Name,
R.Overall_Rating AS Consumer_Rating,
(SELECT AVG(R2.Overall_Rating) FROM RATINGS R2 
WHERE R2.Restaurant_ID = R.Restaurant_ID) AS Avg_Restaurant_Rating
FROM RATINGS R JOIN RESTAURANT Res ON R.Restaurant_ID = Res.Restaurant_ID
WHERE R.Consumer_ID = NEW_Consumer_ID
)
SELECT Restaurant_Name,Consumer_Rating,Avg_Restaurant_Rating,
CASE 
WHEN Consumer_Rating > Avg_Restaurant_Rating THEN 'Above Average'
WHEN Consumer_Rating = Avg_Restaurant_Rating THEN 'At Average'
ELSE 'Below Average'
END AS Performance_Flag,ROW_NUMBER() OVER (ORDER BY Consumer_Rating DESC)
AS Consumer_Rating_Rank FROM ConsumerRatings;
END$$
DELIMITER ;
CALL GetConsumerSegmentAndRestaurantPerformance1('U1002');


 
 









