-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-18 00:00:00.000'
-- Purpose      To Delete Dashboard
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM Workspace WHERE Id = '66C6DEC6-050D-4337-8CE2-0AB375A2AD45')
--EXEC [dbo].[USP_DeleteWorkspace] @WorkspaceId='66C6DEC6-050D-4337-8CE2-0AB375A2AD45'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'


CREATE PROCEDURE [dbo].[USP_DeleteDashboard]
(
    @DashboardId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

       		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
           
		   DECLARE @IsLatest BIT = (CASE WHEN (  SELECT [TimeStamp] FROM Dashboard WHERE Id = ( SELECT Id FROM Dashboard WHERE Id = @DashboardId ) AND [InActiveDateTime] IS NULL ) = @TimeStamp THEN 1 ELSE 0 END )

            IF (@IsLatest = 1)
            BEGIN
                
				UPDATE [dbo].Dashboard
                SET [InActiveDateTime] = GETDATE()
                WHERE Id = @DashboardId

                SELECT Id
                FROM [dbo].[Dashboard]
                WHERE Id = @DashboardId

            END
            ELSE
                RAISERROR('This recored is already Deleted please refresh the page for new changes.', 11, 1)
        END
        ELSE
            RAISERROR(@HavePermission, 11, 1)
    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO