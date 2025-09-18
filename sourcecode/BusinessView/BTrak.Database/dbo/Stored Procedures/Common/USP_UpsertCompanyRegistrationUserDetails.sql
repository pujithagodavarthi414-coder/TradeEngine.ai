CREATE  PROCEDURE [dbo].[USP_UpsertCompanyRegistrationUserDetails]
(
	@Name VARCHAR(100),
	@EmailAddress NVARCHAR(500),
	@SiteAddress NVARCHAR(500),
	@IsVerified BIT = NULL,
	@IsResend BIT = NULL,
	@Otp INT  = NULL,
    @VerificationCode INT  = NULL,
	@IsOtpVerify BIT = NULL
)
AS
BEGIN
	DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company WHERE [WorkEmail] = @EmailAddress AND @IsOtpVerify=0 AND @IsResend=0)
	SET @IsVerified = CASE WHEN @IsOtpVerify = 1 AND @Otp = (SELECT TOP 1 VerificationCode FROM CompanyRegistration  WHERE [Email] = @EmailAddress ORDER BY CreatedDateTime DESC)
						THEN 1 ELSE 0 END

	 IF(@IsVerified=0 AND @IsOtpVerify= 1)
	 BEGIN 
        RAISERROR('IncorrectOTP', 11, 1)
	 END
	 ELSE IF (@IsVerified=1)
	 BEGIN
	 SELECT TOP 1 CAST(Id AS NVARCHAR(50)) FROM CompanyRegistration  WHERE [Email] = @EmailAddress ORDER BY CreatedDateTime DESC
	 END
	 ELSE IF(@IsResend = 1)
	 BEGIN
		DECLARE @CompanyId uniqueidentifier = (SELECT TOP 1 Id FROM CompanyRegistration  WHERE [Email] = @EmailAddress ORDER BY CreatedDateTime DESC  )
		UPDATE CompanyRegistration SET VerificationCode = @VerificationCode WHERE Id = @CompanyId
		SELECT TOP 1 CAST(Id AS NVARCHAR(50))FROM CompanyRegistration WHERE Id = @CompanyId ORDER BY CreatedDateTime DESC

	 END
	 ELSE IF(@CompanyNameCount >0)
	 BEGIN
       SELECT top(1) CONCAT('siteaddress',' : ',siteaddress) FROM Company WHERE [WorkEmail] = @EmailAddress AND @IsOtpVerify=0 AND @IsResend=0 ORDER BY CreatedDateTime DESC
     END
     
	ELSE
	BEGIN
	   INSERT INTO CompanyRegistration([Id],[Name],[Email],[SiteAddress],[IsVerified],[CreatedDateTime],[VerificationCode] )
	   SELECT NEWID(),@Name,@EmailAddress,@SiteAddress,@IsVerified,GETDATE(),@VerificationCode

	   SELECT TOP 1 CAST(Id AS NVARCHAR(50))FROM CompanyRegistration ORDER BY CreatedDateTime DESC
	END
END
GO




