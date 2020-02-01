--temp space heaviest users
select Top 5 ConnHandle,  IQconnID, Name , IQCmdType,LastIQCmdTime, ConnCreateTime, NodeAddr, (TempTableSpaceKB+TempWorkSpaceKB) as TempSpaceUsed 
from sp_iqconnection()
order by TempSpaceUsed desc
go
--db configuration for internal dbs
exec sp_iqdbspace
go
--internal db file distribution
exec sp_iqfile
go

exec sa_server_option 'main_cache_memory_mb', 50000;
go
exec sa_server_option 'temp_cache_memory_mb', 83332;
go
--checking default installation values for server configs
select * from DBA.SYSOPTIONDEFAULTS where option_name like '%temp%'
go
/*
Setting IQ main and IQ temporary cache sizes
The MAIN_CACHE_MEMORY_MB and TEMP_CACHE_MEMORY_MB database options used to set IQ main and IQ temporary cache sizes are removed in Sybase IQ 15.0. The IQ main and IQ temporary cache size settings are now server options only. Server options may be specified on the command line or in a configuration file when starting the server. Server options apply to all databases started or created by the server.

Many server options, for example, the request logging options -zr, -zo, -zs, -zn, -zt, -zl and -zp, the console output options -o and -on, and the idle and liveness timeout values -ti and -tl, may be dynamically changed for a running server using the sa_server_option stored procedure.

Server option settings never persist. They exist in memory only while the server is running. When the server is restarted, the options must be specified again using the start parameters or by calling sa_server_option.

The IQ main and IQ temporary cache sizes set using the -iqmc and -iqtc server options may now be changed using the sa_server_option stored procedure as follows:

sa_server_option 'main_cache_memory_mb', value;
sa_server_option 'temp_cache_memory_mb', value;
Unlike the other server options listed above, the IQ main and IQ temporary cache settings are used only when starting a database. Therefore, to have an effect, a database must be started after calling sa_server_option to change the values.

Using the stored procedure sa_server_option to set the IQ main and IQ temporary cache sizes is useful mainly in a test environment, where many tests with different databases or different cache settings are run using the same server without shutting the server down. A production database should always be started using a configuration file to specify appropriate values for the number of IQ threads, IQ thread stack size, number of connections, and IQ cache sizes.
*/