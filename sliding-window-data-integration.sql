--drop table ExtractionControl_cpscan 
--create existing table ExtractionControl_cpscan at 'CPDB1.cpscan..ExtractionControl' --to create a proxy table for ASE 
--update ExtractionControl_cpscan set last_extraction = dateadd(dd,-2,getdate()) where tbl = 'tttl_ma_barcode_IQ'

declare @cutoffdate datetime,@newcutoffdate datetime
select @cutoffdate=last_extraction from ExtractionControl_cpscan where tbl = 'tttl_ma_barcode_IQ'
set @newcutoffdate=dateadd(ss,-5,getdate())

delete from "tttl_ma_barcode" where "updated_on" > @cutoffdate
insert into "tttl_ma_barcode" ignore constraint unique 0 location 'CPDB1.cpscan' packetsize 5120{ SELECT * from tttl_ma_barcode where updated_on > (select last_extraction from dbo.ExtractionControl where tbl = 'tttl_ma_barcode_IQ')}
update ExtractionControl_cpscan set last_extraction = @newcutoffdate where tbl = 'tttl_ma_barcode_IQ'
go
--select last_extraction from ExtractionControl_cpscan where tbl = 'tttl_ma_barcode_IQ'
select * from tttl_ma_barcode where updated_on > '10/8/2018 5:25:22 PM'
go



declare @cutoffdate datetime,@newcutoffdate datetime
select @cutoffdate=last_extraction from ExtractionControl_cmf_data where tbl = 'iloodaily_IQ'
set @newcutoffdate=dateadd(ss,-5,getdate())

message 'Reloading DBA.iloodaily...', NOW() TO CLIENT
delete from "iloodaily" where "updated_on" > @cutoffdate
insert into "iloodaily" ignore constraint unique 0 location 'CPDB1.cmf_data' packetsize 5120{ SELECT * from iloodaily where updated_on > (select last_extraction from dbo.ExtractionControl where tbl = 'iloodaily_IQ')}
update ExtractionControl_cmf_data set last_extraction = @newcutoffdate where tbl = 'iloodaily_IQ'

