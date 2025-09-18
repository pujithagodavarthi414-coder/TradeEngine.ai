-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Save or update the Employee Work Experience Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights ReservedUSP_UpsertEmployeeWork
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeWorkExperience] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', 
-- @FromDate = '2019-05-14', @PreviousCompany = 'JAM TECH' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393' , @DesignationId = '8e667960-30bb-401c-ba46-04855e8338af' ,@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeWorkExperience]
(
   @EmployeeWorkExperienceId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,   
   @PreviousCompany NVARCHAR(800) = NULL,
   @Comments NVARCHAR(800) = NULL,  
   @FromDate DATETIME = NULL,
   @ToDate DATETIME = NULL,
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

	    IF(@DesignationId = '00000000-0000-0000-0000-000000000000') SET @DesignationId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@FromDate = '') SET @FromDate = NULL

		IF(@PreviousCompany = '') SET @PreviousCompany = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@DesignationId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Designation')

		END
		ELSE IF(@FromDate IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'FromDate')

		END
		ELSE IF(CAST(@FromDate AS DATE) > CAST(@ToDate AS date))
		BEGIN

		RAISERROR('DateFromShouldNotBeGreaterThanDateTo',16, 2)
		
        END
		ELSE IF(@PreviousCompany IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PreviousCompany')

		END
		ELSE IF EXISTS(SELECT * FROM EmployeeWorkExperience WHERE EmployeeId = @EmployeeId AND InActiveDateTime IS NULL AND (@EmployeeWorkExperienceId IS NULL OR Id <> @EmployeeWorkExperienceId) AND ((@FromDate BETWEEN FromDate AND ToDate) OR (@ToDate BETWEEN FromDate AND ToDate))) 	
		BEGIN
		
		 RAISERROR('EmployeeWorkExperienceAlreadyExistedToThisDate',16, 2)

		END	
		ELSE 
		BEGIN

		DECLARE @EmployeeWorkExperienceIdCount INT = (SELECT COUNT(1) FROM EmployeeWorkExperience WHERE Id = @EmployeeWorkExperienceId )

		DECLARE @EmployeeWorkExperienceDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeWorkExperience WHERE EmployeeId = @EmployeeId AND DesignationId = @DesignationId AND Company = @PreviousCompany AND (Id <> @EmployeeWorkExperienceId OR @EmployeeWorkExperienceId IS NULL))

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																								 AND FeatureId = @FeatureId AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeWorkExperienceDetails',11,1)
		END

		ELSE IF(@EmployeeWorkExperienceIdCount = 0 AND @EmployeeWorkExperienceId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeWorkExperience')
		END

		ELSE IF(@EmployeeWorkExperienceDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeWorkExperienceId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeWorkExperience WHERE Id = @EmployeeWorkExperienceId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldDesignationId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldPreviousCompany NVARCHAR(800) = NULL
                    DECLARE @OldComments NVARCHAR(800) = NULL
                    DECLARE @OldFromDate DATETIME = NULL
                    DECLARE @OldToDate DATETIME = NULL
                    DECLARE @Inactive DATETIME = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL

					SELECT @OldDesignationId  = [DesignationId],
					       @OldPreviousCompany= [Company],
					       @OldComments       = [Comments],		
					       @OldFromDate       = [FromDate],
					       @OldToDate         = [ToDate],
						   @Inactive          = [InActiveDateTime]
						   FROM EmployeeWorkExperience WHERE EmployeeId = @EmployeeId AND Id = @EmployeeWorkExperienceId

				       
					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        IF(@EmployeeWorkExperienceId IS NULL)
					BEGIN

					SET @EmployeeWorkExperienceId = NEWID()

			        INSERT INTO [dbo].EmployeeWorkExperience(
			                    [Id],
			                    [EmployeeId],
								[DesignationId],
								[Company],
								[Comments],
								[FromDate],
								[ToDate],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
			             SELECT @EmployeeWorkExperienceId,
			                    @EmployeeId,
								@DesignationId,
								@PreviousCompany,
								@Comments,		
								@FromDate,
								@ToDate,						
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
			                   
						END
						ELSE
						BEGIN

						UPDATE [dbo].EmployeeWorkExperience
			                  SET [EmployeeId] = @EmployeeId,
								[DesignationId] = @DesignationId,
								[Company] = @PreviousCompany,
								[Comments] = @Comments,
								[FromDate] = @FromDate,
								[ToDate] = @ToDate,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy
			                    WHERE Id = @EmployeeWorkExperienceId

						END
						
						DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT Company FROM EmployeeWorkExperience WHERE Id = @EmployeeWorkExperienceId)

						SET @OldValue = (SELECT DesignationName FROM Designation WHERE Id = @OldDesignationId)
					    SET @NewValue = (SELECT DesignationName FROM Designation WHERE Id = @DesignationId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Work experience',
					    @FieldName = 'Designation',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldPreviousCompany,'') <> @PreviousCompany AND @PreviousCompany IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Work experience',
					    @FieldName = 'Company',@OldValue = @OldPreviousCompany,@NewValue = @PreviousCompany

						IF(ISNULL(@OldComments,'') <> @Comments AND @Comments IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Work experience',
					    @FieldName = 'Comments',@OldValue = @OldComments,@NewValue = @Comments

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldFromDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@FromDate,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Work experience',
					    @FieldName = 'From date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldToDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ToDate,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Work experience',
					    @FieldName = 'To date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
					    
						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Contact details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeWorkExperience WHERE Id = @EmployeeWorkExperienceId

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