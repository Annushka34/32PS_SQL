------TRIGGERS---------
--DML
--INSERT
--UPDATE
--DELETE
--AFTER--INSTEAD OF
--inserted---deleted

drop trigger BookInsert
create trigger BookInsert on Book
for INSERT
as
---inserted
---@@rowcount
begin
print(@@rowcount)
declare @bookName nvarchar(max);
select @bookName = BookName FROM inserted
if( LEN(@bookName)<2)
raiserror('no correct name', 0,1, @@rowcount)
end

insert into Book values ('a', 'kkk', 100, 20.5, '2019-12-12', 1, 1)


---------------------------------------------
create trigger SaleInsert on Sales
instead of INSERT
as
---inserted
---@@rowcount
begin

declare @bookId INT;
select @bookId = BookId FROM inserted

declare @salesAmount int, @incomesAmount INT;
select @salesAmount = SUM(Amount) FROM Sales Where BookId = @bookId;
select @incomesAmount = SUM(Amount) FROM Incomes Where BookId = @bookId;
declare @existsBooks int = @incomesAmount - @salesAmount;

declare @amountToSale INT;
select @amountToSale = Amount FROM inserted
if(@amountToSale > @existsBooks)
	raiserror('books not enought', 0,1, @@rowcount)
else
	begin
	declare @shopId int, @dateSale DateTime, @salePrice money;
	Select @shopId = ShopId FROM inserted;
	Select @dateSale = DateSale FROM inserted;
	Select @salePrice = SalePrice FROM inserted;
	insert into Sales values (@shopId, @bookId, @dateSale, @amountToSale, @salePrice);
	raiserror('OK!!! Inserted', 0,1, @@rowcount)
	end
end

insert into Sales values (1, 1, GetDate(), 3000, 25.5);

select * from Sales


-------------------------------

--DDL
--CREATE
--ALTER
--DROP
go
create trigger NotAlterDropTabl
on DATABASE
for DROP_TABLE, ALTER_TABLE
as
begin 
print 'Ви не маєте права видаляти чи змінювати таблиці в цій БД'
rollback
end
go
drop trigger NotAlterDropTable on DATABASE
select * from  sys.triggers

alter table Book
add phone_1 int