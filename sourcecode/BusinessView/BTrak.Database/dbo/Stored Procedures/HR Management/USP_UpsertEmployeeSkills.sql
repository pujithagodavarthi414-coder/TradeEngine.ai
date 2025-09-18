-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Save or update the Skills
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeSkills] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,
-- @EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393', @SkillId = '1448D1B9-80C1-42C1-B008-05B09D55CB9C',
-- @DateFrom = '2019-05-16',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeSkills]
(
   @EmployeeSkillId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @SkillId UNIQUEIDENTIFIER = NULL,
   @YearsOfExperience FLOAT = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @Comments NVARCHAR(800) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@EmployeeSkillId = '00000000-0000-0000-0000-000000000000') SET @EmployeeSkillId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
		
		IF(@DateFrom = '') SET @DateFrom = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@SkillId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'EmployeeSkill')

		END
		ELSE IF(@DateFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DateFrom')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeSkillIdCount INT = (SELECT COUNT(1) FROM EmployeeSkill WHERE Id = @EmployeeSkillId)

		DECLARE @EmployeeSkillDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeSkill WHERE EmployeeId = @EmployeeId AND SkillId = @SkillId AND (Id <> @EmployeeSkillId OR @EmployeeSkillId IS NULL) AND InactiveDateTime IS  NULL)

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeSkillsDetails',11,1)
		END

		ELSE IF(@EmployeeSkillIdCount = 0 AND @EmployeeSkillId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeSkillDetails')
		END

		IF(@EmployeeSkillDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeSkillId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeSkill WHERE Id = @EmployeeSkillId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					DECLARE @OldSkillId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldYearsOfExperience INT = NULL
                    DECLARE @OldDateFrom DATETIME = NULL
                    DECLARE @OldDateTo DATETIME = NULL
                    DECLARE @OldComments NVARCHAR(800) = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					SELECT @OldSkillId           = 	[SkillId],
					       @OldYearsOfExperience = 	[YearsOfExperience],
					       @OldDateFrom          =  [DateFrom],
					       @OldDateTo            = 	[DateTo],
					       @OldComments          = 	[Comments],
						   @Inactive             = 	[InActiveDateTime]
						   FROM EmployeeSkill WHERE Id = @EmployeeSkillId

			        IF(@EmployeeSkillId IS NULL)
					BEGIN

					SET @EmployeeSkillId = NEWID()

			        INSERT INTO [dbo].EmployeeSkill(
			                    [Id],
			                    [EmployeeId],
								[SkillId],
								[YearsOfExperience],
								[DateFrom],
								[DateTo],
								[Comments],
								[InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeSkillId,
			                    @EmployeeId,
								@SkillId,
								@YearsOfExperience,
								@DateFrom, 
								@DateTo,
								@Comments,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy

						END
						ELSE
						BEGIN

						UPDATE [dbo].EmployeeSkill
			                 SET[EmployeeId] = @EmployeeId,
								[SkillId] = @SkillId,
								[YearsOfExperience] = @YearsOfExperience,
								[DateFrom] = @DateFrom,
								[DateTo] = @DateTo,
								[Comments] = @Comments,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy
							WHERE Id = @EmployeeSkillId

						END
			       
						DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT SkillName FROM Skill WHERE Id = @SkillId)

						SET @OldValue = (SELECT SkillName FROM Skill WHERE Id = @OldSkillId)
					    SET @NewValue = (SELECT SkillName FROM Skill WHERE Id = @SkillId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Skill',
					    @FieldName = 'Skill',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						--SET @OldValue =  CONVERT(NVARCHAR(40),@OldDateFrom,20)
					 --   SET @NewValue =  CONVERT(NVARCHAR(40),@DateFrom,20)
					    
					 --   IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					 --   EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Skill',
					 --   @FieldName = 'Date from',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						--SET @OldValue =  CONVERT(NVARCHAR(40),@OldDateTo,20)
					 --   SET @NewValue =  CONVERT(NVARCHAR(40),@DateTo,20)
					    
					 --   IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					 --   EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Skill',
					 --   @FieldName = 'Date to',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldYearsOfExperience)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@YearsOfExperience)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Skill',
					    @FieldName = 'Years of experience',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(@OldComments <> @Comments AND @Comments IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Skill',
					    @FieldName = 'Comments',@OldValue = @Comments,@NewValue = @Comments,@RecordTitle = @RecordTitle
						
						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeSkill WHERE Id = @EmployeeSkillId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END	
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO