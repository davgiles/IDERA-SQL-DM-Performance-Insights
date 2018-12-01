-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Average Wait Statistics by Top 10 Instances
declare @TopN int = 10

select top (@TopN)
	[SQL Instance] = COALESCE(MS.[FriendlyServerName],MS.[InstanceName]),
	[Avg Wait Time (s)] = round(avg(WD.WaitTimeInMilliseconds/1000),0),
	[Max Wait Time (s)] = round(avg(WD.MaxWaitTimeInMilliseconds/1000),0),
	[Avg Resource Wait Time (s)] = round(avg(WD.ResourceWaitTimeInMilliseconds/1000),0)
from dbo.WaitStatistics WS (nolock)
JOIN dbo.WaitStatisticsDetails WD (nolock) ON WD.[WaitStatisticsID] = WS.[WaitStatisticsID]
JOIN dbo.MonitoredSQLServers MS (nolock) ON MS.SQLServerID = WS.SQLServerID
JOIN dbo.ApplicationNames A (nolock) ON WD.[WaitingTasks] = A.ApplicationNameID
JOIN dbo.WaitTypes WT (nolock) ON WD.WaitTypeID = WT.WaitTypeID
where A.ApplicationName IS NOT NULL and A.ApplicationName <> ''
group by COALESCE(MS.[FriendlyServerName], MS.[InstanceName])
order by [Avg Wait Time (s)] desc