
CREATE PROCEDURE dbo.sp_iqcontext_custom( in "connidparm" integer default null ) 
result( 
  "ConnOrCursor" char(22),
  "ConnHandle" unsigned bigint,
  "Name" varchar(255),
  "Userid" varchar(255),
  "numIQCursors" unsigned integer,
  "IQthreads" unsigned integer,
  "TxnID" unsigned bigint,
  "ConnOrCurCreateTime" "datetime",
  "IQconnID" unsigned bigint,
  "IQGovernPriority" char(14),
  "CmdLine" varchar(4096),
  "Attribute" varchar(255) ) 
sql security definer
begin
  declare "connid" integer;
  declare "blocksizeX2" unsigned bigint;
  declare local temporary table "t_conn_info"(
    "Number" integer null,
    "Name" varchar(255) null,
    "Userid" varchar(255) null,
    ) in "SYSTEM" on commit preserve rows;
  declare local temporary table "iq_connTable"(
    "Number" unsigned bigint null,
    "IQconnID" unsigned bigint null,
    "numIQCursors" unsigned integer null,
    "IQthreads" unsigned integer null,
    "TxnID" unsigned bigint null,
    "ConnOrCurCreateTime" "datetime" null,
    "CmdLine" varchar(4096) null,
    "ConnOrCursor" char(4096) null,
    "IQGovernPriority" char(14) null,
    "LeaderID" unsigned integer null,
    "DQPUserID" unsigned integer null,
    "Attribute" varchar(255) null,
    ) in "SYSTEM" on commit preserve rows;
  select first "block_size"/512
    into "blocksizeX2"
    from "SYSIQINFO";
    
  execute immediate with quotes on 'iq utilities main into iq_connTable command statistics 80000';
  
  if("connidparm" is not null) then
    set "connid" = "connection_property"('Number',"connidparm")
  else
    set "connid" = "next_connection"("connid",null)
  end if;
  "lbl": loop
    if "connid" is null then
      leave "lbl"
    end if;
    insert into "t_conn_info" values
      ( "connid",
      @@servername,
      "connection_property"('Userid',"connid") ) ;
    if("connidparm" is not null) then
      leave "lbl"
    else
      set "connid" = "next_connection"("connid",null)
    end if
  end loop "lbl";
  if("connidparm" is null) then
    select "ConnOrCursor","t2"."Number" as "ConnHandle",
      "coalesce"("t4"."server_name","Name") as "Name",
      "t2"."Userid" as "Userid",
      "numIQCursors","IQthreads","TxnID","ConnOrCurCreateTime",
      "IQconnID","IQGovernPriority","CmdLine","Attribute"
      from(("t_conn_info" as "t2" left outer join "iq_connTable" as "t1" on "t1"."Number" = "t2"."Number")
        left outer join "SYSIQMPXSERVER" as "t4" on "t1"."LeaderID" = "t4"."server_id")
      order by "IQGovernPriority" asc;
    drop table "t_conn_info";
    drop table "iq_connTable"
  else
    select "ConnOrCursor","t2"."Number" as "ConnHandle",
      "coalesce"("t4"."server_name","Name") as "Name",
      "coalesce"("t3"."user_name","Userid") as "Userid",
      "numIQCursors","IQthreads","TxnID","ConnOrCurCreateTime",
      "IQconnID","IQGovernPriority","CmdLine","Attribute"
      from(("t_conn_info" as "t2" left outer join "iq_connTable" as "t1" on "t1"."Number" = "t2"."Number")
        left outer join "SYSUSER" as "t3" on "t1"."DQPUserID" = "t3"."user_id")
        left outer join "SYSIQMPXSERVER" as "t4" on "t1"."LeaderID" = "t4"."server_id"
      order by "IQGovernPriority" asc;
    drop table "t_conn_info";
    drop table "iq_connTable"
  end if
end
GO
