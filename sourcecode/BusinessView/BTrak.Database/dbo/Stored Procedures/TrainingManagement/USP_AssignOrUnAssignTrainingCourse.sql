-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-03 00:00:00.000'
-- Purpose      to assign or unassign training courses
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_AssignOrUnAssignTrainingCourse]
(
	@CourseIds NVARCHAR(MAX),
	@UserIds NVARCHAR(MAX),
	@Assign BIT,
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

				DECLARE @Courses TABLE
				(
					CourseId UNIQUEIDENTIFIER
				)

				DECLARE @Users TABLE
				(
					UserId UNIQUEIDENTIFIER
				)

				DECLARE @AssignmentIds TABLE
				(
					AssignmentId UNIQUEIDENTIFIER
				)

				DECLARE @CurrentDate DATETIME2 = GETUTCDATE()

				INSERT INTO @Courses
				SELECT * FROM UfnSplit(@CourseIds)
				
				INSERT INTO @Users
				SELECT * FROM UfnSplit(@UserIds)
				
				IF(@Assign = 1)
				BEGIN
					DECLARE @defaultStatusId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM AssignmentStatus WHERE @CompanyId = CompanyId AND IsDefaultStatus = 1)

					INSERT INTO TrainingAssignment (UserId, TrainingCourseId, CompanyId, CreatedByUserId, StatusId, CreatedDateTime)
					SELECT DISTINCT US.UserId, C.CourseId, @CompanyId, @OperationsPerformedBy, @defaultStatusId, @CurrentDate FROM @Users US
					CROSS APPLY @Courses C
					LEFT JOIN TrainingAssignment TA ON TA.UserId = US.UserId AND TA.TrainingCourseId = C.CourseId
					WHERE (TA.Id IS NULL OR TA.IsActive = 0)

					INSERT INTO @AssignmentIds
					SELECT Id FROM TrainingAssignment WHERE CreatedDateTime = @CurrentDate

					INSERT INTO TrainingWorkflow (AssignmentId, StatusId, CreatedByUserId)
					SELECT AssignmentId, @defaultStatusId, @OperationsPerformedBy FROM @AssignmentIds
				END
				ELSE
				BEGIN
					UPDATE TrainingAssignment SET IsActive = 0
					WHERE Id IN 
					(
						SELECT TA.Id FROM @Users US
						CROSS APPLY @Courses C
						LEFT JOIN TrainingAssignment TA ON TA.UserId = US.UserId AND TA.TrainingCourseId = C.CourseId
						WHERE TA.Id IS NOT NULL AND @CompanyId = TA.CompanyId
					)
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