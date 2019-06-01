create database BookShopPublisher
Go
use BookShopPublisher
Go

CREATE TABLE Country(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CountryName varchar(20),
);


CREATE TABLE Publish
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
PublishName varchar(30) NOT NULL,
CountryId INT CONSTRAINT FK_Publish_Country Foreign KEY  References Country(Id)
);

CREATE TABLE Address
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
Street varchar(20) NOT NULL default 'no street',
City varchar(20) NOT NULL,
CountryId INT CONSTRAINT FK_Address_Country Foreign KEY  References Country(Id)
);


CREATE TABLE Author
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
AuthorName varchar(30) NOT NULL,
AddressId INT CONSTRAINT Fk_Author_Address FOREIGN KEY REFERENCES Address(Id),
PublishId INT CONSTRAINT Fk_Author_Publish FOREIGN KEY REFERENCES Publish(Id)
);

CREATE TABLE Category
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CategotyName varchar(50) NOT NULL
);

CREATE TABLE Book
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
BookName varchar(250) NOT NULL,
Description varchar(MAX) NULL,
NumberPages INT,
Price Money NOT NULL,
PublishDate Date DEFAULT GETDATE(),
AuthorId INT CONSTRAINT Fk_Book_Author FOREIGN KEY REFERENCES Author(Id),
CategoryId INT CONSTRAINT Fk_Book_Category FOREIGN KEY REFERENCES Category(Id)
);

CREATE TABLE UserProfile
(
Id INT PRIMARY KEY IDENTITY,
Email varchar(30) UNIQUE NOT NULL CHECK (Email LIKE '%@%'),
Password varchar(20) NOT NULL CHECK (LEN(Password)>6),
CONSTRAINT FK_UserProfile_Author FOREIGN KEY(Id) REFERENCES Author(Id)
);

CREATE TABLE Shop
(
Id INT PRIMARY KEY IDENTITY,
ShopName varchar(30) NOT NULL,
CountryId INT CONSTRAINT Fk_Shop_Country FOREIGN KEY REFERENCES Country(Id)
);

CREATE TABLE Incomes
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateIncomes Date NOT NULL,
Amount INT NOT NULL,
CONSTRAINT Fk_Incomes_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Incomes_Book Foreign Key (BookId) REFERENCES Book(Id),
);

CREATE TABLE Sales
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateSale Date NOT NULL,
Amount INT NOT NULL,
SalePrice money NOT NULL,
CONSTRAINT Fk_Sales_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Sales_Book Foreign Key (BookId) REFERENCES Book(Id),
);
-----------INSERT VALUES--------------------------
Go
INSERT INTO Country Values
('China'),
('Poland'),
('Ukraine')
;
Go
INSERT INTO Address VALUES
('BigStreet','Vroclav',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Bednarska','Varshava',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Gdanska','Branevo',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Миру','Рівне',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Соборна','Рівне',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Хрещатик','Київ',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Cisy','Ninbo',(SELECT Id FROM Country WHERE CountryName='China'))

INSERT INTO Publish VALUES
('CoolPublisher',(SELECT Id FROM Country WHERE CountryName='Poland')),
('ZirkaBook',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Ababagalamaga',(SELECT Id FROM Country WHERE CountryName='Ukraine'))

INSERT INTO Author VALUES
('Ivanov',(SELECT Id FROM Address WHERE Street='Миру'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Petrov',(SELECT Id FROM Address WHERE Street='Миру'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Верн Жюль',(SELECT Id FROM Address WHERE Street='Миру'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Воронцов Николай',(SELECT Id FROM Address WHERE Street='Миру'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Андерсен Ханс Кристиан',(SELECT Id FROM Address WHERE Street='Миру'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Романова М.',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Скоттон Р',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Фани Марсо',(SELECT Id FROM Address WHERE Street='Gdanska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher'))

INSERT INTO UserProfile VALUES
('ivanov@mail.ru','qwertyy')

INSERT INTO Category VALUES
('Історичні'),
('Наукові'),
('Дитячі'),
('Дорослі'),
('Художні'),
('Фантастика'),
('Поезія')



INSERT INTO Book  VALUES 
('Roksolana',NULL,100,250.5,'12.10.2005',(select Id From Author where AuthorName = 'Ivanov'),(SELECT Id FROM Category WHERE CategotyName='Історичні')),
('Volodimyr',NULL,NULL,400.5,'10.05.2016',(select Id From Author where AuthorName = 'Ivanov'),(SELECT Id FROM Category WHERE CategotyName='Історичні')),
('Yaroslav',NULL,200,250.5,'2.06.2017',(select Id From Author where AuthorName = 'Petrov'),(SELECT Id FROM Category WHERE CategotyName='Історичні')),
('Ігри у які грають люди','Something',150,25.2,'12.12.2016',(select Id From Author where AuthorName = 'Petrov'),(SELECT Id FROM Category WHERE CategotyName='Наукові')),
('Психологічний помічник','Психологія101',110,25.5,'10.10.2015',(select Id From Author where AuthorName = 'Ivanov'),(SELECT Id FROM Category WHERE CategotyName='Наукові')),
('Снежная королева','Сказка',110,25.5,'10.10.2016',(select Id From Author where AuthorName = 'Petrov'),(SELECT Id FROM Category WHERE CategotyName='Наукові')),
('Белий мишка','Сказка',110,25.5,'10.10.2017',(select Id From Author where AuthorName = 'Верн Жюль'),(SELECT Id FROM Category WHERE CategotyName='Історичні')),
('Милашки-очаровашки',N'Миниатюрная книжка «Белый мишка» серии «Милашки-очаровашки» создана специально для самых маленьких читателей. ',110,25.5,'10.10.2015',(select Id From Author where AuthorName = 'Ivanov'),(SELECT Id FROM Category WHERE CategotyName='Дитячі')),
('Шмяк и пингвины','Котенок Шмяк и его друзья живут весело. ',110,25.5,'10.10.2014',(select Id From Author where AuthorName = 'Верн Жюль'),(SELECT Id FROM Category WHERE CategotyName='Історичні')),
('Рассел ищет клад','Что вас ждет под обложкой: Однажды ворона принесла Расселу изрядно потрепанную карту сокровищ Лягушачьей низины. ',110,25.5,'10.10.2015',(select Id From Author where AuthorName = 'Ivanov'),(SELECT Id FROM Category WHERE CategotyName='Дитячі')),
('Котенок Шмяк. Давай играть!','Наконец-то к котёнку Шмяку в гости пришли друзья, и можно вместе поиграть.',120,30.5,'10.10.2017',(select Id From Author where AuthorName = 'Романова М.'),(SELECT Id FROM Category WHERE CategotyName='Поезія'))


INSERT INTO Shop VALUES
('PolandShop',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Slovo',(SELECT Id FROM Country WHERE CountryName='Ukraine'))


INSERT INTO Incomes VALUES
(1,11,'12.10.2017',20),
(2,10,GetDate(),20),
(1,9,GetDate(),10),
(2,8,GetDate(),5),
(2,7,GetDate(),7),
(2,1, DATEADD("D",-5,GetDate()), 15),
(2,1,'10.05.2019',30),
(2,3, DATEADD("D",-15,GetDate()),30),
(2,3, DATEADD("D",-25,GetDate()),30),
(2,2, DATEADD("D",-8,GetDate()),30)

INSERT INTO Sales VALUES
(1,11,'12.10.2017',5,60),
(2,11,GetDate(),5,70.5),
(1,9,GetDate(),3,80.3),
(2,10,GetDate(),2,100),
(2,8,GetDate(),7,70.8),
(2,2,GetDate(),10,250)



SELECT * FROM Book
SELECT * FROM Sales


