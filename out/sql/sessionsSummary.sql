-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Session Summary using hourly interval
declare
	@ServerID int,
	@UTCStart DateTime,
	@UTCEnd DateTime,
	@UTCOffset int,
	@Interval tinyint = 2

-- @Interval - Granularity of calculation:
--	0 - Minutes
--	1 - Hours
--	2 - Days
--	3 - Months
--	4 - Years

select
	[SQL Instance] = m.InstanceName,
	[Avg Client Computers] =
		format(avg(s1.[ClientComputers] * TimeDeltaInSeconds) / nullif(avg(case when s1.[ClientComputers] is not null
					then TimeDeltaInSeconds else 0 end),0),'N0'),
	[Avg User Processes] =
		format(avg(s1.[UserProcesses] * TimeDeltaInSeconds) / nullif(avg(case when s1.[UserProcesses] is not null
					then TimeDeltaInSeconds else 0 end),0),'N0'),
	[Avg Logins] =
		format(avg(convert(float,s1.[Logins])) / nullif((avg(convert(float,case when s1.[Logins] is not null
					then TimeDeltaInSeconds else 0 end))/60),0),'N0'),
	[Avg Transactions] =
		format(avg(convert(float,s1.[Transactions])) / nullif((avg(convert(float,case when s1.[Transactions] is not null
					then TimeDeltaInSeconds else 0 end))/60),0),'N0'),
	[Avg Oldest Open Transactions (min)] = format(avg(s1.[OldestOpenTransactionsInMinutes]),'N0')
from
	dbo.MonitoredSQLServers m (nolock)
	left join dbo.ServerStatistics s1 (nolock) on m.[SQLServerID] = s1.[SQLServerID]
group by
	[InstanceName]
	-- Always group by year at the least
	,datepart(yy, dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime]))
	-- Group by all intervals greater than or equal to the selected interval
	,case when @Interval <= 3 then datepart(mm,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) else datepart(yy,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) end
	,case when @Interval <= 2 then datepart(dd,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) else datepart(yy,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) end
	,case when @Interval <= 1 then datepart(hh,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) else datepart(yy,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) end
	,case when @Interval =  0 then datepart(mi,dateadd(mi, @UTCOffset, s1.[UTCCollectionDateTime])) end