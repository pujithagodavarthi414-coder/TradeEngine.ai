-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-01 00:00:00.000'
-- Purpose      add or update training courses
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertTrainingCourse]
(
  @Id UNIQUEIDENTIFIER = NULL,
  @CourseName NVARCHAR (100),
  @CourseDescription NVARCHAR (800),
  @ValidityInMonths INT,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER = NULL
)
AS 
BEGIN    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
			BEGIN
				IF((SELECT COUNT(*) FROM TrainingCourse WHERE Id = @Id) > 0)
				BEGIN
					UPDATE TrainingCourse 
						SET CourseName = @CourseName,
						CourseDescription = @CourseDescription,
						ValidityInMonths = @ValidityInMonths,
						UpdatedDateTime = GETDATE()
					WHERE Id = @Id

					SELECT @Id
				END
				ELSE
				BEGIN
					SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] WHERE [Id] = @OperationsPerformedBy)
					DECLARE @newId UNIQUEIDENTIFIER = NEWID()

					INSERT INTO TrainingCourse (Id, CourseName, CourseDescription, ValidityInMonths, CompanyId, CreatedByUserId) 
					VALUES (@newId, @CourseName, @CourseDescription, @ValidityInMonths, @CompanyId, @OperationsPerformedBy)

					SELECT @newId
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