--EXEC [dbo].[USP_ValidateAndUpsertGoogleUser] @FirstName = 'Test',@SurName = 'User',@Email = 'Test@gmail.com'
--,@Email = 'Test@gmail.com',@Password = 'Test123!',@ProfileImage = '',@SiteAddress = 'snovasys.snovasys.com',@UserDomain = 'gmail.com'
CREATE PROCEDURE [dbo].[USP_ValidateAndUpsertGoogleUser]
(
	@FirstName NVARCHAR(500)
	,@SurName NVARCHAR(500)
	,@Email NVARCHAR(100)
	,@Password NVARCHAR(200)
	,@ProfileImage NVARCHAR(200)
	,@SiteAddress NVARCHAR(200)
	,@UserDomain NVARCHAR(200)
	,@CanByPassUserCompanyValidation BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT Id FROM Company WHERE SiteAddress = @SiteAddress)
		
		DECLARE @ValidAddressStrings NVARCHAR(MAX) = (SELECT [Value] FROM CompanySettings WHERE [Key] = N'AcceptableGoogleDomains' AND CompanyId = @CompanyId)

		IF(EXISTS(SELECT [value] FROM [dbo].[Ufn_StringSplit](@ValidAddressStrings,',') WHERE [Value] = @UserDomain))
		BEGIN
			DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT [Value] FROM CompanySettings WHERE [Key] = N'DefaultGoogleUserRole' AND CompanyId = @CompanyId)

			IF(@RoleId IS NOT NULL)
			BEGIN
					
					DECLARE @OperationsPerformedBy UNIQUEIDENTIFIER = (SELECT CreatedByUserId FROM CompanySettings WHERE [Key] = N'DefaultGoogleUserRole' AND CompanyId = @CompanyId)

					DECLARE @UserId UNIQUEIDENTIFIER = NEWID()

					DECLARE @Currentdate DATETIME = GETDATE()

					INSERT INTO [dbo].[User](
										[Id],
										[CompanyId],
										[FirstName],
										[SurName],
										[UserName],
										[Password],
										[IsActive],
										[IsActiveOnMobile],
										[ProfileImage],
										[RegisteredDateTime],
										[CreatedDateTime],
										[CreatedByUserId])
								SELECT @UserId,
									   @CompanyId,
									   @FirstName,
									   @Surname,
									   @Email,
									   @Password,
									   1,
									   1,
									   @ProfileImage,
									   @Currentdate,
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
										,@RoleId
										,@OperationsPerformedBy
										,@Currentdate
					
					INSERT INTO UsefulFeatureAudit(Id,UsefulFeatureId,CreatedByUserId,CreatedDateTime)
					VALUES(NEWID(),(SELECT Id FROM UsefulFeature WHERE FeatureName = 'Number of time messages are pinned'),@OperationsPerformedBy,@Currentdate)

					SELECT @UserId AS UserId

			END

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO
