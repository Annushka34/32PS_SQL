CREATE DATABASE AnnShop

use AnnShop

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




