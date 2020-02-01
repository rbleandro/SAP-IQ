
message 'Reloading lm_revhsth...', NOW() TO CLIENT
delete lm_revhsth from lm_revhsth "rh"
where "rh"."data_entry_date" > "dateadd"("dd",-7,"getdate"())

insert into "lm_revhsth" ignore constraint unique 0 location 'CPDB1.rev_hist_lm' packetsize 5120
{
    select rh.* from revhsth as rh (index revhsth4) 
    where rh.data_entry_date > dateadd(dd,-7,getdate())
}

message 'Reloading lm_revhstm...', NOW() TO CLIENT 
delete lm_revhstm from "lm_revhstm" as "ta","lm_revhsth" as "rh"
where "rh"."data_entry_date" > "dateadd"("dd",-7,"getdate"())
and "ta"."linkage" = "rh"."linkage"

insert into "lm_revhstm" ignore constraint unique 0 location 'CPDB1.rev_hist_lm' packetsize 5120
{ 
    select ta.* from revhstm as ta ,revhsth as rh (index revhsth4) 
    where rh.data_entry_date > dateadd(dd,-7,getdate())
    and ta.linkage = rh.linkage
    union 
    select * from revhstm (index revhstm1) where invoice_date='1900-01-01' 
    plan '(use optgoal allrows_oltp)'
}

message 'Reloading lm_revhstr...', NOW() TO CLIENT 
delete from lm_revhstr as "ta" from
"lm_revhstr" as "ta","lm_revhsth" as "rh"
where "rh"."data_entry_date" > "dateadd"("dd",-7,"getdate"())
and "ta"."linkage" = "rh"."linkage"
insert into "lm_revhstr" ignore constraint unique 0 location 'CPDB1.rev_hist_lm' packetsize 5120
{ 
    select ta.* from revhstr as ta (index revhstrx), revhsth as rh (index revhsth4) 
    where rh.data_entry_date > dateadd(dd,-7,getdate())
    and ta.linkage = rh.linkage
    plan '(use optgoal allrows_oltp)'
}

message 'Reloading lm_bcxref...', NOW() TO CLIENT 
delete from lm_bcxref as "ta" from
"lm_bcxref" as "ta","lm_revhsth" as "rh"
where "rh"."data_entry_date" > "dateadd"("dd",-3,"getdate"())
and "ta"."linkage" = "rh"."linkage"
insert into "lm_bcxref" ignore constraint unique 0 location 'CPDB1.rev_hist_lm' packetsize 5120
{ 
    select ta.* from bcxref as ta (index bcxrefy), revhsth as rh (index revhsth4) 
    where rh.data_entry_date > dateadd(dd,-3,getdate())
    and ta.linkage = rh.linkage
    plan '(use optgoal allrows_oltp)'
}

message 'Reloading lm_revhstf1...', NOW() TO CLIENT 
delete from lm_revhstf1 as "ta" from
"lm_revhstf1" as "ta","lm_revhsth" as "rh"
where "rh"."data_entry_date" > "dateadd"("dd",-3,"getdate"())
and "ta"."linkage" = "rh"."linkage"
insert into "lm_revhstf1" ignore constraint unique 0 location 'CPDB1.rev_hist_lm' packetsize 5120
{ 
    select ta.* from revhstf1 as ta, revhsth as rh (index revhsth4) 
    where rh.data_entry_date > dateadd(dd,-3,getdate())
    and ta.linkage = rh.linkage
    plan '(use optgoal allrows_oltp)'
}