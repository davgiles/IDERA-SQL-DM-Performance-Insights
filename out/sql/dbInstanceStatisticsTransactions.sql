-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Database Statistics by Top 5 Instances (Transactions)
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
	[Max Trans/sec] = round(max(ds.Transactions),0),
	[Avg Trans/sec] = round(avg(ds.Transactions),0)
from dbo.DatabaseStatistics ds
	inner join dbo.SQLServerDatabaseNames dn on dn.DatabaseID = ds.DatabaseID
	inner join dbo.MonitoredSQLServers ms on ms.SQLServerID = dn.SQLServerID
--where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName
order by [Avg Trans/sec] desc