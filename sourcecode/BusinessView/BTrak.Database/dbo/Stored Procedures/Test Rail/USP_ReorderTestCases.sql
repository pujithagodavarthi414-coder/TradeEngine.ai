-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-31 00:00:00.000'
-- Purpose      To Reorder the Test cases
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ReorderTestCases] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@TestCaseIds= '<GenericListOfGuid><ListItems><guid>7C7D0AFB-C5B0-458D-A468-0321F4619266</guid>
--<guid>B04FD967-924C-4A91-BD5F-032951FFB697</guid><guid>413C4070-3193-46EF-80CC-03348A3772DE</guid>
--</ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ReorderTestCases]
(
    @TestCaseIds XML,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
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
            TestCaseId UNIQUEIDENTIFIER
        )

        INSERT INTO #Temp
        (
            TestCaseId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS TestCaseId
        FROM @TestCaseIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)

        UPDATE TestCase
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM TestCase TC JOIN #Temp T ON T.TestCaseId = TC.Id

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END