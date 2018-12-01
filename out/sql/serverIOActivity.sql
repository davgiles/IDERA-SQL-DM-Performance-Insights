-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Disk I/O Activity by Top 5 Instances
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
	[Min %] = round(min(IOActivityPercentage),0),
	[Max %] = round(max(IOActivityPercentage),0),
	[Avg %] = round(avg(IOActivityPercentage),0)
from dbo.ServerStatistics ss (nolock)
INNER JOIN dbo.MonitoredSQLServers ms (nolock) ON ms.SQLServerID = ss. SQLServerID
--where UTCCollectionDateTime between @BeginDateTime and @EndDateTime
group by ms.InstanceName
order by [Avg %] desc