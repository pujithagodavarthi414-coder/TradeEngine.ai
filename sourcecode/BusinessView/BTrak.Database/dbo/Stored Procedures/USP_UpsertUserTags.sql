CREATE PROCEDURE [dbo].[USP_UpsertUserTags]
(
    @TagIds XML,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @Currentdate DATETIMEOFFSET = SYSDATETIMEOFFSET()

        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            TagId UNIQUEIDENTIFIER,
        )

        INSERT INTO #Temp
        (
            TagId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS TagId
        FROM @TagIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)

        DELETE FROM [UserTags] WHERE UserId = @OperationsPerformedBy 

        INSERT INTO [dbo].[UserTags]
        (
            [Id],
            [UserId],
            [TagId],
			[Order],
            CreatedDateTime,
            CreatedByUserId
        )
        SELECT NEWID(),
			   @OperationsPerformedBy,
               TagId,
			   [Order],
               SYSDATETIMEOFFSET(),
               @OperationsPerformedBy
        FROM #Temp

        SELECT T.Id
        FROM Tags T
            INNER JOIN #Temp Temp
                ON T.Id = Temp.TagId

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END