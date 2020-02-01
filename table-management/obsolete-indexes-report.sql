
--run the query below to return the unused index
--attention: this will return nothing if you don't collect usage statistics using the sp_iqworkmon proc. 
--Below is the description of how to use the sp_iqworkmon proc. 
--Leave it running for some days (or months depending on your workload) and then use the query below to evaluate what is obsolete.
 
/*
sp_iqworkmon [ ‘action’ ] [ , ‘mode’ ]
action = ‘start’ , ‘stop’ , ’status’ , ‘reset’
mode = ‘index’ , ‘table’ , ‘column’ , ‘all’

For example:
sp_iqworkmon  ‘start’ , ‘all’ 

If one argument is specified, it can only be action. For example:
sp_iqworkmon  ‘stop’ 

*/

begin
  declare local temporary table iq_indexuse_temp2(
    IndexName char(128) not null,
    TableName char(128) not null,
    Owner char(128) not null,
    primary key(IndexName,TableName,Owner),) in SYSTEM on commit delete rows;
    
  insert into iq_indexuse_temp2
    select distinct IndexName,TableName,Owner
      from dbo.sp_iqindexuse();
      
  select si.index_name as IndexName,
    st.table_name as TableName,
    up.user_name as Owner,
    siqidx.index_type as IndexType
    ,'drop index ' + up.user_name + '.' + st.table_name + '.' + si.index_name
    from SYS.SYSIDX as si
      ,SYS.SYSTAB as st
      ,SYS.SYSUSER as up
      ,SYS.SYSIQTAB as sit
      ,SYS.SYSIQIDX as siqidx
    where siqidx.index_type <> 'FP'
    and si.table_id = st.table_id
    and si.index_id = siqidx.index_id
    and si.table_id = siqidx.table_id
    and st.creator = up.user_id
    and sit.table_id = st.table_id
    and sit.join_id = 0
    and not exists
    (select *
      from iq_indexuse_temp2 as iqcu
      where si.index_name = iqcu.IndexName
      and st.table_name = iqcu.TableName
      and up.user_name = iqcu.Owner)
    and si.index_name not like 'ASIQ%'
    and st.table_name not like 'rs_%';
      
  drop table iq_indexuse_temp2
end
GO
