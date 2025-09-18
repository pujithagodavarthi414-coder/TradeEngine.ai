CREATE PROCEDURE [dbo].[USP_GetResetPasswordDetails]
(
    @EmailId NVARCHAR(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
       
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @UserId UNIQUEIDENTIFIER = NULL
		
		SET @UserId = (SELECT TOP(1) Id FROM [User] WHERE UserName = @EmailId AND IsActive = 1 ORDER BY CreatedDateTime DESC)

		DECLARE @CurrentDate DATETIME = GETDATE()

		IF(@UserId IS NOT NULL)
		BEGIN

			INSERT INTO [dbo].[ResetPassword](
						[Id],
						[UserId],
						[ResetGuid],
						[OTP],
						[IsExpired],
						[CreatedDateTime],
						[ExpiredDateTime])
				 SELECT NEWID(),
						@UserId,
						NEWID(),
						LEFT(CAST(RAND()*1000000000+999999 AS int),6),
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
				   RP.[OTP],
				   RP.[IsExpired],
				   RP.[CreatedDateTime],
				   RP.[ExpiredDateTime]

		   FROM ResetPassword RP WITH (NOLOCK) INNER JOIN [User] U WITH (NOLOCK) ON U.Id = RP.UserId
		   WHERE RP.CreatedDateTime = @CurrentDate AND RP.UserId = @UserId 

		END
		ELSE
		BEGIN
			RAISERROR(50004, 16, 1)
		END

	END TRY
	BEGIN CATCH 
		THROW
	END CATCH
END
