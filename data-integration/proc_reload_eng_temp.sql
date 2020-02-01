exec reload_eng_temp @numcols=3
go
alter procedure reload_eng_temp @numcols tinyint=null
as

if @numcols is null
    select @numcols = numcols from eng_temp_control

if @numcols is null 
    set @numcols=1

declare @coltext varchar(1000)

if @numcols = 1
    set @coltext = 'col_text_1'
if @numcols = 2
    set @coltext = 'col_text_1,col_text_2'
if @numcols = 3
    set @coltext = 'col_text_1,col_text_2,col_text_3'
if @numcols = 4
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4'
if @numcols = 5
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1'
if @numcols = 6
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1,col_int_2'
if @numcols = 7
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1,col_int_2,col_float_1'                        
if @numcols = 8
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1,col_int_2,col_float_1,col_float_2'
if @numcols = 9
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1,col_int_2,col_float_1,col_float_2,col_date_1'
if @numcols = 10
    set @coltext = 'col_text_1,col_text_2,col_text_3,col_text_4,col_int_1,col_int_2,col_float_1,col_float_2,col_date_1,col_date_2'

truncate table eng_temp

declare @command varchar(4000)
set @command  ='LOAD TABLE eng_temp (' + @coltext + ') FROM ''/opt/sybase/bcp_data/eng_temp.csv'' 
DELIMITED BY 0x2c 
--ROW DELIMITED BY 0x0d0a
ESCAPES OFF 
QUOTES OFF 
FORMAT ASCII
'

execute(@command)
go

select * from eng_temp
go
select * from eng_temp_control
go
truncate table eng_temp
go
--each line in the file must end with comma. In this case, the line end (or newline character) is 'enter' or \n
LOAD TABLE eng_temp
( col_text_1)
FROM '/opt/sybase/bcp_data/eng_temp.csv'
DELIMITED BY 0x2c
--ROW DELIMITED BY 0x0d0a
ESCAPES OFF 
QUOTES ON
FORMAT ASCII
go

select count(*) from eng_temp
go


create table eng_temp_control (numcols tinyint)
go
insert into eng_temp_control values(1)
