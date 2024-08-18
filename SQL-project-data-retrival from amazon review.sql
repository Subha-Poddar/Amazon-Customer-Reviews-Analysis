--CREATE Scripts 
--R_table
CREATE TABLE R_table(
	Rating_ID int NOT NULL Primary Key,
	Rating int NOT NULL);
--category_data
CREATE TABLE category_data(
            category_ID  int  NOT NULL Primary Key,
            category  varchar(50));
--Own_Rating_Table
 create table Own_Rating
 (Own_Rating_ID int primary key, 
 Own_Rating nvarchar(10));
--Amazon_Review
 CREATE TABLE Amazon_Review(
    Unique_ID INT PRIMARY KEY,
    Category_ID INT NOT NULL,
    Review_Header VARCHAR(MAX),
    Review_text VARCHAR(MAX),
    Rating_ID INT NOT NULL,
    Own_Rating_ID INT NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES category_data(Category_ID),
    FOREIGN KEY (Rating_ID) REFERENCES R_table(Rating_ID),
    FOREIGN KEY (Own_Rating_ID) REFERENCES Own_Rating(Own_Rating_ID)
);

--INSERT Scripts
--R_table
INSERT INTO R_table (Rating_ID, Rating)
SELECT Rating_ID, Rating
FROM Rating_table;
--category_data
INSERT INTO category_data ( category_ID, category)
SELECT category_ID, category
FROM Category;
--Own_Rating
 Insert into Own_Rating (Own_Rating_ID, Own_Rating)
 select Own_Rating_ID, Own_Rating from 
 Own_Rating_Table;
--Amazon_Review
INSERT INTO Amazon_Review (Unique_ID, category_ID, Review_Header, Review_text, Rating_ID, Own_Rating_ID) 
SELECT Unique_ID, category_ID, Review_Header, Review_text, Rating_ID, Own_Rating_ID 
FROM Amazon_Review_Data;

select * from R_table
select * from category_data
select * from Own_Rating
select * from Amazon_Review

--1. Problem statement
--Finding the average rating for each product 
--Query
--the average rating for each product 
SELECT ar.Unique_ID, AVG(r.Rating) AS Avg_Rating
FROM amazon_review ar
JOIN r_table r ON ar.Rating_ID = r.Rating_ID
GROUP BY ar.Unique_ID 
ORDER BY Avg_Rating DESC;

--2. Problem statement
--Recognizing the number of reviews with positive sentiment for each category
--Query
SELECT c.category, COUNT(*) AS Positive_Review_Count
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN Own_Rating_Table ort ON ar.Own_Rating_ID = ort.Own_Rating_ID
WHERE ort.Own_Rating = 'Positive'
GROUP BY c.category
ORDER BY Positive_Review_Count;

--3. Problem statement
--Rank Reviews Within Each Category by Rating
--Query

SELECT ar.Category_ID, ar.Review_Header, ar.Review_text, r.Rating,
ROW_NUMBER() OVER(PARTITION BY ar.Category_ID ORDER BY r.Rating DESC) AS Review_Rank
FROM amazon_review ar
JOIN r_table r ON ar.Rating_ID = r.Rating_ID;

--4. Problem statement
--Identifying all reviews containing the word "battery" in the review text
--Query
SELECT ar.Review_Header, ar.Review_text, c.category
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
WHERE ar.Review_text LIKE '%battery%';

--5. Problem statement
--Identifying Top-Rated Amazon Products with Average Rating of Higher than 3
--Query
SELECT ar.category_ID, c.category, AVG(r.Rating) AS Avg_Rating
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN r_table r ON ar.Rating_ID = r.Rating_ID
GROUP BY ar.category_ID, c.category
HAVING AVG(r.Rating) > 3
ORDER BY Avg_Rating DESC;

--6. Problem statement
--Find the Most Reviewed Category
--Query
SELECT c.category, COUNT(*) AS Review_Count
FROM amazon_review ar
JOIN category_data c ON ar.Category_ID = c.Category_ID
GROUP BY c.Category
ORDER BY Review_Count;

--7. Problem statement
--Find the Products with Ratings Greater Than 4
--Query
SELECT c.category, ar.Review_Header, r.Rating
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN R_table r ON ar.Rating_ID = r.Rating_ID
WHERE r.Rating > 4
order by c.category;

--8. Problem statement
--Identify Most Common Complaints Across Categories
--Query
SELECT ar.Category_ID, ar.Review_text, COUNT(*) AS Complaint_Count
FROM amazon_review ar
WHERE ar.Own_Rating_ID IN (SELECT Own_Rating_ID FROM Own_Rating_table WHERE Own_Rating = 'Negative')
GROUP BY ar.Category_ID, ar.Review_text
ORDER BY Complaint_Count DESC;







