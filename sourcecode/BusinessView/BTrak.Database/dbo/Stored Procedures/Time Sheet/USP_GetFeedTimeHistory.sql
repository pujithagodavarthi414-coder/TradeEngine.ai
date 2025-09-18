-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-17 00:00:00.000'
-- Purpose      To Get the FeedTimeHistory By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetFeedTimeHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@DateFrom='2019-07-17 00:00:00.000',@DateTo='2019-07-20 00:00:00.000'

CREATE PROCEDURE  [dbo].[USP_GetFeedTimeHistory]  
(
    @UserId UNIQUEIDENTIFIER = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo  DATETIME = NULL,
	@PageNumber INT = 1,
    @PageSize INT = 10,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@SortDirection NVARCHAR(50) = NULL,
    @SortBy NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
       IF (@HavePermission = '1')
       BEGIN

      IF(@SortBy IS NULL) SET @SortBy = 'UpdatedDateTime'
      IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	     
      SELECT  TH.NewValue AS PunchTime,
              TH.FieldName,
              TH.CreatedDateTime,
               ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS UserName,
			   TotalCount = COUNT(1) OVER() 
              FROM [TimeSheetHistory]TH LEFT JOIN [TimeSheet]TS ON  TS.Id = TH.TimeSheetId 
                                        LEFT JOIN [UserBreak]UB ON UB.Id = TH.UserBreakId 
                                        INNER JOIN [User] U ON (U.Id = TS.UserId OR U.Id = UB.UserId) 
              WHERE U.CompanyId = @CompanyId
                   AND (@DateFrom IS NULL OR CONVERT(DATE,NewValue) >= CONVERT(DATE,@DateFrom))
                   AND (@DateTo IS NULL OR CONVERT(DATE,NewValue) <= CONVERT(DATE, @DateTo))        
                   AND (@UserId IS NULL OR TS.UserId = @UserId OR UB.UserId = @UserId)
             
			 ORDER BY 
			          CASE WHEN @SortDirection = 'ASC' THEN
                         CASE WHEN(@SortBy = 'Description') THEN CAST(TH.NewValue AS sql_variant)
                              WHEN(@SortBy = 'UpdatedDateTime') THEN CAST(TH.CreatedDateTime AS sql_variant)
                          END
                      END ASC,
                      CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                         CASE WHEN(@SortBy = 'Description') THEN CAST(TH.NewValue AS sql_variant)
                              WHEN(@SortBy = 'UpdatedDateTime') THEN CAST(TH.CreatedDateTime AS sql_variant)
							  --WHEN @SortBy IS NULL THEN TH.NewValue
                          END
                      END DESC
			    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		        
                FETCH NEXT @PageSize ROWS ONLY
		
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
GO