----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-24 00:00:00.000'
-- Purpose      To Add or Update Client Secondary Contacts by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClientSecondaryContact] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = '58771444-6F39-44BA-A8A8-F7465802BBE9', @Email = 'yahoo@snovasys.com', 
-- @FirstName = 'second', @LastName = 'first', @Password='1234566', @RoleId='860484F4-2E1F-4A0A-BD36-3509611EA6E3', @IsActive=1, @MobileNo='9989821523', @IsActiveOnMobile=1, 
-- @ClientSecondaryContactId = 'EF646931-60D8-404E-9398-5B3310063555', @TimeStamp = 0x00000000000807D1
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClientSecondaryContact]
(
   @ClientSecondaryContactId UNIQUEIDENTIFIER = NULL,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @ClientReferenceUserId UNIQUEIDENTIFIER = NULL,
   @CompanyId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @Note NVARCHAR(800) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @FirstName NVARCHAR(800) = NULL,
   @LastName NVARCHAR(800) = NULL,
   @MobileNo NVARCHAR(800) = NULL,
   @ProfileImage NVARCHAR(800) = NULL,
   @Email NVARCHAR(250) = NULL,
   @Password NVARCHAR(250) = NULL,
   --@RoleId UNIQUEIDENTIFIER = NULL,
   @IsPasswordForceReset BIT = NULL,
   @IsActive BIT = 1,
   @IsAdmin BIT = NULL,
   @IsActiveOnMobile BIT = 1,
   @RoleIds NVARCHAR(MAX)  = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @LoggedInCompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF (@HavePermission = '1')
        BEGIN

			IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL
		    
			IF(@FirstName = '') SET @FirstName = NULL

			IF(@LastName = '') SET @LastName = NULL

			IF(@Email = '') SET @Email = NULL

            IF (@UserId IS NULL) SET @UserId = (SELECT U.Id  FROM [User] U JOIN ClientSecondaryContact CLS ON CLS.ClientReferenceUserId = U.Id AND CLS.Id = @ClientSecondaryContactId)

	        IF(@ClientId IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'ClientId')
		  
		    END

			ELSE IF(@FirstName IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'FirstName')
		  
		    END
			ELSE IF(@LastName IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'LastName')
		  
		    END
			ELSE  IF(@Email IS NULL)     
		    BEGIN
		     
		        RAISERROR(50011,16, 2, 'Email')
		  
		    END

			--DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ClientSecondaryContactIdCount INT = (SELECT COUNT(1) FROM ClientSecondaryContact WHERE Id = @ClientSecondaryContactId) 

			DECLARE @ClientIdCount INT = (SELECT COUNT(1) FROM Client WHERE Id = @ClientId) 

			DECLARE @UserNameCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @Email AND (@UserId IS NULL OR Id <> @UserId) AND CompanyId = @LoggedInCompanyId)

			IF(@ClientSecondaryContactIdCount = 0 AND @ClientSecondaryContactId IS NOT NULL)
		    BEGIN
              
				RAISERROR(50002,16, 2,'ClientSecondaryContact')
          
		    END					 				           				        	  
		    ELSE IF(@ClientIdCount = 0 AND @ClientId IS NOT NULL)
		    BEGIN
              
				RAISERROR(50002,16, 2,'ClientId')
          
		   END
		   ELSE IF(@UserNameCount > 0)
           BEGIN

                RAISERROR(50010,16,1,'Client')

           END					 
		   ELSE                     
				
				DECLARE @IsLatest BIT = (CASE WHEN @ClientSecondaryContactId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM ClientSecondaryContact WHERE Id = @ClientSecondaryContactId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                IF(@IsLatest = 1)
                BEGIN									

                    DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @RoleId uniqueidentifier =(SELECT Id FROM Role WHERE RoleName = 'Client' AND CompanyId = @LoggedInCompanyId)

                    DECLARE @OldFirstName NVARCHAR(250) = (SELECT FirstName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldSurName NVARCHAR(250) = (SELECT SurName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldUserName NVARCHAR(250) = (SELECT UserName FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldMobileNo NVARCHAR(250) = (SELECT MobileNo FROM [User] U WHERE U.Id = @UserId)

                    DECLARE @OldProfileImage NVARCHAR(Max) = (SELECT ProfileImage FROM [User] U WHERE U.Id = @UserId)

					DECLARE @NewValue NVARCHAR (250)

					DECLARE @FieldName NVARCHAR (250)

					DECLARE @Description NVARCHAR (1000)

					IF(@ClientId IS NULL)
					BEGIN

						EXEC [USP_InsertClientHistory] @ClientId = @ClientId, @FieldName = 'Insert', @OperationsPerformedBy = @OperationsPerformedBy

					END
					ELSE
					BEGIN

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
                                      [MobileNo],
                                      [ProfileImage],
                                      [RegisteredDateTime],
                                      [IsActiveOnMobile],
									  [InActiveDateTime],                                 
                                      [CreatedDateTime],
                                      [CreatedByUserId]
									  )
                               SELECT @UserId,
                                      @LoggedInCompanyId,
                                      @FirstName,
                                      @LastName,
									  @Email,
                                      ISNULL(@Password,''),
                                      ISNULL(@IsActive,0),
                                      ISNULL(@IsAdmin,0),
                                      ISNULL(@MobileNo,''),
                                      ISNULL(@ProfileImage,''),
                                      ISNULL(@Currentdate,0),
                                      ISNULL(@IsActiveOnMobile,0),
                                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                      @Currentdate,
                                      @OperationsPerformedBy

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
						   SET [CompanyId] = @LoggedInCompanyId,
							   [FirstName] = @FirstName,
							   [SurName] = @LastName,
							   [UserName] = @Email,
							   [Password] = ISNULL(@Password,''),
							   [IsActive] = ISNULL(@IsActive,0),
							   [IsAdmin] = ISNULL(@IsAdmin,0),
							   [MobileNo] = ISNULL(@MobileNo,''),
							   [ProfileImage] = ISNULL(@ProfileImage,''),
							   [RegisteredDateTime] = ISNULL(@Currentdate,0), 	
						       [IsActiveOnMobile] = ISNULL(@IsActiveOnMobile,0),
							   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
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
						--SELECT Id FROM [dbo].[User] WHERE Id = @UserId	

				  IF(@ClientSecondaryContactId IS NULL)
					 BEGIN
					 SET @ClientSecondaryContactId = NEWID()	

				  INSERT INTO [dbo].[ClientSecondaryContact](
									[Id],
									[ClientId],
									[ClientReferenceUserId],
									[CreatedDateTime],
									[CreatedByUserId],    
									[InActiveDateTime]
									)
                             SELECT @ClientSecondaryContactId,
									@ClientId,
									@UserId,
									@Currentdate,
									@OperationsPerformedBy, 
									CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN
					UPDATE [ClientSecondaryContact]
					   SET [ClientId] = @ClientId,
                           [ClientReferenceUserId] = @UserId,
                           [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						   WHERE Id = @ClientSecondaryContactId
					END           

					SELECT Id  FROM [dbo].[ClientSecondaryContact] WHERE Id = @ClientSecondaryContactId

				END
				ELSE

					RAISERROR(50008,11,1)

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