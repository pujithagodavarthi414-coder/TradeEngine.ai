--EXEC [dbo].[EnsureUserCanHaveAccess] '4D5ADF0F-88DF-462C-A987-38AC05AEAB0C','HrDashboard/HrDashboardApi/GetEmployeePresence'

CREATE PROCEDURE [dbo].[EnsureUserCanHaveAccess]
(
   @roleId  AS UNIQUEIDENTIFIER = NULL,
   @rootPath AS VARCHAR(1000) = NULL      
)
AS
BEGIN

    DECLARE @output BIT
    DECLARE @AccessAll BIT
    
	SELECT @AccessAll = CASE WHEN EXISTS(SELECT  RA.AccessAll FROM [dbo].[ControllerApiName] RA
    WHERE RA.ActionPath = @rootPath AND RA.AccessAll = 1) THEN 1 ELSE 0 END
    
    IF(@AccessAll = 1)
    BEGIN

        SET @output = 1

    END
    ELSE
    BEGIN

       SELECT @output = CASE WHEN EXISTS(SELECT 1 
	                                     FROM [dbo].[ControllerApiName] CAN 
											 INNER JOIN [dbo].[ControllerApiFeature] CAF ON CAF.[ControllerApiNameId] = CAN.Id AND CAN.[ActionPath] = @rootPath
											 INNER JOIN [dbo].[Feature] F ON CAF.FeatureId = F.Id
											 INNER JOIN [dbo].[RoleFeature] RF ON RF.FeatureId = F.Id AND RF.RoleId = @roleId
			                         ) THEN 1 ELSE 0 END
										 
    END

    SELECT @output -- AS IsAccessible

END
GO