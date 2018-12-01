-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Top Instances Query Count
DECLARE
	@TopX int=10

select Top (@TopX)
	[SQL Instance] = mss.InstanceName,
	[# of Queries] = count(qms.QueryStatisticsID)
from dbo.QueryMonitorStatistics qms WITH(NOLOCK)
left join dbo.MonitoredSQLServers mss WITH(NOLOCK) on mss.SQLServerID = qms.SQLServerID
where mss.Active=1
group by mss.InstanceName
order by [# of Queries] desc
