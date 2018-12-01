-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Query Duration by Instances Detail (Last 24 days)
declare
	@TopX INT = NULL,
	@NumDays INT = 24,
	@EndDate DATETIME,
	@StartDate DATETIME,
	@UTCOffset int = 0

SELECT @EndDate=dateadd(mi, @UTCOffset, MAX(qm.UTCCollectionDateTime)) FROM dbo.QueryMonitorStatistics qm (NOLOCK)
SELECT @StartDate= DATEADD(DD, -1*@NumDays, dateadd(mi, @UTCOffset, @EndDate))

if @UTCOffset is null
	set @UTCOffset = datediff(mi,getutcdate(),getdate())

IF @TopX IS NOT null AND @TopX > 0
	SET ROWCOUNT @TopX
ELSE
	SET ROWCOUNT 1000

SELECT
	[SQL Instance] = mss.InstanceName,
	[Database] = d.DatabaseName,
	[DateTime Collected] = dateadd(mi, @UTCOffset, qm.UTCCollectionDateTime),
	[Duration (ms)] = format(qm.DurationMilliseconds,'N0'),
	[CPU (ms)] = format(qm.CPUMilliseconds,'N0'),
	[Reads] = format(qm.Reads,'N0'),
	[Writes] = format(qm.Writes,'N0'),
	[SQL Text] = s.SQLSignature
FROM dbo.MonitoredSQLServers mss (nolock)
	JOIN dbo.SQLServerDatabaseNames d (nolock) ON d.SQLServerID = mss.SQLServerID
	JOIN dbo.QueryMonitorStatistics qm (nolock) ON qm.DatabaseID = d.DatabaseID
	JOIN dbo.AllSQLSignatures s (nolock) on qm.SQLSignatureID = s.SQLSignatureID
WHERE mss.Active = 1
	and dateadd(mi, @UTCOffset, qm.UTCCollectionDateTime) between @StartDate and @EndDate
ORDER BY [Duration (ms)] DESC