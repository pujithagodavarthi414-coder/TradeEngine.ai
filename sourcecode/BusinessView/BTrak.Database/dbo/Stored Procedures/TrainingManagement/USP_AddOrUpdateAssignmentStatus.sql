-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-10 00:00:00.000'
-- Purpose      to update the assignment status
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_AddOrUpdateAssignmentStatus]
(
	@AssignmentId UNIQUEIDENTIFIER,
	@StatusId UNIQUEIDENTIFIER,
	@StatusGivenDate DATETIME2,
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

				DECLARE @AddValidity BIT = (SELECT TOP 1 AddsValidity FROM [AssignmentStatus] WHERE [Id] = @StatusId)

				IF(@AddValidity = 1)
				BEGIN
					DECLARE @Validity INT = (SELECT TOP 1 ValidityInMonths FROM TrainingCourse WHERE Id = (SELECT TOP 1 TrainingCourseId FROM TrainingAssignment WHERE Id = @AssignmentId))

					UPDATE TrainingAssignment SET 
						StatusId = @StatusId,
						ValidityEndDate = (SELECT DATEADD(month, @Validity, CreatedDateTime)),
						StatusGivenDate = @StatusGivenDate,
						UpdatedByUserId = @OperationsPerformedBy,
						UpdatedDateTime = GETUTCDATE()
						WHERE Id = @AssignmentId

					DECLARE @CreatedDateTime datetime2 = (SELECT TOP 1 CreatedDateTime FROM TrainingAssignment WHERE [Id] = @AssignmentId)

					INSERT INTO TrainingWorkflow (AssignmentId, StatusId, StatusGivenDate, CreatedByUserId, ValidityEndDate)
					VALUES (@AssignmentId, @StatusId, @StatusGivenDate, @OperationsPerformedBy, (SELECT DATEADD(month, @Validity, @CreatedDateTime)))
				END
				ELSE
				BEGIN
					UPDATE TrainingAssignment SET 
						StatusId = @StatusId,
						UpdatedByUserId = @OperationsPerformedBy,
						StatusGivenDate = @StatusGivenDate,
						UpdatedDateTime = GETUTCDATE(),
						ValidityEndDate = NULL
						WHERE Id = @AssignmentId

					INSERT INTO TrainingWorkflow (AssignmentId, StatusId, StatusGivenDate, CreatedByUserId)
					VALUES (@AssignmentId, @StatusId, @StatusGivenDate, @OperationsPerformedBy)
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