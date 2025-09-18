CREATE PROCEDURE [dbo].[USP_UpsertScript](
@ScriptId UNIQUEIDENTIFIER = NULL,
@Name NVARCHAR(250) = NULL,
@Version NVARCHAR(250) = NULL,
@Description NVARCHAR(2000) = NULL,
@ScriptUrl NVARCHAR(MAX) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	 DECLARE @ScriptAlreadyExists INT = (SELECT COUNT(1) FROM dbo.[Scripts] WHERE [Name] = @Name)
	 IF (@HavePermission = '1')
     BEGIN
		IF(@ScriptId IS NULL)
		BEGIN
			IF(@ScriptAlreadyExists > 0)
			BEGIN
				UPDATE [dbo].[Scripts] SET IsLatest = 0 WHERE [Name] = @Name
			END
			SET @ScriptId = NEWID()
			INSERT INTO [dbo].[Scripts]
			([Id]
			,[CompanyId]
			,[Name]
			,[Version]
			,[Description]
			,[Url]
			,[IsLatest]
			,[CreatedDateTime]
			,[CreatedByUserId])
			VALUES
			(@ScriptId
			,@CompanyId
			,@Name
			,@Version
			,@Description
			,@ScriptUrl
			,1
			,GETUTCDATE()
			,@OperationsPerformedBy)
		END
        SELECT Id FROM [dbo].[Scripts] WHERE Id = @ScriptId
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
