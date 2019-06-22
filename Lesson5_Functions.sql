go
create function GetPrice () returns money
as 
begin
declare @price money
select @price = Price from Book where Id = 3
return @price
end
go
drop function GetPrice

select * from Book
print (dbo.GetPrice())

go
create table Test_1 (
Id INT PRIMARY KEY IDENTITY,
Name nvarchar(max),
Price as dbo.GetPrice()
)

drop table Test_1

go
insert into Test_1 values('First')
select * from Test_1



--------------------------------------------------------
go
create function GetPriceById (@Id int) returns money
as 
begin
declare @price money
select @price = Price from Book where Id = @Id
return @price
end
go
---drop function GetPriceById

---select * from Book
print (dbo.GetPriceById(10))

go
create table Test_2 (
Id INT PRIMARY KEY IDENTITY,
BookId INT,
Name nvarchar(max),
Price as dbo.GetPriceById(BookId)
)

go
insert into Test_2 values(3,'First')
insert into Test_2 values(10,'Second')
go
select * from Test_2


create function CalcProfit (@Id INT) returns money
as
begin
declare @incomes money;
declare @price money;
declare @amount money;
select @price = Price FROM Book WHERE Id = @Id;
select @incomes = SalePrice * Amount FROM Sales WHERE BookId = @Id;
select @amount = Sum(Amount) FROM Sales WHERE BookId = @Id;
return (@incomes - @amount*@price);
end


create table ProfitFromSale(
Id INT PRIMARY KEY IDENTITY,
BookId INT,
Profit as dbo.CalcProfit(BookId)
)

insert into ProfitFromSale values (3)
insert into ProfitFromSale values (6)
insert into ProfitFromSale values (10)
insert into ProfitFromSale values (9)
insert into ProfitFromSale values (1)

select * from ProfitFromSale



------------------------------------------
-----FUNCTIONS RETURNS TABLES---
go
create function GetBooksByAuthor(@authorId INT) returns table
as
return (
select * FROM Book Where AuthorId = @authorId
)


select * FROM dbo.GetBooksByAuthor(1)

create function GetBookIdInCategory (@ctgName nvarchar(max)) returns table
as
return
(
select Book.Id From Book INNER JOIN Category ON Book.CategoryId = Category.Id AND CategotyName = @ctgName
)


select * FROM dbo.GetBookIdInCategory(N'Історичні')
select * From Sales WHERE BookId in (select * FROM dbo.GetBookIdInCategory(N'Історичні'))


CREATE FUNCTION GetBooks(@categId INT)
    RETURNS TABLE AS
    RETURN
        SELECT BookName, Price
        FROM Book
        WHERE Book.CategoryId = @categId
		---
-----USE--------

SELECT c.Id, c.CategotyName, b.Price, b.BookName
    FROM Category as c
    CROSS APPLY GetBooks(c.Id) as b---like INNER JOIN
	order by c.CategotyName

-- Используется OUTER APPLY
	SELECT c.Id, c.CategotyName, b.Price, b.BookName
    FROM Category as c
    OUTER APPLY GetBooks(c.Id) as b----like LEFT OUTER JOIN
	order by c.CategotyName


--------------
 ----FUNCTIONS RETURNS NEW TABLE----------

 declare @MyTableBookAuthor table( AuthorId int, AuthorName nvarchar(50) , BookName  nvarchar(max))
 insert into @MyTableBookAuthor SELECT Author.Id, Author.AuthorName, Book.BookName from Author join Book on Author.Id = Book.AuthorId

 select * from @MyTableBookAuthor



 ------
create TYPE SimpleIdTable as TABLE (id INT)
create function BookCategory( @countryName varchar(50)) returns @finTable TABLE (id int, Bookname varchar(50), CategoryName varchar(50))
as
begin
declare @myT SimpleIdTable;
insert into @myT select id from Author where PublishId IN (select Id from Publish where CountryId = 
										(select id from Country where CountryName = @countryName));
insert into @finTable select Book.Id, BookName, Category.CategotyName from Book, Category, @myT as t where Book.CategoryId = Category.Id and
															Book.AuthorId = t.id;
return;
end
---USE---
select * from dbo.BookCategory('Ukraine')

