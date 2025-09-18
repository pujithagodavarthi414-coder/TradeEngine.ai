----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Update Client by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClient] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @Email = 'yahoo@snovasys.com', @CompanyName = 'test', @FirstName = 'first', @LastName = 'second', @Password='1234566',
-- @IsActive=1, @MobileNo='9989821523',@IsActiveOnMobile=1, @ClientId = '58771444-6F39-44BA-A8A8-F7465802BBE9', @TimeStamp = 0x00000000000807B9
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClient]
(
   @ClientId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @Note NVARCHAR(800) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @FirstName NVARCHAR(800) = NULL,
   @LastName NVARCHAR(800) = NULL,
   @MobileNo NVARCHAR(800) = NULL,
   @ProfileImage NVARCHAR(800) = NULL,
   @CompanyName NVARCHAR(800) = NULL,
   @Email NVARCHAR(250) = NULL,
   @Password NVARCHAR(250) = NULL,
   @IsPasswordForceReset BIT = NULL,
   @IsActive BIT = 1,
   @IsAdmin BIT = NULL,
   @IsActiveOnMobile BIT = 1,
   @SiteAddress NVARCHAR(250) = NULL,
   @CompanyWebsite NVARCHAR(250) = NULL,
   @IndustryId UNIQUEIDENTIFIER = NULL,
   @MainUseCaseId UNIQUEIDENTIFIER = NULL,
   @TeamSize INT = NULL,   
   @PhoneNumber NVARCHAR(100) = NULL,
   @CountryId UNIQUEIDENTIFIER = NULL,
   @TimeZoneId UNIQUEIDENTIFIER = NULL,
   @CurrencyId UNIQUEIDENTIFIER = NULL,
   @NumberFormatId UNIQUEIDENTIFIER = NULL,
   @DateFormatId UNIQUEIDENTIFIER = NULL,
   @TimeFormatId UNIQUEIDENTIFIER = NULL,
   @ClientTypeId UNIQUEIDENTIFIER = NULL,
   @ClientKycId UNIQUEIDENTIFIER = NULL,
   @RoleIds NVARCHAR(MAX)  = NULL,
   @ContractTemplateIds NVARCHAR(MAX)  = NULL,
   @LeadFormId UNIQUEIDENTIFIER = NULL,
   @LeadFormData NVARCHAR(MAX) = NULL,
   @LeadFormJson NVARCHAR(MAX) = NULL,
   @CreditLimit Decimal(18,2) = NULL,
   @ContarctFormId UNIQUEIDENTIFIER = NULL,
   @ContractFromJson NVARCHAR(MAX) = NULL,
   @ContractFromData NVARCHAR(MAX) = NULL,
   @IsForLeadSubmission BIT = NULL,
   @NewClient BIT = 0,
   @AvailableCreditLimit Decimal(18,2) = NULL,
   @AddressLine1 NVARCHAR(500) = NULL,
   @AddressLine2 NVARCHAR(500) = NULL,
   @PanNumber NVARCHAR(50) = NULL,
   @BusinessEmail NVARCHAR(50) = NULL,
   @BusinessNumber NVARCHAR(50) = NULL,
   @EximCode NVARCHAR(50) = NULL,
   @GstNumber NVARCHAR(50) = NULL,
   @BusinesCountryCode NVARCHAR(50) = NULL,
   @PhNoCountryCode NVARCHAR(50) = NULL,
   @KycExpiryDays INT = NULL,
   @LegalEntityId UNIQUEIDENTIFIER = NULL,
   @IsKycSybmissionMailSent BIT = NULL,
   @IsVerified BIT = NULL,
   @UserAuthenticationId UNIQUEIDENTIFIER = NULL,
   @BrokerageValue Decimal(18,3) = NULL

)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            IF (@HavePermission = '1')
            BEGIN
			IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL
			IF (@UserId IS NULL) SET @UserId = (SELECT U.Id FROM [User] U JOIN Client C ON C.UserId = U.Id AND C.Id = @ClientId)

		    IF(@FirstName = '') SET @FirstName = NULL
		  
	        IF(@FirstName IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'FirstName')
		  
		    END
			ELSE IF(@LastName = '') SET @LastName = NULL
		  
	        IF(@LastName IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'LastName')
		  
		    END
			
			ELSE IF(@Email = '') SET @Email = NULL
		  
	        IF(@Email IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'Email')
		  
		    END
			ELSE IF(@Email <> '' AND @Email NOT LIKE '_%@__%.__%')
			BEGIN

				RAISERROR ('Email should be in correct format',11, 1)

			END

			DECLARE @ClientIdCount INT = (SELECT COUNT(1) FROM Client WHERE Id = @ClientId) 

			DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND (@UserId IS NULL OR Id <> @UserId) AND CompanyId = @CompanyId)
				 				           				        	  
		    IF(@ClientIdCount = 0 AND @ClientId IS NOT NULL)
		    BEGIN

				RAISERROR(50002,16, 2,'Client')
		         
		   END
		   ELSE IF(@UserNameCount > 0)
           BEGIN

                RAISERROR(50010,16,1,'Client')
				
           END			 
		   ELSE                   
				
				DECLARE @IsLatest BIT = (CASE WHEN @ClientId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Client WHERE Id = @ClientId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                IF(@IsLatest = 1)
                BEGIN									

                    DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM Client WHERE Id = @ClientId)

                    DECLARE @Currentdate DATETIME = GETDATE()
					
					DECLARE @NewCompanyId UNIQUEIDENTIFIER = NEWID()                                                                                                     

					DECLARE @OldCompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldFirstName NVARCHAR(250) = (SELECT FirstName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldSurName NVARCHAR(250) = (SELECT SurName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldUserName NVARCHAR(250) = (SELECT UserName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldMobileNo NVARCHAR(250) = (SELECT MobileNo FROM [User] U WHERE U.Id = @UserId)
                    DECLARE @OldTimeZoneId UNIQUEIDENTIFIER = (SELECT TimeZoneId FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldProfileImage NVARCHAR(Max) = (SELECT ProfileImage FROM [User] U WHERE U.Id = @UserId)

					DECLARE @NewValue NVARCHAR (250)

					DECLARE @FieldName NVARCHAR (250)

					DECLARE @Description NVARCHAR (1000)

				    DECLARE @RoleId uniqueidentifier =(SELECT Id FROM Role WHERE RoleName = 'Client' and CompanyId = @CompanyId)

					IF(@ClientId IS NULL)
					BEGIN

						EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @FieldName = 'Insert', @OperationsPerformedBy = @OperationsPerformedBy

					END
					ELSE
					BEGIN

						IF(@CompanyId <> @OldCompanyId)
						BEGIN

							SET @FieldName = 'Company Name'

							SET @Description = 'COMPANYNAMEUPDATED'

							EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldCompanyId, @NewValue = @CompanyId, @FieldName = @FieldName,
							@Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END
						IF(@TimeZoneId <> @OldTimeZoneId)
						BEGIN

							SET @FieldName = 'TimeZone'

							SET @Description = 'TIMEZONEUPDATED'
							DECLARE @OldTimeZoneName NVARCHAR(250)=(SELECT TimeZoneName FROM TimeZone WHERE Id=@OldTimeZoneId)
							DECLARE @NewZoneName NVARCHAR(250)=(SELECT TimeZoneName FROM TimeZone WHERE Id=@OldTimeZoneId)
							EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldTimeZoneName, @NewValue = @NewZoneName, @FieldName = @FieldName,
							@Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy

						END

						IF(@FirstName <> @OldFirstName)
                        BEGIN

                            SET @FieldName = 'First Name'

                            SET @Description = 'FIRSTNAMEUPDATED'

                            EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldFirstName, @NewValue = @FirstName, @FieldName = @FieldName,
                            @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy
                        END

                        IF(@LastName <> @OldSurName)
                        BEGIN

                            SET @FieldName = 'Sur Name'

                            SET @Description = 'SURNAMEUPDATED'

                            EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldSurName, @NewValue = @LastName, @FieldName = @FieldName,
                            @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy
                        END

                        IF(@Email <> @OldUserName)
                        BEGIN

                            SET @FieldName = 'User Name'

                            SET @Description = 'USERNAMEUPDATED'

                            EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldUserName, @NewValue = @Email, @FieldName = @FieldName,
                            @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy
                        END

                        IF(@MobileNo <> @OldMobileNo)
                        BEGIN

                            SET @FieldName = 'Mobile number'

                            SET @Description = 'MOBILENOUPDATED'

                            EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldMobileNo, @NewValue = @MobileNo, @FieldName = @FieldName,
                            @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy
                        END

                        IF(@ProfileImage <> @OldProfileImage)
                        BEGIN

                            SET @FieldName = 'Profile Image'

                            SET @Description = 'PROFILEIMAGEUPDATED'

                            EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @OldValue = @OldProfileImage, @NewValue = @ProfileImage, @FieldName = @FieldName,
                            @Description = @Description, @OperationsPerformedBy = @OperationsPerformedBy
                        END

					END

					IF(@UserId IS NULL)
					 BEGIN

					 --SET @IsActive = CASE When  (SELECT ClientTypeName FROM ClientType WHERE Id=@ClientTypeId ) = 'Buyer' or (select ClientTypeName from ClientType where Id=@ClientTypeId ) = 'Supplier' Then 0 Else 1 END

					 SET @UserId = NEWID()

					INSERT INTO [dbo].[User](
                                      [Id],
                                      [CompanyId],
                                      [FirstName],
                                      [SurName],
                                      [UserName],
									  [Password],
                                      [IsActive],
									  [IsExternal],
                                      [IsAdmin],
                                      [MobileNo],
                                      [ProfileImage],
                                      [RegisteredDateTime],
                                      [IsActiveOnMobile],
									  [InActiveDateTime],                                 
                                      [CreatedDateTime],
                                      [CreatedByUserId],
									  TimeZoneId,
									  UserAuthenticationId
									  )
                               SELECT @UserId,
                                      @CompanyId,
                                      @FirstName,
                                      @LastName,
									  @Email,
                                      ISNULL(@Password,''),
                                      ISNULL(@IsActive,0),
									  1,
                                      ISNULL(@IsAdmin,0),
                                      ISNULL(@MobileNo,''),
                                      ISNULL(@ProfileImage,''),
                                      ISNULL(@Currentdate,0),
                                      ISNULL(@IsActiveOnMobile,0),
                                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                      @Currentdate,
                                      @OperationsPerformedBy,
									  @TimeZoneId,
									  @UserAuthenticationId
							
							INSERT INTO UserRole
										(Id
										,UserId
										,RoleId
										,CreatedByUserId
										,CreatedDateTime)
										SELECT NEWID()
										       ,@UserId
											   ,[Value]
											   ,@OperationsPerformedBy
											   ,@Currentdate
											   FROM [dbo].[Ufn_StringSplit](@RoleIds,',')

						END
						ELSE
						BEGIN
						UPDATE [User]
						   SET [CompanyId] = @CompanyId,
							   [FirstName] = @FirstName,
							   [SurName] = @LastName,
							   [UserName] = @Email,
							   [Password] = ISNULL(@Password,0),
							   [IsActive] = CASE WHEN @IsVerified = 1 THEN 1 ELSE ISNULL(@IsActive,0) END,
							   [IsAdmin] = ISNULL(@IsAdmin,0),
							   [MobileNo] = ISNULL(@MobileNo,''),
							   [ProfileImage] = ISNULL(@ProfileImage,''),
							   [RegisteredDateTime] = ISNULL(@Currentdate,0), 	
						       [IsActiveOnMobile] = ISNULL(@IsActiveOnMobile,0),
							   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy,
							   TimeZoneId=@TimeZoneId
							   WHERE Id = @UserId

							   DELETE FROM [UserRole] WHERE UserId = @UserId
							   INSERT INTO UserRole
										  (Id
										  ,UserId
										  ,RoleId
										  ,CreatedByUserId
										  ,CreatedDateTime)
										  SELECT NEWID()
										        ,@UserId
											    ,[Value]
											    ,@OperationsPerformedBy
											    ,@Currentdate
											    FROM [dbo].[Ufn_StringSplit](@RoleIds,',')
						END	

					IF(@ClientId IS NULL)
					 BEGIN
					 SET @ClientId = NEWID()
										SET @NewClient =  1
                    INSERT INTO [dbo].[Client](
									  [Id],
									  [UserId],
									  [CompanyId],
									  [CompanyName],
									  [CompanyWebsite],
									  [BranchId],
									  [Note],
									  [ClientTypeId],
									  [CreatedDateTime],
									  [CreatedByUserId],     
									  [InActiveDateTime],
									  [ClientKycId],
									  [CreditLimit],
									  [AvailableCreditLimit],
									  [AddressLine1],
									  [AddressLine2],
									  PanNumber,
									  BusinessEmail,
									  BusinessNumber,
									  EximCode,
									  GstNumber,
									  [LegalEntityId],
									  [KycExpiryDays],
									  [IsKycSybmissionMailSent],
									  [KycFormStatusId],
									  [ContractTemplateIds],
									  [BrokerageValue],
									  [BusinesCountryCode],
									  [PhoneCountryCode]

									  )
							   SELECT @ClientId,
									  @UserId,
									  @CompanyId,
									  @CompanyName,
									  @CompanyWebsite,
									  @BranchId,
									  @Note,
									  @ClientTypeId,
									  @Currentdate,
									  @OperationsPerformedBy, 
									  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  @ClientKycId,
									  @CreditLimit,
									  @CreditLimit,
									  @AddressLine1,
									  @AddressLine2,
									  @PanNumber,
									  @BusinessEmail,
									  @BusinessNumber,
									  @EximCode,
									  @GstNumber,
									  @LegalEntityId,
									  @KycExpiryDays,
									  @IsKycSybmissionMailSent,
									  (SELECT Id FROM [ClientKycFormStatus] WHERE [StatusName]='Pending' AND CompanyId = @CompanyId),
									  @ContractTemplateIds,
									  @BrokerageValue,
									  @BusinesCountryCode,
									  @PhNoCountryCode
						EXEC [dbo].[USP_UpsertClientEmailTemplates] @OperationsPerformedBy = @OperationsPerformedBy, @ClientId = @ClientId
					
					  END
						ELSE
						BEGIN
						DECLARE @OldCreditLimt Decimal(18,2) = (SELECT CreditLimit FROM Client WHERE Id=@ClientId)
						DECLARE @OldAvailableCreditLimit Decimal(18,2) = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)
						UPDATE [Client]
						   SET [UserId] = @UserId,
							   [CompanyId] = @CompanyId,
                               [CompanyName] = @CompanyName,
							   [CompanyWebsite] = @CompanyWebsite,
                               [BranchId] = @BranchId,
							   [Note] = @Note,
							   [ClientTypeId] = @ClientTypeId,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy,
							   [ClientKycId] =@ClientKycId,
							   [CreditLimit] = @CreditLimit,
							   [AvailableCreditLimit] = @AvailableCreditLimit,
							   [AddressLine1]	=	@AddressLine1,
							   [AddressLine2]	=	@AddressLine2,
							   PanNumber		=	@PanNumber,
							   BusinessEmail	=	@BusinessEmail,
							   BusinessNumber	=	@BusinessNumber,
							   EximCode			=	@EximCode,
							   GstNumber        =   @GstNumber,
							   LegalEntityId    =   @LegalEntityId,
							   KycExpiryDays    =   @KycExpiryDays,
							   IsKycSybmissionMailSent = @IsKycSybmissionMailSent,
							   [BrokerageValue] = @BrokerageValue,
							   [BusinesCountryCode] = @BusinesCountryCode,
							   [PhoneCountryCode] =	   @PhNoCountryCode,
							   KycFormStatusId  =   CASE WHEN @IsVerified = 1 THEN 
																(SELECT Id FROM [ClientKycFormStatus] WHERE [StatusName]='Verified' AND CompanyId = @CompanyId) 
																ELSE 
																(SELECT KycFormStatusId FROM [Client] WHERE Id = @ClientId)  
																END
							   WHERE Id = @ClientId
						END
					IF(@ClientId IS NULL OR @CreditLimit = (SELECT CreditLimit FROM [Client] WHERE Id = @ClientId))
					BEGIN
						INSERT INTO ClientCreditLimitHistory(
													  Id,
													  ClientId,
													  [Description],
													  OldCreditLimit,
													  NewCreditLimit,
													  OldAvailableCreditLimit,
													  NewAvailableCreditLimit,
                                                      Amount,
                                                      CreatedByUserId,
                                                      CreatedDateTime,
													  CompanyId
													 )
											  SELECT  NEWID(),
                                                      @ClientId,
                                                      CASE WHEN @NewClient = 1 THEN 'Credit-Credit Limit Added' ELSE 'Credit-Credit Limit Changed' END,
                                                      CASE WHEN @NewClient = 1 THEN 0 ELSE @OldCreditLimt END,
                                                      (SELECT CreditLimit FROM Client WHERE Id=@ClientId),
                                                      CASE WHEN @NewClient = 1 THEN 0 ELSE @OldAvailableCreditLimit END,
                                                      (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId),
                                                      CASE WHEN @NewClient = 1 THEN @CreditLimit ELSE @CreditLimit END,
                                                      @OperationsPerformedBy,
													  GETDATE(),
													  @CompanyId
					END
					IF (@ContarctFormId IS NOT NULL AND @ClientId IS NOT NULL AND @ContractFromJson IS NOT NULL AND @ContractFromData IS NOT NULL)
					BEGIN
						INSERT INTO [dbo].[ClientContractSubmission](
									  [Id],
								      [ClientId],
									  [LeadFormId],
									  [FormJson],
									  [FormData],
									  [CreatedDateTime],
									  [CreatedByUserId],
									  [CompanyId]
								      )
							   SELECT NEWID(),
								      @ClientId,
									  @ContarctFormId,
									  @ContractFromJson,
									  @ContractFromData,
									  @Currentdate,
									  @OperationsPerformedBy,
									  @CompanyId
					END

					IF(@NewClient = 1 OR @IsVerified = 1)
					BEGIN
						INSERT INTO [dbo].[ClientKycFormHistory](
									[Id],
									[UserId],
									[ClientId],
									[OldValue],
									[NewValue],
									[Description],
									[CreatedByUserId],
									[CreatedDateTime],
									[CompanyId]
									)
							 SELECT NEWID(),
								    @OperationsPerformedBy,
									@ClientId,
									CASE WHEN @IsVerified <> 1 THEN  NULL ELSE (SELECT KycStatusName FROM [ClientKycFormStatus] WHERE [StatusName]='Submitted' AND CompanyId = @CompanyId) END,
									CASE WHEN @IsVerified <> 1 THEN (SELECT KycStatusName FROM [ClientKycFormStatus] WHERE [StatusName]='Pending' AND CompanyId = @CompanyId) 
																 ELSE (SELECT KycStatusName FROM [ClientKycFormStatus] WHERE [StatusName]='Verified' AND CompanyId = @CompanyId) 
																 END,
									CASE WHEN @IsVerified <> 1 THEN  'KYC form assigned' ELSE 'KYC form verified' END,
									@OperationsPerformedBy,
									@Currentdate,
									@CompanyId
					END

						IF(@IsForLeadSubmission IS NULL OR @isForLeadSubmission = 0)
						BEGIN
                         SELECT Id FROM [dbo].[Client] WHERE Id = @ClientId	
						END
						--IF(@IsForLeadSubmission = 1)
						--BEGIN
      --                   SELECT @FormId
						--END

				END
				ELSE
				BEGIN

					RAISERROR(50008,11,1)
			
			END
			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
