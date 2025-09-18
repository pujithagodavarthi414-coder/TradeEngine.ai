-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Save or update the Employee Reporting Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertEmployeeReportTo] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = '3B362452-FFC5-4E98-A908-484947777DD4',@ReportToEmployeeId = 'CB016341-84DB-4DCE-ADBA-69E1F8D3A2C4' 

CREATE PROCEDURE [dbo].[USP_UpsertEmployeeReportTo]
(
   @EmployeeReportToId UNIQUEIDENTIFIER = NULL,
   @ReportToEmployeeId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @ReportingMethodId UNIQUEIDENTIFIER = NULL,  
   @ActiveFrom DATETIME = NULL,
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

	    IF(@ReportToEmployeeId = '00000000-0000-0000-0000-000000000000') SET @ReportToEmployeeId = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

	    IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@ReportToEmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ReportingToEmployee')

		END		
		ELSE IF (@EmployeeId = @ReportToEmployeeId)
		BEGIN

			RAISERROR('SelfReportingIsNotApplicable',16,2)

		END
		ELSE 
		BEGIN

		DECLARE @ReportToUserId UNIQUEIDENTIFIER = (SELECT  E.UserId FROM Employee E WHERE  E.Id = @ReportToEmployeeId)

		DECLARE @EmployeeReportingToIdCount INT = (SELECT COUNT(1) FROM EmployeeReportTo WHERE Id = @EmployeeReportToId)

		DECLARE @EmployeeReportingToDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeReportTo WHERE EmployeeId = @EmployeeId AND ReportToEmployeeId = @ReportToEmployeeId AND (Id  <> @EmployeeReportToId OR @EmployeeReportToId IS NULL)  AND InActiveDateTime IS NULL)

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @ChildCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportedMembers](@UserId,@CompanyId) REP WHERE REP.ChildId = @ReportToUserId)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId  AND InActiveDateTime IS NULL)

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeReportDetails',11,1)
		END

		ELSE IF(@EmployeeReportingToIdCount = 0 AND @EmployeeReportToId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeReportingTo')
		END

		ELSE IF(@EmployeeReportingToDuplicateCount > 0)
		BEGIN
			RAISERROR(50012,16, 1)
		END
		ELSE IF(@ChildCount > 0)
		BEGIN

			RAISERROR('TheReportToEmployeeIsAReportingEmployeeOfThisEmployee',16,1)

		END
		ELSE IF(@EmployeeId = @EmployeeReportToId)
		BEGIN
			RAISERROR(50013,16, 1)
		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeReportToId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeReportTo WHERE Id = @EmployeeReportToId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
					
					DECLARE @OldReportToEmployeeId UNIQUEIDENTIFIER = NULL
					DECLARE @OldEmployeeId UNIQUEIDENTIFIER = NULL
					DECLARE @OldReportingMethodId UNIQUEIDENTIFIER = NULL
					DECLARE @OldActiveFrom DATETIME = NULL
					DECLARE @OldComments NVARCHAR(800) = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					DECLARE @Currentdate DATETIME = GETDATE()
					
					SELECT @OldReportToEmployeeId = [ReportToEmployeeId],
					       @OldReportingMethodId  = [ReportingMethodId],
					       @OldComments           = [OtherText],
						   @Inactive              = [InActiveDateTime],
						   @OldActiveFrom         = ActiveFrom
						   FROM EmployeeReportTo WHERE Id = @EmployeeReportToId

			       
				   IF(@EmployeeReportToId IS NULL)
				   BEGIN

				   SET @EmployeeReportToId = NEWID()

			        INSERT INTO [dbo].EmployeeReportTo(
			                    [Id],
			                    [EmployeeId],
								[ReportToEmployeeId],
								[ReportingMethodId],
								[OtherText],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								[ActiveFrom],
								[ActiveTo]
								)
			             SELECT @EmployeeReportToId,
			                    @EmployeeId,
								@ReportToEmployeeId,
								@ReportingMethodId,
								@Comments,								
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								ISNULL(@ActiveFrom,@CurrentDate),
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

						END
						ELSE
						BEGIN

						--DECLARE @ActiveFrom DATETIME = (SELECT ActiveFrom FROM EmployeeReportTo WHERE Id = @EmployeeReportToId  AND InActiveDateTime IS NULL)

						UPDATE [dbo].EmployeeReportTo
			                SET [EmployeeId] = @EmployeeId,
								[ReportToEmployeeId] = @ReportToEmployeeId,
								[ReportingMethodId] = @ReportingMethodId,
								[OtherText] = @Comments,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy,
								[ActiveFrom] = ISNULL(@ActiveFrom,@CurrentDate),
								[ActiveTo] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @EmployeeReportToId
						 
						END
						
						DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT U.FirstName + '' + ISNULL(U.SurName,'')  FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId = E.Id AND ER.Id = @EmployeeReportToId)

						SET @OldValue = (SELECT U.FirstName + '' + ISNULL(U.SurName,'')  FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE E.Id = @OldReportToEmployeeId)
					    SET @NewValue = (SELECT U.FirstName + '' + ISNULL(U.SurName,'')  FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE E.Id = @ReportToEmployeeId)
					    
					    IF(ISNULL(@OldValue ,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee reporting',
					    @FieldName = 'Report to employee',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue = (SELECT ReportingMethodType  FROM ReportingMethod WHERE Id = @OldReportingMethodId)
					    SET @NewValue = (SELECT ReportingMethodType  FROM ReportingMethod WHERE Id = @ReportingMethodId)
					    
					    IF(ISNULL(@OldValue ,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee reporting',
					    @FieldName = 'Reporting type',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						SET @OldValue =  CONVERT(NVARCHAR(40),@OldActiveFrom,20)
					    SET @NewValue =  CONVERT(NVARCHAR(40),@ActiveFrom,20)
					    
					    IF(ISNULL(@OldValue ,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee reporting',
					    @FieldName = 'Reporting from',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

						IF(@OldComments <> @Comments AND @Comments IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee reporting',
					    @FieldName = 'Comments',@OldValue = @OldComments,@NewValue = @Comments,@RecordTitle = @RecordTitle

						SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					    SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					    IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Employee reporting',
					    @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeReportTo WHERE Id = @EmployeeReportToId

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