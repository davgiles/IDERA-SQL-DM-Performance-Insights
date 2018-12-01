-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Database Statistics by Top 5 Instances (Log)
set transaction isolation level read uncommitted

declare
	@HistoryInMinutes int = 240, --4 hours
	@BeginDateTime datetime,
	@EndDateTime datetime,
	@TopN int = 5

select @EndDateTime = (select max(UTCCollectionDateTime) from dbo.ServerStatistics)

if (@HistoryInMinutes is null)
	select @BeginDateTime = @EndDateTime
else
	select @BeginDateTime = dateadd(n, -@HistoryInMinutes, @EndDateTime)

select TOP (@TopN)
	[SQL Instance] = ms.InstanceName,
	[Avg Log Flushes/sec] =	round(avg(LogFlushes),0),
	[Max Log Flushes/sec] =	round(max(LogFlushes),0),
	[Avg Flush Waits/sec] =	round(avg(LogFlushWaits),0),
	[Max Flush Waits/sec] =	round(max(LogFlushWaits),0)
from dbo.DatabaseStatistics ds
	inner join dbo.SQLServerDatabaseNames dn on dn.DatabaseID = ds.DatabaseID
	inner join dbo.MonitoredSQLServers ms on ms.SQLServerID = dn.SQLServerID
--where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName
order by [Avg Log Flushes/sec] desc