-------PROCEDURES---------
exec Test

--create Procedure GetBookAuthorAddress as
--Select Book.BookName, Author.AuthorName, Address.City + ' ' + Address.Street +'  '+ Country.CountryName
--FROM Book JOIN Author ON Book.AuthorId = Author.Id
--JOIN Address ON Author.AddressId = Address.Id
--JOIN Country ON Address.CountryId = Country.Id

exec GetBookAuthorAddress

go

create procedure GetBooksByAuthorId (@Id INT) as
if EXISTS (
SELECT Book.BookName, Book.Description, Book.Price, Book.PublishDate, Book.NumberPages 
FROM Book JOIN Author ON Book.AuthorId = Author.Id WHERE Author.Id = @Id)
SELECT Book.BookName, Book.Description, Book.Price, Book.PublishDate, Book.NumberPages 
FROM Book JOIN Author ON Book.AuthorId = Author.Id WHERE Author.Id = @Id
else
print('no any books')

exec GetBooksByAuthorId 10

go
drop procedure UpdateSalesSetNewPriceForTop
create procedure UpdateSalesSetNewPriceForTop ( @Price money = 100)
as
declare @Id INT;
select  TOP(1) @Id = Id FROM Book order by PublishDate;
update Book Set Price = @Price where Id = @id

create procedure UpdateDate ( @NewDate DateTime = '2019.06.15', @Id INT = 1)
as
update Book Set PublishDate = @NewDate where Id = @Id

exec UpdateSalesSetNewPriceForTop 13.13
exec UpdateSalesSetNewPriceForTop 

exec UpdateDate '2019-04-13', 8


select * FROM Book

----------------OUTPUT-----------
create procedure InsertIntoBook (@name nvarchar(MAX), @categoryName nvarchar(MAX), @author nvarchar(max),
@price money, @page int = 0, @succesMsg nvarchar(Max) output, @amountRows INT output)
as
declare @authorId INT = 0, @categoryId Int = 0;
select @authorId  = Id from Author where AuthorName=@author;
if ( @authorId = 0 ) set @succesMsg = 'No such author'
else
begin
	select @categoryId  = Id from Category where CategotyName=@categoryName;
	if ( @categoryId = 0 ) set @succesMsg = 'No such category'
	else
	begin
	INSERT Book Values (@name, 'no', @page, @price, GETDATE(), @authorId, @categoryId );
	set @amountRows = 1;
	 set @succesMsg = 'Inserted'
	end   	 
end

go
declare @msg nvarchar(Max), @num INT
exec InsertIntoBook 'new book 111', 'Історичні', 'Ivanov', 200.5, 133, @msg output, @num output
exec InsertIntoBook 'new book 111', 'vsgdvs', 'Ivanov', 200.5, 133, @msg output, @num output

print @msg


create procedure Test1 (@a int, @b INT output)
as
set @b = @a+100;


declare @var INT = 0;
exec Test1 13, @var output
print @var


