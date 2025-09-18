-------------------------------------------------------------------------------
-- Author       Raghavendra Gududhuru
-- Created      '2019-09-05 00:00:00.000'
-- Purpose      To Get User Break Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from TimeSheet 
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserBreakDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @UserId='0B2921A9-E930-4013-9047-670B5352F308', @DateFrom='2019-08-29'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserBreakDetails]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @DateFrom DATETIME = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 

		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

		IF(@UserId IS NULL)
		BEGIN

			RAISERROR(50011,16, 2, 'EmployeeId')

		END

		ELSE IF(@DateFrom = '') SET @DateFrom = NULL

		IF(@DateFrom IS NULL)
		BEGIN

			RAISERROR(50011,16,2, 'DateFrom')

		END

		ELSE
		BEGIN
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN
		SELECT UB.BreakIn As DateFrom,
                         UB.BreakOut As DateTo,
						 UB.Id As BreakId,
						 UB.BreakInTimeZone AS BreakInTimeZoneId,
						 CASE WHEN UB.BreakInTimeZone IS NULL THEN NULL ELSE (SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = UB.BreakInTimeZone) END BreakInAbbreviation,
						 CASE WHEN UB.BreakOutTimeZone IS NULL THEN NULL ELSE (SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = UB.BreakOutTimeZone) END BreakOutAbbreviation,
						 CASE WHEN UB.BreakInTimeZone IS NULL THEN NULL ELSE (SELECT TimeZoneName FROM TimeZone WHERE Id = UB.BreakInTimeZone) END BreakInTimeZone,
						 CASE WHEN UB.BreakOutTimeZone IS NULL THEN NULL ELSE (SELECT TimeZoneName FROM TimeZone WHERE Id = UB.BreakOutTimeZone) END BreakOutTimeZone,
						 TotalCount = COUNT(1) OVER(),
                         CAST(DATEDIFF(MINUTE,BreakIn,BreakOut)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, BreakIn,BreakOut)%60 AS VARCHAR(50)) + 'min' BreakDifference
                  FROM [UserBreak] UB WITH (NOLOCK)
                  WHERE UserId = @UserId AND CONVERT(DATE,[Date]) = CONVERT(DATE,@DateFrom)
                  ORDER BY  CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'DateFrom')           THEN CAST(CONVERT(DATETIME,SWITCHOFFSET( UB.BreakIn ,'+00:00'),121) AS sql_variant)
                              WHEN(@SortBy = 'DateTo')             THEN CAST(CONVERT(DATETIME,SWITCHOFFSET( UB.BreakOut ,'+00:00'),121) AS sql_variant)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'DateFrom')           THEN CAST(CONVERT(DATETIME,SWITCHOFFSET( UB.BreakIn ,'+00:00'),121) AS sql_variant)
                              WHEN(@SortBy = 'DateTo')             THEN CAST(CONVERT(DATETIME,SWITCHOFFSET( UB.BreakOut ,'+00:00'),121) AS sql_variant)
                          END
                      END DESC
          OFFSET ((@PageNumber - 1) * @PageSize) ROWS
          FETCH NEXT @PageSize ROWS ONLY
		END

		 ELSE
        BEGIN
                
          RAISERROR (@HavePermission,11, 1)
                   
        END 
		END 
         END TRY  
      BEGIN CATCH 
        
            THROW
    END CATCH
END

