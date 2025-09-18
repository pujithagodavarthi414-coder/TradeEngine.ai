USE [nxcore-ana1]
GO
/****** Object:  StoredProcedure [dbo].[USP_UpsertUser]    Script Date: 30-07-2025 10:39:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------
-- Author       Pujitha Godavarthi
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Save or Update the User
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUser] @CompanyId='4AFEB444-E826-4F95-AC41-2175E36A0C16',@FirstName='ajay',@SurName='mekala',@Email='test@gmail.com',
--@Password='1234566',@RoleIds='860484F4-2E1F-4A0A-BD36-3509611EA6E3',@IsActive=1,@MobileNo='9989821523',@IsActiveOnMobile=1,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[USP_UpsertUser]
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
  @ModuleIdsXml XML =Null,
  @UserAuthenticationId UNIQUEIDENTIFIER = NULL
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

        IF(@FirstName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'FirstName')
        END
        ELSE IF(@Email IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Email')
        END
        ELSE IF(@Password IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Password')
        END
        ELSE 
        BEGIN
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

			DECLARE @IsRemoteAccess BIT = (SELECT  IsRemoteAccess FROM Company C WHERE C.Id = @CompanyId)

			DECLARE @NoOfEmployees INT = (Select COUNT(Id) FROM [User] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL )

            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            DECLARE @UserIdIdCount INT = (SELECT COUNT(1) FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId)
            DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR Id <> @UserId))

			DECLARE @IsValid BIT = CASE WHEN @NoOfEmployees >= ISNULL((SELECT NoOfPurchasedLicences FROM Company WHERE  Id = @CompanyId),0) THEN 1 ELSE 0 END

			DECLARE @ActivePrevious BIT = (SELECT IsActive FROM [user] WHERE Id =@UserId AND CompanyId = (SELECT Id from Company WHERE IsRemoteAccess =1 AND Id =@CompanyId ))

            IF(@UserIdIdCount = 0 AND @UserId IS NOT NULL)
            BEGIN
                RAISERROR(50002,16, 1,'User')
            END
            
            ELSE IF(@UserNameCount > 0)
            BEGIN
                
                RAISERROR(50010,16,1,'User')
            END
            ELSE
            BEGIN
                
                IF (@HavePermission = '1')
                BEGIN
                    
                    DECLARE @IsLatest BIT = 1--CASE WHEN @UserId IS NULL THEN 1
                                               --  WHEN (SELECT [TimeStamp] FROM [User] WHERE Id = @UserId ) = @TimeStamp THEN 1
                                                 --ELSE 0 END
                    
                    IF(@IsLatest = 1)
                    BEGIN
					      SELECT x.value('(text())[1]','UNIQUEIDENTIFIER') AS Id
                                  INTO #ModuleIdList 
                         FROM  @ModuleIdsXml.nodes('/ArrayOfGuid/guid') XmlData(x)

                        DECLARE @OldUserId UNIQUEIDENTIFIER = NULL
                        DECLARE @OldFirstName NVARCHAR(250) = NULL
                        DECLARE @OldSurName NVARCHAR(250) = NULL
                        DECLARE @OldEmail NVARCHAR(250) = NULL
                        DECLARE @OldPassword NVARCHAR(250) = NULL
                        DECLARE @OldRoleIds NVARCHAR(MAX) = NULL
                        DECLARE @OldIsPasswordForceReset BIT = NULL
                        DECLARE @OldIsActive BIT = 1
                        DECLARE @OldMobileNo NVARCHAR(250) = NULL
                        DECLARE @OldIsAdmin BIT = NULL
                        DECLARE @OldIsActiveOnMobile BIT = NULL
                        DECLARE @OldProfileImage NVARCHAR(1000) = NULL
                        DECLARE @OldLastConnection DATETIME =NULL
                        DECLARE @OldTimeZoneId UNIQUEIDENTIFIER 
                        DECLARE @OldDesktopId UNIQUEIDENTIFIER = NULL
						DECLARE @OldIsExternal BIT = NULL

					    DECLARE @OldCurrencyId UNIQUEIDENTIFIER 
                        DECLARE @Currentdate DATETIME = GETDATE()
                        DECLARE @Inactive DATETIME = NULL
                        DECLARE @OldValue NVARCHAR(MAX) = NULL
					    DECLARE @NewValue NVARCHAR(MAX) = NULL

                        SELECT @OldFirstName         = [FirstName],
                               @OldSurname           = [SurName],
                               @OldEmail             = [UserName],
                               @OldPassword          = [Password],
                               @OldIsActive          = [IsActive],
                               @OldIsAdmin           = [IsAdmin],
							   @OldIsExternal		 = [IsExternal],
                               @OldMobileNo          = [MobileNo],
                               @OldProfileImage      = [ProfileImage],
                               @OldIsActiveOnMobile  = [IsActiveOnMobile],
                               @OldTimeZoneId        = [TimeZoneId],
                               @OldDesktopId         = [DesktopId],
                               @OldCurrencyId        = [CurrencyId],
                               @Inactive             = [InActiveDateTime]
                        FROM [User] WHERE Id = @UserId

						--DECLARE @TimeZoneId UNIQUEIDENTIFIER 

					    DECLARE @CurrencyId UNIQUEIDENTIFIER 
                        
                        SELECT @CurrencyId = CurrencyId FROM [User] WHERE Id = @UserId
                      
					    IF(@UserId IS NULL)
					    BEGIN

					          SET @UserId = NEWID()

						      INSERT INTO [dbo].[User](
													[Id],
													[CompanyId],
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
													[Language],
													[UserAuthenticationId])
											 SELECT @UserId,
											        @CompanyId,
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
													@Language,
													@UserAuthenticationId

								INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
						SELECT NEWID(),@UserId,M.Id AS ModuleId,@OperationsPerformedBy,GETDATE(),1
						FROM #ModuleIdList M

								DECLARE @ChannelId UNIQUEIDENTIFIER = (select Id from Channel where CompanyId = @CompanyId AND ChannelName='General')

								IF (@ChannelId IS NOT NULL)
								BEGIN
				  					   INSERT INTO ChannelMember
									         (
									         [Id] ,
									         [ChannelId] ,
									         [MemberUserId],
									         [ActiveFrom] ,
									         [IsActiveMember],
											 [CreatedDateTime],
									         [CreatedByUserId]
									         )
									   SELECT NEWID(),
									         @ChannelId,
									         @UserId,
									         @CurrentDate,
									         1,
											 @CurrentDate,
											 @OperationsPerformedBy
				                 END

								 INSERT INTO UserRole
											(Id
											,UserId
											,RoleId
											,CreatedByUserId
											,CreatedDateTime)
								 SELECT NEWID()
								            ,@UserId
								 	        ,Id
								 	        ,@OperationsPerformedBy
								 	        ,@Currentdate
								 	   FROM dbo.UfnSplit(@RoleIds)

						 END
						 ELSE
						 BEGIN

								IF(@IsArchived = 1)
								BEGIN
									UPDATE ActivityTrackerDesktop SET InActiveDateTime = GETUTCDATE() WHERE Id = 
									(SELECT TOP 1 DesktopId FROM [User] WHERE Id = @UserId)
								END
								ELSE
								BEGIN
									UPDATE ActivityTrackerDesktop SET InActiveDateTime = NULL WHERE Id = @DesktopId
								END

								UPDATE [User]
								  SET [CompanyId] = @CompanyId,
								      [FirstName] = @FirstName,
								      [SurName] = @SurName,
								      [UserName] = @Email,
								      --[Password] = @Password,
								      [IsActive] = @IsActive,
								      [IsAdmin] = @IsAdmin,
									  [IsExternal] = @IsExternal,
								      [MobileNo] = @MobileNo,
								      [ProfileImage] = @ProfileImage,
								      [RegisteredDateTime] = @CurrentDate,
								      [IsActiveOnMobile] = @IsActiveOnMobile,
								      [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								      [UpdatedDateTime] = @Currentdate,
								      [UpdatedByUserId] = @OperationsPerformedBy,
						  			  [TimeZoneId] = @TimeZoneId,
									  [DesktopId] = CASE WHEN @IsArchived = 1 THEN NULL ELSE @DesktopId END,
						  			  [CurrencyId] = @CurrencyId,
									  [Language] = @Language,
									  [UserAuthenticationId] = @UserAuthenticationId
						  			  WHERE Id = @UserId

								     DELETE FROM Intro WHERE UserId = @UserId

									 INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
									 SELECT NEWID(),@UserId,M.Id AS ModuleId,@OperationsPerformedBy,GETDATE(),1
									 FROM #ModuleIdList M

								 DECLARE @RoleIdsList TABLE
								 (
								    RoleId UNIQUEIDENTIFIER
								 )
								
								 INSERT INTO @RoleIdsList(RoleId)
								 SELECT Id FROM dbo.UfnSplit(@RoleIds)
								
								 UPDATE UserRole SET InactiveDateTime = @Currentdate
								                   ,[UpdatedDateTime] = @Currentdate
								 				   ,[UpdatedByUserId] = @OperationsPerformedBy
												WHERE UserId = @UserId
								
								 INSERT INTO UserRole
								 			(Id
								 			,UserId
								 			,RoleId
								 			,CreatedByUserId
								 			,CreatedDateTime)
								 	SELECT NEWID()
								 	       ,@UserId
								 		   ,RL.RoleId
								 		   ,@OperationsPerformedBy
								 		   ,@Currentdate
								 	FROM @RoleIdsList RL
								
						 END

						 DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @UserId)
						 
						 SET @NewValue = (SELECT ',' + R.RoleName FROM [UserRole] UR JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND UR.UserId = @UserId FOR XML PATH(''))
						 SET @NewValue = (SELECT SUBSTRING(@NewValue,2,LEN(@NewValue)))
						 
						 IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
					@FieldName = 'Role(s)',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
						 
						 SET @OldValue = (SELECT CurrencyName  FROM Currency WHERE Id = @OldCurrencyId)
						 SET @NewValue = (SELECT CurrencyName  FROM Currency WHERE Id = @CurrencyId)
						 
						 IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
					@FieldName = 'Currency',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
						 
						 SET @OldValue = (SELECT TimeZoneName  FROM TimeZone WHERE Id = @OldTimeZoneId)
						 SET @NewValue = (SELECT TimeZoneName  FROM TimeZone WHERE Id = @TimeZoneId)
						 
						 IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Time zone',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
						 
						 SET @OldValue = (SELECT DesktopName FROM ActivityTrackerDesktop WHERE Id = @OldDesktopId)
						 SET @NewValue = (SELECT DesktopName FROM ActivityTrackerDesktop WHERE Id = @DesktopId)
						 
						 IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Desktop',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
						 

						 IF(ISNULL(@OldMobileNo,'') <> @MobileNo AND @MobileNo IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Mobile number',@OldValue = @OldMobileNo,@NewValue = @MobileNo,@RecordTitle = @RecordTitle
						 
						 IF(ISNULL(@OldFirstName,'') <> @FirstName AND @FirstName IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'First name',@OldValue = @OldFirstName,@NewValue = @FirstName,@RecordTitle = @RecordTitle
						 
						 IF(ISNULL(@OldSurname,'') <> @Surname AND @Surname IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Last name',@OldValue = @OldSurname,@NewValue = @Surname,@RecordTitle = @RecordTitle
						 
						 IF(ISNULL(@OldEmail,'') <> @Email AND @Email IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Email',@OldValue = @OldEmail,@NewValue = @Email,@RecordTitle = @RecordTitle
						 
						 IF(ISNULL(@OldPassword,'') <> @Password AND @Password IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Password',@OldValue = @OldPassword,@NewValue = @Password,@RecordTitle = @RecordTitle,@Description = 'Password changed'
						 
						 IF(ISNULL(@OldProfileImage,'') <> @ProfileImage AND @ProfileImage IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Profile image',@OldValue = @OldProfileImage,@NewValue = @ProfileImage,@RecordTitle = @RecordTitle,@Description = 'Profile image changed'
						 
						 SET @OldValue = IIF(ISNULL(@OldIsActive,0) = 0,'Inactive','Active')
						 SET @NewValue = IIF(ISNULL(@IsActive,0) = 0,'Inctive','Active')
						 
						 IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
						 EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@UserId = @UserId,@Category = 'User details',
						 @FieldName = 'Status',@OldValue = @OldValue,@NewValue = @NewValue,@RecordTitle = @RecordTitle
						 
						 --Tracker details update
						 IF
						 (
							(@OldDesktopId IS NULL OR @OldDesktopId <> @DesktopId) 
							AND (SELECT TOP 1 COUNT(*) FROM ActivityTrackerDesktop WHERE Id = @DesktopId) > 0
						  )
						 BEGIN
							UPDATE UserActivityToken SET 
								UserId = @UserId,
								UpdatedByUserId = @UserId,
								UpdatedDateTime = GETUTCDATE() 
							WHERE 
								DesktopId = @DesktopId 
								AND DesktopId IS NOT NULL
								AND (UserId IS NULL OR UserId = @EmptyGuid)

							UPDATE ActivityTrackerStatus SET
								UserId = @UserId
							WHERE
								DesktopId = @DesktopId
								AND DesktopId IS NOT NULL
								AND (UserId IS NULL OR UserId = @EmptyGuid)
								AND [Date] = (SELECT MAX([Date]) FROM ActivityTrackerStatus WHERE DesktopId = @DesktopId)

							UPDATE UserActivityTime SET
								UserId = @UserId
							WHERE 
								DesktopId = @DesktopId
								AND DesktopId IS NOT NULL
								AND (UserId IS NULL OR UserId = @EmptyGuid)

							UPDATE UserActivityTrackerStatus SET
								UserId = @UserId,
								CompanyId = @CompanyId
							WHERE 
								DesktopId = @DesktopId
								AND DesktopId IS NOT NULL
								AND (UserId IS NULL OR UserId = @EmptyGuid)

							UPDATE ActivityScreenShot SET
								UserId = @UserId
							WHERE
								DesktopId = @DesktopId
								AND DesktopId IS NOT NULL
								AND (UserId IS NULL OR UserId = @EmptyGuid)
						 END

						 SELECT Id FROM [dbo].[User] WHERE Id = @UserId

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
