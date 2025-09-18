-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-19 00:00:00.000'
-- Purpose      to fetch training workflow for a particular assignment based on assignement id
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetAssignmentWorkflow]
(
	@AssignmentId UNIQUEIDENTIFIER,
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

				SELECT 
					TW.Id,
					TW.AssignmentId,
					TW.StatusId,
					TW.StatusGivenDate,
					TW.CreatedDateTime,
					AST.IsExpiryStatus
				FROM TrainingWorkflow TW
				JOIN AssignmentStatus AST ON AST.Id = TW.StatusId
				WHERE AssignmentId = @AssignmentId
				ORDER BY CreatedDateTime DESC
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
GO