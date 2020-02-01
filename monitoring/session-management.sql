select  c.ConnHandle,  c.IQconnID, c.Name , c.IQCmdType,c.LastIQCmdTime, c.ConnCreateTime, c.NodeAddr, (c.TempTableSpaceKB+c.TempWorkSpaceKB) as TempSpaceUsed, i.IQGovernPriority ,i.CmdLine
,w.BlockedOn,w.BlockUserid--,w.TempTableSpaceKB,w.TempWorkSpaceKB
from sp_iqconnection() c inner join sp_iqcontext()  i on c.ConnHandle = i.ConnHandle
inner join sp_iqwho() w on w.ConnHandle = c.ConnHandle
order by IQGovernPriority asc
go
sp_iqtransaction --returning detailed info about current transactions
go
sp_iqcontext 50605 --returning detailed session information
go

--drop connection 50576