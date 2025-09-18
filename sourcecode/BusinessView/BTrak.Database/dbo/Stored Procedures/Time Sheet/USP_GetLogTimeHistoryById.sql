-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-21 00:00:00.000'
-- Purpose      To Get THE LogTimeHistory By Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

-- EXEC [dbo].[USP_GetLogTimeHistoryById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetLogTimeHistoryById]
(
    @UserStoryLogTimeId   UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER 
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
	      
		  IF(@UserStoryLogTimeId = '00000000-0000-0000-0000-000000000000') SET @UserStoryLogTimeId = NULL
		  SELECT UST.Id AS UserStoryLogTimeId,
		         UST.UserStoryId,
				 UST.SpentTimeInMin/60 SpentTimeInMin,
				 UST.Comment,
				 UST.UserId,
				 UST.CreatedDateTime,
				 UST.CreatedByUserId,
				 UST.UpdatedDateTime,
				 UST.UpdatedByUserId
		  FROM  [dbo].[UserStorySpentTime]UST WITH (NOLOCK) JOIN [User]U WITH (NOLOCK) ON U.Id = UST.UserId
		  WHERE  (@UserStoryLogTimeId IS NULL OR UST.Id = @UserStoryLogTimeId) AND U.CompanyId = @CompanyId

	  END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
	 END TRY  
	 BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

	END CATCH
END                                                                                

