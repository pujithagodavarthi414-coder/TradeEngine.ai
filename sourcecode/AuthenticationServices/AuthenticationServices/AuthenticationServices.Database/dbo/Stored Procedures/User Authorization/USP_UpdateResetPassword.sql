CREATE PROCEDURE [dbo].[USP_UpdateResetPassword]
(
    @ResetId UNIQUEIDENTIFIER = NULL,
    @OTP INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		IF((GETDATE() > (SELECT ExpiredDateTime FROM ResetPassword WHERE ResetGuid = @ResetId)))
        BEGIN

            UPDATE ResetPassword SET IsExpired = 1 WHERE ResetGuid = @ResetId
            SELECT 1 AS IsExpired

        END
        ELSE IF(@OTP IS NOT NULL AND @OTP <> (SELECT OTP FROM ResetPassword WHERE ResetGuid = @ResetId))
        BEGIN
            RAISERROR(50027, 16, 1, 'InvalidOTP')
        END
        ELSE 
		BEGIN 
            SELECT IsExpired FROM ResetPassword WHERE ResetGuid = @ResetId AND (@OTP IS NULL OR OTP = @OTP)
		END

    END TRY  
	BEGIN CATCH 
		
		THROW

	END CATCH
END