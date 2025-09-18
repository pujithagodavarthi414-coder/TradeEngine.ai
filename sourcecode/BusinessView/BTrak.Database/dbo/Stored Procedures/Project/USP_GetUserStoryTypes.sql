-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the UserStoryTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetUserStoryTypes]
(
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @UserStoryTypeName NVARCHAR(150) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL,
  @GenericStatusType BIT = NULL
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
		  DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

	       
		   IF(@UserStoryTypeId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryTypeId = NULL
	      
		  IF(@UserStoryTypeName = '') SET  @UserStoryTypeName = NULL
	       
		   SELECT UST.Id AS UserStoryTypeId,
		          UST.UserStoryTypeName,
				  UST.ShortName,
		          UST.CompanyId,
				  UST.IsBug,
				  UST.IsAction,
				  UST.IsUserStory,
				  UST.CreatedByUserId,
				  UST.CreatedDateTime,
		          UST.[TimeStamp],	
				  UST.IsApproveOrDecline,
				  UST.IsQaRequired,
				  UST.IsFillForm,
				  UST.IsLogTimeRequired,
				  UST.Color AS UserStoryTypeColor,
				  CASE WHEN UST.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
		   FROM  [dbo].[UserStoryType] UST WITH (NOLOCK)
		   WHERE UST.CompanyId = @CompanyId
		         AND ((@UserStoryTypeId IS NULL OR UST.Id = @UserStoryTypeId))
		         AND (@UserStoryTypeName IS NULL OR UST.UserStoryTypeName = @UserStoryTypeName)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND UST.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND UST.InActiveDateTime IS NULL))
				 AND (@GenericStatusType = 1 OR (@EnableBugBoards = 1 OR (@EnableBugBoards = 0 AND (UST.IsBug = 0 OR UST.IsBug  IS NULl))))
		   ORDER BY UserStoryTypeName ASC 	
	
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
GO