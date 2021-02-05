select  c.ConnHandle,  c.IQconnID, c.Name, t.Userid, t.TxnID, t.State, t.TxnCreateTime
, c.IQCmdType,c.LastIQCmdTime, c.ConnCreateTime, c.NodeAddr, (c.TempTableSpaceKB+c.TempWorkSpaceKB) as TempSpaceUsed
, i.IQGovernPriority ,i.CmdLine
, w.BlockedOn,w.BlockUserid
, c.IQthreads
from sp_iqtransaction() t  
left join sp_iqcontext()  i on t.ConnHandle = i.ConnHandle
left join sp_iqwho() w on w.ConnHandle = t.ConnHandle
left join sp_iqconnection() c on t.ConnHandle = c.ConnHandle
where c.ConnHandle <> @@spid
order by t.TxnID asc
go
sp_iqtransaction --returning detailed info about current transactions
go
sp_iqcontext 50605 --returning detailed session information
go

--drop connection 50576
go
sp_iqtransaction --returning detailed info about current transactions
go
sp_iqcontext 365 --returning detailed session information
go
sp_iqconnection 365
go
sp_iqwho 365
go