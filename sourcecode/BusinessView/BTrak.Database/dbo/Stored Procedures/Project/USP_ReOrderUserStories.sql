-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To Display the UserStories We will give order 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ReOrderUserStories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@UserStoryIds= '<GenericListOfGuid><ListItems><guid>7C7D0AFB-C5B0-458D-A468-0321F4619266</guid>
--<guid>B04FD967-924C-4A91-BD5F-032951FFB697</guid><guid>413C4070-3193-46EF-80CC-03348A3772DE</guid>
--</ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ReOrderUserStories]
(
    @UserStoryIds XML,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @CompanyId UNIQUEIDENTIFIER = (
                                                  SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                                              )

        DECLARE @Currentdate DATETIMEOFFSET = SYSDATETIMEOFFSET()

        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            UserStoryId UNIQUEIDENTIFIER,
            OldOrder INT
        )

        INSERT INTO #Temp
        (
            UserStoryId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS UserStoryId
        FROM @UserStoryIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)

        UPDATE #Temp
        SET OldOrder = US.[Order]
        FROM UserStory US
            JOIN #Temp T
                ON US.Id = T.UserStoryId

        UPDATE UserStory
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM UserStory US
            JOIN #Temp T
                ON T.UserStoryId = US.Id

        INSERT INTO [dbo].[UserStoryHistory]
        (
            [Id],
            [UserStoryId],
            [OldValue],
            [NewValue],
            [FieldName],
            [Description],
            CreatedDateTime,
            CreatedByUserId
        )
        SELECT NEWID(),
               UserStoryId,
               CONVERT(NVARCHAR, OldOrder),
               CONVERT(NVARCHAR, [Order]),
               'Order',
               'OrderChanged',
               SYSDATETIMEOFFSET(),
               @OperationsPerformedBy
        FROM #Temp

        SELECT US.Id
        FROM UserStory US
            INNER JOIN #Temp T
                ON US.Id = T.UserStoryId

    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END