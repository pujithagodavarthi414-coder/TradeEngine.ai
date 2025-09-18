-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-11 00:00:00.000'
-- Purpose      to update the expiry status of expired assignments
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_CheckAndUpdateExpiredAssignments]
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

				DECLARE @ExpiredAssignments TABLE
				(
					AssignmentId UNIQUEIDENTIFIER
				)

				INSERT INTO @ExpiredAssignments
				SELECT Id FROM TrainingAssignment 
				WHERE ValidityEndDate IS NOT NULL 
				AND CAST(StatusGivenDate AS DATE) > CAST(ValidityEndDate AS DATE)
				AND CompanyId = @CompanyId

				IF((SELECT COUNT(*) FROM @ExpiredAssignments) > 0)
				BEGIN
					DECLARE @ExpiryStatusId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM AssignmentStatus WHERE IsExpiryStatus = 1 AND CompanyId = @CompanyId)

					UPDATE TrainingAssignment 
						SET StatusId = @ExpiryStatusId,
						UpdatedDateTime = GETUTCDATE(),
						UpdatedByUserId = @OperationsPerformedBy
						WHERE Id IN (SELECT * FROM @ExpiredAssignments)

					INSERT INTO TrainingWorkflow (AssignmentId, StatusId, StatusGivenDate, CreatedByUserId)
					SELECT AssignmentId, @ExpiryStatusId, GETUTCDATE(), @OperationsPerformedBy FROM @ExpiredAssignments
				END
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