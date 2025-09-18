-------------------------------------------------------------------------------
-- Author       Surya Kadiyam
-- Created      '2020-08-13 00:00:00.000'
-- Purpose      To save dashboard order
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertDashboardsCustomOrder]
(
    @DashboardIdXml XML,
	@WorkspaceId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @Currentdate DATETIMEOFFSET = SYSDATETIMEOFFSET()
		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            DashboardId UNIQUEIDENTIFIER,
        )

        INSERT INTO #Temp
        (
            DashboardId
        )
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS TagId
        FROM @DashboardIdXml.nodes('GenericListOfGuid/ListItems/guid') AS x(y)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN

        DELETE FROM [DashboardCustomViewOrder] WHERE UserId = @OperationsPerformedBy AND CompanyId = @CompanyId AND WorkspaceId = @WorkspaceId 

        INSERT INTO [dbo].[DashboardCustomViewOrder]
        (
            [Id],
			[WorkspaceId],
			[DashboardId],
            [UserId],
            [CompanyId],
			[Order],
            [CreatedDateTime],
            [CreatedByUserId]
        )
        SELECT NEWID(),
			   @WorkspaceId,
               DashboardId,
			   @OperationsPerformedBy,
			   @CompanyId,
			   [Order],
               @Currentdate,
               @OperationsPerformedBy
        FROM #Temp

		END
		ELSE
		BEGIN
			RAISERROR(@HavePermission,11,1)
		END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH

END