-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-15 00:00:00.000'
-- Purpose      To Get ResetPassword Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetResetPasswordDetails]@EmailId='snovasys@slack.com'

CREATE PROCEDURE [dbo].[USP_GetResetPasswordDetails]
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
			--ELSE
			--SET @UserId = (SELECT Id FROM [User] WHERE   UserName = @EmailId AND CompanyId = @CompanyId)
		END
		ELSE
			SET @UserId = (SELECT TOP(1) Id FROM [User] WHERE   UserName = @EmailId ORDER BY CreatedDateTime DESC)
		DECLARE @CurrentDate DATETIME = GETDATE()

		IF(@UserId IS NOT NULL)
		BEGIN
			
			IF(@ResetGuid IS NULL)
			BEGIN
				SET @ResetGuid = NEWID()
			END

			INSERT INTO [dbo].[ResetPassword](
						[Id],
						[UserId],
						[ResetGuid],
						[IsExpired],
						[CreatedDateTime],
						[ExpiredDateTime])
				 SELECT @ResetGuid,
						@UserId,
						NEWID(),
						0,
						@CurrentDate,
						CAST(CONVERT(NVARCHAR(10), @CurrentDate, 110) + ' 23:59:59' AS DATETIME)
			
			SELECT RP.Id AS ResetPasswordId,
				   RP.[UserId],
				   U.FirstName,
				   U.SurName,
				   U.FirstName +' '+ISNULL(U.SurName,'') AS FullName,
				   U.UserName, 
				   RP.[ResetGuid],
				   RP.[IsExpired],
				   RP.[CreatedDateTime],
				   RP.[ExpiredDateTime]

		   FROM ResetPassword RP WITH (NOLOCK) INNER JOIN [User] U WITH (NOLOCK) ON U.Id = RP.UserId
		   WHERE RP.CreatedDateTime = @CurrentDate AND RP.UserId = @UserId 

		END
		ELSE
			
			RAISERROR(50014,11,1)

       END TRY  
	   BEGIN CATCH 
		
		   THROW

	  END CATCH
END
GO