-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Save or update the Employee Education Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertEmployeeEducationDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393', @EducationLevelId = 'BD5AC14C-F88F-4487-8142-1BF7A72CDBEA', @Institute = 'VVIT',@GpaOrScore = 75.6,@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeEducationDetails]
(
   @EmployeeEducationDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @EducationLevelId UNIQUEIDENTIFIER = NULL,
   @Institute NVARCHAR(800) = NULL,
   @MajorSpecialization NVARCHAR(800) = NULL,
   @GpaOrScore Decimal(10,3),
   @StartDate DATETIME = NULL,
   @EndDate DATETIME = NULL,
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

	    IF(@EducationLevelId = '00000000-0000-0000-0000-000000000000') SET @EducationLevelId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
		
		IF(@Institute = '') SET @Institute = NULL

		IF(@GpaOrScore = 0) SET @GpaOrScore = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@EducationLevelId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'EducationLevel')

		END
		ELSE IF(@Institute IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Institute')

		END
		ELSE IF(@GpaOrScore IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'GPAOrScore')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeEducationDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeEducation WHERE Id = @EmployeeEducationDetailId)

		DECLARE @EmployeeEducationDetailDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeEducation WHERE EmployeeId = @EmployeeId AND EducationLevelId = @EducationLevelId AND (Id <> @EmployeeEducationDetailId OR @EmployeeEducationDetailId IS NULL)  AND InActiveDateTime IS NULL)

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																								 AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeEducationDetails',11,1)
		END

		ELSE IF(@EmployeeEducationDetailIdCount = 0 AND @EmployeeEducationDetailId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeEducationDetails')
		END

		DECLARE @EmployeeEducationCountWithDates INT

		SET @EmployeeEducationCountWithDates = (SELECT COUNT(1) FROM EmployeeEducation WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeEducationDetailId OR @EmployeeEducationDetailId IS NULL) 
			                                   AND ((@StartDate BETWEEN [StartDate] AND [EndDate])
											        OR (@EndDate BETWEEN [StartDate] AND [EndDate])
											       )
											  )


		IF(@EmployeeEducationCountWithDates  > 0)
		BEGIN
			RAISERROR('EmployeeEducationDetailsIsAlreadyExistedForThisDate',16, 1)
		END

		IF(@EmployeeEducationDetailDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeEducationDetailId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeEducation WHERE Id = @EmployeeEducationDetailId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					DECLARE @OldEducationLevelId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldInstitute NVARCHAR(800) = NULL
                    DECLARE @OldMajorSpecialization NVARCHAR(800) = NULL
                    DECLARE @OldGpaOrScore Decimal(10,3)
                    DECLARE @OldStartDate DATETIME = NULL
                    DECLARE @OldEndDate DATETIME = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					SELECT @OldEducationLevelId   =  [EducationLevelId],
						   @OldInstitute          =  [Institute],
						   @OldMajorSpecialization=  [MajorSpecialization],
						   @OldGpaOrScore         =  [GPA_Score],
						   @OldStartDate          =  [StartDate],
						   @OldEndDate            =  [EndDate],
						   @Inactive              =  [InActiveDateTime]
						   FROM EmployeeEducation WHERE Id = @EmployeeEducationDetailId

			        IF(@EmployeeEducationDetailId IS NULL)
					BEGIN

					SET @EmployeeEducationDetailId = NEWID()

			        INSERT INTO [dbo].EmployeeEducation(
			                    [Id],
			                    [EmployeeId],
								[EducationLevelId],
								[Institute],
								[MajorSpecialization],
								[GPA_Score],
								[StartDate],
								[EndDate],
								[InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeEducationDetailId,
			                    @EmployeeId,
								@EducationLevelId,
								@Institute,
								@MajorSpecialization,
								@GpaOrScore, 
								@StartDate,
								@EndDate,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
			                    
						END
						ELSE
						BEGIN

						UPDATE [dbo].EmployeeEducation
			                  SET [EmployeeId] = @EmployeeId,
								  [EducationLevelId] = @EducationLevelId,
								  [Institute] = @Institute, 
								  [MajorSpecialization] = @MajorSpecialization,
								  [GPA_Score] = @GpaOrScore,
								  [StartDate] = @StartDate,
								  [EndDate] = @EndDate,
								  [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								  [UpdatedDateTime] = @Currentdate,
								  [UpdatedByUserId] = @OperationsPerformedBy
								WHERE Id = @EmployeeEducationDetailId

						END
			       
						DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT Institute FROM EmployeeEducation WHERE Id = @EmployeeEducationDetailId)

						SET @OldValue = (SELECT EducationLevel FROM EducationLevel WHERE Id = @EducationLevelId)
					    SET @NewValue = (SELECT EducationLevel FROM EducationLevel WHERE Id = @OldEducationLevelId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Education level',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldStartDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@StartDate,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Start date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldEndDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@EndDate,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'End date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(100),@OldGpaOrScore)
					    SET @NewValue =  CONVERT(NVARCHAR(100),@GpaOrScore)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Gpa score',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldMajorSpecialization,'') <> @MajorSpecialization AND @MajorSpecialization IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Major specialization',@OldValue = @OldMajorSpecialization,@NewValue = @MajorSpecialization,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldInstitute,'') <> @Institute AND @Institute IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Institute',@OldValue = @OldInstitute,@NewValue = @Institute,@RecordTitle = @RecordTitle

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeEducation WHERE Id = @EmployeeEducationDetailId

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