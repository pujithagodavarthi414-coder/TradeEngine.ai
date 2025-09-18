------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetUserStoryTypeDropDown] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryTypeDropDown](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsArchived BIT=NULL,
@SearchText NVARCHAR(50)=NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  		   
		    
		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')


				 SELECT Id AS UserStoryTypeId,	
						CompanyId,	
						UserStoryTypeName,
						CreatedDateTime,	
						CreatedByUserId,	
						UpdatedDateTime,	
						UpdatedByUserId,							
						ShortName,	
						IsBug,	
						IsUserStory,	
						[TimeStamp]		   		 
				FROM [dbo].[UserStoryType] 
				WHERE @CompanyId=CompanyId
				      AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (IsBug = 0 OR IsBug  IS NULl)))
				      AND (@IsArchived IS NULL OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
					  AND @SearchText IS NULL OR (UserStoryTypeName LIKE @SearchText)
					
			 ORDER BY UserStoryTypeName ASC

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