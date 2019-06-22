--DML
--INSERT
--UPDATE
--DELETE
--AFTER--INSTEAD OF
--inserted---deleted

create trigger AddAuthor
on Author for INSERT
as
begin
raiserror('added',1,0,@@rowcount);
end
go

create trigger DontAddAuthor
on Author instead of INSERT
as
begin
declare @name varchar(30);
declare @idC int;
declare @idP int;

select @name =  AuthorName From inserted;
select @idC =  AddressId From inserted;
select @idP =  PublishId From inserted;

if exists(
select AuthorName from Author where AuthorName=@name)
raiserror('cant add',1,0,@@rowcount);
else 
begin
Insert into Author values (@name,@idC,@idP);
raiserror('added',1,0,@@rowcount);

end
end
go
drop trigger DontAddAuthor
Insert into Author values ('Ivanov2',2,2);
go
create trigger ChangePrice on dbo.Book
for update
as
declare @id varchar(30);
select @id= BookName from inserted
declare @mes varchar(30);
set @mes = 'було змінено '+ CONVERT(varchar(20),@id);
raiserror(@mes,0,1)

drop trigger ChangePrice
update Book
Set Price = Price*1.2 Where Id=11

--DDL
--CREATE
--ALTER
--DROP
go
create trigger NotAlterDropTable 
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

alter table Users
add phone int



