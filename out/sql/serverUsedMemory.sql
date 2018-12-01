-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Avg SQL Server Memory Used [MB] by Top 5 Instances
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

select top (@TopN)
	[SQL Instance] = InstanceName,
	[Min Used] =
		round(case when min(SqlMemoryUsedInKilobytes/1024) IS NULL then 0
				else min(SqlMemoryUsedInKilobytes/1024) end,0),
	[Max Used] =
		round(case when max(SqlMemoryUsedInKilobytes/1024) IS NULL then 0
				else max(SqlMemoryUsedInKilobytes/1024) end,0),
	[Avg Used] =
		round(case when avg(SqlMemoryUsedInKilobytes/1024) IS NULL then 0
				else avg(SqlMemoryUsedInKilobytes/1024) end, 0)
from dbo.ServerStatistics ss (nolock)
INNER JOIN dbo.MonitoredSQLServers ms (nolock) ON ms.SQLServerID = ss. SQLServerID
--where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName
order by [Avg Used] desc