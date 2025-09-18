CREATE PROCEDURE [dbo].[USP_UpsertModuleTabs]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @ModuleId UNIQUEIDENTIFIER = NULL,
  @TabId UNIQUEIDENTIFIER = NULL,
  @TabName NVARCHAR(100) = NULL,
  @IsUpsert BIT = 0
)
AS
BEGIN
    IF(@IsUpsert = 1)
    BEGIN
		DECLARE @RecordExits UNIQUEIDENTIFIER = (SELECT T.Id FROM Tab T Where T.ModuleId = @ModuleId AND T.[Name] = @TabName)
		IF(@RecordExits IS NULL)
		BEGIN
		    INSERT INTO Tab (Id,[Name],ModuleId,CreatedDateTime,CreatedByUserId) VALUES 
		    (NEWID(),@TabName,@ModuleId,GETDATE(),@OperationsPerformedBy)
        END
	END
	ELSE
	BEGIN
	    SELECT Id,[Name],ModuleId FROM Tab WHERE Tab.ModuleId = @ModuleId
	END
END