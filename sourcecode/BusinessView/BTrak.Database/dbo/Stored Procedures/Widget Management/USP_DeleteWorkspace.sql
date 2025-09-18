-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-06-03 00:00:00.000'
-- Purpose      To Delete Workspace
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM Workspace WHERE Id = '5648406C-19EF-4354-A38A-19FA68410B52')
--EXEC [dbo].[USP_DeleteWorkspace] @WorkspaceId='147A4B70-46EF-47D1-9490-48E74F69AC53'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_DeleteWorkspace]
(
   @WorkspaceId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	   SET @HavePermission = (SELECT CASE WHEN (SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId]((SELECT DeleteRoles FROM DashboardConfiguration WHERE DashboardId = @WorkspaceId),@OperationsPerformedBy)) > 0 AND @HavePermission = '1' THEN '1' ELSE '0' END)

       IF (@HavePermission = '1')
       BEGIN
           DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM Workspace WHERE Id = @WorkspaceId AND [InActiveDateTime] IS NULL) = @TimeStamp
                                         THEN 1 ELSE 0 END)

           IF(@IsLatest = 1)
           BEGIN
               DECLARE @CurrentDate DATETIME = GETDATE()
              
			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                   UPDATE Workspace
				      SET InActiveDateTime = @CurrentDate,
					      UpdatedDateTime = @CurrentDate,
						  UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @WorkspaceId 
				
               SELECT Id FROM [dbo].[Workspace] WHERE Id = @WorkspaceId
                
           END
           ELSE
               RAISERROR (50008,11, 1)
       END
       ELSE
           RAISERROR (@HavePermission,11, 1)

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO