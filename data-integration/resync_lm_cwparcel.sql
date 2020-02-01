declare @time datetime
set @time = get value from iq
declare @now datetime
set @now = getdate() - 3 minutes

--select top 1 * from stg_cwparcel t where not exists (select * from "DBA"."lm_pr_cwparcel" l where l.package_id=t.package_id and l.inserted_on > @time) order by package_id
--select * from "DBA"."lm_pr_cwparcel" where inserted_on > @time
/*
select * from dba.lm_pr_cwparcel where package_id='!C10120056394300558                     '
insert into stg_cwparcel location 'CPDB1.rev_hist_lm' packetsize 5120{ select * from pr_cwparcel where package_id='!C10120056394300558                     '}
*/
--select count(*) from stg_cwparcel where package_id='!C10120056394300558                     '
--select top 40205 * from stg_cwparcel --where package_id ='RXVZ701869'

--CREATE TABLE #tempcwparcel ( linkage integer NOT NULL, shipment_id smallint NOT NULL, package_id char(40) NOT NULL, dimension_unit char(1) NOT NULL, length decimal(5,2) NOT NULL, width decimal(5,2) NOT NULL, height decimal(5,2) NOT NULL, dimensional_weight decimal(6,2) NOT NULL, weight_unit char(1) NOT NULL, measured_weight decimal(6,2) NOT NULL, scale_weight decimal(6,2) NOT NULL, cwused char(1) NOT NULL, equipment_id_scale char(10) NOT NULL DEFAULT '', equipment_id_dims char(10) NOT NULL DEFAULT '', cubed_date datetime NOT NULL, inserted_on datetime NOT NULL, updated_on datetime NOT NULL, PRIMARY KEY(package_id) )
--CREATE TABLE stg_cwparcel ( linkage integer NOT NULL, shipment_id smallint NOT NULL, package_id char(40) NOT NULL, dimension_unit char(1) NOT NULL, length decimal(5,2) NOT NULL, width decimal(5,2) NOT NULL, height decimal(5,2) NOT NULL, dimensional_weight decimal(6,2) NOT NULL, weight_unit char(1) NOT NULL, measured_weight decimal(6,2) NOT NULL, scale_weight decimal(6,2) NOT NULL, cwused char(1) NOT NULL, equipment_id_scale char(10) NOT NULL DEFAULT '', equipment_id_dims char(10) NOT NULL DEFAULT '', cubed_date datetime NOT NULL, inserted_on datetime NOT NULL, updated_on datetime NOT NULL, PRIMARY KEY(package_id) )

truncate table stg_cwparcel
insert into stg_cwparcel location 'CPDB1.rev_hist_lm' packetsize 5120{ select * from pr_cwparcel where inserted_on > (select ... from inte.... where tablename = ...) }
insert into "DBA"."lm_pr_cwparcel" select * from stg_cwparcel t where not exists (select * from "DBA"."lm_pr_cwparcel" l where l.package_id=t.package_id and l.inserted_on > @time)
update production..integration_control set... = @now
update iq..integration_control set ... = @now

--select count(package_id) from stg_cwparcel t where  exists (select * from "DBA"."lm_pr_cwparcel" l where l.package_id=t.package_id and l.inserted_on > convert(date,dateadd(day, -3, getdate())))
--select count(package_id) from stg_cwparcel t where not exists (select * from "DBA"."lm_pr_cwparcel" l where l.package_id=t.package_id and l.inserted_on > convert(date,dateadd(day, -3, getdate())))
--delete from "DBA"."lm_pr_cwparcel" where inserted_on > @time
--select count(*) from #tempcwparcel
--drop table #tempcwparcel

--update integration_control set processed = @now where tablename = 'lm_pr_cwparcel'
--select convert(date,dateadd(day, -8, getdate()))
--select dateadd(day, -8, getdate()))
--select count(*) from #tempcwparcel
--create table dba.integration_control (tablename varchar(50),processed datetime)
--insert into dba.integration_control values ('lm_pr_cwparcel',convert(date,dateadd(day, -7, getdate())))
--RXVZ701869             
--40204

/*


  truncate table stg_cwparcel
  insert into stg_cwparcel location 'CPDB1.rev_hist_lm' packetsize 5120{ select * from pr_cwparcel where inserted_on > dateadd(day, -3, getdate()) }
  delete "DBA"."lm_pr_cwparcel" where package_id in (select package_id from stg_cwparcel)
  insert into "DBA"."lm_pr_cwparcel"  select * from stg_cwparcel t 
  truncate table stg_cwparcel
  
  */

