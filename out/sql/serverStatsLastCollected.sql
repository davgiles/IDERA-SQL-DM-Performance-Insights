-- Copyright © 2018 IDERA, Inc. All rights reserved.

-- Get Last Collection Time
SELECT
    [Last Collection Time] =
		FORMAT(CONVERT(datetime,
						SWITCHOFFSET(CONVERT(datetimeoffset,
                        MAX(UTCCollectionDateTime)),
               DATENAME(TzOffset, SYSDATETIMEOFFSET()))),
		       'dddd, dd MMMM, yyyy - hh.mm tt (Local)', 'en-us')
FROM dbo.ServerStatistics

