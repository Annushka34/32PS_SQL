use BookShopPublisher

create function BookCount() returns INT
as
begin
declare @counter int;
select @counter = COUNT(Id) FROM Book
return @counter;
end

declare @counter INT = dbo.BookCount();
SELECT @counter;

create function BookNameAtId( @id INT ) returns nvarchar(50)
as
begin
declare @name nvarchar(50);
select @name = BookName from Book WHERE Id = @id;
return 'Книжка: '+ convert(nvarchar(5),@id)+' - '+@name;
end

drop function BookNameAtId

print dbo.BookNameAtId(10)

------------------------------------------------------------------------

create function CountProfitFromSale(@percent int) returns money
as
begin
declare @profit money;
declare @incomes money;

select @incomes = (SUM(SalePrice*Amount)) from Sales;
set @profit = @incomes/100*@percent;
return @profit;
end

print dbo.CountProfitFromSale(20);

--------------------------------------------------------------------
create function avgPrice(@id INT) returns money
as
begin
declare @price money;
select @price = avg(Sales.SalePrice) from Sales where BookId=@id;
return @price;
end

declare @id int;
set @id = 0;
while (@id<(SELECT COUNT(*) FROM Book))
begin
set @id=@id+1;
declare @p int = dbo.avgPrice(@id);
if(@p is not null)
begin
select Book.BookName,  @id as [id], dbo.avgPrice(@id) as [сер ціна продаж], Price from Book Where id = @id ;
end
end;

---------------------returns table---------------

create function BookInCategory( @categName nvarchar(50)) returns table
as
return(select BookName From Book Where CategoryId = (select Id from Category where CategotyName = @categName))

select * FRom dbo.BookInCategory('Історичні')

-----------------------------------------------------------------------------------------------
GO
CREATE FUNCTION AuthorsInCountry (@Country nvarchar(20))
    RETURNS TABLE
    AS 
	RETURN (SELECT Author.AuthorName
        FROM Author, Address, Country
        WHERE Author.AddressId = Address.Id and Address.CountryId = Country.Id and Country.CountryName = @Country)
go
		select * from AuthorsInCountry('Poland')
go

------------------------------------------------------------------------------------------------
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

	----------------------------------------------------------------------------------------
declare @myT table (id int);

create TYPE SimpleIdTable as TABLE (id INT)
--create TYPE myTable2 as TABLE (id int, Bookname varchar(50), CategoryName varchar(50));

--declare @myT1 myTable2;
--declare @myT1 table (id int, Bookname varchar(50), CategoryName varchar(50));

create function BookCategory( @countryName varchar(50)) returns @finTable TABLE (id int, Bookname varchar(50), CategoryName varchar(50))
as
begin
declare @myT SimpleIdTable;
insert into @myT select id from Author where PublishId IN (select Id from Publish where CountryId = 
										(select id from Country where CountryName = @countryName));

--declare @finTable myTable2;
insert into @finTable select Book.Id, BookName, Category.CategotyName from Book, Category, @myT as t where Book.CategoryId = Category.Id and
															Book.AuthorId = t.id;
return;
end

select * from dbo.BookCategory('Ukraine')

-------------------------------------------------------------------------------------------------

-----------багатооператора функція-----------

create function BookShop2() returns @tableBookShop table (id int, BookName varchar(50), ShopName varchar(50), Category varchar(50))
as
begin
declare @BookCateg table (BookId int, BookName varchar(50), Category varchar(50));
insert @BookCateg select Book.Id, BookName, CategotyName from Book left outer join Category on Book.CategoryId = Category.Id

insert @tableBookShop
select distinct bb.BookId, bb.BookName, Shop.ShopName, bb.Category from @BookCateg as bb left outer join (Sales inner join Shop on Sales.ShopId = Shop.Id) on bb.BookId = Sales.BookId;
return
end;

select * from BookShop2();

---------варіант 2---------------
create TYPE myBookShopCategTable as table (id int, BookName varchar(50), ShopName varchar(50), Category varchar(50))

create table #BSHCTable (id int, BookName varchar(50), ShopName varchar(50), Category varchar(50))

create function BookShop3( @t myBookShopCategTable readonly) returns @BSHC table (id int, BookName varchar(50), ShopName varchar(50), Category varchar(50))
as 
begin
insert into @BSHC select * from @t
return;
end

declare @t myBookShopCategTable
insert into @t select distinct Book.Id, BookName, 
Shop.ShopName, CategotyName from Category as c right outer join (Book left outer join 
						(Sales inner join Shop on Sales.ShopId = Shop.Id) on Book.Id = Sales.BookId)
						on c.Id = Book.CategoryId;
select * from BookShop3(@t)


create function CalcSalesVal(@id as INT) returns money
as
begin
declare @price money;
select @price =  Price from Book where id = @id;
return @price;
end

CREATE TABLE NewSales
(
id int identity primary key,
BookId int foreign key references Book(id),
SalesAmount int,
SalesSum as dbo.CalcSalesVal(BookId)*SalesAmount
)


select * from NewSales

insert into NewSales values (12, 13);

--------------------------------KURSORS---------------------------

declare book_cursor cursor local keyset 
 for select id, Book.BookName, Price from Book 
 for update;
 open book_cursor; 
 -- витягнути девятий
 fetch absolute 9 from book_cursor; 
 -- внесення змін
 update Book set Price = 100 where current of book_cursor; 
 -- перевірка
 select * from Book where Price = 100; 

 DECLARE @Report CURSOR

 close book_cursor; 
 deallocate book_cursor; 
 go

 -------------------------------------------------------------
 --для update delete
 declare book_cursor cursor 
 for select * from Sales as s
 where s.SalePrice <= (select AVG(b.Price)+50 from Book b where s.BookId = b.Id )
 open book_cursor; 
 -- перемещаемся на первую запись 
 fetch from book_cursor; 
 -- удаляем запись, на которую указывает курсор 
 delete from Sales where current of book_cursor; --!!!!!!!
 close book_cursor; 
 deallocate book_cursor;




 
------------KURSOR-------------------------
-------------------------------------------
-- declare cursor 
declare author_cursor cursor 
for select Author.AuthorName from Author;
go
 -- open cursor 
 open author_cursor; 
 -- get first record from cursor 
 fetch next from author_cursor; 
 fetch next from author_cursor; 
 -- close cursor 
 close author_cursor; 
 -- deallocate resources 
 deallocate author_cursor; 
 go

 -------------------------------------------------
 declare author_cursor cursor for select Author.AuthorName from Author; 
 open author_cursor; 
 fetch next from author_cursor;  -- get first record from cursor 
 while @@FETCH_STATUS = 0 -- 0 – успішно; ■ 1 – невдало; ■ 2 – намагання зчитати запис за межами
 begin  
 fetch next from author_cursor; -- get the next record 
 end
 close author_cursor; 
 deallocate author_cursor; 

 -------------------------------------------------
 declare book_cursor cursor 
 for select BookName, Price from Book
 declare @fname varchar(50), @p money; 
 open book_cursor; 
 fetch next from book_cursor into @fname, @p; 
 -- display the variables values 
 print 'Name: '+@fname+ '  ціна '+convert(nvarchar(10),@p) 
 while @@FETCH_STATUS = 0 
 begin 
 fetch next from book_cursor into @fname, @p; 
 print 'Name: '+@fname+ '  ціна '+convert(nvarchar(10),@p) 
 end
 close book_cursor;
 deallocate book_cursor; 
 go