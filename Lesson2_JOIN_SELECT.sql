SELECT * FROM Book
SELECT * FROM Publish
SELECT * FROM Incomes
SELECT * FROM Sales
SELECT * FROM Author
SELECT * FROM Address

SELECT Book.BookName + ISNULL( Description, '-') + ISNULL( CONVERT(nvarchar(max), '-'), NumberPages) as Book FROM Book
SELECT ISNULL( Description, '-') FROM Book
---alias for table---
SELECT b.BookName FROM Book as b

-------------WHERE-----------
SELECT * FROM Book 
	WHERE BookName LIKE 'Ï%'

SELECT * FROM Book 
	WHERE BookName LIKE N'V%l%'
	
SELECT * FROM Book 
	WHERE BookName BETWEEN 'A%' AND 'S%'
	
SELECT * FROM Book 
	WHERE Price>10 AND Price < 200
	
SELECT * FROM Book 
	WHERE Price BETWEEN 10 AND 200

SELECT * FROM Book WHERE PublishDate > '10.10.2016'

SELECT * FROM Book WHERE PublishDate > DATEADD("D", -30, GETDATE())

SELECT * FROM Book Where Book.AuthorId = (SELECT TOP(1) Id FROM Author WHERE AuthorName = 'Ivanov')

----------------ORDER BY-------------------------
SELECT TOP(3) * FROM Book ORDER BY Price DESC
---------------FETCH---TAKE ONLY...ROW
SELECT * FROM Book ORDER BY Price
OFFSET 2 ROWS
FETCH NEXT 3 ROWS ONLY
-----------------------SUM()-----------------------
SELECT SUM(Price) FROM Book
----total cost of sales----
SELECT SUM(s.Amount*s.SalePrice) FROM Sales as s
-------------------COUNT()------------------------
SELECT COUNT(*) FROM Book
SELECT COUNT(*) FROM Author WHERE PublishId=(SELECT Id  FROM Publish WHERE PublishName='CoolPublisher')
----------------------AVG()--------------------------
SELECT AVG(Price) FROM Book

---------------------MAX---MIN-----------------------
SELECT MIN(Price) FROM Book
SELECT MAX(Price) as [Max], MIN(Price) as [Min] FROM Book

------------------ GROUP BY-----------------
SELECT AuthorId, CategoryId, AVG(Price), MAX(Price) FROM Book 
GROUP BY AuthorId,  CategoryId
ORDER BY 

SELECT Author.AuthorName, Category.CategotyName, AVG(Price) as [avg price], MAX(Price) as [max price]
FROM (Book JOIN Author on Book.AuthorId=Author.Id) JOIN Category on Book.CategoryId = Category.Id
GROUP BY Author.AuthorName,  Category.CategotyName
HAVING AVG(Price)='25.5'
ORDER BY Author.AuthorName
------------------HAVING-----------------------


SELECT Author.AuthorName, Category.CategotyName, AVG(Price) as [avg price], MAX(Price) as [max price]
FROM (Book JOIN Author on Book.AuthorId=Author.Id) JOIN Category on Book.CategoryId = Category.Id
GROUP BY Author.AuthorName,  Category.CategotyName
HAVING Max(Price)>100
ORDER BY Author.AuthorName


SELECT Author.AuthorName, Category.CategotyName, Author.AddressId , AVG(Price) as [avg price], MAX(Price) as [max price]
FROM (Book JOIN Author on Book.AuthorId=Author.Id) JOIN Category on Book.CategoryId = Category.Id
--WHERE Author.AddressId = 4
GROUP BY Author.AuthorName,  Category.CategotyName, Author.AddressId 
HAVING Max(Price)>10
ORDER BY Author.AuthorName

---------------------------EXISTS------------------------
SELECT * FROM Author WHERE EXISTS (SELECT *  FROM Publish WHERE PublishId=2)
SELECT Sum(Sales.Amount) FROM Book  JOIN Sales on Sales.BookId = Book.Id
WHERE EXISTS (SELECT *  FROM Sales Where Book.Id=Sales.BookId)
-------------------------NOT EXISTS----------------------
SELECT * FROM Author WHERE NOT EXISTS (SELECT *  FROM Publish WHERE PublishId=2)

----------------IN----------------------
SELECT * FROM Author WHERE PublishId IN (SELECT Id  FROM Publish WHERE PublishName LIKE 'A%')
SELECT * FROM Author WHERE Author.Id IN (SELECT Book.AuthorId FROM Book WHERE Price BETWEEN 20 AND 100)

-------------------ANY---------------------------
SELECT * FROM Book WHERE Price >= ANY (SELECT Price FROM Book WHERE Price BETWEEN 20 AND 100)
SELECT * FROM Book WHERE Price <= ANY (SELECT Price FROM Book WHERE Price BETWEEN 20 AND 100)
------------------ALL-------------------------------
SELECT * FROM Book WHERE Price >= ALL (SELECT Price FROM Book WHERE Price BETWEEN 20 AND 100)
SELECT * FROM Book WHERE Price < ALL (SELECT Price FROM Book WHERE Price BETWEEN 20 AND 100)

SELECT * FROM Book WHERE Price < (SELECT AVG(Price) FROM Book)

-------------------------JOIN--------------------------
SELECT * FROM Book
SELECT * FROM Book, Author WHERE Book.AuthorId = Author.Id
SELECT BookName, AuthorName FROM Book, Author WHERE Book.AuthorId = Author.Id


SELECT * FROM Book INNER JOIN Author on Book.AuthorId = Author.Id
SELECT BookName, AuthorName FROM Book  JOIN Author on Book.AuthorId = Author.Id

----------------------LEFT OUTER JOIN---------------------
SELECT BookName, AuthorName FROM Book  LEFT OUTER JOIN Author on Book.AuthorId = Author.Id

-------------------RIGHT OUTER JOIN---------------------
SELECT BookName, AuthorName FROM Book  RIGHT OUTER JOIN Author on Book.AuthorId = Author.Id

SELECT BookName, AuthorName FROM Book FULL OUTER JOIN Author on Book.AuthorId = Author.Id


-------------------Book--Author---Publish----
SELECT BookName, AuthorName, PublishName 
	FROM (Book JOIN Author on Book.AuthorId = Author.Id) JOIN Publish on Author.PublishId = Publish.Id

SELECT BookName, AuthorName, PublishName, CountryName 
	FROM ((Book JOIN Author on Book.AuthorId = Author.Id) 
	JOIN Publish on Author.PublishId = Publish.Id) 
	JOIN Country on Country.Id = Publish.CountryId

SELECT BookName, AuthorName, PublishName, CountryName 
	FROM ((Book JOIN Author on Book.AuthorId = Author.Id) 
	RIGHT OUTER JOIN Publish on Author.PublishId = Publish.Id) 
	RIGHT OUTER JOIN Country on Country.Id = Publish.CountryId


SELECT BookName, AuthorName, PublishName, CountryName 
	FROM ((Book LEFT OUTER JOIN Author on Book.AuthorId = Author.Id) 
	LEFT OUTER JOIN Publish on Author.PublishId = Publish.Id) 
	LEFT OUTER JOIN Country on Country.Id = Publish.CountryId















