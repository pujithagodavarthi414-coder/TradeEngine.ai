-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Employees for organization chart
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetEmployeesForOrgChart] @OperationsPerformedBy = ''
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeesForOrgChart]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
			
			SELECT T.ChildId AS EmployeeId,
				   CASE WHEN PU.IsActive = 1 THEN PU.Id ELSE NULL END AS ParentId,
				   E.Id AS SelectedEmployeeId,
				   CU.ProfileImage AS Img,
				   CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS [Name],
				   (SELECT STUFF((SELECT ',' + R.RoleName
									   FROM [UserRole] UR 
									   JOIN [Role] R ON R.Id = UR.RoleId
									   WHERE UR.UserId = CU.Id AND UR.InactiveDateTime IS NULL FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) AS Designation
				  FROM (
						SELECT ChildId,ParentId FROM [Ufn_GetEmployeeReportedMembers](null,@CompanyId)) T
						JOIN [User] CU ON CU.Id = T.ChildId AND CU.InActiveDateTime IS NULL
						JOIN [Employee] E ON E.UserId = T.ChildId
						LEFT JOIN Employee PE ON PE.Id = T.ParentId
						LEFT JOIN [User] PU ON PU.[Id] = PE.UserId AND PU.InActiveDateTime IS NULL
					WHERE CU.IsActive = 1 
         END
         ELSE
         BEGIN
         
                 RAISERROR (@HavePermission,11, 1)
                 
         END
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO
