-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-18 00:00:00.000'
-- Purpose      To Save or update the Employee MemberShip Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertEmployeeMemberships] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393', @MembershipId = 'A3AB385D-5BF5-4178-8461-C3B938AF6A8F'
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeMemberships]
(
   @EmployeeMemberShipId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @MembershipId UNIQUEIDENTIFIER = NULL,
   @SubscriptionId UNIQUEIDENTIFIER = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @SubscriptionAmount DECIMAL(18,5) = NULL,
   @CommenceDate DATETIME = NULL,
   @RenewalDate DATETIME = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @NameOfTheCertificate NVARCHAR(50) = NULL,
   @IssueCertifyingAuthority NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    IF(@MembershipId = '00000000-0000-0000-0000-000000000000') SET @MembershipId = NULL
		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
	    IF(@EmployeeId IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'Employee')
		END
		ELSE IF(@MembershipId IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'MemberShip')
		END
		ELSE IF(@NameOfTheCertificate IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'NameOfTheCertificate')
		END
		ELSE IF(@IssueCertifyingAuthority IS NULL)
		BEGIN
			RAISERROR(50011,16, 2, 'IssueCertifyingAuthority')
		END
		ELSE
		BEGIN
		DECLARE @EmployeeMemberShipDetailIdCount INT = (SELECT COUNT(1) FROM EmployeeMemberShip WHERE Id = @EmployeeMemberShipId)
		DECLARE @EmployeeMemberShipDuplicateCount INT = (SELECT COUNT(1) FROM EmployeeMemberShip WHERE EmployeeId = @EmployeeId AND MemberShipId = @MembershipId AND (Id <> @EmployeeMemberShipId OR @EmployeeMemberShipId IS NULL) AND InActiveDateTime IS NULL)
		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id=@EmployeeId AND InActiveDateTime IS NULL)
		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'
		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL)
		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeMembershipDetails',11,1)
		END
		ELSE IF(@EmployeeMemberShipDetailIdCount = 0 AND @EmployeeMemberShipId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'EmployeeMemberShipDetails')
		END
		ELSE IF(@EmployeeMemberShipDuplicateCount > 0)
		BEGIN
			RAISERROR('EmployeeMembershipWithSameDetailsAlreadyExists',11,1)
		END
		ELSE
		BEGIN
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF (@HavePermission = '1')
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @EmployeeMemberShipId IS NULL
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM EmployeeMemberShip WHERE Id = @EmployeeMemberShipId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @OldMembershipId UNIQUEIDENTIFIER = NULL
					DECLARE @OldSubscriptionId UNIQUEIDENTIFIER = NULL
					DECLARE @OldCurrencyId UNIQUEIDENTIFIER = NULL
					DECLARE @OldSubscriptionAmount DECIMAL(18,5) = NULL
					DECLARE @OldCommenceDate DATETIME = NULL
					DECLARE @OldRenewalDate DATETIME = NULL
					DECLARE @OldIsArchived BIT = NULL
					DECLARE @OldNameOfTheCertificate NVARCHAR(50) = NULL
					DECLARE @OldIssueCertifyingAuthority NVARCHAR(50) = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
					
					SELECT @OldMembershipId             = [MembershipId],
					       @OldSubscriptionId           = [SubscriptionId],
					       @OldSubscriptionAmount       = [SubscriptionAmount],
					       @OldIssueCertifyingAuthority = [IssueCertifyingAuthority],
					       @OldNameOfTheCertificate     = [NameOfTheCertificate], 
					       @OldCurrencyId               = [CurrencyId],
					       @OldCommenceDate             = [CommenceDate],
					       @OldRenewalDate              = [RenewalDate],
						   @Inactive           	        = [InActiveDateTime]
						   FROM EmployeeMembership WHERE Id = @EmployeeMemberShipId

				 IF(@EmployeeMemberShipId IS NULL)
				 BEGIN

				 SET @EmployeeMemberShipId = NEWID()
				 INSERT INTO [dbo].EmployeeMemberShip(
			                    [Id],
			                    [EmployeeId],
								[MembershipId],
								[SubscriptionId],
								[SubscriptionAmount],
								[IssueCertifyingAuthority],
								[NameOfTheCertificate],
								[CurrencyId],
								[CommenceDate],
								[RenewalDate],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId])
			             SELECT @EmployeeMemberShipId,
			                    @EmployeeId,
								@MembershipId,
								@SubscriptionId,
								@SubscriptionAmount,
								@IssueCertifyingAuthority,
								@NameOfTheCertificate,
								@CurrencyId,
								@CommenceDate,
								@RenewalDate,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy

				END
				ELSE
				BEGIN

					UPDATE [dbo].EmployeeMemberShip
						SET [EmployeeId]				     =     @EmployeeId,
							[MembershipId]					 =    @MembershipId,
							[SubscriptionId]				 =    @SubscriptionId,
							[SubscriptionAmount]			 =    @SubscriptionAmount,
							[IssueCertifyingAuthority]		 =    @IssueCertifyingAuthority,
							[NameOfTheCertificate]			 =    @NameOfTheCertificate,
							[CurrencyId]					 =    @CurrencyId,
							[CommenceDate]					 =    @CommenceDate,
							[RenewalDate]					 =    @RenewalDate,
			                [InActiveDateTime]				 =     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                [UpdatedDateTime]				 =     @Currentdate,
			                [UpdatedByUserId]				 =     @OperationsPerformedBy
							WHERE Id = @EmployeeMemberShipId

				END

					UPDATE Reminder SET [InActiveDateTime] = CASE WHEN @IsArchived =  1 THEN @Currentdate ELSE NULL END
                         WHERE ReferenceId = @EmployeeMemberShipId
					
					DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT NameOfTheCertificate FROM EmployeeMembership WHERE Id = @EmployeeMemberShipId)

					SET @OldValue = (SELECT CurrencyName  FROM Currency WHERE Id = @OldCurrencyId)
					SET @NewValue = (SELECT CurrencyName  FROM Currency WHERE Id = @CurrencyId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Currency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT SubscriptionPaidByName  FROM SubscriptionPaidBy WHERE Id = @OldSubscriptionId)
					SET @NewValue = (SELECT SubscriptionPaidByName  FROM SubscriptionPaidBy WHERE Id = @SubscriptionId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Subscription',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = (SELECT MemberShipType  FROM MemberShip WHERE Id = @OldMembershipId)
					SET @NewValue = (SELECT MemberShipType  FROM MemberShip WHERE Id = @MembershipId)
					
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Membership',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldIssueCertifyingAuthority,'') <> @IssueCertifyingAuthority AND @IssueCertifyingAuthority IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Issue Certifying Authority',@OldValue = @OldIssueCertifyingAuthority,@NewValue = @IssueCertifyingAuthority,@RecordTitle = @RecordTitle

					IF(ISNULL(@OldNameOfTheCertificate,'') <> @NameOfTheCertificate AND @IssueCertifyingAuthority IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Name Of The Certificate',@OldValue = @OldNameOfTheCertificate,@NewValue = @NameOfTheCertificate,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldRenewalDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@RenewalDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Renewal date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldCommenceDate,20)
					SET @NewValue =  CONVERT(NVARCHAR(40),@CommenceDate,20)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Commence date',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue =  CONVERT(NVARCHAR(40),@OldSubscriptionAmount)
					SET @NewValue =  CONVERT(NVARCHAR(40),@SubscriptionAmount)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Subscription amount',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

					SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					    
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Membership details',
					@FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].EmployeeMemberShip WHERE Id = @EmployeeMemberShipId
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
