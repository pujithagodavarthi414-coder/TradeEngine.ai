CREATE PROCEDURE [dbo].[USP_GetUserStoryLinkTypes]
(
  @UserStoryLinkTypeId UNIQUEIDENTIFIER = NULL,
  @UserStoryLinkTypeName NVARCHAR(150) = NULL,
  @IsArchived BIT = 0,
  @OperationsPerformedBy UNIQUEIDENTIFIER
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
				
				IF(@UserStoryLinkTypeId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryLinkTypeId = NULL
				
				IF(@UserStoryLinkTypeName = '') SET  @UserStoryLinkTypeName = NULL

				SELECT LUT.Id AS LinkUserStoryTypeId,
				       LUT.LinkUserStoryTypeName,
					   IsArchived = CASE WHEN LUT.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				       LUT.CreatedByUserId,
					   LUT.CreatedDateTime,
					   LUT.UpdatedByUserId,
					   LUT.UpdatedDateTime,
					   LUT.[TimeStamp],
				       TotalCount = COUNT(1) OVER()
				FROM  [dbo].[LinkUserStoryType] LUT WITH (NOLOCK)
				WHERE LUT.CompanyId = @CompanyId
				      AND (@UserStoryLinkTypeId IS NULL OR LUT.Id = @UserStoryLinkTypeId)
				      AND (@UserStoryLinkTypeName IS NULL OR LUT.LinkUserStoryTypeName = @UserStoryLinkTypeName)
				      AND (@IsArchived IS NULL OR (@IsArchived = 0 AND LUT.InActiveDateTime IS NULL)
						  OR (@IsArchived = 1 AND LUT.InActiveDateTime IS NOT NULL))
						
				ORDER BY LinkUserStoryTypeName ASC 	 
    
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