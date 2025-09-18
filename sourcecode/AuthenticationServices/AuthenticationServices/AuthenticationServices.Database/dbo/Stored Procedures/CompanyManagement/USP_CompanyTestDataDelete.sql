CREATE PROCEDURE  [dbo].[USP_CompanyTestDataDelete]
(
 @CompanyId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	DECLARE @IsDemoDataCleared BIT = NULL

	SET @IsDemoDataCleared = (SELECT IsDemoDataCleared FROM Company WHERE Id = @CompanyId AND InActiveDateTime IS NULL)
	
	IF(@IsDemoDataCleared = 0)
	BEGIN
		UPDATE Company SET IsDemoDataCleared = 1 WHERE Id = @CompanyId AND InActiveDateTime IS NULL

		UPDATE Company SET IsDemoData = 0 WHERE Id = @CompanyId AND InActiveDateTime IS NULL

		SELECT @CompanyId
	END
END
GO