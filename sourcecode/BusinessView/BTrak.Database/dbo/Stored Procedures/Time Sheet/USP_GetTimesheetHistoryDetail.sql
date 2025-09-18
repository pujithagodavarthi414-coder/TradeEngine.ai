-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the Timesheet History Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTimesheetHistoryDetail] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTimesheetHistoryDetail]
(
	@UserId UNIQUEIDENTIFIER = NULL,
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

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
      IF (@HavePermission = '1')
      BEGIN

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

		  IF(@DateFrom IS NULL) SET  @DateFrom = CONVERT(DATE,GETDATE()) 

		  IF(@DateTo IS NULL) SET  @DateTo = CONVERT(DATE,GETDATE()) 

		  IF(@SortDirection IS NULL )
	       BEGIN
		   
	         	SET @SortDirection = 'DESC'
		   
	       END
	       
	       DECLARE @OrderByColumn NVARCHAR(250) 
		   
	       IF(@SortBy IS NULL)
	       BEGIN
		   
	        	SET @SortBy = 'EmployeeName'
		   
	       END
	       ELSE
	       BEGIN
		   
	       	    SET @SortBy = @SortBy
		   
	       END

		   SET @SearchText = '%'+ @SearchText+'%'

		   SELECT JSON_VALUE(AuditJSON,'$.UserId'),
		         JSON_VALUE(AuditJSON,'$.Description'),
		         JSON_VALUE(AuditJSON,'$.FeatureId'),
		         JSON_VALUE(AuditJSON,'$.UserStoryId'),
		         CONVERT(DATETIME2(7),JSON_VALUE(AuditJSON,'$.Date')),
                 U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
	             F.FeatureName,
	             CA.CreatedDateTime
           FROM [Audit] CA WITH (NOLOCK) JOIN [User] U ON U.Id = JSON_VALUE(AuditJSON,'$.UserId') 
		        LEFT JOIN Feature F ON F.Id = JSON_VALUE(AuditJSON,'$.FeatureId')
                LEFT JOIN UserStory US ON US.Id = JSON_VALUE(AuditJSON,'$.UserStoryId')
           WHERE ((CONVERT(DATE,JSON_VALUE(AuditJSON,'$.Date')) >= CONVERT(DATE,@DateFrom) 
		         AND CONVERT(DATE,JSON_VALUE(AuditJSON,'$.Date')) <= CONVERT(DATE,@DateTo)))
                 AND (U.Id = @UserId OR @UserId IS NULL) 
		   	     AND U.CompanyId = @CompanyId 
				 AND (@SearchText IS NULL 
				      OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
				      OR (FeatureName LIKE @SearchText)
                      OR (CA.CreatedDateTime LIKE @SearchText)	
				     )
          ORDER BY 
		        CASE WHEN @SortDirection = 'ASC' THEN
		             CASE WHEN @SortBy = 'EmployeeName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
		                  WHEN @SortBy = 'FeatureName' THEN FeatureName
		                  WHEN @SortBy = 'CreatedDateTime' THEN Cast(CA.CreatedDateTime as sql_variant)
		        	 END 
		        END ASC,
	            CASE WHEN @SortDirection = 'DESC' THEN
	                 CASE WHEN @SortBy = 'EmployeeName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
		                  WHEN @SortBy = 'FeatureName' THEN FeatureName
		                  WHEN @SortBy = 'CreatedDateTime' THEN Cast( CA.CreatedDateTime as sql_variant)
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