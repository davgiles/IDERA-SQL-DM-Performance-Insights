-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get TOP 1000 Application Wait Statistics by Instance
declare @TopN int = 1000

select top (@TopN)
	[SQL Instance] = MS.InstanceName,
	[App Name] = case when A.ApplicationName IS NULL then '(none)' else A.ApplicationName end,
	[Wait Type] = WT.WaitType,
	[Avg Waiting Tasks] = format(avg(WD.WaitingTasks),'N0'),
	[Avg Wait Time (s)] = format(avg(WD.WaitTimeInMilliseconds/1000),'N0'),
	[Max Wait Time (s)] = format(max(WD.MaxWaitTimeInMilliseconds/1000),'N0'),
	[Max Resource Wait Time (s)] = format(max(WD.ResourceWaitTimeInMilliseconds/1000),'N0')
from dbo.WaitStatistics WS (nolock)
JOIN dbo.WaitStatisticsDetails WD (nolock) ON WD.[WaitStatisticsID] = WS.[WaitStatisticsID]
JOIN dbo.MonitoredSQLServers MS (nolock) ON MS.SQLServerID = WS.SQLServerID
JOIN dbo.ApplicationNames A (nolock) ON WD.[WaitingTasks] = A.ApplicationNameID
JOIN dbo.WaitTypes WT (nolock) ON WD.WaitTypeID = WT.WaitTypeID
where A.ApplicationName IS NOT NULL and A.ApplicationName <> ''
group by MS.InstanceName, A.ApplicationName, WT.WaitType
order by [Avg Wait Time (s)] desc