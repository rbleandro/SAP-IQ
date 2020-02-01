--exec sp_iqtablesize 

--generate execution of sp_iqtablesize for all user tables
alter procedure generate_iqtablesize_commands
as
set nocount on
declare @sp varchar(20)
select @sp = 'exec sp_iqtablesize'
select @sp as cmd, '''' + substring(user_name,1,30) + '.' + substring(table_name,1,66) + '''' + ' ' as name
from SYS.SYSTABLE t1 
inner join SYS.SYSUSERPERM t2 on t2.user_id = t1.creator
where 1=1
and substring(user_name,1,30) not like 'SYS'
and table_type = 'BASE'
and file_id <> 0
order by 1
go

--Displays the size of all objects and sub-objects in all tables in all dbspaces in the database:
sp_iqdbspaceinfo
go

alter procedure generate_iqtablesize_commands
as
set nocount on
declare @sp varchar(20)
select @sp = 'exec sp_iqtablesize'
select cmd, name from (
select 'create or replace procedure iqtablesize' as cmd, ' as begin' as name, 1 as id
union
select @sp as cmd, '''' + substring(user_name,1,30) + '.' + substring(table_name,1,66) + '''' + ' ' as name, 2 as id
from SYS.SYSTABLE t1 
inner join SYS.SYSUSERPERM t2 on t2.user_id = t1.creator
where 1=1
and substring(user_name,1,30) not like 'SYS'
and table_type = 'BASE'
and file_id <> 0
union
select 'end' as cmd,'' as name,3 as id
order by id
) as a
go