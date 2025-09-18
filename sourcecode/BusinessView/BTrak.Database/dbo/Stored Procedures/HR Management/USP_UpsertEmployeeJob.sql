-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Save or update the Employee Job
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeJob] 
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393'
--,@DesignationId = '2FBEB397-B990-4CB2-9B10-6309BFC271A6'
--,@EmploymentStatusId = 'CF140E45-B467-4CE2-A020-152669B919E1'
--,@JobCategoryId = '200F9900-BE1D-4738-854C-585F80A91C3C'
--,@JoinedDate = '2019-01-01'
--,@DepartmentId = '5F046717-E63D-4A27-A872-05EFDB6BB0A6'
--,@BranchId = '1210DB37-93F7-4347-9240-E978A270B707'
--,@ActiveFrom = '2018-01-01'
--,@ActiveTo = NULL
--,@IsArchived = 0
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeJob]
(
   @EmployeeJobId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @JobCategoryId UNIQUEIDENTIFIER = NULL,
   @JoinedDate DATETIME = NULL,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @NoticePeriodInMonths INT NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@DesignationId = '00000000-0000-0000-0000-000000000000') SET @DesignationId = NULL

		IF(@EmploymentStatusId = '00000000-0000-0000-0000-000000000000') SET @EmploymentStatusId = NULL

		IF(@JobCategoryId = '00000000-0000-0000-0000-000000000000') SET @JobCategoryId = NULL

		IF(@DepartmentId = '00000000-0000-0000-0000-000000000000') SET @DepartmentId = NULL

	    IF(@DesignationId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Designation')

		END
		ELSE IF(@EmploymentStatusId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'EmploymentStatus')

		END
		ELSE IF(@JobCategoryId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'JobCategory')

		END
		ELSE IF(@DepartmentId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Department')

		END
		ELSE 
		BEGIN

		DECLARE @EmployeeJobIdsCount INT = (SELECT COUNT(1) FROM [dbo].[Job] WHERE Id = @EmployeeJobId )

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																								 AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		
        DECLARE @OldEmployeeBranchId UNIQUEIDENTIFIER,@MainBranchId UNIQUEIDENTIFIER,@EmployeeBranchId UNIQUEIDENTIFIER  

        SELECT @EmployeeBranchId = Id, @OldEmployeeBranchId = BranchId FROM EmployeeBranch WHERE ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE()) AND EmployeeId = @EmployeeId 
        

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeJobDetails',11,1)
		END

		ELSE IF(@EmployeeJobIdsCount = 0 AND @EmployeeJobId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'EmployeeJob')

		END
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeJobId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM [dbo].[Job] WHERE Id = @EmployeeJobId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					DECLARE @OldDesignationId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldEmploymentStatusId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldJobCategoryId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldJoinedDate DATETIME = NULL
                    DECLARE @OldDepartmentId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldBranchId UNIQUEIDENTIFIER = NULL
                    DECLARE @OldActiveFrom DATETIME = NULL
                    DECLARE @OldActiveTo DATETIME = NULL
                    DECLARE @OldIsArchived BIT = NULL
                    DECLARE @OldTimeStamp TIMESTAMP = NULL
                    DECLARE @OldNoticePeriodInMonths INT = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					SELECT @OldDesignationId        = [DesignationId],
					       @OldEmploymentStatusId   = [EmploymentStatusId],
					       @OldJobCategoryId        = [JobCategoryId],
					       @OldJoinedDate           = [JoinedDate],
					       @OldDepartmentId         = [DepartmentId],
					       @OldBranchId             = [BranchId],
					       @OldActiveFrom           = [ActiveFrom],
					       @OldActiveTo             = [ActiveTo],
					       @OldNoticePeriodInMonths = [NoticePeriodInMonths],
						   @Inactive                = InActiveDateTime
					       FROM [Job] WHERE EmployeeId = @EmployeeId
					
					IF(@EmployeeJobId IS NULL)
					BEGIN

					SET @EmployeeJobId = NEWID()

					INSERT INTO [dbo].[Job](
								[Id],
								[DesignationId],
								[EmployeeId],
								[EmploymentStatusId],
								[JobCategoryId],
								[JoinedDate],
								[DepartmentId],
								[BranchId],
								[ActiveFrom],
								[ActiveTo],
								[CreatedDateTime],
								[CreatedByUserId],
								[InActiveDateTime],
								[NoticePeriodInMonths])
						 SELECT @EmployeeJobId,
								@DesignationId,
								@EmployeeId,
								@EmploymentStatusId,
								@JobCategoryId,
                                @JoinedDate,
								@DepartmentId,
								@BranchId,
								@ActiveFrom,
								@ActiveTo,
								@Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								@NoticePeriodInMonths

					END
					ELSE
					BEGIN

					UPDATE [dbo].[Job]
							SET [DesignationId] = @DesignationId,
								[EmployeeId] = @EmployeeId,
								[EmploymentStatusId] = @EmploymentStatusId,
								[JobCategoryId] = @JobCategoryId,
								[JoinedDate] = @JoinedDate,
								[DepartmentId] = @DepartmentId,
								[BranchId] = @BranchId,
								[ActiveFrom] = @ActiveFrom,
								[ActiveTo] = @ActiveTo,
								[UpdatedDateTime] = @Currentdate,
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								[NoticePeriodInMonths] = @NoticePeriodInMonths
						WHERE Id = @EmployeeJobId

					END

						 DECLARE @EmployeeBranchTimeStamp TIMESTAMP  = (SELECT [TimeStamp] FROM EmployeeBranch WHERE ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE()) AND EmployeeId = @EmployeeId )

                          IF(((@BranchId IS NOT NULL AND @OldEmployeeBranchId <> @BranchId) OR (@EmployeeBranchId IS NULL AND @BranchId IS NOT NULL)))
						  BEGIN

						    EXEC USP_UpsertEmployeeBranch @EmployeeBranchId = @EmployeeBranchId, @EmployeeId = @EmployeeId,
						    @OperationsPerformedBy= @OperationsPerformedBy,@BranchId = @BranchId,@IsArchived = @IsArchived,
						    @ActiveFrom = @Currentdate,@TimeStamp = @EmployeeBranchTimeStamp

						 END

					    SET @OldValue = (SELECT DesignationName FROM Designation WHERE Id = @OldDesignationId)
					    SET @NewValue = (SELECT DesignationName FROM Designation WHERE Id = @DesignationId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Designation',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT EmploymentStatusName FROM EmploymentStatus WHERE Id = @OldEmploymentStatusId)
					    SET @NewValue = (SELECT EmploymentStatusName FROM EmploymentStatus WHERE Id = @EmploymentStatusId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Employment status',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT JobCategoryType FROM JobCategory WHERE Id = @OldJobCategoryId)
					    SET @NewValue = (SELECT JobCategoryType FROM JobCategory WHERE Id = @JobCategoryId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Job category',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT DepartmentName FROM Department WHERE Id = @OldDepartmentId)
					    SET @NewValue = (SELECT DepartmentName FROM Department WHERE Id = @DepartmentId)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Department',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue = (SELECT BranchName FROM Branch WHERE Id = @OldBranchId)
					    SET @NewValue = (SELECT BranchName FROM Branch WHERE Id = @BranchId)
					    
						IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Branch',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveFrom,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveFrom,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Active from',@OldValue = @OldValue,@NewValue =@NewValue
					    
					    SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveTo,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveTo,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Active to',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue =  CONVERT(NVARCHAR(40),@OldJoinedDate,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@JoinedDate,20)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Joined date',@OldValue = @OldValue,@NewValue = @NewValue
					    
					    SET @OldValue =  CONVERT(NVARCHAR(40),@OldNoticePeriodInMonths)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@NoticePeriodInMonths)
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Notice priod in months',@OldValue = @OldValue,@NewValue = @NewValue

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					        
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Job details',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue

			        SELECT Id FROM [dbo].[Job] WHERE Id = @EmployeeJobId

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