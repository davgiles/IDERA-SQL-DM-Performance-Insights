-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Database Statistic Averages in Last 4 hours
set transaction isolation level read uncommitted

declare
	@UTCSnapshotCollectionDateTime datetime = null,
	@HistoryInMinutes int = 240, --4 hours
	@BeginDateTime datetime,
	@EndDateTime datetime

select @EndDateTime = (select max(UTCCollectionDateTime) from dbo.ServerStatistics)

if (@HistoryInMinutes is null)
	select @BeginDateTime = @EndDateTime
else
	select @BeginDateTime = dateadd(n, -@HistoryInMinutes, @EndDateTime)

select
	[SQL Instance:DB] = ms.InstanceName + ':' + dn.DatabaseName,
	[Bytes Read/sec (mb)] = format(avg(ds.BytesRead/1024),'N0'),
	[Bytes Written/sec (mb)] = format(avg(ds.BytesWritten/1024),'N0'),
	[Transactions/sec] = format(avg(ds.Transactions),'N0'),
	[Log CacheHit Ratio] = format(avg(LogCacheHitRatio),'N0'),
	[Log Cache Reads] =	format(avg(LogCacheReads),'N0'),
	[Log Flush Waits/sec] =	format(avg(LogFlushWaits),'N0'),
	[Log Flushes/sec] =	format(avg(LogFlushes),'N0'),
	[Log KB Flushed/sec] = format(avg(LogKilobytesFlushed),'N0')
from dbo.DatabaseStatistics ds
	inner join dbo.SQLServerDatabaseNames dn on dn.DatabaseID = ds.DatabaseID
	inner join dbo.MonitoredSQLServers ms on ms.SQLServerID = dn.SQLServerID
where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName + ':' + dn.DatabaseName
order by [SQL Instance:DB] asc