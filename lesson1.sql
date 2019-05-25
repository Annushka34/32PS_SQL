CREATE DATABASE AnnShop

use AnnShop

----------------DDL---------------------------

---- CASE 1 --------------
CREATE TABLE Products(
Id INT NOT NULL IDENTITY,
[Name] nvarchar(max) NOT NULL,
Category nvarchar(max),
Price float CHECK (Price > 1),
CONSTRAINT Pk_Products PRIMARY KEY(Id)
)


---- CASE 2-------
CREATE TABLE Products(
Id INT NOT NULL IDENTITY PRIMARY KEY,
[Name] nvarchar(max) NOT NULL,
Category nvarchar(max),
Price float CHECK (Price > 1)
)


drop table Products


ALTER TABLE Products ALTER COLUMN Category varchar(20) NOT NULL
ALTER TABLE Products ADD Discount INT NULL CHECK (Discount < 15)
ALTER TABLE Products ADD CONSTRAINT PK_Products PRIMARY KEY (Id)


ALTER TABLE Products DROP CONSTRAINT PK_Products
ALTER TABLE Products DROP COLUMN Category


----CREATE TABLE WITH GUID ID------------
CREATE TABLE cust  
(  
 CustomerID uniqueidentifier NOT NULL  
   DEFAULT newid(),  
 Company varchar(30) NOT NULL,  
 ContactName varchar(60) NOT NULL
); 


------CREATE CATEGORY----------

CREATE TABLE Category (
Id INT NOT NULL PRIMARY KEY IDENTITY,
CategoryName nvarchar(max) NOT NULL
)



---- CASE 3-------
CREATE TABLE Products(
Id INT NOT NULL IDENTITY PRIMARY KEY,
[Name] nvarchar(max) NOT NULL,
Category nvarchar(max),
Price float CHECK (Price > 1),
CategoryID INT NOT NULL CONSTRAINT Fk_Prod_Categ FOREIGN KEY REFERENCES Category(Id)
)


drop table Category


CREATE TABLE Shops (
Id INT NOT NULL IDENTITY PRIMARY KEY,
ShopName nvarchar(max) NOT NULL,
Address nvarchar(max)
)


ALTER TABLE Products ADD ShopId INT NOT NULL
ALTER TABLE Products ADD CONSTRAINT Fk_Prod_Shop FOREIGN KEY (ShopId)  REFERENCES Shops(Id)


--------DML------------------


INSERT INTO Products VALUES 
(
'Milk',25.3,3,1
);



INSERT INTO Products VALUES 
('Milk',25.3,3,1),
('Toys',200,3,1),
('TV',25.3,3,1),
('Paint',25.3,3,1),
('T-shirt',25.3,3,1),
('Cheese',25.3,3,1),
('Meat',25.3,3,1),
('Dress',25.3,3,1);
SELECT * FROM Products
UPDATE Products SET Price=30
DELETE FROM Products

INSERT INTO Products (CategoryId, ShopId, Name)
VALUES (1, 1, 'Yougurt')


----------------WHERE----------------

SELECT * FROM Products WHERE Price > 26
SELECT * FROM Products WHERE Price <> 25.3
SELECT * FROM Products WHERE Price IS NOT NULL

UPDATE Products SET Price = 110 WHERE Price IS NOT NULL
UPDATE Products SET Price = 110 WHERE Price IS NULL
UPDATE Products SET Price = NULL WHERE Price <> 110

DELETE FROM Products WHERE Name='Milk'

----------------SELECT-----------------
SELECT Name as ProductName FROM Products
SELECT Name+' - '+convert(nvarchar(20), Price) as [ProductName], CategoryID FROM Products


INSERT INTO Shops VALUES ('CoolShop', NULL),('VeryCoolShop', 'Київ'),('Магазин мого сусіда', 'Київ');
SELECT Id FROM Shops WHERE ShopName='CoolShop'
SELECT Id FROM Category WHERE CategoryName='Electronica'

go
INSERT INTO Products (CategoryId, ShopId, Name)
VALUES ((SELECT Id FROM Category WHERE CategoryName='Electronica'), (SELECT Id FROM Shops WHERE ShopName='CoolShop'), 'Yougurt')


go
SELECT * FROM Products

SELECT Products.Id, Products.Name, Price, Category.CategoryName, ShopName FROM Products, Category, Shops 
WHERE Products.CategoryID = Category.Id AND Products.ShopId = Shops.Id

--------WITH ALIAS---------------
SELECT p.Id, p.Name, Price, c.CategoryName, ShopName FROM Products as p, Category as c, Shops as s
WHERE p.CategoryID = c.Id AND p.ShopId = s.Id















