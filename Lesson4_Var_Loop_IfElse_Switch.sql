--declare @a INT;
declare @b INT = 10;
--set @a = 5;
--1--
--select @a;
print @b;
print ('my var b = '+ convert(nvarchar(MAX), @b))

declare @name nvarchar(MAX) = 'Olga';
print (@name)
print ('test = '+@name+ convert(nvarchar(MAX), @b))

select Book.BookName FROM Book where Id=5;

select Book.BookName, Category.CategotyName FROM Book, Category where Book.CategoryId = Category.Id AND Book.Id = 5
select Book.BookName, Category.CategotyName FROM Book JOIN Category ON Book.CategoryId = Category.Id
	WHERE Book.Id = 5

go
declare @b INT = 10;
declare @book nvarchar(50), @category nvarchar(50);
select @book = Book.BookName, @category = Category.CategotyName FROM Book, Category where Book.CategoryId = Category.Id AND Book.Id = @b
print ('test = '+@book+' - ' + @category + '  Id = ' +  convert(nvarchar(MAX), @b))

---------IF---------------
go
declare @price money;
select @price = Price FROM Book Where Id = 5;
if @price > 100
print ('expencive')
else
print ('cheep')

go
declare @amount INT;
declare @authorName nvarchar(max) = 'Petrov';
select @amount = SUM(Amount) FROM Sales JOIN Book ON Sales.BookId = Book.Id
WHERE Book.AuthorId IN (SELECT Id FROM Author WHERE AuthorName = @authorName)
if (@amount > 10)
begin
begin transaction
	print ('sales by author '+ @authorName + ' = ' + convert(nvarchar(20), @amount))
	select * FROM Book 
	WHERE Book.AuthorId IN (SELECT Id FROM Author WHERE AuthorName = @authorName)
	declare @procent float = 10;
	update Book set Price = Price + (Price * @procent/100) 
		where Book.AuthorId IN (SELECT Id FROM Author WHERE AuthorName = @authorName)
	if (@@error <> 0)
		rollback transaction 
	print ('after increase')
	select * FROM Book 
	WHERE Book.AuthorId IN (SELECT Id FROM Author WHERE AuthorName = @authorName)
commit transaction
end
else
	print ('sales by author not enought')

-----------------IF EXISTS--------------
if exists (select * from Book where Id= 5)
begin
print ('id = 5')
delete From Book where Id=5
print('deleted')
end
else
print('no such book')

-------------------SWITCH-----------------

select Book.BookName, 'Price' = 
case Book.Price 
when 250.5 then '-'
when 275.55 then 'more then 275'
else 'something else'
end
from Book


select Book.BookName, Author.AuthorName, 'Country' =  
case Country.CountryName
when 'Ukraine' then 'Вітчизняний'
--when is null then 'no'
else 'Зарубіжний'
end
FROM Book LEFT OUTER JOIN Author on Book.AuthorId = Author.Id
LEFT OUTER JOIN Address on Address.Id = Author.AddressId
LEFT OUTER JOIN Country on Country.Id = Address.CountryId



select Book.BookName, Author.AuthorName, 'Country' =  
case 
when  Country.CountryName IS NULL then 'No author'
else Country.CountryName
end
FROM Book LEFT OUTER JOIN Author on Book.AuthorId = Author.Id
LEFT OUTER JOIN Address on Address.Id = Author.AddressId
LEFT OUTER JOIN Country on Country.Id = Address.CountryId



select Book.BookName, Author.AuthorName, Country.CountryName, 'Price' = 
case 
when Book.Price > 200 then 'Expencive'
when Book.Price > 50 then 'Middle'
else 'Cheep'
end
FROM Book LEFT OUTER JOIN Author on Book.AuthorId = Author.Id
LEFT OUTER JOIN Address on Address.Id = Author.AddressId
LEFT OUTER JOIN Country on Country.Id = Address.CountryId


------------------LOOP----------------

declare @i INT = 1;
declare  @name nvarchar(max) ='';
--select @i = count(*) from Book;
while (@i <> 20)
begin
if exists (select Book.BookName FROM Book where Id = @i)
begin
select @name = Book.BookName FROM Book where Id = @i;
print (@name)
end
else
begin
print('no such Id'+convert(nvarchar(5), @i))
break;
end
set @i+=1;
end

select Book.BookName FROM Book;

select * FROM Book Order By Price

go
declare @i INT = 0, @Id INT;
WHILE ( @i <> 5 )
begin
select @Id =  Id FROM Book Order By Price offset @i rows fetch next 1 rows only
select * FROM Book WHERE Id = @Id
update Book Set Price = Price*1.03 where Id = @Id;
select * FROM Book WHERE Id = @Id
set @i+=1;
end















