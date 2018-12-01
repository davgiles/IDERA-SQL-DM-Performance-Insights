-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Daily Query Count by Instances Detail
declare
	@StartDateTime datetime = null,
	@EndDateTime datetime = null,
	@UTCOffset int = 0,
	@Interval int = 2 -- Daily
	--@QueryText nvarchar(4000),
	--@ApplicationName nvarchar(4000),
	--@StatementType int,
	--@DatabaseName sysname,
	--@SignatureMode bit = 0,
	--@CaseInsensitive bit = 0

--@Interval
--	4 = Yearly
--  3 = Monthly
--  2 = Daily
--  1 = Hourly

if @UTCOffset is null
	set @UTCOffset = datediff(mi,getutcdate(),getdate())

select
	[SQL Instance] = ms.InstanceName,
	[# of Queries] = count(*),
	[First Start] = min(dateadd(mi,@UTCOffset,StatementUTCStartTime)),
	[Last End] = max(dateadd(mi,@UTCOffset,CompletionTime)),
	[Min Duration (s)] = format(min(DurationMilliseconds/1000),'N0'),
	[Max Duration (s)] = format(max(DurationMilliseconds/1000),'N0'),
	[Avg Duration (s)] = format(avg(DurationMilliseconds/1000),'N2'),
	[Sum Duration (s)] = format(sum(DurationMilliseconds/1000),'N0'),
	[Min CPU (s)] = format(min(CPUMilliseconds/1000),'N0'),
	[Max CPU (s)] = format(max(CPUMilliseconds/1000),'N0'),
	[Avg CPU (s)] = format(avg(CPUMilliseconds/1000),'N2'),
	[Sum CPU (s)] = format(sum(CPUMilliseconds/1000),'N0'),
	[Min Reads] = format(min(Reads),'N0'),
	[Max Reads] = format(max(Reads),'N0'),
	[Avg Reads] = format(avg(Reads),'N2'),
	[Sum Reads] = format(sum(Reads),'N0'),
	[Min Writes] = format(min(Writes),'N0'),
	[Max Writes] = format(max(Writes),'N0'),
	[Avg Writes] = format(avg(Writes),'N2'),
	[Sum Writes] = format(sum(Writes),'N0')
from
	dbo.QueryMonitorStatistics qm (nolock)
	left join dbo.MonitoredSQLServers ms WITH (NOLOCK) on ms.SQLServerID = qm.SQLServerID
group by
	ms.InstanceName,
	case when isnull(@Interval,5) <= 4 then datepart(yy, dateadd(mi, @UTCOffset, CompletionTime)) else 1 end
	,case when isnull(@Interval,5) <= 3 then datepart(mm,dateadd(mi, @UTCOffset, CompletionTime)) else datepart(yy,dateadd(mi, @UTCOffset, CompletionTime)) end
	,case when isnull(@Interval,5) <= 2 then datepart(dd,dateadd(mi, @UTCOffset, CompletionTime)) else datepart(yy,dateadd(mi, @UTCOffset, CompletionTime)) end
	,case when isnull(@Interval,5) <= 1 then datepart(hh,dateadd(mi, @UTCOffset, CompletionTime)) else datepart(yy,dateadd(mi, @UTCOffset, CompletionTime)) end
order by [# of Queries] desc
