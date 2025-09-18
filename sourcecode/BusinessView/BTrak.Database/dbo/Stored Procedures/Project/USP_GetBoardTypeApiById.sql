-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-23 00:00:00.000'
-- Purpose      To Get BoardTypeApi By BoardTypeApiId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBoardTypeApiById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeApiId='11E595C6-35F5-48BB-A541-C54057123CBA'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBoardTypeApiById]
(
  @BoardTypeApiId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

     SET NOCOUNT ON

     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT BA.Id AS BoardTypeApiId,
		         BA.ApiName,
		         BA.ApiUrl,
				 BA.CreatedByUserId,
				 BA.CreatedDateTime,
				 BA.UpdatedByUserId,
				 BA.UpdatedDateTime
		  FROM [dbo].[BoardTypeApi] BA WITH (NOLOCK)
		  WHERE (BA.Id = @BoardTypeApiId)

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