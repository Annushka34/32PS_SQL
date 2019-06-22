SELECT *FROM sys.indexes
where object_id=(select object_id from sys.tables where name='Book')


select * from Book
set showplan_all on 
set showplan_all off

select BookName from Book WHERE BookName='jdgfsh' AND Price=200
select * from Book WHERE BookName='jdgfsh' AND Price=200



go
CREATE INDEX ix_bookNamePrice on Book(BookName, Price);
drop index ix_bookNamePrice on Book

declare @tabId INT;
DECLARE @dbId INT;
SET @dbId = DB_ID('BookShopPublisher');
SET @tabId = OBJECT_ID('Book');
PRINT @tabId
print @dbId

SELECT avg_fragmentation_in_percent, avg_page_space_used_in_percent
    FROM sys.dm_db_index_physical_stats
        (@dbId, @tabId, NULL, NULL, NULL);

sp_helpindex Book

SELECT * 
FROM [sys].[dm_db_index_usage_stats] AS ddius 

SELECT * FROM [sys].[dm_db_index_usage_stats] AS ddius 
WHERE [ddius].[database_id] = DB_ID() --поточнна БД

SELECT DB_NAME([ddius].[database_id]) AS [database name] , 
OBJECT_NAME([ddius].[object_id]) AS [Table name] , 
[i].[name] AS [index name] , 
ddius.* 
FROM [sys].[dm_db_index_usage_stats] AS ddius 
INNER JOIN [sys].[indexes] AS i ON [ddius].[index_id] = [i].[index_id] 
AND [ddius].[object_id] = [i].[object_id] WHERE [ddius].[database_id] = DB_ID() 



DROP INDEX ix_book ON Book;
go
create clustered index ci_salesdate on Sales(DateSale);--not create


go
set showplan_all off 
go 
select Book.BookName, Book.Price from Book 

go
set showplan_text off 
go 
select Book.BookName, Book.Price from Book 



-- виключити індекс 
ALTER INDEX ix_bookNamePrice ON Book DISABLE 
-- включити індекс; при этом он перестраивается 
ALTER INDEX ix_bookNamePrice ON Book REBUILD 
-------------------------------------------------------
-------------------------------------------------------
set showplan_all on 
set showplan_all off 

go
SELECT Book.BookName, Category.CategotyName
    FROM Book, Category
    WHERE Book.CategoryId = Category.Id
        AND Price >100;

create index ix_bookNameCategPrice on Book(BookName,CategoryId,Price);


CREATE STATISTICS book_stat   
ON Book (Id, BookName, CategoryId) WITH FULLSCAN ;  

sp_updatestats
sp_helpstats Book
DBCC SHOW_STATISTICS ("Book",ix_bookNameCategPrice);  

-----інекcовані вюшкі

set NUMERIC_ROUNDABORT off;
set ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS on;
go
-- creating a view 
create view iv_Shopes with schemabinding 
as 
select sh.ShopName as 'Shop', c.CountryName as 'Country', COUNT_BIG(*) AS COUNT 
from dbo.Country c, dbo.Shop sh 
where c.Id = sh.CountryId group by sh.ShopName, c.CountryName
go 

select *
from dbo.iv_Shopes as c
-- creating index for the view 
create unique clustered index uci_ivsales on iv_Shopes(Shop) 

drop index uci_ivsales on iv_Shopes
drop view iv_Shopes
go

set showplan_all off 
go 
select sh.ShopName as 'Shop', c.CountryName as 'Country'
from dbo.Country c, dbo.Shop sh 
where c.Id = sh.CountryId
group by sh.ShopName, c.CountryName

select c.Shop, c.Country
from dbo.iv_Shopes as c

EXEC sp_spaceused 'iv_Shopes';

-- виключити індекс 
ALTER INDEX uci_ivsales ON iv_Shopes DISABLE 
-- включити індекс; при этом он перестраивается 
ALTER INDEX uci_ivsales ON iv_Shopes REBUILD 

--------ПОВНОТЕКСТОВИЙ ПОШУК
create fulltext catalog Text_Book as default;

create unique index ui_BookId on dbo.Book(id); 

create fulltext index on dbo.Book(BookName, Description)
key index ui_BookId
on Text_Book;

create fulltext index on dbo.Book(BookName, Description)
key index PK__Book__3214EC075769CD33


drop fulltext index on dbo.Book


select Book.BookName, Address.City
 from Book left outer join Author on Book.AuthorID=Author.id left outer join Address on Author.AddressId=Address.id
 where freetext(BookName, 'Roksolana');  

  alter fulltext index on dbo.Book enable 
  go 
  alter fulltext index on dbo.Book start update population 
  go
  
  DROP FULLTEXT INDEX ON Book 

  create fulltext index on Author(AuthorName)
  key index PK__Author__3214EC075E4494B8

 select * from Author
where contains(Author.AuthorName,'isabout("Iva*" weight (0.8),Petrov weight (0.2))')
select * from Book
where contains(Book.BookName,'isabout("Sup*" weight (0.8),"New*" weight (0.2))')

select * from Book
where contains(Book.BookName,'isabout("s*" weight (0.1),"П*" weight (0.9))')

select * from Book
where contains(Book.BookName,'formsof(inflectional, book)')
  
  select * from containstable(Book, *, N'Super')
  
  select cb.Rank as 'Rank', b.id as 'Id', b.BookName as 'Book Title', a.AuthorName, b.Description
  from containstable(Book, Description, N'Super or NewBook*') as cb, Book as b, Author as a 
  where cb.[KEY] = b.id and b.AuthorId = a.id  

  --select*from Book
select cb.Rank, Book.Id, Book.BookName
from Book join Sales on Book.id=Sales.BookId,
freetexttable(Book, BookName, N'Super') as cb
where cb.[key]=Book.id

 select cb.Rank as 'Rank', b.id as 'Code', b.BookName as 'Book Title', a.AuthorName
 from freetexttable(Book, *, 'Super~Book or NewBook') as cb, Book as b, Author as a 
 where cb.[KEY] = b.id and b.AuthorId = a.id  

 

