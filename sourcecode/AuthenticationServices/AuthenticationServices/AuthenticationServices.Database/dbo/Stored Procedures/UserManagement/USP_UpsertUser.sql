CREATE PROCEDURE [dbo].[USP_UpsertUser]
(
  @UserId UNIQUEIDENTIFIER = NULL,
  @FirstName NVARCHAR(250) = NULL,
  @SurName NVARCHAR(250) = NULL,
  @Email NVARCHAR(250) = NULL,
  @Password NVARCHAR(250) = NULL,
  @RoleIds NVARCHAR(MAX) = NULL,
  @IsPasswordForceReset BIT = NULL,
  @IsActive BIT = 1,
  @IsExternal BIT = NULL,
  @MobileNo NVARCHAR(250) = NULL,
  @IsAdmin BIT = NULL,
  @IsActiveOnMobile BIT = 1,
  @ProfileImage NVARCHAR(1000) = NULL,
  @LastConnection DATETIME =NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @DesktopId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Language NVARCHAR(50) =NULL,
  @CompanyId UNIQUEIDENTIFIER,
  @IdentityServerCallback NVARCHAR(1000) = NULL,
  @UpdateProfileDetails BIT = NULL,
  @IsFromClient BIT = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
    BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		IF(@RoleIds = '') SET @RoleIds = NULL
        
        IF(@FirstName = '') SET @FirstName = NULL
        
        IF(@MobileNo = '') SET @MobileNo = NULL
        
        IF(@Email = '') SET @Email = NULL
        
        IF(@Password = '') SET @Password = NULL
        
        IF(@IsActive = NULL) SET  @IsActive = 1
        
        IF(@IsActive = 0) SET @IsArchived = 1
        
        IF(@IsActiveOnMobile = NULL) SET  @IsActiveOnMobile = 1

		IF(@UpdateProfileDetails = 1 AND @UserId IS NOT NULL)
		BEGIN
			DECLARE @HavePermissionUpdate NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermissionUpdate = '1')
			BEGIN
				DECLARE @OldFirstName NVARCHAR(250) = NULL, @OldSurName NVARCHAR(250) = NULL, @OldProfileImage NVARCHAR(1000) = NULL, @OldTimeZoneId UNIQUEIDENTIFIER = NULL
				
				SELECT @OldFirstName = FirstName, @OldSurName = SurName , @OldProfileImage = ProfileImage FROM [User] WHERE Id = @UserId

				UPDATE [User] 
					SET FirstName = ISNULL(@FirstName, @OldFirstName),
						SurName = ISNULL(@SurName, @OldSurName),
						ProfileImage = ISNULL(@ProfileImage, @OldProfileImage),
						TimeZoneId = ISNULL(@TimeZoneId, @OldTimeZoneId)
				WHERE Id = @UserId
											
				SELECT Id FROM [dbo].[User] WHERE Id = @UserId
			END
			ELSE
            BEGIN
                    RAISERROR (@HavePermissionUpdate,11, 1)
                        
            END
		END
        ELSE IF(@FirstName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'FirstName')
        END
        ELSE IF(@Email IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Email')
        END
        ELSE IF(@Password IS NULL AND @UserId IS  NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Password')
        END
        ELSE
        BEGIN
            
            DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
            
            DECLARE @IsRemoteAccess BIT = (SELECT  IsRemoteAccess FROM Company C WHERE C.Id = @CompanyId)

			DECLARE @NoOfEmployees INT = (Select COUNT(U.Id) FROM [User] U 
                                                INNER JOIN  UserCompany UC ON UC.UserId = U.Id
                                                WHERE UC.CompanyId = @CompanyId AND UC.InActiveDateTime IS NULL )

            DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            DECLARE @UserIdIdCount INT = (SELECT COUNT(1) FROM [dbo].[User] U INNER JOIN UserCompany AS UC ON UC.UserId = U.Id WHERE U.Id = @UserId AND UC.CompanyId = @CompanyId)
            DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [dbo].[User] U INNER JOIN UserCompany AS UC ON UC.UserId = U.Id WHERE U.UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR U.Id <> @UserId))

            DECLARE @IsValid BIT = CASE WHEN @NoOfEmployees >= ISNULL((SELECT NoOfPurchasedLicences FROM Company WHERE  Id = @CompanyId),0) THEN 1 ELSE 0 END

			DECLARE @ActivePrevious BIT = (SELECT IsActive FROM [dbo].[user] U INNER JOIN UserCompany AS UC ON UC.UserId = U.Id WHERE U.Id =@UserId AND UC.CompanyId = (SELECT Id from Company WHERE IsRemoteAccess =1 AND Id = @CompanyId ))

			DECLARE @UserCompanyId UNIQUEIDENTIFIER

			DECLARE @ClientId NVARCHAR(250)

			DECLARE @ClientName NVARCHAR(250)

            IF(@UserIdIdCount = 0 AND @UserId IS NOT NULL)
            BEGIN
                RAISERROR(50002,16, 1,'User')
            END
            
            ELSE IF(@UserNameCount > 0 AND @UserId IS NULL)
            BEGIN
                
                 RAISERROR(50010,16,1,'User')
				--SELECT Id FROM [dbo].[User] WHERE UserName = @Email
            END
            ELSE
            BEGIN
                
                IF (@HavePermission = '1')
                BEGIN
                    
                    DECLARE @IsLatest BIT = CASE WHEN @UserId IS NULL THEN 1
                                                 WHEN (@TimeStamp IS NULL OR (SELECT [TimeStamp] FROM [User] WHERE Id = @UserId ) = @TimeStamp)THEN 1
                                                 ELSE 0 END

                    IF(@IsLatest = 1 AND (@UpdateProfileDetails IS NULL OR @UpdateProfileDetails = 0))
                    BEGIN

					    DECLARE @OldCurrencyId UNIQUEIDENTIFIER 
                        DECLARE @Currentdate DATETIME = GETDATE()
                        DECLARE @Inactive DATETIME = NULL
                        DECLARE @OldValue NVARCHAR(MAX) = NULL
					    DECLARE @NewValue NVARCHAR(MAX) = NULL

                        DECLARE @CurrencyId UNIQUEIDENTIFIER 

						DECLARE @ClientIdInt INT 
                        
                        SELECT @CurrencyId = CurrencyId FROM [User] WHERE Id = @UserId

                        DECLARE @ExistingUserId UNIQUEIDENTIFIER = NULL

                        SET @ExistingUserId = (SELECT Id FROM [User] WHERE UserName = @Email)
                        
						
                        IF(((@ExistingUserId IS NULL OR @ExistingUserId = @EmptyGuid) AND @UserId IS NULL) 
						--OR (@ExistingUserId IS NOT NULL AND @UserId IS NULL AND (SELECT CompanyId FROM UserCompany WHERE UserId = @ExistingUserId AND CompanyId = @CompanyId) IS NULL)
							) 
                        BEGIN
						
                           
						   IF((@ExistingUserId IS NULL OR @ExistingUserId = @EmptyGuid) AND @UserId IS NULL)
						   BEGIN
								SET @ExistingUserId = NEWID()
								SET @UserId = @ExistingUserId

								INSERT INTO [dbo].[User](
														[Id],
														[FirstName],
														[SurName],
														[UserName],
														[Password],
														[IsActive],
														[IsAdmin],
														[IsExternal],
														[MobileNo],
														[ProfileImage],
														[RegisteredDateTime],
														[IsActiveOnMobile],
														[InActiveDateTime],
														[CreatedDateTime],
														[CreatedByUserId],
														[TimeZoneId],
														[DesktopId],
														[CurrencyId],
														[Language])
												 SELECT @UserId,
														@FirstName,
														@Surname,
														@Email,
														@Password,
														@IsActive,
														@IsAdmin,
														@IsExternal,
														@MobileNo,
														@ProfileImage,
														@Currentdate,
														@IsActiveOnMobile,
														CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
														@Currentdate,
														@OperationsPerformedBy,
														@TimeZoneId,
														@DesktopId,
														@CurrencyId,
														@Language
							

								INSERT INTO [dbo].[UserCompany](
                                                    Id,
                                                    UserId,
                                                    CompanyId,
                                                    CreatedDateTime, 
                                                    CreatedByUserId
                                                    )
                                        SELECT NEWID(),
                                               @UserId,
                                               @CompanyId,
                                               GETDATE(),
                                               @OperationsPerformedBy

								IF(@IsArchived = 1)
								BEGIN
									UPDATE [dbo].[UserCompany]
										SET InActiveDateTime = @Currentdate
									WHERE UserId = @UserId AND CompanyId = @CompanyId
								END
								ELSE IF(@IsArchived = 0 OR @IsArchived IS NULL)
								BEGIN
									UPDATE [dbo].[UserCompany]
										SET InActiveDateTime = NULL
									WHERE UserId = @UserId AND CompanyId = @CompanyId

									UPDATE [dbo].[User]
										SET InActiveDateTime = NULL
									WHERE Id = @UserId
								END

								INSERT INTO [dbo].[UserRole](
													Id
													,UserId
													,RoleId
													,CompanyId
													,CreatedByUserId
													,CreatedDateTime)
								 SELECT NEWID()
								            ,@UserId
								 	        ,Id
											,@CompanyId
								 	        ,@OperationsPerformedBy
								 	        ,@Currentdate
								 	   FROM dbo.UfnSplit(@RoleIds)

								SET @UserCompanyId = (SELECT Id FROM UserCompany WHERE UserId = @UserId AND CompanyId = @CompanyId)

								SET @ClientId = (SELECT CONCAT(@UserId , ' ' , @CompanyId))

								SET @ClientName = (SELECT CONCAT(@FirstName , ' ' , @SurName))								

								INSERT INTO [dbo].[Clients] ([Enabled], ClientId, ProtocolType, RequireClientSecret, ClientName, RequireConsent, AllowRememberConsent, AlwaysIncludeUserClaimsInIdToken, RequirePkce, AllowPlainTextPkce, RequireRequestObject, AllowAccessTokensViaBrowser, 
									FrontChannelLogoutSessionRequired, BackChannelLogoutSessionRequired, AllowOfflineAccess, IdentityTokenLifetime, AccessTokenLifetime, AuthorizationCodeLifetime, AbsoluteRefreshTokenLifetime, SlidingRefreshTokenLifetime, RefreshTokenUsage,UpdateAccessTokenClaimsOnRefresh,
									RefreshTokenExpiration, AccessTokenType, EnableLocalLogin, IncludeJwtId, AlwaysSendClientClaims, ClientClaimsPrefix, PairWiseSubjectSalt, Created, DeviceCodeLifetime, NonEditable, UserCompanyId)
								SELECT 1,@ClientId,'oidc', 1, @ClientName,0,1,0,1,0,0,0,
									1,1,0,300,7200,300,2592000,1296000,1,0,
									1,0,1,1,1,'client_',NULL,GETDATE(),300,0, @UserCompanyId

								SET @ClientIdInt = (SELECT Id FROM Clients WHERE UserCompanyId = @UserCompanyId)

								IF(NOT EXISTS(SELECT Id FROM ApiScopes WHERE DisplayName = @CompanyId))
								BEGIN
									INSERT INTO [dbo].[ApiScopes] ([Enabled], [Name], DisplayName, [Required], Emphasize, ShowInDiscoveryDocument)
									SELECT 1, @CompanyId, @CompanyId, 0, 0, 1
								END

								INSERT INTO [dbo].[ClientScopes] (Scope, ClientId)
								SELECT @CompanyId, @ClientIdInt

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

                        END
					  END
                        ELSE IF(@ExistingUserId IS NOT NULL AND @UserId IS NULL)
                       BEGIN
                        
						 IF((SELECT CompanyId FROM UserCompany WHERE UserId = @ExistingUserId AND CompanyId = @CompanyId) IS NULL)
                         BEGIN
                          
						  SET @UserId = @ExistingUserId 
						  
						  INSERT INTO [dbo].[UserCompany](
                                   Id,
                                   UserId,
                                   CompanyId,
                                   CreatedDateTime,
                                   CreatedByUserId
                                   )
                                   SELECT NEWID(),
                                   @UserId,
                                   @CompanyId,
                                   GETDATE(),
                                   @OperationsPerformedBy 
					
					INSERT INTO [dbo].[UserRole](
                                Id
                                ,UserId
                                ,RoleId
                                ,CompanyId
                                ,CreatedByUserId
                                ,CreatedDateTime)
                                SELECT NEWID()
                                ,@UserId
                                ,Id
                                ,@CompanyId
                                ,@OperationsPerformedBy
                                ,@Currentdate
                                FROM dbo.UfnSplit(@RoleIds) 
							
							SET @UserCompanyId = (SELECT Id FROM UserCompany WHERE UserId = @UserId AND CompanyId = @CompanyId)

								SET @ClientId = (SELECT CONCAT(@UserId , ' ' , @CompanyId))

								SET @ClientName = (SELECT CONCAT(@FirstName , ' ' , @SurName))

								INSERT INTO [dbo].[Clients] ([Enabled], ClientId, ProtocolType, RequireClientSecret, ClientName, RequireConsent, AllowRememberConsent, AlwaysIncludeUserClaimsInIdToken, RequirePkce, AllowPlainTextPkce, RequireRequestObject, AllowAccessTokensViaBrowser, 
									FrontChannelLogoutSessionRequired, BackChannelLogoutSessionRequired, AllowOfflineAccess, IdentityTokenLifetime, AccessTokenLifetime, AuthorizationCodeLifetime, AbsoluteRefreshTokenLifetime, SlidingRefreshTokenLifetime, RefreshTokenUsage,UpdateAccessTokenClaimsOnRefresh,
									RefreshTokenExpiration, AccessTokenType, EnableLocalLogin, IncludeJwtId, AlwaysSendClientClaims, ClientClaimsPrefix, PairWiseSubjectSalt, Created, DeviceCodeLifetime, NonEditable, UserCompanyId)
								SELECT 1,@ClientId,'oidc', 1, @ClientName,0,1,0,1,0,0,0,
									1,1,0,300,7200,300,2592000,1296000,1,0,
									1,0,1,1,1,'client_',NULL,GETDATE(),300,0, @UserCompanyId

								SET @ClientIdInt = (SELECT Id FROM Clients WHERE UserCompanyId = @UserCompanyId)

								IF(NOT EXISTS(SELECT Id FROM ApiScopes WHERE DisplayName = @CompanyId))
								BEGIN
									INSERT INTO [dbo].[ApiScopes] ([Enabled], [Name], DisplayName, [Required], Emphasize, ShowInDiscoveryDocument)
									SELECT 1, @CompanyId, @CompanyId, 0, 0, 1
								END

								INSERT INTO [dbo].[ClientScopes] (Scope, ClientId)
								SELECT @CompanyId, @ClientIdInt

								INSERT INTO [dbo].[ClientSecrets]([Value], [Type], Created, ClientId)
								SELECT 'jKGHySpqOJJzXKn9zFr5H09CPujNpVAVgZLP5CGSRq0=', 'SharedSecret', GETDATE(), @ClientIdInt

								INSERT INTO [dbo].[ClientRedirectUris](RedirectUri, ClientId)
								SELECT @IdentityServerCallback, @ClientIdInt

								CREATE TABLE #Grants1 (GrantType NVARCHAR(250)) 
								INSERT INTO #Grants1 (GrantType)
								SELECT 'client_credentials'
								UNION ALL
								SELECT 'authorization_code'

								INSERT INTO [dbo].[ClientGrantTypes](GrantType, ClientId)
								SELECT GrantType, @ClientIdInt FROM #Grants1

						   
                           END
                        
					   END
                        ELSE IF(@UserId IS NOT NULL)
                        BEGIN

						DECLARE @IsActiveFromClient BIT = ( SELECT IsActive From [User] WHERE Id = @UserId )

							UPDATE [dbo].[User]
								SET [FirstName] = @FirstName,
								    [SurName] = @SurName,
								    [UserName] = @Email,
								    --[Password] = @Password,
								    [IsActive] = CASE WHEN @IsFromClient = 1 THEN 1 ELSE @IsActiveFromClient END,
								    [IsAdmin] = @IsAdmin,
									[IsExternal] = @IsExternal,
								    [MobileNo] = @MobileNo,
								    [ProfileImage] = @ProfileImage,
								    [RegisteredDateTime] = @CurrentDate,
								    [IsActiveOnMobile] = @IsActiveOnMobile,
								    --[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								    [UpdatedDateTime] = @Currentdate,
								    [UpdatedByUserId] = @OperationsPerformedBy,
						  			[TimeZoneId] = @TimeZoneId,
									[DesktopId] = CASE WHEN @IsArchived = 1 THEN NULL ELSE @DesktopId END,
						  			[CurrencyId] = @CurrencyId,
									[Language] = @Language
						  			WHERE Id = @UserId

									IF(@Password IS NOT NULL AND @Password <> '' AND @IsFromClient <> 1)
									BEGIN 
										
										UPDATE [dbo].[User]
										SET [Password] = @Password
						  					WHERE Id = @UserId

									END

									IF(@IsArchived = 1)
									BEGIN
										UPDATE [dbo].[UserCompany]
											SET InActiveDateTime = @Currentdate
										WHERE UserId = @UserId AND CompanyId = @CompanyId
									END
									ELSE IF(@IsArchived = 0 OR @IsArchived IS NULL)
									BEGIN
										UPDATE [dbo].[UserCompany]
											SET InActiveDateTime = NULL
										WHERE UserId = @UserId AND CompanyId = @CompanyId

										UPDATE [dbo].[User]
											SET InActiveDateTime = NULL
										WHERE Id = @UserId
									END

									IF(@Password IS NOT NULL AND @Password <> ''  AND @IsFromClient <> 1)
									BEGIN
										UPDATE [dbo].[User]
											SET [Password] = @Password
											WHERE Id = @UserId
									END

									DECLARE @RoleIdsList TABLE
									(
									RoleId UNIQUEIDENTIFIER
									)

									INSERT INTO @RoleIdsList(RoleId)
									SELECT Id FROM [dbo].UfnSplit(@RoleIds)
								
									UPDATE [dbo].[UserRole] SET InactiveDateTime = @Currentdate
													,[UpdatedDateTime] = @Currentdate
								 					,[UpdatedByUserId] = @OperationsPerformedBy
												WHERE UserId = @UserId
								
									INSERT INTO [dbo].[UserRole]
								 			(Id
								 			,UserId
								 			,RoleId
											,CompanyId
								 			,CreatedByUserId
								 			,CreatedDateTime)
								 	SELECT NEWID()
								 			,@UserId
								 			,RL.RoleId
											,@CompanyId
								 			,@OperationsPerformedBy
								 			,@Currentdate
								 	FROM @RoleIdsList RL

                        END

						 SELECT Id FROM [dbo].[User] WHERE Id = @UserId
                    END

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