alter table interco_stops add lm_pieces int
alter table interco_stops add cp_pieces int
alter table interco_stops add ic_pieces int
alter table interco_stops add tf_pieces int
alter table interco_stops add uk_pieces int
alter table interco_stops add total_pieces int
go

alter table interco_pieces add scan_time_date_adjusted datetime null
update interco_pieces set  scan_time_date_adjusted=scan_time_date

if not exists (select * from interco_pieces Where scan_time_date_adjusted != scan_time_date)
begin
    alter table interco_pieces drop scan_time_date
    alter table interco_pieces rename scan_time_date_adjusted to scan_time_date
    commit
end
else
    message 'cant drop the column. Check the data in the new column', NOW() TO CLIENT 
go