-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get TimeZone By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeZones] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetTimeZones]
(
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @TimeZoneName NVARCHAR(150) = NULL,
  @IsArchived BIT = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
          IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET  @TimeZoneId = NULL
          IF(@TimeZoneName = '') SET  @TimeZoneName = NULL
          SELECT TZ.Id AS TimeZoneId,
				 TZ.TimeZoneName + ' (' + TZ.TimeZone + ')' TimeZoneTitle,
                 TZ.TimeZoneName,
				 TZ.TimeZoneOffset,
				 TZ.TimeZone,
				 TZ.TimeZoneAbbreviation,
				 TZ.CountryCode,
				 TZ.CountryName,
                 TZ.CreatedDateTime,
                 CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                 TZ.[TimeStamp],
                 TotalCount = COUNT(1) OVER()
          FROM  [dbo].[TimeZone] TZ WITH (NOLOCK)
          WHERE (@TimeZoneId IS NULL OR TZ.Id = @TimeZoneId)
		    AND TZ.TimeZone IS NOT NULL AND TZ.TimeZoneAbbreviation IS NOT NULL AND TZ.TimeZoneOffset IS NOT NULL
            AND (@TimeZoneName IS NULL OR TZ.TimeZoneName = @TimeZoneName)
            AND ((@IsArchived = 0 AND InActiveDateTime IS NULL)
                          OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
          ORDER BY TimeZoneName ASC     
              
     END TRY  
     BEGIN CATCH 
        
          THROW
    END CATCH
END
GO