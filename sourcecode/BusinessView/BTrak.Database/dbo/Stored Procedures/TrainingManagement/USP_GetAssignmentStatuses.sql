-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-10 00:00:00.000'
-- Purpose      to fetch training assignmentstatuses based on company
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetAssignmentStatuses]
(
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
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT TOP 1 CompanyId FROM [User] WHERE [Id] = @OperationsPerformedBy)

				SELECT * FROM AssignmentStatus WHERE CompanyId = @CompanyId AND IsActive = 1 ORDER BY StatusName
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