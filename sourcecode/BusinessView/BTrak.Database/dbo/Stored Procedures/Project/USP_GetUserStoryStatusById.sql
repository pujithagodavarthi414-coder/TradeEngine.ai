-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the UserStoryStatus By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetUserStoryStatusById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryStatusId='D348204E-A7D4-40C1-A5AD-7A667D8F4216'

CREATE PROCEDURE [dbo].[USP_GetUserStoryStatusById]
(
  @UserStoryStatusId  UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	    SELECT USS.Id AS UserStoryStatusId,
		       USS.[Status] AS UserStoryStatusName,
			   USS.StatusHexValue AS UserStoryStatusColor,
			   USS.IsArchived,
			   USS.ArchivedDateTime,
			   USS.CompanyId,
			   USS.CreatedByUserId,
			   USS.CreatedDateTime,
			   USS.UpdatedByUserId,
			   USS.UpdatedDateTime
        FROM [dbo].[UserStoryStatus] USS WITH (NOLOCK)
	    WHERE USS.Id = @UserStoryStatusId
			  AND (USS.CompanyId = @CompanyId)
		     
	END TRY  
	BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END
GO