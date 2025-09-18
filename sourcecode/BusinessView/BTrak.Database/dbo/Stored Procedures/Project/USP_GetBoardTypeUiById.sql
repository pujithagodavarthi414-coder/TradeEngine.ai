-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get the BoardTypeUi By Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetBoardTypeUiById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeUiId='E3F924E2-9858-4B8D-BB30-16C64860BBD8'

CREATE PROCEDURE [dbo].[USP_GetBoardTypeUiById]
(
	@BoardTypeUiId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

     SET NOCOUNT ON

	 BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
         SELECT BTU.Id AS BoardTypeUiId,
		        BTU.BoardTypeUiName,
				BTU.BoardTypeUiView,
				--BTU.CompanyId,
			    BTU.CreatedByUserId,
				BTU.CreatedDateTime,
				BTU.UpdatedByUserId,
				BTU.UpdatedDateTime
	    FROM [BoardTypeUi] BTU WITH (NOLOCK)
	    WHERE BTU.[Id] = @BoardTypeUiId
			  --AND BTU.CompanyId = @CompanyId

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
