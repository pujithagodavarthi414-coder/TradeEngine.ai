--EXEC [dbo].[USP_InsertRecentSearch] @OperationsPerformedBy='80D61BE0-A923-40B6-ACE4-FF98CE74F0E1', @SearchText = 'Assets Dashboard'
CREATE PROCEDURE [dbo].[USP_InsertRecentSearch]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@SearchText nvarchar(max),
@SearchType int,
@ItemId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF (@HavePermission = '1')
            BEGIN
            DECLARE @Id UNIQUEIDENTIFIER = (SELECT NEWID())
            INSERT INTO [dbo].[RecentSearch] (Id,CreatedByUserId, SearchText, CreatedDateTime, SearchType, ItemId)  VALUES( @Id, @OperationsPerformedBy, @SearchText, GETUTCDATE(), @SearchType, @ItemId)
            SELECT @Id
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