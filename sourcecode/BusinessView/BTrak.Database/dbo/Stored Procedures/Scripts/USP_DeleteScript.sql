CREATE PROCEDURE [dbo].[USP_DeleteScript](
@ScriptId UNIQUEIDENTIFIER = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 IF (@HavePermission = '1')
     BEGIN
		DECLARE @ScriptName NVARCHAR(250)  = (SELECT [Name] From [dbo].[Scripts] WHERE Id = @ScriptId)
		DECLARE @isLatest BIT = (SELECT IsLatest From [dbo].[Scripts] WHERE Id = @ScriptId)

		IF(@isLatest = 0)
		BEGIN
			DELETE FROM [Scripts] WHERE Id = @ScriptId
		END
		ELSE
		BEGIN
			UPDATE dbo.[Scripts] SET IsLatest = 1 where Id = 
			(SELECT TOP(1)Id FROM dbo.[Scripts] WHERE [Name] = @ScriptName AND IsLatest = 0 ORDER BY [CreatedDateTime] DESC)

			DELETE FROM [Scripts] WHERE Id = @ScriptId
		END
     END
     ELSE
     BEGIN
       RAISERROR (@HavePermission,11, 1)
     END
END TRY
    BEGIN CATCH
        THROW
    END CATCH
END

GO