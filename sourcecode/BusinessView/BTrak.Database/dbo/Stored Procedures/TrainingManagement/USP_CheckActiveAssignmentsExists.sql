-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-15 00:00:00.000'
-- Purpose      to check wether the active assignments for the archive training course exists or not
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_CheckActiveAssignmentsExists]
(
	@CourseId UNIQUEIDENTIFIER,
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

				SELECT COUNT(*) 
				FROM TrainingAssignment
				WHERE TrainingCourseId = @CourseId
					AND @CompanyId = CompanyId
					AND IsActive = 1

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