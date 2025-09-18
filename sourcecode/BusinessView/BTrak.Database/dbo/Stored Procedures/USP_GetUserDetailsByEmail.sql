CREATE PROCEDURE [dbo].[USP_GetUserDetailsByEmail]
(
    @EmailId NVARCHAR(250) = NULL,
	@SiteAddress NVARCHAR(250) = NULL,
	@CanBypassSiteCheck BIT,
	@ResetGuid UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
       
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @UserId UNIQUEIDENTIFIER = NULL

		IF(@CanBypassSiteCheck <> 1)
		BEGIN
			DECLARE @CompanyId UNIQUEIDENTIFIER =(SELECT Id FROM Company WHERE SiteAddress = @SiteAddress)
			DECLARE @UsersCount INT = (SELECT COUNT(Id) FROM [User] WHERE UserName = @EmailId AND CompanyId = @CompanyId)
			IF(@UsersCount = 1)
			BEGIN
				SET @UserId = (SELECT Id FROM [User] WHERE UserName = @EmailId AND CompanyId = @CompanyId)
			END
		END
		ELSE
			SET @UserId = (SELECT TOP(1) Id FROM [User] WHERE   UserName = @EmailId ORDER BY CreatedDateTime DESC)
	
		IF(@UserId IS NOT NULL)
		BEGIN
			SELECT @ResetGuid AS ResetPasswordId,
					U.Id AS UserId,
					U.FirstName,
					U.SurName,
					U.FirstName +' '+ISNULL(U.SurName,'') AS FullName,
					U.UserName
				FROM [User] AS U
				WHERE U.Id = @UserId
		END
		ELSE
			RAISERROR(50014,11,1)

	END TRY
	BEGIN CATCH 
		
		THROW

	END CATCH
END
GO