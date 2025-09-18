CREATE PROCEDURE [dbo].[USP_UpsertEmailVerifyDetails]
(
	@RegistorId uniqueidentifier,
	@IsVerified BIT = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	
	IF(@RegistorId IS NOT NULL)
		BEGIN
				UPDATE CompanyRegistration SET IsVerified=1 WHERE Id = @RegistorId
				SELECT 1
		END

		ELSE
		SELECT 0

	END TRY
	BEGIN CATCH
		
		SELECT 0

	END CATCH
END
GO


