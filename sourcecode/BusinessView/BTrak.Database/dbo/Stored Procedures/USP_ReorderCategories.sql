CREATE PROCEDURE [dbo].[USP_ReorderCategories]
(
    @CategoryIds XML,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsAuditElseConduct BIT = NULL,
	@ParentCategoryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @Currentdate DATETIME = GETDATE()

        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            CategoryId UNIQUEIDENTIFIER
        )

        INSERT INTO #Temp
        (
            CategoryId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS CategoryId
        FROM @CategoryIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)
		IF(@IsAuditElseConduct = 1) 
		BEGIN
        UPDATE AuditCategory
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM AuditCategory AC JOIN #Temp T ON T.CategoryId = AC.Id
		END
		ELSE
		BEGIN
		UPDATE AuditConductSelectedCategory
		SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM AuditConductSelectedCategory AC JOIN #Temp T ON T.CategoryId = AC.Id
		END

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END
GO
