-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Get the Holidays By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetHolidays] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@isWeekOff = 1

CREATE PROCEDURE [dbo].[USP_GetHolidays]
(
  @HolidayId UNIQUEIDENTIFIER = NULL,
  @Reason NVARCHAR(250) = NULL,
  @Date DATETIME = NULL,
  @CountryId   UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @IsWeekOff BIT = NULL,
  @PageNumber INT = 1,
  @PageSize INT = 100,
  @SortBy NVARCHAR(60) = NULL,
  @SortDirection NVARCHAR(10) = NULL,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	       	 
		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN
	
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
	        IF(@HolidayId = '00000000-0000-0000-0000-000000000000') SET  @HolidayId = NULL
		   
	        IF(@Reason = '') SET  @Reason = NULL

	           SELECT H.Id AS HolidayId,
		              H.Reason,
			    	  Archived = CASE WHEN H.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
		              H.CompanyId,
			    	  H.[Date],
			    	  H.CountryId,
					  C.CountryName,
					  H.DateFrom,
					  H.DateTo,
					  H.IsWeekOff,
					  H.WeekOffDays AS WeekOff,
					  H.BranchId,
					  B.BranchName,
		              H.CreatedByUserId,
			    	  H.CreatedDateTime,
			    	  H.[TimeStamp],
		              TotalCount = COUNT(1) OVER()

		       FROM  [dbo].[Holiday] H WITH (NOLOCK) INNER JOIN [Country]C ON C.Id = H.CountryId
			   LEFT JOIN  [dbo].[Branch] B ON B.Id = H.BranchId
		       WHERE H.CompanyId = @CompanyId 
		             AND (@HolidayId IS NULL OR H.Id = @HolidayId)
		             AND (@Reason IS NULL OR H.Reason = @Reason)
			    	 AND (@Date IS NULL OR H.[Date] = @Date)
					 AND (@BranchId IS NULL OR H.[BranchId] = @BranchId)
					 AND ((@IsWeekOff IS NULL AND H.[IsWeekOff] IS NULL) OR ISNULL(H.[IsWeekOff],0) = @IsWeekOff)
			    	 AND (@CountryId IS NULL OR H.CountryId   = @CountryId)
					 AND (@DateFrom IS NULL OR (@IsWeekOff = 1 AND (@DateFrom BETWEEN H.DateFrom AND H.DateTo)))
					 AND (@DateTo IS NULL OR (@IsWeekOff = 1 AND (@DateTo BETWEEN H.DateFrom AND H.DateTo)))
		             AND (@IsArchived IS NULL OR (@IsArchived = 0 AND H.InActiveDateTime IS NULL)
			    	 OR  (@IsArchived = 1 AND H.InActiveDateTime IS NOT NULL))
		       ORDER BY 
		        CASE WHEN (@SortDirection = 'ASC' OR @SortDirection IS NULL) THEN
		             CASE WHEN @SortBy = 'DateFrom' THEN CAST(H.DateFrom AS SQL_VARIANT)
		                  WHEN @SortBy = 'DateTo' THEN CAST(H.DateTo AS SQL_VARIANT)
		                  WHEN @SortBy = 'WeekOffDays' THEN H.WeekOffDays
		                  WHEN @SortBy = 'BranchName' THEN B.BranchName
		        	 END 
		        END ASC,
	            CASE WHEN @SortDirection = 'DESC' THEN
	                 CASE WHEN @SortBy = 'DateFrom' THEN CAST(H.DateFrom AS SQL_VARIANT)
		                  WHEN @SortBy = 'DateTo' THEN CAST(H.DateTo AS SQL_VARIANT)
		                  WHEN @SortBy = 'WeekOffDays' THEN H.WeekOffDays
		                  WHEN @SortBy = 'BranchName' THEN B.BranchName
		        	 END   
	 	        END DESC
	       END
	    ELSE
        BEGIN
                
		  RAISERROR (@HavePermission,11, 1)
                   
       END  
	   END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END