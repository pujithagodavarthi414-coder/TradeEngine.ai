----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-02-05 00:00:00.000'
-- Purpose      To Update Dashboard Name
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpdateDashboardName] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@DashboardId = '256D773B-ABCD-4315-A7EF-C4A30F0AE093',@DashboardName=''
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateDashboardName]
(
  @DashboardId UNIQUEIDENTIFIER = NULL,
  @DashboardName NVARCHAR(600) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
        IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL
        
        IF(@DashboardId IS NULL)
        BEGIN
                         
            RAISERROR(50011,16, 2, 'DashboardId')
          
        END
		ELSE IF(@DashboardId IS NULL)
        BEGIN     
                         
             RAISERROR(50011,16, 2, 'DashboardName')
          
        END
        ELSE
        BEGIN
            DECLARE @DashboardIdCount INT = (SELECT COUNT(1) FROM [WorkspaceDashboards] WHERE Id = @DashboardId AND InActiveDateTime IS NULL)
            
            IF(@DashboardIdCount = 0 AND @DashboardId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'DashboardId')
            
            END
            ELSE
            BEGIN
                DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
                IF (@HavePermission = '1')
                BEGIN
                
                    DECLARE @Currentdate DATETIME = GETDATE()
                       
                    UPDATE [dbo].[WorkspaceDashboards] SET  [DashboardName] = @DashboardName,
															[UpdatedDateTime]  = @Currentdate,
															[UpdatedByUserId]  = @OperationsPerformedBy 
													   WHERE Id = @DashboardId
                     
                    SELECT Id FROM [dbo].[WorkspaceDashboards] where Id = @DashboardId

                END
                ELSE
            
                    RAISERROR (@HavePermission,11, 1)
            END
        END
    END TRY  
    BEGIN CATCH 
        
           THROW
    END CATCH
END
GO