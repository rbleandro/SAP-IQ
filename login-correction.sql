
use master
go
select "<BR><b>Adding Customer Service role...</b><BR>"
go
EXEC sp_role 'grant','cust_serv','bhaskar_nagalapat'
go
EXEC sp_modifylogin 'bhaskar_nagalapat', 'add default role', cust_serv
go
select "<BR><b>Adding CMF Users role...</b><BR>"
go
EXEC sp_role 'grant','cmf_users','bhaskar_nagalapat'
go
EXEC sp_modifylogin 'bhaskar_nagalapat', 'add default role', cmf_users
go
select "<BR><b>Adding HTWS role...<b><BR>"
go
EXEC sp_role 'grant','htws_role','bhaskar_nagalapat'
go
EXEC sp_modifylogin 'bhaskar_nagalapat', 'add default role', htws_role
go
EXEC sp_role 'grant','rate_update_role','bhaskar_nagalapat'
go
EXEC sp_modifylogin 'bhaskar_nagalapat', 'add default role', rate_update_role
go
EXEC sp_role 'grant','loomis_users','bhaskar_nagalapat'
go
EXEC sp_modifylogin 'bhaskar_nagalapat', 'add default role', loomis_users
go

--begin tran
--
--INSERT INTO dbo.tttl_ma_document(shipper_num, manifest_num, manifest_date, filedatetime, manlink, weight_unit, EDMP_flag, filenum, filename, inserted_on, updated_on) 
--	VALUES('', '', '2019-7-24 15:9:59', '2019-7-24 15:9:59', 0, '', 0, 0, '', '2019-7-24 15:9:59', '2019-7-24 15:9:59')
--
--rollback
