-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Server Statistics AVG CPU %
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
	[Min %] = round(min(CPUActivityPercentage),0),
	[Max %] = round(max(CPUActivityPercentage),0),
	[Avg %] = round(avg(CPUActivityPercentage),0)
from dbo.ServerStatistics ss (nolock)
INNER JOIN dbo.MonitoredSQLServers ms (nolock) ON ms.SQLServerID = ss. SQLServerID
where --UTCCollectionDateTime between @BeginDateTime and @EndDateTime and
	CPUActivityPercentage IS NOT NULL
group by InstanceName
order by [Avg %] desc