-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-09-21 00:00:00.000'
-- Purpose      To change the order of work flow statuses
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ReOrderWorkflowStatuses] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryStatusIds = NULL
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ReOrderWorkflowStatuses]
(
    @UserStoryStatusIds XML =  NULL,
    @WorkflowId UNIQUEIDENTIFIER = NULL,
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
            UserStoryStatusId UNIQUEIDENTIFIER
        )
        INSERT INTO #Temp(UserStoryStatusId)
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
        FROM @UserStoryStatusIds.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

        UPDATE WorkflowStatus
        SET [OrderId] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM #Temp T  WHERE T.UserStoryStatusId = WorkflowStatus.UserStoryStatusId AND WorkflowId = @WorkflowId

      SELECT @WorkflowId AS  WorkflowId

	  END
    END TRY
    BEGIN CATCH

        THROW

    END CATCH

END