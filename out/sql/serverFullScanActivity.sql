-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Sum Full Scans by Top 5 Instances
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
	[Full Scans] = round(CASE WHEN SUM(FullScans/nullif(TimeDeltaInSeconds,0)) IS NULL THEN 0 ELSE SUM(FullScans/nullif(TimeDeltaInSeconds,0)) END, 0)
from dbo.ServerStatistics ss (nolock)
INNER JOIN dbo.MonitoredSQLServers ms (nolock) ON ms.SQLServerID = ss. SQLServerID
--where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName
order by [Full Scans] desc