-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Get Line mangers list 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetLineManagers_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_GetLineManagers_New]
(
    @OPerationsPerformedBy UNIQUEIDENTIFIER,
    @SearchText NVARCHAR(100) = NULL,
    @IsReportToOnly BIT = NULL
)
AS
BEGIN
DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OPerationsPerformedBy))
	
    IF(@SearchText = '') SET @SearchText = NULL
    
    IF(@IsReportToOnly IS NULL) SET @IsReportToOnly = 0

    SET @SearchText = '%'+  RTRIM(LTRIM(@SearchText)) +'%'
    
    SELECT E.Id EmployeeId
          ,U.Id UserId
          ,U.FirstName +' '+ ISNULL(U.SurName,'') UserName
          ,U.ProfileImage
    FROM EmployeeReportTo ERT WITH (NOLOCK)
        INNER JOIN Employee E WITH (NOLOCK) ON E.Id = ERT.ReportToEmployeeId AND ERT.InactiveDateTime IS NULL
		           AND ERT.InactiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	    INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	               AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	               --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
        INNER JOIN Job J ON J.EmployeeId = E.Id AND J.DepartmentId IS NOT NULL AND J.DesignationId IS NOT NULL AND J.JoinedDate <= GETDATE() AND J.InActiveDateTime IS NULL
        INNER JOIN [User] U WITH (NOLOCK) ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
        --INNER JOIN UserActiveDetails UAD ON UAD.UserId = U.Id AND UAD.AsAtInactiveDateTime IS NULL AND UAD.InActiveDateTime IS NULL
    WHERE J.ActiveTo IS NULL AND U.IsActive = 1
          AND U.CompanyId = @CompanyId
          AND ((@IsReportToOnly = 1 AND (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OPerationsPerformedBy,@CompanyId))))
               OR
               (@IsReportToOnly = 0 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)))
              )
          AND (@SearchText IS NULL OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText))
    GROUP BY E.Id,U.Id,U.FirstName,U.SurName,U.ProfileImage
    ORDER BY (U.FirstName +' '+ ISNULL(U.SurName,''))
END
END
GO