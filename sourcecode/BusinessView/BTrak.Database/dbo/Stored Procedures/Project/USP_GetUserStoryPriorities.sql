-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Get the UserStoryPriorities Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetUserStoryPriorities] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PriorityName='Medium'

CREATE PROCEDURE [dbo].[USP_GetUserStoryPriorities]
(
   @UserStoryPriorityId  UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @PriorityName NVARCHAR(250)=NULL,
   @IsArchived BIT = 0
)
AS
BEGIN

	SET NOCOUNT ON

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

    IF(@HavePermission = '1')
    BEGIN

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 IF(@UserStoryPriorityId = '00000000-0000-0000-0000-000000000000') SET @UserStoryPriorityId = NULL

	 IF(@PriorityName = '') SET @PriorityName = NULL
	
	      SELECT USP.Id UserStoryPriorityId,
				 USP.CompanyId,
				 USP.PriorityName,
				 USP.CreatedDateTime, 
				 USP.CreatedByUserId,
				 USP.[TimeStamp],	
				 CASE WHEN USP.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT(1) OVER()
		   FROM  [UserStoryPriority]USP WITH (NOLOCK)
		   WHERE USP.CompanyId = @CompanyId 
		         AND (@UserStoryPriorityId IS NULL OR USP.Id = @UserStoryPriorityId)  
				 AND (@PriorityName IS NULL OR USP.PriorityName = @PriorityName) 
				 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND USP.InActiveDateTime IS NULL)
				  OR (@IsArchived = 1 AND USP.InActiveDateTime IS NOT NULL))

		  ORDER BY USP.CreatedDateTime


	   END
       ELSE
	   BEGIN

            RAISERROR(@HavePermission,11,1)

	   END
	 END TRY
	 BEGIN CATCH 
		
		THROW

	END CATCH
END
