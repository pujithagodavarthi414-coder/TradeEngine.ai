CREATE PROCEDURE [dbo].[USP_ReOrderClientTypes]
(
    @clientTypeIdsXml XML =  NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 
	    IF (@HavePermission = '1')
	    BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @Currentdate DATETIMEOFFSET = SYSDATETIMEOFFSET()

        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            ClientTypeId UNIQUEIDENTIFIER
        )
        INSERT INTO #Temp(ClientTypeId)
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
        FROM @clientTypeIdsXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

        UPDATE ClientType
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM #Temp T  WHERE T.ClientTypeId = ClientType.Id


	  END
    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END