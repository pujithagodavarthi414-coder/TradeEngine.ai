-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the UserStoryReplanTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryReplanTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetUserStoryReplanTypes]
(
  @ReplanTypeName NVARCHAR(150) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = 0,
  @UserStoryReplanTypeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          IF (@HavePermission = '1')
          BEGIN
		  --DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	      IF(@ReplanTypeName = '') SET  @ReplanTypeName = NULL
	      SELECT USR.Id AS UserStoryReplanTypeId,
		         USR.ReplanTypeName,
		         --USR.CompanyId,
				 USR.CreatedByUserId,
				 USR.CreatedDateTime,
				 USR.UpdatedByUserId,
				 USR.UpdatedDateTime,
				 USR.[TimeStamp],	
				 CASE WHEN USR.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		         TotalCount = Count(1) OVER()
		  FROM  [dbo].[UserStoryReplanType] USR WITH (NOLOCK)
		  WHERE  (@UserStoryReplanTypeId IS NULL OR USR.Id = @UserStoryReplanTypeId)
		        AND (@ReplanTypeName IS NULL OR USR.ReplanTypeName = @ReplanTypeName)
		        AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
				OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))	 
		  ORDER BY ReplanTypeName ASC 	
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