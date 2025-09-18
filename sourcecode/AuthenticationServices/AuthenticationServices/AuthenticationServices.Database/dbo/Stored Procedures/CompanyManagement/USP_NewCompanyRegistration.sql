CREATE PROCEDURE [dbo].[USP_NewCompanyRegistration]
(  
 @CompanyName NVARCHAR(250) = NULL,
 @SiteAddress NVARCHAR(250) = NULL,
 @WorkEmail NVARCHAR(250) = NULL,
 @TeamSize INT = NULL,
 @IsRemoteAccess BIT = NULL,
 @Password NVARCHAR(250) = NULL,
 @IndustryId UNIQUEIDENTIFIER = NULL,
 @MainUseCaseId UNIQUEIDENTIFIER = NULL,
 @CountryId UNIQUEIDENTIFIER = NULL,
 @IsActiveOnMobile BIT = NULL, 
 @TimeZoneId UNIQUEIDENTIFIER = NULL,
 @CurrencyId UNIQUEIDENTIFIER = NULL,
 @NumberFormatId UNIQUEIDENTIFIER = NULL,
 @DateFormatId UNIQUEIDENTIFIER = NULL,
 @TimeFormatId UNIQUEIDENTIFIER = NULL,
 @FirstName NVARCHAR(100) = NULL,
 @MobileNumber NVARCHAR(40) = NULL,
 @LastName NVARCHAR(100) = NULL,
 @IsDemoData BIT = NULL,
 @IsSoftWare BIT = NULL,
 @Language NVARCHAR(10)= NULL,
 @TrailPeriod INT = NULL,
 @ReDirectionUrl NVARCHAR(500) = NULL,
 @ConfigurationUrl NVARCHAR(500) = NULL,
 @SiteDomain NVARCHAR(500) = NULL,
 @RegisterSiteAddress NVARCHAR(Max) = NULL,
 @IdentityServerCallback NVARCHAR(1000) = NULL,
 @ResponsiblePersonName NVARCHAR(250) = NULL,
 @ApiUrl NVARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
        
        IF(@CompanyName =  '') SET @CompanyName = NULL
       
        IF(@MainUseCaseId = '00000000-0000-0000-0000-000000000000') SET @MainUseCaseId = NULL
        
        IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL
        
        IF(@TimeFormatId = '00000000-0000-0000-0000-000000000000') SET @TimeFormatId = NULL
        
        IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL
        
        IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL
        
        IF(@NumberFormatId = '00000000-0000-0000-0000-000000000000') SET @NumberFormatId = NULL
        
        IF(@DateFormatId = '00000000-0000-0000-0000-000000000000') SET @DateFormatId = NULL

        IF(@CompanyName IS NULL)
        BEGIN
           
		   RAISERROR(50011,16,2,'CompanyName')

        END  
        --ELSE IF(@MobileNumber IS NULL)
        --BEGIN
           
        --   RAISERROR(50011,16,2,'MobileNumber')

        --END

        ELSE IF(@SiteAddress IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'SiteAddress')

        END 
		
		ELSE IF(@SiteAddress LIKE '% %')
		BEGIN
           
           RAISERROR(50011,16,2,'SiteAddressSpace')

        END 
		
        ELSE IF(@WorkEmail IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMail')

        END 
		
		ELSE IF((SELECT COUNT(@WorkEmail) WHERE @WorkEmail NOT LIKE '%_@_%.__%') > 0)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMailInVaild')

        END 

        ELSE IF(@Password IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'Password')

        END
		 
        ELSE IF(@FirstName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'FirstNameProvide')

        END 
		ELSE IF(@LastName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'LastName')

        END 
        ELSE IF(@IndustryId IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'TypeofIndustry')

        END
        ELSE
        BEGIN
            
            DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company WHERE CompanyName = @CompanyName AND InActiveDateTime IS NULL)

            DECLARE @SiteAddressCount INT = (SELECT COUNT(1) FROM Company WHERE SiteAddress = @SiteAddress AND InActiveDateTime IS NULL)

		    DECLARE @RegisteredEmailCount INT = (SELECT COUNT(1) FROM Company WHERE WorkEmail = @WorkEmail AND InActiveDateTime IS NULL)

            DECLARE @MobileNumberCount INT = (SELECT COUNT(1) FROM [User] WHERE MobileNo = @MobileNumber AND @MobileNumber != NULL AND @MobileNumber!=''  AND InActiveDateTime IS NULL)

            --DECLARE @WorkEmailCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @WorkEmail AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL)
        
            DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')

            IF (@CompanyNameCount > 0)
            BEGIN

                RAISERROR(50001,16,1,'CompanyName')

            END
            ELSE IF (@SiteAddressCount > 0)
            BEGIN

                RAISERROR(50001,16,1,'SiteAddress')

            END
            --ELSE IF (@RegisteredEmailCount > 0)
            --BEGIN

            --    RAISERROR(50001,16,1,'Email')

            --END
		    ELSE IF (@MobileNumberCount > 0)
            BEGIN

                RAISERROR(50001,16,1,'MobileNumber')

            END
            --ELSE IF (@WorkEmailCount > 0)
            --BEGIN

            --    RAISERROR(50001,16,1,'Email')

            --END
            ELSE
            BEGIN
                
                DECLARE @NewCompanyId UNIQUEIDENTIFIER = NEWID() 

                DECLARE @NewUserId UNIQUEIDENTIFIER = NEWID()
                
                DECLARE @NewUserCompanyId UNIQUEIDENTIFIER = NEWID()

                DECLARE @CurrentDate DATETIME = GETDATE()

                IF(@ResponsiblePersonName IS NULL) SET @ResponsiblePersonName = @FirstName + ' ' + @LastName

                INSERT INTO [dbo].[Company](
                                            [Id],
                                            [CompanyName],
                                            [SiteAddress],
                                            [WorkEmail],
                                            [Password],
                                            [IndustryId],
                                            [MainUseCaseId],
                                            [PhoneNumber],
                                            [CountryId],
                                            [TimeZoneId],
                                            [CurrencyId],
                                            [NumberFormatId],
                                            [DateFormatId],
                                            [TimeFormatId],
                                            [TeamSize],
                                            [CreatedDateTime],
											[IsDemoDataCleared],
											[IsRemoteAccess],
											[IsDemoData],
											[IsSoftWare],
											[Language],
											[TrailDays],
											[ReDirectionUrl],
                                            [ConfigurationUrl],
											[SiteDomain],
											[RegistrerSiteAddress],
                                            [ResponsiblePersonName],
                                            [ApiUrl]
                                            )
                                    SELECT @NewCompanyId,
                                            @CompanyName,
                                            @SiteAddress,
                                            @WorkEmail,
                                            @Password,
                                            @IndustryId,
                                            @MainUseCaseId,
                                            @MobileNumber,
                                            @CountryId,
                                            @TimeZoneId,
                                            @CurrencyId,
                                            @NumberFormatId,
                                            @DateFormatId,
                                            @TimeFormatId,
                                            @TeamSize,
                                            @Currentdate,
											0,
											ISNULL(@IsRemoteAccess,0),
											@IsDemoData,
											@IsSoftWare,
											@Language,
											@TrailPeriod,
											@ReDirectionUrl,
                                            @ConfigurationUrl,
											@SiteDomain,
											@RegisterSiteAddress,
                                            @ResponsiblePersonName,
                                            @ApiUrl

                    INSERT INTO CompanyModule(
                                                [Id],
                                                [CompanyId],
                                                [ModuleId],
                                                [IsActive],
											    [IsEnabled],
                                                [CreatedDateTime],
                                                [CreatedByUserId]
                                            )
                                        SELECT NEWID(),
                                                @NewCompanyId,
                                                M.Id,
                                                CASE WHEN M.IsSystemModule = 1 THEN 1 ELSE 0 END,
											    CASE WHEN M.IsSystemModule = 1 THEN 1 ELSE 0 END,
                                                @Currentdate,
                                                @NewUserId
                                                FROM Module M 
											    --JOIN IndustryModule IM ON IM.ModuleId = M.Id AND IM.IndustryId = @IndustryId
											    WHERE M.InActiveDateTime IS NULL

                    DECLARE @RoleId UNIQUEIDENTIFIER = NEWID()
                       
					INSERT INTO [Role](
						                Id,
										RoleName,
										CompanyId,
										CreatedByUserId,
										CreatedDateTime
										)
								SELECT @RoleId,
									    'Super Admin',
										@NewCompanyId,
										@DefaultUserId,
										@CurrentDate

					INSERT INTO [User](
                                        [Id],
                                        [SurName],
                                        [FirstName],
                                        [UserName],
                                        [Password],
                                        [IsActive],
                                        [TimeZoneId],
                                        [MobileNo],
                                        [IsActiveOnMobile],
                                        [RegisteredDateTime],
                                        [CreatedDateTime],
                                        [CreatedByUserId]
                                        )
                                SELECT @NewUserId,
                                       @LastName,
                                       @FirstName,
                                       @WorkEmail,
                                       @Password,
                                       1,
                                       @TimeZoneId,
                                       @MobileNumber,
                                       CASE WHEN @IsActiveOnMobile IS NULL THEN 0 ELSE @IsActiveOnMobile END,
                                       @CurrentDate,
                                       @CurrentDate,
                                       @DefaultUserId

                    INSERT INTO [UserCompany](
                                            [Id],
                                            [UserId],
                                            [CompanyId],
                                            [CreatedByUserId],
                                            [CreatedDateTime]
                                            )
                                    SELECT @NewUserCompanyId,
                                           @NewUserId,
                                           @NewCompanyId,
                                           @NewUserId,
                                           GETDATE()

                    INSERT INTO UserRole
					    	        (Id
					    	        ,UserId
                                    ,CompanyId
					    	        ,RoleId
					    	        ,CreatedByUserId
					    	        ,CreatedDateTime)
					    	 SELECT NEWID()
					    	        ,@NewUserId
                                    ,@NewCompanyId
					    		    ,@RoleId
					    		    ,@DefaultUserId
					    		    ,@Currentdate

                    DECLARE @ClientId NVARCHAR(250)

			        DECLARE @ClientName NVARCHAR(250)

                    SET @ClientId = (SELECT CONCAT(@NewUserId , ' ', @NewCompanyId))

					SET @ClientName = (SELECT CONCAT(@FirstName , ' ' , @LastName))

					DECLARE @ClientIdInt INT 

					INSERT INTO [dbo].[Clients] ([Enabled], ClientId, ProtocolType, RequireClientSecret, ClientName, RequireConsent, AllowRememberConsent, AlwaysIncludeUserClaimsInIdToken, RequirePkce, AllowPlainTextPkce, RequireRequestObject, AllowAccessTokensViaBrowser, 
						FrontChannelLogoutSessionRequired, BackChannelLogoutSessionRequired, AllowOfflineAccess, IdentityTokenLifetime, AccessTokenLifetime, AuthorizationCodeLifetime, AbsoluteRefreshTokenLifetime, SlidingRefreshTokenLifetime, RefreshTokenUsage,UpdateAccessTokenClaimsOnRefresh,
						RefreshTokenExpiration, AccessTokenType, EnableLocalLogin, IncludeJwtId, AlwaysSendClientClaims, ClientClaimsPrefix, PairWiseSubjectSalt, Created, DeviceCodeLifetime, NonEditable, UserCompanyId)
					SELECT 1,@ClientId,'oidc', 1, @ClientName,0,1,0,1,0,0,0,
						1,1,0,300,7200,300,2592000,1296000,1,0,
						1,0,1,1,1,'client_',NULL,GETDATE(),300,0, @NewUserCompanyId

					SET @ClientIdInt = (SELECT Id FROM Clients WHERE UserCompanyId = @NewUserCompanyId)

					IF(NOT EXISTS(SELECT Id FROM ApiScopes WHERE DisplayName = @NewCompanyId))
					BEGIN
						INSERT INTO [dbo].[ApiScopes] ([Enabled], [Name], DisplayName, [Required], Emphasize, ShowInDiscoveryDocument)
						SELECT 1, @NewCompanyId, @NewCompanyId, 0, 0, 1
					END

					INSERT INTO [dbo].[ClientScopes] (Scope, ClientId)
					SELECT @NewCompanyId, @ClientIdInt

					INSERT INTO [dbo].[ClientSecrets]([Value], [Type], Created, ClientId)
					SELECT 'jKGHySpqOJJzXKn9zFr5H09CPujNpVAVgZLP5CGSRq0=', 'SharedSecret', GETDATE(), @ClientIdInt

					INSERT INTO [dbo].[ClientRedirectUris](RedirectUri, ClientId)
					SELECT @IdentityServerCallback, @ClientIdInt
									

					CREATE TABLE #Grants (GrantType NVARCHAR(250)) 
					INSERT INTO #Grants (GrantType)
					SELECT 'client_credentials'
					UNION ALL
					SELECT 'authorization_code'


					INSERT INTO [dbo].[ClientGrantTypes](GrantType, ClientId)
					SELECT GrantType, @ClientIdInt FROM #Grants

                     DECLARE @EscuteScript NVARCHAR(MAX) = ''

                    --TODO
                    SELECT @EscuteScript = @EscuteScript + '  EXEC [dbo].' + ScriptFileId + ' @CompanyId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@NewCompanyId) + ''',@RoleId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@RoleId) + ''',@UserId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@NewUserId) + ''''
                    FROM DeploymentScript
                    ORDER BY ScriptFileExecutionOrder

                    EXECUTE(@EscuteScript);

                   


                    SELECT @NewCompanyId AS CompanyId,@NewUserId AS UserId,@RoleId AS RoleId
            END

        END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END