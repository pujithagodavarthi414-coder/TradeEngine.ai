CREATE PROCEDURE [dbo].[USP_UpsertUserDetails]
(
  @UserId UNIQUEIDENTIFIER = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @FirstName NVARCHAR(250) = NULL,
  @SurName NVARCHAR(250) = NULL,
  @Email NVARCHAR(250) = NULL,
  @Password NVARCHAR(250) = NULL,
  @Role NVARCHAR(MAX) = NULL,
  @IsPasswordForceReset BIT = NULL,
  @IsActive BIT = 1,
  @MobileNo NVARCHAR(250) = NULL,
  @IsAdmin BIT = NULL,
  @IsActiveOnMobile BIT = 1,
  @ProfileImage NVARCHAR(1000) = NULL,
  @LastConnection DATETIME =NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        IF(@Role = '') SET @Role = NULL
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
		ELSE IF(@Role IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'Role')
        END
        ELSE 
        BEGIN
			 
			IF(@ReferenceId IS NOT NULL)
			BEGIN
				
				SELECT @UserId = UserId FROM UserReference 
				WHERE ReferenceId = @ReferenceId AND InActiveDateTime IS NULL

				SELECT @TimeStamp = [TimeStamp] FROM [User]
				WHERE Id = @UserId

			END

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            DECLARE @UserIdIdCount INT = (SELECT COUNT(1) FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId)
            DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND CompanyId = @CompanyId AND (@UserId IS NULL OR Id <> @UserId))
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
                   
                    DECLARE @IsLatest BIT = CASE WHEN @UserId IS NULL THEN 1
                                                 WHEN (SELECT [TimeStamp] FROM [User] WHERE Id = @UserId ) = @TimeStamp THEN 1
												 --WHEN (SELECT UserId FRom UserReference WHERE ReferenceId = @ReferenceId )
                                                 ELSE 0 END
                    
                    IF(@IsLatest = 1)
                    BEGIN

                        DECLARE @Currentdate DATETIME = GETDATE()

						DECLARE @TimeZoneId UNIQUEIDENTIFIER 

					    DECLARE @CurrencyId UNIQUEIDENTIFIER 
                        
                        SELECT @TimeZoneId = TimeZoneId, @CurrencyId = CurrencyId FROM [User] WHERE Id = @UserId
                      
						IF(@UserId IS NULL)
						BEGIN
							SET @UserId = NEWID()
							
							DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] WHERE RoleName = @Role AND CompanyId = @CompanyId)
							
							IF(@RoleId IS NULL)
							BEGIN
								SET @RoleId = NEWID()
							
								INSERT INTO [dbo].[Role](
											[Id],
											[RoleName],                 
											[CompanyId],
											[IsDeveloper],
											[CreatedDateTime],
											[CreatedByUserId],
											[InActiveDateTime]
											)
									 SELECT @RoleId,
									 	    @Role,
									 	    @CompanyId,
									 	    0,
									 	    @Currentdate,
									 	    @OperationsPerformedBy,
									 	    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
							END
							
							INSERT INTO [dbo].[User](
							             [Id],
							             [CompanyId],
							             [FirstName],
							             [SurName],
							             [UserName],
							             [Password],
							             [IsActive],
							             [IsAdmin],
							             [MobileNo],
							             [ProfileImage],
							             [RegisteredDateTime],
							             [IsActiveOnMobile],
							             [InActiveDateTime],
							             [CreatedDateTime],
							             [CreatedByUserId],
										 [TimeZoneId],
										 [CurrencyId])
							      SELECT @UserId,
							             @CompanyId,
							             @FirstName,
							             @Surname,
							             @Email,
							             @Password,
							             @IsActive,
							             @IsAdmin,
							             @MobileNo,
							             @ProfileImage,
							             @Currentdate,
							             @IsActiveOnMobile,
							             CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							             @Currentdate,
							             @OperationsPerformedBy,
										 @TimeZoneId,
										 @CurrencyId
							
							 INSERT INTO UserRole
										(Id
										,UserId
										,RoleId
										,CreatedByUserId
										,CreatedDateTime)
								 SELECT NEWID()
								        ,@UserId
								 	    ,@RoleId
								 	    ,@OperationsPerformedBy
								 	    ,@Currentdate
							
						 END
						ELSE
						BEGIN
						
								UPDATE [User]
								  SET [CompanyId] = @CompanyId,
								      [FirstName] = @FirstName,
								      [SurName] = @SurName,
								      [UserName] = @Email,
								      [Password] = @Password,
								      [IsActive] = @IsActive,
								      [IsAdmin] = @IsAdmin,
								      [MobileNo] = @MobileNo,
								      [ProfileImage] = @ProfileImage,
								      [RegisteredDateTime] = @CurrentDate,
								      [IsActiveOnMobile] = @IsActiveOnMobile,
								      [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								      [UpdatedDateTime] = @Currentdate,
								      [UpdatedByUserId] = @OperationsPerformedBy,
									  [TimeZoneId] = @TimeZoneId,
									  [CurrencyId] = @CurrencyId
									  WHERE Id = @UserId
									  
								      DECLARE @RoleList TABLE
								      (
								         RoleId UNIQUEIDENTIFIER
								      )

									  IF(@ReferenceId IS NOT NULL)
									  BEGIN 
								
											INSERT INTO @RoleList(RoleId)
											SELECT Id FROM [Role]
											WHERE RoleName IN (
											SELECT Id FROM dbo.UfnSplit(@Role))
											AND CompanyId = @CompanyId

									  END
									  ELSE 
									  BEGIN 
											
											INSERT INTO @RoleList(RoleId)
											SELECT Id FROM dbo.UfnSplit(@Role)
								
									  END 
								
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
					           					  ,RoleId
					           					  ,@OperationsPerformedBy
					           					  ,@Currentdate
					           				 FROM @RoleList RL

						 END
						SELECT Id FROM [dbo].[User] WHERE Id = @UserId
							
						IF(@ReferenceId IS NOT NULL)
						BEGIN
								
							MERGE INTO [dbo].UserReference AS Target 
	                            USING (VALUES 
								(NEWID(),@UserId,@ReferenceId,@OperationsPerformedBy,@Currentdate)
								)
                               AS Source ([Id], [UserId], [ReferenceId], [CreatedByUserId], [CreatedDateTime])
	                           ON Target.[UserId] = Source.[UserId]  
	                           WHEN MATCHED THEN 
	                           UPDATE SET
							          [ReferenceId] = Source.[ReferenceId],
							          [UpdatedByUserId] = Source.[CreatedByUserId],
							          [UpdatedDateTime] = Source.[CreatedDateTime]
							   WHEN NOT MATCHED BY TARGET THEN 
	                           INSERT ([Id], [UserId], [ReferenceId], [CreatedByUserId], [CreatedDateTime]) 
							   VALUES ([Id], [UserId], [ReferenceId], [CreatedByUserId], [CreatedDateTime]);	
	
						END

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