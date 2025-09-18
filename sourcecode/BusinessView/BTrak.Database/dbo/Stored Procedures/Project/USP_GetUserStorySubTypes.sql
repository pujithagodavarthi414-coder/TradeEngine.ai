-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To Get the UserStorySubTypes By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStorySubTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStorySubTypes]
(
	@UserStorySubTypeId UNIQUEIDENTIFIER = NULL,
    @UserStorySubTypeName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortBy NVARCHAR(100) = NULL,
	@IsArchived BIT = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	       IF(@HavePermission = '1')
           BEGIN
			
		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		       
		       IF(@PageSize IS NULL)
		       SET @PageSize  = (SELECT COUNT(1) FROM UserStorySubType)

	           IF(@UserStorySubTypeId = '00000000-0000-0000-0000-000000000000') SET  @UserStorySubTypeId = NULL
		       
	           IF(@SearchText = '') SET  @SearchText = NULL
		       
		       IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		       
		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		       
		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Notification])
		       
		       IF(@PageNumber IS NULL) SET @PageNumber = 1
		       
		       SET @SearchText = '%' + @SearchText + '%'
		       
			    SELECT USST.Id AS UserStorySubTypeId,
			    	   USST.UserStorySubTypeName,				  
			    	   USST.CreatedByUserId,
			    	   USST.CreatedDateTime,
					   USST.UpdatedByUserId,
			    	   USST.UpdatedDateTime,
					   CASE WHEN USST.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
			    	   USST.InActiveDateTime,
					   USST.[TimeStamp],
					   TotalCount = COUNT(1) OVER()
			      FROM [dbo].[UserStorySubType]USST WITH (NOLOCK) 
			      WHERE USST.CompanyId = @CompanyId 					    
				        AND ((@UserStorySubTypeId IS NULL OR USST.Id = @UserStorySubTypeId ))
						AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
						 OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))	        
			    		AND (@UserStorySubTypeName IS NULL OR USST.UserStorySubTypeName = @UserStorySubTypeName)								
			    		AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),USST.CreatedDateTime) LIKE @SearchText)
						                         OR (CONVERT(NVARCHAR(250),USST.UserStorySubTypeName) LIKE @SearchText)
												  )											
			      ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
			    				CASE WHEN @SortBy = 'UserStorySubTypeName' THEN USST.UserStorySubTypeName							  
			    				     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,USST.CreatedDateTime) AS sql_variant)
			    				END
			    		  END ASC,
			    		  CASE WHEN @SortDirection = 'DESC' THEN
			    				CASE WHEN @SortBy = 'UserStorySubTypeName' THEN USST.UserStorySubTypeName							  
			    				     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,USST.CreatedDateTime) AS sql_variant)
			    				END
			    		  END DESC
		       
		       OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		       FETCH NEXT @PageSize Rows ONLY
      END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,10, 1)
	  
	  END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
