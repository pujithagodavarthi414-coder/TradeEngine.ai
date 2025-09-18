-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-31 00:00:00.000'
-- Purpose      To Reorder the Questions
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ReorderQuestions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@QuestionIds= '<GenericListOfGuid><ListItems><guid>7C7D0AFB-C5B0-458D-A468-0321F4619266</guid>
--<guid>B04FD967-924C-4A91-BD5F-032951FFB697</guid><guid>413C4070-3193-46EF-80CC-03348A3772DE</guid>
--</ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ReorderQuestions]
(
    @QuestionIds XML,
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
            QuestionId UNIQUEIDENTIFIER
        )

        INSERT INTO #Temp
        (
            QuestionId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS QuestionId
        FROM @QuestionIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)

        UPDATE AuditQuestions
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM AuditQuestions AQ JOIN #Temp T ON T.QuestionId = AQ.Id

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END
GO
