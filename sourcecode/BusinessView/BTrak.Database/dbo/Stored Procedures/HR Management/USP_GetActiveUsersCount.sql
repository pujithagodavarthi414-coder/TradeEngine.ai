CREATE PROCEDURE [dbo].[USP_GetActiveUsersCount]
(
	@SiteAddress NVARCHAR(MAX),
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

		DECLARE @CompanyId UNIQUEIDENTIFIER
		
		IF(@OperationsPerformedBy IS NULL)
		BEGIN
				SET @CompanyId =(SELECT Id FROM Company WHERE @SiteAddress =  SiteAddress)
		END
		
		ELSE
			BEGIN
				 SET @CompanyId =(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			END

		SELECT COUNT(*) AS [Count] FROM [User] U WHERE U.CompanyId=@CompanyId AND InActiveDateTime IS NULL AND IsActive=1

	END TRY
    BEGIN CATCH

		THROW

	END CATCH
END