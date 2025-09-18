-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get More TimeViewedAudit By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetMoreTimeViewedAudit_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetMoreTimeViewedAudit_New]
(
    @UserId UNIQUEIDENTIFIER = NULL,
    @FeatureId UNIQUEIDENTIFIER = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @SearchText VARCHAR(500) = NULL,
    @SortBy NVARCHAR(250) = NULL,
    @SortDirection NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON 
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @CompanyId UNIQUEIDENTIFIER =  NULL

	IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
          BEGIN
              SET @OperationsPerformedBy = NULL
          END
	      
	      IF (@OperationsPerformedBy IS NOT NULL)
          BEGIN

              SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          END
			
          IF(@UserId = '00000000-0000-0000-0000-000000000000')
          BEGIN

             SET @UserId = NULL

          END
          
          IF(@FeatureId = '00000000-0000-0000-0000-000000000000')
          BEGIN

              SET @FeatureId = NULL

          END
                	      	     
	      IF(@SortDirection IS NULL )
	      BEGIN
	      
	       	  SET @SortDirection = 'ASC'
	      
	      END
	      ELSE
	      
	      IF(@SortBy IS NULL)
	      BEGIN
	      
	      	   SET @SortBy = 'FeatureName'
	      
	      END
	      ELSE
	      BEGIN
	      
	      	   SET @SortBy = @SortBy
	      
	      END

		  SET @SearchText = '%'+ @SearchText +'%'

          SELECT JSON_VALUE(AuditJSON,'$.FeatureId') AS FeatureId,
		         F.FeatureName,
				 COUNT(*) AS ViewedCount
          FROM Audit CA 
	           JOIN [User] U ON U.Id = JSON_VALUE(AuditJSON,'$.UserId') 
	           JOIN Feature F ON F.Id = JSON_VALUE(AuditJSON,'$.FeatureId')
          WHERE (CONVERT(DATE,CA.CreatedDateTime) >= CONVERT(DATE,@DateFrom) 
	           AND CONVERT(DATE,CA.CreatedDateTime) <= CONVERT(DATE,@DateTo))
               AND (U.Id = @UserId OR @UserId IS NULL) 
	      	   AND (F.Id = @FeatureId OR @FeatureId IS NULL) 
	      	   AND IsOldAudit IS NULL 
	      	   AND (U.CompanyId = @CompanyId)
			   AND (@SearchText IS NULL 
		            OR FeatureName LIKE @SearchText
		            OR CA.CreatedDateTime LIKE @SearchText)
	      GROUP BY  JSON_VALUE(AuditJSON,'$.FeatureId'),F.FeatureName
		  ORDER BY 
		   CASE WHEN @SortDirection = 'ASC' THEN
		        CASE WHEN @SortBy = 'FeatureName' THEN F.FeatureName
					 WHEN @SortBy = 'ViewedCount' THEN Cast(COUNT(*) as sql_variant) 
		        END 
		   END ASC,
	       CASE WHEN @SortDirection = 'DESC' THEN
	            CASE WHEN @SortBy = 'FeatureName' THEN F.FeatureName
					 WHEN @SortBy = 'ViewedCount' THEN Cast(COUNT(*) as sql_variant) 
		        END 
	 	   END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
		       
         FETCH NEXT @PageSize ROWS ONLY

    END TRY 
	BEGIN CATCH 
		
		EXEC [dbo].[USP_GetErrorInformation]

	END CATCH
END



