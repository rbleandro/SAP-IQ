truncate table eng_temp
go
select count(*) from eng_temp
go
--each line in the file must end with comma. In this case, the line end (or newline character) is 'enter' or \n
LOAD TABLE eng_temp
( col_text_1)
FROM '/opt/sybase/bcp_data/eng_temp.csv'
DELIMITED BY 0x2c
ROW DELIMITED BY 0x0d0a
ESCAPES OFF 
QUOTES ON
FORMAT ASCII
go

select count(*) from eng_temp
go